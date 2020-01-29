Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAFEA14C86E
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 10:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgA2J54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 04:57:56 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:3295 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgA2J54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 04:57:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1580291876; x=1611827876;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Wk33sfqt8xsqO8WUuL3pyKcuwK41HS7mLw4fgImokUE=;
  b=m5DqfAQPWygGG7DR31voPyc4+Dlr+Kudoc/rg1qPp1aFOqiuRY//x2KH
   fMHkYTCbqasEj+S7e+CVe4YABVuLY9k5LDtApUJOHidq+octUkJOzcP8S
   yTUNUf2rYAQhdEpqbiZbMKlkFF9NU5a3Pf4ClGa3BU9/BtLEWOnPzvec0
   g=;
IronPort-SDR: 2TcLbyI1CLMSuhx4btQcJCUVxKm0w13PT9aISdeK8c97OGv6hAT6dU79CPRCF/JIy/ryrBwcX8
 9OH1VyRx5Ujg==
X-IronPort-AV: E=Sophos;i="5.70,377,1574121600"; 
   d="scan'208";a="23125299"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 29 Jan 2020 09:57:37 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id 221DAA2148;
        Wed, 29 Jan 2020 09:57:35 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Wed, 29 Jan 2020 09:57:34 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.160.29) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 Jan 2020 09:57:25 +0000
Subject: Re: [RFC PATCH 1/4] net/core: Introduce master_xmit_slave_get
To:     Maor Gottlieb <maorg@mellanox.com>
CC:     <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <andy@greyhouse.net>,
        <jiri@mellanox.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <saeedm@mellanox.com>,
        <jgg@mellanox.com>, <leonro@mellanox.com>, <alexr@mellanox.com>,
        <markz@mellanox.com>, <parav@mellanox.com>, <eranbe@mellanox.com>,
        <linux-rdma@vger.kernel.org>
References: <20200126132126.9981-1-maorg@mellanox.com>
 <20200126132126.9981-2-maorg@mellanox.com>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <f27d00e8-e6b5-51a2-fd70-5ed3e5f97610@amazon.com>
Date:   Wed, 29 Jan 2020 11:57:19 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200126132126.9981-2-maorg@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.160.29]
X-ClientProxiedBy: EX13D05UWC002.ant.amazon.com (10.43.162.92) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2020 15:21, Maor Gottlieb wrote:
> Add new ndo to get the xmit slave of master device.
> When slave selection method is based on hash, then the user can ask to
> get the xmit slave assume all the slaves can transmit by setting the
> LAG_FLAGS_HASH_ALL_SLAVES bit in the flags argument.
> 
> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> ---
>  include/linux/netdevice.h |  3 +++
>  include/net/lag.h         | 19 +++++++++++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 11bdf6cb30bd..faba4aa094e5 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1379,6 +1379,9 @@ struct net_device_ops {
>  						 struct netlink_ext_ack *extack);
>  	int			(*ndo_del_slave)(struct net_device *dev,
>  						 struct net_device *slave_dev);
> +	struct net_device*	(*ndo_xmit_slave_get)(struct net_device *master_dev,
> +						      struct sk_buff *skb,
> +						      int lag);

Hey Maor,
Should lag be named flags?
Also, better to use unsigned type for it.
