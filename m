Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71683466607
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 15:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357757AbhLBPCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 10:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358856AbhLBPCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 10:02:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8DCC06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 06:59:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 234DFB823B7
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 14:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF11C53FCB;
        Thu,  2 Dec 2021 14:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638457164;
        bh=zoYHUlVmtalqaqaWlI4ZeuDLit6/dPkwjzcMVkmVLNo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JXIIR7dXPIojilNVLkiWZVf7qGZ3XVWcuyLudVZPlm9c5InqVp4UdpwlU+7WMuPNF
         YphYGgZIfO/mRHZQVEaM8y3LXlCY76hnbu2sckU3IZtGL68GIQVNJXQTQFbnUvzey6
         fAn77XZNU6TzNP0ZiEtUkwqh8K4g7iX9/u3lNgCwss7XHuqFUAhlF8JUor6AwbOvdn
         /lT3mGdBT9SMAEwWz1e5bXYA7TC2yLJlOXvQdbOgr/arcE2h8ABCXYpwLfDfK0Ybtj
         ANHNPusXX5eJAt39b7SCPCRLHdWxFDgbSJSp2/htQkR6I0zUdbBbGEF1x3miO+JDqY
         /ZCsjIUri3+yQ==
Date:   Thu, 2 Dec 2021 06:59:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>, davem@davemloft.net,
        Richard Cochran <richardcochran@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [PATCH net-next] bond: pass get_ts_info and SIOC[SG]HWTSTAMP
 ioctl to active device
Message-ID: <20211202065923.7fc5aa8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <Yag3yI4cNnUK2Yjy@Laptop-X1>
References: <20211130070932.1634476-1-liuhangbin@gmail.com>
        <20211130071956.5ad2c795@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YacAstl+brTqgAu8@Laptop-X1>
        <20211201071118.749a3ed4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <Yag3yI4cNnUK2Yjy@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Dec 2021 11:04:40 +0800 Hangbin Liu wrote:
> > Yeah, there should be some form of well understood indication in the
> > uAPI telling the user space daemon that the PHC may get swapped on the
> > interface, and a reliable notification which indicates PHC change.
> > There is a number of user space daemons out there, fixing linuxptp does
> > not mean other user space won't be broken/surprised/angry.  
> 
> This is a RFE, I don't think this patch will affect the current user space as
> the new topology is not supported before. i.e. no user space tool will configure
> PTP based on bond or vlan over bond. And even the user space use other ways to
> get bond's active interface, e.g. via netlink message. It still not affected
> and could keep using the old way. So I think this patch should be safe.
> 
> Did I miss any thing?

User can point their PTP daemon at any interface. Since bond now
supports the uAPI the user will be blissfully unaware that their
configuration will break if failover happens.

We can't expect every user and every PTP daemon to magically understand
the implicit quirks of the drivers. Quirks which are not even
documented.

What I'm saying is that we should have a new bit in the uAPI that
tells us that the user space can deal with unstable PHC idx and reject
the request forwarding in bond if that bit is not set. We have a flags
field in hwtstamp_config which should fit the bill. Make sense?

> > What notification is linuxptp listening on, SETLINK?  
> 
> Currently, I send RTM_GETLINK message on bond and listening on
> RTM_NEWLINK message to get IFLA_LINKINFO info.
> 
> But for the new VLAN over bond topology. I haven't figure out a good solution.
> Maybe I can just check the active interface status. When it get down,
> do get_ts_info once again to get the new active interface on the VLAN over
> bond interface. I need some testing.
