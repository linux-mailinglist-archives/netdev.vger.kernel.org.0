Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D0453B79F
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 13:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbiFBLKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 07:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234047AbiFBLKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 07:10:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0043B57C;
        Thu,  2 Jun 2022 04:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35E9761640;
        Thu,  2 Jun 2022 11:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7EC8BC34119;
        Thu,  2 Jun 2022 11:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654168212;
        bh=j06rqKLxCiZYtZpREEyAHdj4/fuHN/JgVF0s7TE/l6Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YI4/Ri7Ba7slwR1uW8/viRO3u1row1zIJphRUsZu3LsVs2op4ZPNlk07B4mgkyZV+
         q5DkeqTKNwicZ+JkSHj7kqFSh+pqTnz9p0VO8P3anailRjVwx63HcWcsh8iPqIgXE/
         4JT+2M7klhcHQn2QFNE9YDtwvZ2BEE2wfGfSzyP17rrt/rlt/qSGXcbwECu54+t4Fn
         9wYva8BDgPlAy0YmeRYI5xqFz9CJSeArJqOXLXvYKKYRgOWdOa1c94ERcqRvzDeFVx
         FZkEOovSOk0jXEd7ma0NjeMoPZkab/zDOnhYYHtnCYID5g1oS+Vl1PIHWKe93dr5Ad
         oSa2u9N/DFY0A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 60E29F03950;
        Thu,  2 Jun 2022 11:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ice: fix access-beyond-end in the switch code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165416821239.26072.8874912583921079305.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Jun 2022 11:10:12 +0000
References: <20220601105924.2841410-1-alexandr.lobakin@intel.com>
In-Reply-To: <20220601105924.2841410-1-alexandr.lobakin@intel.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, jeffrey.t.kirsher@intel.com,
        anirudh.venkataramanan@intel.com, bruce.w.allan@intel.com,
        maciej.fijalkowski@intel.com, michal.swiatkowski@linux.intel.com,
        wojciech.drewek@intel.com, marcin.szycik@linux.intel.com,
        martyna.szapar-mudlaw@intel.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed,  1 Jun 2022 12:59:24 +0200 you wrote:
> Global `-Warray-bounds` enablement revealed some problems, one of
> which is the way we define and use AQC rules messages.
> In fact, they have a shared header, followed by the actual message,
> which can be of one of several different formats. So it is
> straightforward enough to define that header as a separate struct
> and then embed it into message structures as needed, but currently
> all the formats reside in one union coupled with the header. Then,
> the code allocates only the memory needed for a particular message
> format, leaving the union potentially incomplete.
> There are no actual reads or writes beyond the end of an allocated
> chunk, but at the same time, the whole implementation is fragile and
> backed by an equilibrium rather than strong type and memory checks.
> 
> [...]

Here is the summary with links:
  - [net] ice: fix access-beyond-end in the switch code
    https://git.kernel.org/netdev/net/c/6e1ff618737a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


