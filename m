Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B3152E1BD
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344398AbiETBLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344416AbiETBK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:10:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE04F13B8DD;
        Thu, 19 May 2022 18:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56091B8297A;
        Fri, 20 May 2022 01:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CDE3EC385B8;
        Fri, 20 May 2022 01:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653009017;
        bh=zKDszjw+FQvQwJMRAb9Fclk+cN7VO6xEcSjWwsNYDtE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mK7k1ZsCOUHvcC7NHhWNX9Xc4C1s17Bp42Tx1SoX3pv+B5NcXYFYjoFjjXpyBZzQR
         3wrOyMVnwtoJa4ij1z2Flqsx114w7shjO/zczDeFAvbKK3rOigfn2Sw6nHedNGc6G4
         9/raNsZmZhd2hDI4lOj8GyUhgkeHjYg7ZGk6KOvr6i2p1M8YNv1PSFcJ+HDwiY8Qp6
         /JWWjNrSX+2ttNIspaaNElruetnRtBWnJ9cdyngyE9jlTOtkxb+Tv/M8GsL0PSNu8x
         Kr7sAuptLM2qgGSXOT44h+wZB67i0Gxu/8acgOqKcrVHdcHhHOJs8vg+E+G5O2OGmk
         B0P7fAF7u3vAA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B2F6EF0389D;
        Fri, 20 May 2022 01:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] NFC: hci: fix sleep in atomic context bugs in
 nfc_hci_hcp_message_tx
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165300901772.19017.10175085376155326113.git-patchwork-notify@kernel.org>
Date:   Fri, 20 May 2022 01:10:17 +0000
References: <20220518115733.62111-1-duoming@zju.edu.cn>
In-Reply-To: <20220518115733.62111-1-duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 18 May 2022 19:57:33 +0800 you wrote:
> There are sleep in atomic context bugs when the request to secure
> element of st21nfca is timeout. The root cause is that kzalloc and
> alloc_skb with GFP_KERNEL parameter and mutex_lock are called in
> st21nfca_se_wt_timeout which is a timer handler. The call tree shows
> the execution paths that could lead to bugs:
> 
>    (Interrupt context)
> st21nfca_se_wt_timeout
>   nfc_hci_send_event
>     nfc_hci_hcp_message_tx
>       kzalloc(..., GFP_KERNEL) //may sleep
>       alloc_skb(..., GFP_KERNEL) //may sleep
>       mutex_lock() //may sleep
> 
> [...]

Here is the summary with links:
  - [net,v3] NFC: hci: fix sleep in atomic context bugs in nfc_hci_hcp_message_tx
    https://git.kernel.org/netdev/net/c/b413b0cb0086

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


