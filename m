Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 118F35637F8
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 18:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbiGAQdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 12:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbiGAQdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 12:33:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4612B369FC
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 09:33:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02F3CB830A5
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 16:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB92C3411E;
        Fri,  1 Jul 2022 16:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656693197;
        bh=swmGFcfZU95LMH/F9gV6NgoDd163U6++cnztcJGyYBE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K+Ye2LkLG6hKNsWp4P6/kvjZRbHsbOpVAix+64YOtWQ4iU7c7pBhuPp/kJdxqeE2A
         kx4l/NMlGxlowkNOnd4W62EdRSW1+Dv5aWomZGEIAn1YLgiH1qH/6adZBEzMF3Dl5E
         wYqnpavAGAbquZDjtJqnL27wDqWvw7rg3oGGnABWKLy80laZMF7fpCg1rZABCyle+w
         V922CmoVU4BRM930vpvR6ZhY4mAmrW4cUXuhxihwJmsTciHrKIS1lAMnSSu+UExHBZ
         kinJ3qksesmZIHxwroSPOAUTrX+/+ZvZAqoXvqAYXN5CHr0wBto39T0O1xtAmovmIf
         Drb+a4TNgtlag==
Date:   Fri, 1 Jul 2022 09:33:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: Re: [patch net-next 2/3] net: devlink: call lockdep_assert_held()
 for devlink->lock directly
Message-ID: <20220701093316.410157f3@kernel.org>
In-Reply-To: <20220701095926.1191660-3-jiri@resnulli.us>
References: <20220701095926.1191660-1-jiri@resnulli.us>
        <20220701095926.1191660-3-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  1 Jul 2022 11:59:25 +0200 Jiri Pirko wrote:
> In devlink.c there is direct access to whole struct devlink so there is
> no need to use helper. So obey the customs and work with lock directly
> avoiding helpers which might obfuscate things a bit.

> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 25b481dd1709..a7477addbd59 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -10185,7 +10185,7 @@ int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
>  	struct devlink *devlink = devlink_port->devlink;
>  	struct devlink_rate *devlink_rate;
>  
> -	devl_assert_locked(devlink_port->devlink);
> +	lockdep_assert_held(&devlink_port->devlink->lock);

I don't understand why. Do we use lockdep asserts directly on rtnl_mutex
in rtnetlink.c?
