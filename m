Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC4165E4CE
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjAEEos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:44:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbjAEEoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:44:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79D84D723
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 20:44:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 517A5618A2
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 04:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABDE3C43396;
        Thu,  5 Jan 2023 04:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672893851;
        bh=nN2MPyRe8D9hMv2r31buj/NXFCqfh9X7KuYFKPtXMnc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LZCudewIgzXozqtmc5d1K9IbWCl1wEXag0sAidu9C1vVXUxNp+AbWPtUUrXKvag15
         lpyvTHZtA7FM2H8hc2JLdJB/Q+m6X/zBxooQcXm4IxfXVMVlC0vLzGPo9Y2+NIOCyk
         omt+Y9gaFfX2TsDM40XHtzAell7w5DISVhj4RZHRcWAS3DaTycfKdzgtFeHcAL9vN1
         9Csl6KbqNvJiBcwCuSBcVFLLg3FQQbmUpHt7XISFTEVg0n9M59DxDiCeb04sweHad0
         EtEnQRY8kJsGnriPTlhoIYz3UCUiKsOPz+6OgavrPYAzCoRCrG/K/ZQv7AfhiVpcMO
         kUkTRGNrKcl3g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 85743E270F0;
        Thu,  5 Jan 2023 04:44:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] qed: allow sleep in qed_mcp_trace_dump()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167289385153.19861.5654918832967601296.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Jan 2023 04:44:11 +0000
References: <20230103233021.1457646-1-csander@purestorage.com>
In-Reply-To: <20230103233021.1457646-1-csander@purestorage.com>
To:     Caleb Sander <csander@purestorage.com>
Cc:     aelior@marvell.com, manishc@marvell.com, pabeni@redhat.com,
        leon@kernel.org, netdev@vger.kernel.org, joern@purestorage.com,
        palok@marvell.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  3 Jan 2023 16:30:21 -0700 you wrote:
> By default, qed_mcp_cmd_and_union() delays 10us at a time in a loop
> that can run 500K times, so calls to qed_mcp_nvm_rd_cmd()
> may block the current thread for over 5s.
> We observed thread scheduling delays over 700ms in production,
> with stacktraces pointing to this code as the culprit.
> 
> qed_mcp_trace_dump() is called from ethtool, so sleeping is permitted.
> It already can sleep in qed_mcp_halt(), which calls qed_mcp_cmd().
> Add a "can sleep" parameter to qed_find_nvram_image() and
> qed_nvram_read() so they can sleep during qed_mcp_trace_dump().
> qed_mcp_trace_get_meta_info() and qed_mcp_trace_read_meta(),
> called only by qed_mcp_trace_dump(), allow these functions to sleep.
> I can't tell if the other caller (qed_grc_dump_mcp_hw_dump()) can sleep,
> so keep b_can_sleep set to false when it calls these functions.
> 
> [...]

Here is the summary with links:
  - [net,v3] qed: allow sleep in qed_mcp_trace_dump()
    https://git.kernel.org/netdev/net/c/5401c3e09928

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


