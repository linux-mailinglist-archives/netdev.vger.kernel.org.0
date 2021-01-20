Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275732FCB63
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 08:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbhATHSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 02:18:34 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:5530 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727744AbhATHS2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 02:18:28 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4DLH0R61MKz9tyLS;
        Wed, 20 Jan 2021 08:17:27 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id VD5vHr_64NrK; Wed, 20 Jan 2021 08:17:27 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4DLH0R516yz9tyLR;
        Wed, 20 Jan 2021 08:17:27 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 9F2D08B7DF;
        Wed, 20 Jan 2021 08:17:28 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id w27xf3pu5l72; Wed, 20 Jan 2021 08:17:28 +0100 (CET)
Received: from [172.25.230.103] (po15451.idsi0.si.c-s.fr [172.25.230.103])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 365558B75F;
        Wed, 20 Jan 2021 08:17:28 +0100 (CET)
Subject: Re: [PATCH net-next v2 13/17] ethernet: ucc_geth: remove bd_mem_part
 and all associated code
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
 <20210119150802.19997-14-rasmus.villemoes@prevas.dk>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <58e13bb0-11fa-95e7-e9d9-acc649af4df7@csgroup.eu>
Date:   Wed, 20 Jan 2021 08:17:24 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210119150802.19997-14-rasmus.villemoes@prevas.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 19/01/2021 à 16:07, Rasmus Villemoes a écrit :
> The bd_mem_part member of ucc_geth_info always has the value
> MEM_PART_SYSTEM, and AFAICT, there has never been any code setting it
> to any other value. Moreover, muram is a somewhat precious resource,
> so there's no point using that when normal memory serves just as well.
> 
> Apart from removing a lot of dead code, this is also motivated by
> wanting to clean up the "store result from kmalloc() in a u32" mess.
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> ---
>   drivers/net/ethernet/freescale/ucc_geth.c | 108 ++++++----------------
>   include/soc/fsl/qe/qe.h                   |   6 --
>   include/soc/fsl/qe/ucc_fast.h             |   1 -
>   3 files changed, 29 insertions(+), 86 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
> index 2369a5ede680..1e9d2f3f47a3 100644
> --- a/drivers/net/ethernet/freescale/ucc_geth.c
> +++ b/drivers/net/ethernet/freescale/ucc_geth.c
> @@ -72,7 +72,6 @@ MODULE_PARM_DESC(debug, "Debug verbosity level (0=none, ..., 0xffff=all)");
>   
>   static const struct ucc_geth_info ugeth_primary_info = {
>   	.uf_info = {
> -		    .bd_mem_part = MEM_PART_SYSTEM,
>   		    .rtsm = UCC_FAST_SEND_IDLES_BETWEEN_FRAMES,
>   		    .max_rx_buf_length = 1536,
>   		    /* adjusted at startup if max-speed 1000 */
> @@ -1854,12 +1853,7 @@ static void ucc_geth_free_rx(struct ucc_geth_private *ugeth)
>   
>   			kfree(ugeth->rx_skbuff[i]);
>   
> -			if (ugeth->ug_info->uf_info.bd_mem_part ==
> -			    MEM_PART_SYSTEM)
> -				kfree((void *)ugeth->rx_bd_ring_offset[i]);
> -			else if (ugeth->ug_info->uf_info.bd_mem_part ==
> -				 MEM_PART_MURAM)
> -				qe_muram_free(ugeth->rx_bd_ring_offset[i]);
> +			kfree((void *)ugeth->rx_bd_ring_offset[i]);
>   			ugeth->p_rx_bd_ring[i] = NULL;
>   		}
>   	}
> @@ -1897,12 +1891,7 @@ static void ucc_geth_free_tx(struct ucc_geth_private *ugeth)
>   		kfree(ugeth->tx_skbuff[i]);
>   
>   		if (ugeth->p_tx_bd_ring[i]) {
> -			if (ugeth->ug_info->uf_info.bd_mem_part ==
> -			    MEM_PART_SYSTEM)
> -				kfree((void *)ugeth->tx_bd_ring_offset[i]);
> -			else if (ugeth->ug_info->uf_info.bd_mem_part ==
> -				 MEM_PART_MURAM)
> -				qe_muram_free(ugeth->tx_bd_ring_offset[i]);
> +			kfree((void *)ugeth->tx_bd_ring_offset[i]);
>   			ugeth->p_tx_bd_ring[i] = NULL;
>   		}
>   	}
> @@ -2060,13 +2049,6 @@ static int ucc_struct_init(struct ucc_geth_private *ugeth)
>   	ug_info = ugeth->ug_info;
>   	uf_info = &ug_info->uf_info;
>   
> -	if (!((uf_info->bd_mem_part == MEM_PART_SYSTEM) ||
> -	      (uf_info->bd_mem_part == MEM_PART_MURAM))) {
> -		if (netif_msg_probe(ugeth))
> -			pr_err("Bad memory partition value\n");
> -		return -EINVAL;
> -	}
> -
>   	/* Rx BD lengths */
>   	for (i = 0; i < ug_info->numQueuesRx; i++) {
>   		if ((ug_info->bdRingLenRx[i] < UCC_GETH_RX_BD_RING_SIZE_MIN) ||
> @@ -2186,6 +2168,8 @@ static int ucc_geth_alloc_tx(struct ucc_geth_private *ugeth)
>   
>   	/* Allocate Tx bds */
>   	for (j = 0; j < ug_info->numQueuesTx; j++) {
> +		u32 align = UCC_GETH_TX_BD_RING_ALIGNMENT;
> +
>   		/* Allocate in multiple of
>   		   UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT,
>   		   according to spec */
> @@ -2195,25 +2179,15 @@ static int ucc_geth_alloc_tx(struct ucc_geth_private *ugeth)
>   		if ((ug_info->bdRingLenTx[j] * sizeof(struct qe_bd)) %
>   		    UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT)
>   			length += UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT;
> -		if (uf_info->bd_mem_part == MEM_PART_SYSTEM) {
> -			u32 align = UCC_GETH_TX_BD_RING_ALIGNMENT;
> -
> -			ugeth->tx_bd_ring_offset[j] =
> -				(u32) kmalloc((u32) (length + align), GFP_KERNEL);
> -
> -			if (ugeth->tx_bd_ring_offset[j] != 0)
> -				ugeth->p_tx_bd_ring[j] =
> -					(u8 __iomem *)((ugeth->tx_bd_ring_offset[j] +
> -					align) & ~(align - 1));
> -		} else if (uf_info->bd_mem_part == MEM_PART_MURAM) {
> -			ugeth->tx_bd_ring_offset[j] =
> -			    qe_muram_alloc(length,
> -					   UCC_GETH_TX_BD_RING_ALIGNMENT);
> -			if (!IS_ERR_VALUE(ugeth->tx_bd_ring_offset[j]))
> -				ugeth->p_tx_bd_ring[j] =
> -				    (u8 __iomem *) qe_muram_addr(ugeth->
> -							 tx_bd_ring_offset[j]);
> -		}
> +
> +		ugeth->tx_bd_ring_offset[j] =
> +			(u32) kmalloc((u32) (length + align), GFP_KERNEL);

Can't this fit on a single ? Nowadays, max allowed line length is 100 chars.

> +
> +		if (ugeth->tx_bd_ring_offset[j] != 0)
> +			ugeth->p_tx_bd_ring[j] =
> +				(u8 __iomem *)((ugeth->tx_bd_ring_offset[j] +
> +						align) & ~(align - 1));

Can we get the above fit on only 2 lines ?

> +
>   		if (!ugeth->p_tx_bd_ring[j]) {
>   			if (netif_msg_ifup(ugeth))
>   				pr_err("Can not allocate memory for Tx bd rings\n");
> @@ -2271,25 +2245,16 @@ static int ucc_geth_alloc_rx(struct ucc_geth_private *ugeth)
>   
>   	/* Allocate Rx bds */
>   	for (j = 0; j < ug_info->numQueuesRx; j++) {
> +		u32 align = UCC_GETH_RX_BD_RING_ALIGNMENT;
> +
>   		length = ug_info->bdRingLenRx[j] * sizeof(struct qe_bd);
> -		if (uf_info->bd_mem_part == MEM_PART_SYSTEM) {
> -			u32 align = UCC_GETH_RX_BD_RING_ALIGNMENT;
> -
> -			ugeth->rx_bd_ring_offset[j] =
> -				(u32) kmalloc((u32) (length + align), GFP_KERNEL);
> -			if (ugeth->rx_bd_ring_offset[j] != 0)
> -				ugeth->p_rx_bd_ring[j] =
> -					(u8 __iomem *)((ugeth->rx_bd_ring_offset[j] +
> -					align) & ~(align - 1));
> -		} else if (uf_info->bd_mem_part == MEM_PART_MURAM) {
> -			ugeth->rx_bd_ring_offset[j] =
> -			    qe_muram_alloc(length,
> -					   UCC_GETH_RX_BD_RING_ALIGNMENT);
> -			if (!IS_ERR_VALUE(ugeth->rx_bd_ring_offset[j]))
> -				ugeth->p_rx_bd_ring[j] =
> -				    (u8 __iomem *) qe_muram_addr(ugeth->
> -							 rx_bd_ring_offset[j]);
> -		}
> +		ugeth->rx_bd_ring_offset[j] =
> +			(u32) kmalloc((u32) (length + align), GFP_KERNEL);

Same.

> +		if (ugeth->rx_bd_ring_offset[j] != 0)
> +			ugeth->p_rx_bd_ring[j] =
> +				(u8 __iomem *)((ugeth->rx_bd_ring_offset[j] +
> +						align) & ~(align - 1));

Same.

> +
>   		if (!ugeth->p_rx_bd_ring[j]) {
>   			if (netif_msg_ifup(ugeth))
>   				pr_err("Can not allocate memory for Rx bd rings\n");
> @@ -2554,20 +2519,11 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
>   		endOfRing =
>   		    ugeth->p_tx_bd_ring[i] + (ug_info->bdRingLenTx[i] -
>   					      1) * sizeof(struct qe_bd);
> -		if (ugeth->ug_info->uf_info.bd_mem_part == MEM_PART_SYSTEM) {
> -			out_be32(&ugeth->p_send_q_mem_reg->sqqd[i].bd_ring_base,
> -				 (u32) virt_to_phys(ugeth->p_tx_bd_ring[i]));
> -			out_be32(&ugeth->p_send_q_mem_reg->sqqd[i].
> -				 last_bd_completed_address,
> -				 (u32) virt_to_phys(endOfRing));
> -		} else if (ugeth->ug_info->uf_info.bd_mem_part ==
> -			   MEM_PART_MURAM) {
> -			out_be32(&ugeth->p_send_q_mem_reg->sqqd[i].bd_ring_base,
> -				 (u32)qe_muram_dma(ugeth->p_tx_bd_ring[i]));
> -			out_be32(&ugeth->p_send_q_mem_reg->sqqd[i].
> -				 last_bd_completed_address,
> -				 (u32)qe_muram_dma(endOfRing));
> -		}
> +		out_be32(&ugeth->p_send_q_mem_reg->sqqd[i].bd_ring_base,
> +			 (u32) virt_to_phys(ugeth->p_tx_bd_ring[i]));
> +		out_be32(&ugeth->p_send_q_mem_reg->sqqd[i].
> +			 last_bd_completed_address,

Same.


> +			 (u32) virt_to_phys(endOfRing));
>   	}
>   
>   	/* schedulerbasepointer */
> @@ -2786,14 +2742,8 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
>   	/* Setup the table */
>   	/* Assume BD rings are already established */
>   	for (i = 0; i < ug_info->numQueuesRx; i++) {
> -		if (ugeth->ug_info->uf_info.bd_mem_part == MEM_PART_SYSTEM) {
> -			out_be32(&ugeth->p_rx_bd_qs_tbl[i].externalbdbaseptr,
> -				 (u32) virt_to_phys(ugeth->p_rx_bd_ring[i]));
> -		} else if (ugeth->ug_info->uf_info.bd_mem_part ==
> -			   MEM_PART_MURAM) {
> -			out_be32(&ugeth->p_rx_bd_qs_tbl[i].externalbdbaseptr,
> -				 (u32)qe_muram_dma(ugeth->p_rx_bd_ring[i]));
> -		}
> +		out_be32(&ugeth->p_rx_bd_qs_tbl[i].externalbdbaseptr,
> +			 (u32) virt_to_phys(ugeth->p_rx_bd_ring[i]));
>   		/* rest of fields handled by QE */
>   	}
>   
> diff --git a/include/soc/fsl/qe/qe.h b/include/soc/fsl/qe/qe.h
> index 66f1afc393d1..4925a1b59dc9 100644
> --- a/include/soc/fsl/qe/qe.h
> +++ b/include/soc/fsl/qe/qe.h
> @@ -27,12 +27,6 @@
>   #define QE_NUM_OF_BRGS	16
>   #define QE_NUM_OF_PORTS	1024
>   
> -/* Memory partitions
> -*/
> -#define MEM_PART_SYSTEM		0
> -#define MEM_PART_SECONDARY	1
> -#define MEM_PART_MURAM		2
> -
>   /* Clocks and BRGs */
>   enum qe_clock {
>   	QE_CLK_NONE = 0,
> diff --git a/include/soc/fsl/qe/ucc_fast.h b/include/soc/fsl/qe/ucc_fast.h
> index dc4e79468094..9696a5b9b5d1 100644
> --- a/include/soc/fsl/qe/ucc_fast.h
> +++ b/include/soc/fsl/qe/ucc_fast.h
> @@ -146,7 +146,6 @@ struct ucc_fast_info {
>   	resource_size_t regs;
>   	int irq;
>   	u32 uccm_mask;
> -	int bd_mem_part;
>   	int brkpt_support;
>   	int grant_support;
>   	int tsa;
> 
