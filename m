Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B918E3F3423
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 20:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhHTS54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 14:57:56 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:36866 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhHTS5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 14:57:53 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 68E6622F70B6
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next 12/18] ravb: Factorise {emac,dmac} init function
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "Prabhakar Mahadev Lad" <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
 <20210722141351.13668-13-biju.das.jz@bp.renesas.com>
 <1bd80ea3-c216-a42a-c46c-0bb13173d793@gmail.com>
 <OS0PR01MB5922828353A987C9A474522C86C19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <1dbfc326-5e15-d533-5b02-ef0680a8221f@omp.ru>
Date:   Fri, 20 Aug 2021 21:57:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB5922828353A987C9A474522C86C19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/21 6:42 PM, Biju Das wrote:

[...]
>>> The R-Car AVB module has Magic packet detection, multiple irq's and
>>> timestamp enable features which is not present on RZ/G2L Gigabit
>>                                    ^ are
> 
> OK. Will fix this in next patch set.
> 
>>
>>> Ethernet module. Factorise emac and dmac initialization function to
>>> support the later SoC.
>>>
>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>>> ---
>>>  drivers/net/ethernet/renesas/ravb.h      |  2 +
>>>  drivers/net/ethernet/renesas/ravb_main.c | 58
>>> ++++++++++++++++--------
>>>  2 files changed, 40 insertions(+), 20 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/renesas/ravb.h
>>> b/drivers/net/ethernet/renesas/ravb.h
>>> index d82bfa6e57c1..4d5910dcda86 100644
>>> --- a/drivers/net/ethernet/renesas/ravb.h
>>> +++ b/drivers/net/ethernet/renesas/ravb.h
>>> @@ -992,6 +992,8 @@ struct ravb_ops {
>>>  	void (*ring_free)(struct net_device *ndev, int q);
>>>  	void (*ring_format)(struct net_device *ndev, int q);
>>>  	bool (*alloc_rx_desc)(struct net_device *ndev, int q);
>>> +	void (*emac_init)(struct net_device *ndev);
>>> +	void (*dmac_init)(struct net_device *ndev);
>>>  };
>>>
>>>  struct ravb_drv_data {
>>> diff --git a/drivers/net/ethernet/renesas/ravb_main.c
>>> b/drivers/net/ethernet/renesas/ravb_main.c
>>> index 3d0f6598b936..e200114376e4 100644
>>> --- a/drivers/net/ethernet/renesas/ravb_main.c
>>> +++ b/drivers/net/ethernet/renesas/ravb_main.c
>>> @@ -454,7 +454,7 @@ static int ravb_ring_init(struct net_device *ndev,
>>> int q)  }
>>>
>>>  /* E-MAC init function */
>>> -static void ravb_emac_init(struct net_device *ndev)
>>> +static void ravb_emac_init_ex(struct net_device *ndev)
>>>  {
>>>  	/* Receive frame limit set register */
>>>  	ravb_write(ndev, ndev->mtu + ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN,
>>> RFLR); @@ -480,30 +480,19 @@ static void ravb_emac_init(struct
>> net_device *ndev)
>>>  	ravb_write(ndev, ECSIPR_ICDIP | ECSIPR_MPDIP | ECSIPR_LCHNGIP,
>>> ECSIPR);  }
>>>
>>> -/* Device init function for Ethernet AVB */
>>
>>    Grr, this comment seems oudated...
> 
> OK.

   Just don't move the comment. :-)

>>> -static int ravb_dmac_init(struct net_device *ndev)
>>> +static void ravb_emac_init(struct net_device *ndev)
>>>  {
>>>  	struct ravb_private *priv = netdev_priv(ndev);
>>>  	const struct ravb_drv_data *info = priv->info;
>>> -	int error;
>>>
>>> -	/* Set CONFIG mode */
>>> -	error = ravb_config(ndev);
>>> -	if (error)
>>> -		return error;
>>> -
>>> -	error = ravb_ring_init(ndev, RAVB_BE);
>>> -	if (error)
>>> -		return error;
>>> -	error = ravb_ring_init(ndev, RAVB_NC);
>>> -	if (error) {
>>> -		ravb_ring_free(ndev, RAVB_BE);
>>> -		return error;
>>> -	}
>>> +	info->ravb_ops->emac_init(ndev);
>>> +}
>>
>>    The whole ravb_emac_init() now consists only of a single method call?
>> Why do we need it at all?
> 
> OK will assign info->emac_init with ravb_emac_init, so GbEthernet just need to
> fill emac_init function. I will remove the function "ravb_emac_init_ex".

  Will the EMAC init methods differ so much as to we should provide 2 separate
implementations?

[...]
>>> +static void ravb_dmac_init_ex(struct net_device *ndev)
>>
>>    Please no _ex suffixes -- reminds me of Windoze too much. :-)
> 
> OK. Will change it to ravb_device_init

   Ugh! Why not leave it named ravb_dmac_init()?

> Regards,
> Biju
> 
>>
>>> +{
>>> +	struct ravb_private *priv = netdev_priv(ndev);
>>> +	const struct ravb_drv_data *info = priv->info;
>>>
>>>  	/* Set AVB RX */
>>>  	ravb_write(ndev,
>>> @@ -530,6 +519,33 @@ static int ravb_dmac_init(struct net_device *ndev)
>>>  	ravb_write(ndev, RIC2_QFE0 | RIC2_QFE1 | RIC2_RFFE, RIC2);
>>>  	/* Frame transmitted, timestamp FIFO updated */
>>>  	ravb_write(ndev, TIC_FTE0 | TIC_FTE1 | TIC_TFUE, TIC);
>>> +}
>>> +
>>> +static int ravb_dmac_init(struct net_device *ndev) {
>>> +	struct ravb_private *priv = netdev_priv(ndev);
>>> +	const struct ravb_drv_data *info = priv->info;
>>> +	int error;
>>> +
>>> +	/* Set CONFIG mode */
>>> +	error = ravb_config(ndev);
>>> +	if (error)
>>> +		return error;
>>> +
>>> +	error = ravb_ring_init(ndev, RAVB_BE);
>>> +	if (error)
>>> +		return error;
>>> +	error = ravb_ring_init(ndev, RAVB_NC);
>>> +	if (error) {
>>> +		ravb_ring_free(ndev, RAVB_BE);
>>> +		return error;
>>> +	}
>>> +
>>> +	/* Descriptor format */
>>> +	ravb_ring_format(ndev, RAVB_BE);
>>> +	ravb_ring_format(ndev, RAVB_NC);
>>> +
>>> +	info->ravb_ops->dmac_init(ndev);
>>>
>>>  	/* Setting the control will start the AVB-DMAC process. */
>>>  	ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_OPERATION); @@ -2018,6
>>> +2034,8 @@ static const struct ravb_ops ravb_gen3_ops = {
>>>  	.ring_free = ravb_ring_free_rx,
>>>  	.ring_format = ravb_ring_format_rx,
>>>  	.alloc_rx_desc = ravb_alloc_rx_desc,
>>> +	.emac_init = ravb_emac_init_ex,
>>> +	.dmac_init = ravb_dmac_init_ex,
>>
>>    Hmm, why not also gen2?!

   The question remained unreplied?... :-/

MBR, Sergey 
