Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698943EFD00
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238392AbhHRGnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:43:04 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:57463 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238034AbhHRGnD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 02:43:03 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4GqJH06ckGz9sVX;
        Wed, 18 Aug 2021 08:42:20 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id BlboCUcmPLhC; Wed, 18 Aug 2021 08:42:20 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4GqJH05SCXz9sVD;
        Wed, 18 Aug 2021 08:42:20 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 9988E8B7D3;
        Wed, 18 Aug 2021 08:42:20 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id KISUn5YdRZul; Wed, 18 Aug 2021 08:42:20 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id B20628B766;
        Wed, 18 Aug 2021 08:42:19 +0200 (CEST)
Subject: Re: [PATCH v2 61/63] powerpc: Split memset() to avoid multi-field
 overflow
To:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wang Wensheng <wangwensheng4@huawei.com>,
        linux-staging@lists.linux.dev, linux-wireless@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        linux-block@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        clang-built-linux@googlegroups.com, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kbuild@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210818060533.3569517-1-keescook@chromium.org>
 <20210818060533.3569517-62-keescook@chromium.org>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <7630b0bc-4389-6283-d8b9-c532df916d60@csgroup.eu>
Date:   Wed, 18 Aug 2021 08:42:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210818060533.3569517-62-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 18/08/2021 à 08:05, Kees Cook a écrit :
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
> 
> Instead of writing across a field boundary with memset(), move the call
> to just the array, and an explicit zeroing of the prior field.
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Qinglang Miao <miaoqinglang@huawei.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: Hulk Robot <hulkci@huawei.com>
> Cc: Wang Wensheng <wangwensheng4@huawei.com>
> Cc: linuxppc-dev@lists.ozlabs.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/lkml/87czqsnmw9.fsf@mpe.ellerman.id.au
> ---
>   drivers/macintosh/smu.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/macintosh/smu.c b/drivers/macintosh/smu.c
> index 94fb63a7b357..59ce431da7ef 100644
> --- a/drivers/macintosh/smu.c
> +++ b/drivers/macintosh/smu.c
> @@ -848,7 +848,8 @@ int smu_queue_i2c(struct smu_i2c_cmd *cmd)
>   	cmd->read = cmd->info.devaddr & 0x01;
>   	switch(cmd->info.type) {
>   	case SMU_I2C_TRANSFER_SIMPLE:
> -		memset(&cmd->info.sublen, 0, 4);
> +		cmd->info.sublen = 0;
> +		memset(&cmd->info.subaddr, 0, 3);

subaddr[] is a table, should the & be avoided ?
And while at it, why not use sizeof(subaddr) instead of 3 ?


>   		break;
>   	case SMU_I2C_TRANSFER_COMBINED:
>   		cmd->info.devaddr &= 0xfe;
> 
