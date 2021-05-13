Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1A337FFAE
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 23:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbhEMVPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 17:15:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39290 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233276AbhEMVPB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 17:15:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mGpK26Mb+uqhFf1LLz52H7ke22MaI/Hpa228UC+2GwM=; b=x1TTkXeXeBcyX6BmDqj3k4ExtK
        /CKVun7INmxbNFmAeQMgEIeQDQ7/HteZ55RHItx/GtLFktd2FyJyzZVtSrzASayuvLXPk7+bzRZj6
        f7jgE61U/+fS90NvtzBtgx3+SBQHy0NpgbOu799qMXDa6FlR02n32hsL/sW+uJwHJPy0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lhIeB-0046qA-4e; Thu, 13 May 2021 23:13:31 +0200
Date:   Thu, 13 May 2021 23:13:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Tong Zhang <ztong0001@gmail.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/2] can: c_can: add ethtool support
Message-ID: <YJ2We1T+34oj8Mm1@lunn.ch>
References: <20210513193638.11201-2-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513193638.11201-2-dariobin@libero.it>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 09:36:37PM +0200, Dario Binacchi wrote:
> With commit 132f2d45fb23 ("can: c_can: add support to 64 message objects")
> the number of message objects used for reception / transmission depends
> on FIFO size.
> The ethtools API support allows you to retrieve this info. Driver info
> has been added too.

Hi Dario

Nice to see the API being re-used for something other than Ethernet.

> +static void c_can_get_drvinfo(struct net_device *netdev,
> +			      struct ethtool_drvinfo *info)
> +{
> +	struct c_can_priv *priv = netdev_priv(netdev);
> +	struct platform_device	*pdev = to_platform_device(priv->device);
> +
> +	strscpy(info->driver, "c_can", sizeof(info->driver));
> +	strscpy(info->version, "1.0", sizeof(info->version));

version is pretty meaningless. This driver could be backported into
some enterprise kernel with a huge number of patches. Or more likely,
some in car infotainment kernel with a lot of vendor patches. Lots of
things around the driver change, but it still tells you version
1.0. So we don't recommend filling this in. The ethtool core will then
fill the version what kernel the driver is actually being used in:

https://elixir.bootlin.com/linux/latest/source/net/ethtool/ioctl.c#L706

	Andrew
