Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A2A431F06
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbhJROLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:11:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234341AbhJROK6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 10:10:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE8EC60F36;
        Mon, 18 Oct 2021 14:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634566127;
        bh=jKk8AWp8ZKOJpLEDn7JUIdKEKcmICORg1TNcNMafg50=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XdCKzx+JQzzPAp+Htc8JI9SGv6ZZRTz1GFmAjUj0nag3sadQOA0OnDJOcEOTNky5d
         UzMHCCwUEIGdfLKUkqsU4zplCEZYCdTDxmjqPupAnfR8KD7bBQQ6hyin5abKaINJKE
         z6mzatKpvf/FQHwoixru63poG+FsmEw2fcivw7iyB0UFrKJALxykzw/AHXsvfo/DOo
         +g45zcz6gGx4b1/lG9ifbW0NtJwfBS7l2n0kS6hQoAq3krTeIahrC5jIKMPNpDu+vP
         iRGdMUzc0hJHyVIY0QixrrwI2JflwasfLAVwLL2BT7WdDXJQ/NJOxh/ff72mfqbfc3
         u05O6p5fYgbbg==
Date:   Mon, 18 Oct 2021 07:08:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, andrew@lunn.ch,
        f.fainelli@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, bjarni.jonasson@microchip.com,
        linux-arm-kernel@lists.infradead.org, qiangqing.zhang@nxp.com,
        vkochan@marvell.com, tchornyi@marvell.com, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com
Subject: Re: [RFC net-next 1/6] ethernet: add a helper for assigning port
 addresses
Message-ID: <20211018070845.68ba815d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YWw76V/UfJm3yM2t@shredder>
References: <20211015193848.779420-1-kuba@kernel.org>
        <20211015193848.779420-2-kuba@kernel.org>
        <YWw76V/UfJm3yM2t@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 Oct 2021 18:06:17 +0300 Ido Schimmel wrote:
> On Fri, Oct 15, 2021 at 12:38:43PM -0700, Jakub Kicinski wrote:
> > +/**
> > + * eth_hw_addr_set_port - Generate and assign Ethernet address to a port
> > + * @dev: pointer to port's net_device structure
> > + * @base_addr: base Ethernet address
> > + * @id: offset to add to the base address
> > + *
> > + * Assign a MAC address to the net_device using a base address and an offset.
> > + * Commonly used by switch drivers which need to compute addresses for all
> > + * their ports. addr_assign_type is not changed.
> > + */
> > +static inline void eth_hw_addr_set_port(struct net_device *dev,
> > +					const u8 *base_addr, u8 id)  
> 
> If necessary, would it be possible to change 'id' to u16?

Let me make it an unsigned int, I had u8 initially because I wasn't
planning on doing the wrapping and wanted the compiler to warn.

> I'm asking because currently in mlxsw we set the MAC of each netdev to
> 'base_mac + local_port' where 'local_port' is u8. In Spectrum-4 we are
> going to have more than 256 logical ports, so 'local_port' becomes u16.
> 
> Regarding the naming, eth_hw_addr_gen() sounds good to me.

