Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F238326FC3
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 01:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhB1Aqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 19:46:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33238 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230063AbhB1Aqn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Feb 2021 19:46:43 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lGADY-008o06-HA; Sun, 28 Feb 2021 01:45:52 +0100
Date:   Sun, 28 Feb 2021 01:45:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Subject: Re: [RFC PATCH net-next 1/5] ethtool: Allow network drivers to dump
 arbitrary EEPROM data
Message-ID: <YDrnwFyvCFT8owgd@lunn.ch>
References: <1614181274-28482-1-git-send-email-moshe@nvidia.com>
 <1614181274-28482-2-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1614181274-28482-2-git-send-email-moshe@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 05:41:10PM +0200, Moshe Shemesh wrote:
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
>  include/linux/ethtool.h              |   5 +
>  include/uapi/linux/ethtool.h         |  25 +++++
>  include/uapi/linux/ethtool_netlink.h |  19 ++++
>  net/ethtool/Makefile                 |   2 +-
>  net/ethtool/eeprom.c                 | 149 +++++++++++++++++++++++++++
>  net/ethtool/netlink.c                |  10 ++
>  net/ethtool/netlink.h                |   2 +
>  7 files changed, 211 insertions(+), 1 deletion(-)
>  create mode 100644 net/ethtool/eeprom.c
> 
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index ec4cd3921c67..6032313fa914 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -410,6 +410,9 @@ struct ethtool_pause_stats {
>   * @get_ethtool_phy_stats: Return extended statistics about the PHY device.
>   *	This is only useful if the device maintains PHY statistics and
>   *	cannot use the standard PHY library helpers.
> + * @get_module_eeprom_data_by_page: Get a region of plug-in module EEPROM data
> + *	from specified page. Updates length to the amount actually read.
> + *	Returns a negative error code or zero.
>   *
>   * All operations are optional (i.e. the function pointer may be set
>   * to %NULL) and callers must take this into account.  Callers must
> @@ -515,6 +518,8 @@ struct ethtool_ops {
>  				   const struct ethtool_tunable *, void *);
>  	int	(*set_phy_tunable)(struct net_device *,
>  				   const struct ethtool_tunable *, const void *);
> +	int	(*get_module_eeprom_data_by_page)(struct net_device *dev,
> +						  struct ethtool_eeprom_data *page);

Hi Moshe, Vladyslav

I think it would be good to pass an extack here, so we can report more
useful errors.

> +/**
> + * struct ethtool_eeprom_data - EEPROM dump from specified page
> + * @offset: Offset within the specified EEPROM page to begin read, in bytes.
> + * @length: Number of bytes to read. On successful return, number of bytes
> + *	actually read.
> + * @page: Page number to read from.
> + * @bank: Page bank number to read from, if applicable by EEPROM spec.
> + * @i2c_address: I2C address of a page. Zero indicates a driver should choose
> + *	by itself.

I don't particularly like the idea of the driver deciding what to
read. User space should really be passing 0x50 or 0x51 for the normal
case. And we need to make it clear what these addresses mean, since
they are often referred to as 0xA0 and 0xA2, due to addresses being
shifted one bit left and a r/w bit added.

I also don't think the in place length should be modified. It would be
better to follow the use semantics of returning a negative value on
error, or a positive value for the length actually
read. ethtool_eeprom_data can then be passed as a const.

> + * @data: Pointer to buffer with EEPROM data of @length size.
> + *
> + * This can be used to manage pages during EEPROM dump in ethtool and pass
> + * required information to the driver.
> + */
> +struct ethtool_eeprom_data {
> +	__u32	offset;
> +	__u32	length;
> +	__u32	page;
> +	__u32	bank;
> +	__u32	i2c_address;
> +	__u8	*data;
> +};
> +
>  /**
>   * struct ethtool_eee - Energy Efficient Ethernet information
>   * @cmd: ETHTOOL_{G,S}EEE
> @@ -1865,6 +1888,8 @@ static inline int ethtool_validate_duplex(__u8 duplex)
>  #define ETH_MODULE_SFF_8636_MAX_LEN     640
>  #define ETH_MODULE_SFF_8436_MAX_LEN     640
>  
> +#define ETH_MODULE_EEPROM_MAX_LEN	640

I'm surprised such a high value is allowed. 128 seems more
appropriate, given the size of 1/2 pages.

> +
>  /* Reset flags */
>  /* The reset() operation must clear the flags for the components which
>   * were actually reset.  On successful return, the flags indicate the
> diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
> index a286635ac9b8..60dd848d0b54 100644
> --- a/include/uapi/linux/ethtool_netlink.h
> +++ b/include/uapi/linux/ethtool_netlink.h
> @@ -42,6 +42,7 @@ enum {
>  	ETHTOOL_MSG_CABLE_TEST_ACT,
>  	ETHTOOL_MSG_CABLE_TEST_TDR_ACT,
>  	ETHTOOL_MSG_TUNNEL_INFO_GET,
> +	ETHTOOL_MSG_EEPROM_DATA_GET,
>  
>  	/* add new constants above here */
>  	__ETHTOOL_MSG_USER_CNT,
> @@ -80,6 +81,7 @@ enum {
>  	ETHTOOL_MSG_CABLE_TEST_NTF,
>  	ETHTOOL_MSG_CABLE_TEST_TDR_NTF,
>  	ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY,
> +	ETHTOOL_MSG_EEPROM_DATA_GET_REPLY,
>  
>  	/* add new constants above here */
>  	__ETHTOOL_MSG_KERNEL_CNT,
> @@ -629,6 +631,23 @@ enum {
>  	ETHTOOL_A_TUNNEL_INFO_MAX = (__ETHTOOL_A_TUNNEL_INFO_CNT - 1)
>  };
>  
> +/* MODULE EEPROM DATA */
> +
> +enum {
> +	ETHTOOL_A_EEPROM_DATA_UNSPEC,
> +	ETHTOOL_A_EEPROM_DATA_HEADER,
> +
> +	ETHTOOL_A_EEPROM_DATA_OFFSET,
> +	ETHTOOL_A_EEPROM_DATA_LENGTH,
> +	ETHTOOL_A_EEPROM_DATA_PAGE,
> +	ETHTOOL_A_EEPROM_DATA_BANK,
> +	ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS,
> +	ETHTOOL_A_EEPROM_DATA,
> +
> +	__ETHTOOL_A_EEPROM_DATA_CNT,
> +	ETHTOOL_A_EEPROM_DATA_MAX = (__ETHTOOL_A_EEPROM_DATA_CNT - 1)
> +};
> +
>  /* generic netlink info */
>  #define ETHTOOL_GENL_NAME "ethtool"
>  #define ETHTOOL_GENL_VERSION 1
> diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
> index 7a849ff22dad..d604346bc074 100644
> --- a/net/ethtool/Makefile
> +++ b/net/ethtool/Makefile
> @@ -7,4 +7,4 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
>  ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
>  		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
>  		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
> -		   tunnels.o
> +		   tunnels.o eeprom.o
> diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
> new file mode 100644
> index 000000000000..51a2ed81a273
> --- /dev/null
> +++ b/net/ethtool/eeprom.c
> @@ -0,0 +1,149 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <linux/ethtool.h>
> +#include "netlink.h"
> +#include "common.h"
> +
> +struct eeprom_data_req_info {
> +	struct ethnl_req_info	base;
> +	u32			offset;
> +	u32			length;
> +	u32			page;
> +	u32			bank;
> +	u32			i2c_address;
> +};
> +
> +struct eeprom_data_reply_data {
> +	struct ethnl_reply_data base;
> +	u32			length;
> +	u32			i2c_address;
> +	u8			*data;
> +};
> +
> +#define EEPROM_DATA_REQINFO(__req_base) \
> +	container_of(__req_base, struct eeprom_data_req_info, base)
> +
> +#define EEPROM_DATA_REPDATA(__reply_base) \
> +	container_of(__reply_base, struct eeprom_data_reply_data, base)
> +
> +static int eeprom_data_prepare_data(const struct ethnl_req_info *req_base,
> +				    struct ethnl_reply_data *reply_base,
> +				    struct genl_info *info)
> +{
> +	struct eeprom_data_reply_data *reply = EEPROM_DATA_REPDATA(reply_base);
> +	struct eeprom_data_req_info *request = EEPROM_DATA_REQINFO(req_base);
> +	struct ethtool_eeprom_data page_data = {0};
> +	struct net_device *dev = reply_base->dev;
> +	int err;
> +
> +	if (!dev->ethtool_ops->get_module_eeprom_data_by_page)
> +		return -EOPNOTSUPP;
> +	err = ethnl_ops_begin(dev);
> +	if (err)
> +		return err;
> +
> +	page_data.offset = request->offset;
> +	page_data.length = request->length;
> +	page_data.i2c_address = request->i2c_address;
> +	page_data.page = request->page;
> +	page_data.bank = request->bank;
> +	page_data.data = kmalloc(page_data.length, GFP_KERNEL);
> +	if (!page_data.data)
> +		return -ENOMEM;

Isn't an ethnl_ops_complete(dev); needed here? Maybe postpone the
ethnl_ops_begin(dev) call until after the memory allocation?

> +
> +	err = dev->ethtool_ops->get_module_eeprom_data_by_page(dev, &page_data);
> +	if (err)
> +		goto err_out;
> +
> +	reply->length = page_data.length;
> +	reply->i2c_address = page_data.i2c_address;
> +	reply->data = page_data.data;
> +
> +	ethnl_ops_complete(dev);
> +	return 0;
> +
> +err_out:
> +	kfree(page_data.data);
> +	ethnl_ops_complete(dev);
> +	return err;
> +}
> +
> +static int eeprom_data_parse_request(struct ethnl_req_info *req_info, struct nlattr **tb,
> +				     struct netlink_ext_ack *extack)
> +{
> +	struct eeprom_data_req_info *request = EEPROM_DATA_REQINFO(req_info);
> +
> +	if (!tb[ETHTOOL_A_EEPROM_DATA_OFFSET] ||
> +	    !tb[ETHTOOL_A_EEPROM_DATA_LENGTH] ||
> +	    !tb[ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS])
> +		return -EINVAL;
> +
> +	request->length = nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_LENGTH]);
> +	if (request->length > ETH_MODULE_EEPROM_MAX_LEN)
> +		return -EINVAL;
> +
> +	request->offset = nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_OFFSET]);

I think you need to validate that offset + length is not passed the
end of a 1/2 page. There seems to be odd wrap around semantics, so we
probably want to avoid that.


> +	request->i2c_address = nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS]);

Maybe validate the i2c address. Most busses are limited to 7 bit
addresses, but some do allow 10 bits. I think we can probably ignore
10 bit addresses for this use case, so check that address is < 128.

   Andrew
