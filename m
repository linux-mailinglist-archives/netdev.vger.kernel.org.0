Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3739CC751
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 04:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbfJECG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 22:06:57 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3247 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725887AbfJECG4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 22:06:56 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 304A96C75F61F2E24409;
        Sat,  5 Oct 2019 10:06:54 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Sat, 5 Oct 2019
 10:06:46 +0800
Subject: Re: [RFC PATCH] net: hns3: add devlink health dump support for hw mac
 tbl
To:     Jiri Pirko <jiri@resnulli.us>
CC:     <jiri@mellanox.com>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linuxarm@huawei.com>
References: <1569759223-200101-1-git-send-email-linyunsheng@huawei.com>
 <20190930092724.GB2211@nanopsycho>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <f82df09f-fe13-5583-2cac-5ceaf3aeff2a@huawei.com>
Date:   Sat, 5 Oct 2019 10:06:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20190930092724.GB2211@nanopsycho>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/9/30 17:27, Jiri Pirko wrote:
> Sun, Sep 29, 2019 at 02:13:43PM CEST, linyunsheng@huawei.com wrote:
>> This patch adds the devlink health dump support for hw mac tbl,
>> which helps to debug some hardware packet switching problem or
>> misconfiguation of the hardware mac table.
> 
> So you basically make internal hw table available to the user to see if
> I understand that correctly. There is a "devlink dpipe" api that
> basically serves the purpose of describing the hw pipeline and also
> allows user to see content of individual tables in the pipeline. Perhaps
> that would be more suitable for you?
> 

Thanks.
I will look into the "devlink dpipe" api.
It seems the dpipe api is a little complicated than health api, and
there seems to be no mention of it in man page in below:
http://man7.org/linux/man-pages/man8/devlink.8.html

Any more detail info about "devlink dpipe" api would be very helpful.

> 
>>
>> And diagnose and recover support has not been added because
>> RAS and misc error handling has done the recover process, we
>> may also support the recover process through the devlink health
>> api in the future.
> 
> What would be the point for the reporter and what would you recover
> from? It that related to the mac table? How?

There is some error that can be detected by hw when it is accessing some
internal memory, such as below error types defined in
ethernet/hisilicon/hns3/hns3pf/hclge_err.c:

static const struct hclge_hw_error hclge_ppp_mpf_abnormal_int_st1[] = {
	{ .int_msk = BIT(0), .msg = "vf_vlan_ad_mem_ecc_mbit_err",
	  .reset_level = HNAE3_GLOBAL_RESET },
	{ .int_msk = BIT(1), .msg = "umv_mcast_group_mem_ecc_mbit_err",
	  .reset_level = HNAE3_GLOBAL_RESET },
	{ .int_msk = BIT(2), .msg = "umv_key_mem0_ecc_mbit_err",
	  .reset_level = HNAE3_GLOBAL_RESET },
	{ .int_msk = BIT(3), .msg = "umv_key_mem1_ecc_mbit_err",
	  .reset_level = HNAE3_GLOBAL_RESET },
.....

The above errors can be reported to the driver through struct pci_error_handlers
api, and the driver can record the error and recover the error by asserting a PF
or global reset according to the error type.

As for the relation to the mac table, we may need to dump everything including
the internal memory content to further analyze the root cause of the problem.

Does above make sense?

Thanks for taking a look at this.

> 
> 
>>
>> Command example and output:
>>
>> root@(none):~# devlink health dump show pci/0000:7d:00.2 reporter hw_mac_tbl
>> index: 556 mac: 33:33:00:00:00:01 vlan: 0 port: 0 type: 2 mc_mac_en: 1 egress_port: 255 egress_queue: 0 vsi: 0 mc bitmap:
>>   1 0 0 0 0 0 0 0
>> index: 648 mac: 00:18:2d:02:00:10 vlan: 0 port: 1 type: 0 mc_mac_en: 0 egress_port: 2 egress_queue: 0 vsi: 0
>> index: 728 mac: 00:18:2d:00:00:10 vlan: 0 port: 0 type: 0 mc_mac_en: 0 egress_port: 0 egress_queue: 0 vsi: 0
>> index: 1028 mac: 00:18:2d:01:00:10 vlan: 0 port: 2 type: 0 mc_mac_en: 0 egress_port: 1 egress_queue: 0 vsi: 0
>> index: 1108 mac: 00:18:2d:03:00:10 vlan: 0 port: 3 type: 0 mc_mac_en: 0 egress_port: 3 egress_queue: 0 vsi: 0
>> index: 1204 mac: 33:33:00:00:00:01 vlan: 0 port: 1 type: 2 mc_mac_en: 1 egress_port: 253 egress_queue: 0 vsi: 0 mc bitmap:
>>   4 0 0 0 0 0 0 0
>> index: 2844 mac: 01:00:5e:00:00:01 vlan: 0 port: 0 type: 2 mc_mac_en: 1 egress_port: 254 egress_queue: 0 vsi: 0 mc bitmap:
>>   1 0 0 0 0 0 0 0
>> index: 3460 mac: 01:00:5e:00:00:01 vlan: 0 port: 1 type: 2 mc_mac_en: 1 egress_port: 252 egress_queue: 0 vsi: 0 mc bitmap:
>>   4 0 0 0 0 0 0 0
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>> drivers/net/ethernet/hisilicon/Kconfig             |   1 +
>> .../net/ethernet/hisilicon/hns3/hns3pf/Makefile    |   2 +-
>> .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  20 +-
>> .../ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c | 201 +++++++++++++++++++++
>> .../ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h |  36 ++++
>> .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   3 +
>> .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   2 +
>> 7 files changed, 263 insertions(+), 2 deletions(-)
>> create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
>> create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h
>>
>> diff --git a/drivers/net/ethernet/hisilicon/Kconfig b/drivers/net/ethernet/hisilicon/Kconfig
>> index 3892a20..48ec9e2 100644
>> --- a/drivers/net/ethernet/hisilicon/Kconfig
>> +++ b/drivers/net/ethernet/hisilicon/Kconfig
>> @@ -102,6 +102,7 @@ config HNS3_HCLGE
>> 	tristate "Hisilicon HNS3 HCLGE Acceleration Engine & Compatibility Layer Support"
>> 	default m
>> 	depends on PCI_MSI
>> +	select NET_DEVLINK
>> 	---help---
>> 	  This selects the HNS3_HCLGE network acceleration engine & its hardware
>> 	  compatibility layer. The engine would be used in Hisilicon hip08 family of
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile b/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
>> index 0fb61d4..9840a7c 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
>> @@ -6,6 +6,6 @@
>> ccflags-y := -I $(srctree)/drivers/net/ethernet/hisilicon/hns3
>>
>> obj-$(CONFIG_HNS3_HCLGE) += hclge.o
>> -hclge-objs = hclge_main.o hclge_cmd.o hclge_mdio.o hclge_tm.o hclge_mbx.o hclge_err.o  hclge_debugfs.o
>> +hclge-objs = hclge_main.o hclge_cmd.o hclge_mdio.o hclge_tm.o hclge_mbx.o hclge_err.o  hclge_debugfs.o hclge_devlink.o
>>
>> hclge-$(CONFIG_HNS3_DCB) += hclge_dcb.o
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
>> index 4821fe0..09fc101 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
>> @@ -3,9 +3,9 @@
>>
>> #ifndef __HCLGE_CMD_H
>> #define __HCLGE_CMD_H
>> +#include <linux/etherdevice.h>
>> #include <linux/types.h>
>> #include <linux/io.h>
>> -
>> #define HCLGE_CMDQ_TX_TIMEOUT		30000
>>
>> struct hclge_dev;
>> @@ -292,6 +292,7 @@ enum hclge_opcode_type {
>> 	HCLGE_TM_QCN_MEM_INT_CFG	= 0x1A14,
>> 	HCLGE_PPP_CMD0_INT_CMD		= 0x2100,
>> 	HCLGE_PPP_CMD1_INT_CMD		= 0x2101,
>> +	HCLGE_PPP_MAC_VLAN_IDX_RD       = 0x2104,
>> 	HCLGE_MAC_ETHERTYPE_IDX_RD      = 0x2105,
>> 	HCLGE_NCSI_INT_EN		= 0x2401,
>> };
>> @@ -750,6 +751,23 @@ struct hclge_mac_vlan_remove_cmd {
>> 	u8      rsv[4];
>> };
>>
>> +#pragma pack(1)
>> +struct hclge_mac_vlan_idx_rd_cmd {
>> +	u8      rsv0;
>> +	u8      resp_code;
>> +	__le16  vlan_tag;
>> +	u8      mac_addr[ETH_ALEN];
>> +	__le16  port;
>> +	u8      entry_type;
>> +	u8      mc_mac_en;
>> +	__le16  egress_port;
>> +	__le16  egress_queue;
>> +	__le16  vsi;
>> +	__le32  index;
>> +};
>> +
>> +#pragma pack()
>> +
>> struct hclge_vlan_filter_ctrl_cmd {
>> 	u8 vlan_type;
>> 	u8 vlan_fe;
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
>> new file mode 100644
>> index 0000000..3fbbd33
>> --- /dev/null
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
>> @@ -0,0 +1,201 @@
>> +// SPDX-License-Identifier: GPL-2.0+
>> +// Copyright (c) 2018-2019 Hisilicon Limited.
>> +
>> +#include <linux/pci.h>
>> +#include <linux/netdevice.h>
>> +#include <net/devlink.h>
>> +
>> +#include "hclge_cmd.h"
>> +#include "hclge_devlink.h"
>> +
>> +#define HCLGE_HW_MAC_TBL_MAX	4223U
>> +#define HCLGE_HW_MAC_MC_TYPY	2U
>> +
>> +/* dummpy for now */
>> +static const struct devlink_ops hclge_dl_ops = {
>> +};
>> +
>> +static int
>> +hclge_hw_mac_reporter_dump(struct devlink_health_reporter *reporter,
>> +			   struct devlink_fmsg *fmsg, void *priv_ctx)
>> +{
>> +	struct hclge_dev *hdev = devlink_health_reporter_priv(reporter);
>> +	struct hclge_mac_vlan_idx_rd_cmd *mac_cmd;
>> +	char macstr[3 * ETH_ALEN + 1];
>> +	struct hclge_desc desc[3];
>> +	int ret;
>> +	u32 i;
>> +
>> +	for (i = 0; i < HCLGE_HW_MAC_TBL_MAX; i++) {
>> +		u32 value;
>> +
>> +		hclge_cmd_setup_basic_desc(&desc[0], HCLGE_PPP_MAC_VLAN_IDX_RD,
>> +					   true);
>> +		desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
>> +
>> +		hclge_cmd_setup_basic_desc(&desc[1], HCLGE_PPP_MAC_VLAN_IDX_RD,
>> +					   true);
>> +		desc[1].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
>> +
>> +		hclge_cmd_setup_basic_desc(&desc[2], HCLGE_PPP_MAC_VLAN_IDX_RD,
>> +					   true);
>> +
>> +		mac_cmd = (struct hclge_mac_vlan_idx_rd_cmd *)desc[0].data;
>> +		mac_cmd->index = cpu_to_le32(i);
>> +		ret = hclge_cmd_send(&hdev->hw, desc, 3);
>> +		if (ret)
>> +			return ret;
>> +
>> +		if (mac_cmd->resp_code)
>> +			continue;
>> +
>> +		ret = devlink_fmsg_obj_nest_start(fmsg);
>> +		if (ret)
>> +			return ret;
>> +
>> +		ret = devlink_fmsg_u32_pair_put(fmsg, "index", i);
>> +		if (ret)
>> +			return ret;
>> +
>> +		snprintf(macstr, sizeof(macstr), "%pM", mac_cmd->mac_addr);
>> +		ret = devlink_fmsg_string_pair_put(fmsg, "mac", macstr);
>> +		if (ret)
>> +			return ret;
>> +
>> +		value = le16_to_cpu(mac_cmd->vlan_tag);
>> +		ret = devlink_fmsg_u32_pair_put(fmsg, "vlan", value);
>> +		if (ret)
>> +			return ret;
>> +
>> +		value = le16_to_cpu(mac_cmd->port);
>> +		ret = devlink_fmsg_u32_pair_put(fmsg, "port", value);
>> +		if (ret)
>> +			return ret;
>> +
>> +		ret = devlink_fmsg_u8_pair_put(fmsg, "type",
>> +					       mac_cmd->entry_type);
>> +		if (ret)
>> +			return ret;
>> +
>> +		ret = devlink_fmsg_u8_pair_put(fmsg, "mc_mac_en",
>> +					       mac_cmd->mc_mac_en);
>> +		if (ret)
>> +			return ret;
>> +
>> +		value = le16_to_cpu(mac_cmd->egress_port);
>> +		ret = devlink_fmsg_u32_pair_put(fmsg, "egress_port",
>> +						value);
>> +		if (ret)
>> +			return ret;
>> +
>> +		value = le16_to_cpu(mac_cmd->egress_queue);
>> +		ret = devlink_fmsg_u32_pair_put(fmsg, "egress_queue",
>> +						value);
>> +		if (ret)
>> +			return ret;
>> +
>> +		value = le32_to_cpu(mac_cmd->vsi);
>> +		ret = devlink_fmsg_u32_pair_put(fmsg, "vsi", value);
>> +		if (ret)
>> +			return ret;
>> +
>> +		if (mac_cmd->entry_type == HCLGE_HW_MAC_MC_TYPY) {
>> +			int j;
>> +
>> +			ret = devlink_fmsg_arr_pair_nest_start(fmsg,
>> +							       "mc bitmap");
>> +			if (ret)
>> +				return ret;
>> +
>> +			for (j = 0; j < 6; j++) {
>> +				value = le32_to_cpu(desc[1].data[j]);
>> +				ret = devlink_fmsg_u32_put(fmsg, value);
>> +				if (ret)
>> +					return ret;
>> +			}
>> +
>> +			for (j = 0; j < 2; j++) {
>> +				value = le32_to_cpu(desc[2].data[j]);
>> +				ret = devlink_fmsg_u32_put(fmsg, value);
>> +				if (ret)
>> +					return ret;
>> +			}
>> +
>> +			ret = devlink_fmsg_arr_pair_nest_end(fmsg);
>> +			if (ret)
>> +				return ret;
>> +		}
>> +
>> +		ret = devlink_fmsg_obj_nest_end(fmsg);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct
>> +devlink_health_reporter_ops hclge_hw_mac_tbl_reporter_ops = {
>> +		.name = "hw_mac_tbl",
>> +		.dump = hclge_hw_mac_reporter_dump,
>> +};
>> +
>> +int hclge_dl_register(struct hclge_dev *hdev)
>> +{
>> +	struct hclge_dl *priv;
>> +	struct devlink *dl;
>> +	int ret;
>> +
>> +	dl = devlink_alloc(&hclge_dl_ops, sizeof(struct hclge_dl));
>> +	if (!dl) {
>> +		dev_err(&hdev->pdev->dev, "devlink_alloc failed");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	hclge_link_hdev_to_dl(hdev, dl);
>> +
>> +	ret = devlink_register(dl, &hdev->pdev->dev);
>> +	if (ret) {
>> +		dev_err(&hdev->pdev->dev, "devlink_register failed. ret=%d",
>> +			ret);
>> +		hclge_link_hdev_to_dl(hdev, NULL);
>> +		goto err;
>> +	}
>> +
>> +	priv = devlink_priv(dl);
>> +
>> +	priv->hw_mac_tbl =
>> +		devlink_health_reporter_create(dl,
>> +					       &hclge_hw_mac_tbl_reporter_ops,
>> +					       0, false, hdev);
>> +
>> +	if (IS_ERR(priv->hw_mac_tbl)) {
>> +		ret = PTR_ERR(priv->hw_mac_tbl);
>> +		dev_err(&hdev->pdev->dev,
>> +			"Failed to create hw mac tbl reporter, err = %d\n",
>> +			ret);
>> +		goto err;
>> +	}
>> +
>> +	return 0;
>> +err:
>> +	hclge_link_hdev_to_dl(hdev, NULL);
>> +	devlink_free(dl);
>> +	return ret;
>> +}
>> +
>> +void hclge_dl_unregister(struct hclge_dev *hdev)
>> +{
>> +	struct devlink *dl = hdev->dl;
>> +	struct hclge_dl *priv;
>> +
>> +	if (!dl)
>> +		return;
>> +
>> +	priv = devlink_priv(dl);
>> +	if (!IS_ERR_OR_NULL(priv->hw_mac_tbl))
>> +		devlink_health_reporter_destroy(priv->hw_mac_tbl);
>> +
>> +	devlink_unregister(dl);
>> +	devlink_free(dl);
>> +}
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h
>> new file mode 100644
>> index 0000000..da33380
>> --- /dev/null
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h
>> @@ -0,0 +1,36 @@
>> +// SPDX-License-Identifier: GPL-2.0+
>> +// Copyright (c) 2018-2019 Hisilicon Limited.
>> +
>> +#ifndef __HCLGE_DEVLINK_H
>> +#define __HCLGE_DEVLINK_H
>> +
>> +#include "hclge_main.h"
>> +
>> +struct hclge_dl {
>> +	struct hclge_dev *hdev;	/* back ptr to the controlling dev */
>> +	struct devlink_health_reporter *hw_mac_tbl;
>> +};
>> +
>> +static inline struct hclge_dev *hclge_get_hdev_from_dl(struct devlink *dl)
>> +{
>> +	return ((struct hclge_dl *)devlink_priv(dl))->hdev;
>> +}
>> +
>> +/* To clear devlink pointer from hdev, pass NULL dl */
>> +static inline void hclge_link_hdev_to_dl(struct hclge_dev *hdev,
>> +					 struct devlink *dl)
>> +{
>> +	hdev->dl = dl;
>> +
>> +	/* add a back pointer in dl to hdev */
>> +	if (dl) {
>> +		struct hclge_dl *hdev_dl = devlink_priv(dl);
>> +
>> +		hdev_dl->hdev = hdev;
>> +	}
>> +}
>> +
>> +int hclge_dl_register(struct hclge_dev *hdev);
>> +void hclge_dl_unregister(struct hclge_dev *hdev);
>> +
>> +#endif
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> index fd7f943..23f46e8 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> @@ -16,6 +16,7 @@
>> #include <net/rtnetlink.h>
>> #include "hclge_cmd.h"
>> #include "hclge_dcb.h"
>> +#include "hclge_devlink.h"
>> #include "hclge_main.h"
>> #include "hclge_mbx.h"
>> #include "hclge_mdio.h"
>> @@ -9290,6 +9291,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
>>
>> 	hclge_state_init(hdev);
>> 	hdev->last_reset_time = jiffies;
>> +	hclge_dl_register(hdev);
>>
>> 	dev_info(&hdev->pdev->dev, "%s driver initialization finished.\n",
>> 		 HCLGE_DRIVER_NAME);
>> @@ -9430,6 +9432,7 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
>> 	struct hclge_dev *hdev = ae_dev->priv;
>> 	struct hclge_mac *mac = &hdev->hw.mac;
>>
>> +	hclge_dl_unregister(hdev);
>> 	hclge_misc_affinity_teardown(hdev);
>> 	hclge_state_uninit(hdev);
>>
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
>> index 3e9574a..f83fe21 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
>> @@ -8,6 +8,7 @@
>> #include <linux/phy.h>
>> #include <linux/if_vlan.h>
>> #include <linux/kfifo.h>
>> +#include <net/devlink.h>
>>
>> #include "hclge_cmd.h"
>> #include "hnae3.h"
>> @@ -835,6 +836,7 @@ struct hclge_dev {
>> 	/* affinity mask and notify for misc interrupt */
>> 	cpumask_t affinity_mask;
>> 	struct irq_affinity_notify affinity_notify;
>> +	struct devlink *dl;
>> };
>>
>> /* VPort level vlan tag configuration for TX direction */
>> -- 
>> 2.8.1
>>
> 
> .
> 

