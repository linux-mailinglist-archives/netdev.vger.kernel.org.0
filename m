Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568835832DF
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 21:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbiG0TGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 15:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiG0TGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 15:06:07 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743B052DC0;
        Wed, 27 Jul 2022 11:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xQPcyNqfjHCOhqiEMs+qhBn/AdkzJIW6wtElPE1gWHM=; b=cyhYqOPO9mtziI7kmxVZW7y977
        pinsDTaUIrnXw8icTKZ68o4V8bERQlroAocunCsFNJ2uEwoHJbk7mJe1k33I+pm6O/GCqElVfroLs
        D5PJn/gNp50Om6qDmtnTnHqZsMW+YJhc0iW5gW+40sV4wh7aQAVemNSAlUl+tlmXKNGg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oGlre-00Bi3v-0D; Wed, 27 Jul 2022 20:34:34 +0200
Date:   Wed, 27 Jul 2022 20:34:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Hayes Wang <hayeswang@realtek.com>,
        USB list <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: handling MAC set by user space in reset_resume() of r8152
Message-ID: <YuGFOU7oKlAGZjTa@lunn.ch>
References: <2397d98d-e373-1740-eb5f-8fe795a0352a@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2397d98d-e373-1740-eb5f-8fe795a0352a@suse.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 01:39:43PM +0200, Oliver Neukum wrote:
> Hi,
> 
> looking at the driver it looks to me like the address
> provided to ndo_set_mac_address() is thrown away after use.
> That looks problematic to me, because reset_resume()
> should redo the operation.
> What do you think?
> 
> 	Regards
> 		Oliver

> From 19fc972a5cc98197bc81a7c56dd5d68e3fdfc36b Mon Sep 17 00:00:00 2001
> From: Oliver Neukum <oneukum@suse.com>
> Date: Wed, 27 Jul 2022 13:29:42 +0200
> Subject: [PATCH] r8152: restore external MAC in reset_resume
> 
> If user space has set the MAC of the interface,
> reset_resume() must restore that setting rather
> than redetermine the MAC like if te interface
> is probed regularly.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> ---
>  drivers/net/usb/r8152.c | 34 +++++++++++++++++++++++++---------
>  1 file changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 0f6efaabaa32..5cf74b984655 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -923,6 +923,7 @@ struct r8152 {
>  	atomic_t rx_count;
>  
>  	bool eee_en;
> +	bool external_mac;
>  	int intr_interval;
>  	u32 saved_wolopts;
>  	u32 msg_enable;
> @@ -933,6 +934,8 @@ struct r8152 {
>  	u32 rx_copybreak;
>  	u32 rx_pending;
>  	u32 fc_pause_on, fc_pause_off;
> +	/* for reset_resume */
> +	struct sockaddr saved_addr;
>  
>  	unsigned int pipe_in, pipe_out, pipe_intr, pipe_ctrl_in, pipe_ctrl_out;
>  
> @@ -1574,6 +1577,7 @@ static int __rtl8152_set_mac_address(struct net_device *netdev, void *p,
>  	mutex_lock(&tp->control);
>  
>  	eth_hw_addr_set(netdev, addr->sa_data);
> +	memcpy(&tp->saved_addr, addr, sizeof(tp->saved_addr));

Do you need a copy in tp? I would expect the MAC address stored in
netdev by eth_hw_addr_set() is still there after the resume?

       Andrew
