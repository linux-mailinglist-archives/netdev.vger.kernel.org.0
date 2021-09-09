Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB714052D2
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352879AbhIIMr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:47:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34430 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354448AbhIIMmO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:42:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ccslqbdbDMRBI5TMJhPLL0kOsQFJUv4TDelcaobks6E=; b=05fGKYQu2zD3ugpGX5N14Irr/u
        4b2Xrw30clYSR6GzAqprkul/PZvrYUFHAsgBsUlQYPoAkIntZMzoEReouEB/rC5W9RMm/fJXufvNK
        YRzOO15MAZywz9newS+wsM8iX2FIthUvRopVsx+PK+IdpiEK8tqC0PAbTvJ3aCpzGbJI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mOJMM-005uJ8-Ct; Thu, 09 Sep 2021 14:40:54 +0200
Date:   Thu, 9 Sep 2021 14:40:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     olteanv@gmail.com, p.rosenberger@kunbus.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
Message-ID: <YToA1hf2/2KWoKxh@lunn.ch>
References: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 09, 2021 at 11:53:21AM +0200, Lino Sanfilippo wrote:
> This patch series fixes a system hang I got each time i tried to shutdown
> or reboot a system that uses a KSZ9897 as a DSA switch with a broadcom
> GENET network device as the DSA master device. At the time the system hangs
> the message "unregister_netdevice: waiting for eth0 to become free. Usage
> count = 2." is dumped periodically to the console.
> 
> After some investigation I found the reason to be unreleased references to
> the master device which are still held by the slave devices at the time the
> system is shut down (I have two slave devices in use).
> 
> While these references are supposed to be released in ksz_switch_remove()
> this function never gets the chance to be called due to the system hang at
> the master device deregistration which happens before ksz_switch_remove()
> is called.
> 
> The fix is to make sure that the master device references are already
> released when the device is unregistered. For this reason PATCH1 provides
> a new function dsa_tree_shutdown() that can be called by DSA drivers to
> untear the DSA switch at shutdown. PATCH2 uses this function in a new
> helper function for KSZ switches to properly shutdown the KSZ switch.
> PATCH 3 uses the new helper function in the KSZ9477 shutdown handler.

I agree with Vladimir here. Shutdown works without issue on mv88e6xxx,
i do it frequently. I'm sure other developers shutdown there devices
at the end of the edit/compile/test cycle. If there was a generic
problem, we would probably know about it. So it seems like there is
something specific to your system which breaks the reference
counting. We need to understand that first, then we can see how we fix
it.

> 
> Theses patches have been tested on a Raspberry PI 5.10 kernel with a
> KSZ9897. The patches have been adjusted to apply against net-next and are
> compile tested with next-next.

Is the switch on a hat? Are you using DT overlays?

   Andrew
