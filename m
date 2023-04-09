Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A716DBFC5
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 14:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjDIMD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 08:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDIMD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 08:03:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1477C1FDB
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 05:03:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A275260C1B
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 12:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41437C433EF;
        Sun,  9 Apr 2023 12:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681041805;
        bh=Zrcj233CmgND95/qDwA1cib/PcgB14/WGD1sK0pMVJo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kmKH2q3V3vnGjthrjymHJMGKk+h4MqKprn6VMwvTK1EOtYMCTbzKRRVqel5jqmqJj
         5UXZKFGdOcdEvw0QXAJiR0X5/fk1KC4Dvj8+pCzX2dflWSBh0MOJuRkW84GlOgOi97
         vUnGOVBFtMBJEWf61UCJLCZcpM4cvXlFGSKU7UB/qmJepkELdy+AO2iw1n6zA96gFs
         iDVboFuT2WGYwjGzi/4QY2agDB4FGsLcgRroZLGIwm4BsYukBNGr4rxUIihTjyV/E2
         LSdA1RVBE71aU00wR0MSWyQfJOyz89EruoAbvZ3V+75QgIBOlIBNnYbKZhb4y1mzvY
         dzlsI5J8QsnhQ==
Date:   Sun, 9 Apr 2023 15:03:20 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
Subject: Re: [PATCH v9 net-next 05/14] pds_core: set up device and adminq
Message-ID: <20230409120320.GD182481@unreal>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-6-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406234143.11318-6-shannon.nelson@amd.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 04:41:34PM -0700, Shannon Nelson wrote:
> Set up the basic adminq and notifyq queue structures.  These are
> used mostly by the client drivers for feature configuration.
> These are essentially the same adminq and notifyq as in the
> ionic driver.
> 
> Part of this includes querying for device identity and FW
> information, so we can make that available to devlink dev info.
> 
>   $ devlink dev info pci/0000:b5:00.0
>   pci/0000:b5:00.0:
>     driver pds_core
>     serial_number FLM18420073
>     versions:
>         fixed:
>           asic.id 0x0
>           asic.rev 0x0
>         running:
>           fw 1.51.0-73
>         stored:
>           fw.goldfw 1.15.9-C-22
>           fw.mainfwa 1.60.0-73
>           fw.mainfwb 1.60.0-57
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  .../device_drivers/ethernet/amd/pds_core.rst  |  47 ++
>  drivers/net/ethernet/amd/pds_core/core.c      | 450 ++++++++++++-
>  drivers/net/ethernet/amd/pds_core/core.h      | 154 +++++
>  drivers/net/ethernet/amd/pds_core/debugfs.c   |  76 +++
>  drivers/net/ethernet/amd/pds_core/devlink.c   |  61 ++
>  drivers/net/ethernet/amd/pds_core/main.c      |  17 +-
>  include/linux/pds/pds_adminq.h                | 637 ++++++++++++++++++
>  7 files changed, 1438 insertions(+), 4 deletions(-)
>  create mode 100644 include/linux/pds/pds_adminq.h

<...>

> +void pdsc_stop(struct pdsc *pdsc)
> +{
> +	if (pdsc->wq)
> +		flush_workqueue(pdsc->wq);
> +
> +	pdsc_mask_interrupts(pdsc);
> +}
> +

<...>

>  static const struct devlink_ops pdsc_dl_vf_ops = {
> @@ -332,6 +346,7 @@ static void pdsc_remove(struct pci_dev *pdev)
>  		mutex_lock(&pdsc->config_lock);
>  		set_bit(PDSC_S_STOPPING_DRIVER, &pdsc->state);
>  
> +		pdsc_stop(pdsc);

You are calling to flush this workqueue in a couple of line above.

>  		pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
>  		mutex_unlock(&pdsc->config_lock);
>  		mutex_destroy(&pdsc->config_lock);
> diff --git a/include/linux/pds/pds_adminq.h b/include/linux/pds/pds_adminq.h
> new file mode 100644
> index 000000000000..9cd58b7f5fb2
> --- /dev/null
> +++ b/include/linux/pds/pds_adminq.h
> @@ -0,0 +1,637 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> +

<...>

> +/* The color bit is a 'done' bit for the completion descriptors
> + * where the meaning alternates between '1' and '0' for alternating
> + * passes through the completion descriptor ring.
> + */
> +static inline u8 pdsc_color_match(u8 color, u8 done_color)

static inline bool?

> +{
> +	return (!!(color & PDS_COMP_COLOR_MASK)) == done_color;
> +}
> +#endif /* _PDS_CORE_ADMINQ_H_ */
> -- 
> 2.17.1
> 
