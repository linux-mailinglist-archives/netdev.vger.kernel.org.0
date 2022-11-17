Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0BE62D773
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 10:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbiKQJvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 04:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbiKQJvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 04:51:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A18BCDB
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:51:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14442B81FCF
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 09:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D285C433C1;
        Thu, 17 Nov 2022 09:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668678663;
        bh=95w0rUAWZja+lkCu8BOjXNKZoqDlAR+NfPwv+qFwCek=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XuV+23lMeALStMmpcHLkVr//DfBoUX4P0iZpTZT37TnHopywdgTF2kCFGXUhtl53m
         PWef09OXAFgndD7o/uMHYsZs0+P7ETguP9VNQwApRm1lbdupsfIshYPHS4hG812ye1
         mgLdo5bnukYHQn6YeAVDzhrhVE+FSxvsUYiUR5kzEb7W+D1BfdE1SHikwm0GT35Ay0
         UN8PYkunbb2+U0LdGB8yR6XrKZPVJqQrJVn4y1RKWSvV0nieQiVVkc5SNtlgIf5L0s
         OTmHBigZPTpDFe/abcageoc8byvP+d2yfmxGqGRiOEVyxKXQBFX28sx404UkAFpksm
         USYjoKLG4uujQ==
Date:   Thu, 17 Nov 2022 11:50:59 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yan Cangang <nalanzeyu@gmail.com>
Cc:     Mark-MC.Lee@mediatek.com, john@phrozen.org, nbd@nbd.name,
        netdev@vger.kernel.org, sean.wang@mediatek.com
Subject: Re: [PATCH v2] net: ethernet: mtk_eth_soc: fix memory leak in error
 path
Message-ID: <Y3YEA35SVvReOoXC@unreal>
References: <Y3H1VgVOJB5kHbaa@unreal>
 <20221116051407.1679342-1-nalanzeyu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116051407.1679342-1-nalanzeyu@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 01:14:07PM +0800, Yan Cangang wrote:
> In mtk_ppe_init(), when dmam_alloc_coherent() or devm_kzalloc() failed,
> the rhashtable ppe->l2_flows isn't destroyed. Fix it.
> 
> In mtk_probe(), when mtk_eth_offload_init() or register_netdev() failed,
> have the same problem. Also, call to mtk_mdio_cleanup() is missed in this
> case. Fix it.
> 
> Fixes: 33fc42de3327 ("net: ethernet: mtk_eth_soc: support creating mac address based offload entries")
> Fixes: ba37b7caf1ed ("net: ethernet: mtk_eth_soc: add support for initializing the PPE")
> Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
> Signed-off-by: Yan Cangang <nalanzeyu@gmail.com>
> ---
> v1: https://lore.kernel.org/netdev/20221112233239.824389-1-nalanzeyu@gmail.com/T/
> v2:
>   - clean up commit message
>   - new mtk_ppe_deinit() function, call it before calling mtk_mdio_cleanup()

Subject line should include target [PATCH net v2] ....

> 
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c |  9 +++++----
>  drivers/net/ethernet/mediatek/mtk_ppe.c     | 19 +++++++++++++++++--
>  drivers/net/ethernet/mediatek/mtk_ppe.h     |  1 +
>  3 files changed, 23 insertions(+), 6 deletions(-)

The change seems ok, but please be aware that mtk_eth_offload_init()
calls to rhashtable_init() which is not destroyed too.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
