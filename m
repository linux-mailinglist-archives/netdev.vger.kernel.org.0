Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288026877B3
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 09:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbjBBIkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 03:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbjBBIkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 03:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5B2761D0;
        Thu,  2 Feb 2023 00:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AFB861A28;
        Thu,  2 Feb 2023 08:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A740AC4339B;
        Thu,  2 Feb 2023 08:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675327217;
        bh=ULsV67zQUJfvmJQRTAc+jmxPY77ctm/HpmxnTdpyPhA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZxzyeduWsSQVTVNv1dXXe8cizpB6icn4jaJjsNQRYs3TOKhufSP7cWqi0TspCOdCC
         qNUJOlG+SpaM5ogAKbtVOzQXV86Gq9MVfMMJLGZCjl2TlFIHVNtyRWrl7hglIDhXy4
         +LoJuSShwwb/gGspLJkOuGPr7Ymg7UDdi7QlzGUZGZkgx8SCxyuJfZ3tgj1DcKKSCw
         GcQtHvRrFip4dVjkNX2EA0q3vzKRSMcYWFZHjjV+up4yxXz98G5JgjzFy6p/TNmf8V
         t+caQ937XGgKyWYY0are0FnqDQnC85gJggbZUTUF1OLKlMFyfeFPjHOFS/VC6MlxKC
         954XcqVTNIsmw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8BC2AE270CC;
        Thu,  2 Feb 2023 08:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] hv_netvsc: Fix missed pagebuf entries in
 netvsc_dma_map/unmap()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167532721756.2893.14755906003032321617.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 08:40:17 +0000
References: <1675135986-254490-1-git-send-email-mikelley@microsoft.com>
In-Reply-To: <1675135986-254490-1-git-send-email-mikelley@microsoft.com>
To:     Michael Kelley (LINUX) <mikelley@microsoft.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 30 Jan 2023 19:33:06 -0800 you wrote:
> netvsc_dma_map() and netvsc_dma_unmap() currently check the cp_partial
> flag and adjust the page_count so that pagebuf entries for the RNDIS
> portion of the message are skipped when it has already been copied into
> a send buffer. But this adjustment has already been made by code in
> netvsc_send(). The duplicate adjustment causes some pagebuf entries to
> not be mapped. In a normal VM, this doesn't break anything because the
> mapping doesn’t change the PFN. But in a Confidential VM,
> dma_map_single() does bounce buffering and provides a different PFN.
> Failing to do the mapping causes the wrong PFN to be passed to Hyper-V,
> and various errors ensue.
> 
> [...]

Here is the summary with links:
  - [net,1/1] hv_netvsc: Fix missed pagebuf entries in netvsc_dma_map/unmap()
    https://git.kernel.org/netdev/net/c/99f1c46011cc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


