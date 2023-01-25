Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0414767AF14
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 11:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbjAYKAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 05:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235023AbjAYKAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 05:00:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2F853B20;
        Wed, 25 Jan 2023 02:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77F2861450;
        Wed, 25 Jan 2023 10:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5E08C433EF;
        Wed, 25 Jan 2023 10:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674640818;
        bh=n0WLKtsLkqD76gvohl+UmSSBLpp83T8xa5J6Aw9VfCk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XMWfJQ8KtBx4ZTbwCFDySoiu28BEnHjUWZjB8gNx+JnjdmMtNpu1k9jh/8DfDiZmo
         ZZx8gGGgBsUSi7aci15XLsHS3Yg8Hhc5jdxVaaFpT2oN3d8zZLWdJhhq4ZWnSWT1cS
         cviGh+qeGIfPXIm2YCNIJE/InZqUs+VAmWsbMNIRsywUe0vqFHF1BUrJcBeGyZsqyb
         UGDlJp789Q3wjEcOXiVicAWvSNU9V2H9nme/RazIUk93BeCNQO4Caena1LjckQ1nYT
         ld1S7xqRvl8bq5IlDywHsCLLmnvVhLNb/cdUVvdKLqmhWZ5VajNKiwh0A8R8j57zuu
         6qWOZZLLW4rZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C107AC04E34;
        Wed, 25 Jan 2023 10:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v2 0/8] drivers/s390/net/ism: Add generalized interface
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167464081878.8627.16367625565624680378.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Jan 2023 10:00:18 +0000
References: <20230123181752.1068-1-jaka@linux.ibm.com>
In-Reply-To: <20230123181752.1068-1-jaka@linux.ibm.com>
To:     Jan Karcher <jaka@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com,
        wintera@linux.ibm.com, wenjia@linux.ibm.com,
        twinkler@linux.ibm.com, raspl@linux.ibm.com, kgraul@linux.ibm.com,
        niho@linux.ibm.com, pasic@linux.ibm.com, tonylu@linux.alibaba.com,
        guwen@linux.alibaba.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 23 Jan 2023 19:17:44 +0100 you wrote:
> Previously, there was no clean separation between SMC-D code and the ISM
> device driver.This patch series addresses the situation to make ISM available
> for uses outside of SMC-D.
> In detail: SMC-D offers an interface via struct smcd_ops, which only the
> ISM module implements so far. However, there is no real separation between
> the smcd and ism modules, which starts right with the ISM device
> initialization, which calls directly into the SMC-D code.
> This patch series introduces a new API in the ISM module, which allows
> registration of arbitrary clients via include/linux/ism.h: struct ism_client.
> Furthermore, it introduces a "pure" struct ism_dev (i.e. getting rid of
> dependencies on SMC-D in the device structure), and adds a number of API
> calls for data transfers via ISM (see ism_register_dmb() & friends).
> Still, the ISM module implements the SMC-D API, and therefore has a number
> of internal helper functions for that matter.
> Note that the ISM API is consciously kept thin for now (as compared to the
> SMC-D API calls), as a number of API calls are only used with SMC-D and
> hardly have any meaningful usage beyond SMC-D, e.g. the VLAN-related calls.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/8] net/smc: Terminate connections prior to device removal
    https://git.kernel.org/netdev/net-next/c/c40bff4132e5
  - [net-next,v2,2/8] net/ism: Add missing calls to disable bus-mastering
    https://git.kernel.org/netdev/net-next/c/462502ff9acb
  - [net-next,v2,3/8] s390/ism: Introduce struct ism_dmb
    https://git.kernel.org/netdev/net-next/c/1baedb13f1d5
  - [net-next,v2,4/8] net/ism: Add new API for client registration
    https://git.kernel.org/netdev/net-next/c/89e7d2ba61b7
  - [net-next,v2,5/8] net/smc: Register SMC-D as ISM client
    https://git.kernel.org/netdev/net-next/c/8747716f3942
  - [net-next,v2,6/8] net/smc: Separate SMC-D and ISM APIs
    https://git.kernel.org/netdev/net-next/c/9de4df7b6be1
  - [net-next,v2,7/8] s390/ism: Consolidate SMC-D-related code
    https://git.kernel.org/netdev/net-next/c/820f21009f1b
  - [net-next,v2,8/8] net/smc: De-tangle ism and smc device initialization
    https://git.kernel.org/netdev/net-next/c/8c81ba20349d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


