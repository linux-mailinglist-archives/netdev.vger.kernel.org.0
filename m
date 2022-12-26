Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2B4656163
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 10:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbiLZJKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 04:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbiLZJKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 04:10:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD551624C;
        Mon, 26 Dec 2022 01:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BBCFB80CA9;
        Mon, 26 Dec 2022 09:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 13CFEC433F1;
        Mon, 26 Dec 2022 09:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672045815;
        bh=vcg8MBpukuOJK7gxVD4AwHL/m1tqLpAGi9YMR+kpwPc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XIw6Ijg6Gtf86wzE60M0cG5yMFU4S8YvT/mIWwfiLXBEnYsIL0D3wLktHFpwbCjz9
         9vFiZem0C7WgJAUPLygQGB9qSVTjGvymYhu3ZOSkINN8SMHKqjF8IakTf854hLegG4
         MQzFYh97zxN8FbOchdCM2zVoqRQ1fO+AwKVzBXQMjPKfftReagdeK3KvQoILkW06Wq
         j3I0vD5RJnRuuZY5+tIUL/7mNUwMTIJFZlwXC2GJpdSCTqykAisnojP5KUYxFGq+4g
         Fc0HY8E+Da1mpoyjH0xlCQDYZCZyl618piUye0c5b4/HO7fygeEPWcQEPsn6GlfhSd
         UsDe+HFKci73w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E858AC43159;
        Mon, 26 Dec 2022 09:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] qlcnic: prevent ->dcb use-after-free on
 qlcnic_dcb_enable() failure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167204581494.6964.6567338467214836731.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Dec 2022 09:10:14 +0000
References: <20221222115228.1766265-1-d-tatianin@yandex-team.ru>
In-Reply-To: <20221222115228.1766265-1-d-tatianin@yandex-team.ru>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.swiatkowski@linux.intel.com
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
by David S. Miller <davem@davemloft.net>:

On Thu, 22 Dec 2022 14:52:28 +0300 you wrote:
> adapter->dcb would get silently freed inside qlcnic_dcb_enable() in
> case qlcnic_dcb_attach() would return an error, which always happens
> under OOM conditions. This would lead to use-after-free because both
> of the existing callers invoke qlcnic_dcb_get_info() on the obtained
> pointer, which is potentially freed at that point.
> 
> Propagate errors from qlcnic_dcb_enable(), and instead free the dcb
> pointer at callsite using qlcnic_dcb_free(). This also removes the now
> unused qlcnic_clear_dcb_ops() helper, which was a simple wrapper around
> kfree() also causing memory leaks for partially initialized dcb.
> 
> [...]

Here is the summary with links:
  - [net,v3] qlcnic: prevent ->dcb use-after-free on qlcnic_dcb_enable() failure
    https://git.kernel.org/netdev/net/c/13a7c8964afc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


