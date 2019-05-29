Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7182D2AB
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfE2AHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 20:07:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbfE2AHq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 20:07:46 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2311420883;
        Wed, 29 May 2019 00:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559088465;
        bh=s5+tvtNKOiEZLGrnWdad5DpIRfr6+XyY8MDL5+id3ko=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wl0O+w50JvYXm1gDaA02/M9u6q02ZlX5pwxLj2kU3+F2CEYejGs4P0we55RTU9whC
         th9GN9f/m50CspY3gUdDVftD77883RXrcL3s968zMy3IgxsrvmXwnrx8V0oU2C2mdQ
         48PHrRP6W+Bbtka37RFxz2rTzdbuQs98KpHnARUU=
Date:   Tue, 28 May 2019 17:07:44 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christoph Paasch <cpaasch@apple.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        William Tu <u9012063@gmail.com>
Subject: Re: [PATCH v4.14.x] net: erspan: fix use-after-free
Message-ID: <20190529000744.GA12783@kroah.com>
References: <20190529000113.49334-1-cpaasch@apple.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529000113.49334-1-cpaasch@apple.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 05:01:13PM -0700, Christoph Paasch wrote:
> When building the erspan header for either v1 or v2, the eth_hdr()
> does not point to the right inner packet's eth_hdr,
> causing kasan report use-after-free and slab-out-of-bouds read.
> 
> The patch fixes the following syzkaller issues:
> [1] BUG: KASAN: slab-out-of-bounds in erspan_xmit+0x22d4/0x2430 net/ipv4/ip_gre.c:735
> [2] BUG: KASAN: slab-out-of-bounds in erspan_build_header+0x3bf/0x3d0 net/ipv4/ip_gre.c:698
> [3] BUG: KASAN: use-after-free in erspan_xmit+0x22d4/0x2430 net/ipv4/ip_gre.c:735
> [4] BUG: KASAN: use-after-free in erspan_build_header+0x3bf/0x3d0 net/ipv4/ip_gre.c:698
> 
> [2] CPU: 0 PID: 3654 Comm: syzkaller377964 Not tainted 4.15.0-rc9+ #185
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:17 [inline]
>  dump_stack+0x194/0x257 lib/dump_stack.c:53
>  print_address_description+0x73/0x250 mm/kasan/report.c:252
>  kasan_report_error mm/kasan/report.c:351 [inline]
>  kasan_report+0x25b/0x340 mm/kasan/report.c:409
>  __asan_report_load_n_noabort+0xf/0x20 mm/kasan/report.c:440
>  erspan_build_header+0x3bf/0x3d0 net/ipv4/ip_gre.c:698
>  erspan_xmit+0x3b8/0x13b0 net/ipv4/ip_gre.c:740
>  __netdev_start_xmit include/linux/netdevice.h:4042 [inline]
>  netdev_start_xmit include/linux/netdevice.h:4051 [inline]
>  packet_direct_xmit+0x315/0x6b0 net/packet/af_packet.c:266
>  packet_snd net/packet/af_packet.c:2943 [inline]
>  packet_sendmsg+0x3aed/0x60b0 net/packet/af_packet.c:2968
>  sock_sendmsg_nosec net/socket.c:638 [inline]
>  sock_sendmsg+0xca/0x110 net/socket.c:648
>  SYSC_sendto+0x361/0x5c0 net/socket.c:1729
>  SyS_sendto+0x40/0x50 net/socket.c:1697
>  do_syscall_32_irqs_on arch/x86/entry/common.c:327 [inline]
>  do_fast_syscall_32+0x3ee/0xf9d arch/x86/entry/common.c:389
>  entry_SYSENTER_compat+0x54/0x63 arch/x86/entry/entry_64_compat.S:129
> RIP: 0023:0xf7fcfc79
> RSP: 002b:00000000ffc6976c EFLAGS: 00000286 ORIG_RAX: 0000000000000171
> RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000020011000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020008000
> RBP: 000000000000001c R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> 
> Commit b423d13c08a6 ("net: erspan: fix use-after-free") fixed the
> use-after-free. The root-cause change (commit 84e54fe0a5ea ("gre:
> introduce native tunnel support for ERSPAN")) made it into 4.14.
> 
> Thus, the fix needs to be backported to 4.14 as well.
> 
> Fixes: 84e54fe0a5ea ("gre: introduce native tunnel support for ERSPAN")
> Cc: William Tu <u9012063@gmail.com>
> Signed-off-by: Christoph Paasch <cpaasch@apple.com>
> ---
> 
> Notes:
>     This should *only* go into 4.14.

What is the git commit id of this patch in Linus's tree?

thanks,

greg k-h
