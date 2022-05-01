Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA2A516348
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 10:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242121AbiEAJAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 05:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236733AbiEAJAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 05:00:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7982B7E3
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 01:56:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76E0D60C95
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 08:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B33C385A9;
        Sun,  1 May 2022 08:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651395399;
        bh=CwCAlXfFr2As0qjLqQPvy+ORLEri1REpP87lS9WN8NY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pbtk/AbJO7SgIbzTZiuswI2Gedpzd01XVfzE9MbuUAfQVGGR2W+6K5rvllofsDT8n
         M+ZenVQDLa1aVjMfU/GuiWkz63UCuLGYx1w3hMVAG3QSjNWQZTTbXkPSgYAtGnLKcy
         brwYhCFkZQJnGyqwhsTdFsmqWliTXeruZllbSk0vWIWEE801lQK+gBnEfeyRuWgWtL
         nOE9YVhZe5NSkrtzuGOgyqDDxZ2Xz/iMjlm6mqn3sfiyZpbVIyI4SZq8hHQ1dgW8hI
         KhIHYn9QPse7WPtfoT9rC/soXL/Me5/F5RHNKOEdSfY7W6b76HDAQG37wueYP0ZjEV
         XlPb90MdVe9qQ==
Date:   Sun, 1 May 2022 11:56:35 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH net-next v1 09/17] net/mlx5: Simplify HW context
 interfaces by using SA entry
Message-ID: <Ym5LQyPYeHQx2UNW@unreal>
References: <cover.1650363043.git.leonro@nvidia.com>
 <3ad7b80c6f58d938550dd3259c5eaaecd8833af4.1650363043.git.leonro@nvidia.com>
 <20220422221935.xf5yvx5i3yt55qho@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422221935.xf5yvx5i3yt55qho@sx1>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 03:19:35PM -0700, Saeed Mahameed wrote:
> On 19 Apr 13:13, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > SA context logic used multiple structures to store same data
> > over and over. By simplifying the SA context interfaces, we
> > can remove extra structs.
> > 
> > Reviewed-by: Raed Salem <raeds@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> > .../mellanox/mlx5/core/en_accel/ipsec.c       |  50 ++---
> > .../mellanox/mlx5/core/en_accel/ipsec.h       |  27 ++-
> > .../mlx5/core/en_accel/ipsec_offload.c        | 182 ++++--------------
> > 3 files changed, 62 insertions(+), 197 deletions(-)

<...>

> > -static int mlx5_create_ipsec_obj(struct mlx5_core_dev *mdev,
> > -				 struct mlx5_ipsec_obj_attrs *attrs,
> > -				 u32 *ipsec_id)
> 
> I don't see the point of this change, the function used to receive two
> primitives, now it receives a god object, just to grab the two primitives,
> this breaks the bottom up design, and contaminates the code with the
> sa_entry container, that only should be visible by high-level ipsec module and
> the SA DB, all service and low level functions should remain as
> primitive and simple as possible to avoid future abuse and reduce the scope
> and visibility of god objects. The effect of this change is more severe in
> the next patch.
> 
> Even within the same file, i still recommend a monotonic bottom up
> design and keep the complex objects usage to as few hight level functions
> as possible.

Like you said: same file, same data copied in and out - it is not bottom
up design for me.

Thanks
