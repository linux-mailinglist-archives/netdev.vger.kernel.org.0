Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 180583AC8B7
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 12:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbhFRKZh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Jun 2021 06:25:37 -0400
Received: from mail-lf1-f49.google.com ([209.85.167.49]:37720 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbhFRKZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 06:25:35 -0400
Received: by mail-lf1-f49.google.com with SMTP id p7so15746042lfg.4;
        Fri, 18 Jun 2021 03:23:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5lJmmJOJ0EpO1wHCkdkF75XWhHVKX9ri+BWC0WJ2EQw=;
        b=Ep/eNkcTj/d/8jRI1yZK5IA8g9VfmdYQ9Wcca/W1ED9xABA47sa9fweFAPlzcDithF
         +0szjC+a+bYjASfu1orlrwL3zrM2LSr3NWmVcDnuk7Bfoc00UxQfYxTgEkCK+/eBT82c
         E5RhiqVEqoeU4P7ZfovZGo628eiNl7uCxyGh5AnSOAhrqM+Htj5uZVc+/NLjxQunFHBw
         NIwVflxk7+6pM5W3pLGux2Zb0AymjSGVEc2AL2jnQRahCFt10EVDD0rbJBCp7nllYLYd
         Ey0Tn0D0QLi+IZXnV4pTbKhE5Kxi9Nz+MCawtpr6WnCZm1tjL965JiDAV0fdOVRGeCwM
         9LoQ==
X-Gm-Message-State: AOAM531R+8eVj4GOW98J9S10JQufBvKLg9ZhA5oLevz7VYU8C1h44OKg
        kaberNXr/wNNBha9nPCNOG1HAFF6+q3jS9xW325sryhiVNHOjA==
X-Google-Smtp-Source: ABdhPJxu0U3/fdgUjqtjiKDOznPc1uqGUEsxMpfFbCXKZKNzpnrMKwzgrMcx0eMrXd9N5L48P33fEyaKk6bhExsfeTM=
X-Received: by 2002:a05:6512:3d08:: with SMTP id d8mr2579457lfv.393.1624011804126;
 Fri, 18 Jun 2021 03:23:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210603151550.140727-1-mailhol.vincent@wanadoo.fr>
 <20210603151550.140727-3-mailhol.vincent@wanadoo.fr> <20210618093424.xohvsqaaq5qf2bjn@pengutronix.de>
In-Reply-To: <20210618093424.xohvsqaaq5qf2bjn@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 18 Jun 2021 19:23:12 +0900
Message-ID: <CAMZ6RqJn5z-9PfkcJdiS6aG+qCPnifXDwH26ZEwo8-=id=TXbw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] can: netlink: add interface for CAN-FD Transmitter
 Delay Compensation (TDC)
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri. 18 Jun 2021 at 18:34, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 04.06.2021 00:15:50, Vincent Mailhol wrote:
> > Add the netlink interface for TDC parameters of struct can_tdc_const
> > and can_tdc.
> >
> > Contrary to the can_bittiming(_const) structures for which there is
> > just a single IFLA_CAN(_DATA)_BITTMING(_CONST) entry per structure,
> > here, we create a nested entry IFLA_CAN_TDC. Within this nested entry,
> > additional IFLA_CAN_TDC_TDC* entries are added for each of the TDC
> > parameters of the newly introduced struct can_tdc_const and struct
> > can_tdc.
> >
> > For struct can_tdc_const, these are:
> >         IFLA_CAN_TDC_TDCV_MAX
> >         IFLA_CAN_TDC_TDCO_MAX
> >         IFLA_CAN_TDC_TDCF_MAX
> >
> > For struct can_tdc, these are:
> >         IFLA_CAN_TDC_TDCV
> >         IFLA_CAN_TDC_TDCO
> >         IFLA_CAN_TDC_TDCF
>
> I just noticed in the mcp2518fd data sheet:
>
> | bit 14-8 TDCO[6:0]: Transmitter Delay Compensation Offset bits;
> | Secondary Sample Point (SSP) Two’s complement; offset can be positive,
> | zero, or negative.
> |
> | 011 1111 = 63 x TSYSCLK
> | ...
> | 000 0000 = 0 x TSYSCLK
> | ...
> | 111 1111 = –64 x TSYSCLK
>
> Have you takes this into account?

I have not. And I fail to understand what would be the physical
meaning if TDCO is zero or negative.

TDCV indicates the position of the bit start on the RX pin. If
TDCO is zero, the measurement occurs on the bit start when all
the ringing occurs. That is a really bad choice to do the
measurement.  If it is negative, it means that you are measuring
the previous bit o_O !?

Maybe I am missing something but I just do not get it.

I believe you started to implement the mcp2518fd. Can you force a
zero and a negative value and tell me if the bus is stable?


Yours sincerely,
Vincent Mailhol
