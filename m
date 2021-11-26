Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A1545F55E
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 20:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbhKZTsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 14:48:54 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38968 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234915AbhKZTqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 14:46:54 -0500
X-Greylist: delayed 1744 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Nov 2021 14:46:52 EST
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67BA662347;
        Fri, 26 Nov 2021 19:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611A8C9305B;
        Fri, 26 Nov 2021 19:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637955818;
        bh=wqmRAo8i92P8veePs7zCFdhg+DjdV21E5wPJEMkkAG8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bG2ZRu2Mjg5mf8flsf04XDHj/OTYCLzxObZnhwAlgbEH8Z3mdHQ7m6u+VGditY3Du
         aeqak3U5jBUWyfaIpwmhyP/fYmNOnO823e1m+hgM0xYjrgTc8XTA+89zqkCSqa1Fy5
         1XrNbomzyxZkAmzA9DT8qXPoDtB0ale4saxVwZ/N7CBUxiZGNmZWxnAMQYEwk1I9f0
         JNw1O9NVQgDk4Vf5c3/El3O/Xj51whWmL8pa1fMUke9yF+sexhp+/bWxjtZzDCkygv
         7BkYmZM9tlisfWZgEPojBbFs7qrOZVwWHC5wmwcwyseqgWs/FDj/uKn42uTrtxqYjc
         5/hRQpx3Gvz9Q==
Date:   Fri, 26 Nov 2021 11:43:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3 1/1] net: dsa: microchip: implement multi-bridge
 support
Message-ID: <20211126114336.05fd7ebd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211126123926.2981028-1-o.rempel@pengutronix.de>
References: <20211126123926.2981028-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Nov 2021 13:39:26 +0100 Oleksij Rempel wrote:
> Current driver version is able to handle only one bridge at time.
> Configuring two bridges on two different ports would end up shorting this
> bridges by HW. To reproduce it:
> 
> 	ip l a name br0 type bridge
> 	ip l a name br1 type bridge
> 	ip l s dev br0 up
> 	ip l s dev br1 up
> 	ip l s lan1 master br0
> 	ip l s dev lan1 up
> 	ip l s lan2 master br1
> 	ip l s dev lan2 up
> 
> 	Ping on lan1 and get response on lan2, which should not happen.
> 
> This happened, because current driver version is storing one global "Port VLAN
> Membership" and applying it to all ports which are members of any
> bridge.
> To solve this issue, we need to handle each port separately.
> 
> This patch is dropping the global port member storage and calculating
> membership dynamically depending on STP state and bridge participation.
> 
> Note: STP support was broken before this patch and should be fixed
> separately.
> 
> Fixes: c2e866911e25 ("net: dsa: microchip: break KSZ9477 DSA driver into two files")

Suspicious, this sounds like a code reshuffling commit. Where was the
bad code introduced? The fixes tag should point at the earliest point 
in the git history where the problem exists.
