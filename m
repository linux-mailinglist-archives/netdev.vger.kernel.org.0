Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 906845ABB4
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 16:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbfF2OPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 10:15:00 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:11469
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726770AbfF2OO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 10:14:59 -0400
X-IronPort-AV: E=Sophos;i="5.63,431,1557180000"; 
   d="scan'208";a="311871666"
Received: from abo-12-105-68.mrs.modulonet.fr (HELO hadrien) ([85.68.105.12])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jun 2019 16:14:55 +0200
Date:   Sat, 29 Jun 2019 16:14:55 +0200 (CEST)
From:   Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To:     csully@google.com
cc:     netdev@vger.kernel.org, Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>, kbuild-all@01.org
Subject: Re: [PATCH net-next v3 2/4] gve: Add transmit and receive support
 (fwd)
Message-ID: <alpine.DEB.2.21.1906291613450.2577@hadrien>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please check on line 124.

julia

---------- Forwarded message ----------
Date: Sat, 29 Jun 2019 22:06:06 +0800
From: kbuild test robot <lkp@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH net-next v3 2/4] gve: Add transmit and receive support

CC: kbuild-all@01.org
In-Reply-To: <20190628230733.54169-3-csully@google.com>
References: <20190628230733.54169-3-csully@google.com>
TO: Catherine Sullivan <csully@google.com>
CC: netdev@vger.kernel.org
CC: Catherine Sullivan <csully@google.com>, Sagi Shahar <sagis@google.com>, Jon Olson <jonolson@google.com>, Willem de Bruijn <willemb@google.com>, Luigi Rizzo <lrizzo@google.com>

Hi Catherine,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Catherine-Sullivan/gve-Add-basic-driver-framework-for-Compute-Engine-Virtual-NIC/20190629-161725
:::::: branch date: 6 hours ago
:::::: commit date: 6 hours ago

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>

>> drivers/net/ethernet/google/gve/gve_rx.c:124:5-22: WARNING: Unsigned expression compared with zero: rx -> desc . fill_cnt < 0

# https://github.com/0day-ci/linux/commit/85611360970280ba46a1abe708f9d63734f0870c
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 85611360970280ba46a1abe708f9d63734f0870c
vim +124 drivers/net/ethernet/google/gve/gve_rx.c

85611360 Catherine Sullivan 2019-06-28   97
85611360 Catherine Sullivan 2019-06-28   98  static int gve_rx_alloc_ring(struct gve_priv *priv, int idx)
85611360 Catherine Sullivan 2019-06-28   99  {
85611360 Catherine Sullivan 2019-06-28  100  	struct gve_rx_ring *rx = &priv->rx[idx];
85611360 Catherine Sullivan 2019-06-28  101  	struct device *hdev = &priv->pdev->dev;
85611360 Catherine Sullivan 2019-06-28  102  	u32 slots, npages, gve_desc_per_page;
85611360 Catherine Sullivan 2019-06-28  103  	size_t bytes;
85611360 Catherine Sullivan 2019-06-28  104  	int err;
85611360 Catherine Sullivan 2019-06-28  105
85611360 Catherine Sullivan 2019-06-28  106  	netif_dbg(priv, drv, priv->dev, "allocating rx ring\n");
85611360 Catherine Sullivan 2019-06-28  107  	/* Make sure everything is zeroed to start with */
85611360 Catherine Sullivan 2019-06-28  108  	memset(rx, 0, sizeof(*rx));
85611360 Catherine Sullivan 2019-06-28  109
85611360 Catherine Sullivan 2019-06-28  110  	rx->gve = priv;
85611360 Catherine Sullivan 2019-06-28  111  	rx->q_num = idx;
85611360 Catherine Sullivan 2019-06-28  112
85611360 Catherine Sullivan 2019-06-28  113  	slots = priv->rx_pages_per_qpl;
85611360 Catherine Sullivan 2019-06-28  114  	rx->data.mask = slots - 1;
85611360 Catherine Sullivan 2019-06-28  115
85611360 Catherine Sullivan 2019-06-28  116  	/* alloc rx data ring */
85611360 Catherine Sullivan 2019-06-28  117  	bytes = sizeof(*rx->data.data_ring) * slots;
85611360 Catherine Sullivan 2019-06-28  118  	rx->data.data_ring = dma_alloc_coherent(hdev, bytes,
85611360 Catherine Sullivan 2019-06-28  119  						&rx->data.data_bus,
85611360 Catherine Sullivan 2019-06-28  120  						GFP_KERNEL);
85611360 Catherine Sullivan 2019-06-28  121  	if (!rx->data.data_ring)
85611360 Catherine Sullivan 2019-06-28  122  		return -ENOMEM;
85611360 Catherine Sullivan 2019-06-28  123  	rx->desc.fill_cnt = gve_prefill_rx_pages(rx);
85611360 Catherine Sullivan 2019-06-28 @124  	if (rx->desc.fill_cnt < 0) {
85611360 Catherine Sullivan 2019-06-28  125  		rx->desc.fill_cnt = 0;
85611360 Catherine Sullivan 2019-06-28  126  		err = -ENOMEM;
85611360 Catherine Sullivan 2019-06-28  127  		goto abort_with_slots;
85611360 Catherine Sullivan 2019-06-28  128  	}
85611360 Catherine Sullivan 2019-06-28  129  	/* Ensure data ring slots (packet buffers) are visible. */
85611360 Catherine Sullivan 2019-06-28  130  	dma_wmb();
85611360 Catherine Sullivan 2019-06-28  131
85611360 Catherine Sullivan 2019-06-28  132  	/* Alloc gve_queue_resources */
85611360 Catherine Sullivan 2019-06-28  133  	rx->q_resources =
85611360 Catherine Sullivan 2019-06-28  134  		dma_alloc_coherent(hdev,
85611360 Catherine Sullivan 2019-06-28  135  				   sizeof(*rx->q_resources),
85611360 Catherine Sullivan 2019-06-28  136  				   &rx->q_resources_bus,
85611360 Catherine Sullivan 2019-06-28  137  				   GFP_KERNEL);
85611360 Catherine Sullivan 2019-06-28  138  	if (!rx->q_resources) {
85611360 Catherine Sullivan 2019-06-28  139  		err = -ENOMEM;
85611360 Catherine Sullivan 2019-06-28  140  		goto abort_filled;
85611360 Catherine Sullivan 2019-06-28  141  	}
85611360 Catherine Sullivan 2019-06-28  142  	netif_dbg(priv, drv, priv->dev, "rx[%d]->data.data_bus=%lx\n", idx,
85611360 Catherine Sullivan 2019-06-28  143  		  (unsigned long)rx->data.data_bus);
85611360 Catherine Sullivan 2019-06-28  144
85611360 Catherine Sullivan 2019-06-28  145  	/* alloc rx desc ring */
85611360 Catherine Sullivan 2019-06-28  146  	gve_desc_per_page = PAGE_SIZE / sizeof(struct gve_rx_desc);
85611360 Catherine Sullivan 2019-06-28  147  	bytes = sizeof(struct gve_rx_desc) * priv->rx_desc_cnt;
85611360 Catherine Sullivan 2019-06-28  148  	npages = bytes / PAGE_SIZE;
85611360 Catherine Sullivan 2019-06-28  149  	if (npages * PAGE_SIZE != bytes) {
85611360 Catherine Sullivan 2019-06-28  150  		err = -EIO;
85611360 Catherine Sullivan 2019-06-28  151  		goto abort_with_q_resources;
85611360 Catherine Sullivan 2019-06-28  152  	}
85611360 Catherine Sullivan 2019-06-28  153
85611360 Catherine Sullivan 2019-06-28  154  	rx->desc.desc_ring = dma_alloc_coherent(hdev, bytes, &rx->desc.bus,
85611360 Catherine Sullivan 2019-06-28  155  						GFP_KERNEL);
85611360 Catherine Sullivan 2019-06-28  156  	if (!rx->desc.desc_ring) {
85611360 Catherine Sullivan 2019-06-28  157  		err = -ENOMEM;
85611360 Catherine Sullivan 2019-06-28  158  		goto abort_with_q_resources;
85611360 Catherine Sullivan 2019-06-28  159  	}
85611360 Catherine Sullivan 2019-06-28  160  	rx->desc.mask = slots - 1;
85611360 Catherine Sullivan 2019-06-28  161  	rx->desc.cnt = 0;
85611360 Catherine Sullivan 2019-06-28  162  	rx->desc.seqno = 1;
85611360 Catherine Sullivan 2019-06-28  163  	gve_rx_add_to_block(priv, idx);
85611360 Catherine Sullivan 2019-06-28  164
85611360 Catherine Sullivan 2019-06-28  165  	return 0;
85611360 Catherine Sullivan 2019-06-28  166
85611360 Catherine Sullivan 2019-06-28  167  abort_with_q_resources:
85611360 Catherine Sullivan 2019-06-28  168  	dma_free_coherent(hdev, sizeof(*rx->q_resources),
85611360 Catherine Sullivan 2019-06-28  169  			  rx->q_resources, rx->q_resources_bus);
85611360 Catherine Sullivan 2019-06-28  170  	rx->q_resources = NULL;
85611360 Catherine Sullivan 2019-06-28  171  abort_filled:
85611360 Catherine Sullivan 2019-06-28  172  	kfree(rx->data.page_info);
85611360 Catherine Sullivan 2019-06-28  173  abort_with_slots:
85611360 Catherine Sullivan 2019-06-28  174  	bytes = sizeof(*rx->data.data_ring) * slots;
85611360 Catherine Sullivan 2019-06-28  175  	dma_free_coherent(hdev, bytes, rx->data.data_ring, rx->data.data_bus);
85611360 Catherine Sullivan 2019-06-28  176  	rx->data.data_ring = NULL;
85611360 Catherine Sullivan 2019-06-28  177
85611360 Catherine Sullivan 2019-06-28  178  	return err;
85611360 Catherine Sullivan 2019-06-28  179  }
85611360 Catherine Sullivan 2019-06-28  180

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
