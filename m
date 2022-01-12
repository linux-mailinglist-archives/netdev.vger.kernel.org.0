Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2524848CA5A
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343992AbiALRs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:48:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45578 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240668AbiALRsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:48:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E36BCB81EA6;
        Wed, 12 Jan 2022 17:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADA2C36AE5;
        Wed, 12 Jan 2022 17:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642009730;
        bh=v5HVJMOt7K5cfz9ChUmoP+h6WJ8BSd2gVzVjKi67/bs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I5IBb8wMr1OFJJp1W4xiBKrGiLlzko0I4nZKxuwBG2kwloTU3de7Oz94htQwZBPr8
         midFS13nAQX6Fs4UhOwPEDWTfK3m//xboWTelsPoUzvmjVnw9K46ZScJcMUUQytTur
         7BunIoxoYHeHz3gAtPMyPmjMdrnivJ/PN5GYKIYXs6s6USAb1V/37faYc+sPS2afL5
         CqFVDc8M5gI7eCI2dRDH7JnnKzHJTXdSGAokYiV0Zo58OAa8yhIaoDyWhDmGiNgESi
         6OU0gIiFdHdDPRihZPjIdDbuzH9Rru5AYGe8XFWwDECAlPy1P1bWERHxc8HWk2dJEO
         9TKEzmzEjOrAw==
Received: by pali.im (Postfix)
        id 2CEB5768; Wed, 12 Jan 2022 18:48:48 +0100 (CET)
Date:   Wed, 12 Jan 2022 18:48:48 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v9 08/24] wfx: add bus_sdio.c
Message-ID: <20220112174848.db5osolurllpc7du@pali>
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
 <42104281.b1Mx7tgHyx@pc-42>
 <20220112114332.jadw527pe7r2j4vv@pali>
 <2680707.qJCEgCfB62@pc-42>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2680707.qJCEgCfB62@pc-42>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 12 January 2022 17:45:45 Jérôme Pouiller wrote:
> On Wednesday 12 January 2022 12:43:32 CET Pali Rohár wrote:
> > 
> > On Wednesday 12 January 2022 12:18:58 Jérôme Pouiller wrote:
> > > On Wednesday 12 January 2022 11:58:59 CET Pali Rohár wrote:
> > > > On Tuesday 11 January 2022 18:14:08 Jerome Pouiller wrote:
> > > > > +static const struct sdio_device_id wfx_sdio_ids[] = {
> > > > > +     { SDIO_DEVICE(SDIO_VENDOR_ID_SILABS, SDIO_DEVICE_ID_SILABS_WF200) },
> > > > > +     { },
> > > > > +};
> > > >
> > > > Hello! Is this table still required?
> > >
> > > As far as I understand, if the driver does not provide an id_table, the
> > > probe function won't be never called (see sdio_match_device()).
> > >
> > > Since, we rely on the device tree, we could replace SDIO_VENDOR_ID_SILABS
> > > and SDIO_DEVICE_ID_SILABS_WF200 by SDIO_ANY_ID. However, it does not hurt
> > > to add an extra filter here.
> > 
> > Now when this particular id is not required, I'm thinking if it is still
> > required and it is a good idea to define these SDIO_VENDOR_ID_SILABS
> > macros into kernel include files. As it would mean that other broken
> > SDIO devices could define these bogus numbers too... And having them in
> > common kernel includes files can cause issues... e.g. other developers
> > could think that it is correct to use them as they are defined in common
> > header files. But as these numbers are not reliable (other broken cards
> > may have same ids as wf200) and their usage may cause issues in future.
> 
> In order to make SDIO_VENDOR_ID_SILABS less official, do you prefer to
> define it in wfx/bus_sdio.c instead of mmc/sdio_ids.h?
> 
> Or even not defined at all like:
> 
>     static const struct sdio_device_id wfx_sdio_ids[] = {
>          /* WF200 does not have official VID/PID */
>          { SDIO_DEVICE(0x0000, 0x1000) },
>          { },
>     };

This has advantage that it is explicitly visible that this device does
not use any officially assigned ids.

> 
> 
> -- 
> Jérôme Pouiller
> 
> 
