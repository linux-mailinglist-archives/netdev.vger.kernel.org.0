Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13DA03A7E55
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 14:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbhFOMnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 08:43:40 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:44552 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229977AbhFOMnj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 08:43:39 -0400
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
        by localhost (Postfix) with ESMTP id 4G47H21f3wzBDWb;
        Tue, 15 Jun 2021 14:41:34 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id e9IboDGy1ZCO; Tue, 15 Jun 2021 14:41:34 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4G47H20khjzBDRW;
        Tue, 15 Jun 2021 14:41:34 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id E917C8B7BA;
        Tue, 15 Jun 2021 14:41:33 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 3PfSUpvszx5u; Tue, 15 Jun 2021 14:41:33 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 6C6648B7B9;
        Tue, 15 Jun 2021 14:41:33 +0200 (CEST)
Subject: Re: [PATCH] vmxnet3: prevent building with 256K pages
To:     Michael Ellerman <mpe@ellerman.id.au>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pv-drivers@vmware.com, doshir@vmware.com
References: <20210615123504.547106-1-mpe@ellerman.id.au>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <76ccb9fc-dc43-46e1-6465-637b72253385@csgroup.eu>
Date:   Tue, 15 Jun 2021 14:41:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210615123504.547106-1-mpe@ellerman.id.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 15/06/2021 à 14:35, Michael Ellerman a écrit :
> This driver assigns PAGE_SIZE to a u16, which can't work when the page
> size is 256K. As reported by lkp:
> 
>   drivers/net/vmxnet3/vmxnet3_drv.c: In function 'vmxnet3_rq_init':
>   arch/powerpc/include/asm/page.h:24:20: warning: conversion from 'long unsigned int' to 'u16' changes value from '262144' to '0'
>   drivers/net/vmxnet3/vmxnet3_drv.c:1784:29: note: in expansion of macro 'PAGE_SIZE'
>    1784 |    rq->buf_info[0][i].len = PAGE_SIZE;
>                                       ^~~~~~~~~
> 
> Simliar to what was done previously in commit fbdf0e28d061 ("vmxnet3:
> prevent building with 64K pages"), prevent the driver from building when
> 256K pages are enabled.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> ---
>   drivers/net/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 74dc8e249faa..da46898f060a 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -549,7 +549,7 @@ config VMXNET3
>   	depends on PCI && INET
>   	depends on !(PAGE_SIZE_64KB || ARM64_64K_PAGES || \
>   		     IA64_PAGE_SIZE_64KB || MICROBLAZE_64K_PAGES || \
> -		     PARISC_PAGE_SIZE_64KB || PPC_64K_PAGES)
> +		     PARISC_PAGE_SIZE_64KB || PPC_64K_PAGES || PPC_256K_PAGES)

Maybe we should also exclude hexagon, same as my patch on BTRFS 
https://patchwork.ozlabs.org/project/linuxppc-dev/patch/a16c31f3caf448dda5d9315e056585b6fafc22c5.1623302442.git.christophe.leroy@csgroup.eu/

>   	help
>   	  This driver supports VMware's vmxnet3 virtual ethernet NIC.
>   	  To compile this driver as a module, choose M here: the
> 
