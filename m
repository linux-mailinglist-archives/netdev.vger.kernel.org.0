Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628C22660CE
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 15:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgIKNyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 09:54:44 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2739 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgIKNVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 09:21:54 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5b79b00000>; Fri, 11 Sep 2020 06:20:48 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 11 Sep 2020 06:21:01 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 11 Sep 2020 06:21:01 -0700
Received: from localhost (10.124.1.5) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 11 Sep 2020 13:21:01
 +0000
Date:   Fri, 11 Sep 2020 16:20:58 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: VLAN filtering with DSA
Message-ID: <20200911132058.GA3154432@shredder>
References: <20200910150738.mwhh2i6j2qgacqev@skbuf>
 <a5e0a066-0193-beca-7773-5933d48696e8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a5e0a066-0193-beca-7773-5933d48696e8@gmail.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599830448; bh=Ybr+GZc7uc1JqpnxLEx/eCBGp+nlP6BkyEG1FnqCKVY=;
        h=X-PGP-Universal:Date:From:To:CC:Subject:Message-ID:References:
         MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy;
        b=OF8fJVyI8e8+JhOiMR40i52UNIv/3fQVptbafB8jQGxZJHU8b7yY886+0sbzLXdEN
         +jzteuVIs3xANVzHuMPvb9CBnlgSU/yF+XemHbv4VzF9Bw941+s1oq+u0Mfsrxf5Du
         5Dpac2Y25cEBYoBaPqyh3BTyMbg+a14lNCMui3dw1zw/uubCmS1e5U9REiPQ13ctTX
         q2N4TKvy6MzV1UQgWSFtqUKkQXJO68WySBPlT8WWDMteNPRaKGl3PYP7o6TypGllZM
         r2k5bYZCLbfQfRWQdh02mSHuWuBTQpRjJOjN5uMw/d4VjEbpXKYuD2nAENXkNtXoya
         y6j2Z+evcYVvw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 11:41:04AM -0700, Florian Fainelli wrote:
> +Ido,
> 
> On 9/10/2020 8:07 AM, Vladimir Oltean wrote:
> > Florian, can you please reiterate what is the problem with calling
> > vlan_vid_add() with a VLAN that is installed by the bridge?
> > 
> > The effect of vlan_vid_add(), to my knowledge, is that the network
> > interface should add this VLAN to its filtering table, and not drop it.
> > So why return -EBUSY?

Can you clarify when you return -EBUSY? At least in mlxsw we return an
error in case we have a VLAN-aware bridge taking care of some VLAN and
then user space tries to install a VLAN upper with the same VLAN on the
same port. See more below.

> 
> I suppose that if you wanted to have an 802.1Q just for the sake of
> receiving VLAN tagged frames but not have them ingress the to the CPU, you
> could install an 802.1Q upper, but why would you do that unless the CPU
> should also receive that traffic?
> 
> The case that I wanted to cover was to avoid the two programming interfaces
> or the same VLAN, and prefer the bridge VLAN management over the 802.1Q
> upper, because once the switch port is in a bridge, that is what an user
> would expect to use.
> 
> If you have a bridge that is VLAN aware, it will manage the data and control
> path for us and that is all good since it is capable of dealing with VLAN
> tagged frames.
> 
> A non-VLAN aware bridge's data path is only allowed to see untagged traffic,
> so if you wanted somehow to inject untagged traffic into the bridge data
> path, then you would add a 802.1Q upper to that switch port, and somehow add
> that device into the bridge. There is a problem with that though, if you
> have mutliple bridge devices spanning the same switch, and you do the same
> thing on another switch port, with another 802.1Q upper, I believe you could
> break isolation between bridges for that particular VID.

At least in mlxsw this is handled by mapping the two {Port, VID} pairs
into different FIDs, each corresponding to a different bridge instance,
thereby maintaining the isolation.

> 
> Most of this was based on discussions we had with Ido and him explaining to
> me how they were doing it in mlxsw.
> 
> AFAIR the other case which is that you already have a 802.1Q upper, and then
> you add the switch port to the bridge is permitted and the bridge would
> inherit the VLAN into its local database.

If you have swp1 and swp1.10, you can put swp1 in a VLAN-aware bridge
and swp1.10 in a VLAN-unaware bridge. If you add VLAN 10 as part of the
VLAN-aware bridge on swp1, traffic tagged with this VLAN will still be
injected into the stack via swp1.10.

I'm not sure what is the use case for such a configuration and we reject
it in mlxsw.

> 
> I did not put much thoughts back then into a cascading set-up, so some
> assumptions can certainly be broken, and in fact, are broken today as you
> experimented.
> -- 
> Florian
