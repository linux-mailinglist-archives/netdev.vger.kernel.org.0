Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFB21DABEB
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 09:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgETHYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 03:24:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgETHYB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 03:24:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56FFA207D3;
        Wed, 20 May 2020 07:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589959439;
        bh=023MqEfgvspdJhXwN7Da0dbwG+Ey+EkpG6YmIhdB9KU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IrucS0inRhPqSOWtzuS4674WiDzfJO+0Iq6vWMzch084LHkQeOzFrLQEhtTHkswZM
         HFaNvorSGr8EucjZmXAEUsWSHbtcNZ2bgupaVDgGMWA1XU08mMODwPQxZJbxgbyuVb
         EcuegYnPP0Xu15u2it4VeLYv6BaZMYzED3UQ9yNY=
Date:   Wed, 20 May 2020 09:23:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, jgg@ziepe.ca,
        pierre-louis.bossart@linux.intel.com,
        Fred Oh <fred.oh@linux.intel.com>
Subject: Re: [net-next v4 12/12] ASoC: SOF: ops: Add new op for client
 registration
Message-ID: <20200520072357.GD2365898@kroah.com>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
 <20200520070227.3392100-13-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520070227.3392100-13-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 12:02:27AM -0700, Jeff Kirsher wrote:
> From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> 
> Add a new op for registering clients. The clients to be
> registered depend on the DSP capabilities and the ACPI/DT
> information. For now, we only add 2 IPC test clients that
> will be used for run tandem IPC flood tests for all Intel
> platforms.
> 
> For ACPI platforms, change the Kconfig to select
> SND_SOC_SOF_PROBE_WORK_QUEUE to allow the virtbus driver
> to probe when the client is registered.
> 
> Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
> Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>  sound/soc/sof/core.c        |  8 ++++++++
>  sound/soc/sof/intel/Kconfig |  1 +
>  sound/soc/sof/intel/apl.c   | 26 ++++++++++++++++++++++++++
>  sound/soc/sof/intel/bdw.c   | 25 +++++++++++++++++++++++++
>  sound/soc/sof/intel/byt.c   | 28 ++++++++++++++++++++++++++++
>  sound/soc/sof/intel/cnl.c   | 26 ++++++++++++++++++++++++++
>  sound/soc/sof/ops.h         | 34 ++++++++++++++++++++++++++++++++++
>  sound/soc/sof/sof-priv.h    |  3 +++
>  8 files changed, 151 insertions(+)
> 
> diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
> index fdfed157e6c0..a0382612b9e7 100644
> --- a/sound/soc/sof/core.c
> +++ b/sound/soc/sof/core.c
> @@ -245,6 +245,12 @@ static int sof_probe_continue(struct snd_sof_dev *sdev)
>  	if (plat_data->sof_probe_complete)
>  		plat_data->sof_probe_complete(sdev->dev);
>  
> +	/*
> +	 * Register client devices. This can fail but errors cannot be
> +	 * propagated.
> +	 */
> +	snd_sof_register_clients(sdev);
> +
>  	return 0;
>  
>  fw_trace_err:
> @@ -349,6 +355,7 @@ int snd_sof_device_remove(struct device *dev)
>  		cancel_work_sync(&sdev->probe_work);
>  
>  	if (sdev->fw_state > SOF_FW_BOOT_NOT_STARTED) {
> +		snd_sof_unregister_clients(sdev);
>  		snd_sof_fw_unload(sdev);
>  		snd_sof_ipc_free(sdev);
>  		snd_sof_free_debug(sdev);
> @@ -382,4 +389,5 @@ EXPORT_SYMBOL(snd_sof_device_remove);
>  MODULE_AUTHOR("Liam Girdwood");
>  MODULE_DESCRIPTION("Sound Open Firmware (SOF) Core");
>  MODULE_LICENSE("Dual BSD/GPL");
> +MODULE_IMPORT_NS(SND_SOC_SOF_CLIENT);
>  MODULE_ALIAS("platform:sof-audio");
> diff --git a/sound/soc/sof/intel/Kconfig b/sound/soc/sof/intel/Kconfig
> index c9a2bee4b55c..002fd426ee53 100644
> --- a/sound/soc/sof/intel/Kconfig
> +++ b/sound/soc/sof/intel/Kconfig
> @@ -13,6 +13,7 @@ config SND_SOC_SOF_INTEL_ACPI
>  	def_tristate SND_SOC_SOF_ACPI
>  	select SND_SOC_SOF_BAYTRAIL  if SND_SOC_SOF_BAYTRAIL_SUPPORT
>  	select SND_SOC_SOF_BROADWELL if SND_SOC_SOF_BROADWELL_SUPPORT
> +	select SND_SOC_SOF_PROBE_WORK_QUEUE if SND_SOC_SOF_CLIENT
>  	help
>  	  This option is not user-selectable but automagically handled by
>  	  'select' statements at a higher level
> diff --git a/sound/soc/sof/intel/apl.c b/sound/soc/sof/intel/apl.c
> index 02218d22e51f..547b2b0ccb9a 100644
> --- a/sound/soc/sof/intel/apl.c
> +++ b/sound/soc/sof/intel/apl.c
> @@ -15,9 +15,13 @@
>   * Hardware interface for audio DSP on Apollolake and GeminiLake
>   */
>  
> +#include <linux/module.h>
>  #include "../sof-priv.h"
>  #include "hda.h"
>  #include "../sof-audio.h"
> +#if IS_ENABLED(CONFIG_SND_SOC_SOF_CLIENT)
> +#include "../sof-client.h"
> +#endif

The amount of #if additions in this patch is crazy.  That should never
be needed for a .h file like this, nor should it be needed for all of
the other times it is used in this patch.  Please fix up your api to not
need that at all, as it's really messy, don't you think?

thanks,

greg k-h
