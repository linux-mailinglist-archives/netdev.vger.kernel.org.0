Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389BD2A1256
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 02:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgJaBQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 21:16:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgJaBQc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 21:16:32 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EAF3207DE;
        Sat, 31 Oct 2020 01:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604106992;
        bh=jPhvz6sDtZw43rKUdScv4T/17xaM5vPNHsQCmncvDyw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t5rIi5Pl94lQ5NNzRwJBlnBPgCiv0CwWpOrchNKBTB6/RrMqXTOUPjCOv7fwq2hQj
         Ox/22xvvKDUu4OTLpSczL83q9eK+QEbbfZDVi2QK/6Q8CIGuhz6MyrYZw7nTlvBxFZ
         C2g/Ls3VIRpgahcGbyk93z3ittpMEG/QZ/H4v3Gs=
Date:   Fri, 30 Oct 2020 18:16:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] net: mscc: ocelot: make entry_type a
 member of struct ocelot_multicast
Message-ID: <20201030181631.20692b43@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201029022738.722794-5-vladimir.oltean@nxp.com>
References: <20201029022738.722794-1-vladimir.oltean@nxp.com>
        <20201029022738.722794-5-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 04:27:37 +0200 Vladimir Oltean wrote:
> +		mc = devm_kzalloc(ocelot->dev, sizeof(*mc), GFP_KERNEL);
> +		if (!mc)
> +			return -ENOMEM;
> +
> +		mc->entry_type = ocelot_classify_mdb(mdb->addr);
> +		ether_addr_copy(mc->addr, mdb->addr);
> +		mc->vid = vid;
> +
> +		pgid = ocelot_mdb_get_pgid(ocelot, mc);
>  
>  		if (pgid < 0) {
>  			dev_err(ocelot->dev,
> @@ -1038,24 +1044,19 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
>  			return -ENOSPC;
>  		}

Transitionally leaking mc here on pgid < 0
