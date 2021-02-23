Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11336322F4E
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 18:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbhBWRCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 12:02:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:43704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233683AbhBWRBw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 12:01:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49BE864E6C;
        Tue, 23 Feb 2021 17:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614099670;
        bh=g1gv8YO7pZWd5mR7ROnHGnD6kZp2ymr2KeI4zLzARSc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F8t18XW2i2HGK3WKbCzDO1rnnO5wPjD4eIXzmE/byJMWXCqfcc1/dF39JWGQtq8dv
         CPqIYmLXEY+TMeLCHxB+5pLj5V0LuTCbPom+wyR7VxfN3r8fLWYVk0FoGTBH4hexez
         K8fEupIddNDeHlYlRiS5IHtPpymBRZN6K3FHKy6RC409XQ4IaSWfBb8JMaU/WGlHH1
         igcdrCI7QmUkGL8tYBgvuj1/9YEe2yPYKuRKkwfofmV+OPvovZ5TqwV9hFQUYw83ay
         i3dgp3aNlqF8Z2WT+pVzD4wLlGw6Ga8dfc1D1xUeeZya6gcSoiQ14g//tp+c+aT7FS
         TSCu5g84jp/MQ==
Date:   Tue, 23 Feb 2021 09:01:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@netronome.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: Re: [PATCH net] ethtool: fix the check logic of at least one
 channel for RX/TX
Message-ID: <20210223090106.73d2e64d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210223132440.810-1-simon.horman@netronome.com>
References: <20210223132440.810-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Feb 2021 14:24:40 +0100 Simon Horman wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> The command "ethtool -L <intf> combined 0" may clean the RX/TX channel
> count and skip the error path, since the attrs
> tb[ETHTOOL_A_CHANNELS_RX_COUNT] and tb[ETHTOOL_A_CHANNELS_TX_COUNT]
> are NULL in this case when recent ethtool is used.
> 
> Tested using ethtool v5.10.
> 
> Fixes: 7be92514b99c ("ethtool: check if there is at least one channel for TX/RX in the core")
> Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@netronome.com>
> Signed-off-by: Louis Peens <louis.peens@netronome.com>

Please make sure you CC Michal on ethtool patches.

> diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
> index 25a9e566ef5c..e35ef627f61f 100644
> --- a/net/ethtool/channels.c
> +++ b/net/ethtool/channels.c
> @@ -175,14 +175,14 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
>  
>  	/* ensure there is at least one RX and one TX channel */
>  	if (!channels.combined_count && !channels.rx_count)
> -		err_attr = tb[ETHTOOL_A_CHANNELS_RX_COUNT];
> +		err_attr = mod_combined ? tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT] :
> +					  tb[ETHTOOL_A_CHANNELS_RX_COUNT];
>  	else if (!channels.combined_count && !channels.tx_count)
> -		err_attr = tb[ETHTOOL_A_CHANNELS_TX_COUNT];
> +		err_attr = mod_combined ? tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT] :
> +					  tb[ETHTOOL_A_CHANNELS_TX_COUNT];
>  	else
>  		err_attr = NULL;
>  	if (err_attr) {
> -		if (mod_combined)
> -			err_attr = tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT];
>  		ret = -EINVAL;
>  		NL_SET_ERR_MSG_ATTR(info->extack, err_attr, "requested channel counts would result in no RX or TX channel being configured");
>  		goto out_ops;

In case driver decides to adjust max counts - I'd lean towards:

diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index 5635604cb9ba..73d267415819 100644
--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -116,10 +116,10 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
        struct ethtool_channels channels = {};
        struct ethnl_req_info req_info = {};
        struct nlattr **tb = info->attrs;
-       const struct nlattr *err_attr;
        const struct ethtool_ops *ops;
        struct net_device *dev;
        u32 max_rx_in_use = 0;
+       u32 err_attr;
        int ret;
 
        ret = ethnl_parse_header_dev_get(&req_info,
@@ -157,34 +157,34 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
 
        /* ensure new channel counts are within limits */
        if (channels.rx_count > channels.max_rx)
-               err_attr = tb[ETHTOOL_A_CHANNELS_RX_COUNT];
+               err_attr = ETHTOOL_A_CHANNELS_RX_COUNT;
        else if (channels.tx_count > channels.max_tx)
-               err_attr = tb[ETHTOOL_A_CHANNELS_TX_COUNT];
+               err_attr = ETHTOOL_A_CHANNELS_TX_COUNT;
        else if (channels.other_count > channels.max_other)
-               err_attr = tb[ETHTOOL_A_CHANNELS_OTHER_COUNT];
+               err_attr = ETHTOOL_A_CHANNELS_OTHER_COUNT;
        else if (channels.combined_count > channels.max_combined)
-               err_attr = tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT];
+               err_attr = ETHTOOL_A_CHANNELS_COMBINED_COUNT;
        else
-               err_attr = NULL;
+               err_attr = 0;
        if (err_attr) {
                ret = -EINVAL;
-               NL_SET_ERR_MSG_ATTR(info->extack, err_attr,
+               NL_SET_ERR_MSG_ATTR(info->extack, tb[err_attr],
                                    "requested channel count exceeds maximum");
                goto out_ops;
        }
 
        /* ensure there is at least one RX and one TX channel */
        if (!channels.combined_count && !channels.rx_count)
-               err_attr = tb[ETHTOOL_A_CHANNELS_RX_COUNT];
+               err_attr = ETHTOOL_A_CHANNELS_RX_COUNT;
        else if (!channels.combined_count && !channels.tx_count)
-               err_attr = tb[ETHTOOL_A_CHANNELS_TX_COUNT];
+               err_attr = ETHTOOL_A_CHANNELS_TX_COUNT;
        else
-               err_attr = NULL;
+               err_attr = 0;
        if (err_attr) {
                if (mod_combined)
-                       err_attr = tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT];
+                       err_attr = ETHTOOL_A_CHANNELS_COMBINED_COUNT;
                ret = -EINVAL;
-               NL_SET_ERR_MSG_ATTR(info->extack, err_attr, "requested channel counts would result in no RX or TX channel being configured");
+               NL_SET_ERR_MSG_ATTR(info->extack, tb[err_attr], "requested channel counts would result in no RX or TX channel being configured");
                goto out_ops;
        }
 
