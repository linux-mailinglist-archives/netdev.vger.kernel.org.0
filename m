Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9C0BF79C
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 19:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfIZRaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 13:30:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727502AbfIZRaw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 13:30:52 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 166F3222C3;
        Thu, 26 Sep 2019 17:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569519050;
        bh=VwP2kBjbEOi8h2i1GPYvMLlTvvzbXQOV5p6AjraPfTg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=foNOLmEZ0Tmv8XceGJDCCOdaTxSGA8qw5tMunjHkfWp6iUNCgG9t7fYBVM/qF6gpC
         vo1H7lfkeCaTwQg3mVNyCMB93Vu9pIs8twYXaeV4Ta9adwzWzpMjusdTYhMYOsDGHu
         uE5fVsBP53iRDqMnj1J5YmH1EbWl1Coy4nnFaaI8=
Date:   Thu, 26 Sep 2019 20:30:46 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     dledford@redhat.com, jgg@mellanox.com, gregkh@linuxfoundation.org,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [RFC 04/20] RDMA/irdma: Add driver framework definitions
Message-ID: <20190926173046.GB14368@unreal>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-5-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926164519.10471-5-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 09:45:03AM -0700, Jeff Kirsher wrote:
> From: Mustafa Ismail <mustafa.ismail@intel.com>
>
> Register irdma as a platform driver capable of supporting platform
> devices from multi-generation RDMA capable Intel HW. Establish the
> interface with all supported netdev peer devices and initialize HW.
>
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>  drivers/infiniband/hw/irdma/i40iw_if.c | 270 +++++++++++
>  drivers/infiniband/hw/irdma/irdma_if.c | 436 +++++++++++++++++
>  drivers/infiniband/hw/irdma/main.c     | 531 ++++++++++++++++++++
>  drivers/infiniband/hw/irdma/main.h     | 639 +++++++++++++++++++++++++
>  4 files changed, 1876 insertions(+)
>  create mode 100644 drivers/infiniband/hw/irdma/i40iw_if.c
>  create mode 100644 drivers/infiniband/hw/irdma/irdma_if.c
>  create mode 100644 drivers/infiniband/hw/irdma/main.c
>  create mode 100644 drivers/infiniband/hw/irdma/main.h
>
> diff --git a/drivers/infiniband/hw/irdma/i40iw_if.c b/drivers/infiniband/hw/irdma/i40iw_if.c
> new file mode 100644
> index 000000000000..3cddb091acfb
> --- /dev/null
> +++ b/drivers/infiniband/hw/irdma/i40iw_if.c
> @@ -0,0 +1,270 @@
> +// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
> +/* Copyright (c) 2019, Intel Corporation. */
> +
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/netdevice.h>
> +#include <linux/etherdevice.h>
> +#include <net/addrconf.h>
> +#include "main.h"
> +#include "i40iw_hw.h"
> +#include <linux/net/intel/i40e_client.h>
> +
> +/**
> + * i40iw_request_reset - Request a reset
> + * @rf: RDMA PCI function
> + *
> + */
> +void i40iw_request_reset(struct irdma_pci_f *rf)
> +{
> +	struct i40e_info *ldev = (struct i40e_info *)rf->ldev.if_ldev;
> +
> +	ldev->ops->request_reset(ldev, rf->ldev.if_client, 1);
> +}
> +
> +/**
> + * i40iw_open - client interface operation open for iwarp/uda device
> + * @ldev: LAN device information
> + * @client: iwarp client information, provided during registration
> + *
> + * Called by the LAN driver during the processing of client register
> + * Create device resources, set up queues, pble and hmc objects and
> + * register the device with the ib verbs interface
> + * Return 0 if successful, otherwise return error
> + */
> +static int i40iw_open(struct i40e_info *ldev, struct i40e_client *client)
> +{
> +	struct irdma_l2params l2params = {};
> +	struct irdma_device *iwdev = NULL;
> +	struct irdma_handler *hdl = NULL;
> +	struct irdma_priv_ldev *pldev;
> +	u16 last_qset = IRDMA_NO_QSET;
> +	struct irdma_sc_dev *dev;
> +	struct irdma_pci_f *rf;
> +	int err_code = -EIO;
> +	u16 qset;
> +	int i;
> +
> +	hdl = irdma_find_handler(ldev->pcidev);
> +	if (hdl)
> +		return 0;
> +
> +	hdl = kzalloc((sizeof(*hdl) + sizeof(*iwdev)), GFP_KERNEL);
> +	if (!hdl)
> +		return -ENOMEM;
> +
> +	iwdev = (struct irdma_device *)((u8 *)hdl + sizeof(*hdl));
> +
> +	iwdev->param_wq = alloc_ordered_workqueue("l2params", WQ_MEM_RECLAIM);
> +	if (!iwdev->param_wq)
> +		goto error;
> +
> +	rf = &hdl->rf;
> +	rf->hdl = hdl;
> +	dev = &rf->sc_dev;
> +	dev->back_dev = rf;
> +	rf->rdma_ver = IRDMA_GEN_1;
> +	hdl->platform_dev = ldev->platform_dev;
> +	irdma_init_rf_config_params(rf);
> +	rf->init_hw = i40iw_init_hw;
> +	rf->hw.hw_addr = ldev->hw_addr;
> +	rf->pdev = ldev->pcidev;
> +	rf->netdev = ldev->netdev;
> +	dev->pci_rev = rf->pdev->revision;
> +	iwdev->rf = rf;
> +	iwdev->hdl = hdl;
> +	iwdev->ldev = &rf->ldev;
> +	iwdev->init_state = INITIAL_STATE;
> +	iwdev->rcv_wnd = IRDMA_CM_DEFAULT_RCV_WND_SCALED;
> +	iwdev->rcv_wscale = IRDMA_CM_DEFAULT_RCV_WND_SCALE;
> +	iwdev->netdev = ldev->netdev;
> +	iwdev->create_ilq = true;
> +	iwdev->vsi_num = 0;
> +
> +	pldev = &rf->ldev;
> +	hdl->ldev = pldev;
> +	pldev->if_client = client;
> +	pldev->if_ldev = ldev;
> +	pldev->fn_num = ldev->fid;
> +	pldev->ftype = ldev->ftype;
> +	pldev->pf_vsi_num = 0;
> +	pldev->msix_count = ldev->msix_count;
> +	pldev->msix_entries = ldev->msix_entries;
> +
> +	if (irdma_ctrl_init_hw(rf))
> +		goto error;
> +
> +	l2params.mtu =
> +		(ldev->params.mtu) ? ldev->params.mtu : IRDMA_DEFAULT_MTU;
> +	for (i = 0; i < I40E_CLIENT_MAX_USER_PRIORITY; i++) {
> +		qset = ldev->params.qos.prio_qos[i].qs_handle;
> +		l2params.up2tc[i] = ldev->params.qos.prio_qos[i].tc;
> +		l2params.qs_handle_list[i] = qset;
> +		if (last_qset == IRDMA_NO_QSET)
> +			last_qset = qset;
> +		else if ((qset != last_qset) && (qset != IRDMA_NO_QSET))
> +			iwdev->dcb = true;
> +	}
> +
> +	if (irdma_rt_init_hw(rf, iwdev, &l2params)) {
> +		irdma_deinit_ctrl_hw(rf);
> +		goto error;
> +	}
> +
> +	irdma_add_handler(hdl);
> +	return 0;
> +error:
> +	kfree(hdl);
> +	return err_code;
> +}
> +
> +/**
> + * i40iw_l2params_worker - worker for l2 params change
> + * @work: work pointer for l2 params
> + */
> +static void i40iw_l2params_worker(struct work_struct *work)
> +{
> +	struct l2params_work *dwork =
> +		container_of(work, struct l2params_work, work);
> +	struct irdma_device *iwdev = dwork->iwdev;
> +
> +	irdma_change_l2params(&iwdev->vsi, &dwork->l2params);
> +	atomic_dec(&iwdev->params_busy);
> +	kfree(work);
> +}
> +
> +/**
> + * i40iw_l2param_change - handle qs handles for QoS and MSS change
> + * @ldev: LAN device information
> + * @client: client for parameter change
> + * @params: new parameters from L2
> + */
> +static void i40iw_l2param_change(struct i40e_info *ldev,
> +				 struct i40e_client *client,
> +				 struct i40e_params *params)
> +{
> +	struct irdma_l2params *l2params;
> +	struct l2params_work *work;
> +	struct irdma_device *iwdev;
> +	struct irdma_handler *hdl;
> +	int i;
> +
> +	hdl = irdma_find_handler(ldev->pcidev);
> +	if (!hdl)
> +		return;
> +
> +	iwdev = (struct irdma_device *)((u8 *)hdl + sizeof(*hdl));
> +
> +	if (atomic_read(&iwdev->params_busy))
> +		return;
> +	work = kzalloc(sizeof(*work), GFP_KERNEL);
> +	if (!work)
> +		return;
> +
> +	atomic_inc(&iwdev->params_busy);

Changing parameters through workqueue and perform locking with atomic_t, exciting.
Please do proper locking scheme and better to avoid workqueue at all.

<...>

> +/* client interface functions */
> +static const struct i40e_client_ops i40e_ops = {
> +	.open = i40iw_open,
> +	.close = i40iw_close,
> +	.l2_param_change = i40iw_l2param_change
> +};
> +
> +static struct i40e_client i40iw_client = {
> +	.name = "irdma",
> +	.ops = &i40e_ops,
> +	.version.major = I40E_CLIENT_VERSION_MAJOR,
> +	.version.minor = I40E_CLIENT_VERSION_MINOR,
> +	.version.build = I40E_CLIENT_VERSION_BUILD,
> +	.type = I40E_CLIENT_IWARP,
> +};
> +
> +int i40iw_probe(struct platform_device *pdev)
> +{
> +	struct i40e_peer_dev_platform_data *pdata =
> +		dev_get_platdata(&pdev->dev);
> +	struct i40e_info *ldev;
> +
> +	if (!pdata)
> +		return -EINVAL;
> +
> +	ldev = pdata->ldev;
> +
> +	if (ldev->version.major != I40E_CLIENT_VERSION_MAJOR ||
> +	    ldev->version.minor != I40E_CLIENT_VERSION_MINOR) {
> +		pr_err("version mismatch:\n");
> +		pr_err("expected major ver %d, caller specified major ver %d\n",
> +		       I40E_CLIENT_VERSION_MAJOR, ldev->version.major);
> +		pr_err("expected minor ver %d, caller specified minor ver %d\n",
> +		       I40E_CLIENT_VERSION_MINOR, ldev->version.minor);
> +		return -EINVAL;
> +	}

This is can't be in upstream code, we don't support out-of-tree modules,
everything else will have proper versions.

Thanks
