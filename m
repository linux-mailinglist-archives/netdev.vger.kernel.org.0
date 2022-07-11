Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499D456FEA0
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 12:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbiGKKO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 06:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234763AbiGKKOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 06:14:05 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9232B7AC0C;
        Mon, 11 Jul 2022 02:34:16 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 2/3] netfilter: nf_log: incorrect offset to network header
Date:   Mon, 11 Jul 2022 11:33:56 +0200
Message-Id: <20220711093357.107260-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220711093357.107260-1-pablo@netfilter.org>
References: <20220711093357.107260-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NFPROTO_ARP is expecting to find the ARP header at the network offset.

In the particular case of ARP, HTYPE= field shows the initial bytes of
the ethernet header destination MAC address.

 netdev out: IN= OUT=bridge0 MACSRC=c2:76:e5:71:e1:de MACDST=36:b0:4a:e2:72:ea MACPROTO=0806 ARP HTYPE=14000 PTYPE=0x4ae2 OPCODE=49782

NFPROTO_NETDEV egress hook is also expecting to find the IP headers at
the network offset.

Fixes: 35b9395104d5 ("netfilter: add generic ARP packet logger")
Reported-by: Tom Yan <tom.ty89@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_log_syslog.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 77bcb10fc586..cb894f0d63e9 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -67,7 +67,7 @@ dump_arp_packet(struct nf_log_buf *m,
 	unsigned int logflags;
 	struct arphdr _arph;
 
-	ah = skb_header_pointer(skb, 0, sizeof(_arph), &_arph);
+	ah = skb_header_pointer(skb, nhoff, sizeof(_arph), &_arph);
 	if (!ah) {
 		nf_log_buf_add(m, "TRUNCATED");
 		return;
@@ -96,7 +96,7 @@ dump_arp_packet(struct nf_log_buf *m,
 	    ah->ar_pln != sizeof(__be32))
 		return;
 
-	ap = skb_header_pointer(skb, sizeof(_arph), sizeof(_arpp), &_arpp);
+	ap = skb_header_pointer(skb, nhoff + sizeof(_arph), sizeof(_arpp), &_arpp);
 	if (!ap) {
 		nf_log_buf_add(m, " INCOMPLETE [%zu bytes]",
 			       skb->len - sizeof(_arph));
@@ -149,7 +149,7 @@ static void nf_log_arp_packet(struct net *net, u_int8_t pf,
 
 	nf_log_dump_packet_common(m, pf, hooknum, skb, in, out, loginfo,
 				  prefix);
-	dump_arp_packet(m, loginfo, skb, 0);
+	dump_arp_packet(m, loginfo, skb, skb_network_offset(skb));
 
 	nf_log_buf_close(m);
 }
@@ -850,7 +850,7 @@ static void nf_log_ip_packet(struct net *net, u_int8_t pf,
 	if (in)
 		dump_mac_header(m, loginfo, skb);
 
-	dump_ipv4_packet(net, m, loginfo, skb, 0);
+	dump_ipv4_packet(net, m, loginfo, skb, skb_network_offset(skb));
 
 	nf_log_buf_close(m);
 }
-- 
2.30.2

