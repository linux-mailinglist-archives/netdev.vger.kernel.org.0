Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661B91F55E9
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 15:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbgFJNh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 09:37:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgFJNhY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 09:37:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D86220734;
        Wed, 10 Jun 2020 13:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591796243;
        bh=jbIPp1Pne8Ob1fTrPxO8JwFaFso7sR0zCSjskdAxvy4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HshxML1+NocZk/9I75W19Xl8pqem/Wo5dfOhNpsRDO5FKL7OfYGm2F4N5KvH+RlXq
         3GAQeWNF1bF890MN/n4u3pLHCXXoGCnUurhyjiglgHm8hXkOdMlGczmgox4PCj/4zF
         1EDguLu5iGVGAAKEgtPmQr84smXQD39tNFIXf59A=
Date:   Wed, 10 Jun 2020 15:37:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Joe Perches <joe@perches.com>,
        Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH v3 6/7] venus: Make debug infrastructure more flexible
Message-ID: <20200610133717.GB1906670@kroah.com>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
 <20200609104604.1594-7-stanimir.varbanov@linaro.org>
 <20200609111414.GC780233@kroah.com>
 <dc85bf9e-e3a6-15a1-afaa-0add3e878573@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc85bf9e-e3a6-15a1-afaa-0add3e878573@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 04:29:27PM +0300, Stanimir Varbanov wrote:
> 
> 
> On 6/9/20 2:14 PM, Greg Kroah-Hartman wrote:
> > On Tue, Jun 09, 2020 at 01:46:03PM +0300, Stanimir Varbanov wrote:
> >> Here we introduce few debug macros with levels (low, medium and
> >> high) and debug macro for firmware. Enabling the particular level
> >> will be done by dynamic debug with levels.
> >>
> >> For example to enable debug messages with low level:
> >> echo 'module venus_dec level 0x01 +p' > debugfs/dynamic_debug/control
> >>
> >> If you want to enable all levels:
> >> echo 'module venus_dec level 0x07 +p' > debugfs/dynamic_debug/control
> >>
> >> All the features which dynamic debugging provide are preserved.
> >>
> >> And finaly all dev_dbg are translated to VDBGX with appropriate
> >> debug levels.
> >>
> >> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> >> ---
> >>  drivers/media/platform/qcom/venus/core.h      |  5 ++
> >>  drivers/media/platform/qcom/venus/helpers.c   |  2 +-
> >>  drivers/media/platform/qcom/venus/hfi_msgs.c  | 30 ++++-----
> >>  drivers/media/platform/qcom/venus/hfi_venus.c | 20 ++++--
> >>  .../media/platform/qcom/venus/pm_helpers.c    |  3 +-
> >>  drivers/media/platform/qcom/venus/vdec.c      | 63 +++++++++++++++++--
> >>  drivers/media/platform/qcom/venus/venc.c      |  4 ++
> >>  7 files changed, 96 insertions(+), 31 deletions(-)
> >>
> >> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
> >> index b48782f9aa95..63eabf5ff96d 100644
> >> --- a/drivers/media/platform/qcom/venus/core.h
> >> +++ b/drivers/media/platform/qcom/venus/core.h
> >> @@ -15,6 +15,11 @@
> >>  #include "dbgfs.h"
> >>  #include "hfi.h"
> >>  
> >> +#define VDBGL(fmt, args...)	pr_debug_level(0x01, fmt, ##args)
> >> +#define VDBGM(fmt, args...)	pr_debug_level(0x02, fmt, ##args)
> >> +#define VDBGH(fmt, args...)	pr_debug_level(0x04, fmt, ##args)
> >> +#define VDBGFW(fmt, args...)	pr_debug_level(0x08, fmt, ##args)
> >> +
> >>  #define VIDC_CLKS_NUM_MAX		4
> >>  #define VIDC_VCODEC_CLKS_NUM_MAX	2
> >>  #define VIDC_PMDOMAINS_NUM_MAX		3
> >> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
> >> index 0143af7822b2..115a9a2af1d6 100644
> >> --- a/drivers/media/platform/qcom/venus/helpers.c
> >> +++ b/drivers/media/platform/qcom/venus/helpers.c
> >> @@ -396,7 +396,7 @@ put_ts_metadata(struct venus_inst *inst, struct vb2_v4l2_buffer *vbuf)
> >>  	}
> >>  
> >>  	if (slot == -1) {
> >> -		dev_dbg(inst->core->dev, "%s: no free slot\n", __func__);
> >> +		VDBGH("no free slot for timestamp\n");
> > 
> > So you just lost the information that dev_dbg() gave you with regards to
> > the device/driver/instance creating that message?
> 
> No, I don't lose anything.  When I do debug I know that all debug
> messages comes from my driver.  dev_dbg will give me few device
> identifiers which I don't care so much.

No, you need/want that, trust me.

> IMO, the device information makes more sense to dev_err/warn/err
> variants.  On the other side we will have dev_dbg_level(group) if
> still someone needs the device information.

You really want those "gerneric identifiers" as tools today are built to
properly parse and handle them to be able to match and filter on what
device/driver is causing what issue.

Please do not try to create driver-specific prefixes instead, use the
standard the rest of the kernel uses, your driver is not "special" in
this case at all.

> > Ick, no, don't do that.
> > 
> > And why is this driver somehow "special" compared to all the rest of
> 
> Of course it is special ... to me ;-)

Yes, "special and unique" like all other drivers in the kernel :)

Please work with the infrastructure we have, we have spent a lot of time
and effort to make it uniform to make it easier for users and
developers.  Don't regress and try to make driver-specific ways of doing
things, that way lies madness...

thanks,

greg k-h
