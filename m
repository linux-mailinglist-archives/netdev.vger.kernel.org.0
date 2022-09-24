Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949B95E8F6C
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 20:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbiIXSvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 14:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiIXSvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 14:51:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7951D4B0E3
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 11:51:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AE3D6108D
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 18:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2D0C433D6;
        Sat, 24 Sep 2022 18:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664045501;
        bh=SBwsx2Bku90wjvj4IgO5Xqo4zAkx6rl0b66DMwcbMGY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZwZtgFJFFltPNgIZWHvHV5qMBgkjzx5U+w4yXqGuZBXAumrjLfGxVDQlpylrftX/e
         9vyg0mDGe49kxU83E7fI4iEcJTmkL9NTwvMldW4akyCsisG4IfHhNgLUSgu3SG1y+f
         yNB8pqG2aIeNGzEshfrFrKAB/fUKsWsvhv029ZDyN3lZS9hCAzwSvQq8YB6JWKxQ7X
         t4uC/dZUxbRLdj5ZQklSw0NCilU1BP7ZXozXBtx00yHR6M6wqLzaWnp+Sqw/ocsLqK
         G07GDkPliR9CXmuzwk1ip14PBbm1DwLIkwPG9NHIGi+ZXA6b8i7rMA/dEY8ieDuj7+
         yGek7qxVhiNwQ==
Date:   Sat, 24 Sep 2022 21:51:37 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] net/mlx5: Make ASO poll CQ usable in atomic
 context
Message-ID: <Yy9RuS1AaEe45iLZ@unreal>
References: <d941bb44798b938705ca6944d8ee02c97af7ddd5.1664017836.git.leonro@nvidia.com>
 <20220924172425.bfagbky4h5tbcxf4@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220924172425.bfagbky4h5tbcxf4@fedora>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 24, 2022 at 10:24:25AM -0700, Saeed Mahameed wrote:
> On 24 Sep 14:17, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Poll CQ functions shouldn't sleep as they are called in atomic context.
> > The following splat appears once the mlx5_aso_poll_cq() is used in such
> > flow.
> > 
> > BUG: scheduling while atomic: swapper/17/0/0x00000100
> 
> ...
> 
> > 	/* With newer FW, the wait for the first ASO WQE is more than 2us, put the wait 10ms. */
> > -	err = mlx5_aso_poll_cq(aso, true, 10);
> > +	expires = jiffies + msecs_to_jiffies(10);
> > +	do {
> > +		err = mlx5_aso_poll_cq(aso, true);
> > +	} while (err && time_is_after_jiffies(expires));
> > 	mutex_unlock(&flow_meters->aso_lock);
>         ^^^^
> busy poll won't work, this mutex is held and can sleep anyway.
> Let's discuss internally and solve this by design.

This is TC code, it doesn't need atomic context and had mutex + sleep
from the beginning.

My change cleans mlx5_aso_poll_cq() from busy loop for the IPsec path,
so why do you plan to change in the design?

Thanks
