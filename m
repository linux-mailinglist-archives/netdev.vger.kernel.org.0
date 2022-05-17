Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE3A529F50
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 12:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243748AbiEQKWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 06:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344779AbiEQKV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 06:21:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA0530569;
        Tue, 17 May 2022 03:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E460AB81823;
        Tue, 17 May 2022 10:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D6ADC34119;
        Tue, 17 May 2022 10:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652782811;
        bh=nhjvkj3iLWixJ5u1Qchylx98GmsqtSXYDoguwIYIxyY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O24H2hoHfqCzvFjdxlcNkLl8eMY1ZjQkuZlSS2SNeQJWT3DrA+6Rgtn7avtuUxouO
         h8hDn35/tbmkUuWDXo21N0mdXTUreSrWhxcoC9oxjQZM1sUfGrqRiqVkh74/jwPLhO
         dRo9y+TwrhT5kM9xZ6Jbx3eCEvkC2AgP/6qUVxPx1lAjBq6AhPps8LEY99Y8JTUQTs
         cKPU6NYSJtv7VfZFyH+KVlc6CvCq6+YUiXl2+yIdS0GBy8prC9IpKySOXbRLTovrUy
         IZirn+jF+xz4oB0+CcrEWZRKpXRS+oZi49/NyCvQ7bxhDRid7ApHfuvlak6kFRJhFT
         kRakzSmiCNqsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7C630F03935;
        Tue, 17 May 2022 10:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: vmxnet3: fix possible use-after-free bugs in
 vmxnet3_rq_alloc_rx_buf()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165278281150.16356.1881926262371677838.git-patchwork-notify@kernel.org>
Date:   Tue, 17 May 2022 10:20:11 +0000
References: <20220514050656.2636588-1-r33s3n6@gmail.com>
In-Reply-To: <20220514050656.2636588-1-r33s3n6@gmail.com>
To:     Zixuan Fu <r33s3n6@gmail.com>
Cc:     doshir@vmware.com, pv-drivers@vmware.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@gmail.com, oslab@tsinghua.edu.cn
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 14 May 2022 13:06:56 +0800 you wrote:
> In vmxnet3_rq_alloc_rx_buf(), when dma_map_single() fails, rbi->skb is
> freed immediately. Similarly, in another branch, when dma_map_page() fails,
> rbi->page is also freed. In the two cases, vmxnet3_rq_alloc_rx_buf()
> returns an error to its callers vmxnet3_rq_init() -> vmxnet3_rq_init_all()
> -> vmxnet3_activate_dev(). Then vmxnet3_activate_dev() calls
> vmxnet3_rq_cleanup_all() in error handling code, and rbi->skb or rbi->page
> are freed again in vmxnet3_rq_cleanup_all(), causing use-after-free bugs.
> 
> [...]

Here is the summary with links:
  - [v3] net: vmxnet3: fix possible use-after-free bugs in vmxnet3_rq_alloc_rx_buf()
    https://git.kernel.org/netdev/net/c/9e7fef9521e7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


