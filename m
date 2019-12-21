Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D612E1287B1
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 06:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfLUFyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 00:54:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57076 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLUFyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 00:54:25 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6537F153DA517;
        Fri, 20 Dec 2019 21:54:24 -0800 (PST)
Date:   Fri, 20 Dec 2019 21:54:23 -0800 (PST)
Message-Id: <20191220.215423.1490110825809704417.davem@davemloft.net>
To:     geert@linux-m68k.org
Cc:     hannes@stressinduktion.org, mkubecek@suse.cz,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-m68k@vger.kernel.org
Subject: Re: [PATCH] net: dst: Force 4-byte alignment of dst_metrics
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191220133140.5684-1-geert@linux-m68k.org>
References: <20191220133140.5684-1-geert@linux-m68k.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Dec 2019 21:54:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 20 Dec 2019 14:31:40 +0100

> When storing a pointer to a dst_metrics structure in dst_entry._metrics,
> two flags are added in the least significant bits of the pointer value.
> Hence this assumes all pointers to dst_metrics structures have at least
> 4-byte alignment.
> 
> However, on m68k, the minimum alignment of 32-bit values is 2 bytes, not
> 4 bytes.  Hence in some kernel builds, dst_default_metrics may be only
> 2-byte aligned, leading to obscure boot warnings like:
> 
>     WARNING: CPU: 0 PID: 7 at lib/refcount.c:28 refcount_warn_saturate+0x44/0x9a
>     refcount_t: underflow; use-after-free.
>     Modules linked in:
>     CPU: 0 PID: 7 Comm: ksoftirqd/0 Tainted: G        W         5.5.0-rc2-atari-01448-g114a1a1038af891d-dirty #261
>     Stack from 10835e6c:
> 	    10835e6c 0038134f 00023fa6 00394b0f 0000001c 00000009 00321560 00023fea
> 	    00394b0f 0000001c 001a70f8 00000009 00000000 10835eb4 00000001 00000000
> 	    04208040 0000000a 00394b4a 10835ed4 00043aa8 001a70f8 00394b0f 0000001c
> 	    00000009 00394b4a 0026aba8 003215a4 00000003 00000000 0026d5a8 00000001
> 	    003215a4 003a4361 003238d6 000001f0 00000000 003215a4 10aa3b00 00025e84
> 	    003ddb00 10834000 002416a8 10aa3b00 00000000 00000080 000aa038 0004854a
>     Call Trace: [<00023fa6>] __warn+0xb2/0xb4
>      [<00023fea>] warn_slowpath_fmt+0x42/0x64
>      [<001a70f8>] refcount_warn_saturate+0x44/0x9a
>      [<00043aa8>] printk+0x0/0x18
>      [<001a70f8>] refcount_warn_saturate+0x44/0x9a
>      [<0026aba8>] refcount_sub_and_test.constprop.73+0x38/0x3e
>      [<0026d5a8>] ipv4_dst_destroy+0x5e/0x7e
>      [<00025e84>] __local_bh_enable_ip+0x0/0x8e
>      [<002416a8>] dst_destroy+0x40/0xae
> 
> Fix this by forcing 4-byte alignment of all dst_metrics structures.
> 
> Fixes: e5fd387ad5b30ca3 ("ipv6: do not overwrite inetpeer metrics prematurely")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied.
