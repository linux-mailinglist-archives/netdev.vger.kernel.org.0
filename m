Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0667F4C7AF4
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 21:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiB1UrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 15:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiB1UrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 15:47:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00FF5F92;
        Mon, 28 Feb 2022 12:46:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE443B8162E;
        Mon, 28 Feb 2022 20:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D46C340F1;
        Mon, 28 Feb 2022 20:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646081191;
        bh=ngBxIU0dO9XuAVHoPmfSDCp6mHYGfoXYNZiBbu46YyM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fQg6CHzqlDMDQ7o79wPQf4siCHkM8mM+Fw92RnhHZE2GzPJvRha9t/+T3JSfGnRGJ
         7l/1fD0Wa6D/Nhb6JyGhdaNDkJqfTYKY6sJPMU/fPYrneo0ybYAap4ZhgCriX2AXtC
         eif0QmSGXZNOwBkALu76W4EDum+Z74fisvVTxiVg+iXBg5XTevl/Tpg1x61t+2A3IV
         Sj4FrVulR88qyy6mntffospY47m2yILKmAQp0BHF1gpjx9GuwBWKaFEGNrR9/eWysm
         32BRKh0h56wMGv9TXsUV6YCe5J7eMZsbPaOEsH9b+U76zBO6SOSKgGfyBLKvvVLZV7
         S3QqM0aQZ7PSw==
Date:   Mon, 28 Feb 2022 12:46:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     wudaemon <wudaemon@163.com>
Cc:     davem@davemloft.net, m.grzeschik@pengutronix.de,
        chenhao288@hisilicon.com, arnd@arndb.de, shenyang39@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ksz884x: use time_before in netdev_open for
 compatibility and remove static variable
Message-ID: <20220228124629.44ee8b84@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220228162955.22819-1-wudaemon@163.com>
References: <20220228162955.22819-1-wudaemon@163.com>
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

On Mon, 28 Feb 2022 16:29:55 +0000 wudaemon wrote:
> use time_before instead of direct compare for compatibility and remove the static next_jiffies variable
> 
> Signed-off-by: wudaemon <wudaemon@163.com>

This does not build.

> diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
> index d024983815da..9d445f27abb8 100644
> --- a/drivers/net/ethernet/micrel/ksz884x.c
> +++ b/drivers/net/ethernet/micrel/ksz884x.c
> @@ -5225,7 +5225,6 @@ static irqreturn_t netdev_intr(int irq, void *dev_id)
>   * Linux network device functions
>   */
>  
> -static unsigned long next_jiffies;
>  
>  #ifdef CONFIG_NET_POLL_CONTROLLER
>  static void netdev_netpoll(struct net_device *dev)
> @@ -5361,7 +5360,7 @@ static int prepare_hardware(struct net_device *dev)
>  	struct dev_info *hw_priv = priv->adapter;
>  	struct ksz_hw *hw = &hw_priv->hw;
>  	int rc = 0;
> -
> +	unsigned long next_jiffies = 0;

Please keep an empty line between variables and code.
The variable declaration lines should be ordered longest to shortest.
next_jiffies can be initialized to jiffies.

>  	/* Remember the network device that requests interrupts. */
>  	hw_priv->dev = dev;
>  	rc = request_irq(dev->irq, netdev_intr, IRQF_SHARED, dev->name, dev);
> @@ -5428,7 +5427,7 @@ static int netdev_open(struct net_device *dev)
>  		if (rc)
>  			return rc;
>  		for (i = 0; i < hw->mib_port_cnt; i++) {
> -			if (next_jiffies < jiffies)
> +			if (time_before(next_jiffies, jiffies))
>  				next_jiffies = jiffies + HZ * 2;
>  			else
>  				next_jiffies += HZ * 1;
> @@ -6566,7 +6565,7 @@ static void mib_read_work(struct work_struct *work)
>  	struct ksz_port_mib *mib;
>  	int i;
>  
> -	next_jiffies = jiffies;
> +	unsigned long next_jiffies = jiffies;
>  	for (i = 0; i < hw->mib_port_cnt; i++) {
>  		mib = &hw->port_mib[i];
>  

