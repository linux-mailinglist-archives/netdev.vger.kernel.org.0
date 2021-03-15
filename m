Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F4933C96A
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 23:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbhCOWba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 18:31:30 -0400
Received: from p3plsmtpa09-07.prod.phx3.secureserver.net ([173.201.193.236]:52495
        "EHLO p3plsmtpa09-07.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232392AbhCOWbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 18:31:11 -0400
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id Lvjxlz8uaw0TsLvjyltJSH; Mon, 15 Mar 2021 15:31:10 -0700
X-CMAE-Analysis: v=2.4 cv=RtQAkAqK c=1 sm=1 tr=0 ts=604fe02f
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=Ikd4Dj_1AAAA:8 a=2l5kUA9s2FG2sXo7IcIA:9
 a=ajH6Zuw854trp7pu:21 a=MlefKlHTm3L0otJD:21 a=CjuIK1q_8ugA:10
X-SECURESERVER-ACCT: don@thebollingers.org
From:   "Don Bollinger" <don@thebollingers.org>
To:     "'Moshe Shemesh'" <moshe@nvidia.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Andrew Lunn'" <andrew@lunn.ch>,
        "'Adrian Pop'" <pop.adrian61@gmail.com>,
        "'Michal Kubecek'" <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
        <don@thebollingers.org>
Cc:     "'Vladyslav Tarasiuk'" <vladyslavt@nvidia.com>
References: <1615828363-464-1-git-send-email-moshe@nvidia.com> <1615828363-464-2-git-send-email-moshe@nvidia.com>
In-Reply-To: <1615828363-464-2-git-send-email-moshe@nvidia.com>
Subject: RE: [RFC PATCH V3 net-next 1/5] ethtool: Allow network drivers to dump arbitrary EEPROM data
Date:   Mon, 15 Mar 2021 15:31:08 -0700
Message-ID: <002201d719ea$e60d9350$b228b9f0$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQGz6jCTEjXEF5R9RRlUkJN6q0cH4gF9RYA5qsAMDgA=
Content-Language: en-us
X-CMAE-Envelope: MS4xfEQA1e6KRAcXCj7OGKjbJ/urJAOKpTRHmQEHnJVTCRoGamdoJznCUXhdghlbZy0HgBt/poM/GsTDpxUdcdzkkHiw4kygHksgZ6FLDPQX9gJHG8oCxU6J
 IxypL5r18tM6AmoWK3PYrBwjemxQhXKv4Brdv4PmVI2C9TK5n6AimEI6uhkV/mxcbVYbNxVf6S5oHYsRQAVdy+FBAyqWF7H/UVx8RPDwqfmx1DPBXySQLjNF
 gIN2hDgrt7Xm2hY8huOmECO85lKUv2fm1iT9DiSK41t3holHa1TMRMokCQZ9AlHiZspHFu7BZEv2hOJp6TpORgUNhAdJ5I/tnodJ5N4fWT3SvqT8dy05WVgB
 ycdJmWLKLXSgp6L2sh5IhAG7xlBXLZQ2hdjwDS+CCW7W9an0fYGRd59XVUg1Uq0gaACyE98x
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Mar 2021 10:12:39 +0700 Moshe Shemesh wrote:
> From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
> 
> Define get_module_eeprom_data_by_page() ethtool callback and
> implement netlink infrastructure.
> 
> get_module_eeprom_data_by_page() allows network drivers to dump a
> part of module's EEPROM specified by page and bank numbers along with
> offset and length. It is effectively a netlink replacement for
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
>  8 files changed, 249 insertions(+), 4 deletions(-)  create mode 100644
> net/ethtool/eeprom.c
> 
> diff --git a/Documentation/networking/ethtool-netlink.rst
> b/Documentation/networking/ethtool-netlink.rst
> index 05073482db05..25846b97632a 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -1280,6 +1280,36 @@ Kernel response contents:
>  For UDP tunnel table empty ``ETHTOOL_A_TUNNEL_UDP_TABLE_TYPES``
> indicates that  the table contains static entries, hard-coded by the NIC.
> 
> +EEPROM_DATA
> +===========
> +
> +Fetch module EEPROM data dump.
> +
> +Request contents:
> +
> +  =====================================  ======
> ==========================
> +  ``ETHTOOL_A_EEPROM_DATA_HEADER``       nested  request header
> +  ``ETHTOOL_A_EEPROM_DATA_OFFSET``       u32     offset within a page
> +  ``ETHTOOL_A_EEPROM_DATA_LENGTH``       u32     amount of bytes to read
> +  ``ETHTOOL_A_EEPROM_DATA_PAGE``         u8      page number
> +  ``ETHTOOL_A_EEPROM_DATA_BANK``         u8      bank number
> +  ``ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS``  u8      page I2C address
> +  =====================================  ======
> + ==========================
> +
> +Kernel response contents:
> +
> +
+---------------------------------------------+--------+--------------------
-+
> + | ``ETHTOOL_A_EEPROM_DATA_HEADER``            | nested | reply header
> |
> +
+---------------------------------------------+--------+--------------------
-+
> + | ``ETHTOOL_A_EEPROM_DATA_LENGTH``            | u32    | amount of bytes
> read|
> +
+---------------------------------------------+--------+--------------------
-+
> + | ``ETHTOOL_A_EEPROM_DATA``                   | nested | array of bytes
from |
> + |                                             |        | module EEPROM
|
> +
+---------------------------------------------+--------+--------------------
-+
> +
> +``ETHTOOL_A_EEPROM_DATA`` has an attribute length equal to the amount
> +of bytes driver actually read.
> +
>  Request translation
>  ===================
> 
> @@ -1357,8 +1387,8 @@ are netlink only.
>    ``ETHTOOL_GET_DUMP_FLAG``           n/a
>    ``ETHTOOL_GET_DUMP_DATA``           n/a
>    ``ETHTOOL_GET_TS_INFO``             ``ETHTOOL_MSG_TSINFO_GET``
> -  ``ETHTOOL_GMODULEINFO``             n/a
> -  ``ETHTOOL_GMODULEEEPROM``           n/a
> +  ``ETHTOOL_GMODULEINFO``
> ``ETHTOOL_MSG_MODULE_EEPROM_GET``
> +  ``ETHTOOL_GMODULEEEPROM``
> ``ETHTOOL_MSG_MODULE_EEPROM_GET``
>    ``ETHTOOL_GEEE``                    ``ETHTOOL_MSG_EEE_GET``
>    ``ETHTOOL_SEEE``                    ``ETHTOOL_MSG_EEE_SET``
>    ``ETHTOOL_GRSSH``                   n/a
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h index
> ec4cd3921c67..9551005b350a 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -81,6 +81,7 @@ enum {
>  #define ETH_RSS_HASH_NO_CHANGE	0
> 
>  struct net_device;
> +struct netlink_ext_ack;
> 
>  /* Some generic methods drivers may use in their ethtool_ops */
>  u32 ethtool_op_get_link(struct net_device *dev); @@ -410,6 +411,9 @@
> struct ethtool_pause_stats {
>   * @get_ethtool_phy_stats: Return extended statistics about the PHY
> device.
>   *	This is only useful if the device maintains PHY statistics and
>   *	cannot use the standard PHY library helpers.
> + * @get_module_eeprom_data_by_page: Get a region of plug-in module
> EEPROM data
> + *	from specified page. Returns a negative error code or the amount of
> + *	bytes read.
>   *
>   * All operations are optional (i.e. the function pointer may be set
>   * to %NULL) and callers must take this into account.  Callers must @@
-515,6
> +519,9 @@ struct ethtool_ops {
>  				   const struct ethtool_tunable *, void *);
>  	int	(*set_phy_tunable)(struct net_device *,
>  				   const struct ethtool_tunable *, const
void
> *);
> +	int	(*get_module_eeprom_data_by_page)(struct net_device
> *dev,
> +						  const struct
> ethtool_eeprom_data *page,
> +						  struct netlink_ext_ack
> *extack);
>  };
> 
>  int ethtool_check_ops(const struct ethtool_ops *ops); @@ -538,7 +545,6
> @@ int ethtool_virtdev_set_link_ksettings(struct net_device *dev,
>  				       const struct ethtool_link_ksettings
*cmd,
>  				       u32 *dev_speed, u8 *dev_duplex);
> 
> -struct netlink_ext_ack;
>  struct phy_device;
>  struct phy_tdr_config;
> 
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index
> cde753bb2093..b3e92db3ad37 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -340,6 +340,28 @@ struct ethtool_eeprom {
>  	__u8	data[0];
>  };
> 
> +/**
> + * struct ethtool_eeprom_data - EEPROM dump from specified page
> + * @offset: Offset within the specified EEPROM page to begin read, in
> bytes.
> + * @length: Number of bytes to read.
> + * @page: Page number to read from.
> + * @bank: Page bank number to read from, if applicable by EEPROM spec.
> + * @i2c_address: I2C address of a page. Value less than 0x7f expected.
> Most
> + *	EEPROMs use 0x50 or 0x51.
> + * @data: Pointer to buffer with EEPROM data of @length size.
> + *
> + * This can be used to manage pages during EEPROM dump in ethtool and
> +pass
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
>  /**
>   * struct ethtool_eee - Energy Efficient Ethernet information
>   * @cmd: ETHTOOL_{G,S}EEE
> @@ -1865,6 +1887,9 @@ static inline int ethtool_validate_duplex(__u8
> duplex)
>  #define ETH_MODULE_SFF_8636_MAX_LEN     640
>  #define ETH_MODULE_SFF_8436_MAX_LEN     640
> 
> +#define ETH_MODULE_EEPROM_PAGE_LEN	256
> +#define ETH_MODULE_MAX_I2C_ADDRESS	0x7f
> +
>  /* Reset flags */
>  /* The reset() operation must clear the flags for the components which
>   * were actually reset.  On successful return, the flags indicate the
diff --git
> a/include/uapi/linux/ethtool_netlink.h
> b/include/uapi/linux/ethtool_netlink.h
> index a286635ac9b8..e1b1b962f3da 100644
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
>  	ETHTOOL_A_TUNNEL_INFO_MAX =
> (__ETHTOOL_A_TUNNEL_INFO_CNT - 1)  };
> 
> +/* MODULE EEPROM DATA */
> +
> +enum {
> +	ETHTOOL_A_EEPROM_DATA_UNSPEC,
> +	ETHTOOL_A_EEPROM_DATA_HEADER,			/* nest -
> _A_HEADER_* */
> +
> +	ETHTOOL_A_EEPROM_DATA_OFFSET,			/* u32 */
> +	ETHTOOL_A_EEPROM_DATA_LENGTH,			/* u32 */
> +	ETHTOOL_A_EEPROM_DATA_PAGE,			/* u8 */
> +	ETHTOOL_A_EEPROM_DATA_BANK,			/* u8 */
> +	ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS,		/* u8 */
> +	ETHTOOL_A_EEPROM_DATA,				/* nested */
> +
> +	__ETHTOOL_A_EEPROM_DATA_CNT,
> +	ETHTOOL_A_EEPROM_DATA_MAX =
> (__ETHTOOL_A_EEPROM_DATA_CNT - 1) };
> +
>  /* generic netlink info */
>  #define ETHTOOL_GENL_NAME "ethtool"
>  #define ETHTOOL_GENL_VERSION 1
> diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile index
> 7a849ff22dad..d604346bc074 100644
> --- a/net/ethtool/Makefile
> +++ b/net/ethtool/Makefile
> @@ -7,4 +7,4 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
>  ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
>  		   linkstate.o debug.o wol.o features.o privflags.o rings.o
\
>  		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o
\
> -		   tunnels.o
> +		   tunnels.o eeprom.o
> diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c new file mode
> 100644 index 000000000000..e110336dc231
> --- /dev/null
> +++ b/net/ethtool/eeprom.c
> @@ -0,0 +1,153 @@
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
> +	u8			page;
> +	u8			bank;
> +	u8			i2c_address;
> +};
> +
> +struct eeprom_data_reply_data {
> +	struct ethnl_reply_data base;
> +	u32			length;
> +	u8			*data;
> +};
> +
> +#define EEPROM_DATA_REQINFO(__req_base) \
> +	container_of(__req_base, struct eeprom_data_req_info, base)
> +
> +#define EEPROM_DATA_REPDATA(__reply_base) \
> +	container_of(__reply_base, struct eeprom_data_reply_data, base)
> +
> +static int eeprom_data_prepare_data(const struct ethnl_req_info
> *req_base,
> +				    struct ethnl_reply_data *reply_base,
> +				    struct genl_info *info)
> +{
> +	struct eeprom_data_reply_data *reply =
> EEPROM_DATA_REPDATA(reply_base);
> +	struct eeprom_data_req_info *request =
> EEPROM_DATA_REQINFO(req_base);
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
> +	ret = ethnl_ops_begin(dev);
> +	if (ret)
> +		goto err_free;
> +
> +	ret = dev->ethtool_ops->get_module_eeprom_data_by_page(dev,
> &page_data,
> +
info->extack);
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
> +static int eeprom_data_parse_request(struct ethnl_req_info *req_info,
> struct nlattr **tb,
> +				     struct netlink_ext_ack *extack) {
> +	struct eeprom_data_req_info *request =
> EEPROM_DATA_REQINFO(req_info);
> +	struct net_device *dev = req_info->dev;
> +
> +	if (!tb[ETHTOOL_A_EEPROM_DATA_OFFSET] ||
> +	    !tb[ETHTOOL_A_EEPROM_DATA_LENGTH] ||
> +	    !tb[ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS])
> +		return -EINVAL;

Suggestion:  Consider using i2c address 0x50 as a default if none is given.
0x50 is the first 256 bytes of SFP, and all of QSFP and CMIS EEPROM.  If
there is a page given on an SFP device, then you know i2c address is 0x51.
The only thing that REQUIRES 0x51 is legacy offset 256-511 on SFP.  Keep the
i2c address, but make it optional for the non-standard devices that Andrew
has mentioned, and for that one section of SFP data that requires it.  And
document it for the user.

Note also, legacy does not have an i2c address, so passing this along allows
the fallback to legacy to cover more cases.  (Legacy ethtool addresses this
part of SFP as offset 256-511.)

> +
> +	request->i2c_address =
> nla_get_u8(tb[ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS]);
> +	if (request->i2c_address > ETH_MODULE_MAX_I2C_ADDRESS)
> +		return -EINVAL;
> +
> +	request->offset =
> nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_OFFSET]);
> +	request->length =
> nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_LENGTH]);
> +	if (tb[ETHTOOL_A_EEPROM_DATA_PAGE] &&
> +	    dev->ethtool_ops->get_module_eeprom_data_by_page &&
> +	    request->offset + request->length >
> ETH_MODULE_EEPROM_PAGE_LEN)
> +		return -EINVAL;

If a request exceeds the length of EEPROM (in legacy), we truncate it to
EEPROM length.  I suggest if a request exceeds the length of the page (in
the new KAPI), then we truncate at the end of the page.  Thus rather than
'return -EINVAL;' I suggest

          request->length = ETH_MODULE_EEPROM_PAGE_LEN - request->offset;

> +
> +	if (tb[ETHTOOL_A_EEPROM_DATA_PAGE])
> +		request->page =
> nla_get_u8(tb[ETHTOOL_A_EEPROM_DATA_PAGE]);
> +	if (tb[ETHTOOL_A_EEPROM_DATA_BANK])
> +		request->bank =
> nla_get_u8(tb[ETHTOOL_A_EEPROM_DATA_BANK]);
> +
> +	return 0;
> +}
> +
> +static int eeprom_data_reply_size(const struct ethnl_req_info *req_base,
> +				  const struct ethnl_reply_data *reply_base)
{
> +	const struct eeprom_data_req_info *request =
> +EEPROM_DATA_REQINFO(req_base);
> +
> +	return nla_total_size(sizeof(u32)) + /* _EEPROM_DATA_LENGTH */
> +	       nla_total_size(sizeof(u8) * request->length); /* _EEPROM_DATA
> +*/ }
> +
> +static int eeprom_data_fill_reply(struct sk_buff *skb,
> +				  const struct ethnl_req_info *req_base,
> +				  const struct ethnl_reply_data *reply_base)
{
> +	struct eeprom_data_reply_data *reply =
> +EEPROM_DATA_REPDATA(reply_base);
> +
> +	if (nla_put_u32(skb, ETHTOOL_A_EEPROM_DATA_LENGTH, reply-
> >length) ||
> +	    nla_put(skb, ETHTOOL_A_EEPROM_DATA, reply->length, reply-
> >data))
> +		return -EMSGSIZE;
> +
> +	return 0;
> +}
> +
> +static void eeprom_data_cleanup_data(struct ethnl_reply_data
> +*reply_base) {
> +	struct eeprom_data_reply_data *reply =
> +EEPROM_DATA_REPDATA(reply_base);
> +
> +	kfree(reply->data);
> +}
> +
> +const struct ethnl_request_ops ethnl_eeprom_data_request_ops = {
> +	.request_cmd		= ETHTOOL_MSG_EEPROM_DATA_GET,
> +	.reply_cmd		=
> ETHTOOL_MSG_EEPROM_DATA_GET_REPLY,
> +	.hdr_attr		= ETHTOOL_A_EEPROM_DATA_HEADER,
> +	.req_info_size		= sizeof(struct eeprom_data_req_info),
> +	.reply_data_size	= sizeof(struct eeprom_data_reply_data),
> +
> +	.parse_request		= eeprom_data_parse_request,
> +	.prepare_data		= eeprom_data_prepare_data,
> +	.reply_size		= eeprom_data_reply_size,
> +	.fill_reply		= eeprom_data_fill_reply,
> +	.cleanup_data		= eeprom_data_cleanup_data,
> +};
> +
> +const struct nla_policy ethnl_eeprom_data_get_policy[] = {
> +	[ETHTOOL_A_EEPROM_DATA_HEADER]		=
> NLA_POLICY_NESTED(ethnl_header_policy),
> +	[ETHTOOL_A_EEPROM_DATA_OFFSET]		= { .type =
> NLA_U32 },
> +	[ETHTOOL_A_EEPROM_DATA_LENGTH]		= { .type =
> NLA_U32 },
> +	[ETHTOOL_A_EEPROM_DATA_PAGE]		= { .type = NLA_U8 },
> +	[ETHTOOL_A_EEPROM_DATA_BANK]		= { .type = NLA_U8 },
> +	[ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS]	= { .type = NLA_U8 },
> +	[ETHTOOL_A_EEPROM_DATA]			= { .type =
> NLA_BINARY },
> +};
> +
> diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c index
> 50d3c8896f91..ff2528bee192 100644
> --- a/net/ethtool/netlink.c
> +++ b/net/ethtool/netlink.c
> @@ -245,6 +245,7 @@
> ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
>  	[ETHTOOL_MSG_PAUSE_GET]		=
> &ethnl_pause_request_ops,
>  	[ETHTOOL_MSG_EEE_GET]		= &ethnl_eee_request_ops,
>  	[ETHTOOL_MSG_TSINFO_GET]	= &ethnl_tsinfo_request_ops,
> +	[ETHTOOL_MSG_EEPROM_DATA_GET]	=
> &ethnl_eeprom_data_request_ops,
>  };
> 
>  static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback
> *cb) @@ -912,6 +913,15 @@ static const struct genl_ops ethtool_genl_ops[]
> = {
>  		.policy = ethnl_tunnel_info_get_policy,
>  		.maxattr = ARRAY_SIZE(ethnl_tunnel_info_get_policy) - 1,
>  	},
> +	{
> +		.cmd	= ETHTOOL_MSG_EEPROM_DATA_GET,
> +		.doit	= ethnl_default_doit,
> +		.start	= ethnl_default_start,
> +		.dumpit	= ethnl_default_dumpit,
> +		.done	= ethnl_default_done,
> +		.policy = ethnl_eeprom_data_get_policy,
> +		.maxattr = ARRAY_SIZE(ethnl_eeprom_data_get_policy) - 1,
> +	},
>  };
> 
>  static const struct genl_multicast_group ethtool_nl_mcgrps[] = { diff
--git
> a/net/ethtool/netlink.h b/net/ethtool/netlink.h index
> 6eabd58d81bf..60954c7b4dfe 100644
> --- a/net/ethtool/netlink.h
> +++ b/net/ethtool/netlink.h
> @@ -344,6 +344,7 @@ extern const struct ethnl_request_ops
> ethnl_coalesce_request_ops;  extern const struct ethnl_request_ops
> ethnl_pause_request_ops;  extern const struct ethnl_request_ops
> ethnl_eee_request_ops;  extern const struct ethnl_request_ops
> ethnl_tsinfo_request_ops;
> +extern const struct ethnl_request_ops ethnl_eeprom_data_request_ops;
> 
>  extern const struct nla_policy
> ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];  extern const struct
> nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1]; @@
> -375,6 +376,7 @@ extern const struct nla_policy
> ethnl_tsinfo_get_policy[ETHTOOL_A_TSINFO_HEADER +  extern const struct
> nla_policy ethnl_cable_test_act_policy[ETHTOOL_A_CABLE_TEST_HEADER +
> 1];  extern const struct nla_policy
> ethnl_cable_test_tdr_act_policy[ETHTOOL_A_CABLE_TEST_TDR_CFG + 1];
> extern const struct nla_policy
> ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INFO_HEADER + 1];
> +extern const struct nla_policy
> +ethnl_eeprom_data_get_policy[ETHTOOL_A_EEPROM_DATA + 1];
> 
>  int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);  int
> ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
> --
> 2.26.2

