Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA8E31667C
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 13:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhBJMV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 07:21:28 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:37965 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbhBJMSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 07:18:09 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 68FAD23E71;
        Wed, 10 Feb 2021 13:17:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612959445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HxKKJGcjZqb6ADx31bF0Km0a9d2097EzXiR7C+jFFBo=;
        b=rfG0eVncG7i5ZobYf8+NjAlDN3QkgU6jRstOhap56CiZDzJaeHrdRX7zX3zgYalQYaLPob
        ObHTavylJFtW910gBqn7YRhUbPdUH8xMv/XzzUNsIrF53X6ZHj3d0S+jrljHjLMCc+Nvfq
        b+RSfKoVmVZIN68QjiITtVUnOfau0rk=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 10 Feb 2021 13:17:25 +0100
From:   Michael Walle <michael@walle.cc>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 7/9] net: phy: icplus: select page before writing
 control register
In-Reply-To: <20210210114826.GU1463@shell.armlinux.org.uk>
References: <20210209164051.18156-1-michael@walle.cc>
 <20210209164051.18156-8-michael@walle.cc>
 <d5672062-c619-02a4-3bbe-dad44371331d@gmail.com>
 <20210210103059.GR1463@shell.armlinux.org.uk>
 <d35f726f82c6c743519f3d8a36037dfa@walle.cc>
 <20210210104900.GS1463@shell.armlinux.org.uk>
 <3a9716ffafc632d2963d3eee673fb0b1@walle.cc>
 <20210210114826.GU1463@shell.armlinux.org.uk>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <1a751f7fe316d58b9846ecfa0dcdc02b@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-02-10 12:48, schrieb Russell King - ARM Linux admin:
> On Wed, Feb 10, 2021 at 12:14:35PM +0100, Michael Walle wrote:
>> Am 2021-02-10 11:49, schrieb Russell King - ARM Linux admin:
>> The PHY doesn't support fiber and register 0..15 are always available
>> regardless of the selected page for the IP101G.
>> 
>> genphy_() stuff will work, but the IP101G PHY driver specific 
>> functions,
>> like interrupt and mdix will break if someone is messing with the page
>> register from userspace.
>> 
>> So Heiner's point was, that there are other PHY drivers which
>> also break when a user changes registers from userspace and no one
>> seemed to cared about that for now.
>> 
>> I guess it boils down to: how hard should we try to get the driver
>> behave correctly if the user is changing registers. Or can we
>> just make the assumption that if the PHY driver sets the page
>> selection to its default, all the other callbacks will work
>> on this page.
> 
> Provided the PHY driver uses the paged accessors for all paged
> registers, userspace can't break the PHY driver because we have proper
> locking in the paged accessors (I wrote them.) Userspace can access the
> paged registers too, but there will be no locking other than on each
> individual access. This can't be fixed without augmenting the kernel/
> user API, and in any case is not a matter for the PHY driver.
> 
> So, let's stop worrying about the userspace paged access problem for
> driver reviews; that's a core phylib and userspace API issue.
> 
> The paged accessor API is designed to allow the driver author to access
> registers in the most efficient manner. There are two parts to it.
> 
> 1) the phy_*_paged() accessors switch the page before accessing the
>    register, and restore it afterwards. If you need to access a lot
>    of paged registers, this can be inefficient.
> 
> 2) phy_save_page()..phy_restore_page() allows wrapping of __phy_*
>    accessors to access paged registers.
> 
> 3) phy_select_page()..phy_restore_page() also allows wrapping of
>    __phy_* accessors to access paged registers.
> 
> phy_save_page() and phy_select_page() must /always/ be paired with
> a call to phy_restore_page(), since the former pair takes the bus lock
> and the latter releases it.
> 
> (2) and (3) allow multiple accesses to either a single page without
> constantly saving and restoring the page, and can also be used to
> select other pages without the save/restore and locking steps. We
> could export __phy_read_page() and __phy_write_page() if required.
> 
> While the bus lock is taken, userspace can't access any PHY on the bus.

That was how the v1 of this series was written. But Heiner's review
comment was, what if we just set the default page and don't
use phy_save_page()..phy_restore_page() for the registers which are
behind the default page. And in this case, userspace _can_ break
access to the paged registers.

-michael
