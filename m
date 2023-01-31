Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B046829FE
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 11:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjAaKKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 05:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjAaKKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 05:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0B34ED7;
        Tue, 31 Jan 2023 02:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 529A5614AA;
        Tue, 31 Jan 2023 10:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A9D01C433D2;
        Tue, 31 Jan 2023 10:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675159816;
        bh=aC8cWenY/vRb5MKewZpHU/4CYbTngFaS7WCF1/uPb70=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ONkWKGOB+Szx+qvF/cRcCVySPNBqaZ1nrBETiv101yQkOGv7B0bxFqDGMFyBLdgWo
         w0ILUfUzw990HV3StV2jly3EEkeD58d7O/DGEpVK59bO5J1cKnm/XVfIMLi8zrCr6V
         OPk/Ap0FFOmRmA9ElqjvvGw/RiztF2Ww4fncxH04n1j3EerZQAZN5JHIAV+oJZFceP
         4MMKF03XUz4YeuMDFo4a8FWt2fnqK4QQjElpcpV0czOTLdpgxroaVy01ceYzEta3Rt
         pE4QbW1KqxEdxSYAbOx64fUJM0o0FnEV8iAV39nFco9Ee7YLe2W8SxF8awhJSlHHJL
         hIAEgdvjky5eQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 88837C0C40E;
        Tue, 31 Jan 2023 10:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: Avoid truncating allocation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167515981654.18378.5828273248043471615.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Jan 2023 10:10:16 +0000
References: <20230127223853.never.014-kees@kernel.org>
In-Reply-To: <20230127223853.never.014-kees@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, lorenzo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 27 Jan 2023 14:38:54 -0800 you wrote:
> There doesn't appear to be a reason to truncate the allocation used for
> flow_info, so do a full allocation and remove the unused empty struct.
> GCC does not like having a reference to an object that has been
> partially allocated, as bounds checking may become impossible when
> such an object is passed to other code. Seen with GCC 13:
> 
> ../drivers/net/ethernet/mediatek/mtk_ppe.c: In function 'mtk_foe_entry_commit_subflow':
> ../drivers/net/ethernet/mediatek/mtk_ppe.c:623:18: warning: array subscript 'struct mtk_flow_entry[0]' is partly outside array bounds of 'unsigned char[48]' [-Warray-bounds=]
>   623 |         flow_info->l2_data.base_flow = entry;
>       |                  ^~
> 
> [...]

Here is the summary with links:
  - net: ethernet: mtk_eth_soc: Avoid truncating allocation
    https://git.kernel.org/netdev/net/c/f3eceaed9edd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


