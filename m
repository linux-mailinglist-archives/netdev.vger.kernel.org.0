Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C882B50029
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 05:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfFXDTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 23:19:41 -0400
Received: from mail5.windriver.com ([192.103.53.11]:41682 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbfFXDTl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jun 2019 23:19:41 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id x5O3HmLU005347
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Sun, 23 Jun 2019 20:18:03 -0700
Received: from pek-lpg-core2.corp.ad.wrs.com (128.224.153.41) by
 ALA-HCA.corp.ad.wrs.com (147.11.189.40) with Microsoft SMTP Server id
 14.3.439.0; Sun, 23 Jun 2019 20:17:41 -0700
From:   <zhe.he@windriver.com>
To:     <pablo@netfilter.org>, <kadlec@blackhole.kfki.hu>, <fw@strlen.de>,
        <davem@davemloft.net>, <netfilter-devel@vger.kernel.org>,
        <coreteam@netfilter.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <zhe.he@windriver.com>
Subject: [PATCH] netfilter: Fix remainder of pseudo-header protocol 0
Date:   Mon, 24 Jun 2019 11:17:38 +0800
Message-ID: <1561346258-272481-1-git-send-email-zhe.he@windriver.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: He Zhe <zhe.he@windriver.com>

Since v5.1-rc1, some types of packets do not get unreachable reply with the
following iptables setting. Fox example,

$ iptables -A INPUT -p icmp --icmp-type 8 -j REJECT
$ ping 127.0.0.1 -c 1
PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
— 127.0.0.1 ping statistics —
1 packets transmitted, 0 received, 100% packet loss, time 0ms

We should have got the following reply from command line, but we did not.
From 127.0.0.1 icmp_seq=1 Destination Port Unreachable

Yi Zhao reported it and narrowed it down to:
7fc38225363d ("netfilter: reject: skip csum verification for protocols that don't support it"),

This is because nf_ip_checksum still expects pseudo-header protocol type 0 for
packets that are of neither TCP or UDP, and thus ICMP packets are mistakenly
treated as TCP/UDP.

This patch corrects the conditions in nf_ip_checksum and all other places that
still call it with protocol 0.

Fixes: 7fc38225363d ("netfilter: reject: skip csum verification for protocols that don't support it")
Reported-by: Yi Zhao <yi.zhao@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
 net/netfilter/nf_conntrack_proto_icmp.c | 2 +-
 net/netfilter/nf_nat_proto.c            | 2 +-
 net/netfilter/utils.c                   | 5 +++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index a824367..dd53e2b 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -218,7 +218,7 @@ int nf_conntrack_icmpv4_error(struct nf_conn *tmpl,
 	/* See ip_conntrack_proto_tcp.c */
 	if (state->net->ct.sysctl_checksum &&
 	    state->hook == NF_INET_PRE_ROUTING &&
-	    nf_ip_checksum(skb, state->hook, dataoff, 0)) {
+	    nf_ip_checksum(skb, state->hook, dataoff, IPPROTO_ICMP)) {
 		icmp_error_log(skb, state, "bad hw icmp checksum");
 		return -NF_ACCEPT;
 	}
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 07da077..83a24cc 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -564,7 +564,7 @@ int nf_nat_icmp_reply_translation(struct sk_buff *skb,
 
 	if (!skb_make_writable(skb, hdrlen + sizeof(*inside)))
 		return 0;
-	if (nf_ip_checksum(skb, hooknum, hdrlen, 0))
+	if (nf_ip_checksum(skb, hooknum, hdrlen, IPPROTO_ICMP))
 		return 0;
 
 	inside = (void *)skb->data + hdrlen;
diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 06dc555..51b454d 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -17,7 +17,8 @@ __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 	case CHECKSUM_COMPLETE:
 		if (hook != NF_INET_PRE_ROUTING && hook != NF_INET_LOCAL_IN)
 			break;
-		if ((protocol == 0 && !csum_fold(skb->csum)) ||
+		if ((protocol != IPPROTO_TCP && protocol != IPPROTO_UDP &&
+		    !csum_fold(skb->csum)) ||
 		    !csum_tcpudp_magic(iph->saddr, iph->daddr,
 				       skb->len - dataoff, protocol,
 				       skb->csum)) {
@@ -26,7 +27,7 @@ __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 		}
 		/* fall through */
 	case CHECKSUM_NONE:
-		if (protocol == 0)
+		if (protocol != IPPROTO_TCP && protocol != IPPROTO_UDP)
 			skb->csum = 0;
 		else
 			skb->csum = csum_tcpudp_nofold(iph->saddr, iph->daddr,
-- 
2.7.4

