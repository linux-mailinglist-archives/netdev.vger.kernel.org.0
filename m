Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DCC290B11
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 20:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390875AbgJPSDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 14:03:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390696AbgJPSDO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 14:03:14 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B3FE20829;
        Fri, 16 Oct 2020 18:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602871393;
        bh=cn9qiIDC7xx1z5X6OBF+/z4VWTz+u/m77dXrjWGJv9A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JzNJgByay3zUnVlfnPv3zTuKqlmZw2GFLDyiogUwGrsGybB0BEMxRprFd+QlCGSxD
         huklRduW18G+3A5njBaJeCYtyHRojwIgE2c0swZV52Pw+qVSEn/pNvlLXyhKMsLbsp
         8yJPUTSzGNwtsLGcgTTajBaXjXPeCmgO+FcZKVXw=
Date:   Fri, 16 Oct 2020 11:03:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: ksz: fix padding size of skb
Message-ID: <20201016110311.6a43e10d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201016155645.kmlehweenqdue6q2@skbuf>
References: <20201014161719.30289-1-ceggers@arri.de>
        <4467366.g9nP7YU7d8@n95hx1g2>
        <20201016090527.tbzmjkraok5k7pwb@skbuf>
        <1655621.YBUmbkoM4d@n95hx1g2>
        <20201016155645.kmlehweenqdue6q2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Oct 2020 18:56:45 +0300 Vladimir Oltean wrote:
> > 3. "Manually" unsharing in dsa_slave_xmit(), reserving enough tailroom
> > for the tail tag (and ETH_ZLEN?). Would moving the "else" clause from
> > ksz_common_xmit()  to dsa_slave_xmit() do the job correctly?  
> 
> I was thinking about something like that, indeed. DSA knows everything
> about the tagger: its overhead, whether it's a tail tag or not. The xmit
> callback of the tagger should only be there to populate the tag where it
> needs to be. But reallocation, padding, etc etc, should all be dealt
> with by the common DSA xmit procedure. We want the taggers to be simple
> and reuse as much logic as possible, not to be bloated.

FWIW if you want to avoid the reallocs you may want to set
needed_tailroom on the netdev.
