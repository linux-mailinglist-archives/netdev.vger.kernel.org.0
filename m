Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327156D5F76
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 13:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234949AbjDDLuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 07:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234863AbjDDLuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 07:50:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023251982;
        Tue,  4 Apr 2023 04:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F62D632A3;
        Tue,  4 Apr 2023 11:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2B84C4339C;
        Tue,  4 Apr 2023 11:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680609017;
        bh=PUme9Pqjr+nOp7BWP8OmqF17obLXySvwFTlVeaoxJaE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZTaK2r+wl4Ag8QVQjUuxGrypd22g9th1Nn/TeN3oGHJZ1ITNecen8gBdA45U8zWoH
         TSZNhR8Ljm6WLiDpFYCz+cVhDnt6hPz0XEkNNk3iTzrv5wKk/kiyxb0vl+7ennRL1m
         Ahkiue8KerIjcH3weqJgp9Ths6X+8EqM8DgZF1vX7+uRRpmvjBsVusFKf5XVsy0bM8
         tT9xc8i3mqfSq5/VrHdnDm6UOUetcGBicNBKsrajoCr8j4zK9Jm2Xkn23CWb7hGwlI
         URA93xRtzlrai17cJQnXBMaJ4hIVZ2PLEKrL9b8VvLrdGJ3vuoFE8DrEsZVq+ol+0r
         ZMK2Xt51fPMFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BFF37E5EA89;
        Tue,  4 Apr 2023 11:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/3] vsock: return errors other than -ENOMEM to
 socket
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168060901777.14038.3884666734757699938.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Apr 2023 11:50:17 +0000
References: <0d20e25a-640c-72c1-2dcb-7a53a05e3132@sberdevices.ru>
In-Reply-To: <0d20e25a-640c-72c1-2dcb-7a53a05e3132@sberdevices.ru>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        bobby.eshleman@bytedance.com, bryantan@vmware.com,
        vdasa@vmware.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
        oxffffaa@gmail.com, avkrasnov@sberdevices.ru, pv-drivers@vmware.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 3 Apr 2023 14:23:00 +0300 you wrote:
> Hello,
> 
> this patchset removes behaviour, where error code returned from any
> transport was always switched to ENOMEM. This works in the same way as
> patch from Bobby Eshleman:
> commit c43170b7e157 ("vsock: return errors other than -ENOMEM to socket"),
> but for receive calls. VMCI transport is also updated (both tx and rx
> SOCK_STREAM callbacks), because it returns VMCI specific error code to
> af_vsock.c (like VMCI_ERROR_*). Tx path is already merged to net, so it
> was excluded from patchset in v4. At the same time, virtio and Hyper-V
> transports are using general error codes, so there is no need to update
> them.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/3] vsock/vmci: convert VMCI error code to -ENOMEM on receive
    https://git.kernel.org/netdev/net-next/c/f59f3006ca7b
  - [net-next,v4,2/3] vsock: return errors other than -ENOMEM to socket
    https://git.kernel.org/netdev/net-next/c/02ab696febab
  - [net-next,v4,3/3] vsock/test: update expected return values
    https://git.kernel.org/netdev/net-next/c/b5d54eb5899a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


