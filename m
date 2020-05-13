Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923141D1D9B
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 20:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390080AbgEMShy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 14:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732218AbgEMShx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 14:37:53 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFA4B205CB;
        Wed, 13 May 2020 18:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589395074;
        bh=N0Mkr91uJ4WFqvYgVPvbeXAxf/CmnN7V/tGMkMy9eUI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZoZ5HyPJwHw3fqJshTe600mvKEtOX5aa4xZjq30yWoixpbTVmcc9mPwTI+xJLJaxH
         KeoBKJgab0H0zOhmif5fNLNMWaQKreDHBmi/YrBxq8h/g2r3/hS03F8O0NVJYif467
         oJ0lUDFf9QBvrVK2Ss3LjJ7ETE2R8ht8l2KZs1+U=
Date:   Wed, 13 May 2020 21:37:49 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IB/mlx4: Replace zero-length array with flexible-array
Message-ID: <20200513183749.GZ4814@unreal>
References: <20200507185921.GA15146@embeddedor>
 <20200513183335.GB29202@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513183335.GB29202@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 03:33:35PM -0300, Jason Gunthorpe wrote:
> On Thu, May 07, 2020 at 01:59:21PM -0500, Gustavo A. R. Silva wrote:
> > The current codebase makes use of the zero-length array language
> > extension to the C90 standard, but the preferred mechanism to declare
> > variable-length types such as these ones is a flexible array member[1][2],
> > introduced in C99:
> >
> > struct foo {
> >         int stuff;
> >         struct boo array[];
> > };
> >
> > By making use of the mechanism above, we will get a compiler warning
> > in case the flexible array does not occur last in the structure, which
> > will help us prevent some kind of undefined behavior bugs from being
> > inadvertently introduced[3] to the codebase from now on.
> >
> > Also, notice that, dynamic memory allocations won't be affected by
> > this change:
> >
> > "Flexible array members have incomplete type, and so the sizeof operator
> > may not be applied. As a quirk of the original implementation of
> > zero-length arrays, sizeof evaluates to zero."[1]
> >
> > sizeof(flexible-array-member) triggers a warning because flexible array
> > members have incomplete type[1]. There are some instances of code in
> > which the sizeof operator is being incorrectly/erroneously applied to
> > zero-length arrays and the result is zero. Such instances may be hiding
> > some bugs. So, this work (flexible-array member conversions) will also
> > help to get completely rid of those sorts of issues.
> >
> > This issue was found with the help of Coccinelle.
> >
> > [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> > [2] https://github.com/KSPP/linux/issues/21
> > [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> >
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> > ---
> >  include/linux/mlx4/qp.h |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Applied to for-next, thanks

Jason,

Please be cautious here, Jakub already applied this patch.
https://lore.kernel.org/lkml/20200509205151.209bdc9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/

>
> Jason
