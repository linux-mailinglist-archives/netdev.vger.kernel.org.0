Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC41B1552D5
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 08:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgBGHVn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 7 Feb 2020 02:21:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:53490 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgBGHVn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Feb 2020 02:21:43 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 23:21:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,412,1574150400"; 
   d="scan'208";a="250325781"
Received: from pgsmsx104.gar.corp.intel.com ([10.221.44.91])
  by orsmga002.jf.intel.com with ESMTP; 06 Feb 2020 23:21:39 -0800
Received: from pgsmsx114.gar.corp.intel.com ([169.254.4.192]) by
 PGSMSX104.gar.corp.intel.com ([169.254.3.14]) with mapi id 14.03.0439.000;
 Fri, 7 Feb 2020 15:21:38 +0800
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v4 1/6] net: stmmac: Fix incorrect location to set
 real_num_rx|tx_queues
Thread-Topic: [PATCH net v4 1/6] net: stmmac: Fix incorrect location to set
 real_num_rx|tx_queues
Thread-Index: AQHV3AI9OlvIBg8tJE+vuiHHv7FbVKgMFToAgAM6L7A=
Date:   Fri, 7 Feb 2020 07:21:38 +0000
Message-ID: <AF233D1473C1364ABD51D28909A1B1B75C4A8F7E@pgsmsx114.gar.corp.intel.com>
References: <20200205085510.32353-1-boon.leong.ong@intel.com>
        <20200205085510.32353-2-boon.leong.ong@intel.com>
 <20200205.143924.1875004608052019375.davem@davemloft.net>
In-Reply-To: <20200205.143924.1875004608052019375.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wednesday, February 5, 2020 9:39 PM

>From: Ong Boon Leong <boon.leong.ong@intel.com>
>Date: Wed,  5 Feb 2020 16:55:05 +0800
>
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> index 5836b21edd7e..4d9afa13eeb9 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> @@ -2657,6 +2657,10 @@ static int stmmac_hw_setup(struct net_device
>*dev, bool init_ptp)
>>  >--->-------stmmac_enable_tbs(priv, priv->ioaddr, enable, chan);
>>  >---}
>>
>> +>---/* Configure real RX and TX queues */
>> +>---netif_set_real_num_rx_queues(dev, priv->plat->rx_queues_to_use);
>> +>---netif_set_real_num_tx_queues(dev, priv->plat->tx_queues_to_use);
>> +
>>  >---/* Start the ball rolling... */
>>  >---stmmac_start_all_dma(priv);
>>
>
>It is only safe to ignore the return values from
>netif_set_real_num_{rx,tx}_queues() if you call them before the
>network device is registered.  Because only in that case are these
>functions guaranteed to succeed.
>
>But now that you have moved these calls here, they can fail.
>
>Therefore you must check the return value and unwind the state
>completely upon failures.
>
>Honestly, I think this change will have several undesirable side effects:
>
>1) Lots of added new code complexity
>
>2) A new failure mode when resuming the device, users will find this
>   very hard to diagnose and recover from
>
>What real value do you get from doing these calls after probe?
>
>If you can't come up with a suitable answer to that question, you
>should reconsider this change.
>
>Thanks.

We have patch that implements get|set_channels() that depends on this fix.
Anyway, we understand your insight and perspective now. So, we will drop
this patch in v5 series.

Thanks
