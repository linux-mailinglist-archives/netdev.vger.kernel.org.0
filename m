Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F1A68B999
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjBFKME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjBFKLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:11:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B383C22785;
        Mon,  6 Feb 2023 02:10:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B64CB80E90;
        Mon,  6 Feb 2023 10:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF328C4339B;
        Mon,  6 Feb 2023 10:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675678216;
        bh=tbHrcoLVmAu+JSnAxdA3YXJoHjx78aj6OCWv3DkWVSk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A6CWRkJsiKqg6h1V5S9J8KmbhyQ1b4BwDLVeA/j9BvyO9+kVafNpRRGgKm7HQYLOn
         NMDd/vdPcRBV6i80DIAHNPMr7HzzytKPRN++drtcC/vAF62EZlja0cR3aH92lhmvgC
         KGcgv2AUADK6wazPwnF2e069DeTaYD/YYo5ymdrheX4HcmL1nPuwIJWrjmJ7ekJcdh
         Cigp/jWQ+FazZJa/4ccLF3B3Twtc3+PBHsP8kUGt/DZu4YOtaH6wq2YlkEmi5x/TqT
         fyszg21jYiMF5Zz9LL/lxVvNOmIKV+3Pac9p0RWx2Gp5lhe6drf/ZSCztQEBKu73kV
         NTtModvQ/xDOQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C59F7E55EFB;
        Mon,  6 Feb 2023 10:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: USB: Fix wrong-direction WARNING in plusb.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167567821680.32454.6898718687327583710.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Feb 2023 10:10:16 +0000
References: <Y91hOew3nW56Ki4O@rowland.harvard.edu>
In-Reply-To: <Y91hOew3nW56Ki4O@rowland.harvard.edu>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     gregkh@linuxfoundation.org,
        syzbot+2a0e7abd24f1eb90ce25@syzkaller.appspotmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        mailhol.vincent@wanadoo.fr, mkl@pengutronix.de, oneukum@suse.com,
        syzkaller-bugs@googlegroups.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 3 Feb 2023 14:32:09 -0500 you wrote:
> The syzbot fuzzer detected a bug in the plusb network driver: A
> zero-length control-OUT transfer was treated as a read instead of a
> write.  In modern kernels this error provokes a WARNING:
> 
> usb 1-1: BOGUS control dir, pipe 80000280 doesn't match bRequestType c0
> WARNING: CPU: 0 PID: 4645 at drivers/usb/core/urb.c:411
> usb_submit_urb+0x14a7/0x1880 drivers/usb/core/urb.c:411
> Modules linked in:
> CPU: 1 PID: 4645 Comm: dhcpcd Not tainted
> 6.2.0-rc6-syzkaller-00050-g9f266ccaa2f5 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google
> 01/12/2023
> RIP: 0010:usb_submit_urb+0x14a7/0x1880 drivers/usb/core/urb.c:411
> ...
> Call Trace:
>  <TASK>
>  usb_start_wait_urb+0x101/0x4b0 drivers/usb/core/message.c:58
>  usb_internal_control_msg drivers/usb/core/message.c:102 [inline]
>  usb_control_msg+0x320/0x4a0 drivers/usb/core/message.c:153
>  __usbnet_read_cmd+0xb9/0x390 drivers/net/usb/usbnet.c:2010
>  usbnet_read_cmd+0x96/0xf0 drivers/net/usb/usbnet.c:2068
>  pl_vendor_req drivers/net/usb/plusb.c:60 [inline]
>  pl_set_QuickLink_features drivers/net/usb/plusb.c:75 [inline]
>  pl_reset+0x2f/0xf0 drivers/net/usb/plusb.c:85
>  usbnet_open+0xcc/0x5d0 drivers/net/usb/usbnet.c:889
>  __dev_open+0x297/0x4d0 net/core/dev.c:1417
>  __dev_change_flags+0x587/0x750 net/core/dev.c:8530
>  dev_change_flags+0x97/0x170 net/core/dev.c:8602
>  devinet_ioctl+0x15a2/0x1d70 net/ipv4/devinet.c:1147
>  inet_ioctl+0x33f/0x380 net/ipv4/af_inet.c:979
>  sock_do_ioctl+0xcc/0x230 net/socket.c:1169
>  sock_ioctl+0x1f8/0x680 net/socket.c:1286
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:870 [inline]
>  __se_sys_ioctl fs/ioctl.c:856 [inline]
>  __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> [...]

Here is the summary with links:
  - net: USB: Fix wrong-direction WARNING in plusb.c
    https://git.kernel.org/netdev/net/c/811d581194f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


