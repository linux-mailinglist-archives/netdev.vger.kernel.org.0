Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C266202502
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 18:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgFTQAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 12:00:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50238 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgFTQAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Jun 2020 12:00:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jmfv4-001PZO-NR; Sat, 20 Jun 2020 18:00:38 +0200
Date:   Sat, 20 Jun 2020 18:00:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo bin <luobin9@huawei.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, luoxianjun@huawei.com,
        yin.yinshi@huawei.com, cloud.wangxiaoyun@huawei.com
Subject: Re: [PATCH net-next v1 5/5] hinic: add support to get eeprom
 information
Message-ID: <20200620160038.GQ304147@lunn.ch>
References: <20200620094258.13181-1-luobin9@huawei.com>
 <20200620094258.13181-6-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200620094258.13181-6-luobin9@huawei.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int hinic_get_module_eeprom(struct net_device *netdev,
> +				   struct ethtool_eeprom *ee, u8 *data)
> +{
> +	struct hinic_dev *nic_dev = netdev_priv(netdev);
> +	u8 sfp_data[STD_SFP_INFO_MAX_SIZE];

sfp_data will contain whatever is on the stack.

> +	u16 len;
> +	int err;
> +
> +	if (!ee->len || ((ee->len + ee->offset) > STD_SFP_INFO_MAX_SIZE))
> +		return -EINVAL;
> +
> +	memset(data, 0, ee->len);

This clears what you are going to return.

> +
> +	err = hinic_get_sfp_eeprom(nic_dev->hwdev, sfp_data, &len);

Upto len bytes of sfp_data now contain useful data. The rest of
sfp_data is still stack data.


> +	if (err)
> +		return err;
> +
> +	memcpy(data, sfp_data + ee->offset, ee->len);

If len < ee->len, you have just returned to user space some stack data.

   Andrew
