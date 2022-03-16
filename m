Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D414DB809
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 19:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239264AbiCPSku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 14:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235282AbiCPSkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 14:40:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A49755204
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 11:39:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02D35B81CAB
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 18:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315D9C340E9;
        Wed, 16 Mar 2022 18:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647455972;
        bh=lF/6Vfm8rYBgIEmsOLR/nS7i/CTaycv7EEiflJ62M8g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uNj+j24nUoqlg09EObq724lAE9LNMQyTjM5AUTFaA8zWSXx98y7Sf8rD0JqZycR7v
         G+oCX9twOpWXIQqeTuzABFvKcc+ttrgNbW0DM3OU1G/sc0VHeMBGXSA38auf7BV1ij
         EJRvyH6qbqTiBwdi7Owf4oMu74RVNx5xTGFB3I5y1dtumS9cWV8FeYYL5U9bzwcXyl
         I8NkYTha2XbahzUJbnRmQejFgaFxsFjMXVYNGntYjOroMhl+iqlpwWJmwWmxb69Zph
         Rm+nRq+cUqKCQ5rpBZiN5Mthhl+tU0Vllt5GyWdgLy07vTy2ARtZHu8eibH0k6vgka
         nq9ykT2OslFsg==
Date:   Wed, 16 Mar 2022 20:39:28 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@nvidia.com,
        idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        louis.peens@corigine.com
Subject: Re: [PATCH net-next 1/6] devlink: expose instance locking and add
 locked port registering
Message-ID: <YjIu4CBxEJ6UTk7c@unreal>
References: <20220315060009.1028519-1-kuba@kernel.org>
 <20220315060009.1028519-2-kuba@kernel.org>
 <YjGf3OqijAiqSNE/@unreal>
 <20220316094859.2128c430@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316094859.2128c430@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 09:48:59AM -0700, Jakub Kicinski wrote:
> On Wed, 16 Mar 2022 10:29:16 +0200 Leon Romanovsky wrote:
> > Sorry that I'm asking you again same question.
> > How will this devl_lock_is_held() be used in drivers?
> > 
> > Right now, if I decide to use this function in mlx5 (or in any other driver),
> > the code will be something like this:
> > 
> > void func(...)
> > {
> >    ....
> >    if (IS_ENABLED(CONFIG_LOCKDEP))
> >    	if (rcu_dereference_protected(a, devl_lock_is_held(devlink) == b) {
> > 		....
> > }
> > 
> > The line "if (IS_ENABLED(CONFIG_LOCKDEP))" needs to be in every driver
> > or it won't compile in release mode.
> 
> It follows the semantics of lockdep_is_held(), note that
> rcu_dereference_protected() makes the last parameter dead 
> code with LOCKDEP=n 
> 
> #define RCU_LOCKDEP_WARN(c, s) do { } while (0 && (c))

Ahhh, I see, thanks for an explanation.

> 
> where (c) would be devl_lock_is_held()
> 
> so the call to devl_lock_is_held() is eliminated, and we 
> won't get a linker error. There's no need for IS_ENABLED().
