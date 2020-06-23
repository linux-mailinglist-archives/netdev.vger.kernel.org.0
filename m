Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D30205747
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 18:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732312AbgFWQdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 12:33:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729481AbgFWQdX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 12:33:23 -0400
Received: from localhost.localdomain.com (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 978C620706;
        Tue, 23 Jun 2020 16:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592930003;
        bh=51+deXi69W8Xj8tDoAhPBkAhoor4ImkX0EdggXv8xA4=;
        h=From:To:Cc:Subject:Date:From;
        b=hjl4yVLbfUm+/msq07EYtr686eU12h8XEFmtTvhHggL2hWg8GZfdg4L87g3VSwkx5
         iJdeekwCUqHlDcA5z+EHi+pSV3uSPTpr+TZ3gHSEFZoGdjxNzmeppT+QrnAquBKh1W
         hKoI6CG7JDn6CtqdOPz023obDOB4mmsrk4NHaqsY=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, pshelar@ovn.org, nusiddiq@redhat.com,
        gvrose8192@gmail.com, lorenzo.bianconi@redhat.com,
        dev@openvswitch.org
Subject: [PATCH v2 net] openvswitch: take into account de-fragmentation/gso_size in execute_check_pkt_len
Date:   Tue, 23 Jun 2020 18:33:15 +0200
Message-Id: <fd266728e5de48e1b4bd82d08e345f308f77eb5a.1592929525.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ovs connection tracking module performs de-fragmentation on incoming
fragmented traffic. Take info account if traffic has been de-fragmented
in execute_check_pkt_len action otherwise we will perform the wrong
nested action considering the original packet size. This issue typically
occurs if ovs-vswitchd adds a rule in the pipeline that requires connection
tracking (e.g. OVN stateful ACLs) before execute_check_pkt_len action.
Moreover take into account GSO fragment size for GSO packet in
execute_check_pkt_len routine

Fixes: 4d5ec89fc8d14 ("net: openvswitch: Add a new action check_pkt_len")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v1:
- take into account gso_size for gso packets
- take into account L2 header for de-fragmented traffic
---
 net/openvswitch/actions.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index fc0efd8833c8..2611657f40ca 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -1169,9 +1169,10 @@ static int execute_check_pkt_len(struct datapath *dp, struct sk_buff *skb,
 				 struct sw_flow_key *key,
 				 const struct nlattr *attr, bool last)
 {
+	struct ovs_skb_cb *ovs_cb = OVS_CB(skb);
 	const struct nlattr *actions, *cpl_arg;
+	int len, max_len, rem = nla_len(attr);
 	const struct check_pkt_len_arg *arg;
-	int rem = nla_len(attr);
 	bool clone_flow_key;
 
 	/* The first netlink attribute in 'attr' is always
@@ -1180,7 +1181,11 @@ static int execute_check_pkt_len(struct datapath *dp, struct sk_buff *skb,
 	cpl_arg = nla_data(attr);
 	arg = nla_data(cpl_arg);
 
-	if (skb->len <= arg->pkt_len) {
+	len = ovs_cb->mru ? ovs_cb->mru + skb->mac_len : skb->len;
+	max_len = arg->pkt_len;
+
+	if ((skb_is_gso(skb) && skb_gso_validate_mac_len(skb, max_len)) ||
+	    len <= max_len) {
 		/* Second netlink attribute in 'attr' is always
 		 * 'OVS_CHECK_PKT_LEN_ATTR_ACTIONS_IF_LESS_EQUAL'.
 		 */
-- 
2.26.2

