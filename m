Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35264BC959
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 17:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242632AbiBSQkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 11:40:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242616AbiBSQkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 11:40:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451B61D3ADC
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 08:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC62E60BAD
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 16:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B8864C340F8;
        Sat, 19 Feb 2022 16:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645288811;
        bh=1ZPOO0EYWUPzjj8AHNak/Wzi8wTcPu8meAhz3/ojTLk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bfT44bXeUxhIdPUmHdAAMzEerX3HGNBbaCQ/Z8F0A6cCHCP0cWV1WJkbmqTuIo0hN
         Jw0k91GMXqK1SLijyAlZa6ZBf/T5vsqsXoh4GTamIO3l5UB7tWYsCAGdjI/U71K5tY
         K+ygcn5GDcn3OX0eR6ymaeJFT6txSpl8HDX5sWzMuvnzY0kzIkk6F+csQplYnzBlzy
         SfqezqId95FbUXkjNNkfvmdeH/sYY27Oc6MxplMDrKF8ZalMHA/S/swMULpDo2f3Ww
         fGEleZbastpNHTyu5a416T9xjjE7qeoW4mpxpNdfQCwTbDG294vhbS3vmGdglhLIex
         y80ZzcUastyig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 97C3EE7BB19;
        Sat, 19 Feb 2022 16:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ip6mr: add support for passing full packet on wrong mif
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164528881161.6364.16449808462091332459.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Feb 2022 16:40:11 +0000
References: <20220217074640.4472-1-mobash.rasool.linux@gmail.com>
In-Reply-To: <20220217074640.4472-1-mobash.rasool.linux@gmail.com>
To:     Mobashshera Rasool <mobash.rasool.linux@gmail.com>
Cc:     davem@davemloft.net, oshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        equinox@opensourcerouting.org, razor@blackwall.org,
        sharpd@cumulusnetworks.com, mrasool@vmware.com
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Feb 2022 07:46:40 +0000 you wrote:
> This patch adds support for MRT6MSG_WRMIFWHOLE which is used to pass
> full packet and real vif id when the incoming interface is wrong.
> While the RP and FHR are setting up state we need to be sending the
> registers encapsulated with all the data inside otherwise we lose it.
> The RP then decapsulates it and forwards it to the interested parties.
> Currently with WRONGMIF we can only be sending empty register packets
> and will lose that data.
> This behaviour can be enabled by using MRT_PIM with
> val == MRT6MSG_WRMIFWHOLE. This doesn't prevent MRT6MSG_WRONGMIF from
> happening, it happens in addition to it, also it is controlled by the same
> throttling parameters as WRONGMIF (i.e. 1 packet per 3 seconds currently).
> Both messages are generated to keep backwards compatibily and avoid
> breaking someone who was enabling MRT_PIM with val == 4, since any
> positive val is accepted and treated the same.
> 
> [...]

Here is the summary with links:
  - net: ip6mr: add support for passing full packet on wrong mif
    https://git.kernel.org/netdev/net-next/c/4b340a5a726d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


