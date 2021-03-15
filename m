Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B07133C96D
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 23:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbhCOWbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 18:31:31 -0400
Received: from p3plsmtpa09-07.prod.phx3.secureserver.net ([173.201.193.236]:52495
        "EHLO p3plsmtpa09-07.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232688AbhCOWbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 18:31:12 -0400
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id Lvjxlz8uaw0TsLvjzltJSQ; Mon, 15 Mar 2021 15:31:11 -0700
X-CMAE-Analysis: v=2.4 cv=RtQAkAqK c=1 sm=1 tr=0 ts=604fe02f
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=Ikd4Dj_1AAAA:8 a=YCkpI4NFU_8Z-YuR2TsA:9
 a=_UhxoBb6jBAwMo4S:21 a=OIW3Hany-UjfWFU8:21 a=CjuIK1q_8ugA:10
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
References: <1615828363-464-1-git-send-email-moshe@nvidia.com> <1615828363-464-6-git-send-email-moshe@nvidia.com>
In-Reply-To: <1615828363-464-6-git-send-email-moshe@nvidia.com>
Subject: RE: [RFC PATCH V3 net-next 5/5] ethtool: Add fallback to get_module_eeprom from netlink command
Date:   Mon, 15 Mar 2021 15:31:10 -0700
Message-ID: <002301d719ea$e6aae4c0$b400ae40$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQGz6jCTEjXEF5R9RRlUkJN6q0cH4gHV7Y+/qr1NVWA=
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
> In case netlink get_module_eeprom_data_by_page() callback is not
> implemented by the driver, try to call old get_module_info() and
> get_module_eeprom() pair. Recalculate parameters to
> get_module_eeprom() offset and len using page number and their sizes.
> Return error if this can't be done.
> 
> Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
> ---
>  net/ethtool/eeprom.c | 75
> +++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 74 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c index
> e110336dc231..33ba9ecc36cb 100644
> --- a/net/ethtool/eeprom.c
> +++ b/net/ethtool/eeprom.c
> @@ -25,6 +25,79 @@ struct eeprom_data_reply_data {  #define
> EEPROM_DATA_REPDATA(__reply_base) \
>  	container_of(__reply_base, struct eeprom_data_reply_data, base)
> 
> +static int fallback_set_params(struct eeprom_data_req_info *request,
> +			       struct ethtool_modinfo *modinfo,
> +			       struct ethtool_eeprom *eeprom) {
> +	u32 offset = request->offset;
> +	u32 length = request->length;
> +
> +	if (request->page) {
> +		if (offset < 128 || offset + length >
> ETH_MODULE_EEPROM_PAGE_LEN)
> +			return -EINVAL;
> +		offset = request->page * 128 + offset;
> +	}
> +
> +	if (modinfo->type == ETH_MODULE_SFF_8079 &&
> +	    request->i2c_address == 0x51)
> +		offset += ETH_MODULE_EEPROM_PAGE_LEN;
> +
> +	if (!length)
> +		length = modinfo->eeprom_len;

Need to move this check up 11 lines, before the 'if (request->page)...'
stanza.  You need to be doing that check against the final length.
Otherwise you could have a request that includes a page, and a length of 0,
which becomes a length of modinfo->eeprom_len.

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
> +	     !dev->ethtool_ops->get_module_eeprom) || request->bank) {
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
> @@ -36,7 +109,7 @@ static int eeprom_data_prepare_data(const struct
> ethnl_req_info *req_base,
>  	int ret;
> 
>  	if (!dev->ethtool_ops->get_module_eeprom_data_by_page)
> -		return -EOPNOTSUPP;
> +		return eeprom_data_fallback(request, reply, info);
> 
>  	page_data.offset = request->offset;
>  	page_data.length = request->length;
> --
> 2.26.2

