Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E635F6CEA
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 19:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbiJFRZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 13:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbiJFRYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 13:24:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B044B4B2;
        Thu,  6 Oct 2022 10:24:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 036F361A32;
        Thu,  6 Oct 2022 17:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDFBC43141;
        Thu,  6 Oct 2022 17:24:36 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Y5qiz5qr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1665077071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hw+hnIMvKUNp0lwyCAgNJh72KYkKEhg87FRQTBs88Es=;
        b=Y5qiz5qraL1Ht5AhJT0KSwXJpIKonST+eqGUAuMAr8WPLDUsliL74+EorKkFA7SYfrCfCm
        8cGVCfHsj2cwWwcbYEhgFOCggukYu1AfE/Xd55KyZqkCt7dB3prgYsEIRtYu+PSN2tbUgt
        nH/6kusiZse/I7yhTs18YFSTmdsmMIE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 968caf85 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 6 Oct 2022 17:24:31 +0000 (UTC)
Received: by mail-ua1-f50.google.com with SMTP id z14so865098uam.10;
        Thu, 06 Oct 2022 10:24:29 -0700 (PDT)
X-Gm-Message-State: ACrzQf2CQk7P2+X6vYRNb0A8CTj0AutlJGrG+F+Km0J6dHkwI4isv0PS
        JKEVLkIefYWmy8DjtI3HVwmcL010PGiaNFgLyt0=
X-Google-Smtp-Source: AMsMyM5KG2gwBNORWG5lbntrblDeF/IiEaNCtjq1xHSusLtpHfgrAAJFtzxp/82W985F9k39J/OxSFTwH+6dW+Mrfqw=
X-Received: by 2002:ab0:6cb0:0:b0:3d7:1184:847f with SMTP id
 j16-20020ab06cb0000000b003d71184847fmr777504uaa.49.1665077067240; Thu, 06 Oct
 2022 10:24:27 -0700 (PDT)
MIME-Version: 1.0
References: <20221006165346.73159-1-Jason@zx2c4.com> <20221006165346.73159-4-Jason@zx2c4.com>
 <848ed24c-13ef-6c38-fd13-639b33809194@csgroup.eu>
In-Reply-To: <848ed24c-13ef-6c38-fd13-639b33809194@csgroup.eu>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 6 Oct 2022 11:24:16 -0600
X-Gmail-Original-Message-ID: <CAHmME9raQ4E00r9r8NyWJ17iSXE_KniTG0onCNAfMmfcGar1eg@mail.gmail.com>
Message-ID: <CAHmME9raQ4E00r9r8NyWJ17iSXE_KniTG0onCNAfMmfcGar1eg@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] treewide: use get_random_u32() when possible
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        Andreas Noever <andreas.noever@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?UTF-8?Q?Christoph_B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Christoph Hellwig <hch@lst.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dave Airlie <airlied@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Helge Deller <deller@gmx.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Huacai Chen <chenhuacai@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Jan Kara <jack@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Russell King <linux@armlinux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Graf <tgraf@suug.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        WANG Xuerui <kernel@xen0n.name>, Will Deacon <will@kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Chuck Lever <chuck.lever@oracle.com>, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christophe,

On Thu, Oct 6, 2022 at 11:21 AM Christophe Leroy
<christophe.leroy@csgroup.eu> wrote:
> Le 06/10/2022 =C3=A0 18:53, Jason A. Donenfeld a =C3=A9crit :
> > The prandom_u32() function has been a deprecated inline wrapper around
> > get_random_u32() for several releases now, and compiles down to the
> > exact same code. Replace the deprecated wrapper with a direct call to
> > the real function. The same also applies to get_random_int(), which is
> > just a wrapper around get_random_u32().
> >
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> # for sch_cak=
e
> > Acked-by: Chuck Lever <chuck.lever@oracle.com> # for nfsd
> > Reviewed-by: Jan Kara <jack@suse.cz> # for ext4
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > ---
>
> > diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/proces=
s.c
> > index 0fbda89cd1bb..9c4c15afbbe8 100644
> > --- a/arch/powerpc/kernel/process.c
> > +++ b/arch/powerpc/kernel/process.c
> > @@ -2308,6 +2308,6 @@ void notrace __ppc64_runlatch_off(void)
> >   unsigned long arch_align_stack(unsigned long sp)
> >   {
> >       if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_s=
pace)
> > -             sp -=3D get_random_int() & ~PAGE_MASK;
> > +             sp -=3D get_random_u32() & ~PAGE_MASK;
> >       return sp & ~0xf;
>
> Isn't that a candidate for prandom_u32_max() ?
>
> Note that sp is deemed to be 16 bytes aligned at all time.

Yes, probably. It seemed non-trivial to think about, so I didn't. But
let's see here... maybe it's not too bad:

If PAGE_MASK is always ~(PAGE_SIZE-1), then ~PAGE_MASK is
(PAGE_SIZE-1), so prandom_u32_max(PAGE_SIZE) should yield the same
thing? Is that accurate? And holds across platforms (this comes up a
few places)? If so, I'll do that for a v4.

Jason
