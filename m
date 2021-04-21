Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C833664FC
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 07:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbhDUFpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 01:45:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:32988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235285AbhDUFpb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 01:45:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A93BB613D5;
        Wed, 21 Apr 2021 05:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618983899;
        bh=dlAmaFwGXMGX/CsxGiaIBkgS5U3GzjbRIhSvCIf+2ks=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ecqRaoeQ173NsGY7GHNUfgS8Seo5DG/fx8W9zDwkr3ygXdItEDGL62XxrcMK+ulQU
         i+DLNCbVFiu4VP8Ml5lR/oTYVwFujCNdbPK6OJFJ8feTvkYX0GYrsqjTwutl899VED
         Uo44++H3kdtcBJvQ2+/yuQ4HV1oHfwyUQedGYVpC55ePu09kqONzivDZheom4QAoVj
         7AzFD5ARgFKQar9wueIYuyVec0qTHvgbOAVaAQrBuFF/TLuhAdcn6IhtrK2AKYv2/d
         5PAzRSwKPT3tmEPfVA5+wDGonnA2oRUe4f3MTsjtjrV9JLp1hSWbbXS6VmHfBopXUA
         iiT9bhUKB0pSA==
Date:   Wed, 21 Apr 2021 08:44:55 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     M Chetan Kumar <m.chetan.kumar@intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
Subject: Re: [PATCH V2 01/16] net: iosm: entry point
Message-ID: <YH+71wFykp/fWcCe@unreal>
References: <20210420161310.16189-1-m.chetan.kumar@intel.com>
 <20210420161310.16189-2-m.chetan.kumar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420161310.16189-2-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 09:42:55PM +0530, M Chetan Kumar wrote:
> 1) Register IOSM driver with kernel to manage Intel WWAN PCIe
>    device(PCI_VENDOR_ID_INTEL, INTEL_CP_DEVICE_7560_ID).
> 2) Exposes the EP PCIe device capability to Host PCIe core.
> 3) Initializes PCIe EP configuration and defines PCIe driver probe, remove
>    and power management OPS.
> 4) Allocate and map(dma) skb memory for data communication from device to
>    kernel and vice versa.
> 
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
> ---
> v2:
> * Implement module_init() & exit() callbacks for rtnl_link.
> * Documentation correction for function signature.
> * Fix coverity warnings.
> ---
>  drivers/net/wwan/iosm/iosm_ipc_pcie.c | 588 ++++++++++++++++++++++++++
>  drivers/net/wwan/iosm/iosm_ipc_pcie.h | 211 +++++++++
>  2 files changed, 799 insertions(+)
>  create mode 100644 drivers/net/wwan/iosm/iosm_ipc_pcie.c
>  create mode 100644 drivers/net/wwan/iosm/iosm_ipc_pcie.h
> 
> diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
> new file mode 100644
> index 000000000000..8a3a8cd68a6a
> --- /dev/null
> +++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
> @@ -0,0 +1,588 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2020-21 Intel Corporation.
> + */
> +
> +#include <linux/acpi.h>
> +#include <linux/bitfield.h>
> +#include <linux/module.h>
> +#include <net/rtnetlink.h>
> +
> +#include "iosm_ipc_imem.h"
> +#include "iosm_ipc_pcie.h"
> +#include "iosm_ipc_protocol.h"
> +
> +#define DRV_AUTHOR "Intel Corporation <linuxwwan@intel.com>"

Driver author can't be a company. It needs to be a person.

Thanks
