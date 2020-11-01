Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2392A1B8E
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 02:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgKABAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 21:00:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbgKABAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 21:00:44 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28FDE208B6;
        Sun,  1 Nov 2020 01:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604192444;
        bh=/vigM5OY2RdXFQm6DiIwxM0xPxD8tFTs26ZhF1RHByE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T9atm9M62RDkHeptvNu5WwfHHzaJ0L/51Cy3tR+5c1K7t4hZxa5U/wNxq9shBbFS3
         yrLf3M1BnqWl7KLg5QwMBvRyJBVF60DQs7RlicgnGtOMqrynBmRqWPH7afZiF7NjFk
         vx2Phnavg0/YVmW7f5e2e01zp8PpYAeltxlhwKHU=
Date:   Sat, 31 Oct 2020 18:00:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH v2 net-next 01/12] net: dsa: implement a central TX
 reallocation procedure
Message-ID: <20201031180043.2f6bed15@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201030014910.2738809-2-vladimir.oltean@nxp.com>
References: <20201030014910.2738809-1-vladimir.oltean@nxp.com>
        <20201030014910.2738809-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 03:48:59 +0200 Vladimir Oltean wrote:
> @@ -567,6 +591,17 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
>  	 */
>  	dsa_skb_tx_timestamp(p, skb);
>  
> +	if (dsa_realloc_skb(skb, dev)) {
> +		kfree_skb(skb);

dev_kfree_skb_any()?

> +		return NETDEV_TX_OK;
> +	}
