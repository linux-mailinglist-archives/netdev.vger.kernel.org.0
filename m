Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662C363319A
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 01:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbiKVAuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 19:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiKVAuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 19:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C69F4044E;
        Mon, 21 Nov 2022 16:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B350260A51;
        Tue, 22 Nov 2022 00:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 100CFC433C1;
        Tue, 22 Nov 2022 00:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669078216;
        bh=oaaCKCKoyoc+e6B4sa8JTeueW5S4WbjiWN/m/BqMr4o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gSngKmUoadOgDoqdy2eGUF0ondlWkpp6BY07Kj720aiC+it12iCp5QipY0JpHgjwC
         QiDjsxqlwtCcVU9w9ho20/FK8kuECsx55OAbaje+mYPbkqC5MAllEFQbOBZph0EUE9
         jAb3FbxgNY+66Tf/nkoB07xN/G2KdET7QJn1RK8ytvRG7yCaVaGH4qAq3UFzEhfP2n
         23ezwp+psNj7grcV2OZlDYz9FAi+U0rYOkMgM57i3QwVWRw86VtMJYFqhgZH8/R2jZ
         gcr5FypkD0F68ZMayVP+ajZlERxcyQWbbr3256+7kZZuW+nBn+RG8GlisUVHS4lBTd
         PL4lawWrgqkJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E4A81E29F3E;
        Tue, 22 Nov 2022 00:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Bluetooth: L2CAP: Fix u8 overflow
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <166907821592.6181.15285782519233443066.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Nov 2022 00:50:15 +0000
References: <20221118200145.1741199-1-iam@sung-woo.kim>
In-Reply-To: <20221118200145.1741199-1-iam@sung-woo.kim>
To:     Sungwoo Kim <iam@sung-woo.kim>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Fri, 18 Nov 2022 15:01:47 -0500 you wrote:
> By keep sending L2CAP_CONF_REQ packets, chan->num_conf_rsp increases
> multiple times and eventually it will wrap around the maximum number
> (i.e., 255).
> This patch prevents this by adding a boundary check with
> L2CAP_MAX_CONF_RSP
> 
> Btmon log:
> Bluetooth monitor ver 5.64
> = Note: Linux version 6.1.0-rc2 (x86_64)                               0.264594
> = Note: Bluetooth subsystem version 2.22                               0.264636
> @ MGMT Open: btmon (privileged) version 1.22                  {0x0001} 0.272191
> = New Index: 00:00:00:00:00:00 (Primary,Virtual,hci0)          [hci0] 13.877604
> @ RAW Open: 9496 (privileged) version 2.22                   {0x0002} 13.890741
> = Open Index: 00:00:00:00:00:00                                [hci0] 13.900426
> (...)
> > ACL Data RX: Handle 200 flags 0x00 dlen 1033             #32 [hci0] 14.273106
>         invalid packet size (12 != 1033)
>         08 00 01 00 02 01 04 00 01 10 ff ff              ............
> > ACL Data RX: Handle 200 flags 0x00 dlen 1547             #33 [hci0] 14.273561
>         invalid packet size (14 != 1547)
>         0a 00 01 00 04 01 06 00 40 00 00 00 00 00        ........@.....
> > ACL Data RX: Handle 200 flags 0x00 dlen 2061             #34 [hci0] 14.274390
>         invalid packet size (16 != 2061)
>         0c 00 01 00 04 01 08 00 40 00 00 00 00 00 00 04  ........@.......
> > ACL Data RX: Handle 200 flags 0x00 dlen 2061             #35 [hci0] 14.274932
>         invalid packet size (16 != 2061)
>         0c 00 01 00 04 01 08 00 40 00 00 00 07 00 03 00  ........@.......
> = bluetoothd: Bluetooth daemon 5.43                                   14.401828
> > ACL Data RX: Handle 200 flags 0x00 dlen 1033             #36 [hci0] 14.275753
>         invalid packet size (12 != 1033)
>         08 00 01 00 04 01 04 00 40 00 00 00              ........@...
> 
> [...]

Here is the summary with links:
  - Bluetooth: L2CAP: Fix u8 overflow
    https://git.kernel.org/bluetooth/bluetooth-next/c/ae4569813a6e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


