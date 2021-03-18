Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679D8340640
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 14:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhCRND0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 09:03:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34440 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231220AbhCRNDK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 09:03:10 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lMsIo-00Bffy-Ns; Thu, 18 Mar 2021 14:03:02 +0100
Date:   Thu, 18 Mar 2021 14:03:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, netdev@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Subject: Re: [RFC PATCH V3 net-next 1/5] ethtool: Allow network drivers to
 dump arbitrary EEPROM data
Message-ID: <YFNPhvelhxg4+5Cl@lunn.ch>
References: <1615828363-464-1-git-send-email-moshe@nvidia.com>
 <1615828363-464-2-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615828363-464-2-git-send-email-moshe@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 07:12:39PM +0200, Moshe Shemesh wrote:
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
> ---
>  Documentation/networking/ethtool-netlink.rst |  34 ++++-
>  include/linux/ethtool.h                      |   8 +-
>  include/uapi/linux/ethtool.h                 |  25 +++
>  include/uapi/linux/ethtool_netlink.h         |  19 +++
>  net/ethtool/Makefile                         |   2 +-
>  net/ethtool/eeprom.c                         | 153 +++++++++++++++++++
>  net/ethtool/netlink.c                        |  10 ++
>  net/ethtool/netlink.h                        |   2 +
>  8 files changed, 249 insertions(+), 4 deletions(-)
>  create mode 100644 net/ethtool/eeprom.c
> 
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> index 05073482db05..25846b97632a 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -1280,6 +1280,36 @@ Kernel response contents:
>  For UDP tunnel table empty ``ETHTOOL_A_TUNNEL_UDP_TABLE_TYPES`` indicates that
>  the table contains static entries, hard-coded by the NIC.
>  
> +EEPROM_DATA
> +===========
> +
> +Fetch module EEPROM data dump.
> +
> +Request contents:
> +
> +  =====================================  ======  ==========================
> +  ``ETHTOOL_A_EEPROM_DATA_HEADER``       nested  request header
> +  ``ETHTOOL_A_EEPROM_DATA_OFFSET``       u32     offset within a page
> +  ``ETHTOOL_A_EEPROM_DATA_LENGTH``       u32     amount of bytes to read

I wonder if offset and length should be u8. At most, we should only be
returning a 1/2 page, so 128 bytes. We don't need a u32.

>  Request translation
>  ===================
>  
> @@ -1357,8 +1387,8 @@ are netlink only.
>    ``ETHTOOL_GET_DUMP_FLAG``           n/a
>    ``ETHTOOL_GET_DUMP_DATA``           n/a
>    ``ETHTOOL_GET_TS_INFO``             ``ETHTOOL_MSG_TSINFO_GET``
> -  ``ETHTOOL_GMODULEINFO``             n/a
> -  ``ETHTOOL_GMODULEEEPROM``           n/a
> +  ``ETHTOOL_GMODULEINFO``             ``ETHTOOL_MSG_MODULE_EEPROM_GET``
> +  ``ETHTOOL_GMODULEEEPROM``           ``ETHTOOL_MSG_MODULE_EEPROM_GET``
>    ``ETHTOOL_GEEE``                    ``ETHTOOL_MSG_EEE_GET``
>    ``ETHTOOL_SEEE``                    ``ETHTOOL_MSG_EEE_SET``
>    ``ETHTOOL_GRSSH``                   n/a

We should check with Michal about this. It is not a direct replacement
of the old IOCTL API, it is new API. He may want it documented
differently.

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

> +
> +	request->offset = nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_OFFSET]);
> +	request->length = nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_LENGTH]);
> +	if (tb[ETHTOOL_A_EEPROM_DATA_PAGE] &&
> +	    dev->ethtool_ops->get_module_eeprom_data_by_page &&
> +	    request->offset + request->length > ETH_MODULE_EEPROM_PAGE_LEN)
> +		return -EINVAL;

You need to watch out for overflows here. 0xfffffff0 + 0x20 is less
than ETH_MODULE_EEPROM_PAGE_LEN when it wraps around, but will cause
bad things to happen.

      Andrew
