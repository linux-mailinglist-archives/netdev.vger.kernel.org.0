Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7915890C7
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 18:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236321AbiHCQth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 12:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbiHCQtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 12:49:36 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447E324F1C;
        Wed,  3 Aug 2022 09:49:35 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id e13so3281195edj.12;
        Wed, 03 Aug 2022 09:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=gMmZnysqAMDlPpkxFBQS+E8RqY1hDuJMvV7H1So3zZU=;
        b=fhEdIhwTAqr5KeMUsYt/g8y6eT/BUynpWSzIPFItnbEjKFFqMBLYTgs5XuAqfq3tyZ
         EYeZYA/AYwdnRfgqp+fgGhnOz/akfNg8ElRIcGgFLoM6P7Sh9PrfCqrPc4QGi0Ao63NA
         Ulf0teM0yTHHKi9LehM+or72eui6A1vu3+yPKFdH6EfbEizSdmJgEfyAdLwZBHfHH8Ia
         ve0/Bzg9LzCcnf+LvHi9mV+5ejPUvbfYgoOxnYUCe5jo2rPewOwJ7JU5vQciDUHqHXRz
         udkbu4ioZwhsPfGd9K2qJD5PlB2TreLjQ9ZSOmb4EUzeaTPeyTzcTqkpbdN73eGHBXDF
         xCdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=gMmZnysqAMDlPpkxFBQS+E8RqY1hDuJMvV7H1So3zZU=;
        b=DKPfQtXcFsM4XkUqaBNVYk6PMcWSOwb4BjKQI4AQH5tZGXwZP/qdwsQhKb85FA2dXA
         iJuLTWRxfZOZH8+2l1pH3DBum64Eq4t6kkHA2OS4GP1dbh71Ru+T3kbmarFs8FWmeYNy
         NnOsxSUXTc8kDdM+w0UUZrqruHxQsC62TxjC+mN/17HKoxBWcAFx/H4YcLYY+rxoyHYU
         V7Wx/YmUyTheT6mbkt0M67tb9LUA0EqtAO71TRRvRv1rzco9TA6RUPZnUfrfya+t/jzn
         lvudjFPgVqoS1fv9KD/bpxVXFxzoCCsmueOCma/c9xTXTQWuz8MocTNVwLmwsH1vBXyZ
         ZICA==
X-Gm-Message-State: AJIora8b4X1stPGQc7dLli1CAvqP1aOF/rGZYr9JfueBbRqdcfl8xXy2
        BrsIjLEWZ1YlxMYIF9FTGkLUOe5TROrmX6cau3w=
X-Google-Smtp-Source: AGRyM1v5EszzSbNUHQJzbLHITpO5Y70v2pRK2Y37tgwqpBBiHlh4sib+QbUmmDUY/fQdfuftn7OIIkS70+ixk/gqlhc=
X-Received: by 2002:a05:6402:4414:b0:434:f58c:ee2e with SMTP id
 y20-20020a056402441400b00434f58cee2emr26332209eda.362.1659545373846; Wed, 03
 Aug 2022 09:49:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220803153300.58732-1-sebastian.wuerl@ororatech.com>
In-Reply-To: <20220803153300.58732-1-sebastian.wuerl@ororatech.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 3 Aug 2022 18:48:57 +0200
Message-ID: <CAHp75VdCH2tJQq3v_-iNP27oWFGF7EtKc-w299tLhDV85WbroQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/net/can/spi/mcp251x.c: Fix race condition on
 receive interrupt
To:     =?UTF-8?Q?Sebastian_W=C3=BCrl?= <sebastian.wuerl@ororatech.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, linux-can@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 3, 2022 at 5:36 PM Sebastian W=C3=BCrl
<sebastian.wuerl@ororatech.com> wrote:
>
> The mcp251x driver uses both receiving mailboxes of the can controller

CAN

> chips. For retrieving the CAN frames from the controller via SPI, it chec=
ks
> once per interrupt which mailboxes have been filled, an will retrieve the
> messages accordingly.
>
> This introduces a race condition, as another CAN frame can enter mailbox =
1
> while mailbox 0 is emptied. If now another CAN frame enters mailbox 0 unt=
il
> the interrupt handler is called next, mailbox 0 is emptied before
> mailbox 1, leading to out-of-order CAN frames in the network device.
>
> This is fixed by checking the interrupt flags once again after freeing
> mailbox 0, to correctly also empty mailbox 1 before leaving the handler.
>
> For reproducing the bug I created the following setup:
>  - Two CAN devices, one Raspberry Pi with MCP2515, the other can be any.
>  - Setup CAN to 1 MHz
>  - Spam bursts of 5 CAN-messages with increasing CAN-ids
>  - Continue sending the bursts while sleeping a second between the bursts
>  - Check on the RPi whether the received messages have increasing CAN-ids
>  - Without this patch, every burst of messages will contain a flipped pai=
r

Fixes tag?

--=20
With Best Regards,
Andy Shevchenko
