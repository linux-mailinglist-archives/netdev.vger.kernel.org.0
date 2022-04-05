Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A927B4F3E44
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 22:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384652AbiDEUFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573253AbiDESem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 14:34:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383DA13F6F;
        Tue,  5 Apr 2022 11:32:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8C68618CE;
        Tue,  5 Apr 2022 18:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6932EC385A4;
        Tue,  5 Apr 2022 18:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649183563;
        bh=FL6Vjlysi/fOyZpJE2rSS+FIJYJRHCiZpiMOwwjfWKo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bS2Cf+uzFDViHR8cb3krNj3czacXlc7byzZjPKhNO5NUVAKnRvgyuk5+wApweFmIj
         pHy5IVyT7lwNS5T3/VDkOQbRuhnkLZXJKkMRwlCInPB5cIUpwRfWYdpLbN8/5ASr52
         +INauoBeJ79nfZrnfNaK40X81MG0NSkSETMesvwdTZBSsRyKq+BFlbZ2RMLOS5b888
         T8a6J0cwq1pfzCcdDS4RYDxESzTzFTBOxcbNhsdnOkxnvo/3NucFHI/jiRnCVW6kEq
         61BN8YYGxDLO7iVr0nuSdY+5+eqS01t9I9QhHjk5VA0mNdNqn1iWZJFGliGwcK8alJ
         YHQX3NGhVT4og==
Date:   Tue, 5 Apr 2022 21:32:39 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH mlx5-next 4/5] net/mlx5: Remove tls vs. ktls separation
 as it is the same
Message-ID: <YkyLR+VBb81npXnC@unreal>
References: <cover.1649073691.git.leonro@nvidia.com>
 <67e596599edcffb0de43f26551208dfd34ac777e.1649073691.git.leonro@nvidia.com>
 <20220405003322.afko7uo527w5j3zu@sx1>
 <YkvW9SNJeb5VPmeg@unreal>
 <20220405172049.slomqla4pmnyczbj@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405172049.slomqla4pmnyczbj@sx1>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 10:20:49AM -0700, Saeed Mahameed wrote:
> On 05 Apr 08:43, Leon Romanovsky wrote:
> > On Mon, Apr 04, 2022 at 05:33:22PM -0700, Saeed Mahameed wrote:
> > > On 04 Apr 15:08, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > >
> > > > After removal FPGA TLS, we can remove tls->ktls indirection too,
> > > > as it is the same thing.
> 
> [...]
> 
> > > rename drivers/net/ethernet/mellanox/mlx5/core/en_accel/{tls_stats.c => ktls_stats.c} (76%)
> > > 
> > > Why not ktls_*.c => tls_*.c ?
> > 
> > Mostly because other drivers use _ktls_ name for this type of functionality.
> > Plus internally, Tariq suggested to squash everything into ktls.
> > 
> > > 
> > > Since we now have one TLS implementation, it would've been easier to maybe
> > > repurpose TLS to be KTLS only and avoid renaming every TLS to KTLS in all
> > > functions and files.
> > > 
> > > So just keep tls.c and all mlx5_tls_xyz functions and implement ktls
> > > directly in them, the renaming will be done only on the ktls implementation
> > > part of the code rather than in every caller.
> > 
> > Should I do it or keep this patch as is?
> > 
> 
> Keep it, i don't have any strong feeling about this,
> I just wanted to reduce the patch size.

Thanks for the review.
