Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9545EED9
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 04:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbfD3Ctm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Apr 2019 22:49:42 -0400
Received: from mga04.intel.com ([192.55.52.120]:61778 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729803AbfD3Ctm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 22:49:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 19:49:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,412,1549958400"; 
   d="scan'208";a="341973650"
Received: from kmsmsx151.gar.corp.intel.com ([172.21.73.86])
  by fmsmga005.fm.intel.com with ESMTP; 29 Apr 2019 19:49:40 -0700
Received: from pgsmsx103.gar.corp.intel.com ([169.254.2.111]) by
 KMSMSX151.gar.corp.intel.com ([169.254.10.147]) with mapi id 14.03.0415.000;
 Tue, 30 Apr 2019 10:49:17 +0800
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Andrew Lunn" <andrew@lunn.ch>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>
Subject: RE: [PATCH 3/7] net: stmmac: dma channel control register need to
 be init first
Thread-Topic: [PATCH 3/7] net: stmmac: dma channel control register need to
 be init first
Thread-Index: AQHU+n51zHATXbnSNU2iG6YzCcFjoaZMdYaggAX7OACAAZgcYA==
Date:   Tue, 30 Apr 2019 02:49:16 +0000
Message-ID: <D6759987A7968C4889FDA6FA91D5CBC8146F0B78@PGSMSX103.gar.corp.intel.com>
References: <1556126241-2774-1-git-send-email-weifeng.voon@intel.com>
 <1556126241-2774-4-git-send-email-weifeng.voon@intel.com>
 <D6759987A7968C4889FDA6FA91D5CBC8146EF098@PGSMSX103.gar.corp.intel.com>
 <78EB27739596EE489E55E81C33FEC33A0B46E022@DE02WEMBXB.internal.synopsys.com>
In-Reply-To: <78EB27739596EE489E55E81C33FEC33A0B46E022@DE02WEMBXB.internal.synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNjhlMzk2MzgtYWVhNy00MmI5LWE4NDEtODg2MzM2ZDJmNTFmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoicFZzRmNRTlBaamlxMEk1c2dMZjNQNmhLRGNiVEFpT1p0eHpHUk1ZTnZmdXJDZU53UGtSXC9IcnlRZXZKTVJ5U2sifQ==
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Voon, Weifeng <weifeng.voon@intel.com>
> Date: Thu, Apr 25, 2019 at 08:06:08
> 
> > > stmmac_init_chan() needs to be called before stmmac_init_rx_chan()
> > > and stmmac_init_tx_chan(). This is because if PBLx8 is to be used,
> > > "DMA_CH(#i)_Control.PBLx8" needs to be set before programming
> > > "DMA_CH(#i)_TX_Control.TxPBL" and "DMA_CH(#i)_RX_Control.RxPBL".
> > >
> > > Reviewed-by: Zhang, Baoli <baoli.zhang@intel.com>
> > > Signed-off-by: Weifeng Voon <weifeng.voon@intel.com>
> > > Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> 
> This is a fix so it should belong to -net tree and it should have the
> "Fixes: " tag.
> 
> Thanks,
> Jose Miguel Abreu

Noted. I will add the "Fixes" tag and re-submit to -net tree. 

Regards,
Weifeng
