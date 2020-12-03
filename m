Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFAA2CE193
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 23:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387551AbgLCW11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 17:27:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:53454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726931AbgLCW11 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 17:27:27 -0500
From:   Arnd Bergmann <arnd@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        YueHaibing <yuehaibing@huawei.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH] ch_ktls: fix build warning for ipv4-only config
Date:   Thu,  3 Dec 2020 23:26:16 +0100
Message-Id: <20201203222641.964234-1-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When CONFIG_IPV6 is disabled, clang complains that a variable
is uninitialized for non-IPv4 data:

drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c:1046:6: error: variable 'cntrl1' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
        if (tx_info->ip_family == AF_INET) {
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c:1059:2: note: uninitialized use occurs here
        cntrl1 |= T6_TXPKT_ETHHDR_LEN_V(maclen - ETH_HLEN) |
        ^~~~~~

Replace the preprocessor conditional with the corresponding C version,
and make the ipv4 case unconditional in this configuration to improve
readability and avoid the warning.

Fixes: 86716b51d14f ("ch_ktls: Update cheksum information")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 .../net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c  | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 7f90b828d159..1b7e8c91b541 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -987,9 +987,7 @@ chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
 	struct fw_eth_tx_pkt_wr *wr;
 	struct cpl_tx_pkt_core *cpl;
 	u32 ctrl, iplen, maclen;
-#if IS_ENABLED(CONFIG_IPV6)
 	struct ipv6hdr *ip6;
-#endif
 	unsigned int ndesc;
 	struct tcphdr *tcp;
 	int len16, pktlen;
@@ -1043,17 +1041,15 @@ chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
 	cpl->len = htons(pktlen);
 
 	memcpy(buf, skb->data, pktlen);
-	if (tx_info->ip_family == AF_INET) {
+	if (!IS_ENABLED(CONFIG_IPV6) || tx_info->ip_family == AF_INET) {
 		/* we need to correct ip header len */
 		ip = (struct iphdr *)(buf + maclen);
 		ip->tot_len = htons(pktlen - maclen);
 		cntrl1 = TXPKT_CSUM_TYPE_V(TX_CSUM_TCPIP);
-#if IS_ENABLED(CONFIG_IPV6)
 	} else {
 		ip6 = (struct ipv6hdr *)(buf + maclen);
 		ip6->payload_len = htons(pktlen - maclen - iplen);
 		cntrl1 = TXPKT_CSUM_TYPE_V(TX_CSUM_TCPIP6);
-#endif
 	}
 
 	cntrl1 |= T6_TXPKT_ETHHDR_LEN_V(maclen - ETH_HLEN) |
-- 
2.27.0

