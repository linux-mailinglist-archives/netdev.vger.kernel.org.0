Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EACD722877D
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbgGURgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:36:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728931AbgGURgj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 13:36:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B70D206C1;
        Tue, 21 Jul 2020 17:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595352998;
        bh=4BBfmkH7vsUW2m+P1swz2DmOP2Nwl3fEXcNaMTLyyqE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2shaQLMviMvMjuF6sKzDqfTgDyxGNWWHDr5qdgarFgfo6brSlzw+G107SUjBaSh6s
         JQEAI8dv2zN2MWuyyhO8wHII3xK3ADFGWKqPzaXKyMaMYfPy6xie/PAkfNlayw3f0P
         McOzzNRTz9wgI9HrdQzekq/ffvJHgB6kgm4vJ9Tw=
Date:   Tue, 21 Jul 2020 10:36:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Alice Michael <alice.michael@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: Re: [net-next v4 02/15] iecm: Add framework set of header files
Message-ID: <20200721103636.6d1054b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200721003810.2770559-3-anthony.l.nguyen@intel.com>
References: <20200721003810.2770559-1-anthony.l.nguyen@intel.com>
        <20200721003810.2770559-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Jul 2020 17:37:57 -0700 Tony Nguyen wrote:
> diff --git a/include/linux/net/intel/iecm_alloc.h b/include/linux/net/intel/iecm_alloc.h
> new file mode 100644
> index 000000000000..fd13bf085663
> --- /dev/null
> +++ b/include/linux/net/intel/iecm_alloc.h
> @@ -0,0 +1,29 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (c) 2020, Intel Corporation. */
> +
> +#ifndef _IECM_ALLOC_H_
> +#define _IECM_ALLOC_H_
> +
> +/* Memory types */
> +enum iecm_memset_type {
> +	IECM_NONDMA_MEM = 0,
> +	IECM_DMA_MEM
> +};
> +
> +/* Memcpy types */
> +enum iecm_memcpy_type {
> +	IECM_NONDMA_TO_NONDMA = 0,
> +	IECM_NONDMA_TO_DMA,
> +	IECM_DMA_TO_DMA,
> +	IECM_DMA_TO_NONDMA
> +};

These enums are never used. Please remove all dead code in the submission.
(Unused HW interface defines are okay.)

> diff --git a/include/linux/net/intel/iecm.h b/include/linux/net/intel/iecm.h
> new file mode 100644
> index 000000000000..ef6e4d79f51f
> --- /dev/null
> +++ b/include/linux/net/intel/iecm.h
> @@ -0,0 +1,430 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/* Copyright (C) 2020 Intel Corporation */
> +
> +#ifndef _IECM_H_
> +#define _IECM_H_
> +
> +#include <linux/aer.h>
> +#include <linux/bitmap.h>
> +#include <linux/compiler.h>
> +#include <linux/cpumask.h>
> +#include <linux/delay.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/errno.h>
> +#include <linux/etherdevice.h>
> +#include <linux/ethtool.h>
> +#include <linux/if_bridge.h>
> +#include <linux/if_vlan.h>
> +#include <linux/interrupt.h>
> +#include <linux/ip.h>
> +#include <linux/ipv6.h>
> +#include <linux/jiffies.h>
> +#include <linux/kernel.h>
> +#include <linux/log2.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/netdevice.h>
> +#include <linux/pci.h>
> +#include <linux/pkt_sched.h>
> +#include <linux/rtnetlink.h>
> +#include <linux/sctp.h>
> +#include <linux/skbuff.h>
> +#include <linux/string.h>
> +#include <linux/timer.h>
> +#include <linux/types.h>
> +#include <linux/workqueue.h>
> +#include <net/tcp.h>
> +#include <net/ipv6.h>
> +#include <net/ip6_checksum.h>
> +#include <linux/prefetch.h>
> +#include <net/pkt_sched.h>
> +
> +#include <net/gre.h>
> +#include <net/udp_tunnel.h>
> +#include <linux/avf/virtchnl.h>
> +
> +#include <linux/net/intel/iecm_osdep.h>
> +#include <linux/net/intel/iecm_controlq_api.h>
> +#include <linux/net/intel/iecm_lan_txrx.h>
> +
> +#include <linux/net/intel/iecm_txrx.h>
> +#include <linux/net/intel/iecm_type.h>

Please trim this litany of include files. You don't need most of them.

> diff --git a/include/linux/net/intel/iecm_osdep.h b/include/linux/net/intel/iecm_osdep.h
> new file mode 100644
> index 000000000000..33e01582f516
> --- /dev/null
> +++ b/include/linux/net/intel/iecm_osdep.h
> @@ -0,0 +1,24 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (c) 2020, Intel Corporation. */
> +
> +#ifndef _IECM_OSDEP_H_
> +#define _IECM_OSDEP_H_

OS abstraction layers are not allowed in Linux drivers. Please rename
this to something meaningful or marge the contents to appropriate
headers and remove this one.

> +#include <linux/bitops.h>
> +#include <linux/delay.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/net/intel/iecm_alloc.h>

None of these headers are required here. Yet you fail to include io.h..

> +#define wr32(a, reg, value)	writel((value), ((a)->hw_addr + (reg)))
> +#define rd32(a, reg)		readl((a)->hw_addr + (reg))
> +#define wr64(a, reg, value)	writeq((value), ((a)->hw_addr + (reg)))
> +#define rd64(a, reg)		readq((a)->hw_addr + (reg))
> +
> +struct iecm_dma_mem {
> +	void *va;
> +	dma_addr_t pa;
> +	size_t size;
> +};
> +
> +#define iecm_wmb() wmb() /* memory barrier */

Please remove this define and use wmb() directly.

> +#endif /* _IECM_OSDEP_H_ */

> diff --git a/include/linux/net/intel/iecm_controlq.h b/include/linux/net/intel/iecm_controlq.h
> new file mode 100644
> index 000000000000..4cba637042cd
> --- /dev/null
> +++ b/include/linux/net/intel/iecm_controlq.h
> @@ -0,0 +1,95 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (c) 2020, Intel Corporation. */
> +
> +#ifndef _IECM_CONTROLQ_H_
> +#define _IECM_CONTROLQ_H_
> +
> +#include <linux/net/intel/iecm_controlq_api.h>
> +
> +/* Maximum buffer lengths for all control queue types */
> +#define IECM_CTLQ_MAX_RING_SIZE	1024
> +#define IECM_CTLQ_MAX_BUF_LEN	4096
> +
> +#define IECM_CTLQ_DESC(R, i) \
> +	(&(((struct iecm_ctlq_desc *)((R)->desc_ring.va))[i]))
> +
> +#define IECM_CTLQ_DESC_UNUSED(R) \
> +	(u16)((((R)->next_to_clean > (R)->next_to_use) ? 0 : (R)->ring_size) + \
> +	      (R)->next_to_clean - (R)->next_to_use - 1)
> +
> +/* Data type manipulation macros. */
> +#define IECM_HI_DWORD(x)	((u32)((((x) >> 16) >> 16) & 0xFFFFFFFF))
> +#define IECM_LO_DWORD(x)	((u32)((x) & 0xFFFFFFFF))

Please use lower_32_bits() / upper_32_bits() directly.

> +#define IECM_HI_WORD(x)		((u16)(((x) >> 16) & 0xFFFF))
> +#define IECM_LO_WORD(x)		((u16)((x) & 0xFFFF))

unused

