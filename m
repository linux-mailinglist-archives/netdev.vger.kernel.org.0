Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8633ED224
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235832AbhHPKlg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 16 Aug 2021 06:41:36 -0400
Received: from mail-lj1-f173.google.com ([209.85.208.173]:39558 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbhHPKlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 06:41:35 -0400
Received: by mail-lj1-f173.google.com with SMTP id q21so4892779ljj.6;
        Mon, 16 Aug 2021 03:41:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UAgKx9qFimpGqmGeQ3TM0J7Mzn3ZTYhunGpWKj3QW8E=;
        b=nyexwiSYDeAsM5rhwe390lHcZXxDORt6nUPfzaISmvlk41DyuGEucvb57xenctilfZ
         +iA02oMlVdWexn0FT3XK+IzBN157tuC0BE0hyeQadaq7rtYDpz1xszCrIZnb8mZAf909
         rj/sPDK6J9OAxnHEiWb8bh9dz0XCmgDFV19bWeu7hKU96aLLSP0qKJTz8nbK4e+NZgRw
         iSlqAgeISYZ6PA10HzkZw2XI+6ZLYxfzkDgtCXlwEWtJ2wBl4+tI3RrokeW38iBGD3TJ
         YDlR8hv5JDVwnQmqaFcB42oj5Qi1rIKqJBfAMXGFcP3m2HcfYe4UgAAgsJDYLAK+n7hc
         faCQ==
X-Gm-Message-State: AOAM530Y4xMGAieU3C90nfSMdRQyJ7Ku/OaEZvzfctD8+kfwE+AuJNdd
        /h5gctffoptOR966ig/t/1lfAxkKnpWbCrVkHLs=
X-Google-Smtp-Source: ABdhPJxsH8x3EfCOw+pbE7D3sXGxvSvKLrPv+OSgf3ha/r/wegNx+Ubs6UxpEeEqHJoV3c7h3WC3ycTLGRw8+iUhr8g=
X-Received: by 2002:a05:651c:24a:: with SMTP id x10mr10915127ljn.60.1629110463281;
 Mon, 16 Aug 2021 03:41:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210814101728.75334-1-mailhol.vincent@wanadoo.fr>
 <20210814101728.75334-5-mailhol.vincent@wanadoo.fr> <20210816081205.7rjdskaui35f3jml@pengutronix.de>
In-Reply-To: <20210816081205.7rjdskaui35f3jml@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 16 Aug 2021 19:40:52 +0900
Message-ID: <CAMZ6RqJiAO-snH0+NKi8=+xi9UnU3sJ+1Ze8qYL0qPwG4eRZVg@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] iplink_can: add new CAN FD bittiming parameters:
 Transmitter Delay Compensation (TDC)
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        linux-can <linux-can@vger.kernel.org>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon. 16 août 2021 at 17:12, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 14.08.2021 19:17:28, Vincent Mailhol wrote:
> > At high bit rates, the propagation delay from the TX pin to the RX pin
> > of the transceiver causes measurement errors: the sample point on the
> > RX pin might occur on the previous bit.
> >
> > This issue is addressed in ISO 11898-1 section 11.3.3 "Transmitter
> > delay compensation" (TDC).
> >
> > This patch brings command line support to nine TDC parameters which
> > were recently added to the kernel's CAN netlink interface in order to
> > implement TDC:
> >   - IFLA_CAN_TDC_TDCV_MIN: Transmitter Delay Compensation Value
> >     minimum value
> >   - IFLA_CAN_TDC_TDCV_MAX: Transmitter Delay Compensation Value
> >     maximum value
> >   - IFLA_CAN_TDC_TDCO_MIN: Transmitter Delay Compensation Offset
> >     minimum value
> >   - IFLA_CAN_TDC_TDCO_MAX: Transmitter Delay Compensation Offset
> >     maximum value
> >   - IFLA_CAN_TDC_TDCF_MIN: Transmitter Delay Compensation Filter
> >     window minimum value
> >   - IFLA_CAN_TDC_TDCF_MAX: Transmitter Delay Compensation Filter
> >     window maximum value
> >   - IFLA_CAN_TDC_TDCV: Transmitter Delay Compensation Value
> >   - IFLA_CAN_TDC_TDCO: Transmitter Delay Compensation Offset
> >   - IFLA_CAN_TDC_TDCF: Transmitter Delay Compensation Filter window
> >
> > All those new parameters are nested together into the attribute
> > IFLA_CAN_TDC.
> >
> > A tdc-mode parameter allow to specify how to operate. Valid options
> > are:
> >
> >   * auto: the transmitter automatically measures TDCV. As such, TDCV
> >     values can not be manually provided. In this mode, the user must
> >     specify TDCO and may also specify TDCF if supported.
> >
> >   * manual: Use the TDCV value provided by the user are used. In this
>                            ^^^^^                      ^^^
>                            singular                   plural

ACK. I fixed that broken grammar in my local branch. As commented
before, I will send the next version of the iproute series after
we agree on the kernel part (unless someone finds a major issue).

FYI, this is the fixed sentence:
  * manual: use a static TDCV provided by the user. In this mode, the
    user must specify both TDCV and TDCO and may also specify TDCF if
    supported.


Yours sincerely,
Vincent
