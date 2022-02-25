Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8B34C42A0
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 11:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239720AbiBYKko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 05:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239709AbiBYKkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 05:40:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCB568F8F;
        Fri, 25 Feb 2022 02:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A6CE6171B;
        Fri, 25 Feb 2022 10:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AEFA2C340F2;
        Fri, 25 Feb 2022 10:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645785610;
        bh=1Bj4E8jna9gv+7NmgSy2dvDNmaH/RWmUnYnExJ1EXXU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=naGEzD/RpkgtsDTe3JbpvxClxahzdvbXym5agxbwVk/p1LYOffGh3xFaC33lapix+
         oUNVFd5208INQsRMIzfwZmVb3gw7bbFvQqQzeWTKQsvSkrXuNmNlYe7TWushWj5fPx
         Afg6Iv4HP44YZcoF6kC5Je/Ulflv37WObaf7eDeB/l8LXdD8JJ4FjTCEj8Dwq9lJx8
         APRLCfXLb76SCcK4WDQnRnxgnjd6aIgn+BhaxqAZaB5NkK8QO7nzfsblMaRYPVD+H6
         ZWOkUzcizcAW2nYprgaEAc0qz/R+IWzSSHef4XdTTzAjF24WPbTxDC9bTSh+J8DpQn
         7/tIvebdXOV+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8E526EAC09B;
        Fri, 25 Feb 2022 10:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] xen/netfront: destroy queues before real_num_tx_queues is
 zeroed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164578561057.13834.5994173770160348500.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Feb 2022 10:40:10 +0000
References: <20220223211954.2506824-1-marmarek@invisiblethingslab.com>
In-Reply-To: <20220223211954.2506824-1-marmarek@invisiblethingslab.com>
To:     =?utf-8?q?Marek_Marczykowski-G=C3=B3recki_=3Cmarmarek=40invisiblethingslab?=@ci.codeaurora.org,
        =?utf-8?q?=2Ecom=3E?=@ci.codeaurora.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, davem@davemloft.net, kuba@kernel.org,
        atenart@kernel.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org
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

On Wed, 23 Feb 2022 22:19:54 +0100 you wrote:
> xennet_destroy_queues() relies on info->netdev->real_num_tx_queues to
> delete queues. Since d7dac083414eb5bb99a6d2ed53dc2c1b405224e5
> ("net-sysfs: update the queue counts in the unregistration path"),
> unregister_netdev() indirectly sets real_num_tx_queues to 0. Those two
> facts together means, that xennet_destroy_queues() called from
> xennet_remove() cannot do its job, because it's called after
> unregister_netdev(). This results in kfree-ing queues that are still
> linked in napi, which ultimately crashes:
> 
> [...]

Here is the summary with links:
  - [v2] xen/netfront: destroy queues before real_num_tx_queues is zeroed
    https://git.kernel.org/netdev/net/c/dcf4ff7a48e7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


