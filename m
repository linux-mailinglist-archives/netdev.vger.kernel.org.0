Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A433D8FAC
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 15:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237314AbhG1NxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 09:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236889AbhG1NwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 09:52:04 -0400
X-Greylist: delayed 145 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 28 Jul 2021 06:52:02 PDT
Received: from gmmr3.centrum.cz (gmmr3.centrum.cz [IPv6:2a00:da80:0:502::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461B4C061764;
        Wed, 28 Jul 2021 06:52:02 -0700 (PDT)
Received: from gmmr-2.centrum.cz (unknown [10.255.254.15])
        by gmmr3.centrum.cz (Postfix) with ESMTP id 527B718007FA5;
        Wed, 28 Jul 2021 15:49:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=atlas.cz; s=mail;
        t=1627480175; bh=btdGKWwqdzolFUEYa7m2BSrGTcmJuco6D2JUC+cfccY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eTjGvc+8YQyWse+4rXP0H3odllxS9gF81n8nQGrQ1RMtQfMkxKILQ+bNpDMjtWhnm
         wKAidtGPjheHzecYALPBCJSw+8Pl4dhSk1H27maQO6djIgtCsqJruQxYUXO7rlkW8m
         uBEJuao9LEfXF8nnLVwUNI/FqZrqLWkJT2idkmYU=
Received: from vm2.excello.cz (vm2.excello.cz [212.24.139.173])
        by gmmr-2.centrum.cz (Postfix) with QMQP
        id 5029F77DE; Wed, 28 Jul 2021 15:49:35 +0200 (CEST)
Received: from vm2.excello.cz by vm2.excello.cz
 (VF-Scanner: Clear:RC:0(2a00:da80:1:502::8):SC:0(-20.5/5.0):CC:0:;
 processed in 0.3 s); 28 Jul 2021 13:49:35 +0000
X-VF-Scanner-ID: 20210728134935.001014.21804.vm2.excello.cz.0
X-Spam-Status: No, hits=-20.5, required=5.0
Received: from gmmr-4.centrum.cz (2a00:da80:1:502::8)
  by out1.virusfree.cz with ESMTPS (TLSv1.3, TLS_AES_256_GCM_SHA384); 28 Jul 2021 15:49:34 +0200
Received: from gm-smtp10.centrum.cz (unknown [10.255.254.32])
        by gmmr-4.centrum.cz (Postfix) with ESMTP id EC69A20056064;
        Wed, 28 Jul 2021 15:49:34 +0200 (CEST)
Received: from arkam (unknown [94.113.86.190])
        by gm-smtp10.centrum.cz (Postfix) with ESMTPA id 815C4C063A35;
        Wed, 28 Jul 2021 15:49:34 +0200 (CEST)
Date:   Wed, 28 Jul 2021 15:49:33 +0200
From:   Petr =?utf-8?B?VmFuxJtr?= <arkamar@atlas.cz>
To:     Pavo Banicevic <pavo.banicevic@sartura.hr>
Cc:     linux@armlinux.org.uk, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, ivan.khoronzhuk@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, matt.redfearn@mips.com,
        mingo@kernel.org, dvlasenk@redhat.com, juraj.vijtiuk@sartura.hr,
        robert.marko@sartura.hr, luka.perkov@sartura.hr,
        jakov.petrina@sartura.hr
Subject: Re: [PATCH 3/3] include/uapi/linux/swab: Fix potentially missing
 __always_inline
Message-ID: <YQFgbRXKIeZ7H6mo@arkam>
References: <20210727141119.19812-1-pavo.banicevic@sartura.hr>
 <20210727141119.19812-4-pavo.banicevic@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210727141119.19812-4-pavo.banicevic@sartura.hr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 04:11:19PM +0200, Pavo Banicevic wrote:
> From: Matt Redfearn <matt.redfearn@mips.com>
> 
> Commit bc27fb68aaad ("include/uapi/linux/byteorder, swab: force inlining
> of some byteswap operations") added __always_inline to swab functions
> and commit 283d75737837 ("uapi/linux/stddef.h: Provide __always_inline to
> userspace headers") added a definition of __always_inline for use in
> exported headers when the kernel's compiler.h is not available.
> 
> However, since swab.h does not include stddef.h, if the header soup does
> not indirectly include it, the definition of __always_inline is missing,
> resulting in a compilation failure, which was observed compiling the
> perf tool using exported headers containing this commit:
> 
> In file included from /usr/include/linux/byteorder/little_endian.h:12:0,
>                  from /usr/include/asm/byteorder.h:14,
>                  from tools/include/uapi/linux/perf_event.h:20,
>                  from perf.h:8,
>                  from builtin-bench.c:18:
> /usr/include/linux/swab.h:160:8: error: unknown type name `__always_inline'
>  static __always_inline __u16 __swab16p(const __u16 *p)
> 
> Fix this by replacing the inclusion of linux/compiler.h with
> linux/stddef.h to ensure that we pick up that definition if required,
> without relying on it's indirect inclusion. compiler.h is then included
> indirectly, via stddef.h.
> 
> Fixes: 283d75737837 ("uapi/linux/stddef.h: Provide __always_inline to userspace headers")
> 
> Signed-off-by: Matt Redfearn <matt.redfearn@mips.com>
> ---

I use this patch in order to fix __always_inline issue for kernels
5.12+, see https://lore.kernel.org/lkml/YPGXXt6Z3O1W0AYS@arkam/ .
I believe this is the correct solution.

Reviewed-by: Petr Vaněk <arkamar@atlas.cz>
