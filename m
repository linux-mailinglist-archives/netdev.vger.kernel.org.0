Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB1B4BA547
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 16:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242879AbiBQP7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 10:59:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242851AbiBQP7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 10:59:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABC1166A7E;
        Thu, 17 Feb 2022 07:58:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8189B821FC;
        Thu, 17 Feb 2022 15:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1FBC340E8;
        Thu, 17 Feb 2022 15:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645113525;
        bh=7xZ83u8iDo18S5QTR71wMPT5q3d56ibzjE9KfTJtmwI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EKdcSlgtu62AhJylD9QXGdp0i48vq0MMSevZuMBJG/jcEPbLP1JSeyZ9ufKr4reuq
         pkzQUvZ7K2fqeZQXA358lJNja50Lp/hhvuk+RPUwKXtMYpIdXYfDNOHcxYjz/pqQPI
         ULYM4K2ScoMQbZrCnp2cjwNEEI2/SO8p/a4Uq0Mw=
Date:   Thu, 17 Feb 2022 16:58:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@kernel.org>, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2/2] staging: wfx: apply the necessary SDIO quirks for
 the Silabs WF200
Message-ID: <Yg5wsmsPQaFOANwv@kroah.com>
References: <20220216093112.92469-1-Jerome.Pouiller@silabs.com>
 <CAPDyKFqm3tGa+dtAGPn803rLnfY=tdcoX5DySnG-spFFqM=CrA@mail.gmail.com>
 <87ley9zg8c.fsf@kernel.org>
 <2063576.g1lFC2ckuq@pc-42>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2063576.g1lFC2ckuq@pc-42>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 04:41:38PM +0100, Jérôme Pouiller wrote:
> On Thursday 17 February 2022 16:04:51 CET Kalle Valo wrote:
> > Ulf Hansson <ulf.hansson@linaro.org> writes:
> > > On Thu, 17 Feb 2022 at 10:59, Kalle Valo <kvalo@kernel.org> wrote:
> > >> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
> > >> > From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> > >> >
> > >> > Until now, the SDIO quirks are applied directly from the driver.
> > >> > However, it is better to apply the quirks before driver probing. So,
> > >> > this patch relocate the quirks in the MMC framework.
> > >>
> > >> It would be good to know how this is better, what's the concrete
> > >> advantage?
> > >
> > > The mmc core has a quirk interface for all types of cards
> > > (eMMC/SD/SDIO), which thus keeps these things from sprinkling to
> > > drivers. In some cases, the quirk needs to be applied already during
> > > card initialization, which is earlier than when probing an SDIO func
> > > driver or the MMC block device driver.
> > >
> > > Perhaps it's a good idea to explain a bit about this in the commit message.
> > 
> > I would add the whole paragraph to the commit log :)
> 
> Arf, Greg has just pulled this patch into staging-testing. I assume it is
> too late to change the commit message.

I can drop it, but really, it's fine as-is.

thanks,

greg k-h
