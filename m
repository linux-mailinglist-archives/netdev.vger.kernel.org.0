Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37973637432
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiKXIkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiKXIkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:40:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96ACA729AC;
        Thu, 24 Nov 2022 00:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39330B8271A;
        Thu, 24 Nov 2022 08:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B42E1C433D6;
        Thu, 24 Nov 2022 08:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669279216;
        bh=eCa8ATWCbYBvLvbnjFk+znnfL+9RvDhTXanoNMS+5Sk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UeruFnrsEcUUNzDwvOAVawvGPxbPT/m6GU9bT+/PiiysiM+iRywmd5dPgWkkpIOtj
         NPAw+7t16rXJ4k+GEtCJfb3Zrnc0qBRu9+iipb7vJHVr+dQgkwPaYbt0JtvQ0E7oqu
         c2Ua1yva0K32PH0AElE0MkpkdbdQo/LP5b4IUFY2L3VakalkAF+ME0Tt3V5ljKqjbl
         J/xCYEiqF6rFrjs3SFulFo95WI1jvQj6iVpF0manU0igFaSUdw9QvNrClyO11Oixtp
         8iR2Qm/v1sr0anODLphMH/NfPCrzAwUUg5MdFLusJ9dJlvPdQ7e/VQR6lbU9edXpt0
         8y+XrEiZM670A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 92589E29F53;
        Thu, 24 Nov 2022 08:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] virtio_net: Fix probe failed when modprobe virtio_net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166927921658.31457.16681019043491426856.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Nov 2022 08:40:16 +0000
References: <20221122150046.3910638-1-lizetao1@huawei.com>
In-Reply-To: <20221122150046.3910638-1-lizetao1@huawei.com>
To:     Li Zetao <lizetao1@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, jasowang@redhat.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, pabeni@redhat.com, rusty@rustcorp.com.au,
        cornelia.huck@de.ibm.com, virtualization@lists.linux-foundation.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 22 Nov 2022 23:00:46 +0800 you wrote:
> When doing the following test steps, an error was found:
>   step 1: modprobe virtio_net succeeded
>     # modprobe virtio_net        <-- OK
> 
>   step 2: fault injection in register_netdevice()
>     # modprobe -r virtio_net     <-- OK
>     # ...
>       FAULT_INJECTION: forcing a failure.
>       name failslab, interval 1, probability 0, space 0, times 0
>       CPU: 0 PID: 3521 Comm: modprobe
>       Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
>       Call Trace:
>        <TASK>
>        ...
>        should_failslab+0xa/0x20
>        ...
>        dev_set_name+0xc0/0x100
>        netdev_register_kobject+0xc2/0x340
>        register_netdevice+0xbb9/0x1320
>        virtnet_probe+0x1d72/0x2658 [virtio_net]
>        ...
>        </TASK>
>       virtio_net: probe of virtio0 failed with error -22
> 
> [...]

Here is the summary with links:
  - [v2] virtio_net: Fix probe failed when modprobe virtio_net
    https://git.kernel.org/netdev/net/c/b06865659463

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


