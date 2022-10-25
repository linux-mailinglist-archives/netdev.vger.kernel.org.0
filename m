Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562D560C27B
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 06:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiJYEKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 00:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJYEKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 00:10:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957FE1211C7;
        Mon, 24 Oct 2022 21:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D9CCB819EE;
        Tue, 25 Oct 2022 04:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E75D5C433B5;
        Tue, 25 Oct 2022 04:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666671016;
        bh=1kc/oco0AWq8/8y4+ZileiMvxdlcuOi0ziZDWhTNb0I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vJQmCQul8LkGiU2yJJ9rIiobCqn8ALOE7iLthDt2xTYHLewfl5Hx9v/wUfg3QzA1Y
         vC8BOXfvsL7pLTtH+ERuMAFpRS3klQs0WiJWlDKxTzDyWLZC5H8cDK5efHUYbfNmO9
         unJ3u2GJ+/3l639a3P4FaLD23Hq1uwclyPL1JuK2spdEBhEm2CWBA7wS8pR89R6o6P
         QF5YSflCrcwxevQUPAYVVsuf3+mhM8572xC7DGade5wTyqtBqQ6/3maitALOS0blGv
         9tTJyVfasmXbykUfKHSczfwc6Mafc7jdXaOwfPxg24IWeFlO0J6oT7ejNHovR7Fdg+
         XH4ANnP8zEMVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C4280E270DD;
        Tue, 25 Oct 2022 04:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: lan966x: Stop replacing tx dcbs and dcbs_buf when
 changing MTU
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166667101579.1819.16740602296394570819.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Oct 2022 04:10:15 +0000
References: <20221021090711.3749009-1-horatiu.vultur@microchip.com>
In-Reply-To: <20221021090711.3749009-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 21 Oct 2022 11:07:11 +0200 you wrote:
> When a frame is sent using FDMA, the skb is mapped and then the mapped
> address is given to an tx dcb that is different than the last used tx
> dcb. Once the HW finish with this frame, it would generate an interrupt
> and then the dcb can be reused and memory can be freed. For each dcb
> there is an dcb buf that contains some meta-data(is used by PTP, is
> it free). There is 1 to 1 relationship between dcb and dcb_buf.
> The following issue was observed. That sometimes after changing the MTU
> to allocate new tx dcbs and dcbs_buf, two frames were not
> transmitted. The frames were not transmitted because when reloading the
> tx dcbs, it was always presuming to use the first dcb but that was not
> always happening. Because it could be that the last tx dcb used before
> changing MTU was first dcb and then when it tried to get the next dcb it
> would take dcb 1 instead of 0. Because it is supposed to take a
> different dcb than the last used one. This can be fixed simply by
> changing tx->last_in_use to -1 when the fdma is disabled to reload the
> new dcb and dcbs_buff.
> But there could be a different issue. For example, right after the frame
> is sent, the MTU is changed. Now all the dcbs and dcbs_buf will be
> cleared. And now get the interrupt from HW that it finished with the
> frame. So when we try to clear the skb, it is not possible because we
> lost all the dcbs_buf.
> The solution here is to stop replacing the tx dcbs and dcbs_buf when
> changing MTU because the TX doesn't care what is the MTU size, it is
> only the RX that needs this information.
> 
> [...]

Here is the summary with links:
  - [net] net: lan966x: Stop replacing tx dcbs and dcbs_buf when changing MTU
    https://git.kernel.org/netdev/net/c/4a4b6848d1e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


