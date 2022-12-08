Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1FD9646CB6
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 11:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiLHK22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 05:28:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiLHK2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 05:28:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90BA1388F;
        Thu,  8 Dec 2022 02:28:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DEE360F35;
        Thu,  8 Dec 2022 10:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C685BC433D6;
        Thu,  8 Dec 2022 10:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670495303;
        bh=kVBPuZl/SCeQHmRkrQsC7oS+MPH0fShGve01Y+Suolw=;
        h=Date:From:To:Cc:Subject:References:From;
        b=F21buIGWYDxMdSJkX7V58LWjtEh8fYiHrAQxJ3pnYxGpAIyaGtE2AmvV2FOPrUAIf
         jufCZfy983CAnVXu26h1hCvdoWHw5JvX35CCx7BbxrP+oWa801sMiffa+3q2E36ZJh
         xrKQAZbzZXxWViV/caDuHOVHZ26ESHHTJvHtUPhyytWxjOvwsqzfLmL8ti/d98F2v0
         VMhcpcO2z98yAqTIR+Ao32oMds81nqOR43HMxd2O20xJ8GL18Fh0KINiPBn5DzhHpt
         6k3GidLJyqO5t95Be/M4Vlt+E3Em8wU16UyNPQ9nA7qNq2O6PZZAb1CX96rdQpJKAK
         Xtm+IyT08mXVA==
Date:   Thu, 8 Dec 2022 12:28:19 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ajit Khaparde <ajit.khaparde@broadcom.com>
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        pabeni@redhat.com, selvin.xavier@broadcom.com
Subject: Re: [PATCH v5 0/7] Add Auxiliary driver support
Message-ID: <Y5G8Qzly9F3fP0Em@unreal>
References: <20221207175310.23656-1-ajit.khaparde@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 09:53:03AM -0800, Ajit Khaparde wrote:
> Add auxiliary device driver for Broadcom devices.
> The bnxt_en driver will register and initialize an aux device
> if RDMA is enabled in the underlying device.
> The bnxt_re driver will then probe and initialize the
> RoCE interfaces with the infiniband stack.
>=20
> We got rid of the bnxt_en_ops which the bnxt_re driver used to
> communicate with bnxt_en.
> Similarly  We have tried to clean up most of the bnxt_ulp_ops.
> In most of the cases we used the functions and entry points provided
> by the auxiliary bus driver framework.
> And now these are the minimal functions needed to support the functionali=
ty.
>=20
> We will try to work on getting rid of the remaining if we find any
> other viable option in future.
>=20
> v1->v2:
> - Incorporated review comments including usage of ulp_id &
>   complex function indirections.
> - Used function calls provided by the auxiliary bus interface
>   instead of proprietary calls.
> - Refactor code to remove ROCE driver's access to bnxt structure.

I still see wrong usage of auxiliary driver model, especially for RDMA
device. That model mimics general driver model, where you should
separate between device creation and configuration.=20

I would expect that your bnxt_en create pre-configured devices with
right amount of MSI-X, limits, capabilities e.t.c and RDMA driver will
simply bind to it. It means that calls like bnxt_re_request_msix()
should go too. All PCI-related logic needs to be in netdev.

In addition, I saw IS_ERR_OR_NULL(..) and "if(dev)" checks in various
uninit functions and it can be one of two: wrong unwind flow or wrong
use of driver model. In right implementation, your driver will be called
only on valid device and uninit won't be called for not-initialized device.

Also I spotted .ulp_async_notifier, which is not used and
bnxt_re_sriov_config() is prune to races due to separation between
driver bind and device creation. You should configure SR-IOV in device
creation stage.

Thanks

>=20
> v2->v3:
> - Addressed review comments including cleanup of some unnecessary wrappers
> - Fixed warnings seen during cross compilation
>=20
> v3->v4:
> - Cleaned up bnxt_ulp.c and bnxt_ulp.h further
> - Removed some more dead code
> - Sending the patchset as a standalone series
>=20
> v4->v5:
> - Removed the SRIOV config callback which bnxt_en driver was calling into
>   bnxt_re driver.
> - Removed excessive checks for rdev and other pointers.
>=20
> Please apply. Thanks.
>=20
> Ajit Khaparde (6):
>   bnxt_en: Add auxiliary driver support
>   RDMA/bnxt_re: Use auxiliary driver interface
>   bnxt_en: Remove usage of ulp_id
>   bnxt_en: Use direct API instead of indirection
>   bnxt_en: Use auxiliary bus calls over proprietary calls
>   RDMA/bnxt_re: Remove the sriov config callback
>=20
> Hongguang Gao (1):
>   bnxt_en: Remove struct bnxt access from RoCE driver
>=20
>  drivers/infiniband/hw/bnxt_re/bnxt_re.h       |   9 +-
>  drivers/infiniband/hw/bnxt_re/main.c          | 591 +++++++-----------
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  10 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   8 +
>  .../net/ethernet/broadcom/bnxt/bnxt_sriov.c   |   7 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 413 ++++++------
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |  53 +-
>  7 files changed, 490 insertions(+), 601 deletions(-)
>=20
> --=20
> 2.37.1 (Apple Git-137.1)
>=20
