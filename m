Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F74A4C5A98
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 12:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbiB0LK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 06:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiB0LKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 06:10:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B14A5B3C7
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 03:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67BC7B80B96
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 11:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 052CDC340F0;
        Sun, 27 Feb 2022 11:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645960215;
        bh=FEIYGSY6saJixV62WvyP9QBLDnN+5NPx6a3gdCGVNEw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sl8h2avioUn2MaPzuXTjVKoCPN/3J5ZYob/qhVj7OhBnt/n2pu3G0sLReF4pdOhJg
         oVYUxZQvkQSIJwPzteHFf95eW6YwIvCv3XSERBKExVXqqClki5Nc3Hz3pxTOQytEjI
         ao/ZeV+1umib/aL8PXK/Aog86pgQl2ynEN0rTGJZ+vkeCW1t9rzqdikA9QM6jynuf7
         cqFjfjN8bwzjV/bBAzsxlya/CJi5HgHUq4DkZrf9xIL5w2QIebNfmBkcV0pfO+4NTn
         hYDVVhyP8rBVcbMUBh4JxZa/CjU7KxEFi55HuXR2isHd7kfUhnSthEHtxsepIblvq9
         TLr9KKCZfYzUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DDBCAEAC081;
        Sun, 27 Feb 2022 11:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 00/10] DSA FDB isolation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164596021490.1414.6291195308160851459.git-patchwork-notify@kernel.org>
Date:   Sun, 27 Feb 2022 11:10:14 +0000
References: <20220225092225.594851-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220225092225.594851-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, kurt@linutronix.de, hauke@hauke-m.de,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com, dqfext@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        linus.walleij@linaro.org, alsi@bang-olufsen.dk,
        george.mccollister@gmail.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 25 Feb 2022 11:22:15 +0200 you wrote:
> There are use cases which need FDB isolation between standalone ports
> and bridged ports, as well as isolation between ports of different
> bridges. Most of these use cases are a result of the fact that packets
> can now be partially forwarded by the software bridge, so one port might
> need to send a packet to the CPU but its FDB lookup will see that it can
> forward it directly to a bridge port where that packet was autonomously
> learned. So the source port will attempt to shortcircuit the CPU and
> forward autonomously, which it can't due to the forwarding isolation we
> have in place. So we will have packet drops instead of proper operation.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,01/10] net: dsa: tag_8021q: replace the SVL bridging with VLAN-unaware IVL bridging
    https://git.kernel.org/netdev/net-next/c/91495f21fcec
  - [v2,net-next,02/10] net: dsa: tag_8021q: add support for imprecise RX based on the VBID
    https://git.kernel.org/netdev/net-next/c/d7f9787a763f
  - [v2,net-next,03/10] docs: net: dsa: sja1105: document limitations of tc-flower rule VLAN awareness
    https://git.kernel.org/netdev/net-next/c/d27656d02d85
  - [v2,net-next,04/10] net: dsa: felix: delete workarounds present due to SVL tag_8021q bridging
    https://git.kernel.org/netdev/net-next/c/08f44db3abe6
  - [v2,net-next,05/10] net: dsa: tag_8021q: merge RX and TX VLANs
    https://git.kernel.org/netdev/net-next/c/04b67e18ce5b
  - [v2,net-next,06/10] net: dsa: tag_8021q: rename dsa_8021q_bridge_tx_fwd_offload_vid
    https://git.kernel.org/netdev/net-next/c/b6362bdf750b
  - [v2,net-next,07/10] net: dsa: request drivers to perform FDB isolation
    https://git.kernel.org/netdev/net-next/c/c26933639b54
  - [v2,net-next,08/10] net: dsa: pass extack to .port_bridge_join driver methods
    https://git.kernel.org/netdev/net-next/c/06b9cce42634
  - [v2,net-next,09/10] net: dsa: sja1105: enforce FDB isolation
    https://git.kernel.org/netdev/net-next/c/219827ef92f8
  - [v2,net-next,10/10] net: mscc: ocelot: enforce FDB isolation when VLAN-unaware
    https://git.kernel.org/netdev/net-next/c/54c319846086

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


