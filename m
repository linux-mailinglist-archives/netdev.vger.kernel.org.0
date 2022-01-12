Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715E548C368
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 12:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352946AbiALLnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 06:43:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57320 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239294AbiALLng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 06:43:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D466A6164C;
        Wed, 12 Jan 2022 11:43:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3E9C36AE9;
        Wed, 12 Jan 2022 11:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641987815;
        bh=nNZvPmLCj5hUY/EAI5dVhxfi/PBGWTo2PlQBAzZcUlo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DQMxxxnMGBy6NVEsiApsuYJBAUBJcIKybBu8A/KI9r+NnkFEzT8nLBqev2dR7t6PU
         FHzCaqUwApBvErP/Kwh9/Nh0vYxKUdVEywsTsxCJlmC6AIWzQuDOPnUVf+MUsc/dHs
         5OMJ7R6ucqR6jmV5GargzvvkdW+ZWPz0W5ksFxlqB8q5HIF6ZSWnEAAy30d1uTLXhe
         /RsA4Idg/f69O5iCf67aYoj6Px8mf/9h80vETZUjfBpTfEAwTIoGonqXRBa3AoBQlN
         O6qJBnSGAhs743Y1SmfwVgltsjL6ZVkizQOPlSW+juG4T8Z6WsC8waCLm75Ckvtx8L
         u5PuHNHhgZubg==
Received: by pali.im (Postfix)
        id ADF7E768; Wed, 12 Jan 2022 12:43:32 +0100 (CET)
Date:   Wed, 12 Jan 2022 12:43:32 +0100
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
Message-ID: <20220112114332.jadw527pe7r2j4vv@pali>
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
 <20220111171424.862764-9-Jerome.Pouiller@silabs.com>
 <20220112105859.u4j76o7cpsr4znmb@pali>
 <42104281.b1Mx7tgHyx@pc-42>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <42104281.b1Mx7tgHyx@pc-42>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 12 January 2022 12:18:58 Jérôme Pouiller wrote:
> On Wednesday 12 January 2022 11:58:59 CET Pali Rohár wrote:
> > On Tuesday 11 January 2022 18:14:08 Jerome Pouiller wrote:
> > > +static const struct sdio_device_id wfx_sdio_ids[] = {
> > > +     { SDIO_DEVICE(SDIO_VENDOR_ID_SILABS, SDIO_DEVICE_ID_SILABS_WF200) },
> > > +     { },
> > > +};
> > 
> > Hello! Is this table still required?
> 
> As far as I understand, if the driver does not provide an id_table, the
> probe function won't be never called (see sdio_match_device()).
> 
> Since, we rely on the device tree, we could replace SDIO_VENDOR_ID_SILABS
> and SDIO_DEVICE_ID_SILABS_WF200 by SDIO_ANY_ID. However, it does not hurt
> to add an extra filter here.

Now when this particular id is not required, I'm thinking if it is still
required and it is a good idea to define these SDIO_VENDOR_ID_SILABS
macros into kernel include files. As it would mean that other broken
SDIO devices could define these bogus numbers too... And having them in
common kernel includes files can cause issues... e.g. other developers
could think that it is correct to use them as they are defined in common
header files. But as these numbers are not reliable (other broken cards
may have same ids as wf200) and their usage may cause issues in future.

Ulf, any opinion?

Btw, is there any project which maintains SDIO ids, like there is
pci-ids.ucw.cz for PCI or www.linux-usb.org/usb-ids.html for USB?

> > > +MODULE_DEVICE_TABLE(sdio, wfx_sdio_ids);
> > > +
> > > +struct sdio_driver wfx_sdio_driver = {
> > > +     .name = "wfx-sdio",
> > > +     .id_table = wfx_sdio_ids,
> > > +     .probe = wfx_sdio_probe,
> > > +     .remove = wfx_sdio_remove,
> > > +     .drv = {
> > > +             .owner = THIS_MODULE,
> > > +             .of_match_table = wfx_sdio_of_match,
> > > +     }
> > > +};
> > > --
> > > 2.34.1
> > >
> > 
> 
> 
> -- 
> Jérôme Pouiller
> 
> 
> 
