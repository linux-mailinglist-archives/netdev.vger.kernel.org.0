Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6C613B260
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 11:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389098AbfFJJoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 05:44:10 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:51318 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387977AbfFJJoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 05:44:10 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id C439C5C17DE;
        Mon, 10 Jun 2019 17:44:06 +0800 (CST)
From:   wenxu@ucloud.cn
To:     roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com
Cc:     bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH net-next] bridge: Set the pvid for untaged packet before prerouting
Date:   Mon, 10 Jun 2019 17:44:06 +0800
Message-Id: <1560159846-29933-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kIGBQJHllBWUlVSUNDS0tLSktNQ0pKTklZV1koWUFJQjdXWS1ZQUlXWQ
        kOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6ORA6CRw6Qjg#Oh4sNDMCURIv
        HBEaFC1VSlVKTk1LSk5CQ09NQkNOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpCT0I3Bg++
X-HM-Tid: 0a6b40c601e72087kuqyc439c5c17de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

bridge vlan add dev veth1 vid 200 pvid untagged
bridge vlan add dev veth2 vid 200 pvid untagged

nft add table bridge firewall
nft add chain bridge firewall zones { type filter hook prerouting priority - 300 \; }
nft add rule bridge firewall zones counter ct zone set vlan id map { 100 : 1, 200 : 2 }

As above set the bridge port with pvid, the received packet don't contain
the vlan tag which means the packet should belong to vlan 200 through pvid.
User can do conntrack base base on vlan id and map the vlan id to zone id
in the prerouting hook.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/bridge/br_input.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 21b74e7..31b44bc 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -341,6 +341,13 @@ rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 	}
 
 forward:
+	if (br_opt_get(p->br, BROPT_VLAN_ENABLED) && !skb_vlan_tag_present(skb)) {
+		u16 pvid = br_get_pvid(nbp_vlan_group_rcu(p));
+
+		if (pvid)
+			__vlan_hwaccel_put_tag(skb, p->br->vlan_proto, pvid);
+	}
+
 	switch (p->state) {
 	case BR_STATE_FORWARDING:
 	case BR_STATE_LEARNING:
-- 
1.8.3.1

