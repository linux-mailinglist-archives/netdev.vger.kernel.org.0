Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7BF64408C
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235186AbiLFJwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235418AbiLFJvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:51:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C36E23BC5;
        Tue,  6 Dec 2022 01:51:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E359CB818E3;
        Tue,  6 Dec 2022 09:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F37C433C1;
        Tue,  6 Dec 2022 09:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670320266;
        bh=OqXrkel/gqs5cVlkVunVtxkFHQXH2a23IGjNXD5nSpI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T5ZMe/9QlZREU2UsUVObCC+9cMPh7m08dwqr+1zNIaV6sDQk1hx3E92N/9nMDhFNu
         KDYxsor+tV0TRZrRf0zH+wDiLdkKfj5VVM7ZKm+rjrfnHN7u7ULZAsHbCGKEeWRG2W
         BEJy71fgXwcSW1cTVa13KKD0Rx+uigtvFCQBx1VU+nXLfMijyQCXtVzD7XgyLQJkzK
         iTQCRn/zQrjCWmYrKMHU1iY67jRYUwAvfB24iS6bd8/DcJvmi7NCkGhQdOtXFFZegI
         /3AjwjnVIbkdrsWvLL8TX0bGLNn6A4/UjC40xdksSdwlxEWzg5I1i25ytbIOI01fNL
         A+/hzHR5FdROw==
Date:   Tue, 6 Dec 2022 11:51:02 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ice: Add check for kzalloc
Message-ID: <Y48QhnqUEfNEcC8u@unreal>
References: <20221206030805.15934-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206030805.15934-1-jiasheng@iscas.ac.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 11:08:05AM +0800, Jiasheng Jiang wrote:
> As kzalloc may fail and return NULL pointer,
> it should be better to check the return value
> in order to avoid the NULL pointer dereference.
> 
> Fixes: d6b98c8d242a ("ice: add write functionality for GNSS TTY")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  drivers/net/ethernet/intel/ice/ice_gnss.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)

The idea is correct, but please change an implementation to use goto
and proper unwind for whole function. It will remove duplication in the
code which handles tty_port destroys.

Thanks

> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
> index b5a7f246d230..6d3d5e75726b 100644
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
> @@ -462,6 +462,17 @@ static struct tty_driver *ice_gnss_create_tty_driver(struct ice_pf *pf)
>  					       GFP_KERNEL);
>  		pf->gnss_serial[i] = NULL;
>  
> +		if (!pf->gnss_tty_port[i]) {
> +			for (j = 0; j < i; j++) {
> +				tty_port_destroy(pf->gnss_tty_port[j]);
> +				kfree(pf->gnss_tty_port[j]);
> +			}
> +			kfree(ttydrv_name);
> +			tty_driver_kref_put(pf->ice_gnss_tty_driver);
> +
> +			return NULL;
> +		}
> +
>  		tty_port_init(pf->gnss_tty_port[i]);
>  		tty_port_link_device(pf->gnss_tty_port[i], tty_driver, i);
>  	}
> -- 
> 2.25.1
> 
