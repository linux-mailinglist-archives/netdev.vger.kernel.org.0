Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF074EAC7D
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 13:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235972AbiC2Ll5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 07:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235250AbiC2Ll4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 07:41:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C2A201B5;
        Tue, 29 Mar 2022 04:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3C30B81739;
        Tue, 29 Mar 2022 11:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6CD66C340F0;
        Tue, 29 Mar 2022 11:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648554011;
        bh=k0MUrQArqRvaVJ8NEHp+nxibDAS10ufLqavY82Lc0gQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZSTqfU9eYWBNmk7yzTCteLGBqaDfjyBiUQQloDsGXKNbguNJqmUgiE/0RvlEmG68N
         hjTxpIyvtvdqn+ly2RXLHAVTEP2rNplZWSDBPfzeWnYbth2LF7zU2aDbXXJI0k9HWh
         so/mDrek8Q5QiwE6kaC/20DvE97+yfdbJRsrZS97mwHX4Wp4Keuvzigf6w1DIM1LIF
         AcIrO32nyH+ASJhssI3YsGI9TP2bsLTmQ8n/B1gJMfvDFi90BHXJn7kfNATuJ4E2/7
         GT7OQlDFzrRA8VogVsX5tu37Lr90aJ63eaOxbviCa2HslhXWjpqqOPRym4244wBpsz
         3gxDU5AGJ3yMg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4E675EAC081;
        Tue, 29 Mar 2022 11:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] Bluetooth: fix dangling sco_conn and use-after-free in
 sco_sock_timeout
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <164855401131.3735.13754664491252004228.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Mar 2022 11:40:11 +0000
References: <20220326070853.v2.1.I67f8ad854ac2f48701902bfb34d6e2070011b779@changeid>
In-Reply-To: <20220326070853.v2.1.I67f8ad854ac2f48701902bfb34d6e2070011b779@changeid>
To:     Ying Hsu <yinghsu@chromium.org>
Cc:     marcel@holtmann.org, chromeos-bluetooth-upstreaming@chromium.org,
        syzbot+2bef95d3ab4daa10155b@syzkaller.appspotmail.com,
        josephsih@chromium.org, davem@davemloft.net,
        desmondcheongzx@gmail.com, kuba@kernel.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
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

This patch was applied to bluetooth/bluetooth-next.git (master)
by Marcel Holtmann <marcel@holtmann.org>:

On Sat, 26 Mar 2022 07:09:28 +0000 you wrote:
> Connecting the same socket twice consecutively in sco_sock_connect()
> could lead to a race condition where two sco_conn objects are created
> but only one is associated with the socket. If the socket is closed
> before the SCO connection is established, the timer associated with the
> dangling sco_conn object won't be canceled. As the sock object is being
> freed, the use-after-free problem happens when the timer callback
> function sco_sock_timeout() accesses the socket. Here's the call trace:
> 
> [...]

Here is the summary with links:
  - [v2] Bluetooth: fix dangling sco_conn and use-after-free in sco_sock_timeout
    https://git.kernel.org/bluetooth/bluetooth-next/c/300cf0bfb43e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


