Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564346E434E
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 11:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjDQJKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 05:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjDQJKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 05:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1D7184;
        Mon, 17 Apr 2023 02:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC2076108F;
        Mon, 17 Apr 2023 09:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 30B5CC433A4;
        Mon, 17 Apr 2023 09:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681722618;
        bh=s1LfW34HbO3mT+PyzMnStn20sJg5U9nSWN5qtvT69JY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Zgsun1SGdjzkxtKRMjor6dPsQMVH+IXC7yenEe5lGj24688Zhc7n9O+Cza3YahPWi
         MjqIkDLLUQbNUHx2W6IYXKkxn3xeTIeeP3UdOG+YFEk3snG34HGn/LIQkm3AoSfaMI
         PZr3zuonPXsPjes60ngUCQqbKWUAQPsqQwvIdCu13fJKxxfRINOWjgiMW760wXsMkm
         QJck+6ptDLUch3dsoWU7cxHu30qTubjoxZj198VUA1n/GgNuKYTQVu7bPFuQOKm7vN
         QahiwiL9mqRfBqpsVXSX3iU1XLdTogh9QNitcmaBoo0xFxAfEHHOfYiPnG/NigW7Qk
         AbvDU5P09pqtA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1CD2AC41671;
        Mon, 17 Apr 2023 09:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: lan966x: Fix lan966x_ifh_get
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168172261811.15038.16817506134246083611.git-patchwork-notify@kernel.org>
Date:   Mon, 17 Apr 2023 09:10:18 +0000
References: <20230417072641.1656960-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230417072641.1656960-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com,
        aleksander.lobakin@intel.com
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

On Mon, 17 Apr 2023 09:26:41 +0200 you wrote:
> From time to time, it was observed that the nanosecond part of the
> received timestamp, which is extracted from the IFH, it was actually
> bigger than 1 second. So then when actually calculating the full
> received timestamp, based on the nanosecond part from IFH and the second
> part which is read from HW, it was actually wrong.
> 
> The issue seems to be inside the function lan966x_ifh_get, which
> extracts information from an IFH(which is an byte array) and returns the
> value in a u64. When extracting the timestamp value from the IFH, which
> starts at bit 192 and have the size of 32 bits, then if the most
> significant bit was set in the timestamp, then this bit was extended
> then the return value became 0xffffffff... . And the reason of this is
> because constants without any postfix are treated as signed longs and
> that is the reason why '1 << 31' becomes 0xffffffff80000000.
> This is fixed by adding the postfix 'ULL' to 1.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: lan966x: Fix lan966x_ifh_get
    https://git.kernel.org/netdev/net-next/c/99676a576641

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


