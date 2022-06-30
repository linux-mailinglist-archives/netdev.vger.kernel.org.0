Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60538560FB3
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 05:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiF3Dgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 23:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiF3Dgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 23:36:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999E8CE36;
        Wed, 29 Jun 2022 20:36:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 078B0CE2B5B;
        Thu, 30 Jun 2022 03:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF62C34115;
        Thu, 30 Jun 2022 03:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656560195;
        bh=f0//88ZTiFLHCQlfvMX650IdOV+vbcMfyadO7E/gHgs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mn9FkE7gphlP0+VQiKmXSp05AGVnDqAO4E2lmdHIuVY6o9j0BA3gQWmhGdjLkKNFy
         gME/zohAZMkoA/ow7t3dGax1aE3KolZm4S/VfQQ9NkD49sYVGI9H6L3Cnz30naKblf
         yyNcj+HJ2J3M/FXZzTU0LULThrvSVgHcX0qDt6NA6HnKgyTQXWD03KB1DnSDWojGCb
         iDGUytaUnM3nGzwHyxe6rvfiPQx2Fvulw1nVQgABNKeuQDhtPnTwyYOoZ1bhkLAIK5
         UZxeuFadC+EDWzJk0By6NfQfka2lWX/TCcccb1Ezy0LWZDo8kujTy17oOsBJ/kz2/0
         skrQm7uBUyQSA==
Date:   Wed, 29 Jun 2022 20:36:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCHv2] usbnet: fix memory leak in error case
Message-ID: <20220629203633.56382dca@kernel.org>
In-Reply-To: <20220628083128.28472-1-oneukum@suse.com>
References: <20220628083128.28472-1-oneukum@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jun 2022 10:31:28 +0200 Oliver Neukum wrote:
> -	void *buf = NULL;
> +	void *buf;
>  
>  	netdev_dbg(dev->net, "usbnet_write_cmd cmd=0x%02x reqtype=%02x"
>  		   " value=0x%04x index=0x%04x size=%d\n",
> @@ -2155,7 +2155,7 @@ int usbnet_write_cmd_async(struct usbnet *dev, u8 cmd, u8 reqtype,
>  		if (!buf) {
>  			netdev_err(dev->net, "Error allocating buffer"
>  				   " in %s!\n", __func__);
> -			goto fail_free;
> +			goto fail_free_urb;
>  		}
>  	}
>  
> @@ -2179,14 +2179,21 @@ int usbnet_write_cmd_async(struct usbnet *dev, u8 cmd, u8 reqtype,
>  	if (err < 0) {
>  		netdev_err(dev->net, "Error submitting the control"
>  			   " message: status=%d\n", err);
> -		goto fail_free;
> +		goto fail_free_all;
>  	}
>  	return 0;
>  
> +fail_free_all:
> +	kfree(req);
>  fail_free_buf:
>  	kfree(buf);

Seems like the buf can be uninitialized now if data was NULL
