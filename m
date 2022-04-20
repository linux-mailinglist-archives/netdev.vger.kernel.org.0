Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1E875082F0
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 09:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376484AbiDTH5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 03:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348806AbiDTH5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 03:57:16 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7373C4AA;
        Wed, 20 Apr 2022 00:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1650441268; x=1681977268;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bWFEfGitKdMdgdAQmadBNZq/Q/gzOOJXd/nmAVkjgXU=;
  b=ogFIotafdHIMt2uD3LEg2IPZwU2YNmwxh2x2lDLDKBYmmp6t/maSPdNR
   kVFsb9WxaK8o474oyx6cGDZxou5caaupWnymD/d+8AbgHEp//7d79qC0I
   gzQjCpruP7tHnsg2YUMfuSByowsGm9lTl+86JeEWl2JZjEMUODCpXXhIo
   Nxrwc3VQD5gs96y0c3p+PKZZ2kJnWbA3OKe/eFVT1j50hGL/CfPz6+GLQ
   yNtd3PemM8dyOa3Qfmc6Kx8MM8LEyTDlajh86Zaa70wXjWwn8qVWwHmAb
   YozGbZthGj4xm5ZZPeYst6Ecnk9D1uVzI4fLaGEje6AW2KGmMW1SWZTd/
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,275,1643698800"; 
   d="scan'208";a="160657894"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Apr 2022 00:54:28 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 20 Apr 2022 00:54:27 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Wed, 20 Apr 2022 00:54:27 -0700
Date:   Wed, 20 Apr 2022 09:57:43 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>, <richardcochran@gmail.com>
Subject: Re: [RFC PATCH net-next 0/2] net: phy: Extend sysfs to adjust PHY
 latency.
Message-ID: <20220420075743.zlragdh525vpzgkz@soft-dev3-1.localhost>
References: <20220419083704.48573-1-horatiu.vultur@microchip.com>
 <Yl6oZLIaBnPVkeqN@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Yl6oZLIaBnPVkeqN@lunn.ch>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/19/2022 14:17, Andrew Lunn wrote:

Hi Andrew,

> 
> On Tue, Apr 19, 2022 at 10:37:02AM +0200, Horatiu Vultur wrote:
> > The previous try of setting the PHY latency was here[1]. But this approach
> > could not work for multiple reasons:
> > - the interface was not generic enough so it would be hard to be extended
> >   in the future
> > - if there were multiple time stamper in the system then it was not clear
> >   to which one should adjust these values.
> >
> > So the next try is to extend sysfs and configure exactly the desired PHY.
> 
> What about timestampers which are not PHYs? Ideally you want one
> interface which will work for any sort of stamper, be it MAC, PHY, or
> a bump in the wire between the MAC and the PHY.

My initial idea was that each of the timestampers will need to extend
the sysfs to add this file or multiple files. But from what I can see
this approach will not fly.

If we want an interface to be used by any sort of stamper, we could
create a new generic class (eth_tunable/eth_obj). Then each driver will
register a device that will use this generic class.
We will continue to use sysfs to expose all the modes supported by the
driver. But this time create a file for each mode.
The entire approach should be something similar with the ptp clocks.
What do you think, is this the right approach?

> 
>   Andrew

-- 
/Horatiu
