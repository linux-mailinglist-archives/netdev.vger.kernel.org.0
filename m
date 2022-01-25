Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442FA49B540
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 14:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386326AbiAYNlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 08:41:01 -0500
Received: from mga14.intel.com ([192.55.52.115]:40016 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1577545AbiAYNie (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 08:38:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643117914; x=1674653914;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=CJl8PBWTgiP70FiEuIpmVHI/yJo5fJhxK8GLVGV7ffk=;
  b=mgjjEkoJjrP2f6NG7ZmONpKkHRqYGbCm/6biFVkts3R6sh8yGgchE2xM
   5UYjabPJocHh6IuWJm7YufzVRdpti/G+z27KCh3dgZP7VF8MXcDj85KrY
   ekm0JkJWiRX7N+s+Owo8KgG3pYdqzwhERbF2ERIYTDSRqxkjl6Qf61d8O
   dTltMAmtCSFrGlQ/Al9OFDfT7zjoSUvarXi765yupnri5NW4/2DFfayKi
   uIv32p8DNy5+c8utLezarZeA2pW/If6HnycIM0UJ86655O+Rkrzd57pa5
   iehi6AhppUfcDwXHSOPqcVnLxAm89/RrIBjEccsjfpcZlS6xZZc1BjofR
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="246516412"
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="246516412"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 05:38:33 -0800
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="534725441"
Received: from nmaronch-mobl1.amr.corp.intel.com ([10.249.43.124])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 05:38:28 -0800
Date:   Tue, 25 Jan 2022 15:38:26 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com
Subject: Re: [PATCH net-next v4 04/13] net: wwan: t7xx: Add port proxy
 infrastructure
In-Reply-To: <20220114010627.21104-5-ricardo.martinez@linux.intel.com>
Message-ID: <1cea423-8b82-f8bd-227b-60536bb47947@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com> <20220114010627.21104-5-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jan 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Port-proxy provides a common interface to interact with different types
> of ports. Ports export their configuration via `struct t7xx_port` and
> operate as defined by `struct port_ops`.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Co-developed-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> ---

> +struct t7xx_port {
> +	/* Members not initialized in definition */
> +	struct t7xx_port_static *port_static;
> +	struct wwan_port	*wwan_port;
> +	struct t7xx_pci_dev	*t7xx_dev;
> +	struct device		*dev;
> +	short			seq_nums[2];

Make this u16 to avoid implicit sign extensions. If port->seq_nums[MTK_TX]
wouldn't be non-constant expression in
+       ccci_h->status |= cpu_to_le32(FIELD_PREP(HDR_FLD_SEQ, port->seq_nums[MTK_TX]));
it would have triggered internal consistency checks due to implicit sign
extension (in include/linux/bitfield.h):
#define __BF_FIELD_CHECK(_mask, _reg, _val, _pfx)                       \
                ...
                BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?           \
                                 ~((_mask) >> __bf_shf(_mask)) & (_val) : 
0, \
                                 _pfx "value too large for the field"); \
t7xx_port_check_rx_seq_num() is already using u16 for the seq number.

> +#define CHECK_RX_SEQ_MASK		GENMASK(14, 0)

This seems same as FIELD_MAX(HDR_FLD_SEQ). Maybe drop the define and
use it directly in t7xx_port_check_rx_seq_num() as it is already using 
FIELD_GET(HDR_FLD_SEQ).

> +static u16 t7xx_port_check_rx_seq_num(struct t7xx_port *port, struct ccci_header *ccci_h)
> +{
> +	u16 seq_num, assert_bit;
> +
> +	seq_num = FIELD_GET(HDR_FLD_SEQ, le32_to_cpu(ccci_h->status));
> +	assert_bit = FIELD_GET(HDR_FLD_AST, le32_to_cpu(ccci_h->status));
> +	if (assert_bit && port->seq_nums[MTK_RX] &&
> +	    ((seq_num - port->seq_nums[MTK_RX]) & CHECK_RX_SEQ_MASK) != 1) {

Why the non-zero port->seq_nums[MTK_RX] check? It cannot be the initial
value check (-1 is used as the initial value). As is, it could miss ofos
when seq_nums[MTK_RX] had overflowed back to zero).

> +int t7xx_port_recv_skb(struct t7xx_port *port, struct sk_buff *skb)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&port->rx_wq.lock, flags);
> +	if (port->rx_skb_list.qlen < port->rx_length_th) {
> +		struct ccci_header *ccci_h = (struct ccci_header *)skb->data;
> +		u32 channel;
> +
> +		port->flags &= ~PORT_F_RX_FULLED;
> +		if (port->flags & PORT_F_RX_ADJUST_HEADER)
> +			t7xx_port_adjust_skb(port, skb);
> +
> +		channel = FIELD_GET(HDR_FLD_CHN, le32_to_cpu(ccci_h->status));
> +		if (channel == PORT_CH_STATUS_RX) {
> +			port->skb_handler(port, skb);
> +		} else {
> +			if (port->wwan_port)
> +				wwan_port_rx(port->wwan_port, skb);
> +			else
> +				__skb_queue_tail(&port->rx_skb_list, skb);
> +		}
> +
> +		spin_unlock_irqrestore(&port->rx_wq.lock, flags);
> +		wake_up_all(&port->rx_wq);
> +		return 0;
> +	}
> +
> +	port->flags |= PORT_F_RX_FULLED;
> +	spin_unlock_irqrestore(&port->rx_wq.lock, flags);
> +	return -ENOBUFS;
> +}

More typical construct would reverse the if condition, use goto 
queue_full; and deindent the normal path.

> +int t7xx_port_proxy_send_skb(struct t7xx_port *port, struct sk_buff *skb)
> +{
> +	struct ccci_header *ccci_h = (struct ccci_header *)(skb->data);
> +	struct cldma_ctrl *md_ctrl;
> +	unsigned char tx_qno;
> +	int ret;
> +
> +	tx_qno = t7xx_port_get_queue_no(port);
> +	t7xx_port_proxy_set_seq_num(port, ccci_h);
> +
> +	md_ctrl = get_md_ctrl(port);
> +	ret = t7xx_cldma_send_skb(md_ctrl, tx_qno, skb, true);
> +	if (ret) {
> +		dev_err(port->dev, "Failed to send skb: %d\n", ret);
> +		return ret;
> +	}
> +
> +	/* Record the port seq_num after the data is sent to HIF.
> +	 * Only bits 0-14 are used, thus negating overflow.
> +	 */
> +	port->seq_nums[MTK_TX]++;

I think the comment is not particularly useful (and I'd argue it's not
factually correct either as overflow is still occurring).

> +static int t7xx_port_proxy_dispatch_recv_skb(struct cldma_queue *queue, struct sk_buff *skb,
> +					     bool *drop_skb_on_err)
> +{
> +	struct ccci_header *ccci_h = (struct ccci_header *)skb->data;
> +	struct port_proxy *port_prox = queue->md->port_prox;
> +	struct t7xx_fsm_ctl *ctl = queue->md->fsm_ctl;
> +	struct list_head *port_list;
> +	struct t7xx_port *port;
> +	u16 seq_num, channel;
> +	int ret = 0;
> +	u8 ch_id;
> +
> +	channel = FIELD_GET(HDR_FLD_CHN, le32_to_cpu(ccci_h->status));
> +	ch_id = FIELD_GET(PORT_CH_ID_MASK, channel);
> +
> +	if (t7xx_fsm_get_md_state(ctl) == MD_STATE_INVALID) {
> +		*drop_skb_on_err = true;
> +		return -EINVAL;
> +	}
> +
> +	port_list = &port_prox->rx_ch_ports[ch_id];
> +	list_for_each_entry(port, port_list, entry) {
> +		struct t7xx_port_static *port_static = port->port_static;
> +
> +		if (queue->md_ctrl->hif_id != port_static->path_id || channel !=
> +		    port_static->rx_ch)
> +			continue;
> +
> +		/* Multi-cast is not supported, because one port may be freed and can modify
> +		 * this request before another port can process it.
> +		 * However we still can use req->state to do some kind of multi-cast if needed.
> +		 */
> +		if (port_static->ops->recv_skb) {
> +			seq_num = t7xx_port_check_rx_seq_num(port, ccci_h);
> +			ret = port_static->ops->recv_skb(port, skb);
> +			/* If the packet is stored to RX buffer successfully or dropped,
> +			 * the sequence number will be updated.
> +			 */
> +			if (ret == -ENETDOWN || (ret < 0 && port->flags & PORT_F_RX_ALLOW_DROP)) {
> +				*drop_skb_on_err = true;
> +				dev_err_ratelimited(port->dev,
> +						    "port %s RX full, drop packet\n",
> +						    port_static->name);
> +			}

One -ENETDOWN path (the only one returned by the driver itself) already 
printed an error and the information is not consistent with what is being 
printed here, perhaps these error branches would need to differentiated?


> +static void t7xx_proxy_init_all_ports(struct t7xx_modem *md)
> +{
> +	struct port_proxy *port_prox = md->port_prox;
> +	struct t7xx_port *port;
> +	int i;
> +
> +	for_each_proxy_port(i, port, port_prox) {
> +		struct t7xx_port_static *port_static = port->port_static;
> +
> +		t7xx_port_struct_init(port);
> +
> +		port->t7xx_dev = md->t7xx_dev;
> +		port->dev = &md->t7xx_dev->pdev->dev;
> +		spin_lock_init(&port->port_update_lock);
> +		spin_lock(&port->port_update_lock);
> +		mutex_init(&port->tx_mutex_lock);
> +
> +		if (port->flags & PORT_F_CHAR_NODE_SHOW)
> +			port->chan_enable = true;
> +		else
> +			port->chan_enable = false;
> +
> +		port->chn_crt_stat = false;
> +		spin_unlock(&port->port_update_lock);

Odd looking spin_lock sequence.



> +int t7xx_port_proxy_node_control(struct t7xx_modem *md, struct port_msg *port_msg)
> +{
> +	u32 *port_info_base = (void *)port_msg + sizeof(*port_msg);
...
> +		u32 *port_info = port_info_base + i;
...
> +		ch_id = FIELD_GET(PORT_INFO_CH_ID, *port_info);

Byte-order.


> +#define PORT_INFO_ENFLG		GENMASK(15, 15)

BIT(15) would seem more sensical for a flag bit.


-- 
 i.

