Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5502D313
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 03:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbfE2BHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 21:07:48 -0400
Received: from nwk-aaemail-lapp01.apple.com ([17.151.62.66]:43458 "EHLO
        nwk-aaemail-lapp01.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725816AbfE2BHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 21:07:47 -0400
Received: from pps.filterd (nwk-aaemail-lapp01.apple.com [127.0.0.1])
        by nwk-aaemail-lapp01.apple.com (8.16.0.27/8.16.0.27) with SMTP id x4T028Vn063993;
        Tue, 28 May 2019 17:02:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=mime-version :
 content-transfer-encoding : content-type : sender : from : to : cc :
 subject : date : message-id; s=20180706;
 bh=Zhe3AF6tqLzlIP22LChU8tdHhaA3S6DVgaYsidjvMj8=;
 b=f+ggHMzkwxHbBY1gI6hJYA+qGzUPRBAs6oQXYjjvf8KJguNn3cZTiEBi2nvXVfXaXCXp
 KlDk9O9FPGllNU1picgrjAaxhuWG4Q6luTAOZzsSBwaFF+olLE47nio8hFsTL61MZq4U
 xvebnxMadtIaguhJEGRQldp/ci97ypBA3jJx0lU771PNL469b882HrR+nl9VBk/7R9Nh
 B5QCc7JzJQIcHLjXL0V3rFtCav06YjFAyO+8WMrMxO8vLseLcWvqHZEaHNyRn3bkmnbM
 Eq/pulhvw/oVoLH2TFu6YhFyz/9KkoT+6hyO23/Qrs2Q1aDbBBemGp4xovpbwHLgHbX3 Cg== 
Received: from mr2-mtap-s03.rno.apple.com (mr2-mtap-s03.rno.apple.com [17.179.226.135])
        by nwk-aaemail-lapp01.apple.com with ESMTP id 2sq4n3f07y-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 28 May 2019 17:02:33 -0700
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from nwk-mmpp-sz09.apple.com
 (nwk-mmpp-sz09.apple.com [17.128.115.80]) by mr2-mtap-s03.rno.apple.com
 (Oracle Communications Messaging Server 8.0.2.3.20181024 64bit (built Oct 24
 2018)) with ESMTPS id <0PS800F45O45L420@mr2-mtap-s03.rno.apple.com>; Tue,
 28 May 2019 17:02:31 -0700 (PDT)
Received: from process_milters-daemon.nwk-mmpp-sz09.apple.com by
 nwk-mmpp-sz09.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0PS800700O1A3400@nwk-mmpp-sz09.apple.com>; Tue,
 28 May 2019 17:02:30 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: 7d75b40a450ca2b8a80652a74fc505d3
X-Va-E-CD: 770681996a36488ab60cbcc8ddbee7d3
X-Va-R-CD: 01d61d6de2240a9a038fefe0acf6615b
X-Va-CD: 0
X-Va-ID: 89f84698-ca89-4d44-899d-ac5cf5f456ae
X-V-A:  
X-V-T-CD: 7d75b40a450ca2b8a80652a74fc505d3
X-V-E-CD: 770681996a36488ab60cbcc8ddbee7d3
X-V-R-CD: 01d61d6de2240a9a038fefe0acf6615b
X-V-CD: 0
X-V-ID: 77e3ea91-c1b4-4aa0-8d98-2e04a3c5da43
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2019-05-28_11:,, signatures=0
Received: from localhost ([17.192.155.217]) by nwk-mmpp-sz09.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0PS8000NFO2CZ480@nwk-mmpp-sz09.apple.com>; Tue,
 28 May 2019 17:01:24 -0700 (PDT)
From:   Christoph Paasch <cpaasch@apple.com>
To:     David Miller <davem@davemloft.net>, gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, William Tu <u9012063@gmail.com>
Subject: [PATCH v4.14.x] net: erspan: fix use-after-free
Date:   Tue, 28 May 2019 17:01:13 -0700
Message-id: <20190529000113.49334-1-cpaasch@apple.com>
X-Mailer: git-send-email 2.21.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_11:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building the erspan header for either v1 or v2, the eth_hdr()
does not point to the right inner packet's eth_hdr,
causing kasan report use-after-free and slab-out-of-bouds read.

The patch fixes the following syzkaller issues:
[1] BUG: KASAN: slab-out-of-bounds in erspan_xmit+0x22d4/0x2430 net/ipv4/ip_gre.c:735
[2] BUG: KASAN: slab-out-of-bounds in erspan_build_header+0x3bf/0x3d0 net/ipv4/ip_gre.c:698
[3] BUG: KASAN: use-after-free in erspan_xmit+0x22d4/0x2430 net/ipv4/ip_gre.c:735
[4] BUG: KASAN: use-after-free in erspan_build_header+0x3bf/0x3d0 net/ipv4/ip_gre.c:698

[2] CPU: 0 PID: 3654 Comm: syzkaller377964 Not tainted 4.15.0-rc9+ #185
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:17 [inline]
 dump_stack+0x194/0x257 lib/dump_stack.c:53
 print_address_description+0x73/0x250 mm/kasan/report.c:252
 kasan_report_error mm/kasan/report.c:351 [inline]
 kasan_report+0x25b/0x340 mm/kasan/report.c:409
 __asan_report_load_n_noabort+0xf/0x20 mm/kasan/report.c:440
 erspan_build_header+0x3bf/0x3d0 net/ipv4/ip_gre.c:698
 erspan_xmit+0x3b8/0x13b0 net/ipv4/ip_gre.c:740
 __netdev_start_xmit include/linux/netdevice.h:4042 [inline]
 netdev_start_xmit include/linux/netdevice.h:4051 [inline]
 packet_direct_xmit+0x315/0x6b0 net/packet/af_packet.c:266
 packet_snd net/packet/af_packet.c:2943 [inline]
 packet_sendmsg+0x3aed/0x60b0 net/packet/af_packet.c:2968
 sock_sendmsg_nosec net/socket.c:638 [inline]
 sock_sendmsg+0xca/0x110 net/socket.c:648
 SYSC_sendto+0x361/0x5c0 net/socket.c:1729
 SyS_sendto+0x40/0x50 net/socket.c:1697
 do_syscall_32_irqs_on arch/x86/entry/common.c:327 [inline]
 do_fast_syscall_32+0x3ee/0xf9d arch/x86/entry/common.c:389
 entry_SYSENTER_compat+0x54/0x63 arch/x86/entry/entry_64_compat.S:129
RIP: 0023:0xf7fcfc79
RSP: 002b:00000000ffc6976c EFLAGS: 00000286 ORIG_RAX: 0000000000000171
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000020011000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020008000
RBP: 000000000000001c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Commit b423d13c08a6 ("net: erspan: fix use-after-free") fixed the
use-after-free. The root-cause change (commit 84e54fe0a5ea ("gre:
introduce native tunnel support for ERSPAN")) made it into 4.14.

Thus, the fix needs to be backported to 4.14 as well.

Fixes: 84e54fe0a5ea ("gre: introduce native tunnel support for ERSPAN")
Cc: William Tu <u9012063@gmail.com>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
---

Notes:
    This should *only* go into 4.14.

 net/ipv4/ip_gre.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index dd3bcf22fe8b..0fc499db6da2 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -689,7 +689,7 @@ static void erspan_build_header(struct sk_buff *skb,
 				__be32 id, u32 index, bool truncate)
 {
 	struct iphdr *iphdr = ip_hdr(skb);
-	struct ethhdr *eth = eth_hdr(skb);
+	struct ethhdr *eth = (struct ethhdr *)skb->data;
 	enum erspan_encap_type enc_type;
 	struct erspanhdr *ershdr;
 	struct qtag_prefix {
-- 
2.21.0

