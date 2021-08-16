Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336BE3ED1E7
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235568AbhHPKZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:25:28 -0400
Received: from mail-lf1-f41.google.com ([209.85.167.41]:44588 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbhHPKZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 06:25:27 -0400
Received: by mail-lf1-f41.google.com with SMTP id c24so33294352lfi.11;
        Mon, 16 Aug 2021 03:24:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Et6VdoqknhMfzcobUJoplG75MspKWGymXJPGsvIiMLY=;
        b=uN6n4Yrzj/lv2cCsu0jeI0GMVNrJ1bfXn7+vIeTxRxzQCpIJMksZS4t6jCxjnchMVd
         zRbFWC7CxTz6hWj+YqSjGBcifkF8A9aNba7Rps7/yffNYCbf5RTKo5ipiPEPAzjN8/Qo
         ePBjVQNOYfnJ+SgJpxMDZmdOF2r3Y2qD3goLdh0b2DBsryFas4Q1/GOnPKSMAMp3Cumf
         6A8gGUW4tGIC87DWhkY1QlGrQUGk1NulZy7jhZw9uVn69tsg4Vihi5uL+3sY5+mLMENh
         OmFdZVly5l4WHqzr5pHQGooXMRuEvZzYsIUTBnKSJqmRtF+h8pGi8MCJQO5PbX0+Fa0v
         1neQ==
X-Gm-Message-State: AOAM530xL5O7lBp5B0wQVxoUQGgKJ7suBEPFs2kI0TCMCyCAZAWXLAnM
        V5o9wF2YyNbrRE7jM14XGNQzRjCn3Zz0sqBceHk=
X-Google-Smtp-Source: ABdhPJyje7QhLUM20joBBX1lFLkwMFs6BjXVOogTkuAH00cOLmYzgVMsL5oeXMKauHWSiJ/y6yNatskiUiZcbyoJxVs=
X-Received: by 2002:ac2:5d27:: with SMTP id i7mr11140330lfb.488.1629109495252;
 Mon, 16 Aug 2021 03:24:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-3-mailhol.vincent@wanadoo.fr> <20210816084235.fr7fzau2ce7zl4d4@pengutronix.de>
In-Reply-To: <20210816084235.fr7fzau2ce7zl4d4@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 16 Aug 2021 19:24:43 +0900
Message-ID: <CAMZ6RqK5t62UppiMe9k5jG8EYvnSbFW3doydhCvp72W_X2rXAw@mail.gmail.com>
Subject: Re: [PATCH v5 2/7] can: bittiming: allow TDC{V,O} to be zero and add can_tdc_const::tdc{v,o,f}_min
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <Stefan.Maetje@esd.eu>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon. 16 Aug 2021 at 17:42, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 15.08.2021 12:32:43, Vincent Mailhol wrote:
> > ISO 11898-1 specifies in section 11.3.3 "Transmitter delay
> > compensation" that "the configuration range for [the] SSP position
> > shall be at least 0 to 63 minimum time quanta."
> >
> > Because SSP = TDCV + TDCO, it means that we should allow both TDCV and
> > TDCO to hold zero value in order to honor SSP's minimum possible
> > value.
> >
> > However, current implementation assigned special meaning to TDCV and
> > TDCO's zero values:
> >   * TDCV = 0 -> TDCV is automatically measured by the transceiver.
> >   * TDCO = 0 -> TDC is off.
> >
> > In order to allow for those values to really be zero and to maintain
> > current features, we introduce two new flags:
> >   * CAN_CTRLMODE_TDC_AUTO indicates that the controller support
> >     automatic measurement of TDCV.
> >   * CAN_CTRLMODE_TDC_MANUAL indicates that the controller support
> >     manual configuration of TDCV. N.B.: current implementation failed
> >     to provide an option for the driver to indicate that only manual
> >     mode was supported.
> >
> > TDC is disabled if both CAN_CTRLMODE_TDC_AUTO and
> > CAN_CTRLMODE_TDC_MANUAL flags are off, c.f. the helper function
> > can_tdc_is_enabled() which is also introduced in this patch.
>
> Nitpick: We can only say that TDC is disabled, if the driver supports
> the TDC interface at all, which is the case if tdc_const is set.

I would argue that saying that a device does not support TDC is
equivalent to saying that TDC is always disabled for that device.
Especially, the function can_tdc_is_enabled() can be used even if
the device does not support TDC (even if there is no benefit
doing so).

Do you still want me to rephrase this part?

> > Also, this patch adds three fields: tdcv_min, tdco_min and tdcf_min to
> > struct can_tdc_const. While we are not convinced that those three
> > fields could be anything else than zero, we can imagine that some
> > controllers might specify a lower bound on these. Thus, those minimums
> > are really added "just in case".
>
> I'm not sure, if we talked about the mcp251xfd's tcdo, valid values are
> -64...63.

Yes! Stefan shed some light on this. The mcp251xfd uses a tdco
value which is relative to the sample point.
| SSP = TDCV + absolute TDCO
|     = TDCV + SP + relative TDCO

Consequently:
| relative TDCO = absolute TDCO - SP

Which is also why TDCO can be negative.

I added an helper function can_tdc_get_relative_tdco() in the
fourth path of this series:
https://lore.kernel.org/linux-can/20210814091750.73931-5-mailhol.vincent@wanadoo.fr/T/#u

Devices which use the absolute TDCO can directly use
can_priv->tdc.tdco. Devices which use the relative TDCO such as
the mcp251xfd should use this helper function instead.

However, you will still need to convert the TDCO valid range from
relative values to absolute ones. In your case 0..127.


Yours sincerely,
Vincent
