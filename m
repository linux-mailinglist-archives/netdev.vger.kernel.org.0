Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D03E1CD8A7
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 13:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbgEKLjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 07:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727873AbgEKLi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 07:38:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08414C061A0C;
        Mon, 11 May 2020 04:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xeljQMsnW7Lnk6+iGt4XV00n22AvM7OMoQv1bQ9vBwU=; b=LC54BPGkN+lmC592opzE3XNq2
        Kk4ZBZxCBDmkduYaIPpSn+6+LFRw9R97gVHqUlXEMpNbZbgbxmv4xhPyK8NeO7gK/texY64B2Qzke
        ST9e6puwhvKOioxE2TYKca7H4oJ/2/QcY2y3IyuQAO69UOm/dXKS6/qw8knreCxcW0kzwobC3L109
        yvv3EyF8eXe0evb3Omug/f+GjIcv8eLWQAlR2gDCDM/Xo84e4E7vePQ+q45Z5XVUDIvLfp+FZZCX/
        IfpKWaCHhjCtGdyNmBKqgwn9iaHosXrGo9laEeJ85fpSj5PgeQvZroov1aIdVdLSQFBmvLMF/DxZB
        0o0qU7HEw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:38872)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jY6ln-00064P-Fo; Mon, 11 May 2020 12:38:51 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jY6lm-0005dF-Fw; Mon, 11 May 2020 12:38:50 +0100
Date:   Mon, 11 May 2020 12:38:50 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 01/15] net: dsa: provide an option for drivers
 to always receive bridge VLANs
Message-ID: <20200511113850.GQ1551@shell.armlinux.org.uk>
References: <20200510164255.19322-1-olteanv@gmail.com>
 <20200510164255.19322-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200510164255.19322-2-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 10, 2020 at 07:42:41PM +0300, Vladimir Oltean wrote:
> From: Russell King <rmk+kernel@armlinux.org.uk>
> 
> DSA assumes that a bridge which has vlan filtering disabled is not
> vlan aware, and ignores all vlan configuration. However, the kernel
> software bridge code allows configuration in this state.
> 
> This causes the kernel's idea of the bridge vlan state and the
> hardware state to disagree, so "bridge vlan show" indicates a correct
> configuration but the hardware lacks all configuration. Even worse,
> enabling vlan filtering on a DSA bridge immediately blocks all traffic
> which, given the output of "bridge vlan show", is very confusing.
> 
> Provide an option that drivers can set to indicate they want to receive
> vlan configuration even when vlan filtering is disabled. At the very
> least, this is safe for Marvell DSA bridges, which do not look up
> ingress traffic in the VTU if the port is in 8021Q disabled state. It is
> also safe for the Ocelot switch family. Whether this change is suitable
> for all DSA bridges is not known.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

This patch was NAK'd because of objections to the "vlan_bridge_vtu"
name.  Unfortunately, this means that the bug for Marvell switches
remains unfixed to this day.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
