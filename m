Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF4631709DF
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 21:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbgBZUh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 15:37:28 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:29120 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727310AbgBZUh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 15:37:28 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1582749447; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=6mHMqlIKcalMT/67c9Lqk6BPlpnD96D7mWx48S9X+jQ=;
 b=et7g7oWDAduhG1HH6ULaDfpHzMMLaU6GeOyxV2kIkbuhL6mWcGmXRk5lC3ikpVXSleLcz8Pn
 oqWQNFlBhEGGCGFUfy+ez6AadH+ZfcW6bZI6EUnA5FLk6qPT2p+glilWpNS2M6XYbl/4O2oA
 K67S34TXXIcJt6fTXVcPpV/8aH4=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e56d6ff.7f0bead1b960-smtp-out-n01;
 Wed, 26 Feb 2020 20:37:19 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1EB78C4479C; Wed, 26 Feb 2020 20:37:18 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 71B66C43383;
        Wed, 26 Feb 2020 20:37:17 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 26 Feb 2020 13:37:17 -0700
From:   subashab@codeaurora.org
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, stranche@codeaurora.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 06/10] net: rmnet: print error message when command
 fails
In-Reply-To: <20200226174740.5636-1-ap420073@gmail.com>
References: <20200226174740.5636-1-ap420073@gmail.com>
Message-ID: <84eb4ca7add20145fc427c3183d67ef6@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-02-26 10:47, Taehee Yoo wrote:
> When rmnet netlink command fails, it doesn't print any error message.
> So, users couldn't know the exact reason.
> In order to tell the exact reason to the user, the extack error message
> is used in this patch.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>  .../ethernet/qualcomm/rmnet/rmnet_config.c    | 26 ++++++++++++-------
>  .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   | 10 +++----
>  .../net/ethernet/qualcomm/rmnet/rmnet_vnd.h   |  3 ++-
>  3 files changed, 24 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> index c8b1bfe127ac..93745cd45c29 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> @@ -141,11 +141,10 @@ static int rmnet_newlink(struct net *src_net,
> struct net_device *dev,
>  	}
> 
>  	real_dev = __dev_get_by_index(src_net, nla_get_u32(tb[IFLA_LINK]));
> -	if (!real_dev || !dev)
> +	if (!real_dev || !dev) {
> +		NL_SET_ERR_MSG_MOD(extack, "link does not exist");
>  		return -ENODEV;
> -
> -	if (!data[IFLA_RMNET_MUX_ID])
> -		return -EINVAL;
> +	}
> 
>  	ep = kzalloc(sizeof(*ep), GFP_ATOMIC);
>  	if (!ep)
> @@ -158,7 +157,7 @@ static int rmnet_newlink(struct net *src_net,
> struct net_device *dev,
>  		goto err0;
> 
>  	port = rmnet_get_port_rtnl(real_dev);
> -	err = rmnet_vnd_newlink(mux_id, dev, port, real_dev, ep);
> +	err = rmnet_vnd_newlink(mux_id, dev, port, real_dev, ep, extack);
>  	if (err)
>  		goto err1;
> 
> @@ -275,12 +274,16 @@ static int rmnet_rtnl_validate(struct nlattr
> *tb[], struct nlattr *data[],
>  {
>  	u16 mux_id;
> 
> -	if (!data || !data[IFLA_RMNET_MUX_ID])
> +	if (!data || !data[IFLA_RMNET_MUX_ID]) {
> +		NL_SET_ERR_MSG_MOD(extack, "MUX ID not specifies");
>  		return -EINVAL;
> +	}
> 
>  	mux_id = nla_get_u16(data[IFLA_RMNET_MUX_ID]);
> -	if (mux_id > (RMNET_MAX_LOGICAL_EP - 1))
> +	if (mux_id > (RMNET_MAX_LOGICAL_EP - 1)) {
> +		NL_SET_ERR_MSG_MOD(extack, "invalid MUX ID");
>  		return -ERANGE;
> +	}
> 
>  	return 0;
>  }
> @@ -414,11 +417,16 @@ int rmnet_add_bridge(struct net_device 
> *rmnet_dev,
>  	/* If there is more than one rmnet dev attached, its probably being
>  	 * used for muxing. Skip the briding in that case
>  	 */
> -	if (port->nr_rmnet_devs > 1)
> +	if (port->nr_rmnet_devs > 1) {
> +		NL_SET_ERR_MSG_MOD(extack, "more than one rmnet dev attached");
>  		return -EINVAL;
> +	}
> 
> -	if (rmnet_is_real_dev_registered(slave_dev))
> +	if (rmnet_is_real_dev_registered(slave_dev)) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "dev is already attached another rmnet dev");
>  		return -EBUSY;
> +	}
> 
>  	err = rmnet_register_real_device(slave_dev);
>  	if (err)
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> index a26e76e9d382..90c19033ebe0 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> @@ -224,16 +224,16 @@ void rmnet_vnd_setup(struct net_device 
> *rmnet_dev)
>  int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
>  		      struct rmnet_port *port,
>  		      struct net_device *real_dev,
> -		      struct rmnet_endpoint *ep)
> +		      struct rmnet_endpoint *ep,
> +		      struct netlink_ext_ack *extack)
>  {
>  	struct rmnet_priv *priv = netdev_priv(rmnet_dev);
>  	int rc;
> 
> -	if (ep->egress_dev)
> -		return -EINVAL;
> -
> -	if (rmnet_get_endpoint(port, id))
> +	if (rmnet_get_endpoint(port, id)) {
> +		NL_SET_ERR_MSG_MOD(extack, "MUX ID already exists");
>  		return -EBUSY;
> +	}
> 
>  	rmnet_dev->hw_features = NETIF_F_RXCSUM;
>  	rmnet_dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
> index 54cbaf3c3bc4..d8fa76e8e9c4 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
> @@ -11,7 +11,8 @@ int rmnet_vnd_do_flow_control(struct net_device
> *dev, int enable);
>  int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
>  		      struct rmnet_port *port,
>  		      struct net_device *real_dev,
> -		      struct rmnet_endpoint *ep);
> +		      struct rmnet_endpoint *ep,
> +		      struct netlink_ext_ack *extack);
>  int rmnet_vnd_dellink(u8 id, struct rmnet_port *port,
>  		      struct rmnet_endpoint *ep);
>  void rmnet_vnd_rx_fixup(struct sk_buff *skb, struct net_device *dev);

This patch and [PATCH net 02/10] "net: rmnet: add missing module alias" 
seem
to be adding new functionality. Perhaps it can be sent to net-next 
instead
of net.
