Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332625C02DA
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 17:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbiIUPzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 11:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbiIUPyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 11:54:06 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A34D9F19B;
        Wed, 21 Sep 2022 08:50:29 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 67EAF24000C;
        Wed, 21 Sep 2022 15:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1663775375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lMfzm7oXpID+EdbJjZtpb1mfBYLUsogwYCElwzGougY=;
        b=bq5mZp2I7J1bxPmqo1WnkFVrTSVMZw7lmpGAHSYo0bQJCNfdc5Th7Iff79dsmmwfu2xHfs
        M911cp+HWQHygENbzzWSrK5Gjme99x1GH9aaecYjYcRLJbFWioHjFUFDW8xUBaoffMUqAp
        gKfLQHBc+Tx0Lql2IctYmmF+4bT0SZlszdr46o5tpUEiLLjX9ooSa6K5HYdsUm8iPmw2AT
        eHie/pqC9AbX/2z2k0LrknsDdBWzTm03zpey6sw8NoA3WZdDXsXl7fSaskOorwRMU10blt
        DRGV/hNA2bcndiixgzjx13arnAiObajVhoMbP9sr44yOb8oj98jCjFFtk+jgmA==
Date:   Wed, 21 Sep 2022 17:49:32 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan/next v3 5/9] net: mac802154: Drop
 IEEE802154_HW_RX_DROP_BAD_CKSUM
Message-ID: <20220921174932.37f2938f@xps-13>
In-Reply-To: <CAK-6q+gH3dRj6szUV6Add7G5nh1-5rBUpVLrrdbkjS22tz3ueA@mail.gmail.com>
References: <20220905203412.1322947-1-miquel.raynal@bootlin.com>
        <20220905203412.1322947-6-miquel.raynal@bootlin.com>
        <CAK-6q+gH3dRj6szUV6Add7G5nh1-5rBUpVLrrdbkjS22tz3ueA@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Thu, 8 Sep 2022 20:49:36 -0400:

> Hi,
>=20
> On Mon, Sep 5, 2022 at 4:34 PM Miquel Raynal <miquel.raynal@bootlin.com> =
wrote:
> >
> > This IEEE802154_HW_RX_DROP_BAD_CKSUM flag was only used by hwsim to
> > reflect the fact that it would not validate the checksum (FCS). In other
> > words, the filtering level of hwsim is always "NONE" while the core
> > expects it to be higher.
> >
> > Now that we have access to real filtering levels, we can actually use
> > them and always enforce the "NONE" level in hwsim. This case is already
> > correctly handled in the receive so we can drop the flag.
> > =20
>=20
> I would say the whole hwsim driver currently only works because we
> don't transmit wrong frames on a virtual hardware... However this can
> be improved, yes. In my opinion the hwsim driver should pretend to
> work like other transceivers sending frames to mac802154. That means
> the filtering level should be implemented in hwsim not in mac802154 as
> on real hardware the hardware would do filtering.
>=20
> I think you should assume for now the previous behaviour that hwsim
> does not send bad frames out. Of course there is a bug but it was
> already there before, but the fix would be to change hwsim driver.

Well, somehow I already implemented all the filtering by software in
one of the other patches. I now agree that it was not relevant (because
of the AACK issue you raised), but instead of fully dropping this code
I might just move it to hwsim because there it would perfectly make
sense?

Thanks,
Miqu=C3=A8l
