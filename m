Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876651F394C
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 13:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbgFILOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 07:14:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727002AbgFILOR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 07:14:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B36F0207ED;
        Tue,  9 Jun 2020 11:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591701256;
        bh=KjT82kHj2v1VQexUfCPUAu1DnRSFG1hgOgh4ntVrp84=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xeDSLknwuygyetEa2eWYHaDw4kFz8UQNQwBLTotMXaKexGC0/VHdJICdDooYk/fFP
         LutM8aohZ1VpOKvKzGzhHKYu2O76ZUknzWmaKW9LYhikq3A9KdQD/Ggf9b1hwJoEN6
         Wuj+np02lhoSKddpZOnRqAb/j9wYGY7iGoLOaFMM=
Date:   Tue, 9 Jun 2020 13:14:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Joe Perches <joe@perches.com>,
        Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH v3 6/7] venus: Make debug infrastructure more flexible
Message-ID: <20200609111414.GC780233@kroah.com>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
 <20200609104604.1594-7-stanimir.varbanov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609104604.1594-7-stanimir.varbanov@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 01:46:03PM +0300, Stanimir Varbanov wrote:
> Here we introduce few debug macros with levels (low, medium and
> high) and debug macro for firmware. Enabling the particular level
> will be done by dynamic debug with levels.
> 
> For example to enable debug messages with low level:
> echo 'module venus_dec level 0x01 +p' > debugfs/dynamic_debug/control
> 
> If you want to enable all levels:
> echo 'module venus_dec level 0x07 +p' > debugfs/dynamic_debug/control
> 
> All the features which dynamic debugging provide are preserved.
> 
> And finaly all dev_dbg are translated to VDBGX with appropriate
> debug levels.
> 
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/core.h      |  5 ++
>  drivers/media/platform/qcom/venus/helpers.c   |  2 +-
>  drivers/media/platform/qcom/venus/hfi_msgs.c  | 30 ++++-----
>  drivers/media/platform/qcom/venus/hfi_venus.c | 20 ++++--
>  .../media/platform/qcom/venus/pm_helpers.c    |  3 +-
>  drivers/media/platform/qcom/venus/vdec.c      | 63 +++++++++++++++++--
>  drivers/media/platform/qcom/venus/venc.c      |  4 ++
>  7 files changed, 96 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
> index b48782f9aa95..63eabf5ff96d 100644
> --- a/drivers/media/platform/qcom/venus/core.h
> +++ b/drivers/media/platform/qcom/venus/core.h
> @@ -15,6 +15,11 @@
>  #include "dbgfs.h"
>  #include "hfi.h"
>  
> +#define VDBGL(fmt, args...)	pr_debug_level(0x01, fmt, ##args)
> +#define VDBGM(fmt, args...)	pr_debug_level(0x02, fmt, ##args)
> +#define VDBGH(fmt, args...)	pr_debug_level(0x04, fmt, ##args)
> +#define VDBGFW(fmt, args...)	pr_debug_level(0x08, fmt, ##args)
> +
>  #define VIDC_CLKS_NUM_MAX		4
>  #define VIDC_VCODEC_CLKS_NUM_MAX	2
>  #define VIDC_PMDOMAINS_NUM_MAX		3
> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
> index 0143af7822b2..115a9a2af1d6 100644
> --- a/drivers/media/platform/qcom/venus/helpers.c
> +++ b/drivers/media/platform/qcom/venus/helpers.c
> @@ -396,7 +396,7 @@ put_ts_metadata(struct venus_inst *inst, struct vb2_v4l2_buffer *vbuf)
>  	}
>  
>  	if (slot == -1) {
> -		dev_dbg(inst->core->dev, "%s: no free slot\n", __func__);
> +		VDBGH("no free slot for timestamp\n");

So you just lost the information that dev_dbg() gave you with regards to
the device/driver/instance creating that message?

Ick, no, don't do that.

And why is this driver somehow "special" compared to all the rest of
the kernel?  Why is the current dev_dbg() control not sufficient that
you need to change the core for just this tiny thing?

thanks,

greg k-h
