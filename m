Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA5B4F5D57
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 14:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbiDFMMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 08:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbiDFML7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 08:11:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6369F362014;
        Wed,  6 Apr 2022 00:55:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC08361B33;
        Wed,  6 Apr 2022 07:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C70C385A1;
        Wed,  6 Apr 2022 07:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649231735;
        bh=pIU6sCODsIEGzX8DXmWz/+uusMOWPOQIIcIBN61QHiw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A9O0uOEDLb0E2N/CnlJcGEG+VmVFBtHNjPT856WHkswPUrMCMKmwVgTCIwhC3bxiH
         H3G4+fvg9l8ST6XybA1Nrs1TzhJjIUruoqXl1IickHaQmb6e5j5IIs7hlkzgS4iWFN
         se5NsuBW7ojaax+2e3CzuXBrVoO12ZXb2woEwHUVDYcSLRPB9VgmTpxto5N22gg0pa
         Ryhn9Iznz2PU5nmN0wpcVA11dBUSiy17SoAMlxCtX6LtOh9XWb9fuMB2KLkQjjhNpl
         PuhPuyVSYV2i8Ka+8cmHKt/kKOmpQkevumu+HRhDMQTjWT8urf+/dY/QsiChGfic5T
         YMd6y06s7VJJg==
Date:   Wed, 6 Apr 2022 10:55:31 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Patrisious Haddad <phaddad@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH mlx5-next 1/3] net/mlx5: Nullify eq->dbg and qp->dbg
 pointers post destruction
Message-ID: <Yk1Hc8l5bs25wEcE@unreal>
References: <cover.1649139915.git.leonro@nvidia.com>
 <032d54e1ed92d0f288b385d6343a5b6e109daabe.1649139915.git.leonro@nvidia.com>
 <20220405194845.c443x4gf522c2kgv@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405194845.c443x4gf522c2kgv@sx1>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 12:48:45PM -0700, Saeed Mahameed wrote:
> On 05 Apr 11:12, Leon Romanovsky wrote:
> > From: Patrisious Haddad <phaddad@nvidia.com>
> > 
> > Prior to this patch in the case that destroy_unmap_eq()
> > failed and was called again, it triggered an additional call of
> 
> Where is it being failed and called again ? this shouldn't even be an
> option, we try to keep mlx5 symmetrical, constructors and destructors are
> supposed to be called only once in their respective positions.
> the callers must be fixed to avoid re-entry, or change destructors to clear
> up all resources even on failures, no matter what do not invent a reentry
> protocols to mlx5 destructors.

It can happen when QP is exposed through DEVX interface. In that flow,
only FW knows about it and reference count all users. This means that
attempt to destroy such QP will fail, but mlx5_core is structured in
such way that all cleanup was done before calling to FW to get
success/fail response.

For more detailed information, see this cover letter:
https://lore.kernel.org/all/20200907120921.476363-1-leon@kernel.org/

<...>

> > int mlx5_eq_destroy_generic(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
> > {
> > +	struct mlx5_eq_table *eq_table = dev->priv.eq_table;
> > 	int err;
> > 
> > 	if (IS_ERR(eq))
> > 		return -EINVAL;
> > 
> > -	err = destroy_async_eq(dev, eq);
> > +	mutex_lock(&eq_table->lock);
> 
> Here you are inventing the re-entry. Please drop this and fix properly. And
> avoid boolean parameters to mlx5 core
> functions as much as possible, let's keep mlx5_core simple.

If after reading the link above, you were not convinced, let's take it offline.

Thanks
