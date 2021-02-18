Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03DC31EA99
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 14:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbhBRNxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 08:53:17 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:45906 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230331AbhBRMcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 07:32:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1613651466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UAKdpUdwYw7+x8cEPUp9unac8+0+nhsUh1t818FgRug=;
        b=AWGpuPIuyyKXAdFcPIhHZOE+b4Tpgy/6NguRDuapJ+9WgWK7QN5bgZCb6nt/rxiQyutvb8
        1ECzYNNzohe+iyhWinUizgEB3gSyo05l9XGK32ZQ5D4lGcv0k036jKt8jD+wXwhaiTWNfv
        kkmY2yGGx+EICYvQgDhqNVeol+nQa7E=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 49209baf (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 18 Feb 2021 12:31:06 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, SinYu <liuxyon@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] net: icmp: zero-out cb in icmp{,v6}_ndo_send before sending
Date:   Thu, 18 Feb 2021 13:30:53 +0100
Message-Id: <20210218123053.2239986-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The icmp{,v6}_send functions make all sorts of use of skb->cb, assuming
the skb to have come directly from the inet layer. But when the packet
comes from the ndo layer, especially when forwarded, there's no telling
what might be in skb->cb at that point. So, icmp{,v6}_ndo_send must zero
out its skb->cb before passing the packet off to icmp{,v6}_send.
Otherwise the icmp sending code risks reading bogus memory contents,
which can result in nasty stack overflows such as this one reported by a
user:

    panic+0x108/0x2ea
    __stack_chk_fail+0x14/0x20
    __icmp_send+0x5bd/0x5c0
    icmp_ndo_send+0x148/0x160

This is easy to simulate by doing a `memset(skb->cb, 0x41,
sizeof(skb->cb));` before calling icmp{,v6}_ndo_send, and it's only by
good fortune and the rarity of icmp sending from that context that we've
avoided reports like this until now. For example, in KASAN:

    BUG: KASAN: stack-out-of-bounds in __ip_options_echo+0xa0e/0x12b0
    Write of size 38 at addr ffff888006f1f80e by task ping/89
    CPU: 2 PID: 89 Comm: ping Not tainted 5.10.0-rc7-debug+ #5
    Call Trace:
     dump_stack+0x9a/0xcc
     print_address_description.constprop.0+0x1a/0x160
     __kasan_report.cold+0x20/0x38
     kasan_report+0x32/0x40
     check_memory_region+0x145/0x1a0
     memcpy+0x39/0x60
     __ip_options_echo+0xa0e/0x12b0
     __icmp_send+0x744/0x1700

Actually, out of the 4 drivers that do this, only gtp zeroed the cb for
the v4 case, while the rest did not. So this commit actually removes the
gtp-specific zeroing, while putting the code where it belongs in the
shared infrastructure of icmp{,v6}_ndo_send.

Fixes: a2b78e9b2cac ("sunvnet: generate ICMP PTMUD messages for smaller port MTUs")
Reported-by: SinYu <liuxyon@gmail.com>
Cc: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/netdev/CAF=yD-LOF116aHub6RMe8vB8ZpnrrnoTdqhobEx+bvoA8AsP0w@mail.gmail.com/T/
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/gtp.c      | 1 -
 include/linux/icmpv6.h | 6 +++++-
 include/net/icmp.h     | 6 +++++-
 net/ipv4/icmp.c        | 2 ++
 net/ipv6/ip6_icmp.c    | 2 ++
 5 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 4c04e271f184..fd3c2d86e48b 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -539,7 +539,6 @@ static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
 	if (!skb_is_gso(skb) && (iph->frag_off & htons(IP_DF)) &&
 	    mtu < ntohs(iph->tot_len)) {
 		netdev_dbg(dev, "packet too big, fragmentation needed\n");
-		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 		icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 			      htonl(mtu));
 		goto err_rt;
diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
index 1b3371ae8193..87d434fc98a3 100644
--- a/include/linux/icmpv6.h
+++ b/include/linux/icmpv6.h
@@ -45,7 +45,11 @@ int ip6_err_gen_icmpv6_unreach(struct sk_buff *skb, int nhs, int type,
 #if IS_ENABLED(CONFIG_NF_NAT)
 void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info);
 #else
-#define icmpv6_ndo_send icmpv6_send
+static inline void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
+{
+	memset(skb_in->cb, 0, sizeof(skb_in->cb));
+	icmpv6_send(skb_in, type, code, info);
+}
 #endif
 
 #else
diff --git a/include/net/icmp.h b/include/net/icmp.h
index 9ac2d2672a93..4bb404c9abc8 100644
--- a/include/net/icmp.h
+++ b/include/net/icmp.h
@@ -46,7 +46,11 @@ static inline void icmp_send(struct sk_buff *skb_in, int type, int code, __be32
 #if IS_ENABLED(CONFIG_NF_NAT)
 void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info);
 #else
-#define icmp_ndo_send icmp_send
+static inline void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
+{
+	memset(skb_in->cb, 0, sizeof(skb_in->cb));
+	icmp_send(skb_in, type, code, info);
+}
 #endif
 
 int icmp_rcv(struct sk_buff *skb);
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 396b492c804f..ecf080532291 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -781,6 +781,7 @@ void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
 
 	ct = nf_ct_get(skb_in, &ctinfo);
 	if (!ct || !(ct->status & IPS_SRC_NAT)) {
+		memset(skb_in->cb, 0, sizeof(skb_in->cb));
 		icmp_send(skb_in, type, code, info);
 		return;
 	}
@@ -796,6 +797,7 @@ void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
 
 	orig_ip = ip_hdr(skb_in)->saddr;
 	ip_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.ip;
+	memset(skb_in->cb, 0, sizeof(skb_in->cb));
 	icmp_send(skb_in, type, code, info);
 	ip_hdr(skb_in)->saddr = orig_ip;
 out:
diff --git a/net/ipv6/ip6_icmp.c b/net/ipv6/ip6_icmp.c
index 70c8c2f36c98..ddc28be8a65d 100644
--- a/net/ipv6/ip6_icmp.c
+++ b/net/ipv6/ip6_icmp.c
@@ -57,6 +57,7 @@ void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
 
 	ct = nf_ct_get(skb_in, &ctinfo);
 	if (!ct || !(ct->status & IPS_SRC_NAT)) {
+		memset(skb_in->cb, 0, sizeof(skb_in->cb));
 		icmpv6_send(skb_in, type, code, info);
 		return;
 	}
@@ -72,6 +73,7 @@ void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
 
 	orig_ip = ipv6_hdr(skb_in)->saddr;
 	ipv6_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.in6;
+	memset(skb_in->cb, 0, sizeof(skb_in->cb));
 	icmpv6_send(skb_in, type, code, info);
 	ipv6_hdr(skb_in)->saddr = orig_ip;
 out:
-- 
2.30.1

