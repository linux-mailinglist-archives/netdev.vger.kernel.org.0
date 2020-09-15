Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A7B269D91
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 06:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgIOEpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 00:45:07 -0400
Received: from linux.microsoft.com ([13.77.154.182]:36392 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgIOEpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 00:45:06 -0400
Received: from [192.168.0.114] (unknown [49.207.201.19])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5925B209F317;
        Mon, 14 Sep 2020 21:45:00 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5925B209F317
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1600145104;
        bh=JnkKK4TYMC57FJonHcCEEa8eYYwBIYvyjnwlcZEjYEs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=OI4rhB497LmSP7xruPdMHORW6JEokhQmX1WE75fo0zPqNuiXsEO+aw+1D6w2G7ZEu
         wvQrIW13MJaTEyc6PFvZCo6CClhKa3UnGSdWHfNOngWKlrEJU8ImPQ0xfOdet/V0/M
         o3IvEttFz6H3/u0heXB/9WDXbd20wBPcVoag0UL4=
Subject: Re: [RESEND net-next v2 00/12]drivers: net: convert tasklets to use
 new tasklet_setup() API
To:     Saeed Mahameed <saeedm@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>
Cc:     "m.grzeschik@pengutronix.de" <m.grzeschik@pengutronix.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "woojung.huh@microchip.com" <woojung.huh@microchip.com>,
        "petkan@nucleusys.com" <petkan@nucleusys.com>,
        "oliver@neukum.org" <oliver@neukum.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "linux-ppp@vger.kernel.org" <linux-ppp@vger.kernel.org>
References: <20200914073131.803374-1-allen.lkml@gmail.com>
 <5ab44bd27936325201e8f71a30e74d8b9d6b34ee.camel@nvidia.com>
 <87508263-99f1-c56a-5fb1-2f4700b6b375@linux.microsoft.com>
 <52bb16899e14923b7df195d6c9e68dad6a7a404b.camel@nvidia.com>
From:   Allen Pais <apais@linux.microsoft.com>
Message-ID: <9d9029bd-720d-dc2a-8cbf-8d084fb7e1db@linux.microsoft.com>
Date:   Tue, 15 Sep 2020 10:14:57 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <52bb16899e14923b7df195d6c9e68dad6a7a404b.camel@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Saeed,
>>>> ommit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
>>>> introduced a new tasklet initialization API. This series converts
>>>> all the net/* drivers to use the new tasklet_setup() API
>        ^^^
> this is not all drivers ..

Right, my bad, I should not have said net/*.


> see below
> 
>>>> This series is based on v5.9-rc5
>>>>
>>>> Allen Pais (12):
>>>>     net: mvpp2: Prepare to use the new tasklet API
>>>>     net: arcnet: convert tasklets to use new tasklet_setup() API
>>>>     net: caif: convert tasklets to use new tasklet_setup() API
>>>>     net: ifb: convert tasklets to use new tasklet_setup() API
>>>>     net: ppp: convert tasklets to use new tasklet_setup() API
>>>>     net: cdc_ncm: convert tasklets to use new tasklet_setup() API
>>>>     net: hso: convert tasklets to use new tasklet_setup() API
>>>>     net: lan78xx: convert tasklets to use new tasklet_setup() API
>>>>     net: pegasus: convert tasklets to use new tasklet_setup() API
>>>>     net: r8152: convert tasklets to use new tasklet_setup() API
>>>>     net: rtl8150: convert tasklets to use new tasklet_setup() API
>>>>     net: usbnet: convert tasklets to use new tasklet_setup() API
>>>>
>>>>
>>>
>>> You are only converting drivers which are passing the taskelt
>>> struct as
>>> data ptr, most of other drivers are passing the container of the
>>> tasklet as data, why not convert them as well, and let them use
>>> container_of to find their data ? it is really straight forward and
>>> will help convert most of net driver if not all.
>>>
>>
>> from_tasklet uses container_of internally. use of container_of is
>> avoided cause it end being really long.
> 
> I understand that, what I meant, you didn't really convert all drivers,
> as you claim in the cover letter, all you did is converting __some__
> drivers which are passing the tasklet ptr as data ptr. all other
> drivers that use tasklet_init differently are not converted, and it
> should be relatively easy as i explained above.
> 
> The list of drivers using tasklet_init is longer than what you touched
> in your series:
> 
>   drivers/net/arcnet/arcnet.c                     |  7 +++----
>   drivers/net/caif/caif_virtio.c                  |  8 +++-----
>   drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  1 +
>   drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |  1 +
>   drivers/net/ifb.c                               |  7 +++----
>   drivers/net/ppp/ppp_async.c                     |  8 ++++----
>   drivers/net/ppp/ppp_synctty.c                   |  8 ++++----
>   drivers/net/usb/cdc_ncm.c                       |  8 ++++----
>   drivers/net/usb/hso.c                           | 10 +++++-----
>   drivers/net/usb/lan78xx.c                       |  6 +++---
>   drivers/net/usb/pegasus.c                       |  6 +++---
>   drivers/net/usb/r8152.c                         |  8 +++-----
>   drivers/net/usb/rtl8150.c                       |  6 +++---
>   drivers/net/usb/usbnet.c                        |  3 +--
>   14 files changed, 41 insertions(+), 46 deletions(-)
> 
> The full file/driver list :

Yes, drivers/net/ethernet/* drivers/net/wireless/* were submitted as a 
separate series. The rest of them were part of the series above.

I should break it down so that it's easier to bisect.

Thanks.


> 
> $ git grep -l tasklet_init drivers/net/
> drivers/net/arcnet/arcnet.c
> drivers/net/caif/caif_virtio.c
> drivers/net/ethernet/alteon/acenic.c
> drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> drivers/net/ethernet/amd/xgbe/xgbe-i2c.c
> drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
> drivers/net/ethernet/broadcom/cnic.c
> drivers/net/ethernet/cadence/macb_main.c
> drivers/net/ethernet/cavium/liquidio/lio_main.c
> drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
> drivers/net/ethernet/cavium/thunder/nicvf_main.c
> drivers/net/ethernet/chelsio/cxgb/sge.c
> drivers/net/ethernet/chelsio/cxgb3/sge.c
> drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
> drivers/net/ethernet/chelsio/cxgb4/sge.c
> drivers/net/ethernet/dlink/sundance.c
> drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
> drivers/net/ethernet/ibm/ehea/ehea_main.c
> drivers/net/ethernet/ibm/ibmvnic.c
> drivers/net/ethernet/jme.c
> drivers/net/ethernet/marvell/skge.c
> drivers/net/ethernet/mellanox/mlx4/eq.c
> drivers/net/ethernet/mellanox/mlx5/core/eq.c
> drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
> drivers/net/ethernet/mellanox/mlxsw/pci.c
> drivers/net/ethernet/micrel/ks8842.c
> drivers/net/ethernet/micrel/ksz884x.c
> drivers/net/ethernet/natsemi/ns83820.c
> drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> drivers/net/ethernet/ni/nixge.c
> drivers/net/ethernet/qlogic/qed/qed_int.c
> drivers/net/ethernet/silan/sc92031.c
> drivers/net/ethernet/smsc/smc91x.c
> drivers/net/ifb.c
> drivers/net/ppp/ppp_async.c
> drivers/net/ppp/ppp_synctty.c
> drivers/net/usb/cdc_ncm.c
> drivers/net/usb/hso.c
> drivers/net/usb/lan78xx.c
> drivers/net/usb/pegasus.c
> drivers/net/usb/r8152.c
> drivers/net/usb/rtl8150.c
> drivers/net/wireless/ath/ath11k/pci.c
> drivers/net/wireless/mediatek/mt76/mac80211.c
> drivers/net/wireless/mediatek/mt76/mt7603/init.c
> drivers/net/wireless/mediatek/mt76/mt7615/mmio.c
> drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
> drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
> drivers/net/wireless/mediatek/mt76/usb.c
> drivers/net/wireless/mediatek/mt7601u/dma.c
> 
