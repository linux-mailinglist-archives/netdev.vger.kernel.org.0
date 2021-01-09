Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E682F03FD
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 23:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbhAIWF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 17:05:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:40806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbhAIWF6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 17:05:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7272E23B00;
        Sat,  9 Jan 2021 22:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610229917;
        bh=vWkgu2vHUEdVBU64RaCJjJRVyp2YHBfwHiEYj86Qxmg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N0XVoM1ST5UakfWgWS/NBN07++n8rcsvoyRKDjXvk0w+iySvbAg/Top6n+LI+I0Dd
         c/KPr1Ge6gzj9yYjx0wk9dTUJ44QmE/W3onMtX1O0beuPoxA9j5LgVXDA+DTYyPKkK
         slqYSJHiHHRLSYqR2B3taOYvknI3oLGDV6aIUTREmqx0awPsoQLRKVNx7DvlwBajqT
         yxKDKF7nowgnqCYvrJ4TWD0BfHDpxyMIAWckPZvIzgM4uk/cBxzxRLimMVjCzYwamC
         gg8kU74sqawW2WG1MrZpfgK1RQBz6BofR6Zc9n3jjpLqnTQZqP8gH9lAIw427aJq5A
         Qr92+pYBjfPsg==
Date:   Sat, 9 Jan 2021 14:05:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v7 net-next 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <20210109140516.2899aac4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <X/ccfY+9a8R6wcJX@lunn.ch>
References: <20210107125613.19046-1-o.rempel@pengutronix.de>
        <20210107125613.19046-3-o.rempel@pengutronix.de>
        <X/ccfY+9a8R6wcJX@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jan 2021 15:36:45 +0100 Andrew Lunn wrote:
> > +static void ar9331_get_stats64(struct dsa_switch *ds, int port,
> > +			       struct rtnl_link_stats64 *s)
> > +{
> > +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> > +	struct ar9331_sw_port *p = &priv->port[port];
> > +
> > +	spin_lock(&p->stats_lock);
> > +	memcpy(s, &p->stats, sizeof(*s));
> > +	spin_unlock(&p->stats_lock);
> > +}  
> 
> This should probably wait until Vladimir's changes for stat64 are
> merged, so this call can sleep. You can then return up to date
> statistics.

Plus rx_nohandler is still updated from HW stats here :|

+	stats->rx_nohandler += raw.filtered;
