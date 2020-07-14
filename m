Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A4321E4E1
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgGNA4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:56:13 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2578 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726257AbgGNA4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 20:56:13 -0400
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 3C2EB8527A91BEB19D2B;
        Tue, 14 Jul 2020 08:56:11 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 14 Jul 2020 08:56:11 +0800
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 14 Jul 2020 08:56:10 +0800
Subject: Re: [PATCH net-next v1] hinic: add firmware update support
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
References: <20200713140522.14600-1-luobin9@huawei.com>
 <20200713154208.7d123d5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <d4f47ea5-7696-e8e2-81cd-dc398f383413@huawei.com>
Date:   Tue, 14 Jul 2020 08:56:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200713154208.7d123d5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme712-chm.china.huawei.com (10.1.199.108) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/7/14 6:42, Jakub Kicinski wrote:
> On Mon, 13 Jul 2020 22:05:22 +0800 Luo bin wrote:
>> add support to update firmware by the devlink flashing API
>>
>> Signed-off-by: Luo bin <luobin9@huawei.com>
>> ---
>> V0~V1: remove the implementation from ethtool to devlink
> 
> Thanks!
> 
>> +static int check_image_device_type(struct hinic_dev *nic_dev,
>> +				   u32 image_device_type)
>> +{
>> +	struct hinic_comm_board_info board_info = {0};
>> +
>> +	if (image_device_type) {
>> +		if (!hinic_get_board_info(nic_dev->hwdev, &board_info)) {
>> +			if (image_device_type == board_info.info.board_type)
>> +				return true;
> 
> Please simplify this, you shouldn't need more than 1 indentation level
> here.
> 
>> +			dev_err(&nic_dev->hwdev->hwif->pdev->dev, "The device type of upgrade file doesn't match the device type of current firmware, please check the upgrade file\n");
>> +			dev_err(&nic_dev->hwdev->hwif->pdev->dev, "The image device type: 0x%x, firmware device type: 0x%x\n",
>> +				image_device_type, board_info.info.board_type);
>> +
>> +			return false;
>> +		}
>> +	}
>> +
>> +	return false;
>> +}
>> +
>> +static int hinic_flash_fw(struct hinic_dev *nic_dev, const u8 *data,
>> +			  struct host_image_st *host_image, u32 boot_flag)
> 
> You seem to always pass boot_flag = 0, AFAICT, please remove the
> parameter and related code.
> 
>> +{
>> +	u32 section_remain_send_len, send_fragment_len, send_pos, up_total_len;
>> +	struct hinic_cmd_update_fw *fw_update_msg = NULL;
>> +	u32 section_type, section_crc, section_version;
>> +	u32 i, len, section_len, section_offset;
>> +	u16 out_size = sizeof(*fw_update_msg);
>> +	int total_len_flag = 0;
>> +	int err;
> 
>> +int hinic_devlink_register(struct devlink *devlink, struct device *dev)
>> +{
>> +	int err;
>> +
>> +	err = devlink_register(devlink, dev);
>> +
>> +	return err;
> 
> No need for temporary variable.
> 
>> +}
>> +
>> +void hinic_devlink_unregister(struct devlink *devlink)
>> +{
>> +	devlink_unregister(devlink);
>> +}
> 
>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
>> index 834a20a0043c..1dfa09411590 100644
>> --- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
>> @@ -18,6 +18,7 @@
>>  #include <linux/semaphore.h>
>>  #include <linux/workqueue.h>
>>  #include <net/ip.h>
>> +#include <net/devlink.h>
>>  #include <linux/bitops.h>
>>  #include <linux/bitmap.h>
>>  #include <linux/delay.h>
>> @@ -25,6 +26,7 @@
>>  
>>  #include "hinic_hw_qp.h"
>>  #include "hinic_hw_dev.h"
>> +#include "hinic_devlink.h"
>>  #include "hinic_port.h"
>>  #include "hinic_tx.h"
>>  #include "hinic_rx.h"
>> @@ -1075,9 +1077,11 @@ static int nic_dev_init(struct pci_dev *pdev)
>>  	struct hinic_rx_mode_work *rx_mode_work;
>>  	struct hinic_txq_stats *tx_stats;
>>  	struct hinic_rxq_stats *rx_stats;
>> +	struct hinic_dev *devlink_dev;
>>  	struct hinic_dev *nic_dev;
>>  	struct net_device *netdev;
>>  	struct hinic_hwdev *hwdev;
>> +	struct devlink *devlink;
>>  	int err, num_qps;
>>  
>>  	hwdev = hinic_init_hwdev(pdev);
>> @@ -1086,6 +1090,15 @@ static int nic_dev_init(struct pci_dev *pdev)
>>  		return PTR_ERR(hwdev);
>>  	}
>>  
>> +	devlink = hinic_devlink_alloc();
>> +	if (!devlink) {
>> +		dev_err(&pdev->dev, "Hinic devlink alloc failed\n");
>> +		err = -ENOMEM;
>> +		goto err_devlink_alloc;
>> +	}
>> +
>> +	devlink_dev = devlink_priv(devlink);
>> +
>>  	num_qps = hinic_hwdev_num_qps(hwdev);
>>  	if (num_qps <= 0) {
>>  		dev_err(&pdev->dev, "Invalid number of QPS\n");
>> @@ -1121,6 +1134,7 @@ static int nic_dev_init(struct pci_dev *pdev)
>>  	nic_dev->sriov_info.hwdev = hwdev;
>>  	nic_dev->sriov_info.pdev = pdev;
>>  	nic_dev->max_qps = num_qps;
>> +	nic_dev->devlink = devlink;
>>  
>>  	hinic_set_ethtool_ops(netdev);
>>  
>> @@ -1146,6 +1160,11 @@ static int nic_dev_init(struct pci_dev *pdev)
>>  		goto err_workq;
>>  	}
>>  
>> +	memcpy(devlink_dev, nic_dev, sizeof(*nic_dev));
> 
> Please create a separate structure for the devlink-level priv.
> This doesn't look right.
> 
>> +	err = hinic_devlink_register(devlink, &pdev->dev);
>> +	if (err)
>> +		goto err_devlink_reg;
>> +
>>  	pci_set_drvdata(pdev, netdev);
>>  
>>  	err = hinic_port_get_mac(nic_dev, netdev->dev_addr);
> 
> .
> 
Will fix all. Thanks for your review.
