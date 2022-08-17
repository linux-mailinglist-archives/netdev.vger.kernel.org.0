Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E613597622
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 20:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241320AbiHQSwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 14:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241300AbiHQSwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 14:52:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E328A3D6A;
        Wed, 17 Aug 2022 11:52:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAB2961446;
        Wed, 17 Aug 2022 18:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02EE6C433D7;
        Wed, 17 Aug 2022 18:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660762349;
        bh=RR33wIOlyo9eMIkzmh0mFx+gISQrdv7F4Oqj1rsVrls=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ewjRLEHvK5mf5HNdt8uN0i2auiMMJL/abHSO0tZhFBtZCdqUL2gHWoMC3BCOSaiFV
         fHNf4HtQwTuT18iTJ0rXY0BZCJQSScNGeS9o8lXeNWhSHmn066mmdPMoNdfz6qcX17
         z9rsxGTKL04zbP9sThuO9coCE4FwO0FGMn70Y3PytUltFoSM6inbpAQsW92AqWmJA+
         TgEFbr3E7FeQ8hEmfOgF8ceNVbabViy+40W8bSG36mleCOFhCHrwji6QQZy8rt/JQ8
         Q2juUM7SxEdX+qeiLIRXz2S7t7ctqgyS+/xx9Z4WoljBk6wRYGo4HrK7fH2qaZCKjv
         6zfZQ1Md/OZ2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CED06E2A04C;
        Wed, 17 Aug 2022 18:52:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Bluetooth: hci_sync: fix double mgmt_pending_free() in
 remove_adv_monitor()
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <166076234884.20898.8598584910836798147.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Aug 2022 18:52:28 +0000
References: <ea64b27e-6cbf-fdd5-1f23-aecc3a308e47@I-love.SAKURA.ne.jp>
In-Reply-To: <ea64b27e-6cbf-fdd5-1f23-aecc3a308e47@I-love.SAKURA.ne.jp>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     syzbot+915a8416bf15895b8e07@syzkaller.appspotmail.com,
        davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Wed, 17 Aug 2022 20:14:36 +0900 you wrote:
> syzbot is reporting double kfree() at remove_adv_monitor() [1], for
> commit 7cf5c2978f23fdbb ("Bluetooth: hci_sync: Refactor remove Adv
> Monitor") forgot to remove duplicated mgmt_pending_remove() when
> merging "if (err) {" path and "if (!pending) {" path.
> 
> Link: https://syzkaller.appspot.com/bug?extid=915a8416bf15895b8e07 [1]
> Reported-by: syzbot <syzbot+915a8416bf15895b8e07@syzkaller.appspotmail.com>
> Fixes: 7cf5c2978f23fdbb ("Bluetooth: hci_sync: Refactor remove Adv Monitor")
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> 
> [...]

Here is the summary with links:
  - Bluetooth: hci_sync: fix double mgmt_pending_free() in remove_adv_monitor()
    https://git.kernel.org/bluetooth/bluetooth-next/c/ae2b5c97cd40

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


