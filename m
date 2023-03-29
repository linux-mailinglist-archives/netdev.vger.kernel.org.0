Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E766CF292
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjC2S7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjC2S7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:59:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20660359B;
        Wed, 29 Mar 2023 11:59:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A295761DF4;
        Wed, 29 Mar 2023 18:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B59EC433EF;
        Wed, 29 Mar 2023 18:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680116352;
        bh=xrNis/Gi3YDSlD/DO7oEOemdsc4Il0XaJqIaosSVJRc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hsPi2UetoUMlw5hSiothNL2dKs8N+efFzVfRSgV7i/z2uZzrzycMAemEsfDnwTwlD
         poGVFn0d0aaYYZKC0yZjaSYY24HI2AiQcYVqjJqeIAk9CXqt5Ov4DR++dC112i0Atm
         KTPy9GKBL8/OrhVfyPBXFs1pmMw3Ytvx7gXWJJb6kxeBHGQgwmoI4qsu6G07W0R7Ys
         fmlritIEb/Fg394yCazQAhZqw6lIrb6NzI2clFiArLntkAJUgubrt9eqThnbZKd1JM
         J9USc/MH1i5FSzrx+Rk2EDMJoG1TmSJlOnhX4jp3z3GmbT/q9swr4/yxKRKsJ7VYP6
         p0QhlzZMl9UDw==
Date:   Wed, 29 Mar 2023 21:59:07 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Denis Plotnikov <den-plotnikov@yandex-team.ru>
Cc:     GR-Linux-NIC-Dev@marvell.com, manishc@marvell.com,
        rahulv@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH] net: netxen: report error on version offset reading
Message-ID: <20230329185907.GE831478@unreal>
References: <20230329162629.96590-1-den-plotnikov@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329162629.96590-1-den-plotnikov@yandex-team.ru>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 07:26:29PM +0300, Denis Plotnikov wrote:
> A static analyzer complains for non-checking the function returning value.
> Although, the code looks like not expecting any problems with version
> reading on netxen_p3_has_mn call, it seems the error still may happen.
> So, at least, add error reporting to ease problems investigation.
> 
> Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
> ---
>  drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
> index 35ec9aab3dc7b..92962dbb73ad0 100644
> --- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
> +++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
> @@ -1192,8 +1192,13 @@ netxen_p3_has_mn(struct netxen_adapter *adapter)
>  	if (NX_IS_REVISION_P2(adapter->ahw.revision_id))
>  		return 1;
>  
> -	netxen_rom_fast_read(adapter,
> -			NX_FW_VERSION_OFFSET, (int *)&flashed_ver);
> +	if (netxen_rom_fast_read(adapter,
> +			NX_FW_VERSION_OFFSET, (int *)&flashed_ver)) {

1. Mo callers of netxen_rom_fast_read() print debug messages, so this
shouldn't too.
2. netxen_p3_has_mn() can't fail and by returning 0, you will cause to
unpredictable behaviour in netxen_validate_firmware().

Thanks

> +		printk(KERN_ERR "%s: ERROR on flashed version reading",
> +				netxen_nic_driver_name);
> +		return 0;
> +	}
> +
>  	flashed_ver = NETXEN_DECODE_VERSION(flashed_ver);
>  
>  	if (flashed_ver >= NETXEN_VERSION_CODE(4, 0, 220)) {
> -- 
> 2.25.1
> 
