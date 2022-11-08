Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04226206B5
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 03:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232924AbiKHCZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 21:25:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbiKHCZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 21:25:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE5E17ABC
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 18:25:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8CC5613B3
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 02:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35CFC433C1;
        Tue,  8 Nov 2022 02:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667874351;
        bh=IADCvyp4/i+Df51/ZVav5HzI/P7HrL0liKSUYeBjNPo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jVF4kSgM+/4lvBO8j5dLsG+83drXXzOc0j38rBFNLuMFyqtbUWLfKAo8hG8jVcqf+
         7LxX8YDizlbKxeOdTDjOq8r1WrxY3ArMaIz8j9G7EjxeiGpjWtwZXY12LR9DWgmtu8
         yt5iQQAfMlBvu+OaJjlaGT2azRzQ1Dbkl0rBDHR/B3TPt1N2aNdS51WA8hZ1Sw/akd
         ZeSj/lIl3i2YBOkRfT6568UOb/oHm0iN42hu8Ok3BTusDMcQ0i5UgNdBOiV76lzeX0
         AhmtozXOA4eQLiAIhBiDaSb0LoUb2fMycAwqmNlobnOvpzj8sxLpepEEOQTsp3Ft7W
         zMxirriH7RC5w==
Date:   Mon, 7 Nov 2022 18:25:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, andrew@lunn.ch,
        corbet@lwn.net, sridhar.samudrala@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v2] ethtool: add netlink based get rxfh support
Message-ID: <20221107182549.278e0d7a@kernel.org>
In-Reply-To: <20221104234244.242527-1-sudheer.mogilappagari@intel.com>
References: <20221104234244.242527-1-sudheer.mogilappagari@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Nov 2022 16:42:44 -0700 Sudheer Mogilappagari wrote:
> Implement RXFH_GET request to get RSS table, hash key
> and hash function of an interface. This is netlink
> equivalent implementation of ETHTOOL_GRSSH ioctl request.

Motivation would be good to have, if any. Are you going to add new
fields or is it simply to fill in the implementation gap we have in
the netlink version?

> +RXFH_GET
> +========
> +
> +Get RSS table, hash key and hash function info like ``ETHTOOL_GRSSH``
> +ioctl request.


Can we describe in more detail which commands are reimplemented?
Otherwise calling the command RXFH makes little sense.
We may be better of using RSS in the name in the first place.

> +Request contents:
> +
> +=====================================  ======  ==========================
> +  ``ETHTOOL_A_RXFH_HEADER``            nested  request header
> +  ``ETHTOOL_A_RXFH_RSS_CONTEXT``       u32     context number
> + ====================================  ======  ==========================
> +
> +Kernel response contents:
> +
> +=====================================  ======  ==========================
> +  ``ETHTOOL_A_RXFH_HEADER``            nested  reply header
> +  ``ETHTOOL_A_RXFH_RSS_CONTEXT``       u32     RSS context number
> +  ``ETHTOOL_A_RXFH_INDIR_SIZE``        u32     RSS Indirection table size
> +  ``ETHTOOL_A_RXFH_KEY_SIZE``          u32     RSS hash key size
> +  ``ETHTOOL_A_RXFH_HFUNC``             u32     RSS hash func

This is u8 in the implementation, please make the implementation u32 as
documented.

> +  ``ETHTOOL_A_RXFH_RSS_CONFIG``        u32     Indir table and hkey bytes

These should really be separate attributes.

Do we even need the indir_size and key_size given every attribute has 
a length so user can just look at the length of the attrs to see the
length?

> +static int rxfh_prepare_data(const struct ethnl_req_info *req_base,
> +			     struct ethnl_reply_data *reply_base,
> +			     struct genl_info *info)
> +{
> +	struct rxfh_reply_data *data = RXFH_REPDATA(reply_base);
> +	struct net_device *dev = reply_base->dev;
> +	struct ethtool_rxfh *rxfh = &data->rxfh;
> +	struct ethnl_req_info req_info = {};
> +	struct nlattr **tb = info->attrs;
> +	u32 indir_size = 0, hkey_size = 0;
> +	const struct ethtool_ops *ops;
> +	u32 total_size, indir_bytes;
> +	bool mod = false;
> +	u8 dev_hfunc = 0;
> +	u8 *hkey = NULL;
> +	u8 *rss_config;
> +	int ret;
> +
> +	ops = dev->ethtool_ops;
> +	if (!ops->get_rxfh)
> +		return -EOPNOTSUPP;
> +
> +	ret = ethnl_parse_header_dev_get(&req_info,
> +					 tb[ETHTOOL_A_RXFH_HEADER],
> +					 genl_info_net(info), info->extack,
> +					 true);

Why are you parsing again?

You hook in ethnl_default_doit() and ethnl_default_dumpit(),
which should call the parsing for you already.

> +	if (ret < 0)
> +		return ret;
> +
> +	ethnl_update_u32(&rxfh->rss_context, tb[ETHTOOL_A_RXFH_RSS_CONTEXT],
> +			 &mod);

ethnl_update_u32() is for when you're updating the config.
You can use plain netlink helpers to get request arguments.

> +	/* Some drivers don't handle rss_context */
> +	if (rxfh->rss_context && !ops->get_rxfh_context) {
> +		ret = -EOPNOTSUPP;
> +		goto out_dev;
> +	}
> +
> +	ret = ethnl_ops_begin(dev);
> +	if (ret < 0)
> +		goto out_dev;
> +
> +	if (ops->get_rxfh_indir_size)
> +		indir_size = ops->get_rxfh_indir_size(dev);
> +	if (ops->get_rxfh_key_size)
> +		hkey_size = ops->get_rxfh_key_size(dev);
> +
> +	indir_bytes = indir_size * sizeof(rxfh->rss_config[0]);
> +	total_size = indir_bytes + hkey_size;
> +	rss_config = kzalloc(total_size, GFP_USER);

GFP_KERNEL is enough here

> +	if (!rss_config) {
> +		ret = -ENOMEM;
> +		goto out_ops;
> +	}
> +
> +	if (indir_size) {
> +		data->rss_config = (u32 *)rss_config;
> +		rxfh->indir_size = indir_size;
> +	}
> +
> +	if (hkey_size) {
> +		hkey = rss_config + indir_bytes;
> +		rxfh->key_size = hkey_size;
> +	}
> +
> +	if (rxfh->rss_context)
> +		ret = ops->get_rxfh_context(dev, data->rss_config, hkey,
> +					    &dev_hfunc, rxfh->rss_context);
> +	else
> +		ret = ops->get_rxfh(dev, data->rss_config, hkey, &dev_hfunc);

This will not be sufficient for dump, I'm afraid.

For dump we need to find a way to dump all contexts in all devices.
Which may require extending the driver API. Maybe drop the dump
implementation for now?

> +	rxfh->hfunc = dev_hfunc;
> +
> +out_ops:
> +	ethnl_ops_complete(dev);
> +out_dev:
> +	ethnl_parse_header_dev_put(&req_info);
> +	return ret;
> +}

