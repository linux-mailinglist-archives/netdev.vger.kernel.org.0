Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04C34D6846
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 19:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348473AbiCKSHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 13:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232941AbiCKSHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 13:07:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6878A1B0BE3
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 10:06:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAF7661DE0
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 18:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9A2C340E9;
        Fri, 11 Mar 2022 18:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647021973;
        bh=uzIz31H32YMY2CM7DldcEaXDBPW8YpRtyJyolL9vCgo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tpL+e34dfHMyYaJrQ840I6FWzFhpzM+3F2bei9ogM7nrWSr0frisdgpfS6V/nB3ta
         V+VlLceRhmdhRNWGaX+JLkb4CW2qVg92ESsIfCEv3ky6SDv2q5gcJiWGR0iWggKAkP
         0/hxamTqN7Yx4ET41R2x2CU9UirJmdy4Q0to3jv36RxJ08tzFE7lU5zCEJT/M8aiOr
         vP4JiAsPNWimgIWt3dcN5l175ZvsbwYL99a/2GWauTJ+gh0OGuW3zFcSUtD8CS5e6V
         rBwxwn/WnMhZu2X35ex7XDXYjolFdgnUte4iD3QAdJycaAzkdGNgATCMCrfdY89MSv
         M3X0J4yE5Fcjw==
Date:   Fri, 11 Mar 2022 10:06:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     <idosch@nvidia.com>, <petrm@nvidia.com>,
        <simon.horman@corigine.com>, <netdev@vger.kernel.org>,
        <jiri@resnulli.us>
Subject: Re: [RFT net-next 1/6] devlink: expose instance locking and add
 locked port registering
Message-ID: <20220311100611.2993ff4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YiuLsDa4jej7bVEz@unreal>
References: <20220310001632.470337-1-kuba@kernel.org>
        <20220310001632.470337-2-kuba@kernel.org>
        <Yit0QFjt7HAHFNnq@unreal>
        <20220311082611.5bca7d5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <Yit/f9MQWusTmsJW@unreal>
        <20220311093913.60694baf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YiuLsDa4jej7bVEz@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Mar 2022 19:49:36 +0200 Leon Romanovsky wrote:
> > No, no, that function is mostly for rcu dereference checking.
> > The calls should be eliminated as dead code on production systems.  
> 
> On systems without LOCKDEP, the devl_lock_is_held function will be
> generated to be like this:
> bool devl_lock_is_held(struct devlink *devlink)
> {
> 	return WARN_ON_ONCE(true);
> }
> EXPORT_SYMBOL_GPL(devl_lock_is_held);

I think you missed my first sentence. Anyway, this is what I'll do in
v1:

#ifdef CONFIG_LOCKDEP
/* For use in conjunction with LOCKDEP only e.g. rcu_dereference_protected() */
bool devl_lock_is_held(struct devlink *devlink)
{
	return lockdep_is_held(&devlink->lock);
}
EXPORT_SYMBOL_GPL(devl_lock_is_held);
#endif
