Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE5030A17
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfEaITE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:19:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:48640 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726485AbfEaITE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:19:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9D6C3AF0A;
        Fri, 31 May 2019 08:19:02 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 79CB9E00E3; Fri, 31 May 2019 10:19:01 +0200 (CEST)
Date:   Fri, 31 May 2019 10:19:01 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     sameehj@amazon.com, davem@davemloft.net,
        Arthur Kiyanovski <akiyano@amazon.com>, dwmw@amazon.com,
        zorik@amazon.com, matua@amazon.com, saeedb@amazon.com,
        msw@amazon.com, aliguori@amazon.com, nafea@amazon.com,
        gtzalik@amazon.com, netanel@amazon.com, alisaidi@amazon.com,
        benh@amazon.com
Subject: Re: [PATCH V1 net-next 02/11] net: ena: ethtool: add extra
 properties retrieval via get_priv_flags
Message-ID: <20190531081901.GC15954@unicorn.suse.cz>
References: <20190529095004.13341-1-sameehj@amazon.com>
 <20190529095004.13341-3-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529095004.13341-3-sameehj@amazon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 12:49:55PM +0300, sameehj@amazon.com wrote:
> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> This commit adds a mechanism for exposing different driver
> properties via ethtool's priv_flags.
> 
> In this commit we:
> 
> Add commands, structs and defines necessary for handling
> extra properties
> 
> Add functions for:
> Allocation/destruction of a buffer for extra properties strings.
> Retreival of extra properties strings and flags from the network device.
> 
> Handle the allocation of a buffer for extra properties strings.
> 
> * Initialize buffer with extra properties strings from the
>   network device at driver startup.
> 
> Use ethtool's get_priv_flags to expose extra properties of
> the ENA device
> 
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
> Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
> ---
...
> diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
> index bd0d785b2..935e8fa8d 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_com.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_com.c
> @@ -1877,6 +1877,62 @@ int ena_com_get_link_params(struct ena_com_dev *ena_dev,
>  	return ena_com_get_feature(ena_dev, resp, ENA_ADMIN_LINK_CONFIG);
>  }
>  
> +int ena_com_extra_properties_strings_init(struct ena_com_dev *ena_dev)
> +{
> +	struct ena_admin_get_feat_resp resp;
> +	struct ena_extra_properties_strings *extra_properties_strings =
> +			&ena_dev->extra_properties_strings;
> +	u32 rc;
> +
> +	extra_properties_strings->size = ENA_ADMIN_EXTRA_PROPERTIES_COUNT *
> +		ENA_ADMIN_EXTRA_PROPERTIES_STRING_LEN;
> +
> +	extra_properties_strings->virt_addr =
> +		dma_alloc_coherent(ena_dev->dmadev,
> +				   extra_properties_strings->size,
> +				   &extra_properties_strings->dma_addr,
> +				   GFP_KERNEL);

Do you need to fetch the private flag names on each ETHTOOL_GSTRING
request? I suppose they could change e.g. on a firmware update but then
even the count could change which you do not seem to handle. Is there
a reason not to fetch the names once on init rather then accessing the
device memory each time?

My point is that ethtool_ops::get_strings() does not return a value
which indicates that it's supposed to be a trivial operation which
cannot fail, usually a simple copy within kernel memory.

> +	if (unlikely(!extra_properties_strings->virt_addr)) {
> +		pr_err("Failed to allocate extra properties strings\n");
> +		return 0;
> +	}
> +
> +	rc = ena_com_get_feature_ex(ena_dev, &resp,
> +				    ENA_ADMIN_EXTRA_PROPERTIES_STRINGS,
> +				    extra_properties_strings->dma_addr,
> +				    extra_properties_strings->size);
> +	if (rc) {
> +		pr_debug("Failed to get extra properties strings\n");
> +		goto err;
> +	}
> +
> +	return resp.u.extra_properties_strings.count;
> +err:
> +	ena_com_delete_extra_properties_strings(ena_dev);
> +	return 0;
> +}
...
> diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> index fe596bc30..65bc5a2b2 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
...
> +static void get_private_flags_strings(struct ena_adapter *adapter, u8 *data)
> +{
> +	struct ena_com_dev *ena_dev = adapter->ena_dev;
> +	u8 *strings = ena_dev->extra_properties_strings.virt_addr;
> +	int i;
> +
> +	if (unlikely(!strings)) {
> +		adapter->ena_extra_properties_count = 0;
> +		netif_err(adapter, drv, adapter->netdev,
> +			  "Failed to allocate extra properties strings\n");
> +		return;
> +	}

This is a bit confusing, IMHO. I'm aware we shouldn't really get here as
with strings null, count would be zero and ethtool_get_strings()
wouldn't call the ->get_strings() callback. But if we ever do, it makes
little sense to complain about failed allocation (which happened once on
init) each time userspace makes ETHTOOL_GSTRINGS request for private
flags.

> +
> +	for (i = 0; i < adapter->ena_extra_properties_count; i++) {
> +		snprintf(data, ETH_GSTRING_LEN, "%s",
> +			 strings + ENA_ADMIN_EXTRA_PROPERTIES_STRING_LEN * i);

snprintf() is a bit overkill here, what you are doing is rather
strlcpy() or strscpy(). Or maybe strncpy() as strings returned by
->get_strings() do not have to be null terminated.

> +		data += ETH_GSTRING_LEN;
> +	}
> +}

Michal Kubecek
