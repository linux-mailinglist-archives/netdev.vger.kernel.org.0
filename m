Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E37358556
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 15:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhDHNzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 09:55:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28006 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229964AbhDHNzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 09:55:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617890124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WdG/+9H4BfauINLjbcdnfsK7R+CRfSR/z4xwYKN7yqw=;
        b=gqRV0DNSkSaGGO0ZTfvv0+WbfIRbiN+y5HgbhihjOzkNrAN9zmtgi9HzvGJERzOf2U/ggI
        otWLVM9fupbK4m7EXqXRJv+9hULtXatNMkXI2YrbO6hLHMmTWdE2NSwrEW5L5tS8FuUCV1
        7arkgnaFVkm/Nxm03GTItwwpyU7kjKA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-EA4COy0TPxiNml6Gmkhlzg-1; Thu, 08 Apr 2021 09:55:22 -0400
X-MC-Unique: EA4COy0TPxiNml6Gmkhlzg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FF048030A1;
        Thu,  8 Apr 2021 13:55:21 +0000 (UTC)
Received: from ovpn-113-96.phx2.redhat.com (ovpn-113-96.phx2.redhat.com [10.3.113.96])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EB0360BF1;
        Thu,  8 Apr 2021 13:55:16 +0000 (UTC)
Message-ID: <c47d99b9d0efeea4e6cd238c2affc0fbe296b53c.camel@redhat.com>
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
From:   Simo Sorce <simo@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Date:   Thu, 08 Apr 2021 09:55:15 -0400
In-Reply-To: <CAHmME9p40M5oHDZXnFDXfO4-JuJ7bUB5BnsccGV1pksguz73sg@mail.gmail.com>
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
         <CAHmME9p40M5oHDZXnFDXfO4-JuJ7bUB5BnsccGV1pksguz73sg@mail.gmail.com>
Organization: Red Hat, Inc.
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-04-07 at 15:15 -0600, Jason A. Donenfeld wrote:
> Hi Hangbin,
> 
> On Wed, Apr 7, 2021 at 5:39 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
> > As the cryptos(BLAKE2S, Curve25519, CHACHA20POLY1305) in WireGuard are not
> > FIPS certified, the WireGuard module should be disabled in FIPS mode.
> 
> I'm not sure this makes so much sense to do _in wireguard_. If you
> feel like the FIPS-allergic part is actually blake, 25519, chacha, and
> poly1305, then wouldn't it make most sense to disable _those_ modules
> instead? And then the various things that rely on those (such as
> wireguard, but maybe there are other things too, like
> security/keys/big_key.c) would be naturally disabled transitively?

The reason why it is better to disable the whole module is that it
provide much better feedback to users. Letting init go through and then
just fail operations once someone tries to use it is much harder to
deal with in terms of figuring out what went wrong.
Also wireguard seem to be poking directly into the algorithms
implementations and not use the crypto API, so disabling individual
algorithm via the regular fips_enabled mechanism at runtime doesn't
work.

> [As an aside, I don't think any of this fips-flag-in-the-kernel makes
> much sense at all for anything, but that seems like a different
> discussion, maybe?]

It makes sense, because vendors provide a single kernel that can be
used by both people that are required to be FIPS compliant and people
that don't. For people that are required to be FIPS complaint vendors
want to provide the ability to use a single knob (fips=1 at boot) to
turn off everything that is not FIPS compliant.
Disabling algorithms at compile time would not work for people that do
not care about FIPS compliance.

HTH,
Simo.

-- 
Simo Sorce
RHEL Crypto Team
Red Hat, Inc




