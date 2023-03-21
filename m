Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29FD6C2BBE
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 08:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjCUHzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 03:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjCUHzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 03:55:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DEA17148;
        Tue, 21 Mar 2023 00:55:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40AE8B812A3;
        Tue, 21 Mar 2023 07:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D17AC433EF;
        Tue, 21 Mar 2023 07:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679385303;
        bh=h5bQVxRQvAsST2mqErHAO6iYNKATPLexOj7785muCJY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ENyUDocswO4ft5+2c7JSJpNmKoUcBQOh98qwTT+RPCX3a4365m6jaELWcdfMmusSI
         zupQTFKKtig0J+v3LFauXv2K1mfP2X8ZsOubwmkUXsBhHAOuKP/UXpeE4HXffpqErb
         dBWFliZjq6wUSm/QHFAxXGkydGsU46LiS+ESp+Qd/hHr2MEG1LFhlwsuVddb0dX61M
         KT54M2Yl1T8U6IxgTdpzQZF2Jk02TaOeOgcalZn2CK9FQ8Sk6lX3V5j6FdD+NsSCae
         57swP4xy/Ta+oBC25FEYVGDi4SOb1mBLCW1H8lc+NPVX8P/+rAtUWNOLFsoQGJt5MQ
         6vLsZxYGkfhQA==
Date:   Tue, 21 Mar 2023 09:54:58 +0200
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
Message-ID: <20230321075458.GP36557@unreal>
References: <cover.1678973858.git.leon@kernel.org>
 <1a064e9d1b372a73860faf053b3ac12c3315e2cd.1678973858.git.leon@kernel.org>
 <ZBixdlVsR5dl3J7Y@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBixdlVsR5dl3J7Y@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 04:18:14PM -0300, Jason Gunthorpe wrote:
> On Thu, Mar 16, 2023 at 03:39:27PM +0200, Leon Romanovsky wrote:
> > From: Patrisious Haddad <phaddad@nvidia.com>
> > 
> > Previously when destroying a DCT, if the firmware function for the
> > destruction failed, the common resource would have been destroyed
> > either way, since it was destroyed before the firmware object.
> > Which leads to kernel warning "refcount_t: underflow" which indicates
> > possible use-after-free.
> > Which is triggered when we try to destroy the common resource for the
> > second time and execute refcount_dec_and_test(&common->refcount).
> > 
> > So, currently before destroying the common resource we check its
> > refcount and continue with the destruction only if it isn't zero.
> 
> This seems super sketchy
> 
> If the destruction fails why not set the refcount back to 1?

Because destruction will fail in destroy_rq_tracked() which is after
destroy_resource_common().

In first destruction attempt, we delete qp from radix tree and wait for all
reference to drop. In order do not undo all this logic (setting 1 alone is
not enough), it is much safer simply skip destroy_resource_common() in reentry
case.

Failure to delete means that something external to kernel holds reference to that
QP, but it is safe to delete from kernel as nothing in kernel can use it after call
to destroy_resource_common().

Thanks

> 
> Jason
