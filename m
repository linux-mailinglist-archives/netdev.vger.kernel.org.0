Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47404444BF
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 16:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbhKCPnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 11:43:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:48394 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229587AbhKCPnX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 11:43:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10156"; a="231374187"
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="231374187"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 08:38:54 -0700
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="468145484"
Received: from smile.fi.intel.com ([10.237.72.184])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 08:38:49 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1miILR-003Itu-09;
        Wed, 03 Nov 2021 17:38:33 +0200
Date:   Wed, 3 Nov 2021 17:38:32 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
Subject: Re: [PATCH v2 04/14] net: wwan: t7xx: Add port proxy infrastructure
Message-ID: <YYKs+DHYRHYFEYEN@smile.fi.intel.com>
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com>
 <20211101035635.26999-5-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101035635.26999-5-ricardo.martinez@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 31, 2021 at 08:56:25PM -0700, Ricardo Martinez wrote:
> From: Haijun Lio <haijun.liu@mediatek.com>
> 
> Port-proxy provides a common interface to interact with different types
> of ports. Ports export their configuration via `struct t7xx_port` and
> operate as defined by `struct port_ops`.

Same here, assuming that the comments from the previous patches are applied
here as well, only unique are given.

...

> -	if (stage == HIF_EX_CLEARQ_DONE)
> +	if (stage == HIF_EX_CLEARQ_DONE) {
>  		/* give DHL time to flush data.
>  		 * this is an empirical value that assure
>  		 * that DHL have enough time to flush all the date.
>  		 */
>  		msleep(PORT_RESET_DELAY_US);

> +	}

These curly brackets should be part of previous patch. Try to minimize
(ideally avoid) ping-pong style of changes in the same series.

...

> +#define CCCI_MAX_CH_ID		0xff /* RX channel ID should NOT be >= this!! */

I haven't got the details behind the comment. Is the Rx channel ID predefined
somewhere? If so, use static_assert() instead of this comment.

...

> +enum ccci_ch {
> +	/* to MD */
> +	CCCI_CONTROL_RX = 0x2000,
> +	CCCI_CONTROL_TX = 0x2001,
> +	CCCI_SYSTEM_RX = 0x2002,
> +	CCCI_SYSTEM_TX = 0x2003,
> +	CCCI_UART1_RX = 0x2006,		/* META */
> +	CCCI_UART1_RX_ACK = 0x2007,
> +	CCCI_UART1_TX = 0x2008,
> +	CCCI_UART1_TX_ACK = 0x2009,
> +	CCCI_UART2_RX = 0x200a,		/* AT */
> +	CCCI_UART2_RX_ACK = 0x200b,
> +	CCCI_UART2_TX = 0x200c,
> +	CCCI_UART2_TX_ACK = 0x200d,
> +	CCCI_MD_LOG_RX = 0x202a,	/* MD logging */
> +	CCCI_MD_LOG_TX = 0x202b,
> +	CCCI_LB_IT_RX = 0x203e,		/* loop back test */
> +	CCCI_LB_IT_TX = 0x203f,
> +	CCCI_STATUS_RX = 0x2043,	/* status polling */
> +	CCCI_STATUS_TX = 0x2044,
> +	CCCI_MIPC_RX = 0x20ce,		/* MIPC */
> +	CCCI_MIPC_TX = 0x20cf,
> +	CCCI_MBIM_RX = 0x20d0,
> +	CCCI_MBIM_TX = 0x20d1,
> +	CCCI_DSS0_RX = 0x20d2,
> +	CCCI_DSS0_TX = 0x20d3,
> +	CCCI_DSS1_RX = 0x20d4,
> +	CCCI_DSS1_TX = 0x20d5,
> +	CCCI_DSS2_RX = 0x20d6,
> +	CCCI_DSS2_TX = 0x20d7,
> +	CCCI_DSS3_RX = 0x20d8,
> +	CCCI_DSS3_TX = 0x20d9,
> +	CCCI_DSS4_RX = 0x20da,
> +	CCCI_DSS4_TX = 0x20db,
> +	CCCI_DSS5_RX = 0x20dc,
> +	CCCI_DSS5_TX = 0x20dd,
> +	CCCI_DSS6_RX = 0x20de,
> +	CCCI_DSS6_TX = 0x20df,
> +	CCCI_DSS7_RX = 0x20e0,
> +	CCCI_DSS7_TX = 0x20e1,

> +	CCCI_MAX_CH_NUM,

Not sure about meaning of this and even needfulness. It's obvious you don't
care about actual value here.

> +	CCCI_MONITOR_CH_ID = GENMASK(31, 28), /* for MD init */
> +	CCCI_INVALID_CH_ID = GENMASK(15, 0),
> +};

...

> +#define MTK_DEV_NAME				"MTK_WWAN_M80"

DEV?

...

> +/* port->minor is configured in-sequence, but when we use it in code
> + * it should be unique among all ports for addressing.
> + */
> +#define TTY_IPC_MINOR_BASE			100
> +#define TTY_PORT_MINOR_BASE			250
> +#define TTY_PORT_MINOR_INVALID			-1

Why it's not automatically allocated?

...

> +static struct t7xx_port md_ccci_ports[] = {
> +	{0, 0, 0, 0, 0, 0, ID_CLDMA1, 0, &dummy_port_ops, 0xff, "dummy_port",},

Use C99 initializers.

> +};

...

> +	nlh = nlmsg_put(nl_skb, 0, 1, NLMSG_DONE, len, 0);
> +	if (!nlh) {

> +		dev_err(port->dev, "could not release netlink\n");

I'm wondering why you are not using net_err() / netdev_err() / netif_err()
where it's appropriate.

> +		nlmsg_free(nl_skb);
> +		return -EFAULT;
> +	}

...

> +	return netlink_broadcast(pprox->netlink_sock, nl_skb,
> +				 0, grp, GFP_KERNEL);

One line?

...

> +static int port_netlink_init(void)
> +{
> +	port_prox->netlink_sock = netlink_kernel_create(&init_net, PORT_NOTIFY_PROTOCOL, NULL);
> +
> +	if (!port_prox->netlink_sock) {
> +		dev_err(port_prox->dev, "failed to create netlink socket\n");
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +static void port_netlink_uninit(void)
> +{
> +	if (port_prox->netlink_sock) {

if (!->netlink_sock) ?

> +		netlink_kernel_release(port_prox->netlink_sock);
> +		port_prox->netlink_sock = NULL;
> +	}
> +}

...

> +static struct t7xx_port *proxy_get_port(int minor, enum ccci_ch ch)
> +{
> +	struct t7xx_port *port;
> +	int i;
> +
> +	if (!port_prox)
> +		return NULL;
> +
> +	for_each_proxy_port(i, port, port_prox) {
> +		if (minor >= 0 && port->minor == minor)
> +			return port;
> +
> +		if (ch != CCCI_INVALID_CH_ID && (port->rx_ch == ch || port->tx_ch == ch))
> +			return port;
> +	}
> +
> +	return NULL;
> +}
> +
> +struct t7xx_port *port_proxy_get_port(int major, int minor)
> +{
> +	if (port_prox && port_prox->major == major)
> +		return proxy_get_port(minor, CCCI_INVALID_CH_ID);
> +
> +	return NULL;
> +}

Looking into the second one I would definitely refactor the first one


static struct t7xx_port *do_proxy_get_port(int minor, enum ccci_ch ch)
{
	struct t7xx_port *port;
	int i;

	for_each_proxy_port(i, port, port_prox) {
		if (minor >= 0 && port->minor == minor)
			return port;

		if (ch != CCCI_INVALID_CH_ID && (port->rx_ch == ch || port->tx_ch == ch))
			return port;
	}

	return NULL;
}

// If it's even needed at all... Perhaps you may move NULL check to the (single?) caller
static struct t7xx_port *proxy_get_port(int minor, enum ccci_ch ch)
{
	if (port_prox)
		return do_proxy_get_port(minor, ch);

	return NULL;
}

struct t7xx_port *port_proxy_get_port(int major, int minor)
{
	if (port_prox && port_prox->major == major)
		return do_proxy_get_port(minor, CCCI_INVALID_CH_ID);

	return NULL;
}


> +static inline struct t7xx_port *port_get_by_ch(enum ccci_ch ch)
> +{
> +	return proxy_get_port(TTY_PORT_MINOR_INVALID, ch);
> +}

...

> +	ccci_h = (struct ccci_header *)skb->data;

Do you need casting?

...

> +	if (port->flags & PORT_F_USER_HEADER) { /* header provide by user */

Is it proper English in the comment?

> +		/* CCCI_MON_CH should fall in here, as header must be
> +		 * send to md_init.
> +		 */
> +		if (ccci_h->data[0] == CCCI_HEADER_NO_DATA) {
> +			if (skb->len > sizeof(struct ccci_header)) {
> +				dev_err_ratelimited(port->dev,
> +						    "recv unexpected data for %s, skb->len=%d\n",
> +						    port->name, skb->len);
> +				skb_trim(skb, sizeof(struct ccci_header));
> +			}
> +		}
> +	} else {
> +		/* remove CCCI header */
> +		skb_pull(skb, sizeof(struct ccci_header));
> +	}

...

> +int port_proxy_send_skb(struct t7xx_port *port, struct sk_buff *skb, bool from_pool)
> +{
> +	struct ccci_header *ccci_h;
> +	unsigned char tx_qno;
> +	int ret;
> +
> +	ccci_h = (struct ccci_header *)(skb->data);
> +	tx_qno = port_get_queue_no(port);
> +	port_proxy_set_seq_num(port, (struct ccci_header *)ccci_h);
> +	ret = cldma_send_skb(port->path_id, tx_qno, skb, from_pool, true);
> +	if (ret) {
> +		dev_err(port->dev, "failed to send skb, error: %d\n", ret);
> +	} else {
> +		/* Record the port seq_num after the data is sent to HIF.
> +		 * Only bits 0-14 are used, thus negating overflow.
> +		 */
> +		port->seq_nums[MTK_OUT]++;
> +	}
> +
> +	return ret;

The density of the characters is a bit high. Why not refactor this?

	...blank line here...
	ret = cldma_send_skb(port->path_id, tx_qno, skb, from_pool, true);
	if (ret) {
		dev_err(port->dev, "failed to send skb, error: %d\n", ret);
		return ret;
	}

	...

> +}

...

> +	port_list = &port_prox->rx_ch_ports[channel & CCCI_CH_ID_MASK];
> +	list_for_each_entry(port, port_list, entry) {
> +		if (queue->hif_id != port->path_id || channel != port->rx_ch)
> +			continue;
> +
> +		/* Multi-cast is not supported, because one port may be freed
> +		 * and can modify this request before another port can process it.
> +		 * However we still can use req->state to achieve some kind of
> +		 * multi-cast if needed.
> +		 */
> +		if (port->ops->recv_skb) {
> +			seq_num = port_check_rx_seq_num(port, ccci_h);
> +			ret = port->ops->recv_skb(port, skb);
> +			/* If the packet is stored to RX buffer
> +			 * successfully or drop, the sequence
> +			 * num will be updated.
> +			 */
> +			if (ret == -ENOBUFS)

Why you don't need to free SKB here?

> +				return ret;
> +
> +			port->seq_nums[MTK_IN] = seq_num;
> +		}
> +
> +		break;
> +	}
> +
> +err_exit:
> +	if (ret < 0) {
> +		struct skb_pools *pools;
> +
> +		pools = &queue->md->mtk_dev->pools;
> +		ccci_free_skb(pools, skb);
> +		return -ENETDOWN;
> +	}
> +
> +	return 0;

Why not simply split this to

	return 0;

// pay attention to the label naming
err_free_skb:
	ccci_free_skb(&queue->md->mtk_dev->pools, skb);
	return -ENETDOWN;

I suspect that this may be part of something bigger which is comming,
so try to minimize both weirdness here and additional shuffling
somewhere else in that case.

...

> +	for_each_proxy_port(i, port, port_prox)
> +		if (port->ops->md_state_notify)
> +			port->ops->md_state_notify(port, state);

Perhaps {} ?

...

> +	for_each_proxy_port(i, port, port_prox)
> +		if (!strncmp(port->name, port_name, strlen(port->name)))
> +			return port;

Ditto.

...

> +	switch (state) {
> +	case MTK_PORT_STATE_ENABLE:
> +		snprintf(msg, PORT_NETLINK_MSG_MAX_PAYLOAD, "enable %s", port->name);

sizeof(msg) is much shorter and flexible.

> +		break;
> +
> +	case MTK_PORT_STATE_DISABLE:
> +		snprintf(msg, PORT_NETLINK_MSG_MAX_PAYLOAD, "disable %s", port->name);
> +		break;
> +
> +	default:
> +		snprintf(msg, PORT_NETLINK_MSG_MAX_PAYLOAD, "invalid operation");
> +		break;
> +	}

...

> +struct ctrl_msg_header {
> +	u32			ctrl_msg_id;
> +	u32			reserved;
> +	u32			data_length;
> +	u8			data[0];

We don't allow VLAs.

> +};
> +
> +struct port_msg {
> +	u32			head_pattern;
> +	u32			info;
> +	u32			tail_pattern;
> +	u8			data[0]; /* port set info */

Ditto.

> +};

...

> -				if (event->event_id == CCCI_EVENT_MD_EX_PASS)
> +				if (event->event_id == CCCI_EVENT_MD_EX_PASS) {
> +					pass = true;
>  					fsm_finish_event(ctl, event);
> +				}

Make curly braces to go to the previous patch despite checkpatch warnings.

-- 
With Best Regards,
Andy Shevchenko


