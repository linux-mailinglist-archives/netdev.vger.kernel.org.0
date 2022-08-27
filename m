Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A155A3518
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 08:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbiH0Gy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 02:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232280AbiH0Gy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 02:54:27 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F39F74CC6;
        Fri, 26 Aug 2022 23:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661583264; x=1693119264;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UH1E/vTeMlllSwzFZAoSra46+z3qWsWaFhDL//3BZu0=;
  b=q0unqfFtJtNLagcwhj+IwqN53NdUXBj1vxR0QZOnrpw0Zm4kI4hHX391
   gzh+8Roz250YivFJdF55IKZo9BrDEvjfYrTYeqWUgKoBwuwrs8K9oxMo2
   AKgD99LtliNtD6ZNVT+ZCdpl4HX8KVVDov09q+s9on7k2gMusNEG5evfm
   yR9kl+KinCtSp/3J48v9NrLysHHvk8anUfV6qhEP49030wmAj6RL6diqU
   +yTplyIJcHIWpiPr9/qEXi80wH/bj3uzttWfL1OQzQ0eXXn7DvcHwEnjb
   5nmXKxR2q73heQR2JkuGkOylHOJ7AhXKNG6SWkpkALjJBuucDhW9gVNN8
   w==;
X-IronPort-AV: E=Sophos;i="5.93,267,1654585200"; 
   d="scan'208";a="174423481"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Aug 2022 23:54:23 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 26 Aug 2022 23:54:23 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Fri, 26 Aug 2022 23:54:22 -0700
Date:   Sat, 27 Aug 2022 08:58:38 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>, <michael@walle.cc>,
        <UNGLinuxDriver@microchip.com>, <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH net-next v2] net: phy: micrel: Make the GPIO to be
 non-exclusive
Message-ID: <20220827065838.7iw3cubgtzhwqc53@soft-dev3-1.localhost>
References: <20220825201447.1444396-1-horatiu.vultur@microchip.com>
 <YwfYnwzQsDruVi5y@lunn.ch>
 <20220826183711.567bc7e8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220826183711.567bc7e8@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 08/26/2022 18:37, Jakub Kicinski wrote:

Hi Jakub,

> 
> On Thu, 25 Aug 2022 22:16:31 +0200 Andrew Lunn wrote:
> > On Thu, Aug 25, 2022 at 10:14:47PM +0200, Horatiu Vultur wrote:
> > > The same GPIO line can be shared by multiple phys for the coma mode pin.
> > > If that is the case then, all the other phys that share the same line
> > > will failed to be probed because the access to the gpio line is not
> > > non-exclusive.
> > > Fix this by making access to the gpio line to be nonexclusive using flag
> > > GPIOD_FLAGS_BIT_NONEXCLUSIVE. This allows all the other PHYs to be
> > > probed.
> > >
> > > Fixes: 738871b09250ee ("net: phy: micrel: add coma mode GPIO")
> > > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> >
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> The tree name switch in the subject compared to v1 is unintentional?

Yes I have switch it by mistake.
It should be net. I can send a new version if it is needed.

-- 
/Horatiu
