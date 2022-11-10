Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D5D624895
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 18:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiKJRs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 12:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbiKJRsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 12:48:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F746303D1;
        Thu, 10 Nov 2022 09:48:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 597A9B82299;
        Thu, 10 Nov 2022 17:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA84CC433D6;
        Thu, 10 Nov 2022 17:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668102526;
        bh=LaCkfzvC3SDe5+BjeA2YYKfWouKye1Ldokf1V6KFsvc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vMXuhXFsxOxiFAzcVPY2ER5SCCLpFVBmjwpaJccYJ+GDNlZFyxLkVv2tY3iHAimwu
         uLWMAub7O1Qv6bozsCz/aX1fmbhj7EQD0i0bAZuJKypW3nn3HdaslwotsRBpDsihHu
         xCki/xwxAHG6rGU3NuPf8TJpxPSpYpIkzLNYlP5E=
Date:   Thu, 10 Nov 2022 18:48:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-kernel@vger.kernel.org, isdn@linux-pingi.de, kuba@kernel.org,
        andrii@kernel.org, axboe@kernel.dk, davem@davemloft.net,
        netdev@vger.kernel.org, zou_wei@huawei.com
Subject: Re: [PATCH] mISDN: hfcpci: Fix use-after-free bug in hfcpci_softirq
Message-ID: <Y205e/GpYNUVm9Bv@kroah.com>
References: <20221009063731.22733-1-duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221009063731.22733-1-duoming@zju.edu.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 02:37:31PM +0800, Duoming Zhou wrote:
> The function hfcpci_softirq() is a timer handler. If it
> is running, the timer_pending() will return 0 and the
> del_timer_sync() in HFC_cleanup() will not be executed.
> As a result, the use-after-free bug will happen. The
> process is shown below:
> 
>     (cleanup routine)          |        (timer handler)
> HFC_cleanup()                  | hfcpci_softirq()
>  if (timer_pending(&hfc_tl))   |
>    del_timer_sync()            |
>  ...                           | ...
>  pci_unregister_driver(hc)     |
>   driver_unregister            |  driver_for_each_device
>    bus_remove_driver           |   _hfcpci_softirq
>     driver_detach              |   ...
>      put_device(dev) //[1]FREE |
>                                |    dev_get_drvdata(dev) //[2]USE
> 
> The device is deallocated is position [1] and used in
> position [2].
> 
> Fix by removing the "timer_pending" check in HFC_cleanup(),
> which makes sure that the hfcpci_softirq() have finished
> before the resource is deallocated.
> 
> Fixes: 009fc857c5f6 ("mISDN: fix possible use-after-free in HFC_cleanup()")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
>  drivers/isdn/hardware/mISDN/hfcpci.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
> index af17459c1a5..e964a8dd851 100644
> --- a/drivers/isdn/hardware/mISDN/hfcpci.c
> +++ b/drivers/isdn/hardware/mISDN/hfcpci.c
> @@ -2345,8 +2345,7 @@ HFC_init(void)
>  static void __exit
>  HFC_cleanup(void)
>  {
> -	if (timer_pending(&hfc_tl))
> -		del_timer_sync(&hfc_tl);
> +	del_timer_sync(&hfc_tl);

How was this tested?  Do you have this hardware?

thanks,

greg k-h
