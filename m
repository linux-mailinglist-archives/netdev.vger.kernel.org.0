Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11CC44681CE
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 02:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376913AbhLDBfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 20:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237601AbhLDBfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 20:35:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFC5C061751
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 17:32:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D24DB80DD7
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 01:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC13C341C1;
        Sat,  4 Dec 2021 01:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638581524;
        bh=oLiw2+AvMLz5jRSwMHbfy8agi20mRg8gaLRcGjN5cAY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PQqbOFPM3nU4dli1iTLWDau6kI2y+xYH4Qp5zg2SwqRLr00AdZU9E3+3pl2s+2a2Y
         wT0sfBlX3b+88vNSHnr6hJU3GnePhYX6+dBLFIqrnBsokWsBwn0xMdDEZevHl9KYbj
         23GZrCYVF+/eDljFD9GsBxF//J/4B+XkUwqTI4qG6ulf3WMHfF1riznLP+wA+0aEob
         KCUZlgEqm+E5SFCsffH93qB4bBoBnmhhucFHksHWt/3J9XYprVMFAJdQwzbj2cI5rQ
         +VcNai3dmslhqN9GihFEtzYmHYRvkoRIHlAzikJCjK4kPQWEgv9pVPjWIg5L3afteX
         um1CZofEerpWw==
Date:   Fri, 3 Dec 2021 17:32:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Hayes Wang <hayeswang@realtek.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [RFC PATCH 0/4] r8169: support dash
Message-ID: <20211203173203.285dc75f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211204010829.7796-1-alexandr.lobakin@intel.com>
References: <20211129101315.16372-381-nic_swsd@realtek.com>
        <20211129095947.547a765f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <918d75ea873a453ab2ba588a35d66ab6@realtek.com>
        <20211130190926.7c1d735d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d3a1e1c469844aa697d6d315c9549eda@realtek.com>
        <20211203070410.1b4abc4d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211204010829.7796-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  4 Dec 2021 02:08:29 +0100 Alexander Lobakin wrote:
> > Ah, I've only spotted the enable/disable knob in the patch. 
> > If you're exchanging arbitrary binary data with the FW we 
> > can't help you. It's not going to fly upstream.  
> 
> Uhm. I'm not saying sysfs is a proper way to do that, not at all,
> buuut...
> We have a ton of different subsystems providing a communication
> channel between userspace and HW/FW. Chardevices all over the
> tree, highly used rpmsg for remoteproc, uio. 

Not in Ethernet.

> We have register dump in Ethtool,

Read only.

> as well as get/set for EEPROM, I'd count them as well.

EEPROM writes are supposed to update FW images, not send random
messages.

> So it probably isn't a bad idea to provide some standard API for
> network drivers to talk to HW/FW from userspace, like get/set or
> rx/tx (when having enough caps for sure)? It could be Devlink ops
> or Ethtool ops, the latter fits more to me.

I'm not saying it's wrong to merge shim drivers into the kernel and
let the user space talk to device FW. I'm saying it's counter to what
netdev's policy has always been and counter to my personal interests.

What is a standard API for custom, proprietary FW message interface?
We want standards at a functional level. Once you open up a raw FW
write interface there is no policing of what goes thru it.

I CCed Intel since you also have the (infamous) ME, but I never heard
of the need to communicate from the OS to the ME via the netdev
driver... Not sure why things are different for Realtek.
