Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61322A74E3
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 02:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731609AbgKEBbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 20:31:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgKEBbW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 20:31:22 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5844A20679;
        Thu,  5 Nov 2020 01:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604539881;
        bh=c9ChzfIEEb0yIJdXlwPM7rs9PlJD4t5/TTBbNsrgkso=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gtDD8hiXZOXLHgRd6xA9gPXK2c6tWwgJHbYYv1DNXC3GnF6RG4xdGwiBROHM7dHVo
         lGYf82s3Iyq93Dm1BM/d2VcMWPDT89RKXMNWkAtTdnM+CyZdxfFaZMofMKXxBI2ZBQ
         wQJgIQ7EuAFCF0GQD3AfcRHLaYm3d3YVqPApY0dw=
Date:   Wed, 4 Nov 2020 17:31:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yu Kuai <yukuai3@huawei.com>
Cc:     <madalin.bucur@nxp.com>, <davem@davemloft.net>,
        <florinel.iordache@nxp.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>
Subject: Re: [PATCH V2] fsl/fman: add missing put_devcie() call in
 fman_port_probe()
Message-ID: <20201104173120.0c72d1b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201103112323.1077040-1-yukuai3@huawei.com>
References: <20201031105418.2304011-1-yukuai3@huawei.com>
        <20201103112323.1077040-1-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 19:23:23 +0800 Yu Kuai wrote:
> --- a/drivers/net/ethernet/freescale/fman/fman_port.c
> +++ b/drivers/net/ethernet/freescale/fman/fman_port.c
> @@ -1792,20 +1792,21 @@ static int fman_port_probe(struct platform_device *of_dev)
>  	if (!fm_node) {
>  		dev_err(port->dev, "%s: of_get_parent() failed\n", __func__);
>  		err = -ENODEV;
> -		goto return_err;
> +		goto free_port;
>  	}
>  
> +	of_node_put(port_node);
>  	fm_pdev = of_find_device_by_node(fm_node);
>  	of_node_put(fm_node);
>  	if (!fm_pdev) {
>  		err = -EINVAL;
> -		goto return_err;
> +		goto free_port;
>  	}

This is not right either. I just asked you fix up the order of the
error path, not move the of_node_put() in the body of the function. 

Now you're releasing the reference on the object and still use it after.
