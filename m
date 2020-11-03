Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CD92A39E2
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 02:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgKCBan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 20:30:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbgKCBam (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 20:30:42 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28CE92222B;
        Tue,  3 Nov 2020 01:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604367042;
        bh=vYsjJ4LcHv3h33ZpuH8GNzXFKow9uMTh+xnXQ+58D/4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nBnUuvxeAl/VocO+V2l/y/FcMI9XQxxOtqmID88olkwB7sF+wqubbWe/XFApgdG7x
         WP9hXEQy1clNvHayHTOke/E37aFBozUAWWVYygbu3zV+XGf70nmrKw9oXYDHd3xQY9
         K1F4aCkMSb3Oq04+aykT696jwW/ToRHmLrx2NmSw=
Date:   Mon, 2 Nov 2020 17:30:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yu Kuai <yukuai3@huawei.com>
Cc:     <madalin.bucur@nxp.com>, <davem@davemloft.net>,
        <florinel.iordache@nxp.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>
Subject: Re: [PATCH] fsl/fman: add missing put_devcie() call in
 fman_port_probe()
Message-ID: <20201102173041.7624b7fb@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031105418.2304011-1-yukuai3@huawei.com>
References: <20201031105418.2304011-1-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 18:54:18 +0800 Yu Kuai wrote:
> if of_find_device_by_node() succeed, fman_port_probe() doesn't have a
> corresponding put_device(). Thus add jump target to fix the exception
> handling for this function implementation.
> 
> Fixes: 0572054617f3 ("fsl/fman: fix dereference null return value")
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

> diff --git a/drivers/net/ethernet/freescale/fman/fman_port.c b/drivers/net/ethernet/freescale/fman/fman_port.c
> index d9baac0dbc7d..576ce6df3fce 100644
> --- a/drivers/net/ethernet/freescale/fman/fman_port.c
> +++ b/drivers/net/ethernet/freescale/fman/fman_port.c
> @@ -1799,13 +1799,13 @@ static int fman_port_probe(struct platform_device *of_dev)
>  	of_node_put(fm_node);
>  	if (!fm_pdev) {
>  		err = -EINVAL;
> -		goto return_err;
> +		goto put_device;
>  	}

> @@ -1898,6 +1898,8 @@ static int fman_port_probe(struct platform_device *of_dev)
>  
>  return_err:
>  	of_node_put(port_node);
> +put_device:
> +	put_device(&fm_pdev->dev);
>  free_port:
>  	kfree(port);
>  	return err;

This does not look right. You're jumping to put_device() when fm_pdev
is NULL? 

The order of error handling should be the reverse of the order of
execution of the function.
