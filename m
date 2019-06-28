Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E96D5A2A0
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbfF1Rlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:41:40 -0400
Received: from mail.us.es ([193.147.175.20]:52772 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726964AbfF1Rlj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 13:41:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D87701B2B73
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 19:41:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C6ACFDA4CA
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 19:41:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BB68BDA732; Fri, 28 Jun 2019 19:41:37 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 38543DA704;
        Fri, 28 Jun 2019 19:41:34 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 28 Jun 2019 19:41:34 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.195.66])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DF5F44265A32;
        Fri, 28 Jun 2019 19:41:33 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4/4] netfilter: Fix remainder of pseudo-header protocol 0
Date:   Fri, 28 Jun 2019 19:41:25 +0200
Message-Id: <20190628174125.20739-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190628174125.20739-1-pablo@netfilter.org>
References: <20190628174125.20739-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_icmp.c | 2 +-
 net/netfilter/nf_nat_proto.c            | 2 +-
 net/netfilter/utils.c                   | 5 +++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index 9becac953587..71a84a0517f3 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -221,7 +221,7 @@ int nf_conntrack_icmpv4_error(struct nf_conn *tmpl,
 	/* See ip_conntrack_proto_tcp.c */
 	if (state->net->ct.sysctl_checksum &&
 	    state->hook == NF_INET_PRE_ROUTING &&
-	    nf_ip_checksum(skb, state->hook, dataoff, 0)) {
+	    nf_ip_checksum(skb, state->hook, dataoff, IPPROTO_ICMP)) {
 		icmp_error_log(skb, state, "bad hw icmp checksum");
 		return -NF_ACCEPT;
 	}
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 84f5c90a7f21..9f3e52ebd3b8 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -567,7 +567,7 @@ int nf_nat_icmp_reply_translation(struct sk_buff *skb,
 
 	if (!skb_make_writable(skb, hdrlen + sizeof(*inside)))
 		return 0;
-	if (nf_ip_checksum(skb, hooknum, hdrlen, 0))
+	if (nf_ip_checksum(skb, hooknum, hdrlen, IPPROTO_ICMP))
 		return 0;
 
 	inside = (void *)skb->data + hdrlen;
diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 06dc55590441..51b454d8fa9c 100644
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
2.11.0


