Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7474B681CC2
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 22:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbjA3VaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 16:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjA3VaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 16:30:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842C57A81;
        Mon, 30 Jan 2023 13:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2564761277;
        Mon, 30 Jan 2023 21:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 836EFC433EF;
        Mon, 30 Jan 2023 21:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675114217;
        bh=ulyw9BIgxWYs3vHIMq6qyhrOmR/0sxf0KvN29c7Q2MA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TrGIvymMtkOvIfvESNd/A2qfLOBWuPwWc7UJIzQVmyWGlYBPJ7GJNwl7ANSp698+D
         uSSBUbvBaPR6cyrSRz3P3BX3M7DJti+gJkiaG+/uxm9WQ6ADksxeeC9YPxV2gVYIqT
         LLYaNQs039X4tTF6W9UIhtjaRcpmjiBGUekcpYMl0SlRfK+HXAXgXLT7QNmAtT+xY9
         XDRb9maJZcy54O0jBnuCrXKHdfYwwEjZEe5jJQ/r7KeiWdGDtNAnCibrXjbr4R0LbB
         VDC36O/ddaQfRYtOIdx0uNSO8XBFPHMo/Zi3lSnfeBD5fngN9sh1vxLAUREycY/4dk
         51jNhVXgdghlQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 64003E4D014;
        Mon, 30 Jan 2023 21:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Bluetooth: hci_conn: Refactor hci_bind_bis() since it always
 succeeds
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <167511421740.28875.16343473654299319606.git-patchwork-notify@kernel.org>
Date:   Mon, 30 Jan 2023 21:30:17 +0000
References: <20230128005150.never.909-kees@kernel.org>
In-Reply-To: <20230128005150.never.909-kees@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     luiz.von.dentz@intel.com, marcel@holtmann.org,
        johan.hedberg@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        luiz.dentz@gmail.com, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Fri, 27 Jan 2023 16:51:54 -0800 you wrote:
> The compiler thinks "conn" might be NULL after a call to hci_bind_bis(),
> which cannot happen. Avoid any confusion by just making it not return a
> value since it cannot fail. Fixes the warnings seen with GCC 13:
> 
> In function 'arch_atomic_dec_and_test',
>     inlined from 'atomic_dec_and_test' at ../include/linux/atomic/atomic-instrumented.h:576:9,
>     inlined from 'hci_conn_drop' at ../include/net/bluetooth/hci_core.h:1391:6,
>     inlined from 'hci_connect_bis' at ../net/bluetooth/hci_conn.c:2124:3:
> ../arch/x86/include/asm/rmwcc.h:37:9: warning: array subscript 0 is outside array bounds of 'atomic_t[0]' [-Warray-bounds=]
>    37 |         asm volatile (fullop CC_SET(cc) \
>       |         ^~~
> ...
> In function 'hci_connect_bis':
> cc1: note: source object is likely at address zero
> 
> [...]

Here is the summary with links:
  - Bluetooth: hci_conn: Refactor hci_bind_bis() since it always succeeds
    https://git.kernel.org/bluetooth/bluetooth-next/c/d57d873e6851

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


