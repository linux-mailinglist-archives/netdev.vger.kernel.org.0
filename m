Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF8521918E
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 22:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgGHUeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 16:34:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgGHUeM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 16:34:12 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C08620739;
        Wed,  8 Jul 2020 20:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594240451;
        bh=zDK5NXXZRSdLUVKIgw4PNxUgvgIS7unDdJHqM90eKH8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zwFjDrTOyFTMMCbXLVvpwCsAWdyt8k2oQYfhW7sf9rTaJ5slRw+zUWaMZKwda7pNB
         UHuaDeq7ISwU/NUhtK9hIzqSKb3fLqfIpydeaS3yCbrovgNzjDtF5JTmsoR0O8JJjH
         fJsKLwclEhtcvO13tweH5wWCMPCeSNSLZMwcKy6E=
Date:   Wed, 8 Jul 2020 13:34:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Alex Elder <elder@linaro.org>, "# 3.4.x" <stable@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] bitfield.h: don't compile-time validate _val in
 FIELD_FIT
Message-ID: <20200708133409.72c037bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAKwvOd=PrNG9WqBc4P43-XK7pOD4rQg4FA8Gd27OdUYb2qMDdw@mail.gmail.com>
References: <20200707211642.1106946-1-ndesaulniers@google.com>
        <bca8cff8-3ffe-e5ab-07a5-2ab29d5e394a@linaro.org>
        <CAKwvOdmtv2EdNQz+c_DZm_47EEibkaXfDW8dGPwNPA3OrcoC9g@mail.gmail.com>
        <20997cd9-91e5-ca83-218d-4fd5af128893@linaro.org>
        <CAKwvOd=PrNG9WqBc4P43-XK7pOD4rQg4FA8Gd27OdUYb2qMDdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Jul 2020 10:56:43 -0700 Nick Desaulniers wrote:
> On Wed, Jul 8, 2020 at 10:34 AM Alex Elder <elder@linaro.org> wrote:
> >
> > I understand why something needs to be done to handle that case.
> > There's fancy macro gymnastics in "bitfield.h" to add convenient
> > build-time checks for usage problems; I just thought there might
> > be something we could do to preserve the checking--even in this
> > case.  But figuring that out takes more time than I was willing
> > to spend on it yesterday...  
> 
> I also find the use of 0U in FIELD_GET sticks out from the use of 0ULL
> or (0ull) in these macros (hard to notice, but I changed it in my diff
> to 0ULL).  Are there implicit promotion+conversion bugs here?  I don't
> know, but I'd rather not think about it by just using types of the
> same width and signedness.

TBH I just copied the type from other arguments. It doesn't matter
in practice now in this case. I have no preference.

> > >> A second comment about this is that it might be nice to break
> > >> __BF_FIELD_CHECK() into the parts that verify the mask (which
> > >> could be used by FIELD_FIT() here) and the parts that verify
> > >> other things.  
> > >
> > > Like so? Jakub, WDYT? Or do you prefer v1+Alex's suggestion about
> > > using `(typeof(_mask))0` in place of 0ULL?  
> >
> > Yes, very much like that!  But you could do that as a follow-on
> > instead, so as not to delay or confuse things.  
> 
> No rush; let's get it right.
> 
> So I can think of splitting this into maybe 3 patches, based on feedback:
> 1. there's a bug in compile time validating _val in FIELD_FIT, since
> we want to be able to call it at runtime with "bad" values.
> 2. the FIELD_* macros use constants (0ull, 0ULL, 0U) that don't match
> typeof(_mask).
> 3. It might be nice to break up __BF_FIELD_CHECK.
>
> I don't think anyone's raised an objection to 1.
> 
> Assuming Jakub is ok with 3, fixing 3 will actually also address 2.
> So then we don't need 3 patches; only 2.  But if we don't do 3 first,
> then I have to resend a v2 of 1 anyways to address 2 (which was Alex's
> original feedback).
> 
> My above diff was all three in one go, but I don't think it would be
> unreasonable to break it up into 3 then 1.
> 
> If we prefer not to do 3, then I can send a v2 of 1 that addresses the
> inconsistent use of types, as one or two patches.
> 
> Jakub, what is your preference?

I don't see much point in breaking up the checking macro. But even less
in arguing either way :)

> (Also, noting that I'm sending to David, assuming he'll pick up the
> patches once we have everyone's buy in? Or is there someone else more
> appropriate to accept changes to this header? I guess Jakub and David
> are the listed maintainers for
> drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c)

Seems reasonable, put [PATCH net] in the subject to make that explicit.
