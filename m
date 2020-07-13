Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E1521E324
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 00:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgGMWmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 18:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgGMWmK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 18:42:10 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D762620DD4;
        Mon, 13 Jul 2020 22:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594680130;
        bh=JbDCK7D2/GsBT9H83GAKXMujtpxLqJNPChMfE6ajF7E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XMsXBO305T47S20vtjueEv7N4nprQ2ZKXM8/nOJvrIT+gpOjlqxlvae0J9pUxEKvv
         PGS8DhPhv8PsDLX5bh3RpqUYAhlnAllGzBBXrlpcg0D/fvFsoq45doNQUtKH5J1q3b
         mw+vL8vouJTWcgPaIQpTpSEptjJWDbbjdNgavvtA=
Date:   Mon, 13 Jul 2020 15:42:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
Subject: Re: [PATCH net-next v1] hinic: add firmware update support
Message-ID: <20200713154208.7d123d5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200713140522.14600-1-luobin9@huawei.com>
References: <20200713140522.14600-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 22:05:22 +0800 Luo bin wrote:
> add support to update firmware by the devlink flashing API
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>
> ---
> V0~V1: remove the implementation from ethtool to devlink

Thanks!

> +static int check_image_device_type(struct hinic_dev *nic_dev,
> +				   u32 image_device_type)
> +{
> +	struct hinic_comm_board_info board_info = {0};
> +
> +	if (image_device_type) {
> +		if (!hinic_get_board_info(nic_dev->hwdev, &board_info)) {
> +			if (image_device_type == board_info.info.board_type)
> +				return true;

Please simplify this, you shouldn't need more than 1 indentation level
here.

> +			dev_err(&nic_dev->hwdev->hwif->pdev->dev, "The device type of upgrade file doesn't match the device type of current firmware, please check the upgrade file\n");
> +			dev_err(&nic_dev->hwdev->hwif->pdev->dev, "The image device type: 0x%x, firmware device type: 0x%x\n",
> +				image_device_type, board_info.info.board_type);
> +
> +			return false;
> +		}
> +	}
> +
> +	return false;
> +}
> +
> +static int hinic_flash_fw(struct hinic_dev *nic_dev, const u8 *data,
> +			  struct host_image_st *host_image, u32 boot_flag)

You seem to always pass boot_flag = 0, AFAICT, please remove the
parameter and related code.

> +{
> +	u32 section_remain_send_len, send_fragment_len, send_pos, up_total_len;
> +	struct hinic_cmd_update_fw *fw_update_msg = NULL;
> +	u32 section_type, section_crc, section_version;
> +	u32 i, len, section_len, section_offset;
> +	u16 out_size = sizeof(*fw_update_msg);
> +	int total_len_flag = 0;
> +	int err;

> +int hinic_devlink_register(struct devlink *devlink, struct device *dev)
> +{
> +	int err;
> +
> +	err = devlink_register(devlink, dev);
> +
> +	return err;

No need for temporary variable.

> +}
> +
> +void hinic_devlink_unregister(struct devlink *devlink)
> +{
> +	devlink_unregister(devlink);
> +}

> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
> index 834a20a0043c..1dfa09411590 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
> @@ -18,6 +18,7 @@
>  #include <linux/semaphore.h>
>  #include <linux/workqueue.h>
>  #include <net/ip.h>
> +#include <net/devlink.h>
>  #include <linux/bitops.h>
>  #include <linux/bitmap.h>
>  #include <linux/delay.h>
> @@ -25,6 +26,7 @@
>  
>  #include "hinic_hw_qp.h"
>  #include "hinic_hw_dev.h"
> +#include "hinic_devlink.h"
>  #include "hinic_port.h"
>  #include "hinic_tx.h"
>  #include "hinic_rx.h"
> @@ -1075,9 +1077,11 @@ static int nic_dev_init(struct pci_dev *pdev)
>  	struct hinic_rx_mode_work *rx_mode_work;
>  	struct hinic_txq_stats *tx_stats;
>  	struct hinic_rxq_stats *rx_stats;
> +	struct hinic_dev *devlink_dev;
>  	struct hinic_dev *nic_dev;
>  	struct net_device *netdev;
>  	struct hinic_hwdev *hwdev;
> +	struct devlink *devlink;
>  	int err, num_qps;
>  
>  	hwdev = hinic_init_hwdev(pdev);
> @@ -1086,6 +1090,15 @@ static int nic_dev_init(struct pci_dev *pdev)
>  		return PTR_ERR(hwdev);
>  	}
>  
> +	devlink = hinic_devlink_alloc();
> +	if (!devlink) {
> +		dev_err(&pdev->dev, "Hinic devlink alloc failed\n");
> +		err = -ENOMEM;
> +		goto err_devlink_alloc;
> +	}
> +
> +	devlink_dev = devlink_priv(devlink);
> +
>  	num_qps = hinic_hwdev_num_qps(hwdev);
>  	if (num_qps <= 0) {
>  		dev_err(&pdev->dev, "Invalid number of QPS\n");
> @@ -1121,6 +1134,7 @@ static int nic_dev_init(struct pci_dev *pdev)
>  	nic_dev->sriov_info.hwdev = hwdev;
>  	nic_dev->sriov_info.pdev = pdev;
>  	nic_dev->max_qps = num_qps;
> +	nic_dev->devlink = devlink;
>  
>  	hinic_set_ethtool_ops(netdev);
>  
> @@ -1146,6 +1160,11 @@ static int nic_dev_init(struct pci_dev *pdev)
>  		goto err_workq;
>  	}
>  
> +	memcpy(devlink_dev, nic_dev, sizeof(*nic_dev));

Please create a separate structure for the devlink-level priv.
This doesn't look right.

> +	err = hinic_devlink_register(devlink, &pdev->dev);
> +	if (err)
> +		goto err_devlink_reg;
> +
>  	pci_set_drvdata(pdev, netdev);
>  
>  	err = hinic_port_get_mac(nic_dev, netdev->dev_addr);

