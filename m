Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF39184E65
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 19:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgCMSLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 14:11:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgCMSLp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 14:11:45 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94B1E20674;
        Fri, 13 Mar 2020 18:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584123104;
        bh=jSnU0TivW+/8sZmyT9xuh9B6MQuT94qtujzAV/0xo4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zb51OB2VHFlBHejoQXM0VvIGWwCkGxmR3lp9dBaRONzJA4B5hgS7pmzkW4aGsNz6X
         x16hVbLEqJGfiKAHIZ1HvcDc/x/JgsqDBQZsE83vpd7yd+HRF5GIjfS/GJ8we1/Ix2
         tne5UUofa+R6CP/CetPwBe7PO1E5bb/m4a/L4t40=
Date:   Fri, 13 Mar 2020 20:11:39 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH v2 net-next 3/7] octeontx2-vf: Virtual function driver
 support
Message-ID: <20200313181139.GC67638@unreal>
References: <1584092566-4793-1-git-send-email-sunil.kovvuri@gmail.com>
 <1584092566-4793-4-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584092566-4793-4-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 03:12:42PM +0530, sunil.kovvuri@gmail.com wrote:
> From: Tomasz Duszynski <tduszynski@marvell.com>
>
> On OcteonTx2 silicon there two two types VFs, VFs that share the
> physical link with their parent SR-IOV PF and the VFs which work
> in pairs using internal HW loopback channels (LBK). Except for the
> underlying Rx/Tx channel mapping from netdev functionality perspective
> they are almost identical. This patch adds netdev driver support
> for these VFs.
>
> Unlike it's parent PF a VF cannot directly communicate with admin
> function (AF) and it has to go through PF for the same. The mailbox
> communication with AF works like 'VF <=> PF <=> AF'.
>
> Also functionality wise VF and PF are identical, hence to avoid code
> duplication PF driver's APIs are resued here for HW initialization,
> packet handling etc etc ie almost everything. For VF driver to compile
> as module exported few of the existing PF driver APIs.
>
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> Signed-off-by: Tomasz Duszynski <tduszynski@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/Kconfig     |   6 +
>  .../net/ethernet/marvell/octeontx2/nic/Makefile    |   2 +
>  .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  14 +
>  .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   9 +
>  .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  11 +-
>  .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |  13 +
>  .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |   1 +
>  .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   | 659 +++++++++++++++++++++
>  8 files changed, 714 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/Kconfig b/drivers/net/ethernet/marvell/octeontx2/Kconfig
> index ced514c..d9dfb61 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/Kconfig
> +++ b/drivers/net/ethernet/marvell/octeontx2/Kconfig
> @@ -33,3 +33,9 @@ config OCTEONTX2_PF
>  	depends on PCI
>  	help
>  	  This driver supports Marvell's OcteonTX2 NIC physical function.
> +
> +config OCTEONTX2_VF
> +	tristate "Marvell OcteonTX2 NIC Virtual Function driver"
> +	depends on OCTEONTX2_PF
> +	help
> +	  This driver supports Marvell's OcteonTX2 NIC virtual function.
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
> index 41bf00c..778df33 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
> @@ -4,7 +4,9 @@
>  #
>
>  obj-$(CONFIG_OCTEONTX2_PF) += octeontx2_nicpf.o
> +obj-$(CONFIG_OCTEONTX2_VF) += octeontx2_nicvf.o
>
>  octeontx2_nicpf-y := otx2_pf.o otx2_common.o otx2_txrx.o otx2_ethtool.o
> +octeontx2_nicvf-y := otx2_vf.o
>
>  ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index 157735443..70d97c7 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -128,6 +128,7 @@ void otx2_get_stats64(struct net_device *netdev,
>  	stats->tx_packets = dev_stats->tx_frames;
>  	stats->tx_dropped = dev_stats->tx_drops;
>  }
> +EXPORT_SYMBOL(otx2_get_stats64);
>
>  /* Sync MAC address with RVU AF */
>  static int otx2_hw_set_mac_addr(struct otx2_nic *pfvf, u8 *mac)
> @@ -197,6 +198,7 @@ int otx2_set_mac_address(struct net_device *netdev, void *p)
>
>  	return 0;
>  }
> +EXPORT_SYMBOL(otx2_set_mac_address);
>
>  int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu)
>  {
> @@ -225,6 +227,9 @@ int otx2_config_pause_frm(struct otx2_nic *pfvf)
>  	struct cgx_pause_frm_cfg *req;
>  	int err;
>
> +	if (is_otx2_lbkvf(pfvf->pdev))
> +		return 0;
> +
>  	otx2_mbox_lock(&pfvf->mbox);
>  	req = otx2_mbox_alloc_msg_cgx_cfg_pause_frm(&pfvf->mbox);
>  	if (!req) {
> @@ -416,6 +421,7 @@ void otx2_tx_timeout(struct net_device *netdev, unsigned int txq)
>
>  	schedule_work(&pfvf->reset_task);
>  }
> +EXPORT_SYMBOL(otx2_tx_timeout);
>
>  void otx2_get_mac_from_af(struct net_device *netdev)
>  {
> @@ -430,6 +436,7 @@ void otx2_get_mac_from_af(struct net_device *netdev)
>  	if (!is_valid_ether_addr(netdev->dev_addr))
>  		eth_hw_addr_random(netdev);
>  }
> +EXPORT_SYMBOL(otx2_get_mac_from_af);
>
>  static int otx2_get_link(struct otx2_nic *pfvf)
>  {
> @@ -1263,6 +1270,7 @@ int otx2_detach_resources(struct mbox *mbox)
>  	otx2_mbox_unlock(mbox);
>  	return 0;
>  }
> +EXPORT_SYMBOL(otx2_detach_resources);
>
>  int otx2_attach_npa_nix(struct otx2_nic *pfvf)
>  {
> @@ -1319,6 +1327,7 @@ int otx2_attach_npa_nix(struct otx2_nic *pfvf)
>
>  	return 0;
>  }
> +EXPORT_SYMBOL(otx2_attach_npa_nix);
>
>  void otx2_ctx_disable(struct mbox *mbox, int type, bool npa)
>  {
> @@ -1387,6 +1396,7 @@ void mbox_handler_nix_txsch_alloc(struct otx2_nic *pf,
>  			pf->hw.txschq_list[lvl][schq] =
>  				rsp->schq_list[lvl][schq];
>  }
> +EXPORT_SYMBOL(mbox_handler_nix_txsch_alloc);
>
>  void mbox_handler_npa_lf_alloc(struct otx2_nic *pfvf,
>  			       struct npa_lf_alloc_rsp *rsp)
> @@ -1394,6 +1404,7 @@ void mbox_handler_npa_lf_alloc(struct otx2_nic *pfvf,
>  	pfvf->hw.stack_pg_ptrs = rsp->stack_pg_ptrs;
>  	pfvf->hw.stack_pg_bytes = rsp->stack_pg_bytes;
>  }
> +EXPORT_SYMBOL(mbox_handler_npa_lf_alloc);
>
>  void mbox_handler_nix_lf_alloc(struct otx2_nic *pfvf,
>  			       struct nix_lf_alloc_rsp *rsp)
> @@ -1404,6 +1415,7 @@ void mbox_handler_nix_lf_alloc(struct otx2_nic *pfvf,
>  	pfvf->hw.lso_tsov4_idx = rsp->lso_tsov4_idx;
>  	pfvf->hw.lso_tsov6_idx = rsp->lso_tsov6_idx;
>  }
> +EXPORT_SYMBOL(mbox_handler_nix_lf_alloc);
>
>  void mbox_handler_msix_offset(struct otx2_nic *pfvf,
>  			      struct msix_offset_rsp *rsp)
> @@ -1411,6 +1423,7 @@ void mbox_handler_msix_offset(struct otx2_nic *pfvf,
>  	pfvf->hw.npa_msixoff = rsp->npa_msixoff;
>  	pfvf->hw.nix_msixoff = rsp->nix_msixoff;
>  }
> +EXPORT_SYMBOL(mbox_handler_msix_offset);
>
>  void mbox_handler_nix_bp_enable(struct otx2_nic *pfvf,
>  				struct nix_bp_cfg_rsp *rsp)
> @@ -1422,6 +1435,7 @@ void mbox_handler_nix_bp_enable(struct otx2_nic *pfvf,
>  		pfvf->bpid[chan_id] = rsp->chan_bpid[chan] & 0x3FF;
>  	}
>  }
> +EXPORT_SYMBOL(mbox_handler_nix_bp_enable);
>
>  void otx2_free_cints(struct otx2_nic *pfvf, int n)
>  {
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> index c0a9693..ca757b2 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> @@ -20,6 +20,8 @@
>
>  /* PCI device IDs */
>  #define PCI_DEVID_OCTEONTX2_RVU_PF              0xA063
> +#define PCI_DEVID_OCTEONTX2_RVU_VF		0xA064
> +#define PCI_DEVID_OCTEONTX2_RVU_AFVF		0xA0F8
>
>  #define PCI_SUBSYS_DEVID_96XX_RVU_PFVF		0xB200
>
> @@ -242,6 +244,11 @@ struct otx2_nic {
>  	int			nix_blkaddr;
>  };
>
> +static inline bool is_otx2_lbkvf(struct pci_dev *pdev)
> +{
> +	return pdev->device == PCI_DEVID_OCTEONTX2_RVU_AFVF;
> +}
> +
>  static inline bool is_96xx_A0(struct pci_dev *pdev)
>  {
>  	return (pdev->revision == 0x00) &&
> @@ -627,6 +634,8 @@ void otx2_set_ethtool_ops(struct net_device *netdev);
>
>  int otx2_open(struct net_device *netdev);
>  int otx2_stop(struct net_device *netdev);
> +int otx2vf_open(struct net_device *netdev);
> +int otx2vf_stop(struct net_device *netdev);
>  int otx2_set_real_num_queues(struct net_device *netdev,
>  			     int tx_queues, int rx_queues);
>  #endif /* OTX2_COMMON_H */
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> index bf6e2529..89644d5 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> @@ -1088,6 +1088,7 @@ int otx2_set_real_num_queues(struct net_device *netdev,
>  			   "Failed to set no of Rx queues: %d\n", rx_queues);
>  	return err;
>  }
> +EXPORT_SYMBOL(otx2_set_real_num_queues);
>
>  static irqreturn_t otx2_q_intr_handler(int irq, void *data)
>  {
> @@ -1523,6 +1524,9 @@ int otx2_open(struct net_device *netdev)
>  	if (pf->linfo.link_up && !(pf->pcifunc & RVU_PFVF_FUNC_MASK))
>  		otx2_handle_link_event(pf);
>
> +	/* Restore pause frame settings */
> +	otx2_config_pause_frm(pf);
> +
>  	err = otx2_rxtx_enable(pf, true);
>  	if (err)
>  		goto err_free_cints;
> @@ -1546,6 +1550,7 @@ int otx2_open(struct net_device *netdev)
>  	kfree(qset->napi);
>  	return err;
>  }
> +EXPORT_SYMBOL(otx2_open);
>
>  int otx2_stop(struct net_device *netdev)
>  {
> @@ -1606,6 +1611,7 @@ int otx2_stop(struct net_device *netdev)
>  	       sizeof(*qset) - offsetof(struct otx2_qset, sqe_cnt));
>  	return 0;
>  }
> +EXPORT_SYMBOL(otx2_stop);
>
>  static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
>  {
> @@ -1734,7 +1740,6 @@ static int otx2_realloc_msix_vectors(struct otx2_nic *pf)
>
>  	otx2_disable_mbox_intr(pf);
>  	pci_free_irq_vectors(hw->pdev);
> -	pci_free_irq_vectors(hw->pdev);
>  	err = pci_alloc_irq_vectors(hw->pdev, num_vec, num_vec, PCI_IRQ_MSIX);
>  	if (err < 0) {
>  		dev_err(pf->dev, "%s: Failed to realloc %d IRQ vectors\n",
> @@ -1901,6 +1906,10 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	/* Enable link notifications */
>  	otx2_cgx_config_linkevents(pf, true);
>
> +	/* Enable pause frames by default */
> +	pf->flags |= OTX2_FLAG_RX_PAUSE_ENABLED;
> +	pf->flags |= OTX2_FLAG_TX_PAUSE_ENABLED;
> +
>  	return 0;
>
>  err_detach_rsrc:
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
> index 7963d41..867f646 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
> @@ -45,6 +45,19 @@
>  #define RVU_PF_MSIX_VECX_CTL(a)             (0x008 | (a) << 4)
>  #define RVU_PF_MSIX_PBAX(a)                 (0xF0000 | (a) << 3)
>
> +/* RVU VF registers */
> +#define	RVU_VF_VFPF_MBOX0		    (0x00000)
> +#define	RVU_VF_VFPF_MBOX1		    (0x00008)
> +#define	RVU_VF_VFPF_MBOXX(a)		    (0x00 | (a) << 3)
> +#define	RVU_VF_INT			    (0x20)
> +#define	RVU_VF_INT_W1S			    (0x28)
> +#define	RVU_VF_INT_ENA_W1S		    (0x30)
> +#define	RVU_VF_INT_ENA_W1C		    (0x38)
> +#define	RVU_VF_BLOCK_ADDRX_DISC(a)	    (0x200 | (a) << 3)
> +#define	RVU_VF_MSIX_VECX_ADDR(a)	    (0x000 | (a) << 4)
> +#define	RVU_VF_MSIX_VECX_CTL(a)		    (0x008 | (a) << 4)
> +#define	RVU_VF_MSIX_PBAX(a)		    (0xF0000 | (a) << 3)
> +
>  #define RVU_FUNC_BLKADDR_SHIFT		20
>  #define RVU_FUNC_BLKADDR_MASK		0x1FULL
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> index bef4c20..1865f16 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> @@ -778,6 +778,7 @@ bool otx2_sq_append_skb(struct net_device *netdev, struct otx2_snd_queue *sq,
>
>  	return true;
>  }
> +EXPORT_SYMBOL(otx2_sq_append_skb);
>
>  void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
>  {
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> new file mode 100644
> index 0000000..cf366dc
> --- /dev/null
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> @@ -0,0 +1,659 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Marvell OcteonTx2 RVU Virtual Function ethernet driver
> + *
> + * Copyright (C) 2020 Marvell International Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */

Please don't add license text, the SPDX line is enough.

> +
> +#include <linux/etherdevice.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +
> +#include "otx2_common.h"
> +#include "otx2_reg.h"
> +
> +#define DRV_NAME	"octeontx2-nicvf"
> +#define DRV_STRING	"Marvell OcteonTX2 NIC Virtual Function Driver"
> +
> +static const struct pci_device_id otx2_vf_id_table[] = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_RVU_AFVF) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_RVU_VF) },
> +	{ }
> +};
> +
> +MODULE_AUTHOR("Sunil Goutham <sgoutham@marvell.com>");
> +MODULE_DESCRIPTION(DRV_STRING);
> +MODULE_LICENSE("GPL v2");
> +MODULE_DEVICE_TABLE(pci, otx2_vf_id_table);
> +
> +/* RVU VF Interrupt Vector Enumeration */
> +enum {
> +	RVU_VF_INT_VEC_MBOX = 0x0,
> +};
> +
> +static int otx2vf_change_mtu(struct net_device *netdev, int new_mtu)
> +{
> +	bool if_up = netif_running(netdev);
> +	int err = 0;
> +
> +	if (if_up)
> +		otx2vf_stop(netdev);
> +
> +	netdev_info(netdev, "Changing MTU from %d to %d\n",
> +		    netdev->mtu, new_mtu);
> +	netdev->mtu = new_mtu;
> +
> +	if (if_up)
> +		err = otx2vf_open(netdev);
> +
> +	return err;
> +}
> +
> +static void otx2vf_process_vfaf_mbox_msg(struct otx2_nic *vf,
> +					 struct mbox_msghdr *msg)
> +{
> +	if (msg->id >= MBOX_MSG_MAX) {
> +		dev_err(vf->dev,
> +			"Mbox msg with unknown ID %d\n", msg->id);
> +		return;
> +	}
> +
> +	if (msg->sig != OTX2_MBOX_RSP_SIG) {
> +		dev_err(vf->dev,
> +			"Mbox msg with wrong signature %x, ID %d\n",
> +			msg->sig, msg->id);
> +		return;
> +	}
> +
> +	if (msg->rc == MBOX_MSG_INVALID) {
> +		dev_err(vf->dev,
> +			"PF/AF says the sent msg(s) %d were invalid\n",
> +			msg->id);
> +		return;
> +	}
> +
> +	switch (msg->id) {
> +	case MBOX_MSG_READY:
> +		vf->pcifunc = msg->pcifunc;
> +		break;
> +	case MBOX_MSG_MSIX_OFFSET:
> +		mbox_handler_msix_offset(vf, (struct msix_offset_rsp *)msg);
> +		break;
> +	case MBOX_MSG_NPA_LF_ALLOC:
> +		mbox_handler_npa_lf_alloc(vf, (struct npa_lf_alloc_rsp *)msg);
> +		break;
> +	case MBOX_MSG_NIX_LF_ALLOC:
> +		mbox_handler_nix_lf_alloc(vf, (struct nix_lf_alloc_rsp *)msg);
> +		break;
> +	case MBOX_MSG_NIX_TXSCH_ALLOC:
> +		mbox_handler_nix_txsch_alloc(vf,
> +					     (struct nix_txsch_alloc_rsp *)msg);
> +		break;
> +	case MBOX_MSG_NIX_BP_ENABLE:
> +		mbox_handler_nix_bp_enable(vf, (struct nix_bp_cfg_rsp *)msg);
> +		break;
> +	default:
> +		if (msg->rc)
> +			dev_err(vf->dev,
> +				"Mbox msg response has err %d, ID %d\n",
> +				msg->rc, msg->id);
> +	}
> +}
> +
> +static void otx2vf_vfaf_mbox_handler(struct work_struct *work)
> +{
> +	struct otx2_mbox_dev *mdev;
> +	struct mbox_hdr *rsp_hdr;
> +	struct mbox_msghdr *msg;
> +	struct otx2_mbox *mbox;
> +	struct mbox *af_mbox;
> +	int offset, id;
> +
> +	af_mbox = container_of(work, struct mbox, mbox_wrk);
> +	mbox = &af_mbox->mbox;
> +	mdev = &mbox->dev[0];
> +	rsp_hdr = (struct mbox_hdr *)(mdev->mbase + mbox->rx_start);
> +	if (af_mbox->num_msgs == 0)
> +		return;
> +	offset = mbox->rx_start + ALIGN(sizeof(*rsp_hdr), MBOX_MSG_ALIGN);
> +
> +	for (id = 0; id < af_mbox->num_msgs; id++) {
> +		msg = (struct mbox_msghdr *)(mdev->mbase + offset);
> +		otx2vf_process_vfaf_mbox_msg(af_mbox->pfvf, msg);
> +		offset = mbox->rx_start + msg->next_msgoff;
> +		mdev->msgs_acked++;
> +	}
> +
> +	otx2_mbox_reset(mbox, 0);
> +}
> +
> +static int otx2vf_process_mbox_msg_up(struct otx2_nic *vf,
> +				      struct mbox_msghdr *req)
> +{
> +	/* Check if valid, if not reply with a invalid msg */
> +	if (req->sig != OTX2_MBOX_REQ_SIG) {
> +		otx2_reply_invalid_msg(&vf->mbox.mbox_up, 0, 0, req->id);
> +		return -ENODEV;
> +	}
> +
> +	switch (req->id) {
> +#define M(_name, _id, _fn_name, _req_type, _rsp_type)			\
> +	case _id: {							\
> +		struct _rsp_type *rsp;					\
> +		int err;						\
> +									\
> +		rsp = (struct _rsp_type *)otx2_mbox_alloc_msg(		\
> +			&vf->mbox.mbox_up, 0,				\
> +			sizeof(struct _rsp_type));			\
> +		if (!rsp)						\
> +			return -ENOMEM;					\
> +									\
> +		rsp->hdr.id = _id;					\
> +		rsp->hdr.sig = OTX2_MBOX_RSP_SIG;			\
> +		rsp->hdr.pcifunc = 0;					\
> +		rsp->hdr.rc = 0;					\
> +									\
> +		err = otx2_mbox_up_handler_ ## _fn_name(		\
> +			vf, (struct _req_type *)req, rsp);		\
> +		return err;						\
> +	}
> +MBOX_UP_CGX_MESSAGES
> +#undef M

"return ..." inside macro which is called by another macro is highly
discouraged by the Linux kernel coding style.

Thanks
