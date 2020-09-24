Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C278277C1E
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 01:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgIXXDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 19:03:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbgIXXDh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 19:03:37 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B043023899;
        Thu, 24 Sep 2020 23:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600988616;
        bh=hGAr1DyrKMvJfHCuTXUvZxsxQexH/3J+s/hSSUjAXL8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=btywj1DxkUNbb0mGpA15Ya5SlOsh9mdb9r3df7Zio3Fmzde5gHTWJuF3Tu4a1X1oU
         wfa9KMCjcA7w7ZkEdxb7nTW/q3PoJSDqutcE6v2c1VItYhJe9ImzkPmF06cCD2cC+7
         A0GSA3pzmyQ5C0ifHLwJzXdYe7A5agxp7hvu9JWQ=
Date:   Thu, 24 Sep 2020 16:03:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next v3 1/4] gve: Add support for raw addressing
 device option
Message-ID: <20200924160335.003bdab0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200924010104.3196839-2-awogbemila@google.com>
References: <20200924010104.3196839-1-awogbemila@google.com>
        <20200924010104.3196839-2-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Sep 2020 18:01:01 -0700 David Awogbemila wrote:
> @@ -518,6 +521,49 @@ int gve_adminq_describe_device(struct gve_priv *priv)
>  		priv->rx_desc_cnt = priv->rx_pages_per_qpl;
>  	}
>  	priv->default_num_queues = be16_to_cpu(descriptor->default_num_queues);
> +	dev_opt = (void *)(descriptor + 1);
> +
> +	num_options = be16_to_cpu(descriptor->num_device_options);
> +	for (i = 0; i < num_options; i++) {
> +		u16 option_length = be16_to_cpu(dev_opt->option_length);
> +		u16 option_id = be16_to_cpu(dev_opt->option_id);
> +
> +		if ((void *)dev_opt + sizeof(*dev_opt) + option_length > (void *)descriptor +
> +				      be16_to_cpu(descriptor->total_length)) {

Can you calculate an void *end pointer before the loop and avoid this
very long condition?

> +			dev_err(&priv->dev->dev,
> +				"options exceed device_descriptor's total length.\n");
> +			err = -EINVAL;
> +			goto free_device_descriptor;
> +		}
> +
> +		switch (option_id) {
> +		case GVE_DEV_OPT_ID_RAW_ADDRESSING:
> +			/* If the length or feature mask doesn't match,
> +			 * continue without enabling the feature.
> +			 */
> +			if (option_length != GVE_DEV_OPT_LEN_RAW_ADDRESSING ||
> +			    be32_to_cpu(dev_opt->feat_mask) !=
> +			    GVE_DEV_OPT_FEAT_MASK_RAW_ADDRESSING) {

Apply the byteswap to the constant so it's done at compilation time.

> +				dev_info(&priv->pdev->dev,
> +					 "Raw addressing device option not enabled, length or features mask did not match expected.\n");

dev_warn(), also do yourself a favor and print what the values were.

> +				priv->raw_addressing = false;
> +			} else {
> +				dev_info(&priv->pdev->dev,
> +					 "Raw addressing device option enabled.\n");
> +				priv->raw_addressing = true;

Does this really need to be printed on every boot?

> +			}
> +			break;
> +		default:
> +			/* If we don't recognize the option just continue
> +			 * without doing anything.
> +			 */
> +			dev_info(&priv->pdev->dev,
> +				 "Unrecognized device option 0x%hx not enabled.\n",

dev_dbg()

> +				   option_id);

alignment is off

> +			break;
> +		}
> +		dev_opt = (void *)dev_opt + sizeof(*dev_opt) + option_length;
> +	}
