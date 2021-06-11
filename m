Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E4B3A4A61
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhFKUzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:55:05 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:37434 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbhFKUzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 16:55:04 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 15BKr1lr003367;
        Fri, 11 Jun 2021 15:53:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1623444781;
        bh=OXOHFNWGFBcOzEQxsJ5B9bTZa4VVR3rYf4P90qJOCmE=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=uoY5VvKZ0MF4xYG8gEDRAPmv2y3d0Sc0y+zvDuPmtcLQn+AHPWL+g6hKESuoe50mP
         XumAeUnmTGFesSEy6mOV4PTNBbYLnT9wnxzFpxhc/UQh7hsEeKhCoxJ4UrHUidL+02
         Uwabdo6LuXSQCkHCYO/+nGZ0U8vTBs1o2zN1i/ds=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 15BKr1UB121519
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Jun 2021 15:53:01 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 11
 Jun 2021 15:53:00 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Fri, 11 Jun 2021 15:53:01 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 15BKqwAc128126;
        Fri, 11 Jun 2021 15:52:59 -0500
Subject: Re: [PATCH net] net: ethernet: ti: cpsw: fix min eth packet size for
 non-switch use-cases
To:     Ben Hutchings <ben.hutchings@essensium.com>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <linux-omap@vger.kernel.org>, Lokesh Vutla <lokeshvutla@ti.com>,
        <stable@vger.kernel.org>
References: <20210611132732.10690-1-grygorii.strashko@ti.com>
 <20210611175448.GA25728@cephalopod>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <7d41dc85-ba44-ff46-8c53-019f97e0703d@ti.com>
Date:   Fri, 11 Jun 2021 23:52:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210611175448.GA25728@cephalopod>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/06/2021 20:54, Ben Hutchings wrote:
> On Fri, Jun 11, 2021 at 04:27:32PM +0300, Grygorii Strashko wrote:
> [...]
>> --- a/drivers/net/ethernet/ti/cpsw_new.c
>> +++ b/drivers/net/ethernet/ti/cpsw_new.c
>> @@ -918,14 +918,17 @@ static netdev_tx_t cpsw_ndo_start_xmit(struct sk_buff *skb,
>>   	struct cpts *cpts = cpsw->cpts;
>>   	struct netdev_queue *txq;
>>   	struct cpdma_chan *txch;
>> +	unsigned int len;
>>   	int ret, q_idx;
>>   
>> -	if (skb_padto(skb, CPSW_MIN_PACKET_SIZE)) {
>> +	if (skb_padto(skb, priv->tx_packet_min)) {
>>   		cpsw_err(priv, tx_err, "packet pad failed\n");
>>   		ndev->stats.tx_dropped++;
>>   		return NET_XMIT_DROP;
>>   	}
>>   
>> +	len = skb->len < priv->tx_packet_min ? priv->tx_packet_min : skb->len;
>> +
>>   	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
>>   	    priv->tx_ts_enabled && cpts_can_timestamp(cpts, skb))
>>   		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
>> @@ -937,7 +940,7 @@ static netdev_tx_t cpsw_ndo_start_xmit(struct sk_buff *skb,
>>   	txch = cpsw->txv[q_idx].ch;
>>   	txq = netdev_get_tx_queue(ndev, q_idx);
>>   	skb_tx_timestamp(skb);
>> -	ret = cpdma_chan_submit(txch, skb, skb->data, skb->len,
>> +	ret = cpdma_chan_submit(txch, skb, skb->data, len,
>>   				priv->emac_port);
>>   	if (unlikely(ret != 0)) {
>>   		cpsw_err(priv, tx_err, "desc submit failed\n");
> 
> This change is odd because cpdma_chan_submit() already pads the DMA
> length.
> 
> Would it not make more sense to update cpdma_params::min_packet_size
> instead of adding a second minimum?

i've been thinking about it, but cpdma parameter copied into cpdma context once at probe,
so change will be more complex.
Can be done if you insist.

> 
> [...]
>> @@ -1686,6 +1690,7 @@ static int cpsw_dl_switch_mode_set(struct devlink *dl, u32 id,
>>   
>>   			priv = netdev_priv(sl_ndev);
>>   			slave->port_vlan = vlan;
>> +			priv->tx_packet_min = CPSW_MIN_PACKET_SIZE_VLAN;
>>   			if (netif_running(sl_ndev))
>>   				cpsw_port_add_switch_def_ale_entries(priv,
>>   								     slave);
>> @@ -1714,6 +1719,7 @@ static int cpsw_dl_switch_mode_set(struct devlink *dl, u32 id,
>>   
>>   			priv = netdev_priv(slave->ndev);
>>   			slave->port_vlan = slave->data->dual_emac_res_vlan;
>> +			priv->tx_packet_min = CPSW_MIN_PACKET_SIZE;
>>   			cpsw_port_add_dual_emac_def_ale_entries(priv, slave);
>>   		}
>>
> [...]
> 
> What happens if this races with the TX path?  Should there be a
> netif_tx_lock() / netif_tx_unlock() around this change?

Mode change operation is heavy and expected to be done once when bridge is configured.
It will completely wipe out all ALE entries and so all VLAN setting -
which any way need to be configured (reconfigured) during bridge configuration.
So, traffic can be disturbed during mode change operation.

As result, in my opinion, it make no sense to add additional complexity here.

-- 
Best regards,
grygorii
