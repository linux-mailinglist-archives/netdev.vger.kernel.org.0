Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE93A2D0B2
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 22:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbfE1Uuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 16:50:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60612 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726683AbfE1Uuu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 16:50:50 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A47775D672;
        Tue, 28 May 2019 20:50:44 +0000 (UTC)
Received: from new-host.redhat.com (ovpn-116-124.ams2.redhat.com [10.36.116.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED9345F5BB;
        Tue, 28 May 2019 20:50:39 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     shuali@redhat.com, Eli Britstein <elibr@mellanox.com>
Subject: [PATCH net] net/sched: act_pedit: fix 'ex munge' on network header in case of QinQ packet
Date:   Tue, 28 May 2019 22:50:33 +0200
Message-Id: <753b96cc340e4fbae6640da070aac09d7220efe2.1559075758.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Tue, 28 May 2019 20:50:49 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like it has been done in commit 2ecba2d1e45b ("net: sched: act_csum: Fix
csum calc for tagged packets"), also 'pedit' needs to adjust the network
offset when multiple tags are present in the packets: otherwise wrong IP
headers (but good checksums) can be observed with the following command:

 # tc filter add dev test0 parent ffff: protocol 802.1Q flower \
   vlan_ethtype ipv4 action \
   pedit ex munge ip ttl set 10 pipe \
   csum ip and icmp pipe \
   mirred egress redirect dev test1

Reported-by: Li Shuang <shuali@redhat.com>
Fixes: d8b9605d2697 ("net: sched: fix skb->protocol use in case of accelerated vlan path")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/act_pedit.c | 38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index d790c02b9c6c..25dcf9ee092e 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -277,9 +277,12 @@ static bool offset_valid(struct sk_buff *skb, int offset)
 }
 
 static int pedit_skb_hdr_offset(struct sk_buff *skb,
-				enum pedit_header_type htype, int *hoffset)
+				enum pedit_header_type htype, int *hoffset,
+				unsigned int *vlan_hdr_count)
 {
+	bool orig_vlan_tag_present = false;
 	int ret = -EINVAL;
+	__be16 protocol;
 
 	switch (htype) {
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_ETH:
@@ -291,8 +294,29 @@ static int pedit_skb_hdr_offset(struct sk_buff *skb,
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK:
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_IP4:
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_IP6:
-		*hoffset = skb_network_offset(skb);
-		ret = 0;
+		protocol = tc_skb_protocol(skb);
+again:
+		switch (protocol) {
+		case cpu_to_be16(ETH_P_8021AD): /* fall through */
+		case cpu_to_be16(ETH_P_8021Q):
+			if (skb_vlan_tag_present(skb) &&
+			    !orig_vlan_tag_present) {
+				protocol = skb->protocol;
+				orig_vlan_tag_present = true;
+			} else {
+				struct vlan_hdr *vlan;
+
+				vlan = (struct vlan_hdr *)skb->data;
+				protocol = vlan->h_vlan_encapsulated_proto;
+				skb_pull(skb, VLAN_HLEN);
+				skb_reset_network_header(skb);
+				(*vlan_hdr_count)++;
+			}
+			goto again;
+		default:
+			*hoffset = skb_network_offset(skb);
+			ret = 0;
+		}
 		break;
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_TCP:
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_UDP:
@@ -313,6 +337,7 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
 			 struct tcf_result *res)
 {
 	struct tcf_pedit *p = to_pedit(a);
+	unsigned int vlan_hdr_count = 0;
 	int i;
 
 	if (skb_unclone(skb, GFP_ATOMIC))
@@ -343,7 +368,8 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
 				tkey_ex++;
 			}
 
-			rc = pedit_skb_hdr_offset(skb, htype, &hoffset);
+			rc = pedit_skb_hdr_offset(skb, htype, &hoffset,
+						  &vlan_hdr_count);
 			if (rc) {
 				pr_info("tc action pedit bad header type specified (0x%x)\n",
 					htype);
@@ -407,6 +433,10 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
 bad:
 	p->tcf_qstats.overlimits++;
 done:
+	while (vlan_hdr_count--) {
+		skb_push(skb, VLAN_HLEN);
+		skb_reset_network_header(skb);
+	}
 	bstats_update(&p->tcf_bstats, skb);
 	spin_unlock(&p->tcf_lock);
 	return p->tcf_action;
-- 
2.20.1

