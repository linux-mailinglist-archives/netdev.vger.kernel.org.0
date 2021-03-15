Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E421F33C817
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 22:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbhCOVBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 17:01:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232525AbhCOVBR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 17:01:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 125F464F26;
        Mon, 15 Mar 2021 21:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615842077;
        bh=GH9NH9q6YK12It0vN7WyhyXDc0rtjelfQErFT040adA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RmFnVT8EXwPUGfGikW5LBY+ppK5zbQ05+Pl1yWvBY8mZqLc5H8sCXGq4+TfMvJ8m7
         Te49rX5tZOYaXDXzk3su6TDaIhwnsb2OWdN5ePGcCM834RZ2vqmcDDJvHyWf2YxKNq
         ZNAf9fv+TBWtpenu8dYAtpIs2UpbfKTSWDzwzd0YAWrXMZh+PRshuIdVwdC7hIkWMH
         y6ZOq6zFrmf/wGGSV9LltsCakvzv1MSK8sWe8yYvPZ9wnSHRh2e0x30/wYa3ycQkab
         K4qOcetVyaxAw6JEKSp7ErbcNZjfm1kz/bfgm30YxPi1LnRJ7E+5ZvmPFLzy47Vrw7
         BIZV8OTTzsBMA==
Date:   Mon, 15 Mar 2021 14:01:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>,
        <netdev@vger.kernel.org>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Subject: Re: [RFC PATCH V3 net-next 1/5] ethtool: Allow network drivers to
 dump arbitrary EEPROM data
Message-ID: <20210315140116.0a1125c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1615828363-464-2-git-send-email-moshe@nvidia.com>
References: <1615828363-464-1-git-send-email-moshe@nvidia.com>
        <1615828363-464-2-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Mar 2021 19:12:39 +0200 Moshe Shemesh wrote:
> From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
> 
> Define get_module_eeprom_data_by_page() ethtool callback and implement
> netlink infrastructure.
> 
> get_module_eeprom_data_by_page() allows network drivers to dump a part
> of module's EEPROM specified by page and bank numbers along with offset
> and length. It is effectively a netlink replacement for
> get_module_info() and get_module_eeprom() pair, which is needed due to
> emergence of complex non-linear EEPROM layouts.
> 
> Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

s/eeprom_data/eeprom/ everywhere?

Otherwise some of your identifiers are over 30 characters long.

> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index cde753bb2093..b3e92db3ad37 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -340,6 +340,28 @@ struct ethtool_eeprom {
>  	__u8	data[0];
>  };
>  
> +/**
> + * struct ethtool_eeprom_data - EEPROM dump from specified page
> + * @offset: Offset within the specified EEPROM page to begin read, in bytes.
> + * @length: Number of bytes to read.
> + * @page: Page number to read from.
> + * @bank: Page bank number to read from, if applicable by EEPROM spec.
> + * @i2c_address: I2C address of a page. Value less than 0x7f expected. Most
> + *	EEPROMs use 0x50 or 0x51.
> + * @data: Pointer to buffer with EEPROM data of @length size.
> + *
> + * This can be used to manage pages during EEPROM dump in ethtool and pass
> + * required information to the driver.
> + */
> +struct ethtool_eeprom_data {
> +	__u32	offset;
> +	__u32	length;
> +	__u8	page;
> +	__u8	bank;
> +	__u8	i2c_address;
> +	__u8	*data;
> +};
> +

This structure does not have to be part of uAPI, right?

> +#define ETH_MODULE_EEPROM_PAGE_LEN	256
> +#define ETH_MODULE_MAX_I2C_ADDRESS	0x7f

Not sure about these defines either.

> +static int eeprom_data_prepare_data(const struct ethnl_req_info *req_base,
> +				    struct ethnl_reply_data *reply_base,
> +				    struct genl_info *info)
> +{
> +	struct eeprom_data_reply_data *reply = EEPROM_DATA_REPDATA(reply_base);
> +	struct eeprom_data_req_info *request = EEPROM_DATA_REQINFO(req_base);
> +	struct ethtool_eeprom_data page_data = {0};
> +	struct net_device *dev = reply_base->dev;
> +	int ret;
> +
> +	if (!dev->ethtool_ops->get_module_eeprom_data_by_page)
> +		return -EOPNOTSUPP;
> +
> +	page_data.offset = request->offset;
> +	page_data.length = request->length;
> +	page_data.i2c_address = request->i2c_address;
> +	page_data.page = request->page;
> +	page_data.bank = request->bank;
> +	page_data.data = kmalloc(page_data.length, GFP_KERNEL);
> +	if (!page_data.data)
> +		return -ENOMEM;

nit: new line?

> +	ret = ethnl_ops_begin(dev);
> +	if (ret)
> +		goto err_free;
> +
> +	ret = dev->ethtool_ops->get_module_eeprom_data_by_page(dev, &page_data,
> +							       info->extack);
> +	if (ret < 0)
> +		goto err_ops;
> +
> +	reply->length = ret;
> +	reply->data = page_data.data;
> +
> +	ethnl_ops_complete(dev);
> +	return 0;
> +
> +err_ops:
> +	ethnl_ops_complete(dev);
> +err_free:
> +	kfree(page_data.data);
> +	return ret;
> +}
> +
> +static int eeprom_data_parse_request(struct ethnl_req_info *req_info, struct nlattr **tb,
> +				     struct netlink_ext_ack *extack)
> +{
> +	struct eeprom_data_req_info *request = EEPROM_DATA_REQINFO(req_info);
> +	struct net_device *dev = req_info->dev;
> +
> +	if (!tb[ETHTOOL_A_EEPROM_DATA_OFFSET] ||
> +	    !tb[ETHTOOL_A_EEPROM_DATA_LENGTH] ||
> +	    !tb[ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS])
> +		return -EINVAL;
> +
> +	request->i2c_address = nla_get_u8(tb[ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS]);
> +	if (request->i2c_address > ETH_MODULE_MAX_I2C_ADDRESS)
> +		return -EINVAL;

Max value should be set in the netlink policy.

> +	request->offset = nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_OFFSET]);
> +	request->length = nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_LENGTH]);
> +	if (tb[ETHTOOL_A_EEPROM_DATA_PAGE] &&
> +	    dev->ethtool_ops->get_module_eeprom_data_by_page &&

Why check dev->ethtool_ops->get_module_eeprom_data_by_page here?

> +	    request->offset + request->length > ETH_MODULE_EEPROM_PAGE_LEN)
> +		return -EINVAL;
> +
> +	if (tb[ETHTOOL_A_EEPROM_DATA_PAGE])
> +		request->page = nla_get_u8(tb[ETHTOOL_A_EEPROM_DATA_PAGE]);
> +	if (tb[ETHTOOL_A_EEPROM_DATA_BANK])
> +		request->bank = nla_get_u8(tb[ETHTOOL_A_EEPROM_DATA_BANK]);
> +
> +	return 0;
> +}
> +
> +static int eeprom_data_reply_size(const struct ethnl_req_info *req_base,
> +				  const struct ethnl_reply_data *reply_base)
> +{
> +	const struct eeprom_data_req_info *request = EEPROM_DATA_REQINFO(req_base);
> +
> +	return nla_total_size(sizeof(u32)) + /* _EEPROM_DATA_LENGTH */
> +	       nla_total_size(sizeof(u8) * request->length); /* _EEPROM_DATA */
> +}

Why report length? Is the netlink length of the DATA attribute not
sufficient?

Should we echo back offset in case driver wants to report re-aligned
data?

> +const struct nla_policy ethnl_eeprom_data_get_policy[] = {
> +	[ETHTOOL_A_EEPROM_DATA_HEADER]		= NLA_POLICY_NESTED(ethnl_header_policy),
> +	[ETHTOOL_A_EEPROM_DATA_OFFSET]		= { .type = NLA_U32 },
> +	[ETHTOOL_A_EEPROM_DATA_LENGTH]		= { .type = NLA_U32 },
> +	[ETHTOOL_A_EEPROM_DATA_PAGE]		= { .type = NLA_U8 },
> +	[ETHTOOL_A_EEPROM_DATA_BANK]		= { .type = NLA_U8 },
> +	[ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS]	= { .type = NLA_U8 },
> +	[ETHTOOL_A_EEPROM_DATA]			= { .type = NLA_BINARY },

This is a policy for inputs, DATA should not be allowed on input, right?
