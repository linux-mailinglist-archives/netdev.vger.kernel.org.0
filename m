Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3AD601452
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 19:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbiJQRI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 13:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiJQRIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 13:08:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4104E851;
        Mon, 17 Oct 2022 10:08:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49AA561195;
        Mon, 17 Oct 2022 17:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73065C433C1;
        Mon, 17 Oct 2022 17:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666026502;
        bh=KdUaY1/13+fnvQg7dGcqMAbtIcx96IH8hUYqJC8QAJ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=XopEiKeMz0xAqDySvCRIy/9wJiF27eMUrvzSI5IiEW0kQl+xYIsJKToEI3ZDzQiz1
         KKXh/VYTo9DsmswmqKrA9CkIj4BRbs9sA2d4tPBA68hsezhM949Cs9izoV1y4olSGc
         Z8DAph7c5ofVit31xCqBYC8Y0acBpdG4AxjQFYCr06BjWaRvbW0sauADnW29QWKO0e
         yxkLev/7SKgzfaiIMRjI3c/fOWl3DmHiQRce6IYzcs6guh6TZytakviVXL1zr1d2GF
         IurjDobWdLtqcmAPcwIQo1LEZtrXMWQF2ULEwYUCcFn5U08+iYZ7k+NTKuihggWWar
         W9TsG7W9f3ddA==
Date:   Mon, 17 Oct 2022 12:08:20 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     Jeffrey Tseng <jeffrey.tseng@gigabyte.com>, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Bug 216599] New: i210 doesn't work and triggers netdev watchdog
 (Linux 5.10)
Message-ID: <20221017170820.GA3712555@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-216599-41252@https.bugzilla.kernel.org/>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 17, 2022 at 11:09:20AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=216599
> 
>             Bug ID: 216599
>            Summary: i210 doesn't work and triggers netdev watchdog (Linux
>                     5.10)

> Created attachment 303021
>   --> https://bugzilla.kernel.org/attachment.cgi?id=303021&action=edit
> This is the complete dmesg log and "sudo lspci -vv" output.
> 
> Here is my question.
> My platform : imx8mm
> Ethernet Control : Intel I210
> Linux version 5.10.72-lts-5.10.y+g22ec7e8cbace (oe-user@oe-host)
> (aarch64-poky-linux-gcc (GCC) 10.2.0, GNU ld (GNU Binutils) 2. UTC 2011
> 
> I follow this  https://git.kernel.org/linus/500b55b05d0a
> to add the patch in my platform.
> 
> The issue and problem is still there. Anyone can give me a hand ?

Note this is an old v5.10 kernel on ARM64.  No indication of whether
the problem occurs on a recent kernel.

We had an earlier issue with i210 when the disabled ROM BAR
overlapped BAR 3 [1] and the watchdog triggered:

  BAR 0: 0x40000000 (32-bit, non-prefetchable) [size=1M]
  BAR 3: 0x40200000 (32-bit, non-prefetchable) [size=16K]
  ROM:   0x40200000 (disabled) [size=1M]
  ...
  NETDEV WATCHDOG: enP2p1s0 (igb): transmit queue 0 timed out
  Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC Eval 2.0 carrier (DT)
  igb 0002:01:00.0 enP2p1s0: Reset adapter

But this case looks different because there is no ROM BAR at all.
From the dmesg attached at [2]:

  pci 0000:01:00.0: BAR 0: assigned [mem 0x18100000-0x1817ffff]
  pci 0000:01:00.0: BAR 3: assigned [mem 0x18180000-0x18183fff]
  pci 0000:01:00.0: BAR 2: assigned [io  0x1000-0x101f]
  ...
  igb 0000:01:00.0: Detected Tx Unit Hang
  NETDEV WATCHDOG: eth1 (igb): transmit queue 1 timed out

I'm assuming this is a driver issue, not a PCI core issue.  But please
ping me if you think otherwise.

Bjorn

[1] https://git.kernel.org/linus/500b55b05d0a
[2] https://bugzilla.kernel.org/show_bug.cgi?id=216599
