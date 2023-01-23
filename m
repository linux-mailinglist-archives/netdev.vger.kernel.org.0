Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC04A677BA8
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 13:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbjAWMuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 07:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbjAWMuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 07:50:24 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A0D12F0D;
        Mon, 23 Jan 2023 04:49:56 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D81BCC0009;
        Mon, 23 Jan 2023 12:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1674478166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rIQSstPgcXGmcuQdv16JqxlRCmJme9MN5dDSHfjPQck=;
        b=is9otCpMHRwafdtuEmY6Bor36GywFgth88qTpDgaNBO02LPYmFSrZSWkaEL6G0alBJj/IE
        TJc82e0yo3S0baHOFooMqVTjH+K98UclQZEA3ZoHD0pa3B56sZ7KSwzS5HtvdI9dieP+t7
        mIRT9q99U52m9gZbeRrJrYCGkSeVSl6eq9KhCA3ONShwfVUZxqHWU4S1+w1y6VVOvclwYE
        vbC7ymf+9u+RcueU/7pnGBF9kln8MsYZdaB82658lsixGjlkXQ/yDhgGIPA1OjfFDWZQAs
        KfCoZnsL602EpsaepFkkAGJh8yXBNvgSNz2o6ZRxEflYg5l2t5InIsZTV/5FGg==
Date:   Mon, 23 Jan 2023 13:49:21 +0100
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
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 0/2] ieee802154: Beaconing support
Message-ID: <20230123134921.38cdfd42@xps-13>
In-Reply-To: <20230118102058.3b1f275b@xps-13>
References: <20230106113129.694750-1-miquel.raynal@bootlin.com>
        <CAK-6q+jNmvtBKKxSp1WepVXbaQ65CghZv3bS2ptjB9jyzOSGTA@mail.gmail.com>
        <20230118102058.3b1f275b@xps-13>
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

> > btw: what is about security handling... however I would declare this
> > feature as experimental anyway. =20
>=20
> I haven't tested the security layer at all yet, would you have a few
> commands to start with, which I could try using eg. hwsim?

Using the dev_queue_xmit() doest not bypasses the whole stack anymore,
the beacons got rejected by the llsec layer. I did just hack into it
just to allow unsecure beacons for now:

-       if (hlen < 0 || hdr.fc.type !=3D IEEE802154_FC_TYPE_DATA)
+       if (hlen < 0 ||
+           (hdr.fc.type !=3D IEEE802154_FC_TYPE_DATA &&
+            hdr.fc.type !=3D IEEE802154_FC_TYPE_BEACON))
                return -EINVAL;

I believe that would be enough as a first step, at least for merging
beacons support for now.

However I'll have to look at the spec about security stuff and
beaconing to know how to handle this properly if security was required,
but could you drive me through useful resources were I could quickly
grasp how all that works? Did you make any presentation of it? Perhaps
just a blog post or something alike? Or even just a script showing its
use?

While I was looking at linux-wpan.org, I realized we should both
contribute to it with some examples about security stuff and
beaconing/scanning?

Thanks,
Miqu=C3=A8l
