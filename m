Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5B634E2E81
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 17:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350310AbiCUQvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 12:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238378AbiCUQvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 12:51:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB095AED9
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 09:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54663B81890
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 16:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 05E1BC340F2;
        Mon, 21 Mar 2022 16:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647881411;
        bh=KLINMYNyq1Cco7DS0TNTOv2cLWiwGUh2B8jAsCus97A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PdeXx6l5Qs00XsiQMarVZbKkwK2o85WHFUQoI20XEVXt5DTszZ+ca1rIuFWWMIF5N
         M7wOUypx6H815DHEDALvHReQLOC5B1/vQJUqJeHIlZV7459MrmZHXuGFRemsCOmW+P
         3WnomHE6sA0cLEmbEgTPXpJCMlB83OwHUEbIHkXZU6rzGKfHCXl4OFqhCvHACkflrM
         ABqLH5RNdkAolTV/8NLbe431LRJ+GZJbuVoTDFXUpXUfxybQ0PfqGdzOTr+VTR5siX
         qBvkd1roJkKlW49kAf+YwBnFiFK8Hvd1x7c6d+uzwptYiFGNQsz4gxL7+xr7RZ841A
         btlUR0U2grrbQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D78E4EAC09C;
        Mon, 21 Mar 2022 16:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/5] devlink: hold the instance lock in eswitch
 callbacks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164788141087.8756.4036477791453541767.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Mar 2022 16:50:10 +0000
References: <20220318192344.1587891-1-kuba@kernel.org>
In-Reply-To: <20220318192344.1587891-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@resnulli.us,
        leonro@nvidia.com, saeedm@nvidia.com, idosch@idosch.org,
        michael.chan@broadcom.com, simon.horman@corigine.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 18 Mar 2022 12:23:39 -0700 you wrote:
> Series number 2 in the effort to hold the devlink instance lock
> in call driver callbacks. We have the following drivers using
> this API:
> 
>  - bnxt, nfp, netdevsim - their own locking is removed / simplified
>    by this series; all of them needed a lock to protect from changes
>    to the number of VFs while switching modes, now the VF config bus
>    callback takes the devlink instance lock via devl_lock();
>  - ice - appears not to allow changing modes while SR-IOV enabled,
>    so nothing to do there;
>  - liquidio - does not contain any locking;
>  - octeontx2/af - is very special but at least doesn't have locking
>    so doesn't get in the way either;
>  - mlx5 has a wealth of locks - I chickened out and dropped the lock
>    in the callbacks so that I can leave the driver be, for now.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/5] bnxt: use the devlink instance lock to protect sriov
    https://git.kernel.org/netdev/net-next/c/7a1b0b1a555e
  - [net-next,v2,2/5] devlink: add explicitly locked flavor of the rate node APIs
    https://git.kernel.org/netdev/net-next/c/8879b32a3a80
  - [net-next,v2,3/5] netdevsim: replace port_list_lock with devlink instance lock
    https://git.kernel.org/netdev/net-next/c/76eea6c2e663
  - [net-next,v2,4/5] netdevsim: replace vfs_lock with devlink instance lock
    https://git.kernel.org/netdev/net-next/c/aff3a9250946
  - [net-next,v2,5/5] devlink: hold the instance lock during eswitch_mode callbacks
    https://git.kernel.org/netdev/net-next/c/14e426bf1a4d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


