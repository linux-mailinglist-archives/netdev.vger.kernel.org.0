Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09CFD4BB772
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 12:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbiBRLAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 06:00:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbiBRLA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 06:00:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011A01EB420;
        Fri, 18 Feb 2022 03:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91B6B61E80;
        Fri, 18 Feb 2022 11:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EDB11C340EB;
        Fri, 18 Feb 2022 11:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645182010;
        bh=KwglRraOwOZOyLVRrYY428yqdeqobp9eallBt0vf47w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ifQQtPSY4h9ByFo7m6Lj86wzl27AaVnW50/hj4q6IbZZyWHhdn5Jpo3cOlrYj+vc/
         9yCWB0LunTBgmZZj2hdX9cT7OQQ/VfMYF62XramxmF78eb3pTVWcIgil9vZlRv7hww
         T6CTMacI2yrhfbmj8F+AMEe9DDIgtXnVPMWQn2CtSiC4KstBfHQ7ZNXtSyOOVYMPPX
         Xv+YsTGl1fSGoZiOYTRIRw0c/lXuwxlcWuQnzSvtPTyYADPBVrPbc0DZ9SwQm1rL+t
         XWu5b9UqGuojhVMerU/PbxjoOwqyoA0O9TrLaY5ivEVq6dN3cUHdAVL5dI3Vs7ADxh
         C6p2I6GkPpIUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D6F33E7BB07;
        Fri, 18 Feb 2022 11:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V3] drivers: hamradio: 6pack: fix UAF bug caused by
 mod_timer()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164518200987.19952.16423799122287139298.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Feb 2022 11:00:09 +0000
References: <20220217014303.102986-1-duoming@zju.edu.cn>
In-Reply-To: <20220217014303.102986-1-duoming@zju.edu.cn>
To:     =?utf-8?b?5ZGo5aSa5piOIDxkdW9taW5nQHpqdS5lZHUuY24+?=@ci.codeaurora.org
Cc:     linux-hams@vger.kernel.org, kuba@kernel.org,
        ajk@comnets.uni-bremen.de, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linma@zju.edu.cn
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 17 Feb 2022 09:43:03 +0800 you wrote:
> When a 6pack device is detaching, the sixpack_close() will act to cleanup
> necessary resources. Although del_timer_sync() in sixpack_close()
> won't return if there is an active timer, one could use mod_timer() in
> sp_xmit_on_air() to wake up timer again by calling userspace syscall such
> as ax25_sendmsg(), ax25_connect() and ax25_ioctl().
> 
> This unexpected waked handler, sp_xmit_on_air(), realizes nothing about
> the undergoing cleanup and may still call pty_write() to use driver layer
> resources that have already been released.
> 
> [...]

Here is the summary with links:
  - [V3] drivers: hamradio: 6pack: fix UAF bug caused by mod_timer()
    https://git.kernel.org/netdev/net/c/efe4186e6a1b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


