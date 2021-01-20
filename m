Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DE22FCB66
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 08:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbhATHUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 02:20:07 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:18288 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726590AbhATHUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 02:20:04 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4DLH2V124pz9tyLV;
        Wed, 20 Jan 2021 08:19:14 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id m0VUYn4JViGU; Wed, 20 Jan 2021 08:19:14 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4DLH2V06yfz9tyLS;
        Wed, 20 Jan 2021 08:19:14 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id F12158B7DF;
        Wed, 20 Jan 2021 08:19:14 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id WJJ0ptMeg3rT; Wed, 20 Jan 2021 08:19:14 +0100 (CET)
Received: from [172.25.230.103] (po15451.idsi0.si.c-s.fr [172.25.230.103])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id B1A908B75F;
        Wed, 20 Jan 2021 08:19:14 +0100 (CET)
Subject: Re: [PATCH net-next v2 14/17] ethernet: ucc_geth: replace
 kmalloc_array()+for loop by kcalloc()
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
 <20210119150802.19997-15-rasmus.villemoes@prevas.dk>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <1703a0ac-5266-3f56-fbff-2c141dfa3022@csgroup.eu>
Date:   Wed, 20 Jan 2021 08:19:10 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210119150802.19997-15-rasmus.villemoes@prevas.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Can you detail a bit the change ?

At least tell that the loop was a zeroising loop and that kcalloc() already zeroises the allocated 
memory ?

Le 19/01/2021 à 16:07, Rasmus Villemoes a écrit :
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> ---
>   drivers/net/ethernet/freescale/ucc_geth.c | 14 ++++----------
>   1 file changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
> index 1e9d2f3f47a3..621a9e3e4b65 100644
> --- a/drivers/net/ethernet/freescale/ucc_geth.c
> +++ b/drivers/net/ethernet/freescale/ucc_geth.c
> @@ -2203,8 +2203,8 @@ static int ucc_geth_alloc_tx(struct ucc_geth_private *ugeth)
>   	for (j = 0; j < ug_info->numQueuesTx; j++) {
>   		/* Setup the skbuff rings */
>   		ugeth->tx_skbuff[j] =
> -			kmalloc_array(ugeth->ug_info->bdRingLenTx[j],
> -				      sizeof(struct sk_buff *), GFP_KERNEL);
> +			kcalloc(ugeth->ug_info->bdRingLenTx[j],
> +				sizeof(struct sk_buff *), GFP_KERNEL);
>   
>   		if (ugeth->tx_skbuff[j] == NULL) {
>   			if (netif_msg_ifup(ugeth))
> @@ -2212,9 +2212,6 @@ static int ucc_geth_alloc_tx(struct ucc_geth_private *ugeth)
>   			return -ENOMEM;
>   		}
>   
> -		for (i = 0; i < ugeth->ug_info->bdRingLenTx[j]; i++)
> -			ugeth->tx_skbuff[j][i] = NULL;
> -
>   		ugeth->skb_curtx[j] = ugeth->skb_dirtytx[j] = 0;
>   		bd = ugeth->confBd[j] = ugeth->txBd[j] = ugeth->p_tx_bd_ring[j];
>   		for (i = 0; i < ug_info->bdRingLenTx[j]; i++) {
> @@ -2266,8 +2263,8 @@ static int ucc_geth_alloc_rx(struct ucc_geth_private *ugeth)
>   	for (j = 0; j < ug_info->numQueuesRx; j++) {
>   		/* Setup the skbuff rings */
>   		ugeth->rx_skbuff[j] =
> -			kmalloc_array(ugeth->ug_info->bdRingLenRx[j],
> -				      sizeof(struct sk_buff *), GFP_KERNEL);
> +			kcalloc(ugeth->ug_info->bdRingLenRx[j],
> +				sizeof(struct sk_buff *), GFP_KERNEL);
>   
>   		if (ugeth->rx_skbuff[j] == NULL) {
>   			if (netif_msg_ifup(ugeth))
> @@ -2275,9 +2272,6 @@ static int ucc_geth_alloc_rx(struct ucc_geth_private *ugeth)
>   			return -ENOMEM;
>   		}
>   
> -		for (i = 0; i < ugeth->ug_info->bdRingLenRx[j]; i++)
> -			ugeth->rx_skbuff[j][i] = NULL;
> -
>   		ugeth->skb_currx[j] = 0;
>   		bd = ugeth->rxBd[j] = ugeth->p_rx_bd_ring[j];
>   		for (i = 0; i < ug_info->bdRingLenRx[j]; i++) {
> 
