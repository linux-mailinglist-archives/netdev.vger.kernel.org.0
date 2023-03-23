Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC5B6C659E
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 11:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbjCWKtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 06:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbjCWKsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 06:48:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67C776B8;
        Thu, 23 Mar 2023 03:47:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75D6CB82072;
        Thu, 23 Mar 2023 10:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4FBC433D2;
        Thu, 23 Mar 2023 10:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679568428;
        bh=rHQ3TAJg8RAt4JjXjcJHVvvGvOrq1SkLAdurwZ69tgQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tZsPYb1ZNCD7NM8HMedI5E2K63lkjqXMFWs7WPPCgsr5LJAy3p1DJ8WZZ/W5ELJCA
         FOUjs/P9lrXKl/boh5wkJ34NHT/SYK8e8pVeE9t7HxsFFBqeQdwjthSiQWyALcEkHZ
         gZya+A+VZmdPEGgImmzlFxgjGqKZeJNdYWR5VeeUrPfTYAypzW6bV5SaQFhOsn79WW
         V3BwGoEmFQkTd1g8HsXdWAjF5FbNPbpdyCh+nKMoVVbVRfO3zkWfVwRNaQ7PxJLqFx
         vD4a7U0wieSXEfYhGLkUQrNLgxRdc+JRV1X5yDmJoiBSkIwKdY/ws5X+uIAA+vW3by
         ZmCSRyYwTD5EA==
Date:   Thu, 23 Mar 2023 12:47:03 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        aayarekar@marvell.com, sedara@marvell.com, sburla@marvell.com,
        linux-doc@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v4 8/8] octeon_ep: add heartbeat monitor
Message-ID: <20230323104703.GD36557@unreal>
References: <20230322091958.13103-1-vburru@marvell.com>
 <20230322091958.13103-9-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322091958.13103-9-vburru@marvell.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 02:19:57AM -0700, Veerasenareddy Burru wrote:
> Monitor periodic heartbeat messages from device firmware.
> Presence of heartbeat indicates the device is active and running.
> If the heartbeat is missed for configured interval indicates
> firmware has crashed and device is unusable; in this case, PF driver
> stops and uninitialize the device.
> 
> Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
> ---
> v3 -> v4:
>  * 0007-xxx.patch in v3 is 0008-xxx.patch in v4.
> 
> v2 -> v3:
>  * 0009-xxx.patch in v2 is now 0007-xxx.patch in v3 due to
>    0007 and 0008.patch from v2 are removed in v3.
> 
> v1 -> v2:
>  * no change
> 
>  .../marvell/octeon_ep/octep_cn9k_pf.c         |  9 ++++
>  .../ethernet/marvell/octeon_ep/octep_config.h |  6 +++
>  .../ethernet/marvell/octeon_ep/octep_main.c   | 45 ++++++++++++++++++-
>  .../ethernet/marvell/octeon_ep/octep_main.h   |  7 +++
>  .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |  2 +
>  5 files changed, 67 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> index e2503c9bc8a1..90c3a419932d 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> @@ -16,6 +16,9 @@
>  #define CTRL_MBOX_MAX_PF	128
>  #define CTRL_MBOX_SZ		((size_t)(0x400000 / CTRL_MBOX_MAX_PF))
>  
> +#define FW_HB_INTERVAL_IN_SECS		1
> +#define FW_HB_MISS_COUNT		10
> +
>  /* Names of Hardware non-queue generic interrupts */
>  static char *cn93_non_ioq_msix_names[] = {
>  	"epf_ire_rint",
> @@ -249,6 +252,10 @@ static void octep_init_config_cn93_pf(struct octep_device *oct)
>  	conf->ctrl_mbox_cfg.barmem_addr = (void __iomem *)oct->mmio[2].hw_addr +
>  					   (0x400000ull * 7) +
>  					   (link * CTRL_MBOX_SZ);
> +
> +	conf->hb_interval = FW_HB_INTERVAL_IN_SECS;
> +	conf->max_hb_miss_cnt = FW_HB_MISS_COUNT;
> +
>  }
>  
>  /* Setup registers for a hardware Tx Queue  */
> @@ -383,6 +390,8 @@ static bool octep_poll_non_ioq_interrupts_cn93_pf(struct octep_device *oct)
>  		octep_write_csr64(oct, CN93_SDP_EPF_OEI_RINT, reg0);
>  		if (reg0 & CN93_SDP_EPF_OEI_RINT_DATA_BIT_MBOX)
>  			queue_work(octep_wq, &oct->ctrl_mbox_task);
> +		else if (reg0 & CN93_SDP_EPF_OEI_RINT_DATA_BIT_HBEAT)
> +			atomic_set(&oct->hb_miss_cnt, 0);
>  
>  		handled = true;
>  	}
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_config.h b/drivers/net/ethernet/marvell/octeon_ep/octep_config.h
> index f208f3f9a447..df7cd39d9fce 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_config.h
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_config.h
> @@ -200,5 +200,11 @@ struct octep_config {
>  
>  	/* ctrl mbox config */
>  	struct octep_ctrl_mbox_config ctrl_mbox_cfg;
> +
> +	/* Configured maximum heartbeat miss count */
> +	u32 max_hb_miss_cnt;
> +
> +	/* Configured firmware heartbeat interval in secs */
> +	u32 hb_interval;
>  };
>  #endif /* _OCTEP_CONFIG_H_ */
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> index ba0d5fe3081d..415dd06ff344 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> @@ -901,6 +901,38 @@ static void octep_intr_poll_task(struct work_struct *work)
>  			   msecs_to_jiffies(OCTEP_INTR_POLL_TIME_MSECS));
>  }
>  
> +/**
> + * octep_hb_timeout_task - work queue task to check firmware heartbeat.
> + *
> + * @work: pointer to hb work_struct
> + *
> + * Check for heartbeat miss count. Uninitialize oct device if miss count
> + * exceeds configured max heartbeat miss count.
> + *
> + **/
> +static void octep_hb_timeout_task(struct work_struct *work)
> +{
> +	struct octep_device *oct = container_of(work, struct octep_device,
> +						hb_task.work);
> +
> +	int miss_cnt;
> +
> +	atomic_inc(&oct->hb_miss_cnt);
> +	miss_cnt = atomic_read(&oct->hb_miss_cnt);

miss_cnt = atomic_inc_return(&oct->hb_miss_cnt);

> +	if (miss_cnt < oct->conf->max_hb_miss_cnt) {

How is this heartbeat working? You increment on every entry to octep_hb_timeout_task(),
After max_hb_miss_cnt invocations, you will stop your device.

Thanks

> +		queue_delayed_work(octep_wq, &oct->hb_task,
> +				   msecs_to_jiffies(oct->conf->hb_interval * 1000));
> +		return;
> +	}
> +
> +	dev_err(&oct->pdev->dev, "Missed %u heartbeats. Uninitializing\n",
> +		miss_cnt);
> +	rtnl_lock();
> +	if (netif_running(oct->netdev))
> +		octep_stop(oct->netdev);
> +	rtnl_unlock();
> +}
> +
>  /**
>   * octep_ctrl_mbox_task - work queue task to handle ctrl mbox messages.
>   *
> @@ -938,7 +970,7 @@ static const char *octep_devid_to_str(struct octep_device *oct)
>  int octep_device_setup(struct octep_device *oct)
>  {
>  	struct pci_dev *pdev = oct->pdev;
> -	int i;
> +	int i, ret;
>  
>  	/* allocate memory for oct->conf */
>  	oct->conf = kzalloc(sizeof(*oct->conf), GFP_KERNEL);
> @@ -973,7 +1005,15 @@ int octep_device_setup(struct octep_device *oct)
>  
>  	oct->pkind = CFG_GET_IQ_PKIND(oct->conf);
>  
> -	return octep_ctrl_net_init(oct);
> +	ret = octep_ctrl_net_init(oct);
> +	if (ret)
> +		return ret;
> +
> +	atomic_set(&oct->hb_miss_cnt, 0);
> +	INIT_DELAYED_WORK(&oct->hb_task, octep_hb_timeout_task);
> +	queue_delayed_work(octep_wq, &oct->hb_task,
> +			   msecs_to_jiffies(oct->conf->hb_interval * 1000));
> +	return 0;
>  
>  unsupported_dev:
>  	for (i = 0; i < OCTEP_MMIO_REGIONS; i++)
> @@ -1002,6 +1042,7 @@ static void octep_device_cleanup(struct octep_device *oct)
>  	}
>  
>  	octep_ctrl_net_uninit(oct);
> +	cancel_delayed_work_sync(&oct->hb_task);
>  
>  	oct->hw_ops.soft_reset(oct);
>  	for (i = 0; i < OCTEP_MMIO_REGIONS; i++) {
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
> index 836d990ba3fa..e0907a719133 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
> @@ -280,6 +280,13 @@ struct octep_device {
>  	bool poll_non_ioq_intr;
>  	/* Work entry to poll non-ioq interrupts */
>  	struct delayed_work intr_poll_task;
> +
> +	/* Firmware heartbeat timer */
> +	struct timer_list hb_timer;
> +	/* Firmware heartbeat miss count tracked by timer */
> +	atomic_t hb_miss_cnt;
> +	/* Task to reset device on heartbeat miss */
> +	struct delayed_work hb_task;
>  };
>  
>  static inline u16 OCTEP_MAJOR_REV(struct octep_device *oct)
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h b/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
> index 0466fd9a002d..b25c3093dc7b 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
> @@ -367,5 +367,7 @@
>  
>  /* bit 0 for control mbox interrupt */
>  #define CN93_SDP_EPF_OEI_RINT_DATA_BIT_MBOX	BIT_ULL(0)
> +/* bit 1 for firmware heartbeat interrupt */
> +#define CN93_SDP_EPF_OEI_RINT_DATA_BIT_HBEAT	BIT_ULL(1)
>  
>  #endif /* _OCTEP_REGS_CN9K_PF_H_ */
> -- 
> 2.36.0
> 
