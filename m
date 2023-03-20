Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 255B26C0CCD
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 10:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbjCTJKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 05:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbjCTJJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 05:09:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACFA1715
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 02:09:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB17D612AC
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 09:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491F9C433EF;
        Mon, 20 Mar 2023 09:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679303397;
        bh=PWy+LVwJwbDP5KdPV6/L6iehpwnYDKSn3mB9fp+gw38=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ItebexXJRmNBtIc5DpaZfxG3snAPcpztaCgdqAiMuLKZe66jti9Wm0wgYM1TyOSmA
         uolFpiHRhx+EQ3YL/ZZIBg4L9fz4UmqK0Pdk66MxUB+coCo8bw8j/e+7Z4cd70aGYi
         U+YdAAxjyJbkinibwr2F06opyxj0CxpGWIMSEYy19qw+q9MqbmBS5oXXP4xJjMy3z4
         Ree00PPBD20X+optM5WUQkHipqUlPE+ocm6W2qrW0NIqy3uqPnp7MThADt+8PNpk09
         2AHgn8QpbB9p/+fOph9ekS+0DcnPdezKcrvXp879FrxRFG0BOZWid7Sxa6IXtP7Zl/
         caE+cVs1jHMbw==
Date:   Mon, 20 Mar 2023 11:09:52 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Blakey <paulb@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH xfrm-next 0/9] Extend packet offload to fully support
 libreswan
Message-ID: <20230320090952.GI36557@unreal>
References: <cover.1678714336.git.leon@kernel.org>
 <ZBgfyumyJL10F4g6@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBgfyumyJL10F4g6@gauss3.secunet.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 09:56:42AM +0100, Steffen Klassert wrote:
> On Tue, Mar 14, 2023 at 10:58:35AM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Hi Steffen,
> > 
> > The following patches are an outcome of Raed's work to add packet
> > offload support to libreswan [1].
> > 
> > The series includes:
> >  * Priority support to IPsec policies
> >  * Statistics per-SA (visible through "ip -s xfrm state ..." command)
> >  * Support to IKE policy holes
> >  * Fine tuning to acquire logic.
> > 
> > --------------------------
> > Future submission roadmap, which can be seen here [2]:
> >  * Support packet offload in IPsec tunnel mode
> >  * Rework lifetime counters support to avoid HW bugs/limitations
> >  * Some general cleanup.
> > 
> > So how do you want me to route the patches, as they have a dependency between them?
> > xfrm-next/net-next/mlx5-next?
> 
> As the changes to the xfrm core are just minor compared to the rest
> of the patchset, I'd not absolutely require to route it through
> ipsec-next. Do it as you prefer, but let me know how you plan
> to do it.

I prefer to prepare and send PR directly to netdev, but I need your
Acked-by on xfrm patches first, before doing it.

Thanks
