Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC163207EB9
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 23:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404448AbgFXVhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 17:37:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:51546 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403996AbgFXVhf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 17:37:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 40060AC91;
        Wed, 24 Jun 2020 21:37:33 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 4FB3060346; Wed, 24 Jun 2020 23:37:32 +0200 (CEST)
Date:   Wed, 24 Jun 2020 23:37:32 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        amitc@mellanox.com, mlxsw@mellanox.com, jacob.e.keller@intel.com,
        andrew@lunn.ch, f.fainelli@gmail.com, linux@rempel-privat.de,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 05/10] ethtool: Add link extended state
Message-ID: <20200624213732.ew55pyv2ah62opcp@lion.mk-sys.cz>
References: <20200624081923.89483-1-idosch@idosch.org>
 <20200624081923.89483-6-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624081923.89483-6-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 11:19:18AM +0300, Ido Schimmel wrote:
> From: Amit Cohen <amitc@mellanox.com>
> 
> Currently, drivers can only tell whether the link is up/down using
> LINKSTATE_GET, but no additional information is given.
> 
> Add attributes to LINKSTATE_GET command in order to allow drivers
> to expose the user more information in addition to link state to ease
> the debug process, for example, reason for link down state.
> 
> Extended state consists of two attributes - link_ext_state and link_ext_substate.

Please keep the commit message within 75 columns.

> The idea is to avoid 'vendor specific' states in order to prevent
> drivers to use specific link_ext_state that can be in the future common
> link_ext_state.
> 
> The substates allows drivers to add more information to the common
> link_ext_state. For example, vendor can expose 'Autoneg' as link_ext_state and add
> 'No partner detected during force mode' as link_ext_substate.
> 
> If a driver cannot pinpoint the extended state with the substate
> accuracy, it is free to expose only the extended state and omit the
> substate attribute.
> 
> Signed-off-by: Amit Cohen <amitc@mellanox.com>
> Reviewed-by: Petr Machata <petrm@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  include/linux/ethtool.h              | 22 +++++++++
>  include/uapi/linux/ethtool.h         | 70 ++++++++++++++++++++++++++++
>  include/uapi/linux/ethtool_netlink.h |  2 +
>  net/ethtool/linkstate.c              | 56 ++++++++++++++++++++--
>  4 files changed, 145 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index a23b26eab479..be2fd37ec84a 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -86,6 +86,22 @@ struct net_device;
>  u32 ethtool_op_get_link(struct net_device *dev);
>  int ethtool_op_get_ts_info(struct net_device *dev, struct ethtool_ts_info *eti);
>  
> +
> +/**
> + * struct ethtool_link_ext_state_info - link extended state and substate.
> + */
> +struct ethtool_link_ext_state_info {
> +	enum ethtool_link_ext_state link_ext_state;
> +	union {
> +		enum ethtool_link_ext_substate_autoneg autoneg;
> +		enum ethtool_link_ext_substate_link_training link_training;
> +		enum ethtool_link_ext_substate_link_logical_mismatch link_logical_mismatch;
> +		enum ethtool_link_ext_substate_bad_signal_integrity bad_signal_integrity;
> +		enum ethtool_link_ext_substate_cable_issue cable_issue;
> +		int __link_ext_substate;

Shouldn't __link_ext_substate rather be u8?

> +	};
> +};
> +
>  /**
>   * ethtool_rxfh_indir_default - get default value for RX flow hash indirection
>   * @index: Index in RX flow hash indirection table
[...]
> @@ -61,6 +65,25 @@ static int linkstate_get_sqi_max(struct net_device *dev)
>  	mutex_unlock(&phydev->lock);
>  
>  	return ret;
> +};
> +
> +static int linkstate_get_link_ext_state(struct net_device *dev,
> +					struct linkstate_reply_data *data)
> +{
> +	int err;
> +
> +	if (!dev->ethtool_ops->get_link_ext_state)
> +		return -EOPNOTSUPP;
> +
> +	err = dev->ethtool_ops->get_link_ext_state(dev, &data->ethtool_link_ext_state_info);
> +	if (err) {
> +		data->link_ext_state_provided = false;

This is not needed, request specific part of the structure is guaranteed
to be zero initialized.

> +		return err;
> +	}
> +
> +	data->link_ext_state_provided = true;
> +
> +	return 0;
>  }
>  
>  static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
> @@ -69,7 +92,7 @@ static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
>  {
>  	struct linkstate_reply_data *data = LINKSTATE_REPDATA(reply_base);
>  	struct net_device *dev = reply_base->dev;
> -	int ret;
> +	int ret, err;

It doesn't seem necessary to introduce a second variable for the same
purpose.

>  
>  	ret = ethnl_ops_begin(dev);
>  	if (ret < 0)
> @@ -88,6 +111,12 @@ static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
>  
>  	data->sqi_max = ret;
>  
> +	if (dev->flags & IFF_UP) {
> +		err = linkstate_get_link_ext_state(dev, data);
> +		if (err < 0 && err != -EOPNOTSUPP && err != -ENODATA)
> +			return err;

This return statement would bypass ethnl_ops_complete(). (We already
have the same problem with SQI related error handling as I just
noticed.) Also, the special meaning of -ENODATA should be probably
documented in ->get_link_ext_state() callback description.

Michal
