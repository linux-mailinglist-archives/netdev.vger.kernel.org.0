Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E24AA152540
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 04:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgBED0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 22:26:09 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:37732 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727714AbgBED0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 22:26:09 -0500
Received: by mail-pj1-f73.google.com with SMTP id dw15so518447pjb.2
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 19:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=el2SlWEkVuLqILjGRz3ZOB2gYqnJbJJUEYG+kluaeJg=;
        b=QAdBxW0BKvrMDUA3fOyVE2eWVUfiCx3kz/l8XzDH44mgvcor585J0iZYwLqMFS+SGD
         urWUsoKSJfYVIPhY3E3Bb0qu1A5tCrPmvaXCQYp+wY7qRyBFlVjFLyHgaFSWBFBExY/X
         nxZlexNmK9kEEjcgfrFb7RkLGXdgLj85qG4YejfXicZR7ObkmhlUtQH5EGHF78ke+QK1
         csdSrytY5JAntsTewLpIOraEDsWSgw75wR4bkVdUqN5Xdrm1MDkYYlta+8aDrFt3RBdP
         mNAZQPSWy9NCnSXNAiosdcq72teYe+NF1uOWsXyXSoNg+lzo0OKeZoT0z6DxIap4xA/E
         4Mfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=el2SlWEkVuLqILjGRz3ZOB2gYqnJbJJUEYG+kluaeJg=;
        b=kc5CFdKxJMny9oSFzNQ3vL/5OqwlrgF+ZANaekGArv8c0s7CUt8kKydaDWCCujgENq
         P/835Od+OW6u006UBh79/HlC8wgE6TpjIkzVDSCHA7o/sSdjUj8rCxzk9+LdzZOj0IcG
         KvdoFyE2F02+0ypRMLRswDVcoNBafogHwxVSrCbiTDsVBKNfplQcnYUBjGqhlHXNK7sH
         +9skXf6PGMvgwBV+zWkKVI81TjtoRw8RUa5Ke1iBZd8F850MdfU/XIT1SfrvULjUksGH
         u38A3wDVYEA/pp/bX2PWRQApdxojlD1jSrmFhp0CXIr32j+r5UYfsfNms+2PfhKRGnvE
         8OBg==
X-Gm-Message-State: APjAAAW1TfXuKpFNzebOdKZ7ZLbOcAOoQCpyfgb/e/yKoEcwE88sQFWI
        w4icqgBBTFistlEfc2zcEzvEXbV5hMmTog==
X-Google-Smtp-Source: APXvYqzqBTnPMnbWuKyWC/GYXzpixdxHfVLapqUwzkWpS8m//eGEyp4dRriV/2SNkqrzqwqBjXE9tOtdcFBqXQ==
X-Received: by 2002:a63:520a:: with SMTP id g10mr31937830pgb.298.1580873168665;
 Tue, 04 Feb 2020 19:26:08 -0800 (PST)
Date:   Tue,  4 Feb 2020 19:26:05 -0800
Message-Id: <20200205032605.242866-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH net] bonding/alb: properly access headers in bond_alb_xmit()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot managed to send an IPX packet through bond_alb_xmit()
and af_packet and triggered a use-after-free.

First, bond_alb_xmit() was using ipx_hdr() helper to reach
the IPX header, but ipx_hdr() was using the transport offset
instead of the network offset. In the particular syzbot
report transport offset was 0xFFFF

This patch removes ipx_hdr() since it was only (mis)used from bonding.

Then we need to make sure IPv4/IPv6/IPX headers are pulled
in skb->head before dereferencing anything.

BUG: KASAN: use-after-free in bond_alb_xmit+0x153a/0x1590 drivers/net/bonding/bond_alb.c:1452
Read of size 2 at addr ffff8801ce56dfff by task syz-executor.2/18108
 (if (ipx_hdr(skb)->ipx_checksum != IPX_NO_CHECKSUM) ...)

Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 [<ffffffff8441fc42>] __dump_stack lib/dump_stack.c:17 [inline]
 [<ffffffff8441fc42>] dump_stack+0x14d/0x20b lib/dump_stack.c:53
 [<ffffffff81a7dec4>] print_address_description+0x6f/0x20b mm/kasan/report.c:282
 [<ffffffff81a7e0ec>] kasan_report_error mm/kasan/report.c:380 [inline]
 [<ffffffff81a7e0ec>] kasan_report mm/kasan/report.c:438 [inline]
 [<ffffffff81a7e0ec>] kasan_report.cold+0x8c/0x2a0 mm/kasan/report.c:422
 [<ffffffff81a7dc4f>] __asan_report_load_n_noabort+0xf/0x20 mm/kasan/report.c:469
 [<ffffffff82c8c00a>] bond_alb_xmit+0x153a/0x1590 drivers/net/bonding/bond_alb.c:1452
 [<ffffffff82c60c74>] __bond_start_xmit drivers/net/bonding/bond_main.c:4199 [inline]
 [<ffffffff82c60c74>] bond_start_xmit+0x4f4/0x1570 drivers/net/bonding/bond_main.c:4224
 [<ffffffff83baa558>] __netdev_start_xmit include/linux/netdevice.h:4525 [inline]
 [<ffffffff83baa558>] netdev_start_xmit include/linux/netdevice.h:4539 [inline]
 [<ffffffff83baa558>] xmit_one net/core/dev.c:3611 [inline]
 [<ffffffff83baa558>] dev_hard_start_xmit+0x168/0x910 net/core/dev.c:3627
 [<ffffffff83bacf35>] __dev_queue_xmit+0x1f55/0x33b0 net/core/dev.c:4238
 [<ffffffff83bae3a8>] dev_queue_xmit+0x18/0x20 net/core/dev.c:4278
 [<ffffffff84339189>] packet_snd net/packet/af_packet.c:3226 [inline]
 [<ffffffff84339189>] packet_sendmsg+0x4919/0x70b0 net/packet/af_packet.c:3252
 [<ffffffff83b1ac0c>] sock_sendmsg_nosec net/socket.c:673 [inline]
 [<ffffffff83b1ac0c>] sock_sendmsg+0x12c/0x160 net/socket.c:684
 [<ffffffff83b1f5a2>] __sys_sendto+0x262/0x380 net/socket.c:1996
 [<ffffffff83b1f700>] SYSC_sendto net/socket.c:2008 [inline]
 [<ffffffff83b1f700>] SyS_sendto+0x40/0x60 net/socket.c:2004

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
---
 drivers/net/bonding/bond_alb.c | 44 ++++++++++++++++++++++++----------
 include/net/ipx.h              |  5 ----
 2 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 4f2e6910c6232618ab536c83cdc83ba1a398b041..1cc2cd894f877c0f6d9117ce008b7ef3fdfbcbcc 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1383,26 +1383,31 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
 	bool do_tx_balance = true;
 	u32 hash_index = 0;
 	const u8 *hash_start = NULL;
-	struct ipv6hdr *ip6hdr;
 
 	skb_reset_mac_header(skb);
 	eth_data = eth_hdr(skb);
 
 	switch (ntohs(skb->protocol)) {
 	case ETH_P_IP: {
-		const struct iphdr *iph = ip_hdr(skb);
+		const struct iphdr *iph;
 
 		if (is_broadcast_ether_addr(eth_data->h_dest) ||
-		    iph->daddr == ip_bcast ||
-		    iph->protocol == IPPROTO_IGMP) {
+		    !pskb_network_may_pull(skb, sizeof(*iph))) {
+			do_tx_balance = false;
+			break;
+		}
+		iph = ip_hdr(skb);
+		if (iph->daddr == ip_bcast || iph->protocol == IPPROTO_IGMP) {
 			do_tx_balance = false;
 			break;
 		}
 		hash_start = (char *)&(iph->daddr);
 		hash_size = sizeof(iph->daddr);
-	}
 		break;
-	case ETH_P_IPV6:
+	}
+	case ETH_P_IPV6: {
+		const struct ipv6hdr *ip6hdr;
+
 		/* IPv6 doesn't really use broadcast mac address, but leave
 		 * that here just in case.
 		 */
@@ -1419,7 +1424,11 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
 			break;
 		}
 
-		/* Additianally, DAD probes should not be tx-balanced as that
+		if (!pskb_network_may_pull(skb, sizeof(*ip6hdr))) {
+			do_tx_balance = false;
+			break;
+		}
+		/* Additionally, DAD probes should not be tx-balanced as that
 		 * will lead to false positives for duplicate addresses and
 		 * prevent address configuration from working.
 		 */
@@ -1429,17 +1438,26 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
 			break;
 		}
 
-		hash_start = (char *)&(ipv6_hdr(skb)->daddr);
-		hash_size = sizeof(ipv6_hdr(skb)->daddr);
+		hash_start = (char *)&ip6hdr->daddr;
+		hash_size = sizeof(ip6hdr->daddr);
 		break;
-	case ETH_P_IPX:
-		if (ipx_hdr(skb)->ipx_checksum != IPX_NO_CHECKSUM) {
+	}
+	case ETH_P_IPX: {
+		const struct ipxhdr *ipxhdr;
+
+		if (pskb_network_may_pull(skb, sizeof(*ipxhdr))) {
+			do_tx_balance = false;
+			break;
+		}
+		ipxhdr = (struct ipxhdr *)skb_network_header(skb);
+
+		if (ipxhdr->ipx_checksum != IPX_NO_CHECKSUM) {
 			/* something is wrong with this packet */
 			do_tx_balance = false;
 			break;
 		}
 
-		if (ipx_hdr(skb)->ipx_type != IPX_TYPE_NCP) {
+		if (ipxhdr->ipx_type != IPX_TYPE_NCP) {
 			/* The only protocol worth balancing in
 			 * this family since it has an "ARP" like
 			 * mechanism
@@ -1448,9 +1466,11 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
 			break;
 		}
 
+		eth_data = eth_hdr(skb);
 		hash_start = (char *)eth_data->h_dest;
 		hash_size = ETH_ALEN;
 		break;
+	}
 	case ETH_P_ARP:
 		do_tx_balance = false;
 		if (bond_info->rlb_enabled)
diff --git a/include/net/ipx.h b/include/net/ipx.h
index baf0903909984de0a2ee823f72e3cd673da42961..9d1342807b597058c268cf84ac57eac77798bf37 100644
--- a/include/net/ipx.h
+++ b/include/net/ipx.h
@@ -47,11 +47,6 @@ struct ipxhdr {
 /* From af_ipx.c */
 extern int sysctl_ipx_pprop_broadcasting;
 
-static __inline__ struct ipxhdr *ipx_hdr(struct sk_buff *skb)
-{
-	return (struct ipxhdr *)skb_transport_header(skb);
-}
-
 struct ipx_interface {
 	/* IPX address */
 	__be32			if_netnum;
-- 
2.25.0.341.g760bfbb309-goog

