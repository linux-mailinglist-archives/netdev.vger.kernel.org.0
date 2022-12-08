Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4001A646BCF
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 10:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbiLHJYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 04:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiLHJYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 04:24:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4385C74F;
        Thu,  8 Dec 2022 01:24:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF2E6B821EB;
        Thu,  8 Dec 2022 09:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE570C433C1;
        Thu,  8 Dec 2022 09:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670491446;
        bh=XZlUsEv07hjY4O631nUYURDX0RrEAXkxMKI/UXjPh44=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WlPi4TibsAaYUTb1UptmbOlmFTUoq1ZrCcb/hswmi7YK9rtmOC42UwBeGeWVxUlZC
         krS5O1VFc9SuHRkcZLfLOF0lxnWA/HS9VFM0HTCkxXqUr1NApI3zX1Dt8lcyJMyXJN
         M8Znz/5sIjpeEWzdxOjo1u1b3BPStar9xDvBFOPv6gUvrMXhcUMoxwMxSjilFCcrE7
         WWhNffXUBexBvx48vJFJbr/y0Qt3MpFGuKU4IKxEuAsWo7ZDIDAkJVn6blzFcPZwnZ
         9GpdogkPmVFow2KEYQd7UoPOxYLJXNcCd58VDzaAjZaziAPhFXcmtVHG/9M93X/fhS
         8Noaw03g3Lw0g==
Date:   Thu, 8 Dec 2022 11:24:02 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     jiri@resnulli.us, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] ice: Add check for kzalloc
Message-ID: <Y5GtMk64Zg+tnbMS@unreal>
References: <20221208011936.47943-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208011936.47943-1-jiasheng@iscas.ac.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 09:19:36AM +0800, Jiasheng Jiang wrote:
> As kzalloc may return NULL pointer, the return value should
> be checked and return error if fails in order to avoid the
> NULL pointer dereference.
> Moreover, use the goto-label to share the clean code.
> 
> Fixes: d6b98c8d242a ("ice: add write functionality for GNSS TTY")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
> Changelog:
> 
> v1 -> v2:
> 
> 1. Use goto-label to share the clean code.
> ---
>  drivers/net/ethernet/intel/ice/ice_gnss.c | 25 ++++++++++++++---------
>  1 file changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
> index b5a7f246d230..7bd3452a16d2 100644
> --- a/drivers/net/ethernet/intel/ice/ice_gnss.c
> +++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
> @@ -421,7 +421,7 @@ static struct tty_driver *ice_gnss_create_tty_driver(struct ice_pf *pf)
>  	const int ICE_TTYDRV_NAME_MAX = 14;
>  	struct tty_driver *tty_driver;
>  	char *ttydrv_name;
> -	unsigned int i;
> +	unsigned int i, j;
>  	int err;
>  
>  	tty_driver = tty_alloc_driver(ICE_GNSS_TTY_MINOR_DEVICES,
> @@ -462,6 +462,9 @@ static struct tty_driver *ice_gnss_create_tty_driver(struct ice_pf *pf)
>  					       GFP_KERNEL);
>  		pf->gnss_serial[i] = NULL;
>  
> +		if (!pf->gnss_tty_port[i])
> +			goto err_out;
> +
>  		tty_port_init(pf->gnss_tty_port[i]);
>  		tty_port_link_device(pf->gnss_tty_port[i], tty_driver, i);
>  	}
> @@ -469,21 +472,23 @@ static struct tty_driver *ice_gnss_create_tty_driver(struct ice_pf *pf)
>  	err = tty_register_driver(tty_driver);
>  	if (err) {
>  		dev_err(dev, "Failed to register TTY driver err=%d\n", err);
> -
> -		for (i = 0; i < ICE_GNSS_TTY_MINOR_DEVICES; i++) {
> -			tty_port_destroy(pf->gnss_tty_port[i]);
> -			kfree(pf->gnss_tty_port[i]);
> -		}
> -		kfree(ttydrv_name);
> -		tty_driver_kref_put(pf->ice_gnss_tty_driver);
> -
> -		return NULL;
> +		goto err_out;
>  	}
>  
>  	for (i = 0; i < ICE_GNSS_TTY_MINOR_DEVICES; i++)
>  		dev_info(dev, "%s%d registered\n", ttydrv_name, i);
>  
>  	return tty_driver;
> +
> +err_out:
> +	for (j = 0; j < i; j++) {

You don't need an extra variable, "while(i--)" will do the trick.

Thanks

> +		tty_port_destroy(pf->gnss_tty_port[j]);
> +		kfree(pf->gnss_tty_port[j]);
> +	}
> +	kfree(ttydrv_name);
> +	tty_driver_kref_put(pf->ice_gnss_tty_driver);
> +
> +	return NULL;
>  }
>  
>  /**
> -- 
> 2.25.1
> 
