Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428F34F93AA
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 13:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiDHLWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 07:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbiDHLWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 07:22:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4083184B48
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 04:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C2A261F83
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 11:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84CA9C385B5;
        Fri,  8 Apr 2022 11:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649416813;
        bh=Zl4SkAZTtG+WTS4yL03lP8TgACQI6DXcYx0KTXQznWY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aOAhN8ww8e6fkM5QUXTI2D18vdbU+VD03hMJLef9QlST6gAaTaf8iBX7UeU23HR0a
         9C75pFki5RS12DEjGZzWcJWvlfGCiGm2EQudN3NltdkfpjLCNIEWMHamIKtdie+ePK
         d84jkLhLVNNbKJ5Gcr4rHB731ybL7BZkm9Ep414b+g0QFh2V+f7zcROCwuK+CDZnn5
         6LX1ag0kZXGwf93opclGJo+VnTU4pqgbxPUpcnpP9nio4V9g+Si/Ff7aNlNh293Vrz
         0aGWKNlceNU6ZHwrhBi/ql4Gk7TzrvLUPtBn3O7fnTzApk4jTcstZmKnAFMQrPscbZ
         XshK57U/NgrIA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3ECFDE8DCCE;
        Fri,  8 Apr 2022 11:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: flower: fix parsing of ethertype following
 VLAN header
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164941681325.25766.1593668124886878009.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 11:20:13 +0000
References: <20220406112241.724452-1-vladbu@nvidia.com>
In-Reply-To: <20220406112241.724452-1-vladbu@nvidia.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, jiri@resnulli.us, netdev@vger.kernel.org,
        maord@nvidia.com, jiri@nvidia.com
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 6 Apr 2022 14:22:41 +0300 you wrote:
> A tc flower filter matching TCA_FLOWER_KEY_VLAN_ETH_TYPE is expected to
> match the L2 ethertype following the first VLAN header, as confirmed by
> linked discussion with the maintainer. However, such rule also matches
> packets that have additional second VLAN header, even though filter has
> both eth_type and vlan_ethtype set to "ipv4". Looking at the code this
> seems to be mostly an artifact of the way flower uses flow dissector.
> First, even though looking at the uAPI eth_type and vlan_ethtype appear
> like a distinct fields, in flower they are all mapped to the same
> key->basic.n_proto. Second, flow dissector skips following VLAN header as
> no keys for FLOW_DISSECTOR_KEY_CVLAN are set and eventually assigns the
> value of n_proto to last parsed header. With these, such filters ignore any
> headers present between first VLAN header and first "non magic"
> header (ipv4 in this case) that doesn't result
> FLOW_DISSECT_RET_PROTO_AGAIN.
> 
> [...]

Here is the summary with links:
  - [net] net/sched: flower: fix parsing of ethertype following VLAN header
    https://git.kernel.org/netdev/net/c/2105f700b53c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


