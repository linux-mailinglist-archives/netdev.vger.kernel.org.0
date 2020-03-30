Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7476198740
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 00:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729491AbgC3WSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 18:18:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728857AbgC3WSk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 18:18:40 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44710205ED;
        Mon, 30 Mar 2020 22:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585606719;
        bh=t8/80Rfw9o7jG+2EaJX+BbAcmZ0Cv28n/D2qsn9Rj+Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EyERsThVkeOm8B8I/N9QLlU8CnBSDP77K7Ayur6jvhghgSa75tFERrabXcAYUPuZE
         kbsUE4TOA5quz9ygUlgQTazwXfXhjfbGBtyD/MxW5/9oas9j+hF/fN64zt8UuxNQtF
         Ra60iJWUMb/XsCzu1zl6t6w+ku6HA5tyOCGA9oZc=
Date:   Mon, 30 Mar 2020 15:18:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     Jose.Abreu@synopsys.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        olteanv@gmail.com, ivan.khoronzhuk@linaro.org,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, po.liu@nxp.com, leoyang.li@nxp.com
Subject: Re: [net-next,v1] net: stmmac: support for tc mqprio offload
Message-ID: <20200330151837.0b5cf804@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200328011414.42401-1-xiaoliang.yang_1@nxp.com>
References: <20200328011414.42401-1-xiaoliang.yang_1@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 28 Mar 2020 09:14:14 +0800 Xiaoliang Yang wrote:
> This patch add support for tc mqprio offload to configure multiple
> prioritized TX traffic classes with mqprio.
> 
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

> +static int stmmac_tc_setup_mqprio(struct net_device *ndev, void *type_data)
> +{
> +	struct tc_mqprio_qopt *mqprio = type_data;
> +	u8 num_tc;
> +	int i;
> +
> +	num_tc = mqprio->num_tc;

num_tc will be set to 0 when root qdisc is change from mqprio to
something else, I don't see you handling this.

> +	netif_set_real_num_tx_queues(ndev, num_tc);
> +	netdev_set_num_tc(ndev, num_tc);
> +	for (i = 0; i < num_tc; i++)
> +		netdev_set_tc_queue(ndev, i, 1, i);

So you never configure any hardware?

> +	return 0;
> +}
> +
>  static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
>  			   void *type_data)
>  {
> @@ -4229,6 +4244,8 @@ static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
>  		return stmmac_tc_setup_cbs(priv, priv, type_data);
>  	case TC_SETUP_QDISC_TAPRIO:
>  		return stmmac_tc_setup_taprio(priv, priv, type_data);
> +	case TC_SETUP_QDISC_MQPRIO:
> +		return stmmac_tc_setup_mqprio(ndev, type_data);
>  	case TC_SETUP_QDISC_ETF:
>  		return stmmac_tc_setup_etf(priv, priv, type_data);
>  	default:

