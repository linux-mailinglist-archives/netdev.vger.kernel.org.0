Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F5537F0B0
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 02:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235774AbhEMA4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 20:56:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235127AbhEMA4Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 20:56:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FC8C61108;
        Thu, 13 May 2021 00:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620867316;
        bh=oPtxwiCl8GQDzfe3udTKNO5B+Tj6W6B4fBboGk8qGdE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BjD/SuCQ8q4diVv/ZpxVDivdP6yBlJIpWu7AiCwBhUzUu9UyaHmmOSP9OmD0cnsw+
         LNWmeXJOmZlT0lpPU53ynZUU/B1pC5/i/9b9HXCmvvRZjoJPXxluo/vS6qY/AvMWj9
         BJEobxcdiz7ww5nRH9GBr8ezXkPT+x0tbeil4ooFJadDUnOwo+Vmnkwpz/w4Qs3gEv
         MJvoXcYsa+Sgcii4sw+Wq3cqvIwDaenv3mTpEO971uSduV/WAJRMygFb65y4mZcR53
         +JKNMtrd6BJrvBZ7c8gFHiRks2CaIMNkdNSHr7SnHhYYXQZZXOeH6dXAe3q9afuKJO
         q/uodL4YsJtdg==
Date:   Wed, 12 May 2021 17:55:12 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Subject: Re: -Wconstant-conversion in
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
Message-ID: <YJx48BfKpWMZCbnz@archlinux-ax161>
References: <20200417004120.GA18080@ubuntu-s3-xlarge-x86>
 <YImjw3eypUdhkp88@archlinux-ax161>
 <CAPv3WKeHcq+viBHR=ok+AytrNWLFudWJ8qHoShs3r4LOj7qD0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv3WKeHcq+viBHR=ok+AytrNWLFudWJ8qHoShs3r4LOj7qD0w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcin,

On Thu, Apr 29, 2021 at 09:08:13AM +0200, Marcin Wojtas wrote:
> Hi Nathan,
> 
> 
> śr., 28 kwi 2021 o 20:04 Nathan Chancellor <nathan@kernel.org> napisał(a):
> >
> > On Thu, Apr 16, 2020 at 05:41:20PM -0700, Nathan Chancellor wrote:
> > > Hi all,
> > >
> > > I was building s390 allyesconfig with clang and came across a curious
> > > warning:
> > >
> > > drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:580:41: warning:
> > > implicit conversion from 'unsigned long' to 'int' changes value from
> > > 18446744073709551584 to -32 [-Wconstant-conversion]
> > >         mvpp2_pools[MVPP2_BM_SHORT].pkt_size = MVPP2_BM_SHORT_PKT_SIZE;
> > >                                              ~ ^~~~~~~~~~~~~~~~~~~~~~~
> > > drivers/net/ethernet/marvell/mvpp2/mvpp2.h:699:33: note: expanded from
> > > macro 'MVPP2_BM_SHORT_PKT_SIZE'
> > > #define MVPP2_BM_SHORT_PKT_SIZE MVPP2_RX_MAX_PKT_SIZE(MVPP2_BM_SHORT_FRAME_SIZE)
> > >                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > drivers/net/ethernet/marvell/mvpp2/mvpp2.h:634:30: note: expanded from
> > > macro 'MVPP2_RX_MAX_PKT_SIZE'
> > >         ((total_size) - NET_SKB_PAD - MVPP2_SKB_SHINFO_SIZE)
> > >                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~
> > > 1 warning generated.
> > >
> > > As far as I understand it, the warning comes from the fact that
> > > MVPP2_BM_SHORT_FRAME_SIZE is treated as size_t because
> > > MVPP2_SKB_SHINFO_SIZE ultimately calls ALIGN with sizeof(struct
> > > skb_shared_info), which has typeof called on it.
> > >
> > > The implicit conversion probably is fine but it would be nice to take
> > > care of the warning. I am not sure what would be the best way to do that
> > > would be though. An explicit cast would take care of it, maybe in
> > > MVPP2_SKB_SHINFO_SIZE since the actual value I see is 320, which is able
> > > to be fit into type int easily.
> > >
> > > Any comments would be appreciated, there does not appear to be a
> > > dedicated maintainer of this driver according to get_maintainer.pl.
> >
> > Sorry for the necrobump, I am doing a bug scrub and it seems like this
> > driver now has maintainers so keying them in in case they have any
> > comments/suggestions.
> >
> 
> Thank you for your interest. Are you still reproducing the issue? With
> clang 10.0.0 the compilation passes in my setup:
> $ ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make CC=clang
> drivers/net/ethernet/marvell/mvpp2/
>   SYNC    include/config/auto.conf.cmd
>   CC      scripts/mod/empty.o
>   MKELF   scripts/mod/elfconfig.h
>   HOSTCC  scripts/mod/modpost.o
>   CC      scripts/mod/devicetable-offsets.s
>   HOSTCC  scripts/mod/file2alias.o
>   HOSTCC  scripts/mod/sumversion.o
>   HOSTLD  scripts/mod/modpost
>   CC      kernel/bounds.s
>   CC      arch/arm64/kernel/asm-offsets.s
>   UPD     include/generated/asm-offsets.h
>   CALL    scripts/checksyscalls.sh
>   CALL    scripts/atomic/check-atomics.sh
>   LDS     arch/arm64/kernel/vdso/vdso.lds
>   CC      arch/arm64/kernel/vdso/vgettimeofday.o
>   AS      arch/arm64/kernel/vdso/note.o
>   AS      arch/arm64/kernel/vdso/sigreturn.o
>   LD      arch/arm64/kernel/vdso/vdso.so.dbg
>   VDSOSYM include/generated/vdso-offsets.h
>   OBJCOPY arch/arm64/kernel/vdso/vdso.so
>   CC      drivers/net/ethernet/marvell/mvpp2/mvpp2_main.o
>   CC      drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.o
>   CC      drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.o
>   CC      drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.o
>   AR      drivers/net/ethernet/marvell/mvpp2/built-in.a

My apologies for taking a while to get back to you, it took me a while
to understand what is going on here.

On s390, MVPP2_RX_MAX_PKT_SIZE(MVPP2_BM_SHORT_FRAME_SIZE) evaluates to
704 - 224 - 512 = -32, which is implicitly converted to size_t or
unsigned long because of the

SKB_DATA_ALIGN(sizeof(struct skb_shared_info));

resulting in the super large number that clang shows above. Then that
large number is converted back into int, resulting in the same value but
with the warning. The 512 comes from the fact that L1_CACHE_BYTES on
s390 is 256, resulting in a large aligned value.

On arm64, MVPP2_RX_MAX_PKT_SIZE(MVPP2_BM_SHORT_FRAME_SIZE) evaluates to
704 - 224 - 320, which is 160, which is the same value signed or
unsigned.

I understand that this probably does not matter in practice because this
driver does not run on anything other than Marvell SoCs but it might be
nice to fix the warning :) this patch below seems like a reasonable
option, let me know what you think.

Cheers,
Nathan

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 8edba5ea90f0..db23da9a0658 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -832,7 +832,7 @@
 
 /* RX buffer constants */
 #define MVPP2_SKB_SHINFO_SIZE \
-	SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
+	SKB_DATA_ALIGN((ssize_t)sizeof(struct skb_shared_info))
 
 #define MVPP2_RX_PKT_SIZE(mtu) \
 	ALIGN((mtu) + MVPP2_MH_SIZE + MVPP2_VLAN_TAG_LEN + \
