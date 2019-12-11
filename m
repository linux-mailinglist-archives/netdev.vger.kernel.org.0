Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC3511AC8B
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 14:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729689AbfLKN4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 08:56:19 -0500
Received: from www62.your-server.de ([213.133.104.62]:38504 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727554AbfLKN4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 08:56:19 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1if2TP-0007p8-I9; Wed, 11 Dec 2019 14:56:15 +0100
Date:   Wed, 11 Dec 2019 14:56:15 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Shubham Bansal <illusionist.neo@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: net: bpf: improve prologue code sequence
Message-ID: <20191211135615.GA25011@linux.fritz.box>
References: <E1ieH2g-0004ih-Rb@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ieH2g-0004ih-Rb@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25660/Wed Dec 11 10:47:07 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 11:17:30AM +0000, Russell King wrote:
> Improve the prologue code sequence to be able to take advantage of
> 64-bit stores, changing the code from:
> 
>   push    {r4, r5, r6, r7, r8, r9, fp, lr}
>   mov     fp, sp
>   sub     ip, sp, #80     ; 0x50
>   sub     sp, sp, #600    ; 0x258
>   str     ip, [fp, #-100] ; 0xffffff9c
>   mov     r6, #0
>   str     r6, [fp, #-96]  ; 0xffffffa0
>   mov     r4, #0
>   mov     r3, r4
>   mov     r2, r0
>   str     r4, [fp, #-104] ; 0xffffff98
>   str     r4, [fp, #-108] ; 0xffffff94
> 
> to the tighter:
> 
>   push    {r4, r5, r6, r7, r8, r9, fp, lr}
>   mov     fp, sp
>   mov     r3, #0
>   sub     r2, sp, #80     ; 0x50
>   sub     sp, sp, #600    ; 0x258
>   strd    r2, [fp, #-100] ; 0xffffff9c
>   mov     r2, #0
>   strd    r2, [fp, #-108] ; 0xffffff94
>   mov     r2, r0
> 
> resulting in a saving of three instructions.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied, thanks!
