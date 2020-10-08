Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56DA287F4B
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 01:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbgJHX7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 19:59:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728538AbgJHX7C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 19:59:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FE8622252;
        Thu,  8 Oct 2020 23:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602201541;
        bh=yOJ47KLe7U5sB6uGTfOhLpR98EQ0O7zDNkKCIuxcNJI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YZS3USsCX5t2nBvHwUIBlJlZV1rAdY2muNqg3qNRkRhmVbz0NZUltq/GPGIN0pcXp
         u2rI3OI+ZlXpVymLhJ9SE6jPC44js3qmo/JoJO3AQ2HP9hE9kc2rlW88JX4YTggIou
         GuuH/kMCO4YM1aL9WlrOOu8GQ4O5cKc02YFTry4k=
Date:   Thu, 8 Oct 2020 16:58:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Allen Pais <allen.lkml@gmail.com>
Cc:     davem@davemloft.net, m.grzeschik@pengutronix.de, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [next-next v3 05/10] net: cdc_ncm: convert tasklets to use new
 tasklet_setup() API
Message-ID: <20201008165859.2e96ef7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201006061159.292340-6-allen.lkml@gmail.com>
References: <20201006061159.292340-1-allen.lkml@gmail.com>
        <20201006061159.292340-6-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Oct 2020 11:41:54 +0530 Allen Pais wrote:
> From: Allen Pais <apais@linux.microsoft.com>
> 
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.

> @@ -815,7 +815,7 @@ int cdc_ncm_bind_common(struct usbnet *dev, struct usb_interface *intf, u8 data_
>  
>  	hrtimer_init(&ctx->tx_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>  	ctx->tx_timer.function = &cdc_ncm_tx_timer_cb;
> -	tasklet_init(&ctx->bh, cdc_ncm_txpath_bh, (unsigned long)dev);
> +	tasklet_setup(&ctx->bh, cdc_ncm_txpath_bh);
>  	atomic_set(&ctx->stop, 0);
>  	spin_lock_init(&ctx->mtx);
>  
> @@ -1468,9 +1468,9 @@ static enum hrtimer_restart cdc_ncm_tx_timer_cb(struct hrtimer *timer)
>  	return HRTIMER_NORESTART;
>  }
>  
> -static void cdc_ncm_txpath_bh(unsigned long param)
> +static void cdc_ncm_txpath_bh(struct tasklet_struct *t)
>  {
> -	struct usbnet *dev = (struct usbnet *)param;
> +	struct usbnet *dev = from_tasklet(dev, t, bh);
>  	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
>  
>  	spin_lock_bh(&ctx->mtx);

This one is wrong.

ctx is struct cdc_ncm_ctx, but you from_tasklet() struct usbdev.
They both happen to have a tasklet called bh in 'em.
