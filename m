Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E166D62CB
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 15:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbjDDNa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 09:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbjDDNaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 09:30:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D7B3C02
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 06:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89427633C8
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 13:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E14A3C433EF;
        Tue,  4 Apr 2023 13:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680615017;
        bh=E8Tcbp9stxnWW3xTsThHXCOeOwIS2QhmbKP94HICSFs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A6svCF94tn2N3Rae804LvcNES/2PG0qA3YVH1czm75cJxhgFMUKOj5H5+cWXOmI7n
         V3A1r0fLolSsgMNR1NIhboqceb4jiWCkZ64i0wz0VcHjjYyrzWQ9M9vEQrPk+ztoFB
         Cy8aHGnAIygeRC2HImvade6uDFFR+yZcEIa4sumlbaqyAfjkB93VYt4s9Hb4q+8No/
         XZFudPVj+PoRyaiG7mA+tE9tHcRONzWHpQrD4YgNxg+z9djxHuEU3vUtWaXl3vlpH6
         VF52khT18RQMKeigghah92iwaeA3j/PEskoA1wmJzfv2LT7D2he3N3ulSUSf+AAZ92
         B4XBye5dqgZMA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C7A02E5EA89;
        Tue,  4 Apr 2023 13:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: stmmac: fix up RX flow hash indirection table
 when setting channels
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168061501781.4633.8487272906411516809.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Apr 2023 13:30:17 +0000
References: <20230403121120.489138-1-vinschen@redhat.com>
In-Reply-To: <20230403121120.489138-1-vinschen@redhat.com>
To:     Corinna Vinschen <vinschen@redhat.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon,  3 Apr 2023 14:11:20 +0200 you wrote:
> stmmac_reinit_queues() fails to fix up the RX hash.  Even if the number
> of channels gets restricted, the output of `ethtool -x' indicates that
> all RX queues are used:
> 
>   $ ethtool -l enp0s29f2
>   Channel parameters for enp0s29f2:
>   Pre-set maximums:
>   RX:		8
>   TX:		8
>   Other:		n/a
>   Combined:	n/a
>   Current hardware settings:
>   RX:		8
>   TX:		8
>   Other:		n/a
>   Combined:	n/a
>   $ ethtool -x enp0s29f2
>   RX flow hash indirection table for enp0s29f2 with 8 RX ring(s):
>       0:      0     1     2     3     4     5     6     7
>       8:      0     1     2     3     4     5     6     7
>   [...]
>   $ ethtool -L enp0s29f2 rx 3
>   $ ethtool -x enp0s29f2
>   RX flow hash indirection table for enp0s29f2 with 3 RX ring(s):
>       0:      0     1     2     3     4     5     6     7
>       8:      0     1     2     3     4     5     6     7
>   [...]
> 
> [...]

Here is the summary with links:
  - [v2,net] net: stmmac: fix up RX flow hash indirection table when setting channels
    https://git.kernel.org/netdev/net/c/218c597325f4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


