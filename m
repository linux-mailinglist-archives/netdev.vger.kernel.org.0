Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6D635A33A
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 18:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbhDIQ0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 12:26:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48559 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233674AbhDIQ0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 12:26:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617985590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A+XNjjMj7uKb6cWyQ0FNy1WHSr2ChCgb+eT313GmatE=;
        b=bvno+QVYXJIwnSNPN5kftbyrvfRjCm58I2a/HMrEdQe8ggtonWgGAPCH3bVTRyREh7oZWx
        Cmptk5BklGcdFGJ1AyRzTGGinqVDmv2A7JN8mDEbIOWZWjflZLhJuijTqtABcTePwdLrJM
        1WytsODND+LUEKOnRLB27Y1NY67WGj0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-70dw0YHIOQq_ivsp5kp6fg-1; Fri, 09 Apr 2021 12:26:27 -0400
X-MC-Unique: 70dw0YHIOQq_ivsp5kp6fg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CE1B10054F6;
        Fri,  9 Apr 2021 16:26:26 +0000 (UTC)
Received: from ovpn-112-53.phx2.redhat.com (ovpn-112-53.phx2.redhat.com [10.3.112.53])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B6A4B5C1D5;
        Fri,  9 Apr 2021 16:26:24 +0000 (UTC)
Message-ID: <2ab19b062cf61cf6f54e7f0145c8d6fd77aee5ed.camel@redhat.com>
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
From:   Simo Sorce <simo@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>,
        Stephan Mueller <smueller@chronox.de>
Cc:     Eric Biggers <ebiggers@kernel.org>, netdev@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        linux-crypto@vger.kernel.org
Date:   Fri, 09 Apr 2021 12:26:23 -0400
In-Reply-To: <20210409080804.GO2900@Leo-laptop-t470s>
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
         <YG4gO15Q2CzTwlO7@quark.localdomain>
         <20210408010640.GH2900@Leo-laptop-t470s>
         <20210408115808.GJ2900@Leo-laptop-t470s> <YG8dJpEEWP3PxUIm@sol.localdomain>
         <20210409021121.GK2900@Leo-laptop-t470s>
         <7c2b6eff291b2d326e96c3a5f9cd70aa4ef92df3.camel@chronox.de>
         <20210409080804.GO2900@Leo-laptop-t470s>
Organization: Red Hat, Inc.
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-04-09 at 16:08 +0800, Hangbin Liu wrote:
> On Fri, Apr 09, 2021 at 09:08:20AM +0200, Stephan Mueller wrote:
> > > > > > > And how do you handle all the other places in the kernel that use
> > > > > > > ChaCha20 and
> > > > > > > SipHash?  For example, drivers/char/random.c?
> > > > > > 
> > > > > > Good question, I will check it and reply to you later.
> > > > > 
> > > > > I just read the code. The drivers/char/random.c do has some fips
> > > > > specific
> > > > > parts(seems not related to crypto). After commit e192be9d9a30 ("random:
> > > > > replace
> > > > > non-blocking pool with a Chacha20-based CRNG") we moved part of chacha
> > > > > code to
> > > > > lib/chacha20.c and make that code out of control.
> > > > > 
> > > > So you are saying that you removed drivers/char/random.c and
> > > > lib/chacha20.c from
> > > > your FIPS module boundary?  Why not do the same for WireGuard?
> > > 
> > > No, I mean this looks like a bug (using not allowed crypto in FIPS mode) and
> > > we should fix it.
> > 
> > The entirety of random.c is not compliant to FIPS rules. ChaCha20 is the least
> > of the problems. SP800-90B is the challenge. This is one of the motivation of
> > the design and architecture of the LRNG allowing different types of crypto and
> > have a different approach to post-process the data.
> > 
> > https://github.com/smuellerDD/lrng
> 
> Thanks Stephan for this info. After offline discussion with Herbert, here is
> what he said:
> 
> """
> This is not a problem in RHEL8 because the Crypto API RNG replaces /dev/random
> in FIPS mode.
> """
> 
> I'm not familiar with this code, not sure how upstream handle this.

It is an open problem upstream.

Simo.

-- 
Simo Sorce
RHEL Crypto Team
Red Hat, Inc




