Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A894DB6AE
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 17:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349454AbiCPQu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 12:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350395AbiCPQuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 12:50:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D933701D
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 09:49:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59FEEB81AA4
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 16:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F8FC340E9;
        Wed, 16 Mar 2022 16:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647449341;
        bh=DP21wJSfV3/gKWLVhhJfWV/+F7GtUkTFCV1ZvVYkfzU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ky75S62SeMolbM9X/4i+ews6hOLzxI0ugtlva5eC3xGWLHBnAz0sMgd6f0PKskLFb
         WTZMlWXWSRyi/kO4eElGJtr4+Nu2QfGcFXfGT6P0bGzfj6CRhNuu5ByfsE/SniovMK
         0FHWa7qEIw7e1D+vDYQjmj7CJK/eJViG2CGhtn9pmZNPTorIonaLrtlTUsWiOVG2mL
         Fruy6qLyfAMl0XyKzUFPZM/Fs8J9nWO7L/XiiW73DDlaQMZnASEsDPsUSzEUSdhLmc
         qlsE8NDR19LYZUhUMhtVHDFeMepZi9OQspcMqqKZPBy/4992DTP0VG0s49WVcL7Zpz
         oEsftAmRoLxCg==
Date:   Wed, 16 Mar 2022 09:48:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@nvidia.com,
        idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        louis.peens@corigine.com
Subject: Re: [PATCH net-next 1/6] devlink: expose instance locking and add
 locked port registering
Message-ID: <20220316094859.2128c430@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YjGf3OqijAiqSNE/@unreal>
References: <20220315060009.1028519-1-kuba@kernel.org>
        <20220315060009.1028519-2-kuba@kernel.org>
        <YjGf3OqijAiqSNE/@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Mar 2022 10:29:16 +0200 Leon Romanovsky wrote:
> Sorry that I'm asking you again same question.
> How will this devl_lock_is_held() be used in drivers?
> 
> Right now, if I decide to use this function in mlx5 (or in any other driver),
> the code will be something like this:
> 
> void func(...)
> {
>    ....
>    if (IS_ENABLED(CONFIG_LOCKDEP))
>    	if (rcu_dereference_protected(a, devl_lock_is_held(devlink) == b) {
> 		....
> }
> 
> The line "if (IS_ENABLED(CONFIG_LOCKDEP))" needs to be in every driver
> or it won't compile in release mode.

It follows the semantics of lockdep_is_held(), note that
rcu_dereference_protected() makes the last parameter dead 
code with LOCKDEP=n 

#define RCU_LOCKDEP_WARN(c, s) do { } while (0 && (c))

where (c) would be devl_lock_is_held()

so the call to devl_lock_is_held() is eliminated, and we 
won't get a linker error. There's no need for IS_ENABLED().
