Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD7C2249CE
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 10:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728944AbgGRIVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 04:21:30 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2646 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726940AbgGRIV3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jul 2020 04:21:29 -0400
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 7538EBBDF60EC98ABCCC;
        Sat, 18 Jul 2020 16:21:26 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Sat, 18 Jul 2020 16:21:26 +0800
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sat, 18 Jul 2020 16:21:25 +0800
Subject: Re: [PATCH net-next v1 1/2] hinic: add support to handle hw abnormal
 event
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
References: <20200717083448.20936-1-luobin9@huawei.com>
 <20200717083448.20936-2-luobin9@huawei.com>
 <20200717121159.1729bb47@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <9dfefdc3-3271-a585-3a4d-ecb13dc64331@huawei.com>
Date:   Sat, 18 Jul 2020 16:21:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200717121159.1729bb47@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme716-chm.china.huawei.com (10.1.199.112) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/7/18 3:11, Jakub Kicinski wrote:
> On Fri, 17 Jul 2020 16:34:47 +0800 Luo bin wrote:
>> add support to handle hw abnormal event such as hardware failure,
>> cable unplugged,link error
>>
>> Signed-off-by: Luo bin <luobin9@huawei.com>
>> Reported-by: kernel test robot <lkp@intel.com>
> 
>> +static void hinic_comm_recv_mgmt_self_cmd_reg(struct hinic_pfhwdev *pfhwdev,
>> +					      u8 cmd,
>> +					      comm_mgmt_self_msg_proc proc)
>> +{
>> +	u8 cmd_idx;
>> +
>> +	cmd_idx = pfhwdev->proc.cmd_num;
>> +	if (cmd_idx >= HINIC_COMM_SELF_CMD_MAX) {
>> +		dev_err(&pfhwdev->hwdev.hwif->pdev->dev,
>> +			"Register recv mgmt process failed, cmd: 0x%x\n", cmd);
>> +		return;
>> +	}
>> +
>> +	pfhwdev->proc.info[cmd_idx].cmd = cmd;
>> +	pfhwdev->proc.info[cmd_idx].proc = proc;
>> +	pfhwdev->proc.cmd_num++;
>> +}
>> +
>> +static void hinic_comm_recv_mgmt_self_cmd_unreg(struct hinic_pfhwdev *pfhwdev,
>> +						u8 cmd)
>> +{
>> +	u8 cmd_idx;
>> +
>> +	cmd_idx = pfhwdev->proc.cmd_num;
>> +	if (cmd_idx >= HINIC_COMM_SELF_CMD_MAX) {
>> +		dev_err(&pfhwdev->hwdev.hwif->pdev->dev, "Unregister recv mgmt process failed, cmd: 0x%x\n",
>> +			cmd);
>> +		return;
>> +	}
>> +
>> +	for (cmd_idx = 0; cmd_idx < HINIC_COMM_SELF_CMD_MAX; cmd_idx++) {
>> +		if (cmd == pfhwdev->proc.info[cmd_idx].cmd) {
>> +			pfhwdev->proc.info[cmd_idx].cmd = 0;
>> +			pfhwdev->proc.info[cmd_idx].proc = NULL;
>> +			pfhwdev->proc.cmd_num--;
>> +		}
>> +	}
>> +}
>> +
>> +static void comm_mgmt_msg_handler(void *handle, u8 cmd, void *buf_in,
>> +				  u16 in_size, void *buf_out, u16 *out_size)
>> +{
>> +	struct hinic_pfhwdev *pfhwdev = handle;
>> +	u8 cmd_idx;
>> +
>> +	for (cmd_idx = 0; cmd_idx < pfhwdev->proc.cmd_num; cmd_idx++) {
>> +		if (cmd == pfhwdev->proc.info[cmd_idx].cmd) {
>> +			if (!pfhwdev->proc.info[cmd_idx].proc) {
>> +				dev_warn(&pfhwdev->hwdev.hwif->pdev->dev,
>> +					 "PF recv mgmt comm msg handle null, cmd: 0x%x\n",
>> +					 cmd);
>> +			} else {
>> +				pfhwdev->proc.info[cmd_idx].proc
>> +					(&pfhwdev->hwdev, buf_in, in_size,
>> +					 buf_out, out_size);
>> +			}
>> +
>> +			return;
>> +		}
>> +	}
>> +
>> +	dev_warn(&pfhwdev->hwdev.hwif->pdev->dev, "Received unknown mgmt cpu event: 0x%x\n",
>> +		 cmd);
>> +
>> +	*out_size = 0;
>> +}
>> +
>> +static void chip_fault_show(struct hinic_hwdev *hwdev,
>> +			    struct hinic_fault_event *event)
>> +{
>> +	char fault_level[FAULT_TYPE_MAX][FAULT_SHOW_STR_LEN + 1] = {
>> +		"fatal", "reset", "flr", "general", "suggestion"};
>> +	char level_str[FAULT_SHOW_STR_LEN + 1] = {0};
>> +	u8 level;
>> +
>> +	level = event->event.chip.err_level;
>> +	if (level < FAULT_LEVEL_MAX)
>> +		strncpy(level_str, fault_level[level],
>> +			FAULT_SHOW_STR_LEN);
>> +	else
>> +		strncpy(level_str, "Unknown", FAULT_SHOW_STR_LEN);
>> +
>> +	if (level == FAULT_LEVEL_SERIOUS_FLR)
>> +		dev_err(&hwdev->hwif->pdev->dev, "err_level: %d [%s], flr func_id: %d\n",
>> +			level, level_str, event->event.chip.func_id);
>> +
>> +	dev_err(&hwdev->hwif->pdev->dev, "Module_id: 0x%x, err_type: 0x%x, err_level: %d[%s], err_csr_addr: 0x%08x, err_csr_value: 0x%08x\n",
>> +		event->event.chip.node_id,
>> +		event->event.chip.err_type, level, level_str,
>> +		event->event.chip.err_csr_addr,
>> +		event->event.chip.err_csr_value);
>> +}
>> +
>> +static void fault_report_show(struct hinic_hwdev *hwdev,
>> +			      struct hinic_fault_event *event)
>> +{
>> +	char fault_type[FAULT_TYPE_MAX][FAULT_SHOW_STR_LEN + 1] = {
>> +		"chip", "ucode", "mem rd timeout", "mem wr timeout",
>> +		"reg rd timeout", "reg wr timeout", "phy fault"};
>> +	char type_str[FAULT_SHOW_STR_LEN + 1] = {0};
>> +
>> +	dev_err(&hwdev->hwif->pdev->dev, "Fault event report received, func_id: %d\n",
>> +		HINIC_HWIF_FUNC_IDX(hwdev->hwif));
>> +
>> +	if (event->type < FAULT_TYPE_MAX)
>> +		strncpy(type_str, fault_type[event->type], FAULT_SHOW_STR_LEN);
>> +	else
>> +		strncpy(type_str, "Unknown", FAULT_SHOW_STR_LEN);
>> +
>> +	dev_err(&hwdev->hwif->pdev->dev, "Fault type: %d [%s]\n", event->type,
>> +		type_str);
>> +	dev_err(&hwdev->hwif->pdev->dev,  "Fault val[0]: 0x%08x, val[1]: 0x%08x, val[2]: 0x%08x, val[3]: 0x%08x\n",
>> +		event->event.val[0], event->event.val[1], event->event.val[2],
>> +		event->event.val[3]);
>> +
>> +	switch (event->type) {
>> +	case FAULT_TYPE_CHIP:
>> +		chip_fault_show(hwdev, event);
>> +		break;
>> +	case FAULT_TYPE_UCODE:
>> +		dev_err(&hwdev->hwif->pdev->dev, "Cause_id: %d, core_id: %d, c_id: %d, epc: 0x%08x\n",
>> +			event->event.ucode.cause_id, event->event.ucode.core_id,
>> +			event->event.ucode.c_id, event->event.ucode.epc);
>> +		break;
>> +	case FAULT_TYPE_MEM_RD_TIMEOUT:
>> +	case FAULT_TYPE_MEM_WR_TIMEOUT:
>> +		dev_err(&hwdev->hwif->pdev->dev, "Err_csr_ctrl: 0x%08x, err_csr_data: 0x%08x, ctrl_tab: 0x%08x, mem_index: 0x%08x\n",
>> +			event->event.mem_timeout.err_csr_ctrl,
>> +			event->event.mem_timeout.err_csr_data,
>> +			event->event.mem_timeout.ctrl_tab,
>> +			event->event.mem_timeout.mem_index);
>> +		break;
>> +	case FAULT_TYPE_REG_RD_TIMEOUT:
>> +	case FAULT_TYPE_REG_WR_TIMEOUT:
>> +		dev_err(&hwdev->hwif->pdev->dev, "Err_csr: 0x%08x\n",
>> +			event->event.reg_timeout.err_csr);
>> +		break;
>> +	case FAULT_TYPE_PHY_FAULT:
>> +		dev_err(&hwdev->hwif->pdev->dev, "Op_type: %u, port_id: %u, dev_ad: %u, csr_addr: 0x%08x, op_data: 0x%08x\n",
>> +			event->event.phy_fault.op_type,
>> +			event->event.phy_fault.port_id,
>> +			event->event.phy_fault.dev_ad,
>> +			event->event.phy_fault.csr_addr,
>> +			event->event.phy_fault.op_data);
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +}
>> +
>> +/* pf fault report event */
>> +static void pf_fault_event_handler(void *hwdev, void *buf_in, u16 in_size,
>> +				   void *buf_out, u16 *out_size)
>> +{
>> +	struct hinic_cmd_fault_event *fault_event = buf_in;
>> +
>> +	fault_report_show(hwdev, &fault_event->event);
>> +}
>> +
>> +static void mgmt_watchdog_timeout_event_handler(void *dev,
>> +						void *buf_in, u16 in_size,
>> +						void *buf_out, u16 *out_size)
>> +{
>> +	struct hinic_mgmt_watchdog_info *watchdog_info = NULL;
>> +	struct hinic_hwdev *hwdev = dev;
>> +	u32 *dump_addr = NULL;
>> +	u32 stack_len, i, j;
>> +	u32 *reg = NULL;
>> +
>> +	if (in_size != sizeof(*watchdog_info)) {
>> +		dev_err(&hwdev->hwif->pdev->dev, "Invalid mgmt watchdog report, length: %d, should be %zu\n",
>> +			in_size, sizeof(*watchdog_info));
>> +		return;
>> +	}
>> +
>> +	watchdog_info = buf_in;
>> +
>> +	dev_err(&hwdev->hwif->pdev->dev, "Mgmt deadloop time: 0x%x 0x%x, task id: 0x%x, sp: 0x%x\n",
>> +		watchdog_info->curr_time_h, watchdog_info->curr_time_l,
>> +		watchdog_info->task_id, watchdog_info->sp);
>> +	dev_err(&hwdev->hwif->pdev->dev, "Stack current used: 0x%x, peak used: 0x%x, overflow flag: 0x%x, top: 0x%x, bottom: 0x%x\n",
>> +		watchdog_info->curr_used, watchdog_info->peak_used,
>> +		watchdog_info->is_overflow, watchdog_info->stack_top,
>> +		watchdog_info->stack_bottom);
>> +
>> +	dev_err(&hwdev->hwif->pdev->dev, "Mgmt pc: 0x%08x, lr: 0x%08x, cpsr:0x%08x\n",
>> +		watchdog_info->pc, watchdog_info->lr, watchdog_info->cpsr);
>> +
>> +	dev_err(&hwdev->hwif->pdev->dev, "Mgmt register info\n");
>> +
>> +	for (i = 0; i < 3; i++) {
>> +		reg = watchdog_info->reg + (u64)(u32)(4 * i);
>> +		dev_err(&hwdev->hwif->pdev->dev, "0x%08x 0x%08x 0x%08x 0x%08x\n",
>> +			*(reg), *(reg + 1), *(reg + 2), *(reg + 3));
>> +	}
>> +
>> +	dev_err(&hwdev->hwif->pdev->dev, "0x%08x\n", watchdog_info->reg[12]);
>> +
>> +	if (watchdog_info->stack_actlen <= 1024) {
>> +		stack_len = watchdog_info->stack_actlen;
>> +	} else {
>> +		dev_err(&hwdev->hwif->pdev->dev, "Oops stack length: 0x%x is wrong\n",
>> +			watchdog_info->stack_actlen);
>> +		stack_len = 1024;
>> +	}
>> +
>> +	dev_err(&hwdev->hwif->pdev->dev, "Mgmt dump stack, 16Bytes per line(start from sp)\n");
>> +	for (i = 0; i < (stack_len / 16); i++) {
>> +		dump_addr = (u32 *)(watchdog_info->data + ((u64)(u32)(i * 16)));
>> +		dev_err(&hwdev->hwif->pdev->dev, "0x%08x 0x%08x 0x%08x 0x%08x\n",
>> +			*dump_addr, *(dump_addr + 1), *(dump_addr + 2),
>> +			*(dump_addr + 3));
>> +	}
>> +
>> +	for (j = 0; j < ((stack_len % 16) / 4); j++) {
>> +		dump_addr = (u32 *)(watchdog_info->data +
>> +			    ((u64)(u32)(i * 16 + j * 4)));
>> +		dev_err(&hwdev->hwif->pdev->dev, "0x%08x ", *dump_addr);
>> +	}
>> +
>> +	*out_size = sizeof(*watchdog_info);
>> +	watchdog_info = buf_out;
>> +	watchdog_info->status = 0;
>> +}
> 
> These look like things which should be devlink health reporters.
> 
We need to know very detailed info about hw fault such as value of error status register which can't be showed
through devlink health reporters and we can't dump these error status registers in case of some fatal hw fault.
We'll implement interfaces of devlink health reporter later to show the general health state of hw to user.

>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
>> index c4c6f9c29f0e..98d2133a268b 100644
>> --- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
>> @@ -75,6 +75,10 @@ MODULE_PARM_DESC(rx_weight, "Number Rx packets for NAPI budget (default=64)");
>>  #define HINIC_DEAULT_TXRX_MSIX_COALESC_TIMER_CFG	32
>>  #define HINIC_DEAULT_TXRX_MSIX_RESEND_TIMER_CFG		7
>>  
>> +static const char *hinic_module_link_err[LINK_ERR_NUM] = {
>> +	"Unrecognized module",
>> +};
>> +
>>  static int change_mac_addr(struct net_device *netdev, const u8 *addr);
>>  
>>  static int set_features(struct hinic_dev *nic_dev,
>> @@ -971,6 +975,44 @@ static void link_status_event_handler(void *handle, void *buf_in, u16 in_size,
>>  	*out_size = sizeof(*ret_link_status);
>>  }
>>  
>> +static void cable_plug_event(void *handle,
>> +			     void *buf_in, u16 in_size,
>> +			     void *buf_out, u16 *out_size)
>> +{
>> +	struct hinic_cable_plug_event *plug_event = buf_in;
>> +	struct hinic_dev *nic_dev = handle;
>> +
>> +	netif_info(nic_dev, link, nic_dev->netdev,
>> +		   "Port module event: Cable %s\n",
>> +		   plug_event->plugged ? "plugged" : "unplugged");
>> +
>> +	*out_size = sizeof(*plug_event);
>> +	plug_event = buf_out;
>> +	plug_event->status = 0;
>> +}
>> +
>> +static void link_err_event(void *handle,
>> +			   void *buf_in, u16 in_size,
>> +			   void *buf_out, u16 *out_size)
>> +{
>> +	struct hinic_link_err_event *link_err = buf_in;
>> +	struct hinic_dev *nic_dev = handle;
>> +
>> +	if (link_err->err_type >= LINK_ERR_NUM)
>> +		netif_info(nic_dev, link, nic_dev->netdev,
>> +			   "Link failed, Unknown error type: 0x%x\n",
>> +			   link_err->err_type);
>> +	else
>> +		netif_info(nic_dev, link, nic_dev->netdev,
>> +			   "Link failed, error type: 0x%x: %s\n",
>> +			   link_err->err_type,
>> +			   hinic_module_link_err[link_err->err_type]);
>> +
>> +	*out_size = sizeof(*link_err);
>> +	link_err = buf_out;
>> +	link_err->status = 0;
>> +}
> 
> Please expose link error information via the infrastructure added in
> commit ecc31c60240b ("ethtool: Add link extended state") rather than
> printing it to the logs.
Will fix. Thanks for your review.
> .
> 
