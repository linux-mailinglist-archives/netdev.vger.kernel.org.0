Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA76F410CD4
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 20:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhISSRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 14:17:32 -0400
Received: from mx3.wp.pl ([212.77.101.9]:54354 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230503AbhISSRb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 14:17:31 -0400
Received: (wp-smtpd smtp.wp.pl 25582 invoked from network); 19 Sep 2021 20:16:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1632075360; bh=dJtM2Sa5+w2q6qeeWG9EfeAq3LLnqFx6o7OMnGapbrM=;
          h=Subject:To:From;
          b=DYYXpBESq3wTWM0U1nQ0jRh5b96tSfpQzTHOmDVRo3JrRGdjVX6e8q05LQraP2Tdl
           4ZJArJqkAJYIouZ74h5EyRMDxYSmCuu9EUT9ddaqv40TFunpsu1yOffj87vfGdPQ6N
           UlwFMKYSEoRNNHXusj7tl8YxsG0M+MME1FuD3WK4=
Received: from ip-5-172-255-97.free.aero2.net.pl (HELO [100.83.197.37]) (olek2@wp.pl@[5.172.255.97])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <linux-kernel@vger.kernel.org>; 19 Sep 2021 20:16:00 +0200
Subject: Re: [PATCH net-next 5/8] net: lantiq: configure the burst length in
 ethernet drivers
To:     Hauke Mehrtens <hauke@hauke-m.de>, john@phrozen.org,
        tsbogend@alpha.franken.de, maz@kernel.org, ralf@linux-mips.org,
        ralph.hempel@lantiq.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, dev@kresin.me, arnd@arndb.de, jgg@ziepe.ca,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210914212105.76186-1-olek2@wp.pl>
 <20210914212105.76186-5-olek2@wp.pl>
 <cdfd53e7-ea43-60a4-7150-11ad166ba2d1@hauke-m.de>
From:   Aleksander Bajkowski <olek2@wp.pl>
Message-ID: <98677485-0bdc-d628-6cc7-417c8ed1a334@wp.pl>
Date:   Sun, 19 Sep 2021 20:16:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <cdfd53e7-ea43-60a4-7150-11ad166ba2d1@hauke-m.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-WP-MailID: 94f05cca218d0575efc7ebaffd909b85
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000B [IfOE]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hauke,

On 9/15/21 12:36 AM, Hauke Mehrtens wrote:
> On 9/14/21 11:21 PM, Aleksander Jan Bajkowski wrote:
>> Configure the burst length in Ethernet drivers. This improves
>> Ethernet performance by 58%. According to the vendor BSP,
>> 8W burst length is supported by ar9 and newer SoCs.
>>
>> The NAT benchmark results on xRX200 (Down/Up):
>> * 2W: 330 Mb/s
>> * 4W: 432 Mb/s    372 Mb/s
>> * 8W: 520 Mb/s    389 Mb/s
>>
>> Tested on xRX200 and xRX330.
>>
>> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
>> ---
>>   drivers/net/ethernet/lantiq_etop.c   | 21 ++++++++++++++++++---
>>   drivers/net/ethernet/lantiq_xrx200.c | 21 ++++++++++++++++++---
>>   2 files changed, 36 insertions(+), 6 deletions(-)
>>
> .....
>> diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
>> index fb78f17d734f..5d96248ce83b 100644
>> --- a/drivers/net/ethernet/lantiq_xrx200.c
>> +++ b/drivers/net/ethernet/lantiq_xrx200.c
>> @@ -71,6 +71,9 @@ struct xrx200_priv {
>>       struct net_device *net_dev;
>>       struct device *dev;
>>   +    int tx_burst_len;
>> +    int rx_burst_len;
>> +
>>       __iomem void *pmac_reg;
>>   };
>>   @@ -316,8 +319,8 @@ static netdev_tx_t xrx200_start_xmit(struct sk_buff *skb,
>>       if (unlikely(dma_mapping_error(priv->dev, mapping)))
>>           goto err_drop;
>>   -    /* dma needs to start on a 16 byte aligned address */
>> -    byte_offset = mapping % 16;
>> +    /* dma needs to start on a burst length value aligned address */
>> +    byte_offset = mapping % (priv->tx_burst_len * 4);
>>         desc->addr = mapping - byte_offset;
>>       /* Make sure the address is written before we give it to HW */
>> @@ -369,7 +372,7 @@ static int xrx200_dma_init(struct xrx200_priv *priv)
>>       int ret = 0;
>>       int i;
>>   -    ltq_dma_init_port(DMA_PORT_ETOP);
>> +    ltq_dma_init_port(DMA_PORT_ETOP, priv->tx_burst_len, rx_burst_len);
>>         ch_rx->dma.nr = XRX200_DMA_RX;
>>       ch_rx->dma.dev = priv->dev;
>> @@ -478,6 +481,18 @@ static int xrx200_probe(struct platform_device *pdev)
>>       if (err)
>>           eth_hw_addr_random(net_dev);
>>   +    err = device_property_read_u32(dev, "lantiq,tx-burst-length", &priv->tx_burst_len);
>> +    if (err < 0) {
>> +        dev_err(dev, "unable to read tx-burst-length property\n");
>> +        return err;
>> +    }
>> +
>> +    err = device_property_read_u32(dev, "lantiq,rx-burst-length", &priv->rx_burst_len);
>> +    if (err < 0) {
>> +        dev_err(dev, "unable to read rx-burst-length property\n");
>> +        return err;
>> +    }
>> +
> 
> I would prefer if you would hard code these values to 8 for the xrx200 driver. All SoCs with this IP block should support this.
OK. I can hard code 8W burst length in the driver for xrx200. Burst length as a configurable parameter is really only needed in the lantiq_etop driver.
> 
>>       /* bring up the dma engine and IP core */
>>       err = xrx200_dma_init(priv);
>>       if (err)
>>
> 
> Hauke
Aleksander
