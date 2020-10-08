Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE1C287AD6
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 19:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731927AbgJHRUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 13:20:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728780AbgJHRUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 13:20:17 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E413204EF;
        Thu,  8 Oct 2020 17:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602177616;
        bh=qqJaQ8w9+/FSFtBNLOGYEQ7wz4IYZfeGaGac4ucM/GA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V7Xmgrp5RI+cknUfCHil8Usd4zBVjfPjV1rt2Tlr4BVtZCM2VuLRGE1I+Xecomqoj
         bP8LYTXylGlFZp2ZdcuKZMVSaA1OMWsS0acb4Jc6VGA93XjPr0U2tOT7g74WmZvB0l
         QfVGV1A1O3YC1l60ZCwG5ka9VFOLPKrwkpT475jg=
Date:   Thu, 8 Oct 2020 20:20:11 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dave Ertman <david.m.ertman@intel.com>
Cc:     alsa-devel@alsa-project.org, tiwai@suse.de, broonie@kernel.org,
        linux-rdma@vger.kernel.org, jgg@nvidia.com, dledford@redhat.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        gregkh@linuxfoundation.org, ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        parav@mellanox.com, shiraz.saleem@intel.com,
        dan.j.williams@intel.com, kiran.patil@intel.com
Subject: Re: [PATCH v2 1/6] Add ancillary bus support
Message-ID: <20201008172011.GO13580@unreal>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005182446.977325-2-david.m.ertman@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 05, 2020 at 11:24:41AM -0700, Dave Ertman wrote:
> Add support for the Ancillary Bus, ancillary_device and ancillary_driver.
> It enables drivers to create an ancillary_device and bind an
> ancillary_driver to it.
>
> The bus supports probe/remove shutdown and suspend/resume callbacks.
> Each ancillary_device has a unique string based id; driver binds to
> an ancillary_device based on this id through the bus.
>
> Co-developed-by: Kiran Patil <kiran.patil@intel.com>
> Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> Co-developed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> Co-developed-by: Fred Oh <fred.oh@linux.intel.com>
> Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
> Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
> Reviewed-by: Parav Pandit <parav@mellanox.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> ---

<...>

> +
> +static const struct ancillary_device_id *ancillary_match_id(const struct ancillary_device_id *id,
> +							    const struct ancillary_device *ancildev)
> +{
> +	while (id->name[0]) {
> +		const char *p = strrchr(dev_name(&ancildev->dev), '.');
> +		int match_size;
> +
> +		if (!p) {
> +			id++;
> +			continue;
> +		}
> +		match_size = p - dev_name(&ancildev->dev);
> +
> +		/* use dev_name(&ancildev->dev) prefix before last '.' char to match to */
> +		if (!strncmp(dev_name(&ancildev->dev), id->name, match_size))

This check is wrong, it causes to wrong matching if strlen(id->name) > match_size
In my case, the trigger was:
[    5.175848] ancillary:ancillary_match_id: dev mlx5_core.ib.0, id mlx5_core.ib_rep

From cf8f10af72f9e0d57c7ec077d59238cc12b0650f Mon Sep 17 00:00:00 2001
From: Leon Romanovsky <leonro@nvidia.com>
Date: Thu, 8 Oct 2020 19:40:03 +0300
Subject: [PATCH] fixup! Fixes to ancillary bus

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/bus/ancillary.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/ancillary.c b/drivers/bus/ancillary.c
index 54858f744ef5..615ce40ef8e4 100644
--- a/drivers/bus/ancillary.c
+++ b/drivers/bus/ancillary.c
@@ -31,8 +31,10 @@ static const struct ancillary_device_id *ancillary_match_id(const struct ancilla
 		match_size = p - dev_name(&ancildev->dev);

 		/* use dev_name(&ancildev->dev) prefix before last '.' char to match to */
-		if (!strncmp(dev_name(&ancildev->dev), id->name, match_size))
+		if (match_size == strlen(id->name) && !strncmp(dev_name(&ancildev->dev), id->name, match_size)) {
 			return id;
+		}
+
 		id++;
 	}
 	return NULL;
--
2.26.2



> +			return id;
> +		id++;
> +	}
> +	return NULL;
> +}
