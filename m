Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583571CBC39
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 03:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgEIByE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 21:54:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbgEIByE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 21:54:04 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C534E218AC;
        Sat,  9 May 2020 01:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588989244;
        bh=U+oZAKvfEcBrfRy9eyomxP9xIkvNuHokIR9NHxLx7Zc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cGn2b3P5tW4EYFTSJEN81nzCiav1F+xOpHytKoNr7DJqbCPbBFkFnaFbH9Gk1kA96
         tBCcbKMxGr5vccRKF/qQAny0phnH+kO9kQS2zMQkdQBkKFeMDJzVsGNj+47oDxIjlk
         rvYb2vT9rVgskaDm3E0Doe6mpomM86q5TOYF1gUE=
Date:   Fri, 8 May 2020 18:54:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, fthain@telegraphics.com.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net/sonic: Fix some resource leaks in error handling
 paths
Message-ID: <20200508185402.41d9d068@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200508172557.218132-1-christophe.jaillet@wanadoo.fr>
References: <20200508172557.218132-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 May 2020 19:25:57 +0200 Christophe JAILLET wrote:
> @@ -527,8 +531,9 @@ static int mac_sonic_platform_remove(struct platform_device *pdev)
>  	struct sonic_local* lp = netdev_priv(dev);
>  
>  	unregister_netdev(dev);
> -	dma_free_coherent(lp->device, SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
> -	                  lp->descriptors, lp->descriptors_laddr);
> +	dma_free_coherent(lp->device,
> +			  SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
> +			  lp->descriptors, lp->descriptors_laddr);
>  	free_netdev(dev);
>  
>  	return 0;

This is a white-space only change, right? Since this is a fix we should
avoid making cleanups which are not strictly necessary.
