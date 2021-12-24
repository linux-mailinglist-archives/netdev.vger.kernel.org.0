Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BF547F115
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 21:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234478AbhLXUgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 15:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhLXUgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 15:36:38 -0500
X-Greylist: delayed 375 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 24 Dec 2021 12:36:38 PST
Received: from kurisu.lahfa.xyz (unknown [IPv6:2001:bc8:38ee::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F90DC061401
        for <netdev@vger.kernel.org>; Fri, 24 Dec 2021 12:36:37 -0800 (PST)
Date:   Fri, 24 Dec 2021 21:30:18 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lahfa.xyz; s=kurisu;
        t=1640377818; bh=p5tu/bfL8pnwemIKX/azppThCLnKKAoOdcfJVZL1VcQ=;
        h=Date:From:To:Subject;
        b=KouwyGiBz//B9EJuSnxaqFjNpTvR0dKKtfprPlNnPsxyKf1YPJmnbEfze8oxfyaab
         eO1zxTfg9KFHb7LtjVeHyiu/fhEuVZFUUsUkdpoE6HK6EYHyjJHV0kkbw71IgzmIpb
         Qzvoo/3d9oijHcgs8xbb9Uw0XsgURTI4gx0DRW9M=
From:   Ryan Lahfa <ryan@lahfa.xyz>
To:     netdev@vger.kernel.org
Subject: RTL8156(A|B) chip requires r8156 to be force loaded to operate
Message-ID: <20211224203018.z2n7sylht47ownga@Thors>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I recently bought an USB-C 2.5Gbps external network card, which shows in
`lsusb` as:

> Bus 002 Device 003: ID 0bda:8156 Realtek Semiconductor Corp. USB 10/100/1G/2.5G LAN

By default, on my distribution (NixOS "21.11pre319254.b5182c214fa")'s
latest kernel (`pkgs.linuxPackages_latest`) which shows in `uname -nar`
as:

> Linux $machine 5.15.10 #1-NixOS SMP Fri Dec 17 09:30:17 UTC 2021 x86_64 GNU/Linux

The network card is loaded with `cdc_ncm` driver and is unable to detect
any carrier even when one is actually plugged in, I tried multiple
things, I confirmed independently that the carrier is working.

Through further investigations and with the help of a user on
Libera.Chat #networking channel, we blacklisted `cdc_ncm`, but nothing
get loaded in turn.

Then, I forced the usage of r8152 for the device 0bda:8156 using `echo
0bda 8156 > /sys/bus/usb/drivers/r8152/new_id`, and... miracle.
Everything just worked.

I am uncertain whether this falls in kernel's responsibility or not, it
seems indeed that my device is listed for r8152: https://github.com/torvalds/linux/blob/master/drivers/net/usb/r8152.c#L9790 introduced by this commit https://github.com/torvalds/linux/commit/195aae321c829dd1945900d75561e6aa79cce208 if I understand well, which is tagged for 5.15.

I am curious to see how difficult would that be to write a patch for
this and fix it, meanwhile, here is my modest contribution with this bug
report, hopefully, this is the right place for them.

Kind regards,
-- 
Ryan Lahfa
