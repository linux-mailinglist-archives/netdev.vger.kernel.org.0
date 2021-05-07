Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB383763E6
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 12:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236907AbhEGKg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 06:36:27 -0400
Received: from mail-yb1-f177.google.com ([209.85.219.177]:36600 "EHLO
        mail-yb1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234057AbhEGKgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 06:36:25 -0400
Received: by mail-yb1-f177.google.com with SMTP id m9so11340629ybm.3;
        Fri, 07 May 2021 03:35:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yslg7vEBym6PVgYau7ulcdvMRd5JUNvV93PwWncFI8g=;
        b=sZWgeqAT93ImrlAJKPS4BY5rSLh5oWMZM9ELqm6vp0aPCsofAvvWLlNm2ZjlMtG4FX
         4uPKTc0/A582S1GsqeFUeknqtmjw9PRKDv7qFuFsTfEeeLrPF8/6UbCl0x3KliQiCrhz
         V3orwaHemyPu7LO5/AM2AXedkR/yTTW5pnlLTcTCdajHDNUGuLG5pvGmsbvl5XyX/dNJ
         7fDaloH95M9F4fZGGBIu4rro1WFVXLyMW46v4S/1Lqjbtp4O4xrofyIonA9Lw7H1i2AL
         GZxeY5o4FSEuU6xa+RWrtuA3xTfbHTWsUDPCK7yMBU7Qy/FdjOTsQ7wsp7tYqBKMpOA5
         Ea/w==
X-Gm-Message-State: AOAM533a3FO1D3C1GfH4XV9ljOW0sd7rG6/a/3hpuSxob+5jwzZMvFb5
        1BNkrb1zNxu7DRrT6PnhFwB0G6aUEOJyxNmiYcv8kDhwB/c=
X-Google-Smtp-Source: ABdhPJyu2QYYWeFVD/sK/TxxJTSyYebJub9VNO4EBWsiDWURGYT1ClwQdNiIsEXSGG3rQ/QnDslzXYPYSDiM6ow3JYc=
X-Received: by 2002:a25:7a02:: with SMTP id v2mr12118642ybc.514.1620383725249;
 Fri, 07 May 2021 03:35:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210506112007.1666738-1-mailhol.vincent@wanadoo.fr>
 <20210506112007.1666738-2-mailhol.vincent@wanadoo.fr> <20210506085035.2fc33bf3@hermes.local>
In-Reply-To: <20210506085035.2fc33bf3@hermes.local>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 7 May 2021 19:35:14 +0900
Message-ID: <CAMZ6RqLcbF2riaMiOPHD4T-A0yQmrr--4moPT1iLz11h2yf3xA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 1/1] iplink_can: add new CAN FD bittiming
 parameters: Transmitter Delay Compensation (TDC)
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri. 7 Mai 2021 at 00:50, Stephen Hemminger
<stephen@networkplumber.org> wrote:
> On Thu,  6 May 2021 20:20:07 +0900
> Vincent Mailhol <mailhol.vincent@wanadoo.fr> wrote:
>
> > +     if (tb[IFLA_CAN_TDC_TDCV] && tb[IFLA_CAN_TDC_TDCO] &&
> > +         tb[IFLA_CAN_TDC_TDCF]) {
> > +             __u32 *tdcv = RTA_DATA(tb[IFLA_CAN_TDC_TDCV]);
> > +             __u32 *tdco = RTA_DATA(tb[IFLA_CAN_TDC_TDCO]);
> > +             __u32 *tdcf = RTA_DATA(tb[IFLA_CAN_TDC_TDCF]);
> > +
> > +             if (is_json_context()) {
> > +                     open_json_object("tdc");
> > +                     print_int(PRINT_JSON, "tdcv", NULL, *tdcv);
> > +                     print_int(PRINT_JSON, "tdco", NULL, *tdco);
> > +                     print_int(PRINT_JSON, "tdcf", NULL, *tdcf);
> > +                     close_json_object();
> > +             } else {
> > +                     fprintf(f, "\n    tdcv %d tdco %d tdcf %d",
> > +                             *tdcv, *tdco, *tdcf);
> > +             }
> > +     }
> > +
>
> The most common pattern in iproute2 is to let json/non-json be decided
> inside the print routine.  I search for all instances of fprintf as
> indication of broken code. Also these are not signed values so please
> print unsigned.  The code should use print_nl() to handle the single line
> case. Also, there is helper to handle

Thanks for pointing out the issues!  For my defence, all the
existing code of ip/iplink_can.c shares the exact same issues and
I just repeated those without using my brain...

I just sent a new v2 which fixes your remarks on both the
existing code and the new code introduced in my patch.

> Something like:
>               __u32 tdc = rte_getattr_u32(tb[IFLA_CAN_TDC_TDCV]);
>
>                 open_json_object("tdc");
>                 print_nl();
>                 print_u32(PRINT_ANY, "tdcv", "    tdcv %u", tdcv);

There is no print_u32 in iproute2. I guess you meant print_uint(). :)


Yours sincerely,
Vincent
