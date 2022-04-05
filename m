Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92C94F445A
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbiDEULU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242305AbiDETzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 15:55:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0986A46B3A;
        Tue,  5 Apr 2022 12:53:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99E9261899;
        Tue,  5 Apr 2022 19:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A8CC385A1;
        Tue,  5 Apr 2022 19:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649188424;
        bh=ksIfVFjF0VhXvGOjeWph7+zGCs5no8Zk0CDK25rDXR0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nc8OjmuDJjbpD7Zx0INTlt+XDlZKmHGNaSSRGSH/aWhy0P/JXj0ZjTGtyIEvtWn5x
         kKVcT7f6LAJKOrdKg13hSoB5+WFT0O3H2wbAdzQ+KkQU1JaaqJXAxUxrDkTq0Vwku3
         RrOWWH5qot4yjkt/ZVEUBoqHbSXzYuukJNOE35pmV32CGgdY6pbYwFVQUavNmH6zVO
         Mp0z3tNewufvLF6KGjFPtjt8Ai0NHkqAlEK5RmkztNGum5ZBmNOsKawHX7GimVzoY6
         ByiQ/pC+lnDxfHtGygxl4Uk8cXgqWryykNFF0HSxMQz+J2WYbnwHFVPzhHpD9ezRXF
         ZuJfEa8tKvu3w==
Date:   Tue, 5 Apr 2022 12:53:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 03/11] bnx2x: Fix undefined behavior due to shift
 overflowing the constant
Message-ID: <20220405125342.1f4d0a1a@kernel.org>
In-Reply-To: <20220405151517.29753-4-bp@alien8.de>
References: <20220405151517.29753-1-bp@alien8.de>
        <20220405151517.29753-4-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 Apr 2022 17:15:09 +0200 Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
>=20
> Fix:
>=20
>   drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c: In function =E2=80=98=
bnx2x_check_blocks_with_parity3=E2=80=99:
>   drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:4917:4: error: case la=
bel does not reduce to an integer constant
>       case AEU_INPUTS_ATTN_BITS_MCP_LATCHED_SCPAD_PARITY:
>       ^~~~
>=20
> See https://lore.kernel.org/r/YkwQ6%2BtIH8GQpuct@zn.tnic for the gory
> details as to why it triggers with older gccs only.
>=20
> Signed-off-by: Borislav Petkov <bp@suse.de>

I think this patch did not make it to netdev patchwork.
Could you resend (as a non-series patch - drop the 03/11
from the subject, that way build bot will not consider
it a partial/broken posting)? Thanks!

> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h b/drivers/ne=
t/ethernet/broadcom/bnx2x/bnx2x_reg.h
> index 5caa75b41b73..881ac33fe914 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h
> @@ -6218,7 +6218,7 @@
>  #define AEU_INPUTS_ATTN_BITS_GPIO0_FUNCTION_0			 (0x1<<2)
>  #define AEU_INPUTS_ATTN_BITS_IGU_PARITY_ERROR			 (0x1<<12)
>  #define AEU_INPUTS_ATTN_BITS_MCP_LATCHED_ROM_PARITY		 (0x1<<28)
> -#define AEU_INPUTS_ATTN_BITS_MCP_LATCHED_SCPAD_PARITY		 (0x1<<31)
> +#define AEU_INPUTS_ATTN_BITS_MCP_LATCHED_SCPAD_PARITY		 (0x1U<<31)
>  #define AEU_INPUTS_ATTN_BITS_MCP_LATCHED_UMP_RX_PARITY		 (0x1<<29)
>  #define AEU_INPUTS_ATTN_BITS_MCP_LATCHED_UMP_TX_PARITY		 (0x1<<30)
>  #define AEU_INPUTS_ATTN_BITS_MISC_HW_INTERRUPT			 (0x1<<15)

