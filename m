Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C3C359F0D
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 14:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbhDIMr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 08:47:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44650 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231946AbhDIMr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 08:47:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617972432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NQ5R2T8qFwf/2wrATCUkhLL2GL2aMOUO18RupDBYC9c=;
        b=HAEKC+PN6YHh350Y7LKTl9guQsrxYrEY86FtwKdouNMxc8ni/fGLxiyNDfuFEYJvyDDoa1
        yPlDy6Hzdrfv2j2Vq3vBBipbXFy39GsNc+bytcC3BTRJcyITgCWNez+IKkkAOl1GlahFYf
        5vF9diUBMIkRt1AdOT7vq4JPyOkEE3I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-yWB4A258PCOomfXYG54EIg-1; Fri, 09 Apr 2021 08:47:08 -0400
X-MC-Unique: yWB4A258PCOomfXYG54EIg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5CB1F107ACC7;
        Fri,  9 Apr 2021 12:47:07 +0000 (UTC)
Received: from ovpn-112-53.phx2.redhat.com (ovpn-112-53.phx2.redhat.com [10.3.112.53])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2480C10013C1;
        Fri,  9 Apr 2021 12:47:03 +0000 (UTC)
Message-ID: <0ef180dea02996fc5f4660405f2333220e8ae4c4.camel@redhat.com>
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
From:   Simo Sorce <simo@redhat.com>
To:     Ard Biesheuvel <ardb@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Date:   Fri, 09 Apr 2021 08:47:02 -0400
In-Reply-To: <CAMj1kXG-e_NtLkAdLYp70x5ft_Q1Bn9rmdXs4awt7FEd5PQ4+Q@mail.gmail.com>
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
         <CAHmME9p40M5oHDZXnFDXfO4-JuJ7bUB5BnsccGV1pksguz73sg@mail.gmail.com>
         <c47d99b9d0efeea4e6cd238c2affc0fbe296b53c.camel@redhat.com>
         <CAHmME9pRSOANrdvegLm9x8VTNWKcMtoymYrgStuSx+nsu=jpwA@mail.gmail.com>
         <20210409024143.GL2900@Leo-laptop-t470s>
         <CAHmME9oqK9iXRn3wxAB-MZvX3k_hMbtjHF_V9UY96u6NLcczAw@mail.gmail.com>
         <20210409024907.GN2900@Leo-laptop-t470s> <YG/EAePSEeYdonA0@zx2c4.com>
         <CAMj1kXG-e_NtLkAdLYp70x5ft_Q1Bn9rmdXs4awt7FEd5PQ4+Q@mail.gmail.com>
Organization: Red Hat, Inc.
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-04-09 at 08:02 +0200, Ard Biesheuvel wrote:
> On Fri, 9 Apr 2021 at 05:03, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > On Fri, Apr 09, 2021 at 10:49:07AM +0800, Hangbin Liu wrote:
> > > On Thu, Apr 08, 2021 at 08:44:35PM -0600, Jason A. Donenfeld wrote:
> > > > Since it's just a normal module library, you can simply do this in the
> > > > module_init function, rather than deep within registration
> > > > abstractions.
> > > 
> > > I did a try but looks it's not that simple. Not sure if it's because wireguard
> > > calls the library directly. Need to check more...
> > 
> > Something like the below should work...
> > 
> 
> The below only works if all the code is modular. initcall return
> values are ignored for builtin code, and so the library functions will
> happily work regardless of fips_enabled, and there is generally no
> guarantee that no library calls can be made before the initcall() is
> invoked.
> 
> For ordinary crypto API client code, the algorithm in question may be
> an a priori unknown, and so the only sensible place to put this check
> is where the algorithms are registered or instantiated.
> 
> For code such as WireGuard that is hardwired to use a single set of
> (forbidden! :-)) algorithms via library calls, the simplest way to do
> this securely is to disable the whole thing, even though I agree it is
> not the most elegant solution.
> 
> If we go with Jason's approach, we would need to mandate each of these
> drivers can only be built as a module if the kernel is built with
> FIPS-200 support. This is rather trivial by itself, i.e.,
> 
>   depends on m || !CRYPTO_FIPS
> 
> but I am a bit concerned that the rather intricate kconfig
> dependencies between the generic and arch-optimized versions of those
> drivers get complicated even further.

Actually this is the opposite direction we are planning to go for
future fips certifications.

Due to requirements about crypto module naming and versioning in the
new FIPS-140-3 standard we are planning to always build all the CRYPTO
as bultin (and maybe even forbid loading additional crypto modules in
FIPS mode). This is clearly just a vendor choice and has no bearing on
what upstream ultimately will do, but just throwing it here as a data
point.

Plus, as you note, it would overly complicate the interfaces.

As much as the check in wireguard is inelegant, it is much simpler to
understand and is not invasive.

Simo.

-- 
Simo Sorce
RHEL Crypto Team
Red Hat, Inc




