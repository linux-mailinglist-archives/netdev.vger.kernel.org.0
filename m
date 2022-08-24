Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C623D59FEBD
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 17:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239845AbiHXPrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 11:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239609AbiHXPrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 11:47:24 -0400
Received: from mail.sf-mail.de (mail.sf-mail.de [IPv6:2a01:4f8:1c17:6fae:616d:6c69:616d:6c69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8975C15737
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 08:45:53 -0700 (PDT)
Received: (qmail 28362 invoked from network); 24 Aug 2022 15:45:53 -0000
Received: from p200300cf070f2e0076d435fffeb7be92.dip0.t-ipconnect.de ([2003:cf:70f:2e00:76d4:35ff:feb7:be92]:54142 HELO eto.sf-tec.de) (auth=eike@sf-mail.de)
        by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
        for <seanga2@gmail.com>; Wed, 24 Aug 2022 17:45:53 +0200
From:   Rolf Eike Beer <eike-kernel@sf-tec.de>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 4/x] sunhme: switch to devres
Date:   Wed, 24 Aug 2022 17:45:45 +0200
Message-ID: <3192215.44csPzL39Z@eto.sf-tec.de>
In-Reply-To: <1754323.ZfhJiG4Tka@daneel.sf-tec.de>
References: <4686583.GXAFRqVoOG@eto.sf-tec.de> <7e286518-2f01-6042-4d23-94d8846774db@gmail.com> <1754323.ZfhJiG4Tka@daneel.sf-tec.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart8107607.T7Z3S40VBb"; micalg="pgp-sha1"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart8107607.T7Z3S40VBb
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Sean Anderson <seanga2@gmail.com>
Cc: netdev@vger.kernel.org
Subject: Re: [PATCH 4/x] sunhme: switch to devres
Date: Wed, 24 Aug 2022 17:45:45 +0200
Message-ID: <3192215.44csPzL39Z@eto.sf-tec.de>
In-Reply-To: <1754323.ZfhJiG4Tka@daneel.sf-tec.de>
MIME-Version: 1.0

Am Montag, 1. August 2022, 17:14:39 CEST schrieb Rolf Eike Beer:
> Am Freitag, 29. Juli 2022, 02:33:01 CEST schrieb Sean Anderson:
> > On 7/28/22 3:52 PM, Rolf Eike Beer wrote:
> > > Am 2022-07-27 05:58, schrieb Sean Anderson:
> > >> On 7/26/22 11:49 PM, Sean Anderson wrote:
> > >>> This looks good, but doesn't apply cleanly. I rebased it as follows:
> > > Looks like what my local rebase has also produced.
> > > 
> > > The sentence about the leak from the commitmessage can be dropped then,
> > > as this leak has already been fixed.
> > > 
> > >>> diff --git a/drivers/net/ethernet/sun/sunhme.c
> > >>> b/drivers/net/ethernet/sun/sunhme.c index eebe8c5f480c..e83774ffaa7a
> > >>> 100644
> > >>> --- a/drivers/net/ethernet/sun/sunhme.c
> > >>> +++ b/drivers/net/ethernet/sun/sunhme.c
> > >>> @@ -2990,21 +2990,23 @@ static int happy_meal_pci_probe(struct pci_dev
> > >>> *pdev, qp->happy_meals[qfe_slot] = dev;
> > >>> 
> > >>>       }
> > >>> 
> > >>> -    hpreg_res = pci_resource_start(pdev, 0);
> > >>> -    err = -ENODEV;
> > >>> 
> > >>>       if ((pci_resource_flags(pdev, 0) & IORESOURCE_IO) != 0) {
> > >>>       
> > >>>           printk(KERN_ERR "happymeal(PCI): Cannot find proper PCI
> > >>>           device
> > >>> 
> > >>> base address.\n"); goto err_out_clear_quattro;
> > >>> 
> > >>>       }
> > >>> 
> > >>> -    if (pci_request_regions(pdev, DRV_NAME)) {
> > >>> +
> > >>> +    if (!devm_request_region(&pdev->dev, pci_resource_start(pdev, 0),
> > >>> +                  pci_resource_len(pdev, 0),
> > >>> +                  DRV_NAME)) {
> > >> 
> > >> Actually, it looks like you are failing to set err from these *m
> > >> calls, like what
> > >> you fixed in patch 3. Can you address this for v2?
> > > 
> > > It returns NULL on error, there is no error code I can set.
> > 
> > So it does. A quick grep shows that most drivers return -EBUSY.
> 
> Sure, I just meant that there is no error code I can pass on. I can change
> that to -EBUSY if you prefer that, currently it just returns -ENODEV as the
> old code has done before.

Ping?

Eike

--nextPart8107607.T7Z3S40VBb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSaYVDeqwKa3fTXNeNcpIk+abn8TgUCYwZHqQAKCRBcpIk+abn8
TvUIAJ4lut81W5Q5tx8bsR5ps3yb9f6/xQCfWYUT6JWE1PNcAES7dYAEUqfhFmU=
=o4lp
-----END PGP SIGNATURE-----

--nextPart8107607.T7Z3S40VBb--



