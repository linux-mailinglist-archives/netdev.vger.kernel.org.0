Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E69C45D31F
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 03:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238158AbhKYCXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 21:23:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:43994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230237AbhKYCWK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 21:22:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6F4D601FF;
        Thu, 25 Nov 2021 02:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637806739;
        bh=LdCtg2YiQshucsy/JIQ93h0ULSoII7k3spAXIsReB0U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wh1FJwyVpu8rztsrdwcf6ZIXoBt5v3OzI3At+zsYXq4mzcKf8bNKOiG8Ma3aH5azG
         R18DbPr2sgWvdSreK1pEV787qNlf07jmmhXqHz/5kedoMugUHvS91+XLvXFsmRZypp
         OFOLHv7gYfVW6otcd3Cy+kf7WoBPdu0ZILOSPdOQaGigzWUvvT7Y8krMwMD8UT7QTy
         zoCSCZYq7YwbfrqFMWu6VAMHY07A0eWzqJHRcQ69U4vGHv3HSwAIER9CaC6DnyNNBA
         JI4eGuPzf/1SZR7oZcyQSdAU0l/ewzkH5xels6o8g6LggPpejB6q3OjyNbyVNbDB4t
         tKHnnbIRXBbvg==
Date:   Wed, 24 Nov 2021 18:18:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     xiangxia.m.yue@gmail.com
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/2] ifb: support ethtools driver info
Message-ID: <20211124181858.6c4668db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211125020155.6488-1-xiangxia.m.yue@gmail.com>
References: <20211125020155.6488-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Nov 2021 10:01:54 +0800 xiangxia.m.yue@gmail.com wrote:
> +#define DRV_NAME	"ifb"
> +#define DRV_VERSION	"1.0"

Let's not invent meaningless driver versions.

> +#define TX_Q_LIMIT	32
> +
>  struct ifb_q_private {
>  	struct net_device	*dev;
>  	struct tasklet_struct   ifb_tasklet;
> @@ -181,6 +185,12 @@ static int ifb_dev_init(struct net_device *dev)
>  	return 0;
>  }
>  
> +static void ifb_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
> +{
> +	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));

Can we make core fill in driver name from rtnl_link_ops so we don't
need to do it in each driver?

> +	strlcpy(info->version, DRV_VERSION, sizeof(info->version));

Leave this field as is, core should fill it with the kernel release.

> +}
