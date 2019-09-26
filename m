Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 827B4BF7A9
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 19:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbfIZRhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 13:37:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbfIZRhP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 13:37:15 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59726222C3;
        Thu, 26 Sep 2019 17:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569519435;
        bh=2g8kxVkBcNkmDUzAmuejPcqunIh64sjttqjRFYEBJ2Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hz0sTFSlRZD3XXm28FS4YT45wLRcSVr6nMtZZdWkB5xDDOo9NDLfOiWax3l3HxkGr
         D4OovYKTNok/dsykHphLjfBFU7172euNhHvalZGFgn7J1qr0hSP7z/U8lKq7e0MgJy
         P5zuJvpCOAcS1U+l4N0oDJwy9NdwDtN5bp15EspQ=
Date:   Thu, 26 Sep 2019 20:37:10 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     dledford@redhat.com, jgg@mellanox.com, gregkh@linuxfoundation.org,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [RFC 12/20] RDMA/irdma: Implement device supported verb APIs
Message-ID: <20190926173710.GC14368@unreal>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-13-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926164519.10471-13-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 09:45:11AM -0700, Jeff Kirsher wrote:
> From: Mustafa Ismail <mustafa.ismail@intel.com>
>
> Implement device supported verb APIs. The supported APIs
> vary based on the underlying transport the ibdev is
> registered as (i.e. iWARP or RoCEv2).
>
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> ---
>  drivers/infiniband/hw/irdma/verbs.c      | 4346 ++++++++++++++++++++++
>  drivers/infiniband/hw/irdma/verbs.h      |  199 +
>  include/uapi/rdma/rdma_user_ioctl_cmds.h |    1 +
>  3 files changed, 4546 insertions(+)
>  create mode 100644 drivers/infiniband/hw/irdma/verbs.c
>  create mode 100644 drivers/infiniband/hw/irdma/verbs.h
>
> diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
> new file mode 100644
> index 000000000000..025c21c722e2
> --- /dev/null
> +++ b/drivers/infiniband/hw/irdma/verbs.c
> @@ -0,0 +1,4346 @@
> +// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
> +/* Copyright (c) 2019, Intel Corporation. */

<...>

> +
> +	size = sqdepth * sizeof(struct irdma_sq_uk_wr_trk_info) +
> +	       (rqdepth << 3);
> +	iwqp->kqp.wrid_mem = kzalloc(size, GFP_KERNEL);
> +	if (!iwqp->kqp.wrid_mem)
> +		return -ENOMEM;
> +
> +	ukinfo->sq_wrtrk_array = (struct irdma_sq_uk_wr_trk_info *)
> +				 iwqp->kqp.wrid_mem;
> +	if (!ukinfo->sq_wrtrk_array)
> +		return -ENOMEM;

You are leaking resources here, forgot to do proper error unwinding.

Thanks
