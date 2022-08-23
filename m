Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27EF59DFB7
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 14:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243911AbiHWLT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 07:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244332AbiHWLRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 07:17:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9965BD760;
        Tue, 23 Aug 2022 02:20:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29CFA6122D;
        Tue, 23 Aug 2022 09:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88A0BC433D7;
        Tue, 23 Aug 2022 09:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661246417;
        bh=E5E6YqheunirZWVRILdnP1fmydkijA605aVw9h45w54=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lNIMtUlYb2oThTM3KA8GuBXUuMf8SCxgSlhXoMHAHnuc/TXp679M6qx2q1wb8FDHJ
         pjEmJK14tnqDdFKTRXzMI+h420ap1y/uLepZ9bbFYtBSBCRsKtn3+cl2jXtu8HiHvt
         kLfdd4nYE4QxAoZca01QrifXWxL+W+hAmOvWsXC7qqdRa3mXvMEKVmG2Y57+xRYSXN
         E40ySzqpbHlSohsmANHbJic/uEbt31aftBq96h/2McHYZCt72nuKw/qvbT9cCcmZbe
         cjTtd/u4yrhCmshGLpJUO4uOakEw7ncW7Z4flpGvb9JyeLakMk+esGFcx6krlfcN89
         fnu0wcI7jDrgQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 67C11E2A041;
        Tue, 23 Aug 2022 09:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/9] vsock: updates for SO_RCVLOWAT handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166124641741.3613.14462529402245081458.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Aug 2022 09:20:17 +0000
References: <de41de4c-0345-34d7-7c36-4345258b7ba8@sberdevices.ru>
In-Reply-To: <de41de4c-0345-34d7-7c36-4345258b7ba8@sberdevices.ru>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     sgarzare@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, stefanha@redhat.com, bryantan@vmware.com,
        vdasa@vmware.com, oxffffaa@gmail.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, kernel@sberdevices.ru, pv-drivers@vmware.com
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

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 19 Aug 2022 05:21:58 +0000 you wrote:
> Hello,
> 
> This patchset includes some updates for SO_RCVLOWAT:
> 
> 1) af_vsock:
>    During my experiments with zerocopy receive, i found, that in some
>    cases, poll() implementation violates POSIX: when socket has non-
>    default SO_RCVLOWAT(e.g. not 1), poll() will always set POLLIN and
>    POLLRDNORM bits in 'revents' even number of bytes available to read
>    on socket is smaller than SO_RCVLOWAT value. In this case,user sees
>    POLLIN flag and then tries to read data(for example using  'read()'
>    call), but read call will be blocked, because  SO_RCVLOWAT logic is
>    supported in dequeue loop in af_vsock.c. But the same time,  POSIX
>    requires that:
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/9] vsock: SO_RCVLOWAT transport set callback
    https://git.kernel.org/netdev/net-next/c/e38f22c860ed
  - [net-next,v4,2/9] hv_sock: disable SO_RCVLOWAT support
    https://git.kernel.org/netdev/net-next/c/24764f8d3c31
  - [net-next,v4,3/9] virtio/vsock: use 'target' in notify_poll_in callback
    https://git.kernel.org/netdev/net-next/c/e7a3266c9167
  - [net-next,v4,4/9] vmci/vsock: use 'target' in notify_poll_in callback
    https://git.kernel.org/netdev/net-next/c/a274f6ff3c5c
  - [net-next,v4,5/9] vsock: pass sock_rcvlowat to notify_poll_in as target
    https://git.kernel.org/netdev/net-next/c/ee0b3843a269
  - [net-next,v4,6/9] vsock: add API call for data ready
    https://git.kernel.org/netdev/net-next/c/f2fdcf67aceb
  - [net-next,v4,7/9] virtio/vsock: check SO_RCVLOWAT before wake up reader
    https://git.kernel.org/netdev/net-next/c/39f1ed33a448
  - [net-next,v4,8/9] vmci/vsock: check SO_RCVLOWAT before wake up reader
    https://git.kernel.org/netdev/net-next/c/e061aed99855
  - [net-next,v4,9/9] vsock_test: POLLIN + SO_RCVLOWAT test
    https://git.kernel.org/netdev/net-next/c/b1346338fbae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


