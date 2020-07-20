Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1D1226FD1
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 22:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgGTUoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 16:44:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45778 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbgGTUoE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 16:44:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jxcdd-0064ln-Jf; Mon, 20 Jul 2020 22:43:53 +0200
Date:   Mon, 20 Jul 2020 22:43:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Helmut Grohne <helmut.grohne@intenta.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>
Subject: Re: [PATCH v3] net: dsa: microchip: call phy_remove_link_mode during
 probe
Message-ID: <20200720204353.GO1339445@lunn.ch>
References: <20200717131814.GA1336433@lunn.ch>
 <20200720090416.GA7307@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720090416.GA7307@laureti-dev>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ignoring the part about how to cleanup this internal phydev for the
moment.

>  int ksz9477_switch_register(struct ksz_device *dev)
>  {
> -	return ksz_switch_register(dev, &ksz9477_dev_ops);
> +	int ret, i;
> +	struct phy_device *phydev;
> +
> +	ret = ksz_switch_register(dev, &ksz9477_dev_ops);
> +	if (ret)
> +		return ret;
> +
> +	for (i = 0; i < dev->phy_port_cnt; ++i) {
> +		phydev = dsa_to_port(dev->ds, i)->slave->phydev;

There is no guarantee this phydev actually exists, as far as i
remember. It will only be allocated for user ports. If a port is not
used, i.e. not listed in DT, it won't have a phydev. So you should add
a test:

		if (!dsa_is_user(ds, i))
			continue;

Otherwise, this now seems correct.

Andrew
