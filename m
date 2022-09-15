Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 589375BA1B1
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 22:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiIOUDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 16:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiIOUDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 16:03:01 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB56A4331C;
        Thu, 15 Sep 2022 13:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CVYuECPM83FEQHhz8izEZQYuCNvrVVGJpDc4BNAW4kc=; b=Bhiyw3lRssLgGmfxRwg53V8q/z
        OEqvH/rgh2kazI5QfI68FNDebvAiNPDi0bVLfVZ2CV/+kpVr0nNbkYrVRY6FJO1iKhrI3jA9ouJsY
        fR6nS9p7G9+piQm9wBF/A24alSCG9lPj+LT7qFQPJdzKPChm/OiBM+s8eHTZC9z9GFt4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oYv4M-00GqxM-0I; Thu, 15 Sep 2022 22:02:42 +0200
Date:   Thu, 15 Sep 2022 22:02:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rondreis <linhaoguo86@gmail.com>
Cc:     pabeni@redhat.com, huangguangbin2@huawei.com,
        john.fastabend@gmail.com, hawk@kernel.org, trix@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: general protection fault in ethtool_get_drvinfo
Message-ID: <YyOE4VPJAnnTODJ4@lunn.ch>
References: <CAB7eexJUFDKsgE9g_2vp9ZM=A-JHwTMFBDqP2LC54WZ666pdZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB7eexJUFDKsgE9g_2vp9ZM=A-JHwTMFBDqP2LC54WZ666pdZw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 12:02:22AM +0800, Rondreis wrote:
> Hello,
> 
> When fuzzing the Linux kernel driver v6.0-rc4, the following crash was
> triggered.
> 
> HEAD commit: 7e18e42e4b280c85b76967a9106a13ca61c16179
> git tree: upstream
> 
> kernel config: https://pastebin.com/raw/xtrgsXP3
> C reproducer: https://pastebin.com/raw/RtX3naYU
> console output: https://pastebin.com/raw/HqjSMu2n
> 
> Basically, in the c reproducer, we use the gadget module to emulate
> attaching a USB device(vendor id: 0x1b3d, product id: 0x19c, with the
> midi function) and executing some simple sequence of system calls.
> To reproduce this crash, we utilize a third-party library to emulate
> the attaching process: https://github.com/linux-usb-gadgets/libusbgx.
> Just clone this repository, install it, and compile the c
> reproducer with ``` gcc crash.c -lusbgx -lconfig -o crash ``` will do
> the trick.
> 
> I would appreciate it if you have any idea how to solve this bug.
> 
> The crash report is as follows:
> general protection fault, probably for non-canonical address
> 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 PID: 6495 Comm: systemd-udevd Not tainted 6.0.0-rc4+ #20
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> RIP: 0010:ethtool_get_drvinfo+0x533/0x7d0 net/ethtool/ioctl.c:723

If this can be trusted:

723:		strlcpy(rsp->info.driver, dev->dev.parent->driver->name,
724:			sizeof(rsp->info.driver));

So it looks like dev->dev.parent->driver->name is invalid. That i
would say is a driver bug, a driver should always have a name.

What driver is dev->dev.parent->driver?

     Andrew
