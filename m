Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486565890CF
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 18:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236910AbiHCQuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 12:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237274AbiHCQux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 12:50:53 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05CCA189;
        Wed,  3 Aug 2022 09:50:51 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z2so11828781edc.1;
        Wed, 03 Aug 2022 09:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=PjTfETeJx0AMMZL3GKU4/eS5rgFKC9COqcGk3w/9o1g=;
        b=RPjG5sqWlEVUG+FaGHhTHzrtfDDIQy9PaG+zA5JW9dlCiZ3Z0LE11d9jbNzc0GzWlv
         7dxRtQPzF6XErhrq213RJiKzm2AYDl54i1HidvN4HOG0qWwJnPRh1g8LuPk4wljOGZyd
         /dJQgFe95fwphCbKi9lPhv5qNjOlc/BNyGFOV1rFJzqlJe2C+2GVezKeI2lJaZ1T8KzD
         FqD6PYeueeqHeAi/ndyUbJ2El51k69i2NbFDCWe5T4L3VApZzJ6c6SHsFl2IhopQbSMi
         nqZ8zwRckOsGv0lE9TTC3I6O4n+vNunzXzY09C40PZCu9lQO+tH7JTDXuNd6vv/JnqA9
         Bxpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=PjTfETeJx0AMMZL3GKU4/eS5rgFKC9COqcGk3w/9o1g=;
        b=5ZV8SfI6DBtobuh9wLR0x45d4mJVkUjBnTGN2s5WNMQl2DVLCxBNLJ506NOKFwASXG
         Thm32fkQaamP8K0mYaRE6NQ8UN2Qe4XlZKxO1atbDFvlj2nxv7joi0mg7403F1uyBBuC
         tDkctvd3Nm+/8rlELnSbr6rfNQbNLkd1o0JrBV6VwIi3LU7aGQrsDxtEOX5rP03mesoY
         5b8eNHkMi0ByDAlCQKaSFcmt70Xiibovb3MPmq1Bnwq7oarakAmJyYGfKgt6Ttmdx05T
         7GkMaXI9e5Pl+ebuEyTgJzL5/En0Mycttpe5BjBYQ/hQ1wDEPVIKmz6i03dNi7fn0Edb
         qZ4Q==
X-Gm-Message-State: ACgBeo1+oiGuxEWito5VSj9CdC17qd44fnpuL5KFpdb2XVVfYpYf2XXP
        G/uPNkW0CCYGq9dnXrl1goPxcaAS++wJ340kydw=
X-Google-Smtp-Source: AA6agR7vS40R5OQ498i9IT1CvyAd1hMJU4jDcIj/iSesCqOe/KJJq7hhbIxQYX/cnqzG52JaEKruskYuCXMZqJxqPpg=
X-Received: by 2002:a50:cccb:0:b0:43d:efd3:88fb with SMTP id
 b11-20020a50cccb000000b0043defd388fbmr9358488edj.265.1659545450254; Wed, 03
 Aug 2022 09:50:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220803153300.58732-1-sebastian.wuerl@ororatech.com> <CAHp75VdCH2tJQq3v_-iNP27oWFGF7EtKc-w299tLhDV85WbroQ@mail.gmail.com>
In-Reply-To: <CAHp75VdCH2tJQq3v_-iNP27oWFGF7EtKc-w299tLhDV85WbroQ@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 3 Aug 2022 18:50:13 +0200
Message-ID: <CAHp75VcTyubQFXyKA1RoYkpWowfKYwA1N_zZtmvGTeCmDG89Ow@mail.gmail.com>
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

On Wed, Aug 3, 2022 at 6:48 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Wed, Aug 3, 2022 at 5:36 PM Sebastian W=C3=BCrl
> <sebastian.wuerl@ororatech.com> wrote:
> >
> > The mcp251x driver uses both receiving mailboxes of the can controller
>
> CAN
>
> > chips. For retrieving the CAN frames from the controller via SPI, it ch=
ecks
> > once per interrupt which mailboxes have been filled, an will retrieve t=
he
> > messages accordingly.
> >
> > This introduces a race condition, as another CAN frame can enter mailbo=
x 1
> > while mailbox 0 is emptied. If now another CAN frame enters mailbox 0 u=
ntil
> > the interrupt handler is called next, mailbox 0 is emptied before
> > mailbox 1, leading to out-of-order CAN frames in the network device.
> >
> > This is fixed by checking the interrupt flags once again after freeing
> > mailbox 0, to correctly also empty mailbox 1 before leaving the handler=
.
> >
> > For reproducing the bug I created the following setup:
> >  - Two CAN devices, one Raspberry Pi with MCP2515, the other can be any=
.
> >  - Setup CAN to 1 MHz
> >  - Spam bursts of 5 CAN-messages with increasing CAN-ids
> >  - Continue sending the bursts while sleeping a second between the burs=
ts
> >  - Check on the RPi whether the received messages have increasing CAN-i=
ds
> >  - Without this patch, every burst of messages will contain a flipped p=
air
>
> Fixes tag?

Also fix the Subject prefix (you may see the most used ones by running
`git log --no-merges --oneline -- drivers/net/can/spi/mcp251x.c`).

--=20
With Best Regards,
Andy Shevchenko
