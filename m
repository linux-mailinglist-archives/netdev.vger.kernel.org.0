Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 115B11CC2D3
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 18:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgEIQlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 12:41:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51068 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727787AbgEIQlH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 12:41:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qRZFxm98xcJRvO64DSisyocKOV6HSzfyqCIPHblFuS4=; b=wJx4RanDMmx5XSYWGaMUqCx8sj
        NEdUJLLxcqKsCCYIaaijrXuWQDEcC+nGDCGcK6FxDduqi7JnpqGbqWxpXuz8IOczUclAUCPh7TtEK
        PzTbdkNYUHE9ytaEExRUqh7okbkC2R8z5zeMb7GJIybSFDjpjxyheatsglABvO3ZBCJM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXSXB-001WQM-Aj; Sat, 09 May 2020 18:41:05 +0200
Date:   Sat, 9 May 2020 18:41:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de
Subject: Re: [PATCH v3 3/5] net: tag: ksz: Add KSZ8863 tag code
Message-ID: <20200509164105.GA362499@lunn.ch>
References: <20200508154343.6074-1-m.grzeschik@pengutronix.de>
 <20200508154343.6074-4-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508154343.6074-4-m.grzeschik@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* For ingress (Host -> KSZ8863), 1 byte is added before FCS.
> + * ---------------------------------------------------------------------------
> + * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|tag1(1byte)|FCS(4bytes)
> + * ---------------------------------------------------------------------------
> + * tag0[1,0] : represents port
> + *             (e.g. 0b00=addr-lookup 0b01=port1, 0b10=port2, 0b11=port1+port2)
> + * tag0[3,2] : bits two and three represent prioritization
> + *             (e.g. 0b00xx=prio0, 0b01xx=prio1, 0b10xx=prio2, 0b11xx=prio3)
> + *
> + * For egress (KSZ8873 -> Host), 1 byte is added before FCS.
> + * ---------------------------------------------------------------------------
> + * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|FCS(4bytes)
> + * ---------------------------------------------------------------------------
> + * tag0[0]   : zero-based value represents port
> + *             (eg, 0b0=port1, 0b1=port2)
> + */
> +
> +static struct sk_buff *ksz8863_xmit(struct sk_buff *skb,
> +				    struct net_device *dev)
> +{
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	struct sk_buff *nskb;
> +	__be16 *tag;

The comment says 1 byte is added. But tag is a u16?

    Andrew
