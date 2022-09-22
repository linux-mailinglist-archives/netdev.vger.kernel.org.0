Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A22975E5854
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 04:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiIVCAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 22:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiIVCAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 22:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB01F6AA1D
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 19:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE3B362355
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 02:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D186C433D6;
        Thu, 22 Sep 2022 02:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663812017;
        bh=sOxZSGN1m7wU/N0C7OkK8lUBcYZUQHN62+lwO7Zxq4Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KDVvo07juMLaaFmV42wVLkmXluZW8AB7EI10Oeo6E+Jo6hft2FjdURs4xSN0cwGwO
         44U357aDcLN2FGNKN1g5gEwR/lMeoMSlRe3iUY5n/DQ1qBh/HUn24ZQjzX4ecp1z+n
         oqP1Ni3QqDvIxJBcnmcPCSWO1wLaUW6xsTrO11X7dM0CXlXFBLVEFNhP5m1o0q0Wle
         wyJn5sj6URWiUNXdTm3j5lMylkUUy0SzuuUYcuC+DmH+HeBgwphfS0dDAhiWxa2vVB
         eXNs24toHhJRFm3Sng5r+nxK6zQw87XzKfHA1wIUnuQA14gvNPsmUO7dtfFtqad5uW
         8HW8xxYVx0yMw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 15165E21ECF;
        Thu, 22 Sep 2022 02:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] flow_dissector: Do not count vlan tags inside tunnel payload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166381201707.16388.1468731298104125114.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 02:00:17 +0000
References: <20220919074808.136640-1-qingqing.yang@broadcom.com>
In-Reply-To: <20220919074808.136640-1-qingqing.yang@broadcom.com>
To:     Qingqing Yang <qingqing.yang@broadcom.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, boris.sukholitko@broadcom.com,
        kurt@linutronix.de, f.fainelli@gmail.com, paulb@nvidia.com,
        wojciech.drewek@intel.com, komachi.yoshiki@gmail.com,
        ludovic.cintrat@gatewatcher.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 19 Sep 2022 15:48:08 +0800 you wrote:
> We've met the problem that when there is a vlan tag inside
> GRE encapsulation, the match of num_of_vlans fails.
> It is caused by the vlan tag inside GRE payload has been
> counted into num_of_vlans, which is not expected.
> 
> One example packet is like this:
> Ethernet II, Src: Broadcom_68:56:07 (00:10:18:68:56:07)
>                    Dst: Broadcom_68:56:08 (00:10:18:68:56:08)
> 802.1Q Virtual LAN, PRI: 0, DEI: 0, ID: 100
> Internet Protocol Version 4, Src: 192.168.1.4, Dst: 192.168.1.200
> Generic Routing Encapsulation (Transparent Ethernet bridging)
> Ethernet II, Src: Broadcom_68:58:07 (00:10:18:68:58:07)
>                    Dst: Broadcom_68:58:08 (00:10:18:68:58:08)
> 802.1Q Virtual LAN, PRI: 0, DEI: 0, ID: 200
> ...
> It should match the (num_of_vlans 1) rule, but it matches
> the (num_of_vlans 2) rule.
> 
> [...]

Here is the summary with links:
  - flow_dissector: Do not count vlan tags inside tunnel payload
    https://git.kernel.org/netdev/net-next/c/9f87eb424699

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


