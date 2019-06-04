Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D83413428C
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 11:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfFDJCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 05:02:47 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:18078 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726918AbfFDJCr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 05:02:47 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EC631184A7955246423C;
        Tue,  4 Jun 2019 17:02:42 +0800 (CST)
Received: from [10.177.30.175] (10.177.30.175) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Tue, 4 Jun 2019 17:02:36 +0800
Subject: Re: [PATCH net-next v3] hinic: add LRO support
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoshaokai@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>,
        <wulike1@huawei.com>
References: <20190603043536.4970-1-xuechaojing@huawei.com>
 <20190603160548.000029eb@intel.com>
From:   xuechaojing <xuechaojing@huawei.com>
Message-ID: <28a29407-4655-1391-0b2a-d34f1397ec3a@huawei.com>
Date:   Tue, 4 Jun 2019 17:02:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190603160548.000029eb@intel.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.30.175]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi jesse

Thank you for reviewing.

Our hardware don't support NETIF_F_GRO_HW.

other review comments have been modified.

дк 2019/6/4 7:05, Jesse Brandeburg wrote:
> some review comments below...
>
> On Mon, 3 Jun 2019 04:35:36 +0000
> Xue Chaojing <xuechaojing@huawei.com> wrote:
>
>> This patch adds LRO support for the HiNIC driver.
>>
>> Signed-off-by: Xue Chaojing <xuechaojing@huawei.com>
>> ---
>>   .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |   2 +
>>   .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |   8 +-
>>   .../net/ethernet/huawei/hinic/hinic_hw_io.c   |  58 +++++++++
>>   .../ethernet/huawei/hinic/hinic_hw_qp_ctxt.h  |   5 +
>>   .../net/ethernet/huawei/hinic/hinic_hw_wqe.h  |  22 +++-
>>   .../net/ethernet/huawei/hinic/hinic_main.c    |  51 +++++++-
>>   .../net/ethernet/huawei/hinic/hinic_port.c    | 114 ++++++++++++++++++
>>   .../net/ethernet/huawei/hinic/hinic_port.h    |  45 +++++++
>>   drivers/net/ethernet/huawei/hinic/hinic_rx.c  |  46 +++++--
>>   drivers/net/ethernet/huawei/hinic/hinic_rx.h  |   2 +
>>   10 files changed, 340 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
>> index 3875f39f43bb..756a7e3280bd 100644
>> --- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
>> @@ -313,6 +313,8 @@ static int set_hw_ioctxt(struct hinic_hwdev *hwdev, unsigned int rq_depth,
>>   	hw_ioctxt.set_cmdq_depth = HW_IOCTXT_SET_CMDQ_DEPTH_DEFAULT;
>>   	hw_ioctxt.cmdq_depth = 0;
>>   
>> +	hw_ioctxt.lro_en = 1;
>> +
>>   	hw_ioctxt.rq_depth  = ilog2(rq_depth);
>>   
>>   	hw_ioctxt.rx_buf_sz_idx = HINIC_RX_BUF_SZ_IDX;
>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
>> index c9e621e19dd0..fba4fe82472a 100644
>> --- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
>> @@ -50,6 +50,8 @@ enum hinic_port_cmd {
>>   
>>   	HINIC_PORT_CMD_GET_LINK_STATE   = 24,
>>   
>> +	HINIC_PORT_CMD_SET_LRO		= 25,
>> +
>>   	HINIC_PORT_CMD_SET_RX_CSUM	= 26,
>>   
>>   	HINIC_PORT_CMD_SET_PORT_STATE   = 41,
>> @@ -62,7 +64,11 @@ enum hinic_port_cmd {
>>   
>>   	HINIC_PORT_CMD_SET_TSO          = 112,
>>   
>> +	HINIC_PORT_CMD_SET_RQ_IQ_MAP	= 115,
>> +
>>   	HINIC_PORT_CMD_GET_CAP          = 170,
>> +
>> +	HINIC_PORT_CMD_SET_LRO_TIMER	= 244,
>>   };
>>   
>>   enum hinic_mgmt_msg_cmd {
>> @@ -106,7 +112,7 @@ struct hinic_cmd_hw_ioctxt {
>>   	u8      set_cmdq_depth;
>>   	u8      cmdq_depth;
>>   
>> -	u8      rsvd2;
>> +	u8      lro_en;
>>   	u8      rsvd3;
>>   	u8      rsvd4;
>>   	u8      rsvd5;
>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
>> index a322a22d9357..1169526323cf 100644
>> --- a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
>> @@ -45,6 +45,7 @@
>>   
>>   enum io_cmd {
>>   	IO_CMD_MODIFY_QUEUE_CTXT = 0,
>> +	IO_CMD_CLEAN_QUEUE_CTXT,
>>   };
>>   
>>   static void init_db_area_idx(struct hinic_free_db_area *free_db_area)
>> @@ -210,6 +211,57 @@ static int write_qp_ctxts(struct hinic_func_to_io *func_to_io, u16 base_qpn,
>>   		write_rq_ctxts(func_to_io, base_qpn, num_qps));
>>   }
>>   
>> +static int clean_queue_offload_ctxt(struct hinic_func_to_io *func_to_io,
>> +				    enum hinic_qp_ctxt_type ctxt_type)
> all the other functions you add have hinic_ in front of them, how come
> not this one?
>
>> +{
>> +	struct hinic_hwif *hwif = func_to_io->hwif;
>> +	struct hinic_clean_queue_ctxt *ctxt_block;
>> +	struct pci_dev *pdev = hwif->pdev;
>> +	struct hinic_cmdq_buf cmdq_buf;
>> +	u64 out_param = 0;
>> +	int err;
>> +
>> +	err = hinic_alloc_cmdq_buf(&func_to_io->cmdqs, &cmdq_buf);
>> +	if (err) {
>> +		dev_err(&pdev->dev, "Failed to allocate cmdq buf\n");
>> +		return err;
>> +	}
>> +
>> +	ctxt_block = cmdq_buf.buf;
>> +	ctxt_block->cmdq_hdr.num_queues = func_to_io->max_qps;
>> +	ctxt_block->cmdq_hdr.queue_type = ctxt_type;
>> +	ctxt_block->cmdq_hdr.addr_offset = 0;
>> +
>> +	/* TSO/LRO ctxt size: 0x0:0B; 0x1:160B; 0x2:200B; 0x3:240B */
>> +	ctxt_block->ctxt_size = 0x3;
>> +
>> +	hinic_cpu_to_be32(ctxt_block, sizeof(*ctxt_block));
>> +
>> +	cmdq_buf.size = sizeof(*ctxt_block);
>> +
>> +	err = hinic_cmdq_direct_resp(&func_to_io->cmdqs, HINIC_MOD_L2NIC,
>> +				     IO_CMD_CLEAN_QUEUE_CTXT,
>> +				     &cmdq_buf, &out_param);
>> +
>> +	if (err || out_param) {
>> +		dev_err(&pdev->dev, "Failed to clean queue offload ctxts, err: %d, out_param: 0x%llx\n",
>> +			err, out_param);
>> +
>> +		err = -EFAULT;
>> +	}
>> +
>> +	hinic_free_cmdq_buf(&func_to_io->cmdqs, &cmdq_buf);
>> +
>> +	return err;
>> +}
>> +
>> +static int clean_qp_offload_ctxt(struct hinic_func_to_io *func_to_io)
>> +{
>> +	/* clean LRO/TSO context space */
>> +	return (clean_queue_offload_ctxt(func_to_io, HINIC_QP_CTXT_TYPE_SQ) ||
>> +		clean_queue_offload_ctxt(func_to_io, HINIC_QP_CTXT_TYPE_RQ));
>> +}
>> +
>>   /**
>>    * init_qp - Initialize a Queue Pair
>>    * @func_to_io: func to io channel that holds the IO components
>> @@ -381,6 +433,12 @@ int hinic_io_create_qps(struct hinic_func_to_io *func_to_io,
>>   		goto err_write_qp_ctxts;
>>   	}
>>   
>> +	err = clean_qp_offload_ctxt(func_to_io);
>> +	if (err) {
>> +		dev_err(&pdev->dev, "Failed to clean qp offload ctxts\n");
> What is the user supposed to do when they see this message? Please
> consider that your audience is users who are not developers.  for
> messages that are only useful for developers, you're better off using
> dev_dbg(...)
>
>> +		goto err_write_qp_ctxts;
>> +	}
>> +
>>   	return 0;
>>   
>>   err_write_qp_ctxts:
>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp_ctxt.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp_ctxt.h
>> index 376abf00762b..01c41dd705cb 100644
>> --- a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp_ctxt.h
>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp_ctxt.h
>> @@ -201,6 +201,11 @@ struct hinic_rq_ctxt {
>>   	u32     wq_block_lo_pfn;
>>   };
>>   
>> +struct hinic_clean_queue_ctxt {
>> +	struct hinic_qp_ctxt_header	cmdq_hdr;
>> +	u32				ctxt_size;
>> +};
>> +
>>   struct hinic_sq_ctxt_block {
>>   	struct hinic_qp_ctxt_header hdr;
>>   	struct hinic_sq_ctxt sq_ctxt[HINIC_Q_CTXT_MAX];
>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_wqe.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_wqe.h
>> index 138941527872..ef852b7b57a3 100644
>> --- a/drivers/net/ethernet/huawei/hinic/hinic_hw_wqe.h
>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_wqe.h
>> @@ -219,6 +219,26 @@
>>   #define HINIC_MSS_DEFAULT		        0x3E00
>>   #define HINIC_MSS_MIN		                0x50
>>   
>> +#define RQ_CQE_STATUS_NUM_LRO_SHIFT		16
>> +#define RQ_CQE_STATUS_NUM_LRO_MASK		0xFFU
>> +
>> +#define RQ_CQE_STATUS_GET(val, member)		(((val) >> \
>> +			RQ_CQE_STATUS_##member##_SHIFT) & \
>> +			RQ_CQE_STATUS_##member##_MASK)
>> +
>> +#define HINIC_GET_RX_NUM_LRO(status)	\
>> +		RQ_CQE_STATUS_GET(status, NUM_LRO)
>> +
>> +#define RQ_CQE_OFFOLAD_TYPE_PKT_TYPE_SHIFT		0
>> +#define RQ_CQE_OFFOLAD_TYPE_PKT_TYPE_MASK		0xFFFU
>> +
>> +#define RQ_CQE_OFFOLAD_TYPE_GET(val, member)		(((val) >> \
>> +				RQ_CQE_OFFOLAD_TYPE_##member##_SHIFT) & \
>> +				RQ_CQE_OFFOLAD_TYPE_##member##_MASK)
>> +
>> +#define HINIC_GET_RX_PKT_TYPE(offload_type)	\
>> +			RQ_CQE_OFFOLAD_TYPE_GET(offload_type, PKT_TYPE)
>> +
>>   enum hinic_l4offload_type {
>>   	HINIC_L4_OFF_DISABLE            = 0,
>>   	HINIC_TCP_OFFLOAD_ENABLE        = 1,
>> @@ -372,7 +392,7 @@ struct hinic_rq_cqe {
>>   	u32     status;
>>   	u32     len;
>>   
>> -	u32     rsvd2;
>> +	u32     offload_type;
>>   	u32     rsvd3;
>>   	u32     rsvd4;
>>   	u32     rsvd5;
>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
>> index cfd3f4232cac..175fe53daa9f 100644
>> --- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
>> @@ -372,6 +372,35 @@ static void free_rxqs(struct hinic_dev *nic_dev)
>>   	nic_dev->rxqs = NULL;
>>   }
>>   
>> +int hinic_rx_configure(struct net_device *netdev)
>> +{
>> +	struct hinic_dev *nic_dev = netdev_priv(netdev);
>> +	int err;
>> +
>> +	err = hinic_set_max_qnum(nic_dev, nic_dev->hwdev->nic_cap.max_qps);
>> +	if (err) {
>> +		netif_err(nic_dev, drv, nic_dev->netdev,
>> +			  "Failed - hinic rx configure\n");
>> +		return err;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int hinic_configure(struct hinic_dev *nic_dev)
>> +{
>> +	struct net_device *netdev = nic_dev->netdev;
>> +	int err;
>> +
>> +	err = hinic_rx_configure(netdev);
>> +	if (err) {
>> +		netif_err(nic_dev, drv, netdev, "Failed to configure rx\n");
>> +		return err;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   static int hinic_open(struct net_device *netdev)
>>   {
>>   	struct hinic_dev *nic_dev = netdev_priv(netdev);
>> @@ -401,6 +430,13 @@ static int hinic_open(struct net_device *netdev)
>>   		goto err_create_rxqs;
>>   	}
>>   
>> +	err = hinic_configure(nic_dev);
>> +	if (err) {
>> +		netif_err(nic_dev, drv, netdev,
>> +			  "Failed to hinic configure\n");
> what was the point of the message here? at the very least should be
> "Failed hinic_configure, err %d"
>
>> +		goto err_port_state;
>> +	}
>> +
>>   	num_qps = hinic_hwdev_num_qps(nic_dev->hwdev);
>>   	netif_set_real_num_tx_queues(netdev, num_qps);
>>   	netif_set_real_num_rx_queues(netdev, num_qps);
>> @@ -805,7 +841,7 @@ static void netdev_features_init(struct net_device *netdev)
>>   {
>>   	netdev->hw_features = NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_IP_CSUM |
>>   			      NETIF_F_IPV6_CSUM | NETIF_F_TSO | NETIF_F_TSO6 |
>> -			      NETIF_F_RXCSUM;
>> +			      NETIF_F_RXCSUM | NETIF_F_LRO;
>>   
>>   	netdev->vlan_features = netdev->hw_features;
>>   
>> @@ -869,6 +905,8 @@ static int set_features(struct hinic_dev *nic_dev,
>>   {
>>   	netdev_features_t changed = force_change ? ~0 : pre_features ^ features;
>>   	u32 csum_en = HINIC_RX_CSUM_OFFLOAD_EN;
>> +	u32 lro_buf_size = 0;
>> +	u32 lro_timer = 0;
>>   	int err = 0;
>>   
>>   	if (changed & NETIF_F_TSO)
>> @@ -878,6 +916,17 @@ static int set_features(struct hinic_dev *nic_dev,
>>   	if (changed & NETIF_F_RXCSUM)
>>   		err = hinic_set_rx_csum_offload(nic_dev, csum_en);
>>   
>> +	if (changed & NETIF_F_LRO) {
>> +		lro_timer = HINIC_LRO_RX_TIMER_DEFAULT;
>> +		lro_buf_size = HINIC_LRO_MAX_WQE_NUM_DEFAULT * HINIC_RX_BUF_SZ;
> was there some reason not to just declare as a local? cppcheck would
> have caught this.
>
>> +
>> +		err = hinic_set_rx_lro_state(nic_dev,
>> +					     !!(features & NETIF_F_LRO),
>> +					     lro_timer,
>> +					     lro_buf_size /
>> +					     HINIC_RX_BUF_SZ);
> unwrap the previous line.
>
> I also think you're missing some checks to make sure that if RX_CSUM is
> disabled that LRO turns off.
>
> Also, does your hardware not support the constraints of NETIF_F_GRO_HW?
>
>
>> +	}
>> +
>>   	return err;
>>   }
>>   
>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
>> index 122c93597268..c1947b2f4462 100644
>> --- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
>> @@ -439,3 +439,117 @@ int hinic_set_rx_csum_offload(struct hinic_dev *nic_dev, u32 en)
>>   
>>   	return 0;
>>   }
>> +
>> +int hinic_set_max_qnum(struct hinic_dev *nic_dev, u8 num_rqs)
>> +{
>> +	struct hinic_hwdev *hwdev = nic_dev->hwdev;
>> +	struct hinic_hwif *hwif = hwdev->hwif;
>> +	struct pci_dev *pdev = hwif->pdev;
>> +	struct hinic_rq_num rq_num = {0};
>> +	u16 out_size = sizeof(rq_num);
>> +	int err;
>> +
>> +	rq_num.func_id = HINIC_HWIF_FUNC_IDX(hwif);
>> +	rq_num.num_rqs = num_rqs;
>> +	rq_num.rq_depth = ilog2(HINIC_SQ_DEPTH);
>> +
>> +	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_SET_RQ_IQ_MAP,
>> +				 &rq_num, sizeof(rq_num),
>> +				 &rq_num, &out_size);
>> +	if (err || !out_size || rq_num.status) {
>> +		dev_err(&pdev->dev,
>> +			"Failed to rxq number, ret = %d\n",
>> +			rq_num.status);
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +int hinic_set_rx_lro(struct hinic_dev *nic_dev, u8 ipv4_en, u8 ipv6_en,
>> +		     u8 max_wqe_num)
>> +{
>> +	struct hinic_hwdev *hwdev = nic_dev->hwdev;
>> +	struct hinic_hwif *hwif = hwdev->hwif;
>> +	struct hinic_lro_config lro_cfg = {0};
> I think canonical usage is { 0 };
>
>
>> +	struct pci_dev *pdev = hwif->pdev;
>> +	u16 out_size = sizeof(lro_cfg);
>> +	int err;
>> +
>> +	lro_cfg.func_id = HINIC_HWIF_FUNC_IDX(hwif);
>> +	lro_cfg.lro_ipv4_en = ipv4_en;
>> +	lro_cfg.lro_ipv6_en = ipv6_en;
>> +	lro_cfg.lro_max_wqe_num = max_wqe_num;
>> +
>> +	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_SET_LRO,
>> +				 &lro_cfg, sizeof(lro_cfg),
>> +				 &lro_cfg, &out_size);
>> +	if (err || !out_size || lro_cfg.status) {
>> +		dev_err(&pdev->dev,
>> +			"Failed to set lro offload, ret = %d\n",
>> +			lro_cfg.status);
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +int hinic_set_rx_lro_timer(struct hinic_dev *nic_dev, u32 timer_value)
>> +{
>> +	struct hinic_hwdev *hwdev = nic_dev->hwdev;
>> +	struct hinic_lro_timer lro_timer = {0};
> same as above
>
>> +	struct hinic_hwif *hwif = hwdev->hwif;
>> +	struct pci_dev *pdev = hwif->pdev;
>> +	u16 out_size = sizeof(lro_timer);
>> +	int err;
>> +
>> +	lro_timer.status = 0;
>> +	lro_timer.type = 0;
>> +	lro_timer.enable = 1;
>> +	lro_timer.timer = timer_value;
>> +
>> +	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_SET_LRO_TIMER,
>> +				 &lro_timer, sizeof(lro_timer),
>> +				 &lro_timer, &out_size);
>> +	if (lro_timer.status == 0xFF) {
>> +		/* For this case, we think status (0xFF) is OK */
>> +		lro_timer.status = 0;
>> +		dev_err(&pdev->dev,
>> +			"Set lro timer not supported by the current FW version, it will be 1ms default\n");
> If it's ok, why print a message? also, maybe dev_dbg?
>
>> +	}
>> +
>> +	if (err || !out_size || lro_timer.status) {
>> +		dev_err(&pdev->dev,
>> +			"Failed to set lro timer, ret = %d\n",
>> +			lro_timer.status);
>> +
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +int hinic_set_rx_lro_state(struct hinic_dev *nic_dev, u8 lro_en,
>> +			   u32 lro_timer, u32 wqe_num)
>> +{
>> +	struct hinic_hwdev *hwdev = nic_dev->hwdev;
>> +	u8 ipv4_en = 0;
>> +	u8 ipv6_en = 0;
> no need to initialize with the way you use below, in fact compiler will
> warn of overwritten value if you turn on the right options.
>
>> +	int err;
>> +
>> +	if (!hwdev)
>> +		return -EINVAL;
>> +
>> +	ipv4_en = lro_en ? 1 : 0;
>> +	ipv6_en = lro_en ? 1 : 0;
>> +
>> +	err = hinic_set_rx_lro(nic_dev, ipv4_en, ipv6_en, (u8)wqe_num);
>> +	if (err)
>> +		return err;
>> +
>> +	err = hinic_set_rx_lro_timer(nic_dev, lro_timer);
>> +	if (err)
>> +		return err;
>> +
>> +	return 0;
>> +}
>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
>> index 02d896eed455..94e3f9bbd688 100644
>> --- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
>> @@ -22,6 +22,10 @@
>>   
>>   #include "hinic_dev.h"
>>   
>> +#define HINIC_LRO_MAX_WQE_NUM_DEFAULT     8
>> +
>> +#define HINIC_LRO_RX_TIMER_DEFAULT	16
>> +
>>   enum hinic_rx_mode {
>>   	HINIC_RX_MODE_UC        = BIT(0),
>>   	HINIC_RX_MODE_MC        = BIT(1),
>> @@ -192,6 +196,42 @@ struct hinic_checksum_offload {
>>   	u16	rsvd1;
>>   	u32	rx_csum_offload;
>>   };
>> +
>> +struct hinic_rq_num {
>> +	u8	status;
>> +	u8	version;
>> +	u8	rsvd0[6];
>> +
>> +	u16	func_id;
>> +	u16	rsvd1[33];
>> +	u32	num_rqs;
>> +	u32	rq_depth;
>> +};
>> +
>> +struct hinic_lro_config {
>> +	u8	status;
>> +	u8	version;
>> +	u8	rsvd0[6];
>> +
>> +	u16	func_id;
>> +	u16	rsvd1;
>> +	u8	lro_ipv4_en;
>> +	u8	lro_ipv6_en;
>> +	u8	lro_max_wqe_num;
>> +	u8	resv2[13];
>> +};
>> +
>> +struct hinic_lro_timer {
>> +	u8	status;
>> +	u8	version;
>> +	u8	rsvd0[6];
>> +
>> +	u8	type;   /* 0: set timer value, 1: get timer value */
>> +	u8	enable; /* when set lro time, enable should be 1 */
>> +	u16	rsvd1;
>> +	u32	timer;
>> +};
>> +
>>   int hinic_port_add_mac(struct hinic_dev *nic_dev, const u8 *addr,
>>   		       u16 vlan_id);
>>   
>> @@ -220,7 +260,12 @@ int hinic_port_set_func_state(struct hinic_dev *nic_dev,
>>   int hinic_port_get_cap(struct hinic_dev *nic_dev,
>>   		       struct hinic_port_cap *port_cap);
>>   
>> +int hinic_set_max_qnum(struct hinic_dev *nic_dev, u8 num_rqs);
>> +
>>   int hinic_port_set_tso(struct hinic_dev *nic_dev, enum hinic_tso_state state);
>>   
>>   int hinic_set_rx_csum_offload(struct hinic_dev *nic_dev, u32 en);
>> +
>> +int hinic_set_rx_lro_state(struct hinic_dev *nic_dev, u8 lro_en,
>> +			   u32 lro_timer, u32 wqe_num);
>>   #endif
>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
>> index b6d218768ec1..04c887d13848 100644
>> --- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
>> @@ -45,6 +45,15 @@
>>   #define RX_IRQ_NO_RESEND_TIMER          0
>>   #define HINIC_RX_BUFFER_WRITE           16
>>   
>> +#define HINIC_RX_IPV6_PKT		7
>> +#define LRO_PKT_HDR_LEN_IPV4		66
>> +#define LRO_PKT_HDR_LEN_IPV6		86
>> +#define LRO_REPLENISH_THLD		256
>> +
>> +#define LRO_PKT_HDR_LEN(cqe)		\
>> +	(HINIC_GET_RX_PKT_TYPE(be32_to_cpu((cqe)->offload_type)) == \
>> +	 HINIC_RX_IPV6_PKT ? LRO_PKT_HDR_LEN_IPV6 : LRO_PKT_HDR_LEN_IPV4)
>> +
>>   /**
>>    * hinic_rxq_clean_stats - Clean the statistics of specific queue
>>    * @rxq: Logical Rx Queue
>> @@ -90,18 +99,12 @@ static void rxq_stats_init(struct hinic_rxq *rxq)
>>   	hinic_rxq_clean_stats(rxq);
>>   }
>>   
>> -static void rx_csum(struct hinic_rxq *rxq, u16 cons_idx,
>> +static void rx_csum(struct hinic_rxq *rxq, u32 status,
>>   		    struct sk_buff *skb)
>>   {
>>   	struct net_device *netdev = rxq->netdev;
>> -	struct hinic_rq_cqe *cqe;
>> -	struct hinic_rq *rq;
>>   	u32 csum_err;
>> -	u32 status;
>>   
>> -	rq = rxq->rq;
>> -	cqe = rq->cqe[cons_idx];
>> -	status = be32_to_cpu(cqe->status);
>>   	csum_err = HINIC_RQ_CQE_STATUS_GET(status, CSUM_ERR);
>>   
>>   	if (!(netdev->features & NETIF_F_RXCSUM))
>> @@ -321,12 +324,16 @@ static int rxq_recv(struct hinic_rxq *rxq, int budget)
>>   {
>>   	struct hinic_qp *qp = container_of(rxq->rq, struct hinic_qp, rq);
>>   	u64 pkt_len = 0, rx_bytes = 0;
>> +	struct hinic_rq *rq = rxq->rq;
>>   	struct hinic_rq_wqe *rq_wqe;
>>   	unsigned int free_wqebbs;
>> +	struct hinic_rq_cqe *cqe;
>>   	int num_wqes, pkts = 0;
>>   	struct hinic_sge sge;
>> +	unsigned int status;
>>   	struct sk_buff *skb;
>> -	u16 ci;
>> +	u16 ci, num_lro;
>> +	u16 num_wqe = 0;
>>   
>>   	while (pkts < budget) {
>>   		num_wqes = 0;
>> @@ -336,11 +343,13 @@ static int rxq_recv(struct hinic_rxq *rxq, int budget)
>>   		if (!rq_wqe)
>>   			break;
>>   
>> +		cqe = rq->cqe[ci];
>> +		status =  be32_to_cpu(cqe->status);
>>   		hinic_rq_get_sge(rxq->rq, rq_wqe, ci, &sge);
>>   
>>   		rx_unmap_skb(rxq, hinic_sge_to_dma(&sge));
>>   
>> -		rx_csum(rxq, ci, skb);
>> +		rx_csum(rxq, status, skb);
>>   
>>   		prefetch(skb->data);
>>   
>> @@ -354,7 +363,7 @@ static int rxq_recv(struct hinic_rxq *rxq, int budget)
>>   						     HINIC_RX_BUF_SZ, ci);
>>   		}
>>   
>> -		hinic_rq_put_wqe(rxq->rq, ci,
>> +		hinic_rq_put_wqe(rq, ci,
>>   				 (num_wqes + 1) * HINIC_RQ_WQE_SIZE);
>>   
>>   		skb_record_rx_queue(skb, qp->q_id);
>> @@ -364,6 +373,21 @@ static int rxq_recv(struct hinic_rxq *rxq, int budget)
>>   
>>   		pkts++;
>>   		rx_bytes += pkt_len;
>> +
>> +		num_lro = HINIC_GET_RX_NUM_LRO(status);
>> +		if (num_lro) {
>> +			rx_bytes += ((num_lro - 1) *
>> +				     LRO_PKT_HDR_LEN(cqe));
>> +
>> +			num_wqe +=
>> +			(u16)(pkt_len >> rxq->rx_buff_shift) +
>> +			((pkt_len & (rxq->buf_len - 1)) ? 1 : 0);
>> +		}
>> +
>> +		cqe->status = 0;
>> +
>> +		if (num_wqe >= LRO_REPLENISH_THLD)
>> +			break;
>>   	}
>>   
>>   	free_wqebbs = hinic_get_rq_free_wqebbs(rxq->rq);
>> @@ -482,6 +506,8 @@ int hinic_init_rxq(struct hinic_rxq *rxq, struct hinic_rq *rq,
>>   
>>   	rxq->netdev = netdev;
>>   	rxq->rq = rq;
>> +	rxq->buf_len = HINIC_RX_BUF_SZ;
>> +	rxq->rx_buff_shift = ilog2(HINIC_RX_BUF_SZ);
>>   
>>   	rxq_stats_init(rxq);
>>   
>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.h b/drivers/net/ethernet/huawei/hinic/hinic_rx.h
>> index f8ed3fa6c8ee..08e7d88382cd 100644
>> --- a/drivers/net/ethernet/huawei/hinic/hinic_rx.h
>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.h
>> @@ -41,6 +41,8 @@ struct hinic_rxq {
>>   	struct hinic_rxq_stats  rxq_stats;
>>   
>>   	char                    *irq_name;
>> +	u16			buf_len;
>> +	u32			rx_buff_shift;
>>   
>>   	struct napi_struct      napi;
>>   };
> .
>
