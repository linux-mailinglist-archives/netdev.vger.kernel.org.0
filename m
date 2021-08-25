Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F8F3F7B28
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 19:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242190AbhHYRHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 13:07:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242183AbhHYRHF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 13:07:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0161061058;
        Wed, 25 Aug 2021 17:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629911179;
        bh=d2lCqJb48k/VCROtiXDkkcJZlUlABGvCvA1gpbGnLCM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PXCH12JzYdNIEH4ZxijPfSTxWlaDJcGRJ56zW+dv/KG0byJ6s4GHTKGaMW8JgmW/0
         AvFa/7mngnhBvcFjsvMdplHef4kzyxGmfVRXz6WDbnhRTckfGrw35YRycS0bo8EVzy
         eLz7HAFW95G9mT22PHRUFQiHHZ0Y14WlN89ML01izv6GKHOzhNrjHz7DKcNAd3pfYV
         fvBrfUfZhXiST2kjRpZ2EQUD4lDz71Aviuuphrfw1bOSxlk1b4E+fcKXMCn1zRc6vY
         4dvlnhAQoUixCkUoyU4hSVtj7MKEdEdCvW6E3AmF9zPSjCiOXLr5JB9G44Ko8nftAY
         SxyKGul0wSRTQ==
Date:   Wed, 25 Aug 2021 10:06:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Zhongya Yan <yan2228598786@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, hengqi.chen@gmail.com,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH] net: tcp_drop adds `reason` parameter for tracing v2
Message-ID: <20210825100618.687eedae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iKkjtj68yksMg6fhpv2tZ9j2k0xgNK7S-wWi3e=XUrXmw@mail.gmail.com>
References: <20210825154043.247764-1-yan2228598786@gmail.com>
        <CANn89iJO8jzjFWvJ610TPmKDE8WKi8ojTr_HWXLz5g=4pdQHEA@mail.gmail.com>
        <20210825090418.57fd7d2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iKkjtj68yksMg6fhpv2tZ9j2k0xgNK7S-wWi3e=XUrXmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Aug 2021 09:20:37 -0700 Eric Dumazet wrote:
> On Wed, Aug 25, 2021 at 9:04 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed, 25 Aug 2021 08:47:46 -0700 Eric Dumazet wrote:  
> > > I'd rather use a string. So that we can more easily identify _why_ the
> > > packet was drop, without looking at the source code
> > > of the exact kernel version to locate line number 1057  
> >
> > Yeah, the line number seems like a particularly bad idea. Hopefully
> > strings won't be problematic, given we can expect most serious users
> > to feed the tracepoints via BPF. enum would be more convenient there,
> > I'd think.
> >  
> > > You can be sure that we will get reports in the future from users of
> > > heavily modified kernels.
> > > Having to download a git tree, or apply semi-private patches is a no go.  
> >
> > I'm slightly surprised by this angle. Are there downstream kernels with
> > heavily modified TCP other than Google's?  
> 
> Not sure why Google is mentioned here ?
> Have you ever received a public report about TCP behavior in a Google kernel ?

That's a rhetorical question quite likely, but to be clear - what 
I meant is that Google is the main contributor to Linux TCP and has 
the expertise to make changes. I don't know of any others hence the
question.

> Over the years, we received hundreds of TCP bug reports on
> netdev@vger, where users claim to use  kernel version 4.19 (or other),
> when in fact they use 4.19.xxx
> It takes in general multiple emails exchange before we get a more
> realistic version number.
> Not to mention distro kernels, or even worse private kernels, which
> are not exactly easy to track for us upstream developers.

Right but for backports values come from original patch, enum or string.

I don't mean to dispute your preference tho, if you want strings,
strings it is.
