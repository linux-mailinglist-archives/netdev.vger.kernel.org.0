Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3085FDA5F
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 15:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiJMNT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 09:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiJMNTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 09:19:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB1C4E182;
        Thu, 13 Oct 2022 06:19:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6791D617A7;
        Thu, 13 Oct 2022 13:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E08FC433B5;
        Thu, 13 Oct 2022 13:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665667161;
        bh=TF5evexQCaWAnM8YqzbvcWgQx5Wx+FEnE7540Ug803s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TaWO7ScmXh3c3WWSOR26mewtnUfpG9v/itOPFv6aRGbb7g3Hpc4WhqbqB+TRGr83p
         LrT8uuESh3245oABML5gTUadnj6sD4Ek26FkkiWhv9Qnxg5PEGR9+cKvzA8J6ScZm0
         vX3z7oNQaKI4XutNSDVa0LXQRj8HoAIe3LHiXg/Y=
Date:   Thu, 13 Oct 2022 15:20:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        isdn@linux-pingi.de, kuba@kernel.org, andrii@kernel.org,
        davem@davemloft.net, axboe@kernel.dk
Subject: Re: [PATCH] mISDN: hfcpci: Fix use-after-free bug in hfcpci_Timer
Message-ID: <Y0gQhe6EL6nDstlL@kroah.com>
References: <20221013125729.105652-1-duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013125729.105652-1-duoming@zju.edu.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 08:57:29PM +0800, Duoming Zhou wrote:
> If the timer handler hfcpci_Timer() is running, the
> del_timer(&hc->hw.timer) in release_io_hfcpci() could
> not stop it. As a result, the use-after-free bug will
> happen. The process is shown below:
> 
>     (cleanup routine)          |        (timer handler)
> release_card()                 | hfcpci_Timer()
>   release_io_hfcpci            |
>     del_timer(&hc->hw.timer)   |
>   ...                          |  ...
>   kfree(hc) //[1]FREE          |
>                                |   hc->hw.timer.expires //[2]USE
> 
> The hfc_pci is deallocated in position [1] and used in
> position [2].
> 
> Fix by changing del_timer() in release_io_hfcpci() to
> del_timer_sync(), which makes sure the hfcpci_Timer()
> have finished before the hfc_pci is deallocated.
> 
> Fixes: 1700fe1a10dc ("Add mISDN HFC PCI driver")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
>  drivers/isdn/hardware/mISDN/hfcpci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
> index af17459c1a5..5cf37fe7de2 100644
> --- a/drivers/isdn/hardware/mISDN/hfcpci.c
> +++ b/drivers/isdn/hardware/mISDN/hfcpci.c
> @@ -157,7 +157,7 @@ release_io_hfcpci(struct hfc_pci *hc)
>  {
>  	/* disable memory mapped ports + busmaster */
>  	pci_write_config_word(hc->pdev, PCI_COMMAND, 0);
> -	del_timer(&hc->hw.timer);
> +	del_timer_sync(&hc->hw.timer);

Nice, how did you test that this will work properly?  Do you have this
hardware for testing?  How was this issue found and verified that this
is the correct resolution?

thanks,

greg k-h
