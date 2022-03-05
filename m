Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 740A14CE327
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 06:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiCEFuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 00:50:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiCEFuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 00:50:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40AE2583BE;
        Fri,  4 Mar 2022 21:49:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D75F6609FE;
        Sat,  5 Mar 2022 05:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA18AC340EE;
        Sat,  5 Mar 2022 05:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646459354;
        bh=ZRml+jTpq4ZmzpURaHuOyjWE7v4a4+MU2vWXWz/blnw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E2Sz5J3KJRDgAAOgFcbMb9eOSzUhNbPWSxIblXeHCAhV0DoVYLKCxSzSq9KNX+1Ce
         oCIGlvi2jgbeXsHYipwhXtqbIQEL9C0bKvye9mpKfoo8coWV85qhcW/yIyiS4mx4sC
         ZP8iXLNqyQrl1vQshJ3LEOGf4nDLN6cfAQJOOcj67U12ic65StWYBeEAGi7HqMLKM0
         1ecK2QWdLolcfy2yK6ZZ4jfMv4dEKb0N0DxokygSxNemms8NOuxbM8zKlvV2KkhQJz
         wcaoJOnB/hMKRnky8idPKAwlmuHyKyYlV9CtaaLSYvmZfumG3NOp6vWrTZS7HEo5y/
         9mXTtEYEG69bw==
Date:   Fri, 4 Mar 2022 21:49:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     wudaemon <wudaemon@163.com>
Cc:     davem@davemloft.net, m.grzeschik@pengutronix.de,
        chenhao288@hisilicon.com, arnd@arndb.de, shenyang39@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: ksz884x: use time_before in netdev_open for
 compatibility and remove static variable
Message-ID: <20220304214912.314b5829@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220301151808.2855-1-wudaemon@163.com>
References: <20220301151808.2855-1-wudaemon@163.com>
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

On Tue,  1 Mar 2022 15:18:08 +0000 wudaemon wrote:
> use time_before instead of direct compare for compatibility and remove the static next_jiffies variable
> 
> Signed-off-by: wudaemon <wudaemon@163.com>

Oops, thought I replied to this one but apparently I haven't.
Sorry for the delay.

> diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
> index d024983815da..ce4f5c99c1ac 100644
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
> @@ -5411,10 +5410,12 @@ static int netdev_open(struct net_device *dev)
>  	struct dev_info *hw_priv = priv->adapter;
>  	struct ksz_hw *hw = &hw_priv->hw;
>  	struct ksz_port *port = &priv->port;
> +	unsigned long next_jiffies;
>  	int i;
>  	int p;
>  	int rc = 0;
>  
> +	next_jiffies = jiffies;

This should probably be:

	next_jiffies = jiffies + HZ * 2;

and then...

>  	priv->multicast = 0;
>  	priv->promiscuous = 0;
>  
> @@ -5428,7 +5429,7 @@ static int netdev_open(struct net_device *dev)
>  		if (rc)
>  			return rc;
>  		for (i = 0; i < hw->mib_port_cnt; i++) {
> -			if (next_jiffies < jiffies)
> +			if (time_before(next_jiffies, jiffies))

I don't think this check is needed at all any more. Since we initialize
next_jiffies to jiffies earlier in the function it's got to be in the
right ballpark.

>  				next_jiffies = jiffies + HZ * 2;
>  			else
>  				next_jiffies += HZ * 1;

Remove the if and just leave this line to move the time forward.

Thanks!

