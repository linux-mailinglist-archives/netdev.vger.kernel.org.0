Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D179E6CD967
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 14:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjC2Mfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 08:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjC2Mfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 08:35:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96583ABE
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 05:35:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DABCB822EF
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 12:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA13C433D2;
        Wed, 29 Mar 2023 12:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680093338;
        bh=rf77M4+XSraXySGfUVad2FoW7oZEHV3pMMP44UQAwGQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QlfJQlccqbh4fkO5MMCFrSTS1Ql2n7PbI4dRG8wtK22f6Lva09bRZxvmFJeuWrYc8
         ERiy9zMNvjB3b/5wA8fVHuv5apdmZ5P04B006wLqlLjH7Crpkf0C08WcmtoOczeYI5
         WvHAqPZA6BDt1G8ndPJp9rxDhS/rB5x7uxmGzhVgQ5/7eCXHayGowoK6Vdc7+RvOMk
         xN1e+FBqZZQdz4K5yQRbTk+MiixN5DIKm/vYkOsoa1cBmtNduDwRs7nzcqGDy+hvSO
         lull5BmBmHSH8A4W+53OqVAt/tWBJHvMAXneedpyq1G2HUHCkxk1YQJHX5IWHm18cU
         LZlmA/Kc7Kt4Q==
Date:   Wed, 29 Mar 2023 15:35:33 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Thomas Voegtle <tv@lio96.de>,
        aelior@marvell.com, skalluru@marvell.com, manishc@marvell.com,
        keescook@chromium.org
Subject: Re: [PATCH net] bnx2x: use the right build_skb() helper
Message-ID: <20230329123533.GU831478@unreal>
References: <20230329000013.2734957-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329000013.2734957-1-kuba@kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 05:00:13PM -0700, Jakub Kicinski wrote:
> build_skb() no longer accepts slab buffers. Since slab use is fairly
> uncommon we prefer the drivers to call a separate slab_build_skb()
> function appropriately.
> 
> bnx2x uses the old semantics where size of 0 meant buffer from slab.
> It sets the fp->rx_frag_size to 0 for MTUs which don't fit in a page.
> It needs to call slab_build_skb().
> 
> This fixes the WARN_ONCE() of incorrect API use seen with bnx2x.
> 
> Reported-by: Thomas Voegtle <tv@lio96.de>
> Link: https://lore.kernel.org/all/b8f295e4-ba57-8bfb-7d9c-9d62a498a727@lio96.de/
> Fixes: ce098da1497c ("skbuff: Introduce slab_build_skb()")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: aelior@marvell.com
> CC: skalluru@marvell.com
> CC: manishc@marvell.com
> CC: keescook@chromium.org
> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
