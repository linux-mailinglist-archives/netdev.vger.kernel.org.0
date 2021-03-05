Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD1532DEB4
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 01:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhCEA5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 19:57:52 -0500
Received: from p3plsmtpa12-09.prod.phx3.secureserver.net ([68.178.252.238]:59408
        "EHLO p3plsmtpa12-09.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230416AbhCEA5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 19:57:49 -0500
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id Hyffl7hKIHr94HyfilIBxn; Thu, 04 Mar 2021 17:50:27 -0700
X-CMAE-Analysis: v=2.4 cv=DvqTREz+ c=1 sm=1 tr=0 ts=60418053
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=Ikd4Dj_1AAAA:8 a=dw-guJqK09mEijrvh9IA:9
 a=9T37Jm6LrWyWfwu6:21 a=nOSnXnN94GO9EL1N:21 a=CjuIK1q_8ugA:10
X-SECURESERVER-ACCT: don@thebollingers.org
From:   "Don Bollinger" <don@thebollingers.org>
To:     "'Moshe Shemesh'" <moshe@nvidia.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Andrew Lunn'" <andrew@lunn.ch>,
        "'Adrian Pop'" <pop.adrian61@gmail.com>,
        "'Michal Kubecek'" <mkubecek@suse.cz>, <netdev@vger.kernel.org>
Cc:     "'Vladyslav Tarasiuk'" <vladyslavt@nvidia.com>,
        <don@thebollingers.org>
References: <1614884228-8542-1-git-send-email-moshe@nvidia.com> <1614884228-8542-6-git-send-email-moshe@nvidia.com>
In-Reply-To: <1614884228-8542-6-git-send-email-moshe@nvidia.com>
Subject: RE: [RFC PATCH V2 net-next 5/5] ethtool: Add fallback to get_module_eeprom from netlink command
Date:   Thu, 4 Mar 2021 16:50:25 -0800
Message-ID: <001201d71159$88013120$98039360$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQFnKUugUW+R+aqYgGARCVs1/gX+XwI42Hg3q0KP8rA=
Content-Language: en-us
X-CMAE-Envelope: MS4xfIDEVzQ8mIcleF2qlw17BkSrrUCDn+Im8AIIYk+NneZC0slrR0j/0TCAoXkAg1kF2O08MhikJL3k1ZN+ux2m8Z7Jxr0AfPQB77c41qtXRtEAQhiMkNdO
 UtO09+qGRwE7cIE8D1cYdMcjtyTt/ZR3dKe2lYff7YcHK61/oAkqJ1WvJ2Y0tmc+jIFVmoit810E9XG5N7llqQssTaecryS6CQMtkt665SISPGYnIl8J75qJ
 g7AlgQPgnRW701n3njppqCq1cctzjcPvvQvpPFSbdWJLtqXjkkMHEcCpJJIBIpQwmO+//5HPP4GQJCXW78dG5T8vcXuosvgK3htMXS6kftCjSoV+I7qWl1al
 R1SYcMsTNxZgo9mnf8HaKUt8sJx/SVilSZTz8xOa3eY/48UeRNQhloVGV7FZQ0tdcGnzOTJ+
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 04, 2021 at 10:57AM-0800, Moshe Shemesh wrote:
> From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
> 
> In case netlink get_module_eeprom_data_by_page() callback is not
> implemented by the driver, try to call old get_module_info() and
> get_module_eeprom() pair. Recalculate parameters to
> get_module_eeprom() offset and len using page number and their sizes.
> Return error if this can't be done.
> 
> Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
> ---
>  net/ethtool/eeprom.c | 84
> +++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 83 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c index
> 2618a55b9a40..72c7714a9d37 100644
> --- a/net/ethtool/eeprom.c
> +++ b/net/ethtool/eeprom.c
> @@ -26,6 +26,88 @@ struct eeprom_data_reply_data {  #define
> EEPROM_DATA_REPDATA(__reply_base) \
>  	container_of(__reply_base, struct eeprom_data_reply_data, base)
> 
> +static int fallback_set_params(struct eeprom_data_req_info *request,
> +			       struct ethtool_modinfo *modinfo,
> +			       struct ethtool_eeprom *eeprom) {

This is translating the new data structure into the old.  Hence, I assume we
have i2c_addr, page, bank, offset, len to work with, and we should use
all of them.  We shouldn't be applying the legacy data structure's rules
to how we interpret the *request data.  Therefore...

> +	u32 offset = request->offset;
> +	u32 length = request->length;
> +
> +	if (request->page)
> +		offset = 128 + request->page * 128 + offset;

This is tricky to map to old behavior.  The new data structure should give
lower 
memory for offsets less than 128, and paged upper memory for offsets of 128
and higher.  There is no way to describe that request as {offset, length} in
the
old ethtool format with a fake linear memory.

        if (request->page) {
                if (offset < 128) && (offset + length > 128)
                       return -EINVAL;
                if (offset > 127) offset = request->page * 128 + offset;

> +
> +	if (!length)
> +		length = modinfo->eeprom_len;
> +
> +	if (offset >= modinfo->eeprom_len)
> +		return -EINVAL;
> +
> +	if (modinfo->eeprom_len < offset + length)
> +		length = modinfo->eeprom_len - offset;
> +
> +	eeprom->cmd = ETHTOOL_GMODULEEEPROM;
> +	eeprom->len = length;
> +	eeprom->offset = offset;
> +
> +	switch (modinfo->type) {
> +	case ETH_MODULE_SFF_8079:
> +		if (request->page > 1)
> +			return -EINVAL;
> +		break;
> +	case ETH_MODULE_SFF_8472:
> +		if (request->page > 3)

Not sure this is needed, there can be pages higher than 3.

> +			return -EINVAL;

I *think* the linear memory on SFP puts 0x50 in the first
256 bytes, 0x51 after that, including pages after that.  So,
the old fashioned linear memory offset needs to be adjusted
for accesses to 0x51.  Thus add:

        if (request->i2c_address == 0x51)
                offset += 256;

> +		break;
> +	case ETH_MODULE_SFF_8436:
> +	case ETH_MODULE_SFF_8636:

Not sure this is needed, there can be pages higher than 3.

> +		if (request->page > 3)
> +			return -EINVAL;
> +		break;
> +	}
> +	return 0;
> +}
> +
> +static int eeprom_data_fallback(struct eeprom_data_req_info *request,
> +				struct eeprom_data_reply_data *reply,
> +				struct genl_info *info)
> +{
> +	struct net_device *dev = reply->base.dev;
> +	struct ethtool_modinfo modinfo = {0};
> +	struct ethtool_eeprom eeprom = {0};
> +	u8 *data;
> +	int err;
> +
> +	if ((!dev->ethtool_ops->get_module_info &&
> +	     !dev->ethtool_ops->get_module_eeprom) ||
> +	    request->bank || request->i2c_address) {

We don't need to reject if there is an i2c_address.  Indeed, we need that
to determine the correct offset for the legacy linear memory offset.

Note my comment on an earlier patch in this series, I would have rejected
any request that didn't have either 0x50 or 0x51 here.

> +		return -EOPNOTSUPP;
> +	}
> +	modinfo.cmd = ETHTOOL_GMODULEINFO;
> +	err = dev->ethtool_ops->get_module_info(dev, &modinfo);
> +	if (err < 0)
> +		return err;
> +
> +	err = fallback_set_params(request, &modinfo, &eeprom);
> +	if (err < 0)
> +		return err;
> +
> +	data = kmalloc(eeprom.len, GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +	err = dev->ethtool_ops->get_module_eeprom(dev, &eeprom,
> data);
> +	if (err < 0)
> +		goto err_out;
> +
> +	reply->data = data;
> +	reply->length = eeprom.len;
> +
> +	return 0;
> +
> +err_out:
> +	kfree(data);
> +	return err;
> +}
> +
>  static int eeprom_data_prepare_data(const struct ethnl_req_info
> *req_base,
>  				    struct ethnl_reply_data *reply_base,
>  				    struct genl_info *info)
> @@ -37,7 +119,7 @@ static int eeprom_data_prepare_data(const struct
> ethnl_req_info *req_base,
>  	int err;
> 
>  	if (!dev->ethtool_ops->get_module_eeprom_data_by_page)
> -		return -EOPNOTSUPP;
> +		return eeprom_data_fallback(request, reply, info);
> 
>  	page_data.offset = request->offset;
>  	page_data.length = request->length;
> --
> 2.18.2


