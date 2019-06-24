Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F098851D2F
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 23:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbfFXVhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 17:37:47 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37192 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728925AbfFXVhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 17:37:42 -0400
Received: by mail-ed1-f67.google.com with SMTP id w13so23848118eds.4
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 14:37:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iEMJd9rrUanMl1AnDSEWdEtDu8Y2dbHTCGwIuEN1mlA=;
        b=TD4I4ppWd9jUVJEM7JuT/BC7NotLwM5MthZPwF2YtG9KDZxKPSHR2C4RW6zoTO/mSC
         XUP4OiwgBWpfp0cem+hZEAa7ueo+AmhRJXcXBEDVUmH9dpGCruH01//V79izdS5jS6Tl
         qFal7zLmTv7xVyxno2ASwiVPyyTt2o5L8QgIMlfEAng8tTwZ0+HrjbcCqAeR84FJR1V0
         4aCx6IL+YyEkITfV0DHY2eRnnYRYcSFKXu9ucAjF8IdKRlDwRleJV3PKGUK9SYm2Q0yj
         JVtPug516GNyU1DBXJac80iNG32w2+PN4mZ9i4zx/wP3WCbF9G4EpQ8VBLXtSUjMY5rf
         HzMg==
X-Gm-Message-State: APjAAAUcRoHl+57+rd+eVAm9BbewRURUKOLJyX4HvAoXPDSyhylD+cwg
        +4NhbGodpdFWEwK5sbdu1a5JBnaai5i46DtDGRqH7A==
X-Google-Smtp-Source: APXvYqxIFpQ/09upPuco6SVGrowuEMPLt1M+DjTVRrR+2yC4AXZ24bYiQO2iseviQQy9r4vN6X5gM8SR72hELrw+rig=
X-Received: by 2002:a17:906:a308:: with SMTP id j8mr82536076ejz.167.1561412260731;
 Mon, 24 Jun 2019 14:37:40 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1561394228.git.aclaudi@redhat.com> <20190624102041.25224fae@hermes.lan>
In-Reply-To: <20190624102041.25224fae@hermes.lan>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Mon, 24 Jun 2019 23:38:28 +0200
Message-ID: <CAPpH65wG9OXhEnXd2LrL0wQc9P4G7MKQjQ4bUTHN1CVqAc6bMg@mail.gmail.com>
Subject: Re: [PATCH iproute2 0/3] do not set IPv6-only options on IPv4 addresses
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 7:21 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon, 24 Jun 2019 19:05:52 +0200
> Andrea Claudi <aclaudi@redhat.com> wrote:
>
> > 'home', 'nodad' and 'mngtmpaddr' options are IPv6-only, but
> > it is possible to set them on IPv4 addresses, too. This should
> > not be possible.
> >
> > Fix this adding a check on the protocol family before setting
> > the flags, and exiting with invarg() on error.
> >
> > Andrea Claudi (3):
> >   ip address: do not set nodad option for IPv4 addresses
> >   ip address: do not set home option for IPv4 addresses
> >   ip address: do not set mngtmpaddr option for IPv4 addresses
> >
> >  ip/ipaddress.c | 15 ++++++++++++---
> >  1 file changed, 12 insertions(+), 3 deletions(-)
> >
>
> Maybe this should be a warning, not a failure.
> A little concerned that there will be some user with a scripted setup
> that this breaks.

Hi Stephen,
I think that if a script wrongly uses some of these flags on a IPv4
address, it most probably operates on an unexpected address, since
everyone is aware that these flags are IPv6 only. In other words we
are breaking a scripted setup that is already broken.
In this case it's probably worth exiting with error and give the
author the chance to fix the script, otherwise the error can go
unnoticed.

If you prefer, I can send a v2 with warnings instead of errors, just
let me know.

Regards,
Andrea
