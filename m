Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435A06876FC
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 09:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbjBBIHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 03:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjBBIHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 03:07:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD51CA35
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 00:07:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 460B9B824E3
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 08:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4DCC433D2;
        Thu,  2 Feb 2023 08:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675325236;
        bh=vWJW04QtS/CG3YT8fVI8FZTkqT+r2sffSUUw16+OEnE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bseJy4iAEuiOJ8nOmycA0zHG4GYTV3QmmIIEOFKETQLRo5uCGYjM00g+f3cF02O/S
         V/pHa8RZjoF/Bp42HSQSve05BoQ17Lm1163actK1K6PGfWGt7cBXGLg4wddFXxL6Pq
         CvEVolK7fdmkf3qPRF+1My99jG5mW0Sms/lQCrroWL9hZ8kgf51kBECyfVhui/9lap
         IDYFqeWdrqGufy/XpNV3QohsyieuRuCCyfxjok4ThXqZw4DhTCG62GYZ/9381IgeFv
         kOFbQjAxDDA3WZJmAlO/DM1vXnIXhxdBBuszpT6MMSP1K91+1zsu4a1hB3U0ux3u/Z
         cH54JAKUFyt4Q==
Date:   Thu, 2 Feb 2023 10:07:11 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next v3] gve: Introduce a way to disable queue formats
Message-ID: <Y9tvL0KCQbfKfo9v@unreal>
References: <20230201155722.110460-1-jeroendb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201155722.110460-1-jeroendb@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 07:57:22AM -0800, Jeroen de Borst wrote:
> The device is capable of simultaneously supporting multiple
> queue formats. These queue formats are:
> 
> - GQI-QPL: A queue format with in-order completions and a
> bounce-buffer (Queue Page List)
> - GQI-RDA: A queue format with in-order completions and no
> bounce-buffer (Raw DMA Access)
> - DQO-RDA: A queue format with out-of-order completions and
> no bounce buffer
> 
> With this change the driver can deliberately pick a queue format.
> 
> Signed-off-by: Jeroen de Borst <jeroendb@google.com>
> ---
> Changed in v2:
> - Documented queue formats and addressed nits.
> Changed in v3:
> - Move changelog below trailer
> ---
>  drivers/net/ethernet/google/gve/gve.h         | 28 +++++++++
>  drivers/net/ethernet/google/gve/gve_adminq.c  | 35 +++++++-----
>  drivers/net/ethernet/google/gve/gve_ethtool.c | 57 ++++++++++++-------
>  drivers/net/ethernet/google/gve/gve_main.c    | 26 ++++++++-
>  4 files changed, 109 insertions(+), 37 deletions(-)

<...>

>  	priv->queue_format = GVE_QUEUE_FORMAT_UNSPECIFIED;
>  	/* Get the initial information we need from the device */
>  	err = gve_adminq_describe_device(priv);
> @@ -1661,6 +1680,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	priv->service_task_flags = 0x0;
>  	priv->state_flags = 0x0;
>  	priv->ethtool_flags = 0x0;
> +	priv->ethtool_formats = 0x0;
>  

There is no need to assign zeroes to priv as it is allocated with kvzalloc.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
