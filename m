Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263F26E2053
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 12:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjDNKKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 06:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjDNKKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 06:10:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B83D9028;
        Fri, 14 Apr 2023 03:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BF1C64626;
        Fri, 14 Apr 2023 10:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B8E4C4339B;
        Fri, 14 Apr 2023 10:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681467018;
        bh=6vFCtZdLswTTngNOHSWwKa2cqJCsc1kWkahPU6fh2IA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XTMCjyPzrz6aDFgnkhP9KSQ7vt+L9iUkAwmdUMISGkre3YgGlOrKzvpQ6nR8DUIvG
         qK55a4fzU16WGRvze9wLIsPEMOM8EYD+JjmR9BHTTHiYL8mp2JUQ2H6dH5gGzr5a87
         coRENjdodA7ZB06nK6FQ7gPD0N8CK2OFBUl9n75rbBzrZ/AWkocpzjREZOO4H7Wx4w
         Kh8WBoYh1QV5csblMgGT1CqAKxX5+96g21LkZpNBJz/nbiWfaGM7/Ns3Io3XOjooDW
         cM2xMRbs72LNGH1NxUkxaU6wf45p+R9g4uNuwPvkgCp6S8MGxYOFaxDSrfhSGR4vei
         jZLeg7N1Y0N9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 73429E29F3B;
        Fri, 14 Apr 2023 10:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1] vsock/loopback: don't disable irqs for queue
 access
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168146701846.23331.1103536295768648716.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Apr 2023 10:10:18 +0000
References: <a4f17ab9-4be9-1b0a-0fc0-9fa8ef98273d@sberdevices.ru>
In-Reply-To: <a4f17ab9-4be9-1b0a-0fc0-9fa8ef98273d@sberdevices.ru>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        bobby.eshleman@bytedance.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
        oxffffaa@gmail.com, avkrasnov@sberdevices.ru
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 13 Apr 2023 12:17:19 +0300 you wrote:
> This replaces 'skb_queue_tail()' with 'virtio_vsock_skb_queue_tail()'.
> The first one uses 'spin_lock_irqsave()', second uses 'spin_lock_bh()'.
> There is no need to disable interrupts in the loopback transport as
> there is no access to the queue with skbs from interrupt context. Both
> virtio and vhost transports work in the same way.
> 
> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v1] vsock/loopback: don't disable irqs for queue access
    https://git.kernel.org/netdev/net-next/c/eaaa4e923979

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


