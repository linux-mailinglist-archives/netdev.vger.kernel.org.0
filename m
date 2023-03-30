Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2106D0D73
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 20:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbjC3SK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 14:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbjC3SK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 14:10:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40FEEB6F;
        Thu, 30 Mar 2023 11:10:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 446B16215E;
        Thu, 30 Mar 2023 18:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 92F0EC433D2;
        Thu, 30 Mar 2023 18:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680199824;
        bh=DwOUP2sC5a3Y4i+2avGuq1jTgRQ93tyP+6+l0yyjMGQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TS/hNse95qXp1BpIaZgmTsV36A/sDyd193Iup5fBfsBM7y27Yb48oCpRWuPZXo+Hj
         xZWjCMNvgxBVViBn+e9AYfMdQ4b1zUmCiAgmratRyeX0qxDqSoyQbsUJuyXSW3B9TW
         px4FCjGasOFGKHcLAGdtevEbRfiKWwcElEn/uh4pL2D4GFYWD9r19jab7fG/0Ie19g
         oZ1kggYcxaCt2UMkFESG1yYC8u935PfPI6lW8w0mW/bYCwRiBrknGiUokAgwWbzKf4
         Xnpe9ySB3sQPlwoVVXyhNtKRJCSS6bHp33HVuGzyBbAjkg3z+qcjfaXQKJ2mlPEE8y
         ++e/ds7klCfnA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 781D6E2A037;
        Thu, 30 Mar 2023 18:10:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v13 1/4] Bluetooth: Add support for hci devcoredump
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <168019982448.20045.10207710004218277745.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Mar 2023 18:10:24 +0000
References: <20230330095714.v13.1.I9b4e4818bab450657b19cda3497d363c9baa616e@changeid>
In-Reply-To: <20230330095714.v13.1.I9b4e4818bab450657b19cda3497d363c9baa616e@changeid>
To:     Manish Mandlik <mmandlik@google.com>
Cc:     marcel@holtmann.org, luiz.dentz@gmail.com,
        chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org, abhishekpandit@chromium.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        johan.hedberg@gmail.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Thu, 30 Mar 2023 09:58:23 -0700 you wrote:
> From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> 
> Add devcoredump APIs to hci core so that drivers only have to provide
> the dump skbs instead of managing the synchronization and timeouts.
> 
> The devcoredump APIs should be used in the following manner:
>  - hci_devcoredump_init is called to allocate the dump.
>  - hci_devcoredump_append is called to append any skbs with dump data
>    OR hci_devcoredump_append_pattern is called to insert a pattern.
>  - hci_devcoredump_complete is called when all dump packets have been
>    sent OR hci_devcoredump_abort is called to indicate an error and
>    cancel an ongoing dump collection.
> 
> [...]

Here is the summary with links:
  - [v13,1/4] Bluetooth: Add support for hci devcoredump
    (no matching commit)
  - [v13,2/4] Bluetooth: Add vhci devcoredump support
    https://git.kernel.org/bluetooth/bluetooth-next/c/d5d5df6da0aa
  - [v13,3/4] Bluetooth: btusb: Add btusb devcoredump support
    https://git.kernel.org/bluetooth/bluetooth-next/c/1078959dcb5c
  - [v13,4/4] Bluetooth: btintel: Add Intel devcoredump support
    https://git.kernel.org/bluetooth/bluetooth-next/c/0b93eeba4454

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


