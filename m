Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6227B53D6BB
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 14:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235710AbiFDMVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 08:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiFDMVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 08:21:19 -0400
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB18252A2;
        Sat,  4 Jun 2022 05:21:18 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id u3so8362166ybi.4;
        Sat, 04 Jun 2022 05:21:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QZO+pLOrAhcvGiTUGNCSJiLeB6psDXjM9tKW6RP6/Ag=;
        b=zsYYjpLHNJQyJlm2Wowl298AP7WFBL4CHkGE8zc0tbp2aph9oEsbNih/WAlWChFKRr
         g0VELnBDL808YvZXoYghZQ37SAW3tDqw9OCdvWg1iqPPAwjFsSWrC75Jcvgq9EaPEbQg
         mB8uCsY0xHcRoETAHcm8IIESNFuSZPV1gBdS+qhs7B3g4s2xkognye8uX5lCwc1tSSQ/
         iaOCadk16LRcZ78o+Rc+W3H9u4rhEilZwXQshpWEQldvHZZSj2YdufZBhiaMhUPUFpNi
         X2Av3SfQZy1TFZU6T7Gl0OK6NYO/clP6TceUbuWabMEiaF/faKG7eGBPON0Hx7ZYjPIW
         W/wg==
X-Gm-Message-State: AOAM533KhO66gfvqnaDp0ZIFuc+VwjZl6+eG3MQanp205DGBjNNZdp5h
        W3oOsFsaN5nYQKhw/G1BTF2wCCivcIPednb//rE=
X-Google-Smtp-Source: ABdhPJykGcZWslVv3Tj0UMcudm0cPYI9CXJY4CqRCN6KA9bR1NSqEKN+mAU1RQHU7Q4sVULSWO6OsAI8Zk22h0tag+A=
X-Received: by 2002:a25:ad58:0:b0:65c:e3e5:e813 with SMTP id
 l24-20020a25ad58000000b0065ce3e5e813mr15283814ybe.151.1654345272834; Sat, 04
 Jun 2022 05:21:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-1-mailhol.vincent@wanadoo.fr> <20220603102848.17907-4-mailhol.vincent@wanadoo.fr>
 <20220604112538.p4hlzgqnodyvftsj@pengutronix.de>
In-Reply-To: <20220604112538.p4hlzgqnodyvftsj@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sat, 4 Jun 2022 21:21:01 +0900
Message-ID: <CAMZ6RqLg_Enyn1h+sn=o8rc8kkR6r=YaygLy40G9D4=Ug_KxOg@mail.gmail.com>
Subject: Re: [PATCH v4 3/7] can: bittiming: move bittiming calculation
 functions to calc_bittiming.c
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat. 4 June 2022 at 20:25, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 03.06.2022 19:28:44, Vincent Mailhol wrote:
> > The canonical way to select or deselect an object during compilation
> > is to use this pattern in the relevant Makefile:
> >
> > bar-$(CONFIG_FOO) := foo.o
> >
> > bittiming.c instead uses some #ifdef CONFIG_CAN_CALC_BITTIMG.
> >
> > Create a new file named calc_bittiming.c with all the functions which
> > are conditionally compiled with CONFIG_CAN_CALC_BITTIMG and modify the
> > Makefile according to above pattern.
> >
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> > ---
> >  drivers/net/can/Kconfig              |   4 +
> >  drivers/net/can/dev/Makefile         |   2 +
> >  drivers/net/can/dev/bittiming.c      | 197 --------------------------
> >  drivers/net/can/dev/calc_bittiming.c | 202 +++++++++++++++++++++++++++
> >  4 files changed, 208 insertions(+), 197 deletions(-)
> >  create mode 100644 drivers/net/can/dev/calc_bittiming.c
> >
> > diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
> > index b1e47f6c5586..8f3b97aea638 100644
> > --- a/drivers/net/can/Kconfig
> > +++ b/drivers/net/can/Kconfig
> > @@ -96,6 +96,10 @@ config CAN_CALC_BITTIMING
> >         source clock frequencies. Disabling saves some space, but then the
> >         bit-timing parameters must be specified directly using the Netlink
> >         arguments "tq", "prop_seg", "phase_seg1", "phase_seg2" and "sjw".
> > +
> > +       The additional features selected by this option will be added to the
> > +       can-dev module.
> > +
> >         If unsure, say Y.
> >
> >  config CAN_AT91
> > diff --git a/drivers/net/can/dev/Makefile b/drivers/net/can/dev/Makefile
> > index 919f87e36eed..b8a55b1d90cd 100644
> > --- a/drivers/net/can/dev/Makefile
> > +++ b/drivers/net/can/dev/Makefile
> > @@ -9,3 +9,5 @@ can-dev-$(CONFIG_CAN_NETLINK) += dev.o
> >  can-dev-$(CONFIG_CAN_NETLINK) += length.o
> >  can-dev-$(CONFIG_CAN_NETLINK) += netlink.o
> >  can-dev-$(CONFIG_CAN_NETLINK) += rx-offload.o
> > +
> > +can-dev-$(CONFIG_CAN_CALC_BITTIMING) += calc_bittiming.o
>
> Nitpick:
> Can we keep this list sorted?

My idea was first to group per CONFIG symbol according to the
different levels: CAN_DEV first, then CAN_NETLINK and finally
CAN_CALC_BITTIMING and CAN_RX_OFFLOAD. And then only sort by
alphabetical order within each group.

By sorting the list, do literally mean to sort each line like this:

obj-$(CONFIG_CAN_DEV) += can-dev.o
can-dev-$(CONFIG_CAN_CALC_BITTIMING) += calc_bittiming.o
can-dev-$(CONFIG_CAN_DEV) += skb.o
can-dev-$(CONFIG_CAN_NETLINK) += bittiming.o
can-dev-$(CONFIG_CAN_NETLINK) += dev.o
can-dev-$(CONFIG_CAN_NETLINK) += length.o
can-dev-$(CONFIG_CAN_NETLINK) += netlink.o
can-dev-$(CONFIG_CAN_RX_OFFLOAD) += rx-offload.o

or do you mean to sort by object name (ignoring the config symbol) like that:

obj-$(CONFIG_CAN_DEV) += can-dev.o
can-dev-$(CONFIG_CAN_NETLINK) += bittiming.o
can-dev-$(CONFIG_CAN_CALC_BITTIMING) += calc_bittiming.o
can-dev-$(CONFIG_CAN_NETLINK) += dev.o
can-dev-$(CONFIG_CAN_NETLINK) += length.o
can-dev-$(CONFIG_CAN_NETLINK) += netlink.o
can-dev-$(CONFIG_CAN_RX_OFFLOAD) += rx-offload.o
can-dev-$(CONFIG_CAN_DEV) += skb.o

?

(I honestly do not care so much how we sort the lines. My logic of
grouping first by CONFIG symbols seems more natural, but I am fine to
go with any other suggestion).
