Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E933234CF
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 02:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbhBXA7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 19:59:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:52956 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234369AbhBXAoN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 19:44:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 553A6AEC4;
        Wed, 24 Feb 2021 00:43:07 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 192ED60795; Wed, 24 Feb 2021 01:43:07 +0100 (CET)
Date:   Wed, 24 Feb 2021 01:43:07 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@netronome.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: Re: [PATCH net] ethtool: fix the check logic of at least one channel
 for RX/TX
Message-ID: <20210224004307.hcwj32u42qzhphjb@lion.mk-sys.cz>
References: <20210223132440.810-1-simon.horman@netronome.com>
 <20210223090106.73d2e64d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223090106.73d2e64d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 09:01:06AM -0800, Jakub Kicinski wrote:
> On Tue, 23 Feb 2021 14:24:40 +0100 Simon Horman wrote:
> > From: Yinjun Zhang <yinjun.zhang@corigine.com>
> > 
> > The command "ethtool -L <intf> combined 0" may clean the RX/TX channel
> > count and skip the error path, since the attrs
> > tb[ETHTOOL_A_CHANNELS_RX_COUNT] and tb[ETHTOOL_A_CHANNELS_TX_COUNT]
> > are NULL in this case when recent ethtool is used.
> > 
> > Tested using ethtool v5.10.
> > 
> > Fixes: 7be92514b99c ("ethtool: check if there is at least one channel for TX/RX in the core")
> > Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> > Signed-off-by: Simon Horman <simon.horman@netronome.com>
> > Signed-off-by: Louis Peens <louis.peens@netronome.com>
> 
> Please make sure you CC Michal on ethtool patches.
> 
> > diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
> > index 25a9e566ef5c..e35ef627f61f 100644
> > --- a/net/ethtool/channels.c
> > +++ b/net/ethtool/channels.c
> > @@ -175,14 +175,14 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
> >  
> >  	/* ensure there is at least one RX and one TX channel */
> >  	if (!channels.combined_count && !channels.rx_count)
> > -		err_attr = tb[ETHTOOL_A_CHANNELS_RX_COUNT];
> > +		err_attr = mod_combined ? tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT] :
> > +					  tb[ETHTOOL_A_CHANNELS_RX_COUNT];
> >  	else if (!channels.combined_count && !channels.tx_count)
> > -		err_attr = tb[ETHTOOL_A_CHANNELS_TX_COUNT];
> > +		err_attr = mod_combined ? tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT] :
> > +					  tb[ETHTOOL_A_CHANNELS_TX_COUNT];
> >  	else
> >  		err_attr = NULL;
> >  	if (err_attr) {
> > -		if (mod_combined)
> > -			err_attr = tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT];
> >  		ret = -EINVAL;
> >  		NL_SET_ERR_MSG_ATTR(info->extack, err_attr, "requested channel counts would result in no RX or TX channel being configured");
> >  		goto out_ops;
> 
> In case driver decides to adjust max counts - I'd lean towards:

I missed this note while reading the e-mail for the first time so I
thouoght this was just a cleanup. You are right, this would address both
issues.

Michal

> 
> diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
> index 5635604cb9ba..73d267415819 100644
> --- a/net/ethtool/channels.c
> +++ b/net/ethtool/channels.c
> @@ -116,10 +116,10 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
>         struct ethtool_channels channels = {};
>         struct ethnl_req_info req_info = {};
>         struct nlattr **tb = info->attrs;
> -       const struct nlattr *err_attr;
>         const struct ethtool_ops *ops;
>         struct net_device *dev;
>         u32 max_rx_in_use = 0;
> +       u32 err_attr;
>         int ret;
>  
>         ret = ethnl_parse_header_dev_get(&req_info,
> @@ -157,34 +157,34 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
>  
>         /* ensure new channel counts are within limits */
>         if (channels.rx_count > channels.max_rx)
> -               err_attr = tb[ETHTOOL_A_CHANNELS_RX_COUNT];
> +               err_attr = ETHTOOL_A_CHANNELS_RX_COUNT;
>         else if (channels.tx_count > channels.max_tx)
> -               err_attr = tb[ETHTOOL_A_CHANNELS_TX_COUNT];
> +               err_attr = ETHTOOL_A_CHANNELS_TX_COUNT;
>         else if (channels.other_count > channels.max_other)
> -               err_attr = tb[ETHTOOL_A_CHANNELS_OTHER_COUNT];
> +               err_attr = ETHTOOL_A_CHANNELS_OTHER_COUNT;
>         else if (channels.combined_count > channels.max_combined)
> -               err_attr = tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT];
> +               err_attr = ETHTOOL_A_CHANNELS_COMBINED_COUNT;
>         else
> -               err_attr = NULL;
> +               err_attr = 0;
>         if (err_attr) {
>                 ret = -EINVAL;
> -               NL_SET_ERR_MSG_ATTR(info->extack, err_attr,
> +               NL_SET_ERR_MSG_ATTR(info->extack, tb[err_attr],
>                                     "requested channel count exceeds maximum");
>                 goto out_ops;
>         }
>  
>         /* ensure there is at least one RX and one TX channel */
>         if (!channels.combined_count && !channels.rx_count)
> -               err_attr = tb[ETHTOOL_A_CHANNELS_RX_COUNT];
> +               err_attr = ETHTOOL_A_CHANNELS_RX_COUNT;
>         else if (!channels.combined_count && !channels.tx_count)
> -               err_attr = tb[ETHTOOL_A_CHANNELS_TX_COUNT];
> +               err_attr = ETHTOOL_A_CHANNELS_TX_COUNT;
>         else
> -               err_attr = NULL;
> +               err_attr = 0;
>         if (err_attr) {
>                 if (mod_combined)
> -                       err_attr = tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT];
> +                       err_attr = ETHTOOL_A_CHANNELS_COMBINED_COUNT;
>                 ret = -EINVAL;
> -               NL_SET_ERR_MSG_ATTR(info->extack, err_attr, "requested channel counts would result in no RX or TX channel being configured");
> +               NL_SET_ERR_MSG_ATTR(info->extack, tb[err_attr], "requested channel counts would result in no RX or TX channel being configured");
>                 goto out_ops;
>         }
>  
