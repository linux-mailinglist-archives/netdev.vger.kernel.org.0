Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375FB6BDB27
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 22:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjCPVyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 17:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjCPVyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 17:54:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0DB24122;
        Thu, 16 Mar 2023 14:54:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A38C162080;
        Thu, 16 Mar 2023 21:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31B0C433D2;
        Thu, 16 Mar 2023 21:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679003660;
        bh=K3UNssMD1oUQCyet+zxbfyXr1tNNX+nNPwdj1dW2wbQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BLpr2MZzMQJxSYQuhS4yEzbUEjJq6+sIHwcE4XaPUsYQylOVHUJwPjAQ/11lKhPTe
         LwdTc9AN4W9GNSa4VxpAvRURDtdkhO6lUVDeS36Tx2a/FM0Oe7BJXf3T5uxlwzK50G
         HUMj/2AeZvtJFQasX4HaA9pr2EhPlqC/mTtCu++KztwmGSmWgRyScDO9B7FjZG9Myu
         sOcP9vkIitIc7z+H3LGS+2rd0zcZHSL2qx3vvEpoEduLoTw8R7rkd7tOSCa5N5qHWI
         itt8Mpyd7dXJ5adDoIET+9j/a7J+FGJv54GEknIj4EMq3I4YEVH3VMrmkioxfUjg7B
         73E2VBe260y5Q==
Date:   Thu, 16 Mar 2023 14:54:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Tariq Toukan <ttoukan.linux@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, tariqt@nvidia.com, bpf@vger.kernel.org
Subject: Re: [PATCH net] net: xdp: don't call notifiers during driver init
Message-ID: <20230316145418.3af738c3@kernel.org>
In-Reply-To: <ZBL3nVZ4LVWUPRva@localhost.localdomain>
References: <20230316002903.492497-1-kuba@kernel.org>
        <ebe10b79-34c2-4e85-2cf7-b7491266748e@gmail.com>
        <ZBL3nVZ4LVWUPRva@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Mar 2023 12:03:57 +0100 Lorenzo Bianconi wrote:
> > I maybe need to dig deeper, but, it looks strange to still
> > call_netdevice_notifiers in cases > NETREG_REGISTERED.
> > 
> > Isn't it problematic to call it with NETREG_UNREGISTERED ?
> > 
> > For comparison, netif_set_real_num_tx_queues has this ASSERT_RTNL() only
> > under dev->reg_state == NETREG_REGISTERED || dev->reg_state ==
> > NETREG_UNREGISTERING.  
> 
> does it make sense to run call_netdevice_notifiers() in xdp_set_features_flag()
> just if dev->reg_state is NETREG_REGISTERED?

I was thinking - we'll adjust it if someone complains, but indeed
the detection is somewhat weak, a call on a dead device but under
rtnl_lock won't warn. Let me just copy what the queue helpers do,
exactly, then.

> Moreover, looking at the code it seems netdev code can run with dev->reg_state
> set to NETREG_UNREGISTERED and without holding RTNL lock, right?

You mean - part of unregistration is done without rtnl lock held?
