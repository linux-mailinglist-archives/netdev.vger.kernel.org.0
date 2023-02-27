Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158036A3EB9
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 10:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjB0Jyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 04:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjB0Jyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 04:54:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81BDEB44
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 01:54:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38E8B60DD4
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 09:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31107C433D2;
        Mon, 27 Feb 2023 09:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677491671;
        bh=+nyD2+vZss861jESp5X6n6fw6b71tD5ZtO2peboE1vQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PHvCybr4pZ1G26lKLlaVzNYdPlUW4yDo9TFBjUmDeSfCv59dJzZI61881MagSrUiH
         XuHvSDE2LD19vsPIaQJcxfxw2Jwl1SGNwFizYifNMmB4CCtK4Yegt3izITPpUSngNr
         w9UWSvRFZJNa2YfUrR6uI/i6/A2LZduF9Zl0LaPFuRl3uWtN/H4bHrxKUJLI3n+n21
         nPTZhDhAg3V0kNX9gG7mF68TWGea7tHIn3LXNZXj1PcmbAxq9vn38QlxBXPHPHVOCt
         3y/yCEBSnpNP/MpiFRlMm9Pj0Jmn+pBki4vJij6C4+lD8+LHk5H4wY1f86Kdq5vmM+
         dq/zsVAirkHdQ==
Date:   Mon, 27 Feb 2023 11:54:28 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Mason <jon.mason@broadcom.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Jon Mason <jdmason@kudzu.us>
Subject: Re: [PATCH net] bgmac: fix *initial* chip reset to support BCM5358
Message-ID: <Y/x91CqqRE1mLTWc@unreal>
References: <20230227091156.19509-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230227091156.19509-1-zajec5@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 10:11:56AM +0100, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> While bringing hardware up we should perform a full reset including the
> switch bit (BGMAC_BCMA_IOCTL_SW_RESET aka SICF_SWRST). It's what
> specification says and what reference driver does.
> 
> This seems to be critical for the BCM5358. Without this hardware doesn't
> get initialized properly and doesn't seem to transmit or receive any
> packets.
> 
> Originally bgmac was calling bgmac_chip_reset() before setting
> "has_robosw" property which resulted in expected behaviour. That has
> changed as a side effect of adding platform device support which
> regressed BCM5358 support.
> 
> Fixes: f6a95a24957a ("net: ethernet: bgmac: Add platform device support")
> Cc: Jon Mason <jdmason@kudzu.us>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  drivers/net/ethernet/broadcom/bgmac.c | 8 ++++++--
>  drivers/net/ethernet/broadcom/bgmac.h | 2 ++
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
