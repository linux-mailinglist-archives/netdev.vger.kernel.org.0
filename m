Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5927AA7E9
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 18:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390790AbfIEQEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 12:04:12 -0400
Received: from correo.us.es ([193.147.175.20]:53058 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390792AbfIEQEK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 12:04:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9E70F1228C5
        for <netdev@vger.kernel.org>; Thu,  5 Sep 2019 18:04:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 92573A7D53
        for <netdev@vger.kernel.org>; Thu,  5 Sep 2019 18:04:06 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 87946D1DBB; Thu,  5 Sep 2019 18:04:06 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5EC6EB7FF2;
        Thu,  5 Sep 2019 18:04:04 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 05 Sep 2019 18:04:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2F00742EE38E;
        Thu,  5 Sep 2019 18:04:04 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/8] netfilter: nfnetlink_log: add support for VLAN information
Date:   Thu,  5 Sep 2019 18:03:55 +0200
Message-Id: <20190905160400.25399-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190905160400.25399-1-pablo@netfilter.org>
References: <20190905160400.25399-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Braun <michael-dev@fami-braun.de>

Currently, there is no vlan information (e.g. when used with a vlan aware
bridge) passed to userspache, HWHEADER will contain an 08 00 (ip) suffix
even for tagged ip packets.

Therefore, add an extra netlink attribute that passes the vlan information
to userspace similarly to 15824ab29f for nfqueue.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nfnetlink_log.h | 11 ++++++
 net/netfilter/nfnetlink_log.c                | 57 ++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/include/uapi/linux/netfilter/nfnetlink_log.h b/include/uapi/linux/netfilter/nfnetlink_log.h
index 20983cb195a0..45c8d3b027e0 100644
--- a/include/uapi/linux/netfilter/nfnetlink_log.h
+++ b/include/uapi/linux/netfilter/nfnetlink_log.h
@@ -33,6 +33,15 @@ struct nfulnl_msg_packet_timestamp {
 	__aligned_be64	usec;
 };
 
+enum nfulnl_vlan_attr {
+	NFULA_VLAN_UNSPEC,
+	NFULA_VLAN_PROTO,		/* __be16 skb vlan_proto */
+	NFULA_VLAN_TCI,			/* __be16 skb htons(vlan_tci) */
+	__NFULA_VLAN_MAX,
+};
+
+#define NFULA_VLAN_MAX (__NFULA_VLAN_MAX + 1)
+
 enum nfulnl_attr_type {
 	NFULA_UNSPEC,
 	NFULA_PACKET_HDR,
@@ -54,6 +63,8 @@ enum nfulnl_attr_type {
 	NFULA_HWLEN,			/* hardware header length */
 	NFULA_CT,                       /* nf_conntrack_netlink.h */
 	NFULA_CT_INFO,                  /* enum ip_conntrack_info */
+	NFULA_VLAN,			/* nested attribute: packet vlan info */
+	NFULA_L2HDR,			/* full L2 header */
 
 	__NFULA_MAX
 };
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index d69e1863e536..0ba020ca38e6 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -385,6 +385,57 @@ nfulnl_timer(struct timer_list *t)
 	instance_put(inst);
 }
 
+static u32 nfulnl_get_bridge_size(const struct sk_buff *skb)
+{
+	u32 size = 0;
+
+	if (!skb_mac_header_was_set(skb))
+		return 0;
+
+	if (skb_vlan_tag_present(skb)) {
+		size += nla_total_size(0); /* nested */
+		size += nla_total_size(sizeof(u16)); /* id */
+		size += nla_total_size(sizeof(u16)); /* tag */
+	}
+
+	if (skb->network_header > skb->mac_header)
+		size += nla_total_size(skb->network_header - skb->mac_header);
+
+	return size;
+}
+
+static int nfulnl_put_bridge(struct nfulnl_instance *inst, const struct sk_buff *skb)
+{
+	if (!skb_mac_header_was_set(skb))
+		return 0;
+
+	if (skb_vlan_tag_present(skb)) {
+		struct nlattr *nest;
+
+		nest = nla_nest_start(inst->skb, NFULA_VLAN);
+		if (!nest)
+			goto nla_put_failure;
+
+		if (nla_put_be16(inst->skb, NFULA_VLAN_TCI, htons(skb->vlan_tci)) ||
+		    nla_put_be16(inst->skb, NFULA_VLAN_PROTO, skb->vlan_proto))
+			goto nla_put_failure;
+
+		nla_nest_end(inst->skb, nest);
+	}
+
+	if (skb->mac_header < skb->network_header) {
+		int len = (int)(skb->network_header - skb->mac_header);
+
+		if (nla_put(inst->skb, NFULA_L2HDR, len, skb_mac_header(skb)))
+			goto nla_put_failure;
+	}
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
 /* This is an inline function, we don't really care about a long
  * list of arguments */
 static inline int
@@ -580,6 +631,10 @@ __build_packet_message(struct nfnl_log_net *log,
 				 NFULA_CT, NFULA_CT_INFO) < 0)
 		goto nla_put_failure;
 
+	if ((pf == NFPROTO_NETDEV || pf == NFPROTO_BRIDGE) &&
+	    nfulnl_put_bridge(inst, skb) < 0)
+		goto nla_put_failure;
+
 	if (data_len) {
 		struct nlattr *nla;
 		int size = nla_attr_size(data_len);
@@ -687,6 +742,8 @@ nfulnl_log_packet(struct net *net,
 				size += nfnl_ct->build_size(ct);
 		}
 	}
+	if (pf == NFPROTO_NETDEV || pf == NFPROTO_BRIDGE)
+		size += nfulnl_get_bridge_size(skb);
 
 	qthreshold = inst->qthreshold;
 	/* per-rule qthreshold overrides per-instance */
-- 
2.11.0

