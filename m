Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13A72AA833
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 23:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbgKGWJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 17:09:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:50444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgKGWJy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 17:09:54 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D258220702;
        Sat,  7 Nov 2020 22:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604786994;
        bh=P69/MVPtSLlqmmiXEPZLWJik5SF3YokFWmFRfoizsnM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jzwKECuA+biP5vP9ftywRYFSBX+85OieEZlUzsQMEYcAmbfmAO7VFFT0E6Er9GGil
         fcXzZmkoxlYZA1dhDz71jqWfTZq4bAbZ70mOeqRCfNWxNSMEQezMQHUjZctvLIq7FE
         qunHfw2O2psUVeH19+7qDT95io7aCKC9ryNEFWqM=
Date:   Sat, 7 Nov 2020 14:09:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yu Kuai <yukuai3@huawei.com>
Cc:     <madalin.bucur@nxp.com>, <davem@davemloft.net>,
        <florinel.iordache@nxp.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>
Subject: Re: [PATCH V3] fsl/fman: add missing put_devcie() call in
 fman_port_probe()
Message-ID: <20201107140953.1f04c04e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201107090925.1494578-1-yukuai3@huawei.com>
References: <20201103112323.1077040-1-yukuai3@huawei.com>
        <20201107090925.1494578-1-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 7 Nov 2020 17:09:25 +0800 Yu Kuai wrote:
> if of_find_device_by_node() succeed, fman_port_probe() doesn't have a
> corresponding put_device(). Thus add jump target to fix the exception
> handling for this function implementation.
> 
> Fixes: 0572054617f3 ("fsl/fman: fix dereference null return value")
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

> @@ -1792,20 +1792,20 @@ static int fman_port_probe(struct platform_device *of_dev)
>  	if (!fm_node) {
>  		dev_err(port->dev, "%s: of_get_parent() failed\n", __func__);
>  		err = -ENODEV;
> -		goto return_err;
> +		goto free_port;

And now you no longer put port_node if jumping from here...

Also does the reference to put_device() not have to be released when
this function succeeds?

>  	}

> @@ -1896,7 +1895,9 @@ static int fman_port_probe(struct platform_device *of_dev)
>  
>  	return 0;
>  
> -return_err:
> +put_device:
> +	put_device(&fm_pdev->dev);
> +put_node:
>  	of_node_put(port_node);
>  free_port:
>  	kfree(port);

