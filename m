Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81B046C9BD9
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 09:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbjC0HUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 03:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbjC0HUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 03:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805D612D;
        Mon, 27 Mar 2023 00:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1071660FF8;
        Mon, 27 Mar 2023 07:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3BDD7C4339C;
        Mon, 27 Mar 2023 07:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679901618;
        bh=Fmno9IUHFL/QJZTBpdI7jH/KHqpYXwLcCK8t+LApJ4o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l5bV+NYLBrhR08OenBels8TTFjCmkZ+e0XLLHTTqX3K6mqooCMef7QbZrvf1GzKpB
         sHDGPBe1wBi5pAKSgS8JZHzFLeuqTbQj51NsL5BaiV1bHe+r/+xNjhBIqxD8Ez3+is
         ++62mnLEHHHgTJTDzzji9gjnaknpomHmpqAonS09oOu9WAA36uqrIUnu3U+BQhMlOs
         LzRNLeDn5pwwFeio3GAKUoIFWYqwPvJ2qedC/8t++u5MVBjp0Ux0C7uOxgbMl4aXcZ
         zzLqvKzEFW1gqt3tmLDjyYtWgRodFIaMPGka4vo/Cr7Cqo4s7wrStrZDcZwmmBUp0C
         jAM0vmiA+fs8w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1C784E2A038;
        Mon, 27 Mar 2023 07:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] vsock/loopback: use only sk_buff_head.lock to protect the
 packet queue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167990161811.4487.17278563612725612411.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Mar 2023 07:20:18 +0000
References: <20230324115450.11268-1-sgarzare@redhat.com>
In-Reply-To: <20230324115450.11268-1-sgarzare@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, bobby.eshleman@bytedance.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        linux-kernel@vger.kernel.org, avkrasnov@sberdevices.ru,
        kuba@kernel.org, virtualization@lists.linux-foundation.org,
        syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 24 Mar 2023 12:54:50 +0100 you wrote:
> pkt_list_lock was used before commit 71dc9ec9ac7d ("virtio/vsock:
> replace virtio_vsock_pkt with sk_buff") to protect the packet queue.
> After that commit we switched to sk_buff and we are using
> sk_buff_head.lock in almost every place to protect the packet queue
> except in vsock_loopback_work() when we call skb_queue_splice_init().
> 
> As reported by syzbot, this caused unlocked concurrent access to the
> packet queue between vsock_loopback_work() and
> vsock_loopback_cancel_pkt() since it is not holding pkt_list_lock.
> 
> [...]

Here is the summary with links:
  - [net] vsock/loopback: use only sk_buff_head.lock to protect the packet queue
    https://git.kernel.org/netdev/net/c/b465518dc27d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


