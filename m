Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B00B2FCB41
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 08:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbhATHDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 02:03:30 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:39511 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbhATHD1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 02:03:27 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4DLGgS5fVXz9v0cw;
        Wed, 20 Jan 2021 08:02:44 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id iPHD3Qo_-GrY; Wed, 20 Jan 2021 08:02:44 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4DLGgS2zBpz9v0cv;
        Wed, 20 Jan 2021 08:02:44 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 444808B7DF;
        Wed, 20 Jan 2021 08:02:45 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 9dGa2k7RdLCn; Wed, 20 Jan 2021 08:02:45 +0100 (CET)
Received: from [172.25.230.103] (po15451.idsi0.si.c-s.fr [172.25.230.103])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 1A39B8B75F;
        Wed, 20 Jan 2021 08:02:45 +0100 (CET)
Subject: Re: [PATCH net-next v2 11/17] ethernet: ucc_geth: don't statically
 allocate eight ucc_geth_info
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
 <20210119150802.19997-12-rasmus.villemoes@prevas.dk>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <fa391dc7-9870-dd7b-503d-c0f1468328c2@csgroup.eu>
Date:   Wed, 20 Jan 2021 08:02:46 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210119150802.19997-12-rasmus.villemoes@prevas.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 19/01/2021 à 16:07, Rasmus Villemoes a écrit :
> struct ucc_geth_info is somewhat large, and on systems with only one
> or two UCC instances, that just wastes a few KB of memory. So
> allocate and populate a chunk of memory at probe time instead of
> initializing them all during driver init.
> 
> Note that the existing "ug_info == NULL" check was dead code, as the
> address of some static array element can obviously never be NULL.
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> ---
>   drivers/net/ethernet/freescale/ucc_geth.c | 32 +++++++++--------------
>   1 file changed, 12 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
> index 65ef7ae38912..67b93d60243e 100644
> --- a/drivers/net/ethernet/freescale/ucc_geth.c
> +++ b/drivers/net/ethernet/freescale/ucc_geth.c
> @@ -157,8 +157,6 @@ static const struct ucc_geth_info ugeth_primary_info = {
>   	.riscRx = QE_RISC_ALLOCATION_RISC1_AND_RISC2,
>   };
>   
> -static struct ucc_geth_info ugeth_info[8];
> -
>   #ifdef DEBUG
>   static void mem_disp(u8 *addr, int size)
>   {
> @@ -3715,25 +3713,23 @@ static int ucc_geth_probe(struct platform_device* ofdev)
>   	if ((ucc_num < 0) || (ucc_num > 7))
>   		return -ENODEV;
>   
> -	ug_info = &ugeth_info[ucc_num];
> -	if (ug_info == NULL) {
> -		if (netif_msg_probe(&debug))
> -			pr_err("[%d] Missing additional data!\n", ucc_num);
> -		return -ENODEV;
> -	}
> +	ug_info = kmalloc(sizeof(*ug_info), GFP_KERNEL);

What about using devm_kmalloc() and avoid those kfree and associated goto ?


> +	if (ug_info == NULL)
> +		return -ENOMEM;
> +	memcpy(ug_info, &ugeth_primary_info, sizeof(*ug_info));
>   
>   	ug_info->uf_info.ucc_num = ucc_num;
>   
>   	err = ucc_geth_parse_clock(np, "rx", &ug_info->uf_info.rx_clock);
>   	if (err)
> -		return err;
> +		goto err_free_info;
>   	err = ucc_geth_parse_clock(np, "tx", &ug_info->uf_info.tx_clock);
>   	if (err)
> -		return err;
> +		goto err_free_info;
>   
>   	err = of_address_to_resource(np, 0, &res);
>   	if (err)
> -		return -EINVAL;
> +		goto err_free_info;
>   
>   	ug_info->uf_info.regs = res.start;
>   	ug_info->uf_info.irq = irq_of_parse_and_map(np, 0);
