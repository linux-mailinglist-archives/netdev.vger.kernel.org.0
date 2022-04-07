Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07FAC4F791A
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 10:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235806AbiDGIJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 04:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242839AbiDGIHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 04:07:19 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6254A15E892;
        Thu,  7 Apr 2022 01:05:17 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E7BED1BF20F;
        Thu,  7 Apr 2022 08:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649318716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6dwUq/lt2WsDVhhZ/1fD04alAg8p/cPPGANiZ4vYVpE=;
        b=mAMjI54nbxQTGy1pPkzMHxsbbMbRiX8aiZpUngRH9+k4G/eN7xlU8nC/dqw0NZF767UZgV
        moF7yKEYE3msEAufBdBI6SzCu0FHlB6AvXobqUoZysA91VTN3y5kHZ3CMoOSdMQPTPDbON
        t2D/bc4BfOoEYHAY/jqkH7GXCvxHfjkB6yF+KzAvjvHK86sAsMd1ZAPhBtauPZ9/PX0Dka
        zyEi4zLJ+pNAyOXtqQY3aPEHNwaibtFGhEZd21yd1bYeS8bIj9dcgOrscLODR7HD1l9MbA
        lTsVCukqS8RB+rVpd/hdmqY7F6CAgpCh1y71qn37x6M0f88u0jCkiM7/1iOvhg==
Date:   Thu, 7 Apr 2022 10:05:13 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v5 06/11] net: ieee802154: at86rf230: Rename the
 asynchronous error helper
Message-ID: <20220407100513.4b8378b6@xps13>
In-Reply-To: <CAB_54W4DMkBxYYorSZXp52D=xCEATFDbuz+0YvxNc6doO8uJ2A@mail.gmail.com>
References: <20220406153441.1667375-1-miquel.raynal@bootlin.com>
        <20220406153441.1667375-7-miquel.raynal@bootlin.com>
        <CAB_54W4DMkBxYYorSZXp52D=xCEATFDbuz+0YvxNc6doO8uJ2A@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Wed, 6 Apr 2022 17:57:41 -0400:

> Hi,
>=20
> On Wed, Apr 6, 2022 at 11:34 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > In theory there are two distinct error path:
> > - The bus error when forwarding a packet to the transceiver fails.
> > - The transmitter error, after the transmission has been offloaded.
> >
> > Right now in this driver only the former situation is properly handled,
> > so rename the different helpers to reflect this situation before
> > improving the support of the other path.
> > =20
>=20
> I have no idea what I should think about this patch.
>=20
> On the driver layer there only exists "bus errors" okay, whatever
> error because spi_async() returns an error and we try to recover from
> it. Also async_error() will be called when there is a timeout because
> the transceiver took too long for some state change... In this case
> most often this async_error() is called if spi_async() returns an
> error but as I said it's not always the case (e.g. timeout)... it is
> some kind of hardware issue (indicated by 802.15.4 SYSTEM_ERROR for
> upper layer) and probably if it occurs we can't recover anyway from it
> (maybe rfkill support can do it, which does a whole transceiver reset
> routine, but this is always user triggered so far I know).
>=20
> However if you want that patch in that's it's fine for me, but for me
> this if somebody looks closely into the code it's obvious that in most
> cases it's called when spi_async() returns an error (which is not
> always the case see timeout).

I thought it would clarify the situation but I overlooked the timeout
situation. Actually I did wrote it before understanding what was wrong
with the patch coming next (I assume my new approach is fine?), and
the two changes are fully independent, so I'll drop this patch too.

Thanks,
Miqu=C3=A8l
