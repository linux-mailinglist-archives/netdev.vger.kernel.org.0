Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E442D2E0F
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 16:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729977AbgLHPWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 10:22:04 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:45505 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729334AbgLHPWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 10:22:04 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4Cr3mc0sP8zB09b1;
        Tue,  8 Dec 2020 16:21:20 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id amiY2y3Yyv5n; Tue,  8 Dec 2020 16:21:20 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4Cr3mb6pFsz9v42n;
        Tue,  8 Dec 2020 16:21:19 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 86EE78B7CA;
        Tue,  8 Dec 2020 16:21:21 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id qgY2TNo5a1GV; Tue,  8 Dec 2020 16:21:21 +0100 (CET)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id A724A8B7BE;
        Tue,  8 Dec 2020 16:21:20 +0100 (CET)
Subject: Re: [PATCH 18/20] ethernet: ucc_geth: add helper to replace repeated
 switch statements
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Zhao Qiang <qiang.zhao@nxp.com>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
 <20201205191744.7847-19-rasmus.villemoes@prevas.dk>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <ed16ea1d-5017-96bd-c1a9-5201f51231fd@csgroup.eu>
Date:   Tue, 8 Dec 2020 16:21:20 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201205191744.7847-19-rasmus.villemoes@prevas.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 05/12/2020 à 20:17, Rasmus Villemoes a écrit :
> The translation from the ucc_geth_num_of_threads enum value to the
> actual count can be written somewhat more compactly with a small
> lookup table, allowing us to replace the four switch statements.
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> ---
>   drivers/net/ethernet/freescale/ucc_geth.c | 100 +++++-----------------
>   1 file changed, 22 insertions(+), 78 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
> index 3aebea191b52..a26d1feb7dab 100644
> --- a/drivers/net/ethernet/freescale/ucc_geth.c
> +++ b/drivers/net/ethernet/freescale/ucc_geth.c
> @@ -70,6 +70,20 @@ static struct {
>   module_param_named(debug, debug.msg_enable, int, 0);
>   MODULE_PARM_DESC(debug, "Debug verbosity level (0=none, ..., 0xffff=all)");
>   
> +static int ucc_geth_thread_count(enum ucc_geth_num_of_threads idx)
> +{
> +	static const u8 count[] = {
> +		[UCC_GETH_NUM_OF_THREADS_1] = 1,
> +		[UCC_GETH_NUM_OF_THREADS_2] = 2,
> +		[UCC_GETH_NUM_OF_THREADS_4] = 4,
> +		[UCC_GETH_NUM_OF_THREADS_6] = 6,
> +		[UCC_GETH_NUM_OF_THREADS_8] = 8,
> +	};
> +	if (idx >= ARRAY_SIZE(count))
> +		return 0;
> +	return count[idx];
> +}

I think you would allow GCC to provide a much better optimisation with something like:

static int ucc_geth_thread_count(enum ucc_geth_num_of_threads idx)
{
	if (idx == UCC_GETH_NUM_OF_THREADS_1)
		return 1;
	if (idx == UCC_GETH_NUM_OF_THREADS_2)
		return 2;
	if (idx == UCC_GETH_NUM_OF_THREADS_4)
		return 4;
	if (idx == UCC_GETH_NUM_OF_THREADS_6)
		return 6;
	if (idx == UCC_GETH_NUM_OF_THREADS_8)
		return 8;
	return 0;
}

> +
>   static const struct ucc_geth_info ugeth_primary_info = {
>   	.uf_info = {
>   		    .rtsm = UCC_FAST_SEND_IDLES_BETWEEN_FRAMES,
> @@ -668,32 +682,12 @@ static void dump_regs(struct ucc_geth_private *ugeth)
>   		in_be32(&ugeth->ug_regs->scam));
>   
>   	if (ugeth->p_thread_data_tx) {
> -		int numThreadsTxNumerical;
> -		switch (ugeth->ug_info->numThreadsTx) {
> -		case UCC_GETH_NUM_OF_THREADS_1:
> -			numThreadsTxNumerical = 1;
> -			break;
> -		case UCC_GETH_NUM_OF_THREADS_2:
> -			numThreadsTxNumerical = 2;
> -			break;
> -		case UCC_GETH_NUM_OF_THREADS_4:
> -			numThreadsTxNumerical = 4;
> -			break;
> -		case UCC_GETH_NUM_OF_THREADS_6:
> -			numThreadsTxNumerical = 6;
> -			break;
> -		case UCC_GETH_NUM_OF_THREADS_8:
> -			numThreadsTxNumerical = 8;
> -			break;
> -		default:
> -			numThreadsTxNumerical = 0;
> -			break;
> -		}
> +		int count = ucc_geth_thread_count(ugeth->ug_info->numThreadsTx);
>   
>   		pr_info("Thread data TXs:\n");
>   		pr_info("Base address: 0x%08x\n",
>   			(u32)ugeth->p_thread_data_tx);
> -		for (i = 0; i < numThreadsTxNumerical; i++) {
> +		for (i = 0; i < count; i++) {
>   			pr_info("Thread data TX[%d]:\n", i);
>   			pr_info("Base address: 0x%08x\n",
>   				(u32)&ugeth->p_thread_data_tx[i]);
> @@ -702,32 +696,12 @@ static void dump_regs(struct ucc_geth_private *ugeth)
>   		}
>   	}
>   	if (ugeth->p_thread_data_rx) {
> -		int numThreadsRxNumerical;
> -		switch (ugeth->ug_info->numThreadsRx) {
> -		case UCC_GETH_NUM_OF_THREADS_1:
> -			numThreadsRxNumerical = 1;
> -			break;
> -		case UCC_GETH_NUM_OF_THREADS_2:
> -			numThreadsRxNumerical = 2;
> -			break;
> -		case UCC_GETH_NUM_OF_THREADS_4:
> -			numThreadsRxNumerical = 4;
> -			break;
> -		case UCC_GETH_NUM_OF_THREADS_6:
> -			numThreadsRxNumerical = 6;
> -			break;
> -		case UCC_GETH_NUM_OF_THREADS_8:
> -			numThreadsRxNumerical = 8;
> -			break;
> -		default:
> -			numThreadsRxNumerical = 0;
> -			break;
> -		}
> +		int count = ucc_geth_thread_count(ugeth->ug_info->numThreadsRx);
>   
>   		pr_info("Thread data RX:\n");
>   		pr_info("Base address: 0x%08x\n",
>   			(u32)ugeth->p_thread_data_rx);
> -		for (i = 0; i < numThreadsRxNumerical; i++) {
> +		for (i = 0; i < count; i++) {
>   			pr_info("Thread data RX[%d]:\n", i);
>   			pr_info("Base address: 0x%08x\n",
>   				(u32)&ugeth->p_thread_data_rx[i]);
> @@ -2315,45 +2289,15 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
>   	uf_regs = uccf->uf_regs;
>   	ug_regs = ugeth->ug_regs;
>   
> -	switch (ug_info->numThreadsRx) {
> -	case UCC_GETH_NUM_OF_THREADS_1:
> -		numThreadsRxNumerical = 1;
> -		break;
> -	case UCC_GETH_NUM_OF_THREADS_2:
> -		numThreadsRxNumerical = 2;
> -		break;
> -	case UCC_GETH_NUM_OF_THREADS_4:
> -		numThreadsRxNumerical = 4;
> -		break;
> -	case UCC_GETH_NUM_OF_THREADS_6:
> -		numThreadsRxNumerical = 6;
> -		break;
> -	case UCC_GETH_NUM_OF_THREADS_8:
> -		numThreadsRxNumerical = 8;
> -		break;
> -	default:
> +	numThreadsRxNumerical = ucc_geth_thread_count(ug_info->numThreadsRx);
> +	if (!numThreadsRxNumerical) {
>   		if (netif_msg_ifup(ugeth))
>   			pr_err("Bad number of Rx threads value\n");
>   		return -EINVAL;
>   	}
>   
> -	switch (ug_info->numThreadsTx) {
> -	case UCC_GETH_NUM_OF_THREADS_1:
> -		numThreadsTxNumerical = 1;
> -		break;
> -	case UCC_GETH_NUM_OF_THREADS_2:
> -		numThreadsTxNumerical = 2;
> -		break;
> -	case UCC_GETH_NUM_OF_THREADS_4:
> -		numThreadsTxNumerical = 4;
> -		break;
> -	case UCC_GETH_NUM_OF_THREADS_6:
> -		numThreadsTxNumerical = 6;
> -		break;
> -	case UCC_GETH_NUM_OF_THREADS_8:
> -		numThreadsTxNumerical = 8;
> -		break;
> -	default:
> +	numThreadsTxNumerical = ucc_geth_thread_count(ug_info->numThreadsTx);
> +	if (!numThreadsTxNumerical) {
>   		if (netif_msg_ifup(ugeth))
>   			pr_err("Bad number of Tx threads value\n");
>   		return -EINVAL;
> 
