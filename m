Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B86465D270
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 13:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbjADMWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 07:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbjADMVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 07:21:38 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DFE395E6;
        Wed,  4 Jan 2023 04:20:42 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6F476C0002;
        Wed,  4 Jan 2023 12:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1672834841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qeGA/M0gdxoNtTY0KeX78lNDJC4dSk65hmgtZUX0ask=;
        b=hUYWnTaj9xGNrIduznjKSeUKVt6gkcPhPsTEH7nwb566I+asiRTxGe4iYe5MHVI+O3NiRR
        MagE+AvCiJMNY4xMx1uQSlLmmhRNpTgpgDdUIwCeo9jWG5kz5/6P/wO0y0r02qPfLLjPtl
        QdS8a5di8t896c09n/rRZXKQCYrRrRZXKOzUNdEM5fi6UQOZ624wyQeYBbE2graxUIxo8C
        TZNmS4YJoiBSts77UIzPgz82+hKHnQIMEELXV8g3dZlQ5uuHmwhsrFe4voj9u+p0Inh88n
        diXW7XpaAk0eoKFYKOum9+B6BDXhBC7oCJItIGILT5FkxiGNf2mGe+Bdl8Ygyg==
Date:   Wed, 4 Jan 2023 13:20:37 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Alexander Aring <alex.aring@gmail.com>, linux-wpan@vger.kernel.org,
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
Subject: Re: [PATCH wpan-next v3 0/6] IEEE 802.15.4 passive scan support
Message-ID: <20230104132037.0c49a4ed@xps-13>
In-Reply-To: <9828444e-d047-40ac-6550-0bde4a9b5230@datenfreihafen.org>
References: <20230103165644.432209-1-miquel.raynal@bootlin.com>
        <9828444e-d047-40ac-6550-0bde4a9b5230@datenfreihafen.org>
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

Hi Stefan,

stefan@datenfreihafen.org wrote on Tue, 3 Jan 2023 20:43:02 +0100:

> Hello Miquel.
>=20
> On 03.01.23 17:56, Miquel Raynal wrote:
> > Hello,
> >=20
> > We now have the infrastructure to report beacons/PANs, we also have the
> > capability to transmit MLME commands synchronously. It is time to use
> > these to implement a proper scan implementation.
> >=20
> > There are a few side-changes which are necessary for the soft MAC scan
> > implementation to compile/work, but nothing big. The two main changes
> > are:
> > * The introduction of a user API for managing scans.
> > * The soft MAC implementation of a scan.
> >=20
> > In all the past, current and future submissions, David and Romuald from
> > Qorvo are credited in various ways (main author, co-author,
> > suggested-by) depending of the amount of rework that was involved on
> > each patch, reflecting as much as possible the open-source guidelines we
> > follow in the kernel. All this effort is made possible thanks to Qorvo
> > Inc which is pushing towards a featureful upstream WPAN support.
> >=20
> > Example of output:
> >=20
> > 	# iwpan monitor
> > 	coord1 (phy #1): scan started
> > 	coord1 (phy #1): beacon received: PAN 0xabcd, addr 0xb2bcc36ac5570abe
> > 	coord1 (phy #1): scan finished
> > 	coord1 (phy #1): scan started
> > 	coord1 (phy #1): scan aborted =20
>=20
> These patches have been applied to the wpan-next tree and will be
> part of the next pull request to net-next. Thanks!
>=20
> Before I would add them to a pull request to net-next I would like to hav=
e an updated patchset for iwpan to reflect these scan changes. We would nee=
d something to verify the kernel changes and try to coordinate a new iwpan =
release with this functionality with the major kernel release bringing the =
feature.

So far I did not made a single change for the scan, but a common
changeset for scan+beaconing (which I am about to send), should I split
it or should we assume we could introduce scanning and beaconing in the
same kernel release?

Thanks,
Miqu=C3=A8l
