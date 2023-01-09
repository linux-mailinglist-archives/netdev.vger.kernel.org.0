Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952F1661F3F
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 08:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233565AbjAIHai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 02:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbjAIHaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 02:30:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1908C1275A;
        Sun,  8 Jan 2023 23:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DA941CE0EA2;
        Mon,  9 Jan 2023 07:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15AE3C433D2;
        Mon,  9 Jan 2023 07:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673249417;
        bh=ZCUEoA+q5Y84FmkEwkCc0/nI1EnWj90AeV4mz06wEPw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EJtDcDS834gb+MQJViYN6J1w5bmWGQXT4EzMDPi+kZRL243D+uMqGGg61S6jAi/qf
         py4bF3OXFNnZxJhK6ImjDlQimeNmlKpunkmuLLBssfXx1V344Km2iyhHdICnDBg/YS
         501ZTs6m6bToAje3zcKCloVHkBc8Lni+Pq2rnlGMGCOUFBMKcaUP+a+/ptxQuffmGH
         S9NvaECoi+YimZmcKjsk9jXW+1EV64C17m9E5T78XRoW6dnZiAPZc4ZeeV1W/nVEUe
         qAlhjeBHdpmbVZUruM6jbheUmvP58uyRB3myG+svWpeN7u/TyNS5DPYPCFPHPCAmQ6
         y6kBnwZMLTRUA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 02FE7E4D005;
        Mon,  9 Jan 2023 07:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4] usbnet: optimize usbnet_bh() to reduce CPU load
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167324941700.24554.6732820998527805542.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Jan 2023 07:30:17 +0000
References: <20230106104950.22741-1-lsahn@ooseel.net>
In-Reply-To: <20230106104950.22741-1-lsahn@ooseel.net>
To:     Leesoo Ahn <lsahn@ooseel.net>
Cc:     oneukum@suse.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  6 Jan 2023 19:49:49 +0900 you wrote:
> The current source pushes skb into dev-done queue by calling
> skb_dequeue_tail() and then pop it by skb_dequeue() to branch to
> rx_cleanup state for freeing urb/skb in usbnet_bh(). It takes extra CPU
> load, 2.21% (skb_queue_tail) as follows,
> 
> -   11.58%     0.26%  swapper          [k] usbnet_bh
>    - 11.32% usbnet_bh
>       - 6.43% skb_dequeue
>            6.34% _raw_spin_unlock_irqrestore
>       - 2.21% skb_queue_tail
>            2.19% _raw_spin_unlock_irqrestore
>       - 1.68% consume_skb
>          - 0.97% kfree_skbmem
>               0.80% kmem_cache_free
>            0.53% skb_release_data
> 
> [...]

Here is the summary with links:
  - [net-next,v4] usbnet: optimize usbnet_bh() to reduce CPU load
    https://git.kernel.org/netdev/net-next/c/fb59bf28cd63

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


