Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E80859A3F0
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351257AbiHSRp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 13:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354889AbiHSRpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 13:45:44 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEB010475D;
        Fri, 19 Aug 2022 10:09:50 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7F94D20008;
        Fri, 19 Aug 2022 17:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1660928987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=af8NiFFBbQBcqZbf5KXHymvUGECBo7Q6iFJT3UlUWkA=;
        b=W3hYmBQ2w+obMJm182GEBHOhBb6bPpPaMpfeR511Mrf0Y5EaKoztOD2VkN21utSIB9qI/d
        PqJYqH2Whq0J9M+Vq7PMiDoyCDQBVu+tEn7/rHGEQJOWUoPBaSZGGHwwz+5PtusqmimF6L
        OkRW3SQK1epC/cZ1my94uHZkekOJZ5G6T+DU4n+B1A1SVaVzo6qoNcIYM8MO3t/SKiRi43
        BQaWVd5BUSir2YJEw1ZVvzK9x04+JmAgYKyY0TYQjaJbP8vLNtXQiDlNnhFGkwlIHa9G6F
        Erf0iYSJd7Vksuft6czCn2pL5PRyD94u/sxAavksWbwxxUPgZlrQpM5ZUbT5HQ==
Date:   Fri, 19 Aug 2022 19:09:44 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 19/20] ieee802154: hwsim: Do not check the
 rtnl
Message-ID: <20220819190944.0718c7e1@xps-13>
In-Reply-To: <CAK-6q+ihSui2ra188kt9W5CT0HPfJgHoOJfsMS_XDLfVvoQJTg@mail.gmail.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
        <20220701143052.1267509-20-miquel.raynal@bootlin.com>
        <CAK-6q+ihSui2ra188kt9W5CT0HPfJgHoOJfsMS_XDLfVvoQJTg@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Tue, 5 Jul 2022 21:23:21 -0400:

> Hi,
>=20
> On Fri, Jul 1, 2022 at 10:37 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > There is no need to ensure the rtnl is locked when changing a driver's
> > channel. This cause issues when scanning and this is the only driver
> > relying on it. Just drop this dependency because it does not seem
> > legitimate.
> > =20
>=20
> switching channels relies on changing pib attributes, pib attributes
> are protected by rtnl. If you experience issues here then it's
> probably because you do something wrong. All drivers assuming here
> that rtnl lock is held.

---8<---
> especially this change could end in invalid free. Maybe we can solve
> this problem in a different way, what exactly is the problem by
> helding rtnl lock?
--->8---

During a scan we need to change channels. So when the background job
kicks-in, we first acquire scan_lock, then we check the internal
parameters of the structure protected by this lock, like the next
channel to use and the sdata pointer. A channel change must be
performed, preceded by an rtnl_lock(). This will again trigger a
possible circular lockdep dependency warning because the triggering path
acquires the rtnl (as part of the netlink layer) before the scan lock.

One possible solution would be to do the following:
scan_work() {
	acquire(scan_lock);
	// do some config
	release(scan_lock);
	rtnl_lock();
	perform_channel_change();
	rtnl_unlock();
	acquire(scan_lock);
	// reinit the scan struct ptr and the sdata ptr
	// do some more things
	release(scan_lock);
}

It looks highly non-elegant IMHO. Otherwise I need to stop verifying in
the drivers that the rtnl is taken. Any third option here?

BTW I don't see where the invalid free situation you mentioned can
happen here, can you explain?

Thanks,
Miqu=C3=A8l
