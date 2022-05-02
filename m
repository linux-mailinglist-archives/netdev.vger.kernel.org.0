Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81B76517A81
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 01:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbiEBXOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 19:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbiEBXNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 19:13:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299B8BAE;
        Mon,  2 May 2022 16:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A772D6125B;
        Mon,  2 May 2022 23:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F27F8C385B3;
        Mon,  2 May 2022 23:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651533012;
        bh=h+9vyutzFn0vqwBNUHVZL/aCACh4zO9RWy2rKMlvYQU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ShtibUKqD964y6v0TjaDpNmJRvwI4HAi73rF8lTBYQqTB6yxyps2tTmvRRpcKN7Rm
         LR4gvtEunHS/9ekucdUy0pyqlsRdT1bYGhxMi5p9jjh24ptdS7fOY3qU+ad6kDw8Hw
         qb1JN0WyzneyCz2aRmLwrtEosO5VnAfZROAWw64JdDsY+lHF1tTXDM/RQQ1lwDVYZ2
         HN44SambEwndvIumZQaGgL22rTppcjgHfUIPLek/7Zhq/BV9KVWsey/RlLlzWhJaPB
         49ABWz2WS9Cqt40NQBYpmGCpKMEY2mOxI2mlyRRNLmTri05wGyqBJ2t1GXMIi2T5kE
         7ZtwqO7U9Gk2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C0E22F03847;
        Mon,  2 May 2022 23:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] selftests: forwarding: add Per-Stream Filtering
 and Policing test for Ocelot
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165153301178.26672.6286318277147064633.git-patchwork-notify@kernel.org>
Date:   Mon, 02 May 2022 23:10:11 +0000
References: <20220501112953.3298973-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220501112953.3298973-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        vinicius.gomes@intel.com, gerhard@engleder-embedded.com,
        yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        richardcochran@gmail.com, bigeasy@linutronix.de,
        kurt@linutronix.de, yannick.vignon@nxp.com, rui.sousa@nxp.com,
        jiri@nvidia.com, idosch@nvidia.com,
        linux-kselftest@vger.kernel.org, shuah@kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  1 May 2022 14:29:53 +0300 you wrote:
> The Felix VSC9959 switch in NXP LS1028A supports the tc-gate action
> which enforced time-based access control per stream. A stream as seen by
> this switch is identified by {MAC DA, VID}.
> 
> We use the standard forwarding selftest topology with 2 host interfaces
> and 2 switch interfaces. The host ports must require timestamping non-IP
> packets and supporting tc-etf offload, for isochron to work. The
> isochron program monitors network sync status (ptp4l, phc2sys) and
> deterministically transmits packets to the switch such that the tc-gate
> action either (a) always accepts them based on its schedule, or
> (b) always drops them.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] selftests: forwarding: add Per-Stream Filtering and Policing test for Ocelot
    https://git.kernel.org/netdev/net-next/c/954f46d2f0b4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


