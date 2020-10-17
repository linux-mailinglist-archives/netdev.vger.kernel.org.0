Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280522910C9
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 10:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437734AbgJQIsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 04:48:11 -0400
Received: from z5.mailgun.us ([104.130.96.5]:39831 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437730AbgJQIsK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 04:48:10 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1602924489; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=QwjYGlqYo24gqdDkAcddWX8Qdr+goF/apA1d3PH9D6E=; b=AmHZCN2vFNByUExAE0dQK2+jwad7I8y7GlOXXHR3UVRjFjXOx6xZPg0bZbCpv4g+2VImCTEw
 hbnZjZ7+Fs4GJyfwSKm8661lOK8p7lhjzx9emXigE1je6n+WPkd13otQ66qIHRy0LtOgE6MC
 WPY5p62eZ4phIBcdchW5Q/ekxsw=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5f8a404f4f8cc67c3150a1fd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 17 Oct 2020 00:52:31
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6FF08C43382; Sat, 17 Oct 2020 00:52:30 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.2 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from [10.46.162.249] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AAF07C433F1;
        Sat, 17 Oct 2020 00:52:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AAF07C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
Subject: Re: [PATCH v6 2/3] net: Add mhi-net driver
To:     Loic Poulain <loic.poulain@linaro.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        eric.dumazet@gmail.com
References: <1602840007-27140-1-git-send-email-loic.poulain@linaro.org>
 <1602840007-27140-2-git-send-email-loic.poulain@linaro.org>
From:   Hemant Kumar <hemantk@codeaurora.org>
Message-ID: <ec86ae1d-5e64-85d3-090f-5f74649561f3@codeaurora.org>
Date:   Fri, 16 Oct 2020 17:52:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1602840007-27140-2-git-send-email-loic.poulain@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Loic,

On 10/16/20 2:20 AM, Loic Poulain wrote:
> This patch adds a new network driver implementing MHI transport for
> network packets. Packets can be in any format, though QMAP (rmnet)
> is the usual protocol (flow control + PDN mux).
> 
> It support two MHI devices, IP_HW0 which is, the path to the IPA
> (IP accelerator) on qcom modem, And IP_SW0 which is the software
> driven IP path (to modem CPU).
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
> 
>    v2: - rebase on net-next
>        - remove useless skb_linearize
>        - check error type on mhi_queue return
>        - rate limited errors
>        - Schedule RX refill only on 'low' buf level
>        - SET_NETDEV_DEV in probe
>        - reorder device remove sequence
>    v3: - Stop channels on net_register error
>        - Remove useles parentheses
>        - Add driver .owner
>    v4: - prevent potential cpu hog in rx-refill loop
>        - Access mtu via READ_ONCE
>    v5: - Fix access to u64 stats
>    v6: - Stop TX queue earlier if queue is full
>        - Preventing 'abnormal' NETDEV_TX_BUSY path
> 
>   drivers/net/Kconfig   |   7 ++
>   drivers/net/Makefile  |   1 +
>   drivers/net/mhi_net.c | 312 ++++++++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 320 insertions(+)
>   create mode 100644 drivers/net/mhi_net.c
> 
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 1368d1d..11a6357 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -426,6 +426,13 @@ config VSOCKMON
>   	  mostly intended for developers or support to debug vsock issues. If
>   	  unsure, say N.
>   
> +config MHI_NET
> +	tristate "MHI network driver"
> +	depends on MHI_BUS
> +	help
> +	  This is the network driver for MHI.  It can be used with
> +	  QCOM based WWAN modems (like SDX55).  Say Y or M.
> +
>   endif # NET_CORE
>   
>   config SUNGEM_PHY
> diff --git a/drivers/net/Makefile b/drivers/net/Makefile
> index 94b6080..8312037 100644
> --- a/drivers/net/Makefile
> +++ b/drivers/net/Makefile
> @@ -34,6 +34,7 @@ obj-$(CONFIG_GTP) += gtp.o
>   obj-$(CONFIG_NLMON) += nlmon.o
>   obj-$(CONFIG_NET_VRF) += vrf.o
>   obj-$(CONFIG_VSOCKMON) += vsockmon.o
> +obj-$(CONFIG_MHI_NET) += mhi_net.o
>   
>   #
>   # Networking Drivers
> diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
> new file mode 100644
> index 0000000..9c93db1
> --- /dev/null
> +++ b/drivers/net/mhi_net.c
> @@ -0,0 +1,312 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/* MHI Network driver - Network over MHI
> + *
> + * Copyright (C) 2020 Linaro Ltd <loic.poulain@linaro.org>
> + */
> +
> +#include <linux/if_arp.h>
> +#include <linux/mhi.h>
> +#include <linux/mod_devicetable.h>
> +#include <linux/module.h>
> +#include <linux/netdevice.h>
> +#include <linux/skbuff.h>
> +#include <linux/u64_stats_sync.h>
> +
> +#define MIN_MTU		ETH_MIN_MTU
> +#define MAX_MTU		0xffff
uci driver patch series would take care of this :)
> +#define DEFAULT_MTU	8192
it would be good to pass this from driver data based on sw/hw channel
> +
> +struct mhi_net_stats {
> +	u64_stats_t rx_packets;
> +	u64_stats_t rx_bytes;
> +	u64_stats_t rx_errors;
> +	u64_stats_t rx_dropped;
> +	u64_stats_t tx_packets;
> +	u64_stats_t tx_bytes;
> +	u64_stats_t tx_errors;
> +	u64_stats_t tx_dropped;
> +	atomic_t rx_queued;
> +	struct u64_stats_sync tx_syncp;
> +	struct u64_stats_sync rx_syncp;
> +};
> +
> +struct mhi_net_dev {
> +	struct mhi_device *mdev;
> +	struct net_device *ndev;
> +	struct delayed_work rx_refill;
> +	struct mhi_net_stats stats;
> +	u32 rx_queue_sz;
> +};
> +
> +static int mhi_ndo_open(struct net_device *ndev)
> +{
> +	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
> +
> +	/* Feed the rx buffer pool */
> +	schedule_delayed_work(&mhi_netdev->rx_refill, 0);
> +
> +	/* Carrier is established via out-of-band channel (e.g. qmi) */
> +	netif_carrier_on(ndev);
> +
> +	netif_start_queue(ndev);
> +
> +	return 0;
> +}
> +
> +static int mhi_ndo_stop(struct net_device *ndev)
> +{
> +	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
> +
> +	netif_stop_queue(ndev);
> +	netif_carrier_off(ndev);
> +	cancel_delayed_work_sync(&mhi_netdev->rx_refill);
> +
> +	return 0;
> +}
> +
> +static int mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
> +{
> +	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
> +	struct mhi_device *mdev = mhi_netdev->mdev;
> +	int err;
> +
> +	/* mhi_queue_skb is not thread-safe, but xmit is serialized by the
> +	 * network core. Once MHI core will be thread save, migrate to
> +	 * NETIF_F_LLTX support.
> +	 */
> +	err = mhi_queue_skb(mdev, DMA_TO_DEVICE, skb, skb->len, MHI_EOT);
> +	if (unlikely(err)) {
> +		net_err_ratelimited("%s: Failed to queue TX buf (%d)\n",
> +				    ndev->name, err);
> +
> +		u64_stats_update_begin(&mhi_netdev->stats.tx_syncp);
> +		u64_stats_inc(&mhi_netdev->stats.tx_dropped);
> +		u64_stats_update_end(&mhi_netdev->stats.tx_syncp);
> +
> +		/* drop the packet */
> +		kfree_skb(skb);
> +	}
> +
> +	if (mhi_queue_is_full(mdev, DMA_TO_DEVICE))
> +		netif_stop_queue(ndev);
is it possible to enable flow control on tx queue if mhi_queue_skb 
returns non zero value and return NETDEV_TX_BUSY instead of dropping 
packet at MHI layer ? If this is possible you dont need to export new 
API as well.
> +
> +	return NETDEV_TX_OK;
> +}
> +
> +static void mhi_ndo_get_stats64(struct net_device *ndev,
> +				struct rtnl_link_stats64 *stats)
> +{
> +	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
> +	unsigned int start;
> +
> +	do {
> +		start = u64_stats_fetch_begin_irq(&mhi_netdev->stats.rx_syncp);
> +		stats->rx_packets = u64_stats_read(&mhi_netdev->stats.rx_packets);
> +		stats->rx_bytes = u64_stats_read(&mhi_netdev->stats.rx_bytes);
> +		stats->rx_errors = u64_stats_read(&mhi_netdev->stats.rx_errors);
> +		stats->rx_dropped = u64_stats_read(&mhi_netdev->stats.rx_dropped);
> +	} while (u64_stats_fetch_retry_irq(&mhi_netdev->stats.rx_syncp, start));
> +
> +	do {
> +		start = u64_stats_fetch_begin_irq(&mhi_netdev->stats.tx_syncp);
> +		stats->tx_packets = u64_stats_read(&mhi_netdev->stats.tx_packets);
> +		stats->tx_bytes = u64_stats_read(&mhi_netdev->stats.tx_bytes);
> +		stats->tx_errors = u64_stats_read(&mhi_netdev->stats.tx_errors);
> +		stats->tx_dropped = u64_stats_read(&mhi_netdev->stats.tx_dropped);
> +	} while (u64_stats_fetch_retry_irq(&mhi_netdev->stats.tx_syncp, start));
> +}
> +
> +static const struct net_device_ops mhi_netdev_ops = {
> +	.ndo_open               = mhi_ndo_open,
> +	.ndo_stop               = mhi_ndo_stop,
> +	.ndo_start_xmit         = mhi_ndo_xmit,
> +	.ndo_get_stats64	= mhi_ndo_get_stats64,
> +};
> +
> +static void mhi_net_setup(struct net_device *ndev)
> +{
> +	ndev->header_ops = NULL;  /* No header */
> +	ndev->type = ARPHRD_NONE; /* QMAP... */
> +	ndev->hard_header_len = 0;
> +	ndev->addr_len = 0;
> +	ndev->flags = IFF_POINTOPOINT | IFF_NOARP;
> +	ndev->netdev_ops = &mhi_netdev_ops;
> +	ndev->mtu = DEFAULT_MTU;
> +	ndev->min_mtu = MIN_MTU;
> +	ndev->max_mtu = MAX_MTU;
> +	ndev->tx_queue_len = 1000;
some of the above parameters can go in to driver data specific to sw and 
hw channels.
> +}
> +
> +static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
> +				struct mhi_result *mhi_res)
> +{
> +	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
> +	struct sk_buff *skb = mhi_res->buf_addr;
> +	int remaining;
> +
> +	remaining = atomic_dec_return(&mhi_netdev->stats.rx_queued);
> +
> +	if (unlikely(mhi_res->transaction_status)) {
> +		u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
> +		u64_stats_inc(&mhi_netdev->stats.rx_errors);
> +		u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
> +
> +		kfree_skb(skb);
> +	} else {
> +		u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
> +		u64_stats_inc(&mhi_netdev->stats.rx_packets);
> +		u64_stats_add(&mhi_netdev->stats.rx_bytes, mhi_res->bytes_xferd);
> +		u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
> +
> +		skb->protocol = htons(ETH_P_MAP);
> +		skb_put(skb, mhi_res->bytes_xferd);
> +		netif_rx(skb);
> +	}
> +
> +	/* Refill if RX buffers queue becomes low */
> +	if (remaining <= mhi_netdev->rx_queue_sz / 2)
> +		schedule_delayed_work(&mhi_netdev->rx_refill, 0);
> +}
> +
> +static void mhi_net_ul_callback(struct mhi_device *mhi_dev,
> +				struct mhi_result *mhi_res)
> +{
> +	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
> +	struct net_device *ndev = mhi_netdev->ndev;
> +	struct sk_buff *skb = mhi_res->buf_addr;
> +
> +	/* Hardware has consumed the buffer, so free the skb (which is not
> +	 * freed by the MHI stack) and perform accounting.
> +	 */
> +	consume_skb(skb);
> +
> +	u64_stats_update_begin(&mhi_netdev->stats.tx_syncp);
> +	if (unlikely(mhi_res->transaction_status)) {
> +		u64_stats_inc(&mhi_netdev->stats.tx_errors);
> +	} else {
> +		u64_stats_inc(&mhi_netdev->stats.tx_packets);
> +		u64_stats_add(&mhi_netdev->stats.tx_bytes, mhi_res->bytes_xferd);
> +	}
> +	u64_stats_update_end(&mhi_netdev->stats.tx_syncp);
> +
> +	if (netif_queue_stopped(ndev))
> +		netif_wake_queue(ndev);
> +}
> +
> +static void mhi_net_rx_refill_work(struct work_struct *work)
> +{
> +	struct mhi_net_dev *mhi_netdev = container_of(work, struct mhi_net_dev,
> +						      rx_refill.work);
> +	struct net_device *ndev = mhi_netdev->ndev;
> +	struct mhi_device *mdev = mhi_netdev->mdev;
> +	int size = READ_ONCE(ndev->mtu);
> +	struct sk_buff *skb;
> +	int err;
> +
> +	do {
> +		skb = netdev_alloc_skb(ndev, size);
> +		if (unlikely(!skb))
> +			break;
> +
> +		err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb, size, MHI_EOT);
> +		if (err) {
> +			if (unlikely(err != -ENOMEM))
> +				net_err_ratelimited("%s: Failed to queue RX buf (%d)\n",
> +						    ndev->name, err);
> +			kfree_skb(skb);
> +			break;
> +		}
> +
> +		atomic_inc(&mhi_netdev->stats.rx_queued);
> +
> +		/* Do not hog the CPU if rx buffers are completed faster than
> +		 * queued (unlikely).
> +		 */
> +		cond_resched();
> +	} while (1);
> +
> +	/* If we're still starved of rx buffers, reschedule latter */
> +	if (unlikely(!atomic_read(&mhi_netdev->stats.rx_queued)))
> +		schedule_delayed_work(&mhi_netdev->rx_refill, HZ / 2);
> +}
> +
> +static int mhi_net_probe(struct mhi_device *mhi_dev,
> +			 const struct mhi_device_id *id)
> +{
> +	const char *netname = (char *)id->driver_data;
> +	struct mhi_net_dev *mhi_netdev;
> +	struct net_device *ndev;
> +	struct device *dev = &mhi_dev->dev;
> +	int err;
> +
> +	ndev = alloc_netdev(sizeof(*mhi_netdev), netname, NET_NAME_PREDICTABLE,
> +			    mhi_net_setup);
> +	if (!ndev)
> +		return -ENOMEM;
> +
> +	mhi_netdev = netdev_priv(ndev);
> +	dev_set_drvdata(dev, mhi_netdev);
> +	mhi_netdev->ndev = ndev;
> +	mhi_netdev->mdev = mhi_dev;
> +	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
> +
> +	/* All MHI net channels have 128 ring elements (at least for now) */
> +	mhi_netdev->rx_queue_sz = 128;
Instead of hard coded value you can use mhi_get_free_desc_count() again 
from uci patch series :)
> +
> +	INIT_DELAYED_WORK(&mhi_netdev->rx_refill, mhi_net_rx_refill_work);
> +	u64_stats_init(&mhi_netdev->stats.rx_syncp);
> +	u64_stats_init(&mhi_netdev->stats.tx_syncp);
> +
> +	/* Start MHI channels */
> +	err = mhi_prepare_for_transfer(mhi_dev);
> +	if (err)
> +		goto out_err;
> +
> +	err = register_netdev(ndev);
> +	if (err) {
> +		mhi_unprepare_from_transfer(mhi_dev);
> +		goto out_err;
> +	}
> +
> +	return 0;
> +
> +out_err:
> +	free_netdev(ndev);
> +	return err;
> +}
> +
> +static void mhi_net_remove(struct mhi_device *mhi_dev)
> +{
> +	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
> +
> +	unregister_netdev(mhi_netdev->ndev);
> +
> +	mhi_unprepare_from_transfer(mhi_netdev->mdev);
> +
> +	free_netdev(mhi_netdev->ndev);
> +}
> +
> +static const struct mhi_device_id mhi_net_id_table[] = {
> +	{ .chan = "IP_HW0", .driver_data = (kernel_ulong_t)"mhi_hwip%d" },
it would be good to use driver data as struct which would pass network 
device name, mru, etc. You can have diff mru between sw and hw channel 
if packet level aggregation is enabled.
> +	{ .chan = "IP_SW0", .driver_data = (kernel_ulong_t)"mhi_swip%d" },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(mhi, mhi_net_id_table);
> +
> +static struct mhi_driver mhi_net_driver = {
> +	.probe = mhi_net_probe,
> +	.remove = mhi_net_remove,
> +	.dl_xfer_cb = mhi_net_dl_callback,
> +	.ul_xfer_cb = mhi_net_ul_callback,
> +	.id_table = mhi_net_id_table,
> +	.driver = {
> +		.name = "mhi_net",
> +		.owner = THIS_MODULE,
> +	},
> +};
> +
> +module_mhi_driver(mhi_net_driver);
> +
> +MODULE_AUTHOR("Loic Poulain <loic.poulain@linaro.org>");
> +MODULE_DESCRIPTION("Network over MHI");
> +MODULE_LICENSE("GPL v2");
> 

Thanks,
Hemant
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
