Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54FF74AF2BA
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbiBINaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiBINaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:30:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0ECC0613CA
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 05:30:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90A9B619B9
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE4DFC340EE;
        Wed,  9 Feb 2022 13:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644413409;
        bh=dqFLCMcM1a2t/cui77gdWRtBrzz/Wa4FCnYr7aYvVBo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p2t3g1DMOPpZTfCM+nEXBN+pDOQb5L0hxdTOppt9J17vJAc0KG2ymgFBJ9j6VTc40
         OKWCbnjMQRl/HVNAPOLi1g7de5tqHybz7zkTW8CvTyJdpJMXWgOQYdMU48KDQR2wcc
         mo9fXCW5KMqHE+zRZ7So20/Km35CXNDweXAj0YkAjh0+uHd2kyAzaQJxdFKNPoCor1
         F3NeB3UKxgQIUVIGiuKNXo9pEoOeJZhGQOnYW+j+bg3HbLI8fPioFk4anhmBlsOamd
         heHWHWKCZAUYzphjQ5Nlps08wJjBJC7yq5Bg/cv3CVFgRX/2IO4l3S6r52wfZkIBAO
         ATPrMMJUeOc9w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D6F32E5D07D;
        Wed,  9 Feb 2022 13:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: fix panic when DSA master device unbinds on
 shutdown
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164441340887.22778.9139231600742390355.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 13:30:08 +0000
References: <20220209120433.1942242-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220209120433.1942242-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, rafael.richter@gin.de, daniel.klauer@gin.de,
        LinoSanfilippo@gmx.de
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  9 Feb 2022 14:04:33 +0200 you wrote:
> Rafael reports that on a system with LX2160A and Marvell DSA switches,
> if a reboot occurs while the DSA master (dpaa2-eth) is up, the following
> panic can be seen:
> 
> systemd-shutdown[1]: Rebooting.
> Unable to handle kernel paging request at virtual address 00a0000800000041
> [00a0000800000041] address between user and kernel address ranges
> Internal error: Oops: 96000004 [#1] PREEMPT SMP
> CPU: 6 PID: 1 Comm: systemd-shutdow Not tainted 5.16.5-00042-g8f5585009b24 #32
> pc : dsa_slave_netdevice_event+0x130/0x3e4
> lr : raw_notifier_call_chain+0x50/0x6c
> Call trace:
>  dsa_slave_netdevice_event+0x130/0x3e4
>  raw_notifier_call_chain+0x50/0x6c
>  call_netdevice_notifiers_info+0x54/0xa0
>  __dev_close_many+0x50/0x130
>  dev_close_many+0x84/0x120
>  unregister_netdevice_many+0x130/0x710
>  unregister_netdevice_queue+0x8c/0xd0
>  unregister_netdev+0x20/0x30
>  dpaa2_eth_remove+0x68/0x190
>  fsl_mc_driver_remove+0x20/0x5c
>  __device_release_driver+0x21c/0x220
>  device_release_driver_internal+0xac/0xb0
>  device_links_unbind_consumers+0xd4/0x100
>  __device_release_driver+0x94/0x220
>  device_release_driver+0x28/0x40
>  bus_remove_device+0x118/0x124
>  device_del+0x174/0x420
>  fsl_mc_device_remove+0x24/0x40
>  __fsl_mc_device_remove+0xc/0x20
>  device_for_each_child+0x58/0xa0
>  dprc_remove+0x90/0xb0
>  fsl_mc_driver_remove+0x20/0x5c
>  __device_release_driver+0x21c/0x220
>  device_release_driver+0x28/0x40
>  bus_remove_device+0x118/0x124
>  device_del+0x174/0x420
>  fsl_mc_bus_remove+0x80/0x100
>  fsl_mc_bus_shutdown+0xc/0x1c
>  platform_shutdown+0x20/0x30
>  device_shutdown+0x154/0x330
>  __do_sys_reboot+0x1cc/0x250
>  __arm64_sys_reboot+0x20/0x30
>  invoke_syscall.constprop.0+0x4c/0xe0
>  do_el0_svc+0x4c/0x150
>  el0_svc+0x24/0xb0
>  el0t_64_sync_handler+0xa8/0xb0
>  el0t_64_sync+0x178/0x17c
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: fix panic when DSA master device unbinds on shutdown
    https://git.kernel.org/netdev/net/c/ee534378f005

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


