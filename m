Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7600049F7FB
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 12:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244320AbiA1LLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 06:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiA1LLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 06:11:47 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0A8C061714;
        Fri, 28 Jan 2022 03:11:46 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5355E20008;
        Fri, 28 Jan 2022 11:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1643368305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iR0Ke+v1DOJu+t5Jl0WPRhbNBzvlE1GoH4GRyh4tuJs=;
        b=ATYr5XHRHUGzCLC/tiE3p9jWlf3+rnEwnd0khx2ml1H50eWI86kU8RVNTYvejsf2yCTYkk
        3CNun48k7vkpMzLkyR42tkW7y2KgEhHusX0y+03NqVm1tNKLFloEi2Gx6m18PaYD3FA10o
        eXYL7nIhDX2qvwzV3eu18p+4kbL3VAn6x//zwhi0X6lRlePkv0LP4glpr+eKACD9lhoFUj
        Lg7OeJZkYVltOmgg9JVUC4BhidSGWdcynfMqnje66Tpyw+xV0xrixi1/Dl2wdWer+flpMP
        1xLHALUMbbF1xYc5FI+Ok7hA8KyOHUZlCQ1YYv8SbBfS1439kw02Q9L5WUAp3Q==
Date:   Fri, 28 Jan 2022 12:11:39 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>
Subject: Re: [PATCH wpan-next v2 0/5] ieee802154: Improve durations handling
Message-ID: <20220128121139.626394ae@xps13>
In-Reply-To: <20220128110825.1120678-1-miquel.raynal@bootlin.com>
References: <20220128110825.1120678-1-miquel.raynal@bootlin.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

miquel.raynal@bootlin.com wrote on Fri, 28 Jan 2022 12:08:20 +0100:

> These paches try to enhance the support of the various delays by adding
> into the core the necessary logic to derive the actual symbol duration
> (and then the lifs/sifs durations) depending on the protocol used. The
> symbol duration type is also updated to fit smaller numbers.
>=20
> Having the symbol durations properly set is a mandatory step in order to
> use the scanning feature that will soon be introduced.

I forgot to mention the changelog here, I've just reworded a commit
message and fixed a typo.

>=20
> Miquel Raynal (5):
>   net: ieee802154: Improve the way supported channels are declared
>   net: ieee802154: Give more details to the core about the channel
>     configurations
>   net: mac802154: Convert the symbol duration into nanoseconds
>   net: mac802154: Set durations automatically
>   net: ieee802154: Drop duration settings when the core does it already
>=20
>  drivers/net/ieee802154/adf7242.c         |   3 +-
>  drivers/net/ieee802154/at86rf230.c       |  66 ++++++-------
>  drivers/net/ieee802154/atusb.c           |  66 ++++++-------
>  drivers/net/ieee802154/ca8210.c          |   7 +-
>  drivers/net/ieee802154/cc2520.c          |   3 +-
>  drivers/net/ieee802154/fakelb.c          |  43 ++++++---
>  drivers/net/ieee802154/mac802154_hwsim.c |  76 ++++++++++++---
>  drivers/net/ieee802154/mcr20a.c          |  11 +--
>  drivers/net/ieee802154/mrf24j40.c        |   3 +-
>  include/net/cfg802154.h                  |  60 +++++++++++-
>  net/ieee802154/core.h                    |   2 +
>  net/ieee802154/nl-phy.c                  |   8 +-
>  net/ieee802154/nl802154.c                |  30 ++++--
>  net/mac802154/cfg.c                      |   1 +
>  net/mac802154/main.c                     | 113 ++++++++++++++++++++++-
>  15 files changed, 361 insertions(+), 131 deletions(-)
>=20


Thanks,
Miqu=C3=A8l
