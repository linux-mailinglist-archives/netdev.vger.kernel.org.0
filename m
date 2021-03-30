Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2F634E2FC
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 10:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhC3ISy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 04:18:54 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:23463 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbhC3ISs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 04:18:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1617092328; x=1648628328;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+gyuP2o8c81Fb8w4sK4HiD0tTwx8CqW4Of6BFZ8CVpc=;
  b=t3lD7ORaiAP00DXQRqkPI9L3sr63eH5EQ+Yu7fmR630sinq7Kko4AD3Z
   4SXj8YwQ6fKqCEVjeGWHHntWeyEWTdWQ5mnX8u8jL3gaO65cUvHUrM9df
   I8asi7FUnDiMZjNuUBZxqxkkHMFQ2JyXPIEe4Xw0AGiWojFPnch5Ar6KV
   uFQoeTqQrwSr7n1hZprU2otAe0WUKVDEXFZVQviGpu6KL+8vPn8kog7vt
   NOFsYtQk/QFJVYMhQqanohFrS8d/wQivERMod6FOdWqtrfVUoNQsdiT22
   h1TZv1RxQYxC7PY4PrMZL17D+p07UKPlyQtRS0gp2CagNb5rtvLrwfojj
   A==;
IronPort-SDR: QOiXiy9v2yvWnu8splEZ7FCYjwOfZM9vsj+WkXS+Ez26JD7zAOsNo4nzyLB2nsJ/WVcL2p3uTd
 O0uYjcYzeP/WhLEfyD/Lbmvc+voqrTSDy0qTo7Om24f2skespBOB74BjMZpChKCSacFt0W++Pk
 jE+7GPbFvPCEFnbrIdeAb/v6OVaDpieiKwP3T+WBV6TwzB1t7uS2DRu6//8HbtBXpSBt2uWOz2
 E4aytVlV2W/oowrvLX+GN+pxdmYRPj6Zams5vQCQ/342xeshie3Ug3HEZZ8oklUiV8JxboZuC2
 H3U=
X-IronPort-AV: E=Sophos;i="5.81,290,1610434800"; 
   d="scan'208";a="49364921"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Mar 2021 01:18:47 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 30 Mar 2021 01:18:47 -0700
Received: from den-her-m31857h.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 30 Mar 2021 01:18:45 -0700
Message-ID: <2356027828f1fa424751e91e478ff4bc188e7f6d.camel@microchip.com>
Subject: Re: [PATCH linux-next 1/1] phy: Sparx5 Eth SerDes: Use direct
 register operations
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        kernel test robot <lkp@intel.com>
Date:   Tue, 30 Mar 2021 10:18:44 +0200
In-Reply-To: <YGIimz9UnVYWfcXH@lunn.ch>
References: <20210329081438.558885-1-steen.hegelund@microchip.com>
         <20210329081438.558885-2-steen.hegelund@microchip.com>
         <YGIimz9UnVYWfcXH@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, 2021-03-29 at 20:55 +0200, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Mon, Mar 29, 2021 at 10:14:38AM +0200, Steen Hegelund wrote:
> > Use direct register operations instead of a table of register
> > information to lower the stack usage.
> > 
> > Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> > Reported-by: kernel test robot <lkp@intel.com>
> > ---
> >  drivers/phy/microchip/sparx5_serdes.c | 1869 +++++++++++++------------
> >  1 file changed, 951 insertions(+), 918 deletions(-)
> > 
> > diff --git a/drivers/phy/microchip/sparx5_serdes.c b/drivers/phy/microchip/sparx5_serdes.c
> > index 06bcf0c166cf..43de68a62c2f 100644
> > --- a/drivers/phy/microchip/sparx5_serdes.c
> > +++ b/drivers/phy/microchip/sparx5_serdes.c
> > @@ -343,12 +343,6 @@ struct sparx5_sd10g28_params {
> >       u8 fx_100;
> >  };
> > 
> > -struct sparx5_serdes_regval {
> > -     u32 value;
> > -     u32 mask;
> > -     void __iomem *addr;
> > -};
> > -
> >  static struct sparx5_sd25g28_media_preset media_presets_25g[] = {
> >       { /* ETH_MEDIA_DEFAULT */
> >               .cfg_en_adv               = 0,
> > @@ -945,431 +939,411 @@ static void sparx5_sd25g28_reset(void __iomem *regs[],
> >       }
> >  }
> > 
> > -static int sparx5_sd25g28_apply_params(struct device *dev,
> > -                                    void __iomem *regs[],
> > -                                    struct sparx5_sd25g28_params *params,
> > -                                    u32 sd_index)
> > +static int sparx5_sd25g28_apply_params(struct sparx5_serdes_macro *macro,
> > +                                    struct sparx5_sd25g28_params *params)
> >  {
> > -     struct sparx5_serdes_regval item[] = {
> 
> Could you just add const here, and then it is no longer on the stack?
> 
>    Andrew

No it still counts against the stack even as a const structure.

BR
Steen


