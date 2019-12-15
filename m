Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2E211FB8C
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 22:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfLOVo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 16:44:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44088 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfLOVo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 16:44:57 -0500
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 651E515103188;
        Sun, 15 Dec 2019 13:44:55 -0800 (PST)
Date:   Sun, 15 Dec 2019 13:44:52 -0800 (PST)
Message-Id: <20191215.134452.1354053731963113491.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     sd@queasysnail.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        camelia.groza@nxp.com, Simon.Edelhaus@aquantia.com,
        Igor.Russkikh@aquantia.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next v3 06/15] net: macsec: add nla support for
 changing the offloading selection
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191213154844.635389-7-antoine.tenart@bootlin.com>
References: <20191213154844.635389-1-antoine.tenart@bootlin.com>
        <20191213154844.635389-7-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Dec 2019 13:44:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Fri, 13 Dec 2019 16:48:35 +0100

> +static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
> +{

This function is over the top and in fact confusing.

Really, if you want to make semantics sane, you have to require that no
rules are installed when enabling offloading.  The required sequence of
events if "enable offloading, add initial rules".

> +	/* Check the physical interface isn't offloading another interface
> +	 * first.
> +	 */
> +	for_each_net(loop_net) {
> +		for_each_netdev(loop_net, loop_dev) {
> +			struct macsec_dev *priv;
> +
> +			if (!netif_is_macsec(loop_dev))
> +				continue;
> +
> +			priv = macsec_priv(loop_dev);
> +
> +			if (!macsec_check_offload(MACSEC_OFFLOAD_PHY, priv))
> +				continue;
> +
> +			if (priv->offload != MACSEC_OFFLOAD_OFF)
> +				return -EBUSY;
> +		}
> +	}

You are rejecting the enabling of offloading on one interface if any
interface in the entire system is doing macsec offload?  That doesn't
make any sense at all.

Really, just require that a macsec interface is "clean" (no rules installed
yet) in order to enable offloading.

Then you don't have to check anything else at all.
