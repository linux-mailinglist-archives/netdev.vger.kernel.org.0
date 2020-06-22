Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AC7203F45
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 20:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbgFVSio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 14:38:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53964 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730229AbgFVSio (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 14:38:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jnRL2-001hpO-LZ; Mon, 22 Jun 2020 20:38:36 +0200
Date:   Mon, 22 Jun 2020 20:38:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     yunaixin03610@163.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, wuguanping@huawei.com,
        wangqindong@huawei.com
Subject: Re: [PATCH 3/5] Huawei BMA: Adding Huawei BMA driver: host_veth_drv
Message-ID: <20200622183836.GD405672@lunn.ch>
References: <20200622160311.1533-1-yunaixin03610@163.com>
 <20200622160311.1533-4-yunaixin03610@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622160311.1533-4-yunaixin03610@163.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 12:03:09AM +0800, yunaixin03610@163.com wrote:
> From: yunaixin <yunaixin03610@163.com>
> 
> The BMA software is a system management software offered by Huawei. It supports the status monitoring, performance monitoring, and event monitoring of various components, including server CPUs, memory, hard disks, NICs, IB cards, PCIe cards, RAID controller cards, and optical modules.
> 
> This host_veth_drv driver is one of the communication drivers used by BMA software. It depends on the host_edma_drv driver. The host_veth_drv driver will create a virtual net device "veth" once loaded. BMA software will use it to send/receive RESTful messages to/from BMC software.

This might be acceptable, maybe. Some more details of the RESTful API
would be good. Is this using Redfish?

> diff --git a/drivers/net/ethernet/huawei/bma/veth_drv/veth_hb.c b/drivers/net/ethernet/huawei/bma/veth_drv/veth_hb.c
> new file mode 100644
> index 000000000000..9681ce3bfc7b
> --- /dev/null
> +++ b/drivers/net/ethernet/huawei/bma/veth_drv/veth_hb.c
> @@ -0,0 +1,2502 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Huawei iBMA driver.
> + * Copyright (c) 2017, Huawei Technologies Co., Ltd.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */

You have a SPDX, hence you don't need this text.

> +static u32 veth_ethtool_get_link(struct net_device *dev);

The veth prefix is already in use, drivers/net/veth.c. Please use
something else, e.g. bmaveth. Please use it consistently thought the
driver.

> +
> +int debug;			/* debug switch*/
> +module_param_call(debug, &edma_param_set_debug, &param_get_int, &debug, 0644);
> +
> +MODULE_PARM_DESC(debug, "Debug switch (0=close debug, 1=open debug)");

No module parameters.

> +
> +#define VETH_LOG(lv, fmt, args...)    \
> +do {	\
> +	if (debug < (lv))	\
> +		continue;	\
> +	if (lv == DLOG_DEBUG)	\
> +		netdev_dbg(g_bspveth_dev.pnetdev, "%s(), %d, " \
> +		fmt, __func__, __LINE__, ## args);	\
> +	else if (lv == DLOG_ERROR)	\
> +		netdev_err(g_bspveth_dev.pnetdev, "%s(), %d, " \
> +		fmt, __func__, __LINE__, ## args);	\
> +} while (0)

Don't do this. Just use netdev_dbg or netdev_err directly.

> +#ifdef __UT_TEST
> +u32 g_testdma;
> +
> +u32 g_testlbk;
> +
> +#endif

Remove all your unit test code please.

> +
> +struct bspveth_device g_bspveth_dev = {};
> +
> +static int veth_int_handler(struct notifier_block *pthis, unsigned long ev,
> +			    void *unuse);
> +
> +static struct notifier_block g_veth_int_nb = {
> +	.notifier_call = veth_int_handler,
> +};
> +
> +static const struct veth_stats veth_gstrings_stats[] = {
> +	{"rx_packets", NET_STATS, VETH_STAT_SIZE(stats.rx_packets),
> +	 VETH_STAT_OFFSET(stats.rx_packets)},
> +	{"rx_bytes", NET_STATS, VETH_STAT_SIZE(stats.rx_bytes),
> +	 VETH_STAT_OFFSET(stats.rx_bytes)},
> +	{"rx_dropped", NET_STATS, VETH_STAT_SIZE(stats.rx_dropped),
> +	 VETH_STAT_OFFSET(stats.rx_dropped)},
> +	{"rx_head", QUEUE_RX_STATS, QUEUE_TXRX_STAT_SIZE(head),
> +	 QUEUE_TXRX_STAT_OFFSET(head)},
> +	{"rx_tail", QUEUE_RX_STATS, QUEUE_TXRX_STAT_SIZE(tail),
> +	 QUEUE_TXRX_STAT_OFFSET(tail)},
> +	{"rx_next_to_fill", QUEUE_RX_STATS,
> +	 QUEUE_TXRX_STAT_SIZE(next_to_fill),
> +	 QUEUE_TXRX_STAT_OFFSET(next_to_fill)},
> +	{"rx_shmq_head", SHMQ_RX_STATS, SHMQ_TXRX_STAT_SIZE(head),
> +	 SHMQ_TXRX_STAT_OFFSET(head)},
> +	{"rx_shmq_tail", SHMQ_RX_STATS, SHMQ_TXRX_STAT_SIZE(tail),
> +	 SHMQ_TXRX_STAT_OFFSET(tail)},
> +	{"rx_shmq_next_to_free", SHMQ_RX_STATS,
> +	 SHMQ_TXRX_STAT_SIZE(next_to_free),
> +	 SHMQ_TXRX_STAT_OFFSET(next_to_free)},
> +	{"rx_queue_full", QUEUE_RX_STATS,
> +	 QUEUE_TXRX_STAT_SIZE(s.q_full),
> +	 QUEUE_TXRX_STAT_OFFSET(s.q_full)},
> +	{"rx_dma_busy", QUEUE_RX_STATS,
> +	 QUEUE_TXRX_STAT_SIZE(s.dma_busy),
> +	 QUEUE_TXRX_STAT_OFFSET(s.dma_busy)},
> +	{"rx_dma_failed", QUEUE_RX_STATS,
> +	 QUEUE_TXRX_STAT_SIZE(s.dma_failed),
7> +	 QUEUE_TXRX_STAT_OFFSET(s.dma_failed)},
> +
> +	{"tx_packets", NET_STATS, VETH_STAT_SIZE(stats.tx_packets),
> +	 VETH_STAT_OFFSET(stats.tx_packets)},
> +	{"tx_bytes", NET_STATS, VETH_STAT_SIZE(stats.tx_bytes),
> +	 VETH_STAT_OFFSET(stats.tx_bytes)},
> +	{"tx_dropped", NET_STATS, VETH_STAT_SIZE(stats.tx_dropped),
> +	 VETH_STAT_OFFSET(stats.tx_dropped)},
> +
> +	{"tx_head", QUEUE_TX_STATS, QUEUE_TXRX_STAT_SIZE(head),
> +	 QUEUE_TXRX_STAT_OFFSET(head)},
> +	{"tx_tail", QUEUE_TX_STATS, QUEUE_TXRX_STAT_SIZE(tail),
> +	 QUEUE_TXRX_STAT_OFFSET(tail)},
> +	{"tx_next_to_free", QUEUE_TX_STATS,
> +	 QUEUE_TXRX_STAT_SIZE(next_to_free),
> +	 QUEUE_TXRX_STAT_OFFSET(next_to_free)},
> +	{"tx_shmq_head", SHMQ_TX_STATS, SHMQ_TXRX_STAT_SIZE(head),
> +	 SHMQ_TXRX_STAT_OFFSET(head)},
> +	{"tx_shmq_tail", SHMQ_TX_STATS, SHMQ_TXRX_STAT_SIZE(tail),
> +	 SHMQ_TXRX_STAT_OFFSET(tail)},
> +	{"tx_shmq_next_to_free", SHMQ_TX_STATS,
> +	 SHMQ_TXRX_STAT_SIZE(next_to_free),
> +	 SHMQ_TXRX_STAT_OFFSET(next_to_free)},
> +
> +	{"tx_queue_full", QUEUE_TX_STATS,
> +	 QUEUE_TXRX_STAT_SIZE(s.q_full),
> +	 QUEUE_TXRX_STAT_OFFSET(s.q_full)},
> +	{"tx_dma_busy", QUEUE_TX_STATS,
> +	 QUEUE_TXRX_STAT_SIZE(s.dma_busy),
> +	 QUEUE_TXRX_STAT_OFFSET(s.dma_busy)},
> +	{"tx_dma_failed", QUEUE_TX_STATS,
> +	 QUEUE_TXRX_STAT_SIZE(s.dma_failed),
> +	 QUEUE_TXRX_STAT_OFFSET(s.dma_failed)},
> +
> +	{"recv_int", VETH_STATS, VETH_STAT_SIZE(recv_int),
> +	 VETH_STAT_OFFSET(recv_int)},
> +	{"tobmc_int", VETH_STATS, VETH_STAT_SIZE(tobmc_int),
> +	 VETH_STAT_OFFSET(tobmc_int)},
> +};
> +
> +#define VETH_GLOBAL_STATS_LEN	\
> +		(sizeof(veth_gstrings_stats) / sizeof(struct veth_stats))
> +
> +static int veth_param_get_statics(char *buf, const struct kernel_param *kp)
> +{
> +	int len = 0;
> +	int i = 0, j = 0, type = 0;
> +	struct bspveth_rxtx_q *pqueue = NULL;
> +	__kernel_time_t running_time = 0;
> +
> +	if (!buf)
> +		return 0;
> +
> +	GET_SYS_SECONDS(running_time);
> +
> +	running_time -= g_bspveth_dev.init_time;
> +
> +	len += sprintf(buf + len,
> +			"================VETH INFO=============\r\n");
> +	len += sprintf(buf + len, "[version     ]:" VETH_VERSION "\n");
> +	len += sprintf(buf + len, "[link state  ]:%d\n",
> +			veth_ethtool_get_link(g_bspveth_dev.pnetdev));
> +	len += sprintf(buf + len, "[running_time]:%luD %02lu:%02lu:%02lu\n",
> +			running_time / (SECONDS_PER_DAY),
> +			running_time % (SECONDS_PER_DAY) / SECONDS_PER_HOUR,
> +			running_time % SECONDS_PER_HOUR / SECONDS_PER_MINUTE,
> +			running_time % SECONDS_PER_MINUTE);
> +	len += sprintf(buf + len,
> +			"[bspveth_dev ]:MAX_QUEUE_NUM :0x%-16x	",
> +			MAX_QUEUE_NUM);
> +	len += sprintf(buf + len,
> +			"MAX_QUEUE_BDNUM :0x%-16x\r\n", MAX_QUEUE_BDNUM);
> +	len += sprintf(buf + len,
> +			"[bspveth_dev ]:pnetdev	  :0x%-16p	",
> +			g_bspveth_dev.pnetdev);
> +	len += sprintf(buf + len,
> +			"ppcidev		 :0x%-16p\r\n",
> +			g_bspveth_dev.ppcidev);
> +	len += sprintf(buf + len,
> +			"[bspveth_dev ]:pshmpool_p:0x%-16p	",
> +			g_bspveth_dev.pshmpool_p);
> +	len += sprintf(buf + len,
> +			"pshmpool_v	  :0x%-16p\r\n",
> +			g_bspveth_dev.pshmpool_v);
> +	len += sprintf(buf + len,
> +			"[bspveth_dev ]:shmpoolsize:0x%-16x	",
> +			g_bspveth_dev.shmpoolsize);
> +	len += sprintf(buf + len,
> +			"g_veth_dbg_lv		:0x%-16x\r\n", debug);
> +
> +	for (i = 0; i < MAX_QUEUE_NUM; i++) {
> +		for (j = 0, type = BSPVETH_RX; j < 2; j++, type++) {
> +			if (type == BSPVETH_RX) {
> +				pqueue = g_bspveth_dev.prx_queue[i];
> +				len += sprintf(buf + len,
> +				"=============RXQUEUE STATIS============\r\n");
> +			} else {
> +				pqueue = g_bspveth_dev.ptx_queue[i];
> +				len += sprintf(buf + len,
> +				"=============TXQUEUE STATIS============\r\n");
> +			}
> +
> +			if (!pqueue) {
> +				len += sprintf(buf + len, "NULL\r\n");
> +				continue;
> +			}
> +
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[pkt	] :%lld\r\n", i,
> +					pqueue->s.pkt);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[pktbyte	] :%lld\r\n", i,
> +					pqueue->s.pktbyte);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[refill	] :%lld\r\n", i,
> +					pqueue->s.refill);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[freetx	] :%lld\r\n", i,
> +					pqueue->s.freetx);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[dmapkt	] :%lld\r\n", i,
> +					pqueue->s.dmapkt);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[dmapktbyte	] :%lld\r\n", i,
> +					pqueue->s.dmapktbyte);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[next_to_fill ] :%d\r\n", i,
> +					pqueue->next_to_fill);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[next_to_free ] :%d\r\n", i,
> +					pqueue->next_to_free);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[head	] :%d\r\n", i,
> +					pqueue->head);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[tail	] :%d\r\n", i,
> +					pqueue->tail);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[work_limit	] :%d\r\n", i,
> +					pqueue->work_limit);
> +			len += sprintf(buf + len,
> +			"=================SHARE=================\r\n");
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[next_to_fill] :%d\r\n", i,
> +					pqueue->pshmqhd_v->next_to_fill);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[next_to_free] :%d\r\n", i,
> +					pqueue->pshmqhd_v->next_to_free);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[head	] :%d\r\n", i,
> +					pqueue->pshmqhd_v->head);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[tail	] :%d\r\n", i,
> +					pqueue->pshmqhd_v->tail);
> +			len += sprintf(buf + len,
> +			"=======================================\r\n");
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[dropped_pkt] :%d\r\n", i,
> +					pqueue->s.dropped_pkt);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[netifrx_err] :%d\r\n", i,
> +					pqueue->s.netifrx_err);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[null_point	] :%d\r\n", i,
> +					pqueue->s.null_point);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[retry_err	] :%d\r\n", i,
> +					pqueue->s.retry_err);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[allocskb_err  ] :%d\r\n",
> +					i, pqueue->s.allocskb_err);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[q_full	] :%d\r\n", i,
> +					pqueue->s.q_full);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[q_emp	] :%d\r\n", i,
> +					pqueue->s.q_emp);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[need_fill	] :%d\r\n", i,
> +					pqueue->s.need_fill);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[need_free	] :%d\r\n", i,
> +					pqueue->s.need_free);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[type_err	] :%d\r\n", i,
> +					pqueue->s.type_err);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[shm_full	] :%d\r\n", i,
> +					pqueue->s.shm_full);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[shm_emp	] :%d\r\n", i,
> +					pqueue->s.shm_emp);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[shmretry_err ] :%d\r\n", i,
> +					pqueue->s.shmretry_err);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[shmqueue_noinit] :%d\r\n",
> +					i, pqueue->s.shmqueue_noinit);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[dma_busy	] :%d\r\n", i,
> +					pqueue->s.dma_busy);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[dma_mapping_err] :%d\r\n",
> +					i, pqueue->s.dma_mapping_err);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[dma_failed	] :%d\r\n", i,
> +					pqueue->s.dma_failed);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[dma_burst	] :%d\r\n", i,
> +					pqueue->s.dma_burst);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[lbk_cnt	] :%d\r\n", i,
> +					pqueue->s.lbk_cnt);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[dma_need_offset] :%d\r\n",
> +					i, pqueue->s.dma_need_offset);
> +			len += sprintf(buf + len,
> +					"QUEUE[%d]--[lbk_txerr	] :%d\r\n", i,
> +					pqueue->s.lbk_txerr);
> +		}
> +	}
> +
> +	len += sprintf(buf + len, "=============BSPVETH STATIS===========\r\n");
> +	len += sprintf(buf + len,
> +				"[bspveth_dev]:run_dma_rx_task:0x%-8x(%d)\r\n",
> +				g_bspveth_dev.run_dma_rx_task,
> +				g_bspveth_dev.run_dma_rx_task);
> +	len += sprintf(buf + len,
> +				"[bspveth_dev]:run_dma_tx_task:0x%-8x(%d)\r\n",
> +				g_bspveth_dev.run_dma_tx_task,
> +				g_bspveth_dev.run_dma_tx_task);
> +	len += sprintf(buf + len,
> +				"[bspveth_dev]:run_skb_rx_task:0x%-8x(%d)\r\n",
> +				g_bspveth_dev.run_skb_rx_task,
> +				g_bspveth_dev.run_skb_rx_task);
> +	len += sprintf(buf + len,
> +				"[bspveth_dev]:run_skb_fr_task:0x%-8x(%d)\r\n",
> +				g_bspveth_dev.run_skb_fr_task,
> +				g_bspveth_dev.run_skb_fr_task);
> +	len += sprintf(buf + len,
> +				"[bspveth_dev]:recv_int	     :0x%-8x(%d)\r\n",
> +				g_bspveth_dev.recv_int, g_bspveth_dev.recv_int);
> +	len += sprintf(buf + len,
> +				"[bspveth_dev]:tobmc_int      :0x%-8x(%d)\r\n",
> +				g_bspveth_dev.tobmc_int,
> +				g_bspveth_dev.tobmc_int);
> +	len += sprintf(buf + len,
> +				"[bspveth_dev]:shutdown_cnt   :0x%-8x(%d)\r\n",
> +				g_bspveth_dev.shutdown_cnt,
> +				g_bspveth_dev.shutdown_cnt);
> +
> +	return len;
> +}
> +
> +module_param_call(statistics, NULL, veth_param_get_statics, &debug, 0444);
> +
> +MODULE_PARM_DESC(statistics, "Statistics info of veth driver,readonly");

That is a horrible abuse of module parameters!

I stopped reviewing here.

  Andrew
