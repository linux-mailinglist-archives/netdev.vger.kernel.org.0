Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F615515EE8
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 17:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242982AbiD3P42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 11:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242970AbiD3P41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 11:56:27 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1CA580C4;
        Sat, 30 Apr 2022 08:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lxRU4LE3pvOW3ivVzq+FV5/t6uMeAUpHsCxeSXoPW3M=; b=jXI2aVt7bjb5ddwZ6Y5/6fdyjI
        QCFaK7Z7eTmsXS0W+gvekQj1zhc0LZx0Ufb6Iqm405H4GQNxo8lXVuwvXVaEJAAB4iA6n7QHj8wGn
        3siWN5DD3CGDyxm00w0JElWRQpoPsKBkh3JkUivDHE6gRPknVFhPLlUjvh6Kpko6II4g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nkpOy-000eIR-VZ; Sat, 30 Apr 2022 17:52:56 +0200
Date:   Sat, 30 Apr 2022 17:52:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] net: phy: fix motorcomm module automatic loading
Message-ID: <Ym1bWHNj0p6L9lY8@lunn.ch>
References: <20220228233057.1140817-1-pgwipeout@gmail.com>
 <Yh1lboz7VDiuYuZV@shell.armlinux.org.uk>
 <CAMdYzYrNvUUMom4W4uD9yf9LtFK1h5Xw+9GYc54hB5+iqVmJtw@mail.gmail.com>
 <CAMdYzYrFuMw4aj_9L698ZhL7Xqy8=NeXhy9HDz4ug-v3=f4fpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMdYzYrFuMw4aj_9L698ZhL7Xqy8=NeXhy9HDz4ug-v3=f4fpw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Good Morning,
> 
> After testing various configurations I found what is actually
> happening here. When libphy is built in but the phy drivers are
> modules and not available in the initrd, the generic phy driver binds
> here. This allows the phy to come up but it is not functional.

What MAC are you using?

Why is you interface being brought up by the initramfs? Are you using
NFS root from within the initramfs?

What normally happens is that the kernel loads, maybe with the MAC
driver and phylib loading, as part of the initramfs. The other modules
in the initramfs allow the root filesystem to be found, mounted, and
pivoted into it. The MAC driver is then brought up by the initscripts,
which causes phylib to request the needed PHY driver modules, it loads
and all is good.

If you are using NFS root, then the load of the PHY driver happens
earlier, inside the initramfs. If this is you situation, maybe the
correct fix is to teach the initramfs tools to include the PHY drivers
when NFS root is being used?

     Andrew
