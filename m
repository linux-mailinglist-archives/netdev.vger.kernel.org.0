Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351EA6C91B9
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 00:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjCYXj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 19:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCYXj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 19:39:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C789AF25
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 16:39:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 694BB60DB5
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 23:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64042C433D2;
        Sat, 25 Mar 2023 23:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679787593;
        bh=Dboylo/78jBTGTrj2SlEO08uVBSCxw2LSC/H90FYjII=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mEC837KA4QjRR8MYWvFnepE71D1moz+0Jn1cqWVRS8wphyo83GFtl+EQRAcUlQH7o
         Mw3TPzAUYifvBiz5nt49j6tzltN3vruJE7C5zMi0K7Kw0XGc+Sl/B3EL2ncMv0lY9X
         1JLTuqrBsBFMAB2h+0vIbYKerFT0YR8sO+xOhBsYxjjVbp5qjIZiBxaVm69Gthd2GX
         UucUyRygB+/uh6AmtDmPhuv07g3bkemWr+1rk7sQiUdK6tIV2TdXfzZuTVjd4JyeUj
         APjKbbxelaDBg3j9aDt8znZBKLJAUHrHX+rVo7DyHtXOE9MH9DfBc0UcoRucftCY/Q
         5FY29knsQMBew==
Date:   Sat, 25 Mar 2023 16:39:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     <brett.creeley@amd.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <drivers@pensando.io>, <leon@kernel.org>,
        <jiri@resnulli.us>
Subject: Re: [PATCH v6 net-next 01/14] pds_core: initial framework for
 pds_core PF driver
Message-ID: <20230325163952.0eb18d3b@kernel.org>
In-Reply-To: <20230324190243.27722-2-shannon.nelson@amd.com>
References: <20230324190243.27722-1-shannon.nelson@amd.com>
        <20230324190243.27722-2-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Mar 2023 12:02:30 -0700 Shannon Nelson wrote:
> This is the initial PCI driver framework for the new pds_core device
> driver and its family of devices.  This does the very basics of
> registering for the new PF PCI device 1dd8:100c, setting up debugfs
> entries, and registering with devlink.

> +	debugfs_create_file("state", 0400, pdsc->dentry,
> +			    pdsc, &core_state_fops);

debugfs_create_ulong() ?

> diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
> new file mode 100644
> index 000000000000..a9021bfe680a
> --- /dev/null
> +++ b/drivers/net/ethernet/amd/pds_core/devlink.c
> @@ -0,0 +1,51 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> +
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <linux/errno.h>
> +#include <linux/pci.h>
> +
> +#include "core.h"
> +
> +static const struct devlink_ops pdsc_dl_ops = {
> +};
> +
> +static const struct devlink_ops pdsc_dl_vf_ops = {
> +};
> +
> +struct pdsc *pdsc_dl_alloc(struct device *dev, bool is_pf)
> +{
> +	const struct devlink_ops *ops;
> +	struct devlink *dl;
> +
> +	ops = is_pf ? &pdsc_dl_ops : &pdsc_dl_vf_ops;
> +	dl = devlink_alloc(ops, sizeof(struct pdsc), dev);
> +	if (!dl)
> +		return NULL;
> +
> +	return devlink_priv(dl);
> +}
> +
> +void pdsc_dl_free(struct pdsc *pdsc)
> +{
> +	struct devlink *dl = priv_to_devlink(pdsc);
> +
> +	devlink_free(dl);
> +}
> +
> +int pdsc_dl_register(struct pdsc *pdsc)
> +{
> +	struct devlink *dl = priv_to_devlink(pdsc);
> +
> +	devlink_register(dl);
> +
> +	return 0;
> +}
> +
> +void pdsc_dl_unregister(struct pdsc *pdsc)
> +{
> +	struct devlink *dl = priv_to_devlink(pdsc);
> +
> +	devlink_unregister(dl);

Don't put core devlink functionality in a separate file.
You're not wrapping all pci_* calls in your own wrappers, why are you
wrapping delvink? And use explicit locking, please. devl_* APIs.
