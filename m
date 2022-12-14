Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71EB364C480
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 08:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237538AbiLNHvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 02:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237342AbiLNHvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 02:51:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39DA1AF00
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 23:51:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 763DE617F4
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 07:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18223C433EF;
        Wed, 14 Dec 2022 07:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671004273;
        bh=73X2UfaQ6K5nlHyk8iDz1B9vETU61BYsdzqVT9sIzLk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C851pKNhc0y9b7ObZjHgootcQ4wmfWb3MKTdHruZFVPue1wq6Bt/vj47A/+C30Dcw
         G40cMWH4tu4aY0f/i7F4kqK5/6y2GTgvO0HX35k3Dtsx77NdZ6JPkunyZ27MQi2vfX
         GgFYW2X3/4U9cwYGdGQONbHSFYDzYCgErrldA7HmNwIQiH8sr1E5NaEnSoi4xIicTv
         X73KvcQaKIwT8eS51iDws1NF92lhZZAESelqgAjhYA/hHXUrHIx4jmUXIse8aRE6+j
         Idikhwe+MiCAx4RMLpapxvfG62gFG5/oSpmX6Ix8E2S+Ac7mZwmc8TdTtf//9jQh1U
         r/5tr6haw7cTg==
Date:   Wed, 14 Dec 2022 09:51:09 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Nir Levy <bhr166@gmail.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: atm: Fix use-after-free bug in
 atm_dev_register()
Message-ID: <Y5mAbfpeHEuQp0BE@unreal>
References: <20221211124943.3004-1-bhr166@gmail.com>
 <Y5bUXjhM3mvUkwNL@unreal>
 <20221213191233.5d0a7c8f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213191233.5d0a7c8f@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 07:12:33PM -0800, Jakub Kicinski wrote:
> On Mon, 12 Dec 2022 09:12:30 +0200 Leon Romanovsky wrote:
> > > v2: Call put_device in atm_register_sysfs instead of atm_dev_register.
> > 
> > Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> 
> On one of the previous versions you commented that
> atm_unregister_sysfs() also needs to move to unregister() rather 
> than del():
> 
> https://lore.kernel.org/all/Y48CwyATYAAcPgqT@unreal/
> 
> Is that not the case?

Yes, it should, but it is much larger change than this fix and someone
needs to do it as a separate patch.

You can't simply replace device_del() in atm_unregister_sysfs() because
how atm_dev_put() is implemented. The latter blindly calls to put_device(&dev->class_dev)
and you can't remove it without close look on all atm_dev_put() callers.

> 
> Also atm_dev_register() still frees the dev on atm_register_sysfs()
> failure, is that okay?

Yes, the kernel panic points that class_dev (not dev) had use-after-free.

Thanks
