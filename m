Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680195972C4
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 17:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237660AbiHQPPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 11:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbiHQPPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 11:15:24 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B1E85ABB
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 08:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660749322; x=1692285322;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=C2dfwzCJVoV8IK/zCi8wQd8/VoDpYZbwkF86hhRG8Wo=;
  b=cTk66G1u+AvHzRzs0h/TyLWKvSmzowCsHSUAbdgrLr9nWgot60myPSm8
   JI5/9P0hlGgNAxRdMJ8z2pXGQZ0sF/Cc1+bNKR60cztTWIqoF39Dg15j6
   nIRYorAZna4/uVrFPUmCJKZPbu4A9jSgRLxARmKgBpbBOY+y7tcxwITM1
   GYa2mrGPAui4X6hqUlKQil3Z9IEBDikIvwOyogmfvR+//veet3WLgc83b
   DcXnCBAfAed/K4WnhngKcMvOkTtPELK4cgO4Mldn0/3N9WSLqUSGY7UJX
   +zSzG6kkTwt3IJMxYhTAeQx0hFiE1djaGfgKbLjhXifNc5UfC/mw4lOXJ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="272284423"
X-IronPort-AV: E=Sophos;i="5.93,243,1654585200"; 
   d="scan'208";a="272284423"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 08:15:22 -0700
X-IronPort-AV: E=Sophos;i="5.93,243,1654585200"; 
   d="scan'208";a="667660704"
Received: from mckumar-mobl2.gar.corp.intel.com (HELO [10.215.204.195]) ([10.215.204.195])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 08:15:18 -0700
Message-ID: <1ff95a2c-c648-aea2-be23-0d4bf8a9b3d7@linux.intel.com>
Date:   Wed, 17 Aug 2022 20:45:09 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next 2/5] net: wwan: t7xx: Infrastructure for early
 port configuration
Content-Language: en-US
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        m.chetan.kumar@intel.com
Cc:     Netdev <netdev@vger.kernel.org>, kuba@kernel.org,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, linuxwwan@intel.com,
        Haijun Liu <haijun.liu@mediatek.com>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
References: <20220816042340.2416941-1-m.chetan.kumar@intel.com>
 <5a74770-94d3-f690-4aa1-59cdbbb29339@linux.intel.com>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <5a74770-94d3-f690-4aa1-59cdbbb29339@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/17/2022 5:40 PM, Ilpo Järvinen wrote:
> On Tue, 16 Aug 2022, m.chetan.kumar@intel.com wrote:
> 
>> From: Haijun Liu <haijun.liu@mediatek.com>
>>
>> To support cases such as FW update or Core dump, the t7xx device
>> is capable of signaling the host that a special port needs
>> to be created before the handshake phase.
>>
>> This patch adds the infrastructure required to create the
>> early ports which also requires a different configuration of
>> CLDMA queues.
>>
>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>> Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
>> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>> ---
> 
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port.h b/drivers/net/wwan/t7xx/t7xx_port.h
>> index 4a29bd04cbe2..6a96ee6d9449 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_port.h
>> +++ b/drivers/net/wwan/t7xx/t7xx_port.h
>> @@ -100,6 +100,7 @@ struct t7xx_port_conf {
>>   	struct port_ops		*ops;
>>   	char			*name;
>>   	enum wwan_port_type	port_type;
>> +	bool			is_early_port;
>>   };
>>   
>>   struct t7xx_port {
>> @@ -130,9 +131,11 @@ struct t7xx_port {
>>   	struct task_struct		*thread;
>>   };
>>   
>> +int t7xx_get_port_mtu(struct t7xx_port *port);
>>   struct sk_buff *t7xx_port_alloc_skb(int payload);
>>   struct sk_buff *t7xx_ctrl_alloc_skb(int payload);
>>   int t7xx_port_enqueue_skb(struct t7xx_port *port, struct sk_buff *skb);
>> +int t7xx_port_send_raw_skb(struct t7xx_port *port, struct sk_buff *skb);
>>   int t7xx_port_send_skb(struct t7xx_port *port, struct sk_buff *skb, unsigned int pkt_header,
>>   		       unsigned int ex_msg);
>>   int t7xx_port_send_ctl_skb(struct t7xx_port *port, struct sk_buff *skb, unsigned int msg,
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>> index 62305d59da90..7582777cf94d 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>> @@ -88,6 +88,20 @@ static const struct t7xx_port_conf t7xx_md_port_conf[] = {
>>   	},
>>   };
>>   
>> +static struct t7xx_port_conf t7xx_early_port_conf[] = {
>> +	{
>> +		.tx_ch = 0xffff,
>> +		.rx_ch = 0xffff,
>> +		.txq_index = 1,
>> +		.rxq_index = 1,
>> +		.txq_exp_index = 1,
>> +		.rxq_exp_index = 1,
>> +		.path_id = CLDMA_ID_AP,
>> +		.is_early_port = true,
>> +		.name = "ttyDUMP",
>> +	},
>> +};
>> +
>>   static struct t7xx_port *t7xx_proxy_get_port_by_ch(struct port_proxy *port_prox, enum port_ch ch)
>>   {
>>   	const struct t7xx_port_conf *port_conf;
>> @@ -202,7 +216,17 @@ int t7xx_port_enqueue_skb(struct t7xx_port *port, struct sk_buff *skb)
>>   	return 0;
>>   }
>>   
>> -static int t7xx_port_send_raw_skb(struct t7xx_port *port, struct sk_buff *skb)
>> +int t7xx_get_port_mtu(struct t7xx_port *port)
>> +{
>> +	enum cldma_id path_id = port->port_conf->path_id;
>> +	int tx_qno = t7xx_port_get_queue_no(port);
>> +	struct cldma_ctrl *md_ctrl;
>> +
>> +	md_ctrl = port->t7xx_dev->md->md_ctrl[path_id];
>> +	return md_ctrl->tx_ring[tx_qno].pkt_size;
>> +}
>> +
>> +int t7xx_port_send_raw_skb(struct t7xx_port *port, struct sk_buff *skb)
> 
> Why you removed static from this function here (+add the prototype into a
> header), I cannot see anything in this patch. Perhaps those changes belong
> to patch 4?

Prototype is added in header file. Patch4 is using this func.

> 
>>   {
>>   	enum cldma_id path_id = port->port_conf->path_id;
>>   	struct cldma_ctrl *md_ctrl;
>> @@ -317,6 +341,26 @@ static void t7xx_proxy_setup_ch_mapping(struct port_proxy *port_prox)
>>   	}
>>   }
>>   
>> +static int t7xx_port_proxy_recv_skb_from_queue(struct t7xx_pci_dev *t7xx_dev,
>> +					       struct cldma_queue *queue, struct sk_buff *skb)
>> +{
>> +	struct port_proxy *port_prox = t7xx_dev->md->port_prox;
>> +	const struct t7xx_port_conf *port_conf;
>> +	struct t7xx_port *port;
>> +	int ret;
>> +
>> +	port = port_prox->ports;
>> +	port_conf = port->port_conf;
>> +
>> +	ret = port_conf->ops->recv_skb(port, skb);
>> +	if (ret < 0 && ret != -ENOBUFS) {
>> +		dev_err(port->dev, "drop on RX ch %d, %d\n", port_conf->rx_ch, ret);
>> +		dev_kfree_skb_any(skb);
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>>   static struct t7xx_port *t7xx_port_proxy_find_port(struct t7xx_pci_dev *t7xx_dev,
>>   						   struct cldma_queue *queue, u16 channel)
>>   {
>> @@ -338,6 +382,22 @@ static struct t7xx_port *t7xx_port_proxy_find_port(struct t7xx_pci_dev *t7xx_dev
>>   	return NULL;
>>   }
>>   
>> +struct t7xx_port *t7xx_port_proxy_get_port_by_name(struct port_proxy *port_prox, char *port_name)
>> +{
>> +	const struct t7xx_port_conf *port_conf;
>> +	struct t7xx_port *port;
>> +	int i;
>> +
>> +	for_each_proxy_port(i, port, port_prox) {
>> +		port_conf = port->port_conf;
>> +
>> +		if (!strncmp(port_conf->name, port_name, strlen(port_conf->name)))
>> +			return port;
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>>   /**
>>    * t7xx_port_proxy_recv_skb() - Dispatch received skb.
>>    * @queue: CLDMA queue.
>> @@ -358,6 +418,9 @@ static int t7xx_port_proxy_recv_skb(struct cldma_queue *queue, struct sk_buff *s
>>   	u16 seq_num, channel;
>>   	int ret;
>>   
>> +	if (queue->q_type == CLDMA_DEDICATED_Q)
>> +		return t7xx_port_proxy_recv_skb_from_queue(t7xx_dev, queue, skb);
>> +
> 
> So ->recv_skb() is per cldma but now you'd actually want to have a
> different one per queue?

dump and download port uses different configuration (packet size is
different, received data doesn't contain header portion) so using q_type
to distinguish rx flow.

> 
>>   	channel = FIELD_GET(CCCI_H_CHN_FLD, le32_to_cpu(ccci_h->status));
>>   	if (t7xx_fsm_get_md_state(ctl) == MD_STATE_INVALID) {
>>   		dev_err_ratelimited(dev, "Packet drop on channel 0x%x, modem not ready\n", channel);
>> @@ -372,7 +435,8 @@ static int t7xx_port_proxy_recv_skb(struct cldma_queue *queue, struct sk_buff *s
>>   
>>   	seq_num = t7xx_port_next_rx_seq_num(port, ccci_h);
>>   	port_conf = port->port_conf;
>> -	skb_pull(skb, sizeof(*ccci_h));
>> +	if (!port->port_conf->is_early_port)
>> +		skb_pull(skb, sizeof(*ccci_h));
> 
> This seems to be the only user for is_early_port, wouldn't be more obvious
> to store the header size instead?
> 
>>   	ret = port_conf->ops->recv_skb(port, skb);
>>   	/* Error indicates to try again later */
>> @@ -439,26 +503,58 @@ static void t7xx_proxy_init_all_ports(struct t7xx_modem *md)
>>   	t7xx_proxy_setup_ch_mapping(port_prox);
>>   }
>>   
>> +void t7xx_port_proxy_set_cfg(struct t7xx_modem *md, enum port_cfg_id cfg_id)
>> +{
>> +	struct port_proxy *port_prox = md->port_prox;
>> +	const struct t7xx_port_conf *port_conf;
>> +	struct device *dev = port_prox->dev;
>> +	unsigned int port_count;
>> +	struct t7xx_port *port;
>> +	int i;
>> +
>> +	if (port_prox->cfg_id == cfg_id)
>> +		return;
>> +
>> +	if (port_prox->cfg_id != PORT_CFG_ID_INVALID) {
> 
> This seems to be always true.

In initialization flow it would be false.
Depending on boot stage, right port config would be chosen and
cfg_id reflects the chosen config.

> 
>> +		for_each_proxy_port(i, port, port_prox)
>> +			port->port_conf->ops->uninit(port);
>> +
>> +		devm_kfree(dev, port_prox->ports);
>> +	}
>> +	if (cfg_id == PORT_CFG_ID_EARLY) {
>> +		port_conf = t7xx_early_port_conf;
>> +		port_count = ARRAY_SIZE(t7xx_early_port_conf);
>> +	} else {
>> +		port_conf = t7xx_md_port_conf;
>> +		port_count = ARRAY_SIZE(t7xx_md_port_conf);
>> +	}
>> +
>> +	port_prox->ports = devm_kzalloc(dev, sizeof(struct t7xx_port) * port_count, GFP_KERNEL);
>> +	if (!port_prox->ports)
>> +		return;
> 
> Is error handling missing entirely for this failure? (In the caller
> domain, I mean).

Will fix it in next patch.

> 
>> +
>> +	for (i = 0; i < port_count; i++)
>> +		port_prox->ports[i].port_conf = &port_conf[i];
>> +
>> +	port_prox->cfg_id = cfg_id;
>> +	port_prox->port_count = port_count;
>> +	t7xx_proxy_init_all_ports(md);
>> +}
>> +
>>   static int t7xx_proxy_alloc(struct t7xx_modem *md)
>>   {
>> -	unsigned int port_count = ARRAY_SIZE(t7xx_md_port_conf);
>>   	struct device *dev = &md->t7xx_dev->pdev->dev;
>>   	struct port_proxy *port_prox;
>> -	int i;
>>   
>> -	port_prox = devm_kzalloc(dev, sizeof(*port_prox) + sizeof(struct t7xx_port) * port_count,
>> -				 GFP_KERNEL);
>> +	port_prox = devm_kzalloc(dev, sizeof(*port_prox), GFP_KERNEL);
>>   	if (!port_prox)
>>   		return -ENOMEM;
>>   
>>   	md->port_prox = port_prox;
>>   	port_prox->dev = dev;
>> +	t7xx_port_proxy_set_cfg(md, PORT_CFG_ID_EARLY);
>>   
>> -	for (i = 0; i < port_count; i++)
>> -		port_prox->ports[i].port_conf = &t7xx_md_port_conf[i];
>> -
>> -	port_prox->port_count = port_count;
>> -	t7xx_proxy_init_all_ports(md);
>>   	return 0;
>>   }
> 
>> diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
>> index 80edb8e75a6a..c1789a558c9d 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_state_monitor.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
>> @@ -47,6 +47,10 @@
>>   #define FSM_MD_EX_PASS_TIMEOUT_MS		45000
>>   #define FSM_CMD_TIMEOUT_MS			2000
>>   
>> +/* As per MTK, AP to MD Handshake time is ~15s*/
> 
> Add space before */

Will fix it in next patch.

> 
>> +#define DEVICE_STAGE_POLL_INTERVAL_MS		100
>> +#define DEVICE_STAGE_POLL_COUNT			150
>> +
>>   void t7xx_fsm_notifier_register(struct t7xx_modem *md, struct t7xx_fsm_notifier *notifier)
>>   {
>>   	struct t7xx_fsm_ctl *ctl = md->fsm_ctl;
>> @@ -206,6 +210,46 @@ static void fsm_routine_exception(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_comm
>>   		fsm_finish_command(ctl, cmd, 0);
>>   }
>>   
>> +static void t7xx_lk_stage_event_handling(struct t7xx_fsm_ctl *ctl, unsigned int dev_status)
>> +{
>> +	struct t7xx_modem *md = ctl->md;
>> +	struct cldma_ctrl *md_ctrl;
>> +	enum lk_event_id lk_event;
>> +	struct t7xx_port *port;
>> +	struct device *dev;
>> +
>> +	dev = &md->t7xx_dev->pdev->dev;
>> +	lk_event = FIELD_GET(LK_EVENT_MASK, dev_status);
>> +	dev_info(dev, "Device enter next stage from LK stage/n");
> 
> Wrong slash. Maybe also the language of this message could be improved.
> It seems somewhat questionable to have this print out anyway, and its
> usefulness is made even less by not including the lk_event into it,
> I think.

Will fix it in next patch.

> 
>> +	switch (lk_event) {
>> +	case LK_EVENT_NORMAL:
>> +		break;
>> +
>> +	case LK_EVENT_CREATE_PD_PORT:
>> +		md_ctrl = md->md_ctrl[CLDMA_ID_AP];
>> +		t7xx_cldma_hif_hw_init(md_ctrl);
>> +		t7xx_cldma_stop(md_ctrl);
>> +		t7xx_cldma_switch_cfg(md_ctrl, CLDMA_DEDICATED_Q_CFG);
>> +		dev_info(dev, "creating the ttyDUMP port\n");
> 
> I'd just drop this.

Will fix it in next patch.

> 
>> +		port = t7xx_port_proxy_get_port_by_name(md->port_prox, "ttyDUMP");
>> +		if (!port) {
>> +			dev_err(dev, "ttyDUMP port not found\n");
>> +			return;
>> +		}
> 
> Should this be WARN_ON instead, it looks a code level bug for the port to
> not exists (somebody removed ttyDUMP from the code?).

Will fix it in next patch.

> 
>> +		port->port_conf->ops->enable_chl(port);
>> +		t7xx_cldma_start(md_ctrl);
>> +		break;
>> +
>> +	case LK_EVENT_RESET:
>> +		break;
>> +
>> +	default:
>> +		dev_err(dev, "Invalid BROM event\n");
>> +		break;
>> +	}
>> +}
>> +
>>   static int fsm_stopped_handler(struct t7xx_fsm_ctl *ctl)
>>   {
>>   	ctl->curr_state = FSM_STATE_STOPPED;
>> @@ -317,8 +361,10 @@ static int fsm_routine_starting(struct t7xx_fsm_ctl *ctl)
>>   static void fsm_routine_start(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_command *cmd)
>>   {
>>   	struct t7xx_modem *md = ctl->md;
>> +	unsigned int device_stage;
>> +	struct device *dev;
>>   	u32 dev_status;
>> -	int ret;
>> +	int ret = 0;
>>   
>>   	if (!md)
>>   		return;
>> @@ -329,23 +375,60 @@ static void fsm_routine_start(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_command
>>   		return;
>>   	}
>>   
>> +	dev = &md->t7xx_dev->pdev->dev;
>> +	dev_status = ioread32(IREG_BASE(md->t7xx_dev) + T7XX_PCIE_MISC_DEV_STATUS);
>> +	dev_status &= MISC_DEV_STATUS_MASK;
>> +	dev_dbg(dev, "dev_status = %x modem state = %d\n", dev_status, ctl->md_state);
>> +
>> +	if (dev_status == MISC_DEV_STATUS_MASK) {
> 
> I'd add
> #define MISC_DEV_STATUS_INVALID MISC_DEV_STATUS_MASK
> and use it here.

Ok. will consider it.

> 
>> +		dev_err(dev, "invalid device status\n");
>> +		ret = -EINVAL;
>> +		goto finish_command;
>> +	}
>> +
>>   	ctl->curr_state = FSM_STATE_PRE_START;
>>   	t7xx_md_event_notify(md, FSM_PRE_START);
>>   
>> -	ret = read_poll_timeout(ioread32, dev_status,
>> -				(dev_status & MISC_STAGE_MASK) == LINUX_STAGE, 20000, 2000000,
>> -				false, IREG_BASE(md->t7xx_dev) + T7XX_PCIE_MISC_DEV_STATUS);
>> -	if (ret) {
>> -		struct device *dev = &md->t7xx_dev->pdev->dev;
>> +	device_stage = FIELD_GET(MISC_STAGE_MASK, dev_status);
>> +	if (dev_status == ctl->prev_dev_status) {
> 
> Maybe the local variables from need dev_ or device_ prefixes. They just
> makes them harder to read.

Ok. will consider it.

> 
>> +		if (ctl->device_stage_check_cnt++ >= DEVICE_STAGE_POLL_COUNT) {
>> +			dev_err(dev, "Timeout at device stage 0x%x\n", device_stage);
>> +			ctl->device_stage_check_cnt = 0;
>> +			ret = -ETIMEDOUT;
>> +		} else {
>> +			msleep(DEVICE_STAGE_POLL_INTERVAL_MS);
>> +			ret = t7xx_fsm_append_cmd(ctl, FSM_CMD_START, 0);
> 
> I'm somewhat skeptical about this. Could this contain a race that results
> in skipping over a stage?

Ideally it should not skip the stage. The device_stage would reflect the 
actual device boot stage i.e. BROM -> PL -> LK -> Linux.

Just in case, when the next device stage has not changed it poll's for a 
certain interval and returns ETIMEDOUT value to fsm cmd waiter.


> 
> But given I don't know how the startup stages are working, I cannot say
> it's incorrect.
> 
>> +		}
>>   
>> -		fsm_finish_command(ctl, cmd, -ETIMEDOUT);
>> -		dev_err(dev, "Invalid device status 0x%lx\n", dev_status & MISC_STAGE_MASK);
>> -		return;
>> +		goto finish_command;
>> +	}
>> +
>> +	switch (device_stage) {
>> +	case INIT_STAGE:
>> +	case PRE_BROM_STAGE:
>> +	case POST_BROM_STAGE:
>> +		ret = t7xx_fsm_append_cmd(ctl, FSM_CMD_START, 0);
>> +		break;
>> +
>> +	case LK_STAGE:
>> +		dev_info(dev, "LK_STAGE Entered");
>> +		t7xx_lk_stage_event_handling(ctl, dev_status);
>> +		break;
>> +
>> +	case LINUX_STAGE:
>> +		t7xx_cldma_hif_hw_init(md->md_ctrl[CLDMA_ID_AP]);
>> +		t7xx_cldma_hif_hw_init(md->md_ctrl[CLDMA_ID_MD]);
>> +		t7xx_port_proxy_set_cfg(md, PORT_CFG_ID_NORMAL);
>> +		ret = fsm_routine_starting(ctl);
>> +		break;
>> +
>> +	default:
>> +		break;
>>   	}
>>   
>> -	t7xx_cldma_hif_hw_init(md->md_ctrl[CLDMA_ID_AP]);
>> -	t7xx_cldma_hif_hw_init(md->md_ctrl[CLDMA_ID_MD]);
>> -	fsm_finish_command(ctl, cmd, fsm_routine_starting(ctl));
>> +finish_command:
>> +	ctl->prev_dev_status = dev_status;
>> +	fsm_finish_command(ctl, cmd, ret);
>>   }
>>   
>>   static int fsm_main_thread(void *data)
> 
> 

-- 
Chetan
