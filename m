Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B699217D1FD
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 07:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgCHGFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 01:05:24 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:35659 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgCHGFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 01:05:24 -0500
Received: by mail-pg1-f202.google.com with SMTP id w8so4223857pgr.2
        for <netdev@vger.kernel.org>; Sat, 07 Mar 2020 22:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=wgJx1jCZAeH15eHuj5hqq4KMY6uh1EQG3oOhk3epjw8=;
        b=cpdXRwyq342FoFwwQpmJ2A62khqxfFXXircuMnwGJup4LO7Ptbmj/Rbh75hpUl8Hzd
         baqfHEB3Vqre+IYiBqIZwys1gaNMF5U6nz4duM0ecqCwFmBOSG1p8p2NvMJHDf83Re65
         d6kyb3j7nKCv6P2MRwnT6ZtbP0kbn8VdQsxc8ROp80Kj+oT/bOh5vY3Qfl8dmnsJxIlF
         HEoH1n6o8Awb/6GWQbL2mGMv41Cae7Mz1SoMbo6adDOvW9wjxRuGkTVOD6VO3TGuw6rK
         Imz8OOhPWvQpURaRX9x5U/h3r37PdoiZzLzOjdScoSEa3+IVhQuoROJewQl2Q8nbI04R
         JrnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=wgJx1jCZAeH15eHuj5hqq4KMY6uh1EQG3oOhk3epjw8=;
        b=t3tRI53ohmPvfXcYk+aYTDCJxBfwh/j4r8qGr+AQAT99q4GD/MQEBaYVohRKbaW3rm
         1zlzpq1xHBbGZY2CithGhsfjvj9Ouw6m6QzeU69lVAmI2FAV0Czb2Uk3wa29OjiHzfgS
         ds7hTnPTgdkKtweRtjIgcYkCct8TbijbltL8iwfvbl/iOZWKsfxtns4KlMTeHvjkJOnC
         66agIu/PeOO4va1cDwdUTV0QuiYUqdrwRGKQcRuUUrHkhoAsXLHeLE54Q1SaDIX/Lq77
         ggOxFIjuZPJOdmJi1S8LN6IDuPsPGIQ/sp9UCX8Rzrl50R0BL6y0oYZCuzNTWJ/TRvUF
         fHZA==
X-Gm-Message-State: ANhLgQ3aVhHDSSKS1GQlpca7z2StCiKllSq4stBiQiLMsx4Em35BS9+n
        0Xr9CokamAouI3ItV3hgW07brNqgjU8zSw==
X-Google-Smtp-Source: ADFU+vsCku6UEVyBjFA+u38OPY6+02t4dI86c16Tj2URFJlBLA1cbuOsX9+PmkEQ75K+dmaqRn+0ASP4ff8Xyg==
X-Received: by 2002:a17:90a:9409:: with SMTP id r9mr12003153pjo.39.1583647521758;
 Sat, 07 Mar 2020 22:05:21 -0800 (PST)
Date:   Sat,  7 Mar 2020 22:05:14 -0800
Message-Id: <20200308060514.149512-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH net] gre: fix uninit-value in __iptunnel_pull_header
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found an interesting case of the kernel reading
an uninit-value [1]

Problem is in the handling of ETH_P_WCCP in gre_parse_header()

We look at the byte following GRE options to eventually decide
if the options are four bytes longer.

Use skb_header_pointer() to not pull bytes if we found
that no more bytes were needed.

All callers of gre_parse_header() are properly using pskb_may_pull()
anyway before proceeding to next header.

[1]
BUG: KMSAN: uninit-value in pskb_may_pull include/linux/skbuff.h:2303 [inline]
BUG: KMSAN: uninit-value in __iptunnel_pull_header+0x30c/0xbd0 net/ipv4/ip_tunnel_core.c:94
CPU: 1 PID: 11784 Comm: syz-executor940 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 pskb_may_pull include/linux/skbuff.h:2303 [inline]
 __iptunnel_pull_header+0x30c/0xbd0 net/ipv4/ip_tunnel_core.c:94
 iptunnel_pull_header include/net/ip_tunnels.h:411 [inline]
 gre_rcv+0x15e/0x19c0 net/ipv6/ip6_gre.c:606
 ip6_protocol_deliver_rcu+0x181b/0x22c0 net/ipv6/ip6_input.c:432
 ip6_input_finish net/ipv6/ip6_input.c:473 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ip6_input net/ipv6/ip6_input.c:482 [inline]
 ip6_mc_input+0xdf2/0x1460 net/ipv6/ip6_input.c:576
 dst_input include/net/dst.h:442 [inline]
 ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ipv6_rcv+0x683/0x710 net/ipv6/ip6_input.c:306
 __netif_receive_skb_one_core net/core/dev.c:5198 [inline]
 __netif_receive_skb net/core/dev.c:5312 [inline]
 netif_receive_skb_internal net/core/dev.c:5402 [inline]
 netif_receive_skb+0x66b/0xf20 net/core/dev.c:5461
 tun_rx_batched include/linux/skbuff.h:4321 [inline]
 tun_get_user+0x6aef/0x6f60 drivers/net/tun.c:1997
 tun_chr_write_iter+0x1f2/0x360 drivers/net/tun.c:2026
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:483 [inline]
 __vfs_write+0xa5a/0xca0 fs/read_write.c:496
 vfs_write+0x44a/0x8f0 fs/read_write.c:558
 ksys_write+0x267/0x450 fs/read_write.c:611
 __do_sys_write fs/read_write.c:623 [inline]
 __se_sys_write fs/read_write.c:620 [inline]
 __ia32_sys_write+0xdb/0x120 fs/read_write.c:620
 do_syscall_32_irqs_on arch/x86/entry/common.c:339 [inline]
 do_fast_syscall_32+0x3c7/0x6e0 arch/x86/entry/common.c:410
 entry_SYSENTER_compat+0x68/0x77 arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7f62d99
Code: 90 e8 0b 00 00 00 f3 90 0f ae e8 eb f9 8d 74 26 00 89 3c 24 c3 90 90 90 90 90 90 90 90 90 90 90 90 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000fffedb2c EFLAGS: 00000217 ORIG_RAX: 0000000000000004
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000020002580
RDX: 0000000000000fca RSI: 0000000000000036 RDI: 0000000000000004
RBP: 0000000000008914 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:82
 slab_alloc_node mm/slub.c:2793 [inline]
 __kmalloc_node_track_caller+0xb40/0x1200 mm/slub.c:4401
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2fd/0xac0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1051 [inline]
 alloc_skb_with_frags+0x18c/0xa70 net/core/skbuff.c:5766
 sock_alloc_send_pskb+0xada/0xc60 net/core/sock.c:2242
 tun_alloc_skb drivers/net/tun.c:1529 [inline]
 tun_get_user+0x10ae/0x6f60 drivers/net/tun.c:1843
 tun_chr_write_iter+0x1f2/0x360 drivers/net/tun.c:2026
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:483 [inline]
 __vfs_write+0xa5a/0xca0 fs/read_write.c:496
 vfs_write+0x44a/0x8f0 fs/read_write.c:558
 ksys_write+0x267/0x450 fs/read_write.c:611
 __do_sys_write fs/read_write.c:623 [inline]
 __se_sys_write fs/read_write.c:620 [inline]
 __ia32_sys_write+0xdb/0x120 fs/read_write.c:620
 do_syscall_32_irqs_on arch/x86/entry/common.c:339 [inline]
 do_fast_syscall_32+0x3c7/0x6e0 arch/x86/entry/common.c:410
 entry_SYSENTER_compat+0x68/0x77 arch/x86/entry/entry_64_compat.S:139

Fixes: 95f5c64c3c13 ("gre: Move utility functions to common headers")
Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv4/gre_demux.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/gre_demux.c b/net/ipv4/gre_demux.c
index 5fd6e8ed02b5d5c201ff8dc8cf31db3994fcdcf7..66fdbfe5447cdb93e06fe85d94646a6806401e98 100644
--- a/net/ipv4/gre_demux.c
+++ b/net/ipv4/gre_demux.c
@@ -56,7 +56,9 @@ int gre_del_protocol(const struct gre_protocol *proto, u8 version)
 }
 EXPORT_SYMBOL_GPL(gre_del_protocol);
 
-/* Fills in tpi and returns header length to be pulled. */
+/* Fills in tpi and returns header length to be pulled.
+ * Note that caller must use pskb_may_pull() before pulling GRE header.
+ */
 int gre_parse_header(struct sk_buff *skb, struct tnl_ptk_info *tpi,
 		     bool *csum_err, __be16 proto, int nhs)
 {
@@ -110,8 +112,14 @@ int gre_parse_header(struct sk_buff *skb, struct tnl_ptk_info *tpi,
 	 * - When dealing with WCCPv2, Skip extra 4 bytes in GRE header
 	 */
 	if (greh->flags == 0 && tpi->proto == htons(ETH_P_WCCP)) {
+		u8 _val, *val;
+
+		val = skb_header_pointer(skb, nhs + hdr_len,
+					 sizeof(_val), &_val);
+		if (!val)
+			return -EINVAL;
 		tpi->proto = proto;
-		if ((*(u8 *)options & 0xF0) != 0x40)
+		if ((*val & 0xF0) != 0x40)
 			hdr_len += 4;
 	}
 	tpi->hdr_len = hdr_len;
-- 
2.25.1.481.gfbce0eb801-goog

