Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B356C3134
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 13:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbjCUMDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 08:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCUMDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 08:03:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FAA4BEB1;
        Tue, 21 Mar 2023 05:03:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01DDAB8163C;
        Tue, 21 Mar 2023 12:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63E9C433D2;
        Tue, 21 Mar 2023 12:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679400184;
        bh=DKgnq/M13pVNuOOzlN17KcsCEqglAFkiJvFXeQc14tY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZTUDQ+Z8AoG9dETJAMaRUyYvcscd8EKkf2P1rQCDGhVhJ2XfPpC+k+xuN5oT87hAS
         8krEakNiwmZH1Pw7mdfDPj5pfDrTOU0zmOBIH2z+nPHtmUG8FV7tuZkf6QPPuL6+5S
         xw/lkQ7PMK9fgFoP0ezlQlaI8ZHU7HALtiCT5kfomuSeKRzgv/H6n7jRgyADaKKSrc
         4sjYMSGREOgM2njuAsg75YwOyadqJo4kZ2FcMjnE10kfLF3Q/sR8iLpxGh5Zuk6DR7
         QOB+cIAreSjQVe70+k4JXgl9rV0rJI5e1m/M0vf9aY7jkHtJzk8Farp7qg7FnfKKth
         DVF7SxS8OiZ2g==
Date:   Tue, 21 Mar 2023 14:02:59 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Patrisious Haddad <phaddad@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next v1 2/3] RDMA/mlx5: Handling dct common resource
 destruction upon firmware failure
Message-ID: <20230321120259.GT36557@unreal>
References: <cover.1678973858.git.leon@kernel.org>
 <1a064e9d1b372a73860faf053b3ac12c3315e2cd.1678973858.git.leon@kernel.org>
 <ZBixdlVsR5dl3J7Y@nvidia.com>
 <20230321075458.GP36557@unreal>
 <ZBmav4CF1yqRvyzZ@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBmav4CF1yqRvyzZ@nvidia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 08:53:35AM -0300, Jason Gunthorpe wrote:
> On Tue, Mar 21, 2023 at 09:54:58AM +0200, Leon Romanovsky wrote:
> > On Mon, Mar 20, 2023 at 04:18:14PM -0300, Jason Gunthorpe wrote:
> > > On Thu, Mar 16, 2023 at 03:39:27PM +0200, Leon Romanovsky wrote:
> > > > From: Patrisious Haddad <phaddad@nvidia.com>
> > > > 
> > > > Previously when destroying a DCT, if the firmware function for the
> > > > destruction failed, the common resource would have been destroyed
> > > > either way, since it was destroyed before the firmware object.
> > > > Which leads to kernel warning "refcount_t: underflow" which indicates
> > > > possible use-after-free.
> > > > Which is triggered when we try to destroy the common resource for the
> > > > second time and execute refcount_dec_and_test(&common->refcount).
> > > > 
> > > > So, currently before destroying the common resource we check its
> > > > refcount and continue with the destruction only if it isn't zero.
> > > 
> > > This seems super sketchy
> > > 
> > > If the destruction fails why not set the refcount back to 1?
> > 
> > Because destruction will fail in destroy_rq_tracked() which is after
> > destroy_resource_common().
> > 
> > In first destruction attempt, we delete qp from radix tree and wait for all
> > reference to drop. In order do not undo all this logic (setting 1 alone is
> > not enough), it is much safer simply skip destroy_resource_common() in reentry
> > case.
> 
> This is the bug I pointed a long time ago, it is ordered wrong to
> remove restrack before destruction is assured

It is not restrack, but internal to mlx5_core structure.

  176 static void destroy_resource_common(struct mlx5_ib_dev *dev,
  177                                     struct mlx5_core_qp *qp)
  178 {
  179         struct mlx5_qp_table *table = &dev->qp_table;
  180         unsigned long flags;
  181

....

  185         spin_lock_irqsave(&table->lock, flags);
  186         radix_tree_delete(&table->tree,
  187                           qp->qpn | (qp->common.res << MLX5_USER_INDEX_LEN));
  188         spin_unlock_irqrestore(&table->lock, flags);
  189         mlx5_core_put_rsc((struct mlx5_core_rsc_common *)qp);
  190         wait_for_completion(&qp->common.free);
  191 }


> 
> Jason
