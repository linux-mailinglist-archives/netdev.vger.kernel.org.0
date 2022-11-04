Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE474618F6E
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 05:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbiKDEKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 00:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiKDEKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 00:10:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882E21F2D7
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 21:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B057B82B91
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 04:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9CAEC433D6;
        Fri,  4 Nov 2022 04:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667535016;
        bh=ApaiQe9NHQIv1tPUBVEp9YVhwksi3Pz4UQhS5vP84Uc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Jvz6c/UbITYG5plDJefD1SYw1ceOGPmS+83llSJKyI+2a8DJLgM88/gV+uAXH3aP1
         v69kBlSEsybhjCQI8DrRRXxSKG/BRlUcmNuPvBMkOATSfFFj505E9sTi9aPhFn2Uk5
         0rKrDKQIP6xqI0F1XLSPuvHdULhelTdTo+GgPTIDM15m7TwMiH+bMxwdY8T1RFoomC
         ALJsLisuB6YwRxP8ReCEchdxgt28VHBYazaF2b70fPYlLq872klPfN3+cY6rlNE1F4
         9sOlcVITo5j2UATi5z7xGrAgQmJGpAIW1uxGfBNQRrgawzicPENrQd9M/xVUVJ3v0r
         HtGjM5U1IbPCQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ACF24E270EA;
        Fri,  4 Nov 2022 04:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: gso: fix panic on frag_list with mixed head alloc
 types
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166753501670.4086.1819802414418539212.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Nov 2022 04:10:16 +0000
References: <e04426a6a91baf4d1081e1b478c82b5de25fdf21.1667407944.git.jbenc@redhat.com>
In-Reply-To: <e04426a6a91baf4d1081e1b478c82b5de25fdf21.1667407944.git.jbenc@redhat.com>
To:     Jiri Benc <jbenc@redhat.com>
Cc:     netdev@vger.kernel.org, shmulik@metanetworks.com,
        eric.dumazet@gmail.com, tomas@tigera.io,
        jpiotrowski@linux.microsoft.com, kuba@kernel.org,
        willemdebruijn.kernel@gmail.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  2 Nov 2022 17:53:25 +0100 you wrote:
> Since commit 3dcbdb134f32 ("net: gso: Fix skb_segment splat when
> splitting gso_size mangled skb having linear-headed frag_list"), it is
> allowed to change gso_size of a GRO packet. However, that commit assumes
> that "checking the first list_skb member suffices; i.e if either of the
> list_skb members have non head_frag head, then the first one has too".
> 
> It turns out this assumption does not hold. We've seen BUG_ON being hit
> in skb_segment when skbs on the frag_list had differing head_frag with
> the vmxnet3 driver. This happens because __netdev_alloc_skb and
> __napi_alloc_skb can return a skb that is page backed or kmalloced
> depending on the requested size. As the result, the last small skb in
> the GRO packet can be kmalloced.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: gso: fix panic on frag_list with mixed head alloc types
    https://git.kernel.org/netdev/net/c/9e4b7a99a03a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


