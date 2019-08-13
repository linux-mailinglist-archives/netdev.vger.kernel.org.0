Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0C78BF5B
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 19:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfHMRIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 13:08:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbfHMRIh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 13:08:37 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50A5020679;
        Tue, 13 Aug 2019 17:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565716117;
        bh=65STqoKxZejhRA8D9TwQa+K2PAMisn1xsEutBY/kUY0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e8o5cKrg0h7l3Es4XUW2/tElqvpgDv1p8yDzOCq5FdWQnf1aMYy0Xzef2T/tELhCD
         s0upFTQQ5MtnqWUt7HUvO/2NRH2JQikPkh4tk9SAzwfYzOGXhtLhiE0lh5gNu7Nibj
         fm3edf+JH5WVs5yzATU7sOHcbCWCbW1hmNJjWplI=
Date:   Tue, 13 Aug 2019 18:08:30 +0100
From:   Will Deacon <will@kernel.org>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>, yhs@fb.com,
        clang-built-linux@googlegroups.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Enrico Weigelt <info@metux.net>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf@vger.kernel.org
Subject: Re: [PATCH 12/16] arm64: prefer __section from compiler_attributes.h
Message-ID: <20190813170829.c3lryb6va3eopxd7@willie-the-truck>
References: <20190812215052.71840-1-ndesaulniers@google.com>
 <20190812215052.71840-12-ndesaulniers@google.com>
 <20190813082744.xmzmm4j675rqiz47@willie-the-truck>
 <CANiq72mAfJ23PyWzZAELgbKQDCX2nvY0z+dmOMe14qz=wa6eFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiq72mAfJ23PyWzZAELgbKQDCX2nvY0z+dmOMe14qz=wa6eFg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 02:36:06PM +0200, Miguel Ojeda wrote:
> On Tue, Aug 13, 2019 at 10:27 AM Will Deacon <will@kernel.org> wrote:
> > On Mon, Aug 12, 2019 at 02:50:45PM -0700, Nick Desaulniers wrote:
> > > GCC unescapes escaped string section names while Clang does not. Because
> > > __section uses the `#` stringification operator for the section name, it
> > > doesn't need to be escaped.
> > >
> > > This antipattern was found with:
> > > $ grep -e __section\(\" -e __section__\(\" -r
> > >
> > > Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> > > Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> > > ---
> > >  arch/arm64/include/asm/cache.h     | 2 +-
> > >  arch/arm64/kernel/smp_spin_table.c | 2 +-
> > >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > Does this fix a build issue, or is it just cosmetic or do we end up with
> > duplicate sections or something else?
> 
> This should be cosmetic -- basically we are trying to move all users
> of current available __attribute__s in compiler_attributes.h to the
> __attr forms. I am also adding (slowly) new attributes that are
> already used but we don't have them yet in __attr form.
> 
> > Happy to route it via arm64, just having trouble working out whether it's
> > 5.3 material!
> 
> As you prefer! Those that are not taken by a maintainer I will pick up
> and send via compiler-attributes.
> 
> I would go for 5.4, since there is no particular rush anyway.

Okey doke, I'll pick this one up for 5.4 then. Thanks for the explanation!

Will
