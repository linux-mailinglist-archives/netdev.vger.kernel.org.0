Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0B95B0488
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 15:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiIGNAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 09:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiIGNAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 09:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143562B639;
        Wed,  7 Sep 2022 06:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE0A6B81CE0;
        Wed,  7 Sep 2022 13:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 707A0C433B5;
        Wed,  7 Sep 2022 13:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662555618;
        bh=YUbML6SnybUQenPOnS9RUhAv7AHorgG7Ue71eD2KC/I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DwfTtzg3inknXAH7yDs3OKHdlS9PVBq+gBod97j6qG8eJvbg8RHEhncGBW0nTwl2I
         Jcq6VZ9toBNe+rpEDA2uU4UzglW6sZkuqt4znqDR2UfoK0PDNbj9oCXv4qXOIryf+M
         W2uOMIjWsTnI0onAT1uj+RrdopTYrhsRj5AkHU6hT5dlaac5G5CXrYAdIButdPf/mS
         6yOTIjlkmat+xIaG6ajX4rGISml4fW3wDeFDIpuQs4nNdXgwznGmccn4KVztiTK+Y2
         oB90mcIsL3WU3DG/1uSMyVWwFZGc4xaEhRNjglRpBmEEg18Atrbn788dDPy0kDAAD5
         NCj8umWPntiug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 50680E1CABD;
        Wed,  7 Sep 2022 13:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net 0/3] Fixes for Felix DSA driver calculation of
 tc-taprio guard bands
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166255561832.21322.16877680025526013164.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Sep 2022 13:00:18 +0000
References: <20220905170125.1269498-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220905170125.1269498-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, xiaoliang.yang_1@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, michael@walle.cc,
        vinicius.gomes@intel.com, fido_max@inbox.ru,
        colin.foster@in-advantage.com, richard.pearn@nxp.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon,  5 Sep 2022 20:01:22 +0300 you wrote:
> This series fixes some bugs which are not quite new, but date from v5.13
> when static guard bands were enabled by Michael Walle to prevent
> tc-taprio overruns.
> 
> The investigation started when Xiaoliang asked privately what is the
> expected max SDU for a traffic class when its minimum gate interval is
> 10 us. The answer, as it turns out, is not an L1 size of 1250 octets,
> but 1245 octets, since otherwise, the switch will not consider frames
> for egress scheduling, because the static guard band is exactly as large
> as the time interval. The switch needs a minimum of 33 ns outside of the
> guard band to consider a frame for scheduling, and the reduction of the
> max SDU by 5 provides exactly for that.
> 
> [...]

Here is the summary with links:
  - [v2,net,1/3] net: dsa: felix: tc-taprio intervals smaller than MTU should send at least one packet
    https://git.kernel.org/netdev/net/c/11afdc6526de
  - [v2,net,2/3] net: dsa: felix: disable cut-through forwarding for frames oversized for tc-taprio
    https://git.kernel.org/netdev/net/c/843794bbdef8
  - [v2,net,3/3] net: dsa: felix: access QSYS_TAG_CONFIG under tas_lock in vsc9959_sched_speed_set
    https://git.kernel.org/netdev/net/c/a4bb481aeb9d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


