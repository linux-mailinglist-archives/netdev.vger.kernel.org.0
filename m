Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647C26315E2
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 20:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiKTTkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 14:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKTTkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 14:40:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2880F21245
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 11:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7E0E60C77
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 19:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F03C433D6;
        Sun, 20 Nov 2022 19:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668973217;
        bh=GL04zna6asJ/uDimC+B7yajAjSU1Mf1gf1CK9qw6W5c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fnNYpi9HPUv7KDhkvfVwdAecWZf9W/zKkgmlK/W1Hyp87xcghevhyg8exY7vKyEPt
         EIsr87lAfWSgh0s+lA4tEFEVZrzENDihSHOtxedTT7EOtsBixzZBEoWFaFh/zb77Fe
         F3O9J2lViZYUnxDlpGXJiVPr2oOQWHL+bSjDQ7owj4QqBNQOd4VwvD6zl4Xjx7+l5o
         PCTRWKLQ2gZZZhMiab4IO/xjCq0146GxLIA2/2AOxiIVCtZiTaIu+l+BRgaNfnaFt+
         GNAxzcphtRUENinJTOyQQZEN17kjfA0Qc7RsZOHNxhGWfZcbXoeUEXlVj/44pi6ilm
         hnh3F7Ewm1cTQ==
Date:   Sun, 20 Nov 2022 21:40:12 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jesse.brandeburg@intel.com
Subject: Re: [PATCH net-next v5 1/2] gve: Adding a new AdminQ command to
 verify driver
Message-ID: <Y3qCnJi2D/WOK0BG@unreal>
References: <20221117162701.2356849-1-jeroendb@google.com>
 <20221117162701.2356849-2-jeroendb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117162701.2356849-2-jeroendb@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 08:27:00AM -0800, Jeroen de Borst wrote:
> Check whether the driver is compatible with the device
> presented.
> 
> Signed-off-by: Jeroen de Borst <jeroendb@google.com>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
>  drivers/net/ethernet/google/gve/gve.h        |  1 +
>  drivers/net/ethernet/google/gve/gve_adminq.c | 21 +++++++-
>  drivers/net/ethernet/google/gve/gve_adminq.h | 49 ++++++++++++++++++
>  drivers/net/ethernet/google/gve/gve_main.c   | 52 ++++++++++++++++++++
>  4 files changed, 122 insertions(+), 1 deletion(-)

<...>

> +enum gve_driver_capbility {
> +	gve_driver_capability_gqi_qpl = 0,
> +	gve_driver_capability_gqi_rda = 1,
> +	gve_driver_capability_dqo_qpl = 2, /* reserved for future use */
> +	gve_driver_capability_dqo_rda = 3,
> +};
> +
> +#define GVE_CAP1(a) BIT((int)a)
> +#define GVE_CAP2(a) BIT(((int)a) - 64)
> +#define GVE_CAP3(a) BIT(((int)a) - 128)
> +#define GVE_CAP4(a) BIT(((int)a) - 192)
> +
> +#define GVE_DRIVER_CAPABILITY_FLAGS1 \
> +	(GVE_CAP1(gve_driver_capability_gqi_qpl) | \
> +	 GVE_CAP1(gve_driver_capability_gqi_rda) | \
> +	 GVE_CAP1(gve_driver_capability_dqo_rda))

I never understood it why people do it.

You created named enum gve_driver_capbility, but nothing in the code
uses this name and you use the values as bits, which later you cast them
to int.

It will be much saner, if you use anonymous enum, which is int in
C-world and you won't need any (int) casting when you call to BIT().

BTW, you don't need this casting anyway and it will be much better if you
use >> for bit operations and not "- 64|128|192".

Thanks
