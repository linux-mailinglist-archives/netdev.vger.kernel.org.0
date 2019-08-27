Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59FE79E5C9
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 12:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbfH0Kiy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 27 Aug 2019 06:38:54 -0400
Received: from mga04.intel.com ([192.55.52.120]:56706 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbfH0Kiy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 06:38:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 03:38:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,436,1559545200"; 
   d="scan'208";a="355732298"
Received: from pgsmsx104.gar.corp.intel.com ([10.221.44.91])
  by orsmga005.jf.intel.com with ESMTP; 27 Aug 2019 03:38:51 -0700
Received: from pgsmsx106.gar.corp.intel.com (10.221.44.98) by
 PGSMSX104.gar.corp.intel.com (10.221.44.91) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 27 Aug 2019 18:38:50 +0800
Received: from pgsmsx103.gar.corp.intel.com ([169.254.2.25]) by
 PGSMSX106.gar.corp.intel.com ([169.254.9.10]) with mapi id 14.03.0439.000;
 Tue, 27 Aug 2019 18:38:50 +0800
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH v1 net-next 4/4] net: stmmac: setup higher frequency clk
 support for EHL & TGL
Thread-Topic: [PATCH v1 net-next 4/4] net: stmmac: setup higher frequency
 clk support for EHL & TGL
Thread-Index: AQHVXDU69zXHtb/poUqtoKXItI5YJKcNUeeAgAAFGQCAAXRAAA==
Date:   Tue, 27 Aug 2019 10:38:50 +0000
Message-ID: <D6759987A7968C4889FDA6FA91D5CBC814758DB5@PGSMSX103.gar.corp.intel.com>
References: <1566869891-29239-1-git-send-email-weifeng.voon@intel.com>
 <1566869891-29239-5-git-send-email-weifeng.voon@intel.com>
 <7d43e0c6-6f51-0d71-0af8-89f22b0234f9@gmail.com>
 <20190826201346.GJ2168@lunn.ch>
In-Reply-To: <20190826201346.GJ2168@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +#include <linux/clk-provider.h>
> > >  #include <linux/pci.h>
> > >  #include <linux/dmi.h>
> > >
> > > @@ -174,6 +175,19 @@ static int intel_mgbe_common_data(struct
> pci_dev *pdev,
> > >  	plat->axi->axi_blen[1] = 8;
> > >  	plat->axi->axi_blen[2] = 16;
> > >
> > > +	plat->ptp_max_adj = plat->clk_ptp_rate;
> > > +
> > > +	/* Set system clock */
> > > +	plat->stmmac_clk = clk_register_fixed_rate(&pdev->dev,
> > > +						   "stmmac-clk", NULL, 0,
> > > +						   plat->clk_ptp_rate);
> > > +
> > > +	if (IS_ERR(plat->stmmac_clk)) {
> > > +		dev_warn(&pdev->dev, "Fail to register stmmac-clk\n");
> > > +		plat->stmmac_clk = NULL;
> >
> > Don't you need to propagate at least EPROBE_DEFER here?
> 
> Hi Florian
> 
> Isn't a fixed rate clock a complete fake. There is no hardware behind it.
> So can it return EPROBE_DEFER?
> 
>     Andrew

Yes, there is no hardware behind it. So, I don't think we need to deferred probe
and a warning message should be sufficient. Anyhow, please point it out if I miss
out anything.

Thanks. 

