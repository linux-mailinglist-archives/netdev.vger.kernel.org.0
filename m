Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913E1349942
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 19:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhCYSNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 14:13:37 -0400
Received: from p3plsmtpa12-08.prod.phx3.secureserver.net ([68.178.252.237]:53166
        "EHLO p3plsmtpa12-08.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229833AbhCYSNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 14:13:35 -0400
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id PUU9lLyN6GlIUPUUAlAXLe; Thu, 25 Mar 2021 11:13:34 -0700
X-CMAE-Analysis: v=2.4 cv=cd0XElPM c=1 sm=1 tr=0 ts=605cd2ce
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=Ikd4Dj_1AAAA:8 a=vTjQQ9nbuII55B4aMBAA:9
 a=yyXAShrWtU0GOba7:21 a=Y5bY_9OocLU_SHxF:21 a=CjuIK1q_8ugA:10
 a=fCgQI5UlmZDRPDxm0A3o:22
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
References: <1616684215-4701-1-git-send-email-moshe@nvidia.com> <1616684215-4701-6-git-send-email-moshe@nvidia.com>
In-Reply-To: <1616684215-4701-6-git-send-email-moshe@nvidia.com>
Subject: RE: [RFC PATCH V5 net-next 5/5] ethtool: Add fallback to get_module_eeprom from netlink command
Date:   Thu, 25 Mar 2021 11:13:33 -0700
Message-ID: <00b801d721a2$91b73300$b5259900$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQFdLvpPbcUsX3qySThLff0M89UzmQFWyC3mq34t1WA=
Content-Language: en-us
X-CMAE-Envelope: MS4xfAzqflFkQdj+7z7J/YzXuXfDTAD7AEW+RyIBmjqSf74Wr6yT0SIFW8sg6lX2vgmOZBBw509+K/i8Ru/KGZgXiyUJWp0VsdwN1rl6u99Xexo9Lx+B7Dcx
 VPrV/sx5184vcEuMZQJAtvarQK9LBOVs/OqNPuWSpb16Ft/l+CCPdOJQqkbEkIa/WqRF7TCKXaTGbN7wCDfBJ3pbEBppHdz9f0oRDwxumzYbgkPOawdVOHOO
 88rBbUQr+pdN3H9/97oVc8SStb5GPDfmREp6El/1UvfDNSFBZsDOSXOY2FOhDw0S4a+qcDdH3rJyydlJaiVirMMoBHayDkB3BkYXSxmiHoiYiKYl+pm7L+/1
 79IijIct7dtMr9BCPjT4WNbs1iX8nqYPsBAvxSsvC9AhDlS/1cRcVmOopWJ0/J8Q+FmJIcDl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
> 
> In case netlink get_module_eeprom_by_page() callback is not implemented
> by the driver, try to call old get_module_info() and get_module_eeprom()
> pair. Recalculate parameters to get_module_eeprom() offset and len using
> page number and their sizes. Return error if this can't be done.
> 
> Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
> ---
>  net/ethtool/eeprom.c | 66
> +++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 65 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c index
> 10d5f6b34f2f..9f773b778bbe 100644
> --- a/net/ethtool/eeprom.c
> +++ b/net/ethtool/eeprom.c
> @@ -25,6 +25,70 @@ struct eeprom_reply_data {  #define
> MODULE_EEPROM_REPDATA(__reply_base) \
>  	container_of(__reply_base, struct eeprom_reply_data, base)
> 
> +static int fallback_set_params(struct eeprom_req_info *request,
> +			       struct ethtool_modinfo *modinfo,
> +			       struct ethtool_eeprom *eeprom) {
> +	u32 offset = request->offset;
> +	u32 length = request->length;
> +
> +	if (request->page)
> +		offset = request->page *
> ETH_MODULE_EEPROM_PAGE_LEN + offset;

The test 'if (request->page)' is not necessary, the math works with page 0
as well.  Keep it if you like the style.

> +
> +	if (modinfo->type == ETH_MODULE_SFF_8079 &&
> +	    request->i2c_address == 0x51)
> +		offset += ETH_MODULE_EEPROM_PAGE_LEN;

offset += ETH_MODULE_EEPROM_PAGE_LEN * 2;

Now that PAGE_LEN is 128, you need two of them to account for both low
memory and high memory at 0x50.

> +
> +	if (offset >= modinfo->eeprom_len)
> +		return -EINVAL;
> +
> +	eeprom->cmd = ETHTOOL_GMODULEEEPROM;
> +	eeprom->len = length;
> +	eeprom->offset = offset;
> +
> +	return 0;
> +}
> +
> +static int eeprom_fallback(struct eeprom_req_info *request,
> +			   struct eeprom_reply_data *reply,
> +			   struct genl_info *info)
> +{
> +	struct net_device *dev = reply->base.dev;
> +	struct ethtool_modinfo modinfo = {0};
> +	struct ethtool_eeprom eeprom = {0};
> +	u8 *data;
> +	int err;
> +
> +	if (!dev->ethtool_ops->get_module_info ||
> +	    !dev->ethtool_ops->get_module_eeprom || request->bank) {
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
>  static int eeprom_prepare_data(const struct ethnl_req_info *req_base,
>  			       struct ethnl_reply_data *reply_base,
>  			       struct genl_info *info)
> @@ -36,7 +100,7 @@ static int eeprom_prepare_data(const struct
> ethnl_req_info *req_base,
>  	int ret;
> 
>  	if (!dev->ethtool_ops->get_module_eeprom_by_page)
> -		return -EOPNOTSUPP;
> +		return eeprom_fallback(request, reply, info);
> 
>  	page_data.offset = request->offset;
>  	page_data.length = request->length;
> --
> 2.18.2

