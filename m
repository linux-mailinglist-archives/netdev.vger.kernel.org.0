Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE5FC38B4
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 17:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388916AbfJAPQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 11:16:19 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37414 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727185AbfJAPQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 11:16:19 -0400
Received: by mail-io1-f68.google.com with SMTP id b19so20803426iob.4
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 08:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e0PgULxTe+K5h7TV89WIY5dseHPRzbGe/3pdYRZTTOc=;
        b=a1yD6VH7mVK4bFkEPj0DXpaTvvQn1JlZ3iOXmqt1IhCwHgZXrhsIP4t92kPJDR73WK
         UlkeHLM72pK8ixvkzD3mwv/1xiAduQHtwgt6QNH1AW1rGRCIFw4o1n2fcAd6MP/hrtgy
         KQxc6aYn2FcHx64/eQZCWaMGDvPqhY3sOomv0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e0PgULxTe+K5h7TV89WIY5dseHPRzbGe/3pdYRZTTOc=;
        b=CzQGyhqlnrsisZogVzban3LTS85SL6kLcQmCG9prml3gpCSzpRTRKb2gkN9R67n9Qg
         x795BGPJlCnhs2prP+hILu1VSGOkg2cJ2PHUzGhu6EGb0dj+y+UGtMGGAPf+tNKbCpb+
         nmFLCD0iyhq8FARCx/ZORrq3PrNvPqfhQkf7RGCjOfMI2s7QJyD5aM6qs2oMcoRt01AN
         3rEeVMKLU/F2d7s++C5BliH9LT8ixaeFHkMeLqPd/xycYODxw39z5LBbkmMi9GfaMfp0
         pikl35lp89SbaAOjcgNChiDDIaztcXXD0nWOGiEDTFA511/a4eQa7vBjMcQfmIG7fpnU
         favw==
X-Gm-Message-State: APjAAAUGIujngVAnnv89k65k2ILT8S9LiJU7fW6WNFJF31U1wA5NsL7C
        vxdEKHdE9J77dyedblk/zWw28CHuH2QFxck4OJi6
X-Google-Smtp-Source: APXvYqzD9N3TvWrqK5HBa8CYndepsrsF1PiwukwwUNsVBgfsKGuBGIaohtHUoAOAd5b9XmtWvx47w9WC9ToLLgSgTHY=
X-Received: by 2002:a5d:8c97:: with SMTP id g23mr4153081ion.184.1569942978535;
 Tue, 01 Oct 2019 08:16:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190926152934.9121-1-julien@cumulusnetworks.com> <ba5f6b14-1740-b9ba-c100-5272765fbef4@gmail.com>
In-Reply-To: <ba5f6b14-1740-b9ba-c100-5272765fbef4@gmail.com>
From:   Julien Fortin <julien@cumulusnetworks.com>
Date:   Tue, 1 Oct 2019 17:16:07 +0200
Message-ID: <CAM_1_Kz_xHSODDa51=_GyPuTMoyXZDM-idpQc9-dmCsjJYj_7A@mail.gmail.com>
Subject: Re: [PATCH iproute2(-next) v2 1/1] ip: fix ip route show json output
 for multipath nexthops
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@cumulusnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks David!

On Tue, Oct 1, 2019 at 5:14 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 9/26/19 9:29 AM, Julien Fortin wrote:
> > From: Julien Fortin <julien@cumulusnetworks.com>
> >
> > print_rta_multipath doesn't support JSON output:
> >
> > {
> >     "dst":"27.0.0.13",
> >     "protocol":"bgp",
> >     "metric":20,
> >     "flags":[],
> >     "gateway":"169.254.0.1"dev uplink-1 weight 1 ,
> >     "flags":["onlink"],
> >     "gateway":"169.254.0.1"dev uplink-2 weight 1 ,
> >     "flags":["onlink"]
> > },
> >
> > since RTA_MULTIPATH has nested objects we should print them
> > in a json array.
> >
> > With the path we have the following output:
> >
> > {
> >     "flags": [],
> >     "dst": "36.0.0.13",
> >     "protocol": "bgp",
> >     "metric": 20,
> >     "nexthops": [
> >         {
> >             "weight": 1,
> >             "flags": [
> >                 "onlink"
> >             ],
> >             "gateway": "169.254.0.1",
> >             "dev": "uplink-1"
> >         },
> >         {
> >             "weight": 1,
> >             "flags": [
> >                 "onlink"
> >             ],
> >             "gateway": "169.254.0.1",
> >             "dev": "uplink-2"
> >         }
> >     ]
> > }
> >
> > Fixes: 663c3cb23103f4 ("iproute: implement JSON and color output")
> >
> > Signed-off-by: Julien Fortin <julien@cumulusnetworks.com>
> > ---
> >  ip/iproute.c | 46 ++++++++++++++++++++++++++++------------------
> >  1 file changed, 28 insertions(+), 18 deletions(-)
> >
>
> applied to iproute2-next. Thanks
>
> Stephen: I see only 1 place (mdb) that prints devices with color, so
> that can be done across all of the commands by a follow up.
>
