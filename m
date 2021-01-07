Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188AD2EC7A3
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 02:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbhAGBTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 20:19:11 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:9960 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbhAGBTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 20:19:11 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DB7dJ57XHzj3Mv;
        Thu,  7 Jan 2021 09:17:40 +0800 (CST)
Received: from [10.67.102.67] (10.67.102.67) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.498.0; Thu, 7 Jan 2021
 09:18:15 +0800
Subject: Re: [PATCH RFC net-next] net: hns3: debugfs add dump tm info of
 nodes, priority and qset
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <lipeng321@huawei.com>,
        <salil.mehta@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1609405396-39071-1-git-send-email-huangguangbin2@huawei.com>
Message-ID: <a0395221-e4e8-e040-e5af-da236337ec10@huawei.com>
Date:   Thu, 7 Jan 2021 09:18:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1609405396-39071-1-git-send-email-huangguangbin2@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ping

On 2020/12/31 17:03, Guangbin Huang wrote:
> To increase methods to dump more tm info, adds three debugfs commands
> to dump tm info of nodes, priority and qset. And a new tm file of debugfs
> is created for only dumping tm info.
> 
> Unlike previous debugfs commands, to dump each tm information, user needs
> to enter two commands now. The first command writes parameters to tm and
> the second command reads info from tm. For examples, to dump tm info of
> priority 0, user needs to enter follow two commands:
> 1. echo dump priority 0 > tm
> 2. cat tm
> 
> The reason for adding new tm file is because we accepted Jakub Kicinski's
> opinion as link https://lkml.org/lkml/2020/9/29/2101. And in order to
> avoid generating too many files, we implement write ops to allow user to
> input parameters.
> 
> However, If there are two or more users concurrently write parameters to
> tm, parameters of the latest command will overwrite previous commands,
> this concurrency problem will confuse users, but now there is no good
> method to fix it.
> 
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> ---
>   drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   9 +
>   drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 117 ++++++++++
>   drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   6 +
>   .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   1 +
>   .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 250 +++++++++++++++++++++
>   .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   1 +
>   .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   2 +
>   .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |  26 +++
>   8 files changed, 412 insertions(+)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
> index 912c51e..08a30de 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
> @@ -243,6 +243,10 @@ struct hnae3_vector_info {
>   	int vector;
>   };
>   
> +enum hnae3_dbg_module_type {
> +	HNAE3_DBG_MODULE_TYPE_TM,
> +};
> +
>   #define HNAE3_RING_TYPE_B 0
>   #define HNAE3_RING_TYPE_TX 0
>   #define HNAE3_RING_TYPE_RX 1
> @@ -454,6 +458,8 @@ struct hnae3_ae_dev {
>    *   Configure the default MAC for specified VF
>    * get_module_eeprom
>    *   Get the optical module eeprom info.
> + * dbg_read_cmd
> + *   Execute debugfs read command.
>    */
>   struct hnae3_ae_ops {
>   	int (*init_ae_dev)(struct hnae3_ae_dev *ae_dev);
> @@ -609,6 +615,8 @@ struct hnae3_ae_ops {
>   	int (*add_arfs_entry)(struct hnae3_handle *handle, u16 queue_id,
>   			      u16 flow_id, struct flow_keys *fkeys);
>   	int (*dbg_run_cmd)(struct hnae3_handle *handle, const char *cmd_buf);
> +	int (*dbg_read_cmd)(struct hnae3_handle *handle, const char *cmd_buf,
> +			    char *buf, int len);
>   	pci_ers_result_t (*handle_hw_ras_error)(struct hnae3_ae_dev *ae_dev);
>   	bool (*get_hw_reset_stat)(struct hnae3_handle *handle);
>   	bool (*ae_dev_resetting)(struct hnae3_handle *handle);
> @@ -734,6 +742,7 @@ struct hnae3_handle {
>   
>   	u8 netdev_flags;
>   	struct dentry *hnae3_dbgfs;
> +	int dbgfs_type;
>   
>   	/* Network interface message level enabled bits */
>   	u32 msg_enable;
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> index dc9a857..bdca7d4 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> @@ -12,6 +12,10 @@
>   
>   static struct dentry *hns3_dbgfs_root;
>   
> +#define HNS3_HELP_INFO "help"
> +
> +#define HNS3_DBG_MODULE_NAME_TM		"tm"
> +
>   static int hns3_dbg_queue_info(struct hnae3_handle *h,
>   			       const char *cmd_buf)
>   {
> @@ -305,6 +309,22 @@ static void hns3_dbg_help(struct hnae3_handle *h)
>   	dev_info(&h->pdev->dev, "%s", printf_buf);
>   }
>   
> +static void hns3_dbg_tm_help(struct hnae3_handle *h, char *buf, int len)
> +{
> +	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
> +	int pos;
> +
> +	pos = scnprintf(buf, len, "available commands:\n");
> +
> +	if (!hns3_is_phys_func(h->pdev))
> +		return;
> +
> +	if (ae_dev->dev_version > HNAE3_DEVICE_VERSION_V2)
> +		pos += scnprintf(buf + pos, len - pos, "dump nodes\n");
> +	pos += scnprintf(buf + pos, len - pos, "dump priority <pri id>\n");
> +	pos += scnprintf(buf + pos, len - pos, "dump qset <qset id>\n");
> +}
> +
>   static void hns3_dbg_dev_caps(struct hnae3_handle *h)
>   {
>   	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
> @@ -444,6 +464,93 @@ static ssize_t hns3_dbg_cmd_write(struct file *filp, const char __user *buffer,
>   	return count;
>   }
>   
> +static ssize_t hns3_dbg_tm_read(struct file *filp, char __user *buffer,
> +				size_t count, loff_t *ppos)
> +{
> +	struct hnae3_handle *handle = filp->private_data;
> +	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
> +	struct hns3_nic_priv *priv  = handle->priv;
> +	char *cmd_buf, *read_buf;
> +	ssize_t size = 0;
> +	int ret = 0;
> +
> +	if (strncmp(filp->f_path.dentry->d_iname, HNS3_DBG_MODULE_NAME_TM,
> +		    strlen(HNS3_DBG_MODULE_NAME_TM)) != 0)
> +		return -EINVAL;
> +
> +	if (!priv->dbg_in_msg.tm)
> +		return -EINVAL;
> +
> +	read_buf = kzalloc(HNS3_DBG_READ_LEN, GFP_KERNEL);
> +	if (!read_buf)
> +		return -ENOMEM;
> +
> +	cmd_buf = priv->dbg_in_msg.tm;
> +	handle->dbgfs_type = HNAE3_DBG_MODULE_TYPE_TM;
> +
> +	if (strncmp(cmd_buf, HNS3_HELP_INFO, strlen(HNS3_HELP_INFO)) == 0)
> +		hns3_dbg_tm_help(handle, read_buf, HNS3_DBG_READ_LEN);
> +	else if (ops->dbg_read_cmd)
> +		ret = ops->dbg_read_cmd(handle, cmd_buf, read_buf,
> +					HNS3_DBG_READ_LEN);
> +
> +	if (ret) {
> +		dev_info(priv->dev, "unknown command\n");
> +		goto out;
> +	}
> +
> +	size = simple_read_from_buffer(buffer, count, ppos, read_buf,
> +				       strlen(read_buf));
> +out:
> +	kfree(read_buf);
> +	return size;
> +}
> +
> +static ssize_t hns3_dbg_tm_write(struct file *filp, const char __user *buffer,
> +				 size_t count, loff_t *ppos)
> +{
> +	struct hnae3_handle *handle = filp->private_data;
> +	struct hns3_nic_priv *priv  = handle->priv;
> +	char *cmd_buf, *cmd_buf_tmp;
> +	int uncopied_bytes;
> +
> +	if (*ppos != 0)
> +		return 0;
> +
> +	/* Judge if the instance is being reset. */
> +	if (!test_bit(HNS3_NIC_STATE_INITED, &priv->state) ||
> +	    test_bit(HNS3_NIC_STATE_RESETTING, &priv->state))
> +		return 0;
> +
> +	if (count > HNS3_DBG_WRITE_LEN)
> +		return -ENOSPC;
> +
> +	kfree(priv->dbg_in_msg.tm);
> +	priv->dbg_in_msg.tm = NULL;
> +
> +	cmd_buf = kzalloc(count + 1, GFP_KERNEL);
> +	if (!cmd_buf)
> +		return count;
> +
> +	uncopied_bytes = copy_from_user(cmd_buf, buffer, count);
> +	if (uncopied_bytes) {
> +		kfree(cmd_buf);
> +		return -EFAULT;
> +	}
> +
> +	cmd_buf[count] = '\0';
> +
> +	cmd_buf_tmp = strchr(cmd_buf, '\n');
> +	if (cmd_buf_tmp) {
> +		*cmd_buf_tmp = '\0';
> +		count = cmd_buf_tmp - cmd_buf + 1;
> +	}
> +
> +	priv->dbg_in_msg.tm = cmd_buf;
> +
> +	return count;
> +}
> +
>   static const struct file_operations hns3_dbg_cmd_fops = {
>   	.owner = THIS_MODULE,
>   	.open  = simple_open,
> @@ -451,6 +558,13 @@ static const struct file_operations hns3_dbg_cmd_fops = {
>   	.write = hns3_dbg_cmd_write,
>   };
>   
> +static const struct file_operations hns3_dbg_tm_fops = {
> +	.owner = THIS_MODULE,
> +	.open  = simple_open,
> +	.read  = hns3_dbg_tm_read,
> +	.write = hns3_dbg_tm_write,
> +};
> +
>   void hns3_dbg_init(struct hnae3_handle *handle)
>   {
>   	const char *name = pci_name(handle->pdev);
> @@ -459,6 +573,9 @@ void hns3_dbg_init(struct hnae3_handle *handle)
>   
>   	debugfs_create_file("cmd", 0600, handle->hnae3_dbgfs, handle,
>   			    &hns3_dbg_cmd_fops);
> +
> +	debugfs_create_file(HNS3_DBG_MODULE_NAME_TM, 0600, handle->hnae3_dbgfs,
> +			    handle, &hns3_dbg_tm_fops);
>   }
>   
>   void hns3_dbg_uninit(struct hnae3_handle *handle)
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
> index 1c81dea..b52f0e6 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
> @@ -464,6 +464,10 @@ struct hns3_enet_tqp_vector {
>   	unsigned long last_jiffies;
>   } ____cacheline_internodealigned_in_smp;
>   
> +struct hns3_dbg_input_msg {
> +	char *tm;
> +};
> +
>   struct hns3_nic_priv {
>   	struct hnae3_handle *ae_handle;
>   	struct net_device *netdev;
> @@ -484,6 +488,8 @@ struct hns3_nic_priv {
>   
>   	struct hns3_enet_coalesce tx_coal;
>   	struct hns3_enet_coalesce rx_coal;
> +
> +	struct hns3_dbg_input_msg dbg_in_msg;
>   };
>   
>   union l3_hdr_info {
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
> index 096e26a..f47437c 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
> @@ -160,6 +160,7 @@ enum hclge_opcode_type {
>   	HCLGE_OPC_TM_PRI_SCH_MODE_CFG   = 0x0813,
>   	HCLGE_OPC_TM_QS_SCH_MODE_CFG    = 0x0814,
>   	HCLGE_OPC_TM_BP_TO_QSET_MAPPING = 0x0815,
> +	HCLGE_OPC_TM_NODES		= 0x0816,
>   	HCLGE_OPC_ETS_TC_WEIGHT		= 0x0843,
>   	HCLGE_OPC_QSET_DFX_STS		= 0x0844,
>   	HCLGE_OPC_PRI_DFX_STS		= 0x0845,
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
> index 16df050..7a893e5 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
> @@ -766,6 +766,223 @@ static void hclge_dbg_dump_tm_map(struct hclge_dev *hdev,
>   		cmd, ret);
>   }
>   
> +static void hclge_dbg_dump_tm_nodes(struct hclge_dev *hdev, char *buf, int len)
> +{
> +	struct hclge_tm_nodes_cmd *nodes;
> +	struct hclge_desc desc;
> +	int pos = 0;
> +	int ret;
> +
> +	if (hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2) {
> +		dev_err(&hdev->pdev->dev, "unsupported command!\n");
> +		return;
> +	}
> +
> +	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_TM_NODES, true);
> +	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
> +	if (ret) {
> +		dev_err(&hdev->pdev->dev,
> +			"failed to dump tm nodes, ret = %d\n", ret);
> +		return;
> +	}
> +
> +	nodes = (struct hclge_tm_nodes_cmd *)desc.data;
> +
> +	pos += scnprintf(buf + pos, len - pos, "PG base_id: %u\n",
> +			 nodes->pg_base_id);
> +	pos += scnprintf(buf + pos, len - pos, "PG number: %u\n",
> +			 nodes->pg_num);
> +	pos += scnprintf(buf + pos, len - pos, "PRI base_id: %u\n",
> +			 nodes->pri_base_id);
> +	pos += scnprintf(buf + pos, len - pos, "PRI number: %u\n",
> +			 nodes->pri_num);
> +	pos += scnprintf(buf + pos, len - pos, "QSET base_id: %u\n",
> +			 le16_to_cpu(nodes->qset_base_id));
> +	pos += scnprintf(buf + pos, len - pos, "QSET number: %u\n",
> +			 le16_to_cpu(nodes->qset_num));
> +	pos += scnprintf(buf + pos, len - pos, "QUEUE base_id: %u\n",
> +			 le16_to_cpu(nodes->queue_base_id));
> +	pos += scnprintf(buf + pos, len - pos, "QUEUE number: %u\n",
> +			 le16_to_cpu(nodes->queue_num));
> +}
> +
> +static int hclge_dbg_dump_tm_pri_sch(struct hclge_dev *hdev, u8 pri_id,
> +				     char *buf, int len)
> +{
> +	struct hclge_priority_weight_cmd *priority_weight;
> +	struct hclge_pri_sch_mode_cfg_cmd *pri_sch_mode;
> +	enum hclge_opcode_type cmd;
> +	struct hclge_desc desc;
> +	int pos = 0;
> +	int ret;
> +
> +	cmd = HCLGE_OPC_TM_PRI_SCH_MODE_CFG;
> +	hclge_cmd_setup_basic_desc(&desc, cmd, true);
> +	pri_sch_mode = (struct hclge_pri_sch_mode_cfg_cmd *)desc.data;
> +	pri_sch_mode->pri_id = pri_id;
> +	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
> +	if (ret)
> +		goto err_tm_pri_sch_cmd_send;
> +
> +	pos += scnprintf(buf + pos, len - pos, "PRI schedule mode: %s\n",
> +			 (pri_sch_mode->sch_mode & HCLGE_TM_TX_SCHD_DWRR_MSK) ?
> +			 "dwrr" : "sp");
> +
> +	cmd = HCLGE_OPC_TM_PRI_WEIGHT;
> +	hclge_cmd_setup_basic_desc(&desc, cmd, true);
> +	priority_weight = (struct hclge_priority_weight_cmd *)desc.data;
> +	priority_weight->pri_id = pri_id;
> +	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
> +	if (ret)
> +		goto err_tm_pri_sch_cmd_send;
> +
> +	pos += scnprintf(buf + pos, len - pos, "PRI dwrr: %u\n",
> +			 priority_weight->dwrr);
> +
> +	return pos;
> +
> +err_tm_pri_sch_cmd_send:
> +	dev_err(&hdev->pdev->dev,
> +		"dump tm priority fail(0x%x), ret=%d\n", cmd, ret);
> +	return pos;
> +}
> +
> +static void hclge_dbg_dump_tm_pri_shaping(struct hclge_dev *hdev, u8 pri_id,
> +					  char *buf, int len)
> +{
> +	struct hclge_pri_shapping_cmd *shap_cfg_cmd;
> +	u8 ir_u, ir_b, ir_s, bs_b, bs_s;
> +	enum hclge_opcode_type cmd;
> +	struct hclge_desc desc;
> +	u32 shapping_para;
> +	int pos = 0;
> +	int ret;
> +
> +	cmd = HCLGE_OPC_TM_PRI_C_SHAPPING;
> +	hclge_cmd_setup_basic_desc(&desc, cmd, true);
> +	shap_cfg_cmd = (struct hclge_pri_shapping_cmd *)desc.data;
> +	shap_cfg_cmd->pri_id = pri_id;
> +	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
> +	if (ret)
> +		goto err_tm_pri_shaping_cmd_send;
> +
> +	shapping_para = le32_to_cpu(shap_cfg_cmd->pri_shapping_para);
> +	ir_b = hclge_tm_get_field(shapping_para, IR_B);
> +	ir_u = hclge_tm_get_field(shapping_para, IR_U);
> +	ir_s = hclge_tm_get_field(shapping_para, IR_S);
> +	bs_b = hclge_tm_get_field(shapping_para, BS_B);
> +	bs_s = hclge_tm_get_field(shapping_para, BS_S);
> +	pos += scnprintf(buf + pos, len - pos,
> +			 "PRI_C ir_b:%u ir_u:%u ir_s:%u bs_b:%u bs_s:%u\n",
> +			 ir_b, ir_u, ir_s, bs_b, bs_s);
> +	pos += scnprintf(buf + pos, len - pos, "PRI_C flag: %#x\n",
> +			 shap_cfg_cmd->flag);
> +	pos += scnprintf(buf + pos, len - pos, "PRI_C pri_rate: %u(Mbps)\n",
> +			 le32_to_cpu(shap_cfg_cmd->pri_rate));
> +
> +	cmd = HCLGE_OPC_TM_PRI_P_SHAPPING;
> +	hclge_cmd_setup_basic_desc(&desc, cmd, true);
> +	shap_cfg_cmd = (struct hclge_pri_shapping_cmd *)desc.data;
> +	shap_cfg_cmd->pri_id = pri_id;
> +	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
> +	if (ret)
> +		goto err_tm_pri_shaping_cmd_send;
> +
> +	shapping_para = le32_to_cpu(shap_cfg_cmd->pri_shapping_para);
> +	ir_b = hclge_tm_get_field(shapping_para, IR_B);
> +	ir_u = hclge_tm_get_field(shapping_para, IR_U);
> +	ir_s = hclge_tm_get_field(shapping_para, IR_S);
> +	bs_b = hclge_tm_get_field(shapping_para, BS_B);
> +	bs_s = hclge_tm_get_field(shapping_para, BS_S);
> +	pos += scnprintf(buf + pos, len - pos,
> +			 "PRI_P ir_b:%u ir_u:%u ir_s:%u bs_b:%u bs_s:%u\n",
> +			 ir_b, ir_u, ir_s, bs_b, bs_s);
> +	pos += scnprintf(buf + pos, len - pos, "PRI_P flag: %#x\n",
> +			 shap_cfg_cmd->flag);
> +	pos += scnprintf(buf + pos, len - pos, "PRI_P pri_rate: %u(Mbps)\n",
> +			 le32_to_cpu(shap_cfg_cmd->pri_rate));
> +
> +	return;
> +
> +err_tm_pri_shaping_cmd_send:
> +	dev_err(&hdev->pdev->dev,
> +		"dump tm priority fail(0x%x), ret=%d\n", cmd, ret);
> +}
> +
> +static void hclge_dbg_dump_tm_pri(struct hclge_dev *hdev, const char *cmd_buf,
> +				  char *buf, int len)
> +{
> +	int ret, pos;
> +	u8 pri_id;
> +
> +	ret = kstrtou8(cmd_buf, 0, &pri_id);
> +	pri_id = (ret != 0) ? 0 : pri_id;
> +
> +	pos = scnprintf(buf, len, "priority id: %u\n", pri_id);
> +
> +	pos += hclge_dbg_dump_tm_pri_sch(hdev, pri_id, buf + pos, len - pos);
> +	hclge_dbg_dump_tm_pri_shaping(hdev, pri_id, buf + pos, len - pos);
> +}
> +
> +static void hclge_dbg_dump_tm_qset(struct hclge_dev *hdev, const char *cmd_buf,
> +				   char *buf, int len)
> +{
> +	struct hclge_qs_sch_mode_cfg_cmd *qs_sch_mode;
> +	struct hclge_qs_weight_cmd *qs_weight;
> +	struct hclge_qs_to_pri_link_cmd *map;
> +	enum hclge_opcode_type cmd;
> +	struct hclge_desc desc;
> +	int ret, pos;
> +	u16 qset_id;
> +
> +	ret = kstrtou16(cmd_buf, 0, &qset_id);
> +	qset_id = (ret != 0) ? 0 : qset_id;
> +
> +	pos = scnprintf(buf, len, "qset id: %u\n", qset_id);
> +
> +	cmd = HCLGE_OPC_TM_QS_TO_PRI_LINK;
> +	map = (struct hclge_qs_to_pri_link_cmd *)desc.data;
> +	hclge_cmd_setup_basic_desc(&desc, cmd, true);
> +	map->qs_id = cpu_to_le16(qset_id);
> +	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
> +	if (ret)
> +		goto err_tm_qset_cmd_send;
> +
> +	pos += scnprintf(buf + pos, len - pos, "QS map pri id: %u\n",
> +			 map->priority);
> +	pos += scnprintf(buf + pos, len - pos, "QS map link_vld: %u\n",
> +			 map->link_vld);
> +
> +	cmd = HCLGE_OPC_TM_QS_SCH_MODE_CFG;
> +	hclge_cmd_setup_basic_desc(&desc, cmd, true);
> +	qs_sch_mode = (struct hclge_qs_sch_mode_cfg_cmd *)desc.data;
> +	qs_sch_mode->qs_id = qset_id;
> +	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
> +	if (ret)
> +		goto err_tm_qset_cmd_send;
> +
> +	pos += scnprintf(buf + pos, len - pos, "QS schedule mode: %s\n",
> +			 (qs_sch_mode->sch_mode & HCLGE_TM_TX_SCHD_DWRR_MSK) ?
> +			 "dwrr" : "sp");
> +
> +	cmd = HCLGE_OPC_TM_QS_WEIGHT;
> +	hclge_cmd_setup_basic_desc(&desc, cmd, true);
> +	qs_weight = (struct hclge_qs_weight_cmd *)desc.data;
> +	qs_weight->qs_id = cpu_to_le16(qset_id);
> +	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
> +	if (ret)
> +		goto err_tm_qset_cmd_send;
> +
> +	pos += scnprintf(buf + pos, len - pos, "QS dwrr: %u\n",
> +			 qs_weight->dwrr);
> +
> +	return;
> +
> +err_tm_qset_cmd_send:
> +	dev_err(&hdev->pdev->dev, "dump tm qset fail(0x%x), ret=%d\n",
> +		cmd, ret);
> +}
> +
>   static void hclge_dbg_dump_qos_pause_cfg(struct hclge_dev *hdev)
>   {
>   	struct hclge_cfg_pause_param_cmd *pause_param;
> @@ -1555,3 +1772,36 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
>   
>   	return 0;
>   }
> +
> +int hclge_dbg_read_cmd_tm(struct hnae3_handle *handle, const char *cmd_buf,
> +			  char *buf, int len)
> +{
> +#define DUMP_TM_NODE	"dump nodes"
> +#define DUMP_TM_PRI	"dump priority"
> +#define DUMP_TM_QSET	"dump qset"
> +
> +	struct hclge_vport *vport = hclge_get_vport(handle);
> +	struct hclge_dev *hdev = vport->back;
> +
> +	if (strncmp(cmd_buf, DUMP_TM_NODE, strlen(DUMP_TM_NODE)) == 0)
> +		hclge_dbg_dump_tm_nodes(hdev, buf, len);
> +	else if (strncmp(cmd_buf, DUMP_TM_PRI, strlen(DUMP_TM_PRI)) == 0)
> +		hclge_dbg_dump_tm_pri(hdev, &cmd_buf[sizeof(DUMP_TM_PRI)],
> +				      buf, len);
> +	else if (strncmp(cmd_buf, DUMP_TM_QSET, strlen(DUMP_TM_QSET)) == 0)
> +		hclge_dbg_dump_tm_qset(hdev, &cmd_buf[sizeof(DUMP_TM_QSET)],
> +				       buf, len);
> +	else
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +int hclge_dbg_read_cmd(struct hnae3_handle *handle, const char *cmd_buf,
> +		       char *buf, int len)
> +{
> +	if (handle->dbgfs_type == HNAE3_DBG_MODULE_TYPE_TM)
> +		return hclge_dbg_read_cmd_tm(handle, cmd_buf, buf, len);
> +
> +	return -EINVAL;
> +}
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> index 1f02640..4b273e4 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> @@ -11408,6 +11408,7 @@ static const struct hnae3_ae_ops hclge_ops = {
>   	.enable_fd = hclge_enable_fd,
>   	.add_arfs_entry = hclge_add_fd_entry_by_arfs,
>   	.dbg_run_cmd = hclge_dbg_run_cmd,
> +	.dbg_read_cmd = hclge_dbg_read_cmd,
>   	.handle_hw_ras_error = hclge_handle_hw_ras_error,
>   	.get_hw_reset_stat = hclge_get_hw_reset_stat,
>   	.ae_dev_resetting = hclge_ae_dev_resetting,
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> index 64e6afd..fc7ab27 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> @@ -985,6 +985,8 @@ int hclge_vport_start(struct hclge_vport *vport);
>   void hclge_vport_stop(struct hclge_vport *vport);
>   int hclge_set_vport_mtu(struct hclge_vport *vport, int new_mtu);
>   int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf);
> +int hclge_dbg_read_cmd(struct hnae3_handle *handle, const char *cmd_buf,
> +		       char *buf, int len);
>   u16 hclge_covert_handle_qid_global(struct hnae3_handle *handle, u16 queue_id);
>   int hclge_notify_client(struct hclge_dev *hdev,
>   			enum hnae3_reset_notify_type type);
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
> index bb2a2d8..898aa14 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
> @@ -59,6 +59,18 @@ struct hclge_priority_weight_cmd {
>   	u8 dwrr;
>   };
>   
> +struct hclge_pri_sch_mode_cfg_cmd {
> +	u8 pri_id;
> +	u8 rev[3];
> +	u8 sch_mode;
> +};
> +
> +struct hclge_qs_sch_mode_cfg_cmd {
> +	__le16 qs_id;
> +	u8 rev[2];
> +	u8 sch_mode;
> +};
> +
>   struct hclge_qs_weight_cmd {
>   	__le16 qs_id;
>   	u8 dwrr;
> @@ -90,6 +102,9 @@ struct hclge_pri_shapping_cmd {
>   	u8 pri_id;
>   	u8 rsvd[3];
>   	__le32 pri_shapping_para;
> +	u8 flag;
> +	u8 rsvd1[3];
> +	__le32 pri_rate;
>   };
>   
>   struct hclge_pg_shapping_cmd {
> @@ -147,6 +162,17 @@ struct hclge_shaper_ir_para {
>   	u8 ir_s; /* IR_S parameter of IR shaper */
>   };
>   
> +struct hclge_tm_nodes_cmd {
> +	u8 pg_base_id;
> +	u8 pri_base_id;
> +	__le16 qset_base_id;
> +	__le16 queue_base_id;
> +	u8 pg_num;
> +	u8 pri_num;
> +	__le16 qset_num;
> +	__le16 queue_num;
> +};
> +
>   #define hclge_tm_set_field(dest, string, val) \
>   			   hnae3_set_field((dest), \
>   			   (HCLGE_TM_SHAP_##string##_MSK), \
> 
