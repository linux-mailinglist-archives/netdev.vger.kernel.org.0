Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210D31B5171
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 02:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgDWAjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 20:39:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgDWAjn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 20:39:43 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FCC620776;
        Thu, 23 Apr 2020 00:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587602383;
        bh=OkG6PTaBw8gw2N0RBzpFps9AGXfW9KSNJXHczq2HhYg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uG5f0kOraF0CoZwloXwMygG2CnEaxrB0BRCmOM2VW4M53PIP0o+9ExFwFLuYEALuf
         9l5+NHV9l7/OEiOZR7H6xaeIq2aQhmnL06+x7EGDwCINtxSX5u6OOlCpBYTuiyGrPI
         L9YfsK2Av7RpI40Ph26s7FZBNPKpwy0Ua5wAy3fE=
Date:   Wed, 22 Apr 2020 17:39:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <sameehj@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>
Subject: Re: [PATCH V1 net-next 02/13] net: ena: avoid unnecessary admin
 command when RSS function set fails
Message-ID: <20200422173941.5d43c2df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200422081628.8103-3-sameehj@amazon.com>
References: <20200422081628.8103-1-sameehj@amazon.com>
        <20200422081628.8103-3-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Apr 2020 08:16:17 +0000 sameehj@amazon.com wrote:
> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> Currently when ena_set_hash_function() fails the hash function is
> restored to the previous value by calling an admin command to get
> the hash function from the device.

I don't see how. func argument is NULL. If I'm reading the code right
if this function is restoring anything it's restoring the rss key.

> In this commit we avoid the admin command, by saving the previous
> hash function before calling ena_set_hash_function() and using this
> previous value to restore the hash function in case of failure of
> ena_set_hash_function().
> 
> Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_com.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
> index 07b0f396d3c2..66edc86c41c9 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_com.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_com.c
> @@ -2286,6 +2286,7 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
>  	struct ena_admin_get_feat_resp get_resp;
>  	struct ena_admin_feature_rss_flow_hash_control *hash_key =
>  		rss->hash_key;
> +	enum ena_admin_hash_functions old_func;
>  	int rc;
>  
>  	/* Make sure size is a mult of DWs */
> @@ -2325,12 +2326,13 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
>  		return -EINVAL;
>  	}
>  
> +	old_func = rss->hash_func;
>  	rss->hash_func = func;
>  	rc = ena_com_set_hash_function(ena_dev);
>  
>  	/* Restore the old function */
>  	if (unlikely(rc))
> -		ena_com_get_hash_function(ena_dev, NULL, NULL);
> +		rss->hash_func = old_func;

Please order your commits correctly.

>  	return rc;
>  }

