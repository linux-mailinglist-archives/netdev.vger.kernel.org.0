Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182BB2FD660
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 18:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391570AbhATRCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 12:02:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:57970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730067AbhATRBg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 12:01:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7438C233E2;
        Wed, 20 Jan 2021 17:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611162055;
        bh=6OUtqhWSO+0DZitUi2hZqE/CxaSo5m2rxUBWTvDjJgA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iNIrfR2TK21i6woG9gWlIsWyB/XFJjVrINhr4DN+OVOiryaEgoF5hdGBsplH+vkyE
         8D9N1ykKda3Aiu5ylrrz4NvHGlj1QlRwECK/P5Ls1vF4P8Ng/tFDCu467UiR8sUSHA
         sp+VNVcbtyFVbwfRUJME8QtX7FYCu/LO4asyKNyEU0vqQW58ZIiSc5XdeVziwb7kw7
         Uaiee2/JKVnPu1P6Qamdwr4egWY8umiTs1o3ovHAz2bcLfM5ZQV64L6SN2BfgrEjUk
         LdjKss75WrHyiCQq84cX4lNkCMLrd2ajrYHiVjDzxfB3S9f8SJ6TDrfiS4Er9v5sYy
         UCpgPDCW7E6aQ==
Date:   Wed, 20 Jan 2021 09:00:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "Bedel, Alban" <alban.bedel@aerq.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] net: mscc: ocelot: Fix multicast to the CPU port
Message-ID: <20210120090054.12d56482@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210119164601.dplx4js4wzhnmw6r@skbuf>
References: <20210119140638.203374-1-alban.bedel@aerq.com>
        <20210119164601.dplx4js4wzhnmw6r@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jan 2021 16:46:01 +0000 Vladimir Oltean wrote:
> On Tue, Jan 19, 2021 at 03:06:38PM +0100, Alban Bedel wrote:
> > Multicast entries in the MAC table use the high bits of the MAC
> > address to encode the ports that should get the packets. But this port
> > mask does not work for the CPU port, to receive these packets on the
> > CPU port the MAC_CPU_COPY flag must be set.
> > 
> > Because of this IPv6 was effectively not working because neighbor
> > solicitations were never received. This was not apparent before commit
> > 9403c158 (net: mscc: ocelot: support IPv4, IPv6 and plain Ethernet mdb
> > entries) as the IPv6 entries were broken so all incoming IPv6
> > multicast was then treated as unknown and flooded on all ports.
> > 
> > To fix this problem rework the ocelot_mact_learn() to set the
> > MAC_CPU_COPY flag when a multicast entry that target the CPU port is
> > added. For this we have to read back the ports endcoded in the pseudo
> > MAC address by the caller. It is not a very nice design but that avoid
> > changing the callers and should make backporting easier.
> > 
> > Signed-off-by: Alban Bedel <alban.bedel@aerq.com>
> > Fixes: 9403c158b872 ("net: mscc: ocelot: support IPv4, IPv6 and plain Ethernet mdb entries")
> > 
> > ---  
> 
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thanks!
