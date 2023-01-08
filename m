Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A1366158A
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 14:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbjAHNoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 08:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjAHNoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 08:44:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07440BE0D
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 05:44:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83E2960C6D
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 13:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282A4C433D2;
        Sun,  8 Jan 2023 13:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673185453;
        bh=TWXJ008peu/SyuMEdqRm0v9zvoHkALHKxAPjM9RdBsQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FnhRjGROM+hzDRHC3X37C9xlsLDLfjEGNJfmiCe+Vis9Lb2WaT5cVo7om0baYOkZa
         zzNaE4sx70sIA/tisSHACerhnPC45anHzmyg5brfCojpz+1cFbA7Xnjovt0ZtRS5mw
         lEW3FE0gEYqU1Lk6AbPLm8OEfrpwUplfJLJffgEWE9RzQhewFwrkouu7ETcu6puq9U
         pPzzai95+91sLu+eDPTWbommzGVr8YnjjbHb4avlHlqXWr7eb9f50vo2BewSaa83fZ
         KCxJbNb7vPhte6bndN9ZlqxMJgSLb2RFBcgmPDQuuC9RkgVBFF/KI4QyGhP6z8G0Aj
         grk4n6Ng6yV7Q==
Date:   Sun, 8 Jan 2023 15:44:09 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, sujuan.chen@mediatek.com,
        daniel@makrotopia.org
Subject: Re: [PATCH v3 net-next 3/5] net: ethernet: mtk_eth_soc: align reset
 procedure to vendor sdk
Message-ID: <Y7rIqUhWdX1yoaKO@unreal>
References: <cover.1673102767.git.lorenzo@kernel.org>
 <af8547b94b6cad76f17c1c467b507bd915a0e2c0.1673102767.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af8547b94b6cad76f17c1c467b507bd915a0e2c0.1673102767.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 07, 2023 at 03:50:52PM +0100, Lorenzo Bianconi wrote:
> Avoid to power-down the ethernet chip during hw reset and align reset
> procedure to vendor sdk.
> 
> Tested-by: Daniel Golle <daniel@makrotopia.org>
> Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
> Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c  | 94 +++++++++++++++-----
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h  | 12 +++
>  drivers/net/ethernet/mediatek/mtk_ppe.c      | 27 ++++++
>  drivers/net/ethernet/mediatek/mtk_ppe.h      |  1 +
>  drivers/net/ethernet/mediatek/mtk_ppe_regs.h |  6 ++
>  5 files changed, 116 insertions(+), 24 deletions(-)

mdelay is macro wrapper around udelay, to account for possible overflow when
passing large arguments to udelay. In general, use of mdelay is discouraged
and code should be refactored to allow for the use of msleep.

https://www.kernel.org/doc/html/latest/timers/timers-howto.html#delays-information-on-the-various-kern

It is not your case as you are passing small numbers and can use udelay instead.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
