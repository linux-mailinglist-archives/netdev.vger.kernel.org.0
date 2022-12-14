Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3D564C295
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 04:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237109AbiLNDMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 22:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236910AbiLNDMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 22:12:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE9FED
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 19:12:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF95260B5A
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 03:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77F4C433EF;
        Wed, 14 Dec 2022 03:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670987555;
        bh=Ge/57PmwkIaCoOixxazI6O0UUvTQxryyZ77gcuXZz7k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CLt/ww8B59ZQPkwrVXM6tN4U3TwtYjVMLCIUULveprBVSBLLAYG7QNh7TT42myUgF
         HJZFrms023bvxZxjWFXzShJCM0qJrh7G5JoUqdUb6i2b937mUeFPCzmr4Cz/pYXDt3
         WQCtrrW1CufoyWJbqPmj4vY9kce6l85fhjtYxqZvvubVpmP0RlB/BRQuG9DcGfkxEm
         VEyYBVhtdDLZz7IkiaBRsQqrH5OSqozl204xHom6o1EB+MJbyEn+qD/Be3MBe1xkPI
         2tCNXZLEFvco2JenJk/XLj/Y7DEy0QbJyhq/2cnjHwWYpKuX3Y/ZBBfLqkLPCwmtF2
         dIkAi4dUax+5Q==
Date:   Tue, 13 Dec 2022 19:12:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Nir Levy <bhr166@gmail.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: atm: Fix use-after-free bug in
 atm_dev_register()
Message-ID: <20221213191233.5d0a7c8f@kernel.org>
In-Reply-To: <Y5bUXjhM3mvUkwNL@unreal>
References: <20221211124943.3004-1-bhr166@gmail.com>
        <Y5bUXjhM3mvUkwNL@unreal>
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

On Mon, 12 Dec 2022 09:12:30 +0200 Leon Romanovsky wrote:
> > v2: Call put_device in atm_register_sysfs instead of atm_dev_register.
> 
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

On one of the previous versions you commented that
atm_unregister_sysfs() also needs to move to unregister() rather 
than del():

https://lore.kernel.org/all/Y48CwyATYAAcPgqT@unreal/

Is that not the case?

Also atm_dev_register() still frees the dev on atm_register_sysfs()
failure, is that okay?
