Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D66B301DF2
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 18:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbhAXRii convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 24 Jan 2021 12:38:38 -0500
Received: from mail-lf1-f54.google.com ([209.85.167.54]:33355 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbhAXRic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 12:38:32 -0500
Received: by mail-lf1-f54.google.com with SMTP id v67so14513122lfa.0
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 09:38:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7g0YxH2zXtoVZezdMcpa2y0APkykfD37xoglV2/imsk=;
        b=om7Ce01+iAqsdYiuit8snb6I0K0HO4T8N26++gWZZsZCJV7tHM48rs2cYG3zAi5t7R
         h8WFr4nG1aiKZ1Ip11pi7WasVIABy4nNCg3V0yMLvePcnz49MLgVSFYd51je0Pk4MHzf
         W6+69xRqZPmGGuzSj+PiU5wW+xS7kU7vJAJ6yBSDK4IQ9qny36UMMpi1jFU1JgcYCCy8
         NYxIK41PEQDW7wsUai+xWx4vCx3Sy+mkUl9iCjby4JXAV8C+5yeOyaksYWgLFhhGjF7D
         PyaBByshpCtZoZfGXC+AWUSPIyuwdmYS9V3oZfVGxtO9SYYSNVQHhjyyhdR2wyDGZKaP
         7uuA==
X-Gm-Message-State: AOAM530BRl6I0Mtxs24aojmxcM759bEi3TiX3O8hXz0VWAlcyib+GH1z
        IyW0En1Ew9qHokZH1cuP9Un9B1xTFl4xQw==
X-Google-Smtp-Source: ABdhPJzyrSjqshcMFHietr8vyprgP0xGjJVHza7Bk74fkBq39iuTw2SvdOnqzIBO7L/WOKHfoyiOkw==
X-Received: by 2002:a19:8789:: with SMTP id j131mr260640lfd.382.1611509870355;
        Sun, 24 Jan 2021 09:37:50 -0800 (PST)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id g4sm1516560lfc.85.2021.01.24.09.37.50
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jan 2021 09:37:50 -0800 (PST)
Received: by mail-lf1-f46.google.com with SMTP id b26so14460976lff.9
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 09:37:50 -0800 (PST)
X-Received: by 2002:a19:7507:: with SMTP id y7mr1443988lfe.334.1611509870014;
 Sun, 24 Jan 2021 09:37:50 -0800 (PST)
MIME-Version: 1.0
References: <20210124155347.61959-1-bluca@debian.org> <5a165b08-9394-6c64-efe7-2f141b498b76@gmail.com>
In-Reply-To: <5a165b08-9394-6c64-efe7-2f141b498b76@gmail.com>
From:   Luca Boccassi <bluca@debian.org>
Date:   Sun, 24 Jan 2021 17:37:38 +0000
X-Gmail-Original-Message-ID: <CAMw=ZnTko4jf0GeLzPNQ1pz5ccZb6d+Rt1PgNSVmHVTMBtOixQ@mail.gmail.com>
Message-ID: <CAMw=ZnTko4jf0GeLzPNQ1pz5ccZb6d+Rt1PgNSVmHVTMBtOixQ@mail.gmail.com>
Subject: Re: [PATCH iproute2] iproute get: force rtm_dst_len to 32/128
To:     David Ahern <dsahern@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Jan 2021 at 17:26, David Ahern <dsahern@gmail.com> wrote:
>
> On 1/24/21 8:53 AM, Luca Boccassi wrote:
> > Since NETLINK_GET_STRICT_CHK was enabled, the kernel rejects commands
> > that pass a prefix length, eg:
> >
> >  ip route get `1.0.0.0/1
> >   Error: ipv4: Invalid values in header for route get request.
> >  ip route get 0.0.0.0/0
> >   Error: ipv4: rtm_src_len and rtm_dst_len must be 32 for IPv4
>
> Those are not the best responses from the kernel for the mask setting. I
> should have been clearer about src and dst masks.
>
> >
> > Since there's no point in setting a rtm_dst_len that we know is going
> > to be rejected, just force it to the right value if it's passed on
> > the command line.
> >
> > Bug-Debian: https://bugs.debian.org/944730
> > Reported-By: Clément 'wxcafé' Hertling <wxcafe@wxcafe.net>
> > Signed-off-by: Luca Boccassi <bluca@debian.org>
> > ---
> > As mentioned by David on:
> >
> > https://www.spinics.net/lists/netdev/msg624125.html
> >
> >  ip/iproute.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/ip/iproute.c b/ip/iproute.c
> > index ebb5f160..3646d531 100644
> > --- a/ip/iproute.c
> > +++ b/ip/iproute.c
> > @@ -2069,7 +2069,12 @@ static int iproute_get(int argc, char **argv)
> >                       if (addr.bytelen)
> >                               addattr_l(&req.n, sizeof(req),
> >                                         RTA_DST, &addr.data, addr.bytelen);
> > -                     req.r.rtm_dst_len = addr.bitlen;
> > +                     if (req.r.rtm_family == AF_INET)
> > +                             req.r.rtm_dst_len = 32;
> > +                     else if (req.r.rtm_family == AF_INET6)
> > +                             req.r.rtm_dst_len = 128;
> > +                     else
> > +                             req.r.rtm_dst_len = addr.bitlen;
> >                       address_found = true;
> >               }
> >               argc--; argv++;
> >
>
> Since the kernel used to blindly ignore the mask, having iproute2 fix it
> up seems acceptable.
>
> I think it would be good to educate the user about invalid settings as
> well - get them to fix scripts and mind set.

Sent v2 with a warning print to stderr.

Kind regards,
Luca Boccassi
