Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57D33609B3F
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 09:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiJXHYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 03:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbiJXHYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 03:24:37 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DD4BE1F;
        Mon, 24 Oct 2022 00:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666596270; x=1698132270;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=x2hdzbJFZkGSOjRme22bRLCPN3Dwe5K//vVXwOM7pNE=;
  b=b02sZEcbkA/LjNmkxPIXgQgc4/sO52p3MyjY0XWEDb18BM4PTWatOj4D
   U4H30qJUKkdaeMwtmQ0MF/TuQU+FlUy7vG37ZBX9/nL7UstU5u8QnQxhP
   Ylz0bvXTbqkdL2xTCoy6FG9fx9yc1i4FpoGDSxL1iGPoZ7TeYHt/epIoo
   AMPQusi44bXuoM7U1+fauTv31EjPT+RlRsS5FXxiAsR8C/tn+lkcxnAXZ
   2NsMyssiB7fmkaFzxlUasWCCIK+J5Dc+R9fmyUD9Km0jsdABccbUqE2Et
   QjORoEAHLq980EgIjpeV+9Qk4lGUOZAwIWdfFSKkf2W0lRkRM6ZkfZWWi
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,207,1661842800"; 
   d="scan'208";a="183588946"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Oct 2022 00:24:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 24 Oct 2022 00:24:26 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Mon, 24 Oct 2022 00:24:22 -0700
Date:   Mon, 24 Oct 2022 12:54:21 +0530
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <lxu@maxlinear.com>,
        <hkallweit1@gmail.com>, <pabeni@redhat.com>, <edumazet@google.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net-next] net: phy: mxl-gpy: Add PHY Auto/MDI/MDI-X set
 driver for GPY211 chips
Message-ID: <20221024072421.GB653394@raju-project-pc>
References: <20221021100305.6576-1-Raju.Lakkaraju@microchip.com>
 <Y1KmL7vTunvbw1/U@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Y1KmL7vTunvbw1/U@lunn.ch>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thank you for review comments.

The 10/21/2022 16:01, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> > +static void gpy_update_mdix(struct phy_device *phydev)
> > +{
> > +     int ret;
> > +
> > +     ret = phy_read(phydev, PHY_CTL1);
> > +     if (ret < 0) {
> > +             phydev_err(phydev, "Error: MDIO register access failed: %d\n",
> > +                        ret);
> > +             return;
> > +     }
> 
> > @@ -413,6 +490,8 @@ static void gpy_update_interface(struct phy_device *phydev)
> >
> >       if (phydev->speed == SPEED_2500 || phydev->speed == SPEED_1000)
> >               genphy_read_master_slave(phydev);
> > +
> > +     gpy_update_mdix(phydev);
> 
> Do you know why gpy_update_interface() is a void function? It is
> called from gpy_read_status() which does return error codes. And it
> seems like gpy_read_status() would benefit from returning -EINVAL, etc.

Do you want me to change gpy_update_interface() return type ?
Can I do those changes as part of this commit or need to fix on "net"
branch ?

> 
>       Andrew

-- 
--------
Thanks,
Raju
