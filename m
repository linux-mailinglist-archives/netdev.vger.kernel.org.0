Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBA95FD7E2
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 12:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiJMKn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 06:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiJMKnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 06:43:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1767E6F79;
        Thu, 13 Oct 2022 03:43:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B7B16177B;
        Thu, 13 Oct 2022 10:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CFDC433C1;
        Thu, 13 Oct 2022 10:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665657803;
        bh=ossWo8LyH8dkodWmbwnkOkO94f2sDxCTIm28ZOqDeQI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=grmcX7AytvVYg3wfKBL7eAaP/T82Ouemrzj420kJXSovTEAcUM/wFqUllwzoN8fiP
         u9TCGWP4onBXuojX012A6alLQgw1T7Nms2bbw2Cjek8oXH3FSYT5NTg9Nf+UeJQo1u
         cY7g8VhRPBGvqO1HNVs0MMaySPgH5qphGWqGdBwoOsn+31sfHIa5KfdMiALbGyqW4C
         xuI7cYBfNbBX+fGh62c7ZZVUBRtWtjpa1KX5em3WtxcUjK2mkE0p4tOSaYKbyA2lAv
         YUg2rICJa/wfxz8toU5FyWffJf8nj+q5BugqiXUiQYUWXOTPKy4lABXM/C5OPjDlhN
         +5+dMZib35+SQ==
Date:   Thu, 13 Oct 2022 13:43:19 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Aru Kolappan <aru.kolappan@oracle.com>
Cc:     jgg@ziepe.ca, saeedm@nvidia.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        manjunath.b.patil@oracle.com, rama.nichanamatlu@oracle.com
Subject: Re: [PATCH  1/1] net/mlx5: add dynamic logging for mlx5_dump_err_cqe
Message-ID: <Y0frx6g/iadBBYgQ@unreal>
References: <1665618772-11048-1-git-send-email-aru.kolappan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1665618772-11048-1-git-send-email-aru.kolappan@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 04:52:52PM -0700, Aru Kolappan wrote:
> From: Arumugam Kolappan <aru.kolappan@oracle.com>
> 
> Presently, mlx5 driver dumps error CQE by default for few syndromes. Some
> syndromes are expected due to application behavior[Ex: REMOTE_ACCESS_ERR
> for revoking rkey before RDMA operation is completed]. There is no option
> to disable the log if the application decided to do so. This patch
> converts the log into dynamic print and by default, this debug print is
> disabled. Users can enable/disable this logging at runtime if needed.
> 
> Suggested-by: Manjunath Patil <manjunath.b.patil@oracle.com>
> Signed-off-by: Arumugam Kolappan <aru.kolappan@oracle.com>
> ---
>  drivers/infiniband/hw/mlx5/cq.c | 2 +-
>  include/linux/mlx5/cq.h         | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
> index be189e0..890cdc3 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@ -269,7 +269,7 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
>  
>  static void dump_cqe(struct mlx5_ib_dev *dev, struct mlx5_err_cqe *cqe)
>  {
> -	mlx5_ib_warn(dev, "dump error cqe\n");
> +	mlx5_ib_dbg(dev, "dump error cqe\n");

This path should be handled in switch<->case of mlx5_handle_error_cqe()
by skipping dump_cqe for MLX5_CQE_SYNDROME_REMOTE_ACCESS_ERR.

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index be189e0525de..2d75c3071a1e 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -306,6 +306,7 @@ static void mlx5_handle_error_cqe(struct mlx5_ib_dev *dev,
                wc->status = IB_WC_REM_INV_REQ_ERR;
                break;
        case MLX5_CQE_SYNDROME_REMOTE_ACCESS_ERR:
+               dump = 0;
                wc->status = IB_WC_REM_ACCESS_ERR;
                break;
        case MLX5_CQE_SYNDROME_REMOTE_OP_ERR:

Thanks
