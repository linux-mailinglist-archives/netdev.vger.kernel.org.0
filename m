Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B862FCB3B
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 07:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbhATG6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 01:58:01 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:53182 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbhATG5x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 01:57:53 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4DLGXt0bK6z9v0cw;
        Wed, 20 Jan 2021 07:57:02 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id qymY7y7EqYVh; Wed, 20 Jan 2021 07:57:01 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4DLGXs5yNqz9v0cv;
        Wed, 20 Jan 2021 07:57:01 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id B90E48B7DF;
        Wed, 20 Jan 2021 07:57:02 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id BeVwRpLR4b8u; Wed, 20 Jan 2021 07:57:02 +0100 (CET)
Received: from [172.25.230.103] (po15451.idsi0.si.c-s.fr [172.25.230.103])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 76C398B75F;
        Wed, 20 Jan 2021 07:57:02 +0100 (CET)
Subject: Re: [PATCH net-next v2 08/17] ethernet: ucc_geth: remove
 {rx,tx}_glbl_pram_offset from struct ucc_geth_private
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
 <20210119150802.19997-9-rasmus.villemoes@prevas.dk>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <26c7c3cc-2dec-c86e-2e9d-63dc1a7ddba1@csgroup.eu>
Date:   Wed, 20 Jan 2021 07:57:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210119150802.19997-9-rasmus.villemoes@prevas.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 19/01/2021 à 16:07, Rasmus Villemoes a écrit :
> These fields are only used within ucc_geth_startup(), so they might as
> well be local variables in that function rather than being stashed in
> struct ucc_geth_private.
> 
> Aside from making that struct a tiny bit smaller, it also shortens
> some lines (getting rid of pointless casts while here), and fixes the
> problems with using IS_ERR_VALUE() on a u32 as explained in commit
> 800cd6fb76f0 ("soc: fsl: qe: change return type of cpm_muram_alloc()
> to s32").
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> ---
>   drivers/net/ethernet/freescale/ucc_geth.c | 21 +++++++++------------
>   drivers/net/ethernet/freescale/ucc_geth.h |  2 --
>   2 files changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
> index 74ee2ed2fbbb..75466489bf9a 100644
> --- a/drivers/net/ethernet/freescale/ucc_geth.c
> +++ b/drivers/net/ethernet/freescale/ucc_geth.c
> @@ -2351,6 +2351,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
>   	u8 function_code = 0;
>   	u8 __iomem *endOfRing;
>   	u8 numThreadsRxNumerical, numThreadsTxNumerical;
> +	s32 rx_glbl_pram_offset, tx_glbl_pram_offset;

That's still a quite long name for a local variable. Kernel Codying Style says:


LOCAL variable names should be short, and to the point. If you have some random integer loop 
counter, it should probably be called i. Calling it loop_counter is non-productive, if there is no 
chance of it being mis-understood. Similarly, tmp can be just about any type of variable that is 
used to hold a temporary value.

If you are afraid to mix up your local variable names, you have another problem, which is called the 
function-growth-hormone-imbalance syndrome. See chapter 6 (Functions).

>   
>   	ugeth_vdbg("%s: IN", __func__);
>   	uccf = ugeth->uccf;
> @@ -2495,17 +2496,15 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
>   	 */
>   	/* Tx global PRAM */
>   	/* Allocate global tx parameter RAM page */
> -	ugeth->tx_glbl_pram_offset =
> +	tx_glbl_pram_offset =
>   	    qe_muram_alloc(sizeof(struct ucc_geth_tx_global_pram),
>   			   UCC_GETH_TX_GLOBAL_PRAM_ALIGNMENT);
> -	if (IS_ERR_VALUE(ugeth->tx_glbl_pram_offset)) {
> +	if (tx_glbl_pram_offset < 0) {
>   		if (netif_msg_ifup(ugeth))
>   			pr_err("Can not allocate DPRAM memory for p_tx_glbl_pram\n");
>   		return -ENOMEM;
>   	}
> -	ugeth->p_tx_glbl_pram =
> -	    (struct ucc_geth_tx_global_pram __iomem *) qe_muram_addr(ugeth->
> -							tx_glbl_pram_offset);
> +	ugeth->p_tx_glbl_pram = qe_muram_addr(tx_glbl_pram_offset);
>   	/* Fill global PRAM */
>   
>   	/* TQPTR */
> @@ -2656,17 +2655,15 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
>   
>   	/* Rx global PRAM */
>   	/* Allocate global rx parameter RAM page */
> -	ugeth->rx_glbl_pram_offset =
> +	rx_glbl_pram_offset =
>   	    qe_muram_alloc(sizeof(struct ucc_geth_rx_global_pram),
>   			   UCC_GETH_RX_GLOBAL_PRAM_ALIGNMENT);
> -	if (IS_ERR_VALUE(ugeth->rx_glbl_pram_offset)) {
> +	if (rx_glbl_pram_offset < 0) {
>   		if (netif_msg_ifup(ugeth))
>   			pr_err("Can not allocate DPRAM memory for p_rx_glbl_pram\n");
>   		return -ENOMEM;
>   	}
> -	ugeth->p_rx_glbl_pram =
> -	    (struct ucc_geth_rx_global_pram __iomem *) qe_muram_addr(ugeth->
> -							rx_glbl_pram_offset);
> +	ugeth->p_rx_glbl_pram = qe_muram_addr(rx_glbl_pram_offset);
>   	/* Fill global PRAM */
>   
>   	/* RQPTR */
> @@ -2928,7 +2925,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
>   	    ((u32) ug_info->numThreadsTx) << ENET_INIT_PARAM_TGF_SHIFT;
>   
>   	ugeth->p_init_enet_param_shadow->rgftgfrxglobal |=
> -	    ugeth->rx_glbl_pram_offset | ug_info->riscRx;
> +	    rx_glbl_pram_offset | ug_info->riscRx;
>   	if ((ug_info->largestexternallookupkeysize !=
>   	     QE_FLTR_LARGEST_EXTERNAL_TABLE_LOOKUP_KEY_SIZE_NONE) &&
>   	    (ug_info->largestexternallookupkeysize !=
> @@ -2966,7 +2963,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
>   	}
>   
>   	ugeth->p_init_enet_param_shadow->txglobal =
> -	    ugeth->tx_glbl_pram_offset | ug_info->riscTx;
> +	    tx_glbl_pram_offset | ug_info->riscTx;
>   	if ((ret_val =
>   	     fill_init_enet_entries(ugeth,
>   				    &(ugeth->p_init_enet_param_shadow->
> diff --git a/drivers/net/ethernet/freescale/ucc_geth.h b/drivers/net/ethernet/freescale/ucc_geth.h
> index c80bed2c995c..be47fa8ced15 100644
> --- a/drivers/net/ethernet/freescale/ucc_geth.h
> +++ b/drivers/net/ethernet/freescale/ucc_geth.h
> @@ -1166,9 +1166,7 @@ struct ucc_geth_private {
>   	struct ucc_geth_exf_global_pram __iomem *p_exf_glbl_param;
>   	u32 exf_glbl_param_offset;
>   	struct ucc_geth_rx_global_pram __iomem *p_rx_glbl_pram;
> -	u32 rx_glbl_pram_offset;
>   	struct ucc_geth_tx_global_pram __iomem *p_tx_glbl_pram;
> -	u32 tx_glbl_pram_offset;
>   	struct ucc_geth_send_queue_mem_region __iomem *p_send_q_mem_reg;
>   	u32 send_q_mem_reg_offset;
>   	struct ucc_geth_thread_data_tx __iomem *p_thread_data_tx;
> 
