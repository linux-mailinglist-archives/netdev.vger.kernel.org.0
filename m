Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B541B5152
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 02:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgDWAe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 20:34:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgDWAe2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 20:34:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 395962076C;
        Thu, 23 Apr 2020 00:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587602067;
        bh=1NDoRcAvGvcbpVF+Dv/DgmTW72TGz7+wqgwt0iV/8UQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lGfhwhjNbBwSUV1dd6YIfTT5eGKNqyDeKDuK1O4V44TfoRJw36pvUudtIBS9RZvwJ
         4Pffh9dtnpJnsGrTK7M5a0EbS+OESmqzUeo4963y8b/eKBHCIZN+4EJj65/5Wb9dZe
         pRvb3tSb+aOB+VNWuz5ZlY3ie56DCw79vCX7cXRM=
Date:   Wed, 22 Apr 2020 17:34:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <sameehj@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>
Subject: Re: [PATCH V1 net-next 01/13] net: ena: fix error returning in
 ena_com_get_hash_function()
Message-ID: <20200422173425.1a46db2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200422081628.8103-2-sameehj@amazon.com>
References: <20200422081628.8103-1-sameehj@amazon.com>
        <20200422081628.8103-2-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Apr 2020 08:16:16 +0000 sameehj@amazon.com wrote:
> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> In case the "func" parameter is NULL we now return "-EINVAL".
> This shouldn't happen in general, but when it does happen, this is the
> proper way to handle it.
> 
> We also check func for NULL in the beginning of the function, as there
> is no reason to do all the work and realize in the end of the function
> it was useless.
> 
> Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
> Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_com.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
> index a250046b8e18..07b0f396d3c2 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_com.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_com.c
> @@ -2345,6 +2345,9 @@ int ena_com_get_hash_function(struct ena_com_dev *ena_dev,
>  		rss->hash_key;
>  	int rc;
>
> +	if (unlikely(!func))
> +		return -EINVAL;
> +

There is a call to this with func being null like 5 lines above:

	/* Restore the old function */
	if (unlikely(rc))
		ena_com_get_hash_function(ena_dev, NULL, NULL);

What am I missing?


>  	rc = ena_com_get_feature_ex(ena_dev, &get_resp,
>  				    ENA_ADMIN_RSS_HASH_FUNCTION,
>  				    rss->hash_key_dma_addr,
> @@ -2357,8 +2360,7 @@ int ena_com_get_hash_function(struct ena_com_dev *ena_dev,
>  	if (rss->hash_func)
>  		rss->hash_func--;
>  
> -	if (func)
> -		*func = rss->hash_func;
> +	*func = rss->hash_func;
>  
>  	if (key)
>  		memcpy(key, hash_key->key, (size_t)(hash_key->keys_num) << 2);

