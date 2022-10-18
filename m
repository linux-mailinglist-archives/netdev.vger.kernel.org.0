Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 659F560261B
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 09:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiJRHrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 03:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiJRHro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 03:47:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D403718F;
        Tue, 18 Oct 2022 00:47:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24BBC6148F;
        Tue, 18 Oct 2022 07:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02035C433D6;
        Tue, 18 Oct 2022 07:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666079262;
        bh=dTb8BDS1O5vbDAjfxZNFnpPKuW0eQTPLw9NpNDarqMQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lZIVD2TD7r/UVWBk/IwsGcztgYvv9uSinp0gZ/s2bzq0qFBzl81OpJU5fQAQFfg9D
         1rfheCdC3GHUdKBK4dVYvZAUUQmwldYrVh1zEWp/3V3/a2aaPWI4qZmzOOr+yMD+0X
         ESKrBWftoix1vtH654FfDKM3jmoHpOpXHulKOZojtKdN442Iu4IViNvDwY/b3hget9
         bsVG4n+P/rPgppugmW2Sb8Q34HXjuI2tactKdouet1jsvOO1WRxYBIKB6eMVQ1axQR
         HlK1AAb1QPx58eckgBJNnzNHbULLGHu8390t13NShpYOLfscwQuP/YGK6f4FAqh9a/
         TF6xe90b9mKGw==
Date:   Tue, 18 Oct 2022 10:47:38 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Aru <aru.kolappan@oracle.com>
Cc:     jgg@ziepe.ca, saeedm@nvidia.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        manjunath.b.patil@oracle.com, rama.nichanamatlu@oracle.com
Subject: Re: [PATCH 1/1] net/mlx5: add dynamic logging for mlx5_dump_err_cqe
Message-ID: <Y05aGuXSEtSt2aS2@unreal>
References: <1665618772-11048-1-git-send-email-aru.kolappan@oracle.com>
 <Y0frx6g/iadBBYgQ@unreal>
 <a7fad299-6df5-e79b-960a-c85c7ea4235a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7fad299-6df5-e79b-960a-c85c7ea4235a@oracle.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 12:12:36PM -0700, Aru wrote:
> Hi Leon,
> 
> Thank you for reviewing the patch.
> 
> The method you mentioned disables the dump permanently for the kernel.
> We thought vendor might have enabled it for their consumption when needed.
> Hence we made it dynamic, so that it can be enabled/disabled at run time.
> 
> Especially, in a production environment, having the option to turn this log
> on/off
> at runtime will be helpful.

While you are interested on/off this specific warning, your change will
cause "to hide" all syndromes as it is unlikely that anyone runs in
production with debug prints.

 -   mlx5_ib_warn(dev, "dump error cqe\n");
 +   mlx5_ib_dbg(dev, "dump error cqe\n");

Something like this will do the trick without interrupting to the others.

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 457f57b088c6..966206085eb3 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -267,10 +267,29 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 	wc->wc_flags |= IB_WC_WITH_NETWORK_HDR_TYPE;
 }
 
-static void dump_cqe(struct mlx5_ib_dev *dev, struct mlx5_err_cqe *cqe)
+static void dump_cqe(struct mlx5_ib_dev *dev, struct mlx5_err_cqe *cqe,
+		     struct ib_wc *wc, int dump)
 {
-	mlx5_ib_warn(dev, "dump error cqe\n");
-	mlx5_dump_err_cqe(dev->mdev, cqe);
+	const char *level;
+
+	if (!dump)
+		return;
+
+	mlx5_ib_warn(dev, "WC error: %d, Message: %s\n", wc->status,
+		     ib_wc_status_msg(wc->status));
+
+	if (dump == 1) {
+		mlx5_ib_warn(dev, "dump error cqe\n");
+		level = KERN_WARNING;
+	}
+
+	if (dump == 2) {
+		mlx5_ib_dbg(dev, "dump error cqe\n");
+		level = KERN_DEBUG;
+	}
+
+	print_hex_dump(level, "", DUMP_PREFIX_OFFSET, 16, 1, cqe, sizeof(*cqe),
+		       false);
 }
 
 static void mlx5_handle_error_cqe(struct mlx5_ib_dev *dev,
@@ -300,6 +319,7 @@ static void mlx5_handle_error_cqe(struct mlx5_ib_dev *dev,
 		wc->status = IB_WC_BAD_RESP_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_LOCAL_ACCESS_ERR:
+		dump = 2;
 		wc->status = IB_WC_LOC_ACCESS_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_REMOTE_INVAL_REQ_ERR:
@@ -328,11 +348,7 @@ static void mlx5_handle_error_cqe(struct mlx5_ib_dev *dev,
 	}
 
 	wc->vendor_err = cqe->vendor_err_synd;
-	if (dump) {
-		mlx5_ib_warn(dev, "WC error: %d, Message: %s\n", wc->status,
-			     ib_wc_status_msg(wc->status));
-		dump_cqe(dev, cqe);
-	}
+	dump_cqe(dev, cqe, wc, dump);
 }
 
 static void handle_atomics(struct mlx5_ib_qp *qp, struct mlx5_cqe64 *cqe64,

> 
> Feel free to share your thoughts.

And please don't top-post.

Thanks
> 
> Thanks,
> Aru
> 
> On 10/13/22 3:43 AM, Leon Romanovsky wrote:
> > On Wed, Oct 12, 2022 at 04:52:52PM -0700, Aru Kolappan wrote:
> > > From: Arumugam Kolappan <aru.kolappan@oracle.com>
> > > 
> > > Presently, mlx5 driver dumps error CQE by default for few syndromes. Some
> > > syndromes are expected due to application behavior[Ex: REMOTE_ACCESS_ERR
> > > for revoking rkey before RDMA operation is completed]. There is no option
> > > to disable the log if the application decided to do so. This patch
> > > converts the log into dynamic print and by default, this debug print is
> > > disabled. Users can enable/disable this logging at runtime if needed.
> > > 
> > > Suggested-by: Manjunath Patil <manjunath.b.patil@oracle.com>
> > > Signed-off-by: Arumugam Kolappan <aru.kolappan@oracle.com>
> > > ---
> > >   drivers/infiniband/hw/mlx5/cq.c | 2 +-
> > >   include/linux/mlx5/cq.h         | 4 ++--
> > >   2 files changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
> > > index be189e0..890cdc3 100644
> > > --- a/drivers/infiniband/hw/mlx5/cq.c
> > > +++ b/drivers/infiniband/hw/mlx5/cq.c
> > > @@ -269,7 +269,7 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
> > >   static void dump_cqe(struct mlx5_ib_dev *dev, struct mlx5_err_cqe *cqe)
> > >   {
> > > -	mlx5_ib_warn(dev, "dump error cqe\n");
> > > +	mlx5_ib_dbg(dev, "dump error cqe\n");
> > This path should be handled in switch<->case of mlx5_handle_error_cqe()
> > by skipping dump_cqe for MLX5_CQE_SYNDROME_REMOTE_ACCESS_ERR.
> > 
> > diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
> > index be189e0525de..2d75c3071a1e 100644
> > --- a/drivers/infiniband/hw/mlx5/cq.c
> > +++ b/drivers/infiniband/hw/mlx5/cq.c
> > @@ -306,6 +306,7 @@ static void mlx5_handle_error_cqe(struct mlx5_ib_dev *dev,
> >                  wc->status = IB_WC_REM_INV_REQ_ERR;
> >                  break;
> >          case MLX5_CQE_SYNDROME_REMOTE_ACCESS_ERR:
> > +               dump = 0;
> >                  wc->status = IB_WC_REM_ACCESS_ERR;
> >                  break;
> >          case MLX5_CQE_SYNDROME_REMOTE_OP_ERR:
> > 
> > Thanks
