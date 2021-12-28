Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F474805B9
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 03:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbhL1CV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 21:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbhL1CV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 21:21:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3F2C06173E
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 18:21:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 278E2CE10D1
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 02:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E03C36AE7;
        Tue, 28 Dec 2021 02:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640658085;
        bh=SFIvM3d9w+BZ4pJPMI9U9MCXgno+/HQnLOe+H+YvpxA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f4Q7OhnaTs+z6uKozHHemdQxMVaeyYjy3f5nfSdZZ7cJOE/4lufbTXqIO5Y37pdxp
         HktF8ncL47CnLblK0B+5ypL8Q3Y2marfjf7gRFGryNO4v6B+Vlxe6bYAsL1XdignA4
         x2mw+eHVbFKBihRRaz2xnYy0KNeW1CJP7tADwaF6nDB7UySYsIdn/TPaSwDYfmbwVz
         xFb9wIMLF6v7bg5NhaDnzhUmuvGcbyq4ksHTr3veTbzvI7z2+6BoUaYSnNA99NULlZ
         1LeL+lMZdbs2sh0uTdzwHucbx6OLq8ZvE39pBBKBvYqaQyNPa9Zt0OqEGYDgoNf8OG
         d3bMQyZHm32ng==
Date:   Mon, 27 Dec 2021 18:21:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ryan Lahfa <ryan@lahfa.xyz>
Cc:     netdev@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>
Subject: Re: RTL8156(A|B) chip requires r8156 to be force loaded to operate
Message-ID: <20211227182124.5cbc0d07@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211224203018.z2n7sylht47ownga@Thors>
References: <20211224203018.z2n7sylht47ownga@Thors>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Dec 2021 21:30:18 +0100 Ryan Lahfa wrote:
> Hi all,
> 
> I recently bought an USB-C 2.5Gbps external network card, which shows in
> `lsusb` as:
> 
> > Bus 002 Device 003: ID 0bda:8156 Realtek Semiconductor Corp. USB 10/100/1G/2.5G LAN  
> 
> By default, on my distribution (NixOS "21.11pre319254.b5182c214fa")'s
> latest kernel (`pkgs.linuxPackages_latest`) which shows in `uname -nar`
> as:
> 
> > Linux $machine 5.15.10 #1-NixOS SMP Fri Dec 17 09:30:17 UTC 2021 x86_64 GNU/Linux  
> 
> The network card is loaded with `cdc_ncm` driver and is unable to detect
> any carrier even when one is actually plugged in, I tried multiple
> things, I confirmed independently that the carrier is working.
> 
> Through further investigations and with the help of a user on
> Libera.Chat #networking channel, we blacklisted `cdc_ncm`, but nothing
> get loaded in turn.
> 
> Then, I forced the usage of r8152 for the device 0bda:8156 using `echo
> 0bda 8156 > /sys/bus/usb/drivers/r8152/new_id`, and... miracle.
> Everything just worked.
> 
> I am uncertain whether this falls in kernel's responsibility or not, it
> seems indeed that my device is listed for r8152: https://github.com/torvalds/linux/blob/master/drivers/net/usb/r8152.c#L9790 introduced by this commit https://github.com/torvalds/linux/commit/195aae321c829dd1945900d75561e6aa79cce208 if I understand well, which is tagged for 5.15.
> 
> I am curious to see how difficult would that be to write a patch for
> this and fix it, meanwhile, here is my modest contribution with this bug
> report, hopefully, this is the right place for them.

Can you please share the output of lsusb -d '0bda:8156' -vv ?

Adding Hayes to the CC list.
