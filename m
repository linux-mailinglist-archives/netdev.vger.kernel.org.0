Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29EC0663B5D
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 09:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbjAJIjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 03:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237924AbjAJIjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 03:39:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B79120AE;
        Tue, 10 Jan 2023 00:38:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C1D061536;
        Tue, 10 Jan 2023 08:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68635C433F1;
        Tue, 10 Jan 2023 08:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673339932;
        bh=VGGN88dzsKmyouw7pGm8JHmTwQ08CwrwJb0SehOTI8c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LjI2HPvjVlu/TTakbIZuXpVInAyCsMs31c57d0ZXqYBg+mrsB0+/DMqhd8v/aZXmK
         Al56mPGEL4URacmnNu5IasugEoeikMhrW6gX+jcR4xd+91fXC/ry433jqLAHlirCdj
         4JwZpQMRdwXWOpGlV3t3OIdvDfBJesTX8wVmsIh7u58bMYsDo982xizrM6UaRgFCZU
         VMN8WWp1ovx9R4oY5s5a27zLtwqq+pkXNWEdKrBaX/k4IMhpV1D2gYpvmYdECVDy9I
         uzvIAQChAkoWnaMvToGjTM/GyktrwsGCHcPVWfql4aQKhhq+8WF9cPNRzIPJhtiuSp
         jhsvPcRq/g7DA==
Date:   Tue, 10 Jan 2023 10:38:47 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ajit Khaparde <ajit.khaparde@broadcom.com>
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        pabeni@redhat.com, selvin.xavier@broadcom.com
Subject: Re: [PATCH 0/8] Add Auxiliary driver support
Message-ID: <Y70kF3cpyogrxUUC@unreal>
References: <20230108030208.26390-1-ajit.khaparde@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230108030208.26390-1-ajit.khaparde@broadcom.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 07, 2023 at 07:02:00PM -0800, Ajit Khaparde wrote:
> 
> Ajit Khaparde <ajit.khaparde@broadcom.com>
> Dec 7, 2022, 9:53 AM
> to me, andrew.gospodarek, davem, edumazet, jgg, kuba, leon, linux-kernel, linux-rdma, michael.chan, netdev, pabeni, selvin.xavier
> 
> Add auxiliary device driver for Broadcom devices.
> The bnxt_en driver will register and initialize an aux device
> if RDMA is enabled in the underlying device.
> The bnxt_re driver will then probe and initialize the
> RoCE interfaces with the infiniband stack.
> 
> We got rid of the bnxt_en_ops which the bnxt_re driver used to
> communicate with bnxt_en.
> Similarly  We have tried to clean up most of the bnxt_ulp_ops.
> In most of the cases we used the functions and entry points provided
> by the auxiliary bus driver framework.
> And now these are the minimal functions needed to support the functionality.
> 
> We will try to work on getting rid of the remaining if we find any
> other viable option in future.
> 
> v1->v2:
> - Incorporated review comments including usage of ulp_id &
>   complex function indirections.
> - Used function calls provided by the auxiliary bus interface
>   instead of proprietary calls.
> - Refactor code to remove ROCE driver's access to bnxt structure.
> 
> v2->v3:
> - Addressed review comments including cleanup of some unnecessary wrappers
> - Fixed warnings seen during cross compilation
> 
> v3->v4:
> - Cleaned up bnxt_ulp.c and bnxt_ulp.h further
> - Removed some more dead code
> - Sending the patchset as a standalone series
> 
> v4->v5:
> - Removed the SRIOV config callback which bnxt_en driver was calling into
>   bnxt_re driver.
> - Removed excessive checks for rdev and other pointers.
> 
> v5->v6:
> - Removed excessive checks for dev and other pointers
> - Remove runtime interrupt vector allocation. bnxt_en preallocates
> interrupt vectors for bnxt_re to use.
> 
> Please apply. Thanks.
> 
> Ajit Khaparde (7):
>   bnxt_en: Add auxiliary driver support
>   RDMA/bnxt_re: Use auxiliary driver interface
>   bnxt_en: Remove usage of ulp_id
>   bnxt_en: Use direct API instead of indirection
>   bnxt_en: Use auxiliary bus calls over proprietary calls
>   RDMA/bnxt_re: Remove the sriov config callback
>   bnxt_en: Remove runtime interrupt vector allocation
> 
> Hongguang Gao (1):
>   bnxt_en: Remove struct bnxt access from RoCE driver
> 

Thanks a lot for pursuing it,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
