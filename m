Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A094EF6A23
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 17:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfKJQcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 11:32:35 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59090 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727016AbfKJQcf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 11:32:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cGe9ZZstmY+/NzXCzCs6ryWffLsR4LuQJUw/czL6qvY=; b=BFMhIr729u87UE4ns6UfiNvwU9
        +jjSSHqUwAgrspaPxvgJwuyyuvRF5lhB1D5PrsHZ1BJCrbGHap1ltayM/zxM+r3Nw8yiKBH2KM0zL
        phOIDbtHWU+RkaRsT8ceb9wmXyAw0u1/bVCPaZClyuP+OWzlcpOrbJuQ48kgoBVEdMFY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTq8b-0006sS-L1; Sun, 10 Nov 2019 17:32:29 +0100
Date:   Sun, 10 Nov 2019 17:32:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, horatiu.vultur@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 14/15] net: mscc: ocelot: split assignment of
 the cpu port into a separate function
Message-ID: <20191110163229.GE25889@lunn.ch>
References: <20191109130301.13716-1-olteanv@gmail.com>
 <20191109130301.13716-15-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191109130301.13716-15-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
> +			 enum ocelot_tag_prefix injection,
> +			 enum ocelot_tag_prefix extraction)
> +{
> +	/* Configure and enable the CPU port. */
> +	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, cpu);
> +	ocelot_write_rix(ocelot, BIT(cpu), ANA_PGID_PGID, PGID_CPU);
> +	ocelot_write_gix(ocelot, ANA_PORT_PORT_CFG_RECV_ENA |
> +			 ANA_PORT_PORT_CFG_PORTID_VAL(cpu),
> +			 ANA_PORT_PORT_CFG, cpu);
> +
> +	/* If the CPU port is a physical port, set up the port in Node
> +	 * Processor Interface (NPI) mode. This is the mode through which
> +	 * frames can be injected from and extracted to an external CPU.
> +	 * Only one port can be an NPI at the same time.
> +	 */
> +	if (cpu < ocelot->num_phys_ports) {
> +		ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPUQ_MSK_M |
> +			     QSYS_EXT_CPU_CFG_EXT_CPU_PORT(cpu),
> +			     QSYS_EXT_CPU_CFG);
> +	}

If a port is not a physical port, what is it? Is it actually an error
if the CPU port is not physical? Should we be returning -EINVAL here,
indicating the device tree is bad?

	   Andrew
