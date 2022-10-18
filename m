Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4BC4602929
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 12:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiJRKMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 06:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiJRKL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 06:11:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30F5B3B36
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 03:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666087895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1clN6YYSHPELBC6RtYOPG6kuOY0pGGZ/GET+ZIeJc5g=;
        b=KUTUQKVzVqGuo8KrADr4AR6KYvWvt/svN0kb5AckFkGhqY2YV1mn+WaOFzcr+nrxjq2LJ0
        j18KhU6dBbYlnWeu3i0c/t5tvqr9a0jard6f1ORkYrmXGMpQkA2zC/hhupXS39iUc4efOB
        p5dlTkzTbksUQBkGJ640wToKo4Hwca0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-583-oHNza4BgMMeSctt57qlnXQ-1; Tue, 18 Oct 2022 06:11:34 -0400
X-MC-Unique: oHNza4BgMMeSctt57qlnXQ-1
Received: by mail-qt1-f199.google.com with SMTP id fy10-20020a05622a5a0a00b0039cd5097697so9511261qtb.7
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 03:11:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1clN6YYSHPELBC6RtYOPG6kuOY0pGGZ/GET+ZIeJc5g=;
        b=FLcCcCQX5S4nIJiTi6pEk+6C11cTk3jBRGOYQA8EyrW+zReFiA+vkXDKVqAvjTA5q+
         zUbPyTyTYPFxhLksiM6xYNbjbxXPvUhiYX+6g57TeWIgJtwuvrLfe2tYHgNP+sA92Fn8
         LlCtL9/3hf1yJwQoJwjmrW9A/lN0/zZnrYROvTSfaFw38JXqfoZGCB1K7WELd7PPMmRK
         l7MSpLfGznxi2866HStbH0b8o2vkUjK/2E09L/7LKq/1uJE2vbQocFT4Zd2WIbyfq4Tu
         ia3lHDqlnlW3fgJwd0+6eBY3Xw4T/MelMx5vWJEuGOVf1DQmjguVI2uJTjGaYuyxSQHs
         5m2A==
X-Gm-Message-State: ACrzQf0hqxVYQu/AQRry/7/FF8hLA5mwdUyrVWwveSYoj3Jt04phD6HM
        5tkqygucyMfBlPLpP1er5TXFOhcLU5ys5E3NsAQJe8OqI5Lhs5hHUHyQExwJegKWJGHTfHz14Pj
        acR2Jes4fsX+lZhMZ
X-Received: by 2002:ac8:4e89:0:b0:39c:c025:887a with SMTP id 9-20020ac84e89000000b0039cc025887amr1358826qtp.413.1666087893619;
        Tue, 18 Oct 2022 03:11:33 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7DsxJ2DLFs28NjOrMptWxggYK3t40OlJt+7xNu2Q3Vh8+TvT5sEexDPbDkleGi2SqKmGnM2w==
X-Received: by 2002:ac8:4e89:0:b0:39c:c025:887a with SMTP id 9-20020ac84e89000000b0039cc025887amr1358801qtp.413.1666087893270;
        Tue, 18 Oct 2022 03:11:33 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id ch8-20020a05622a40c800b0039cc82a319asm1593863qtb.76.2022.10.18.03.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 03:11:32 -0700 (PDT)
Message-ID: <720519df325384f4bf5d1e51045ecfd402d1d859.camel@redhat.com>
Subject: Re: [Patch v7 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
From:   Paolo Abeni <pabeni@redhat.com>
To:     longli@microsoft.com, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, edumazet@google.com,
        shiraz.saleem@intel.com, Ajay Sharma <sharmaajay@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Date:   Tue, 18 Oct 2022 12:11:28 +0200
In-Reply-To: <1666034441-15424-13-git-send-email-longli@linuxonhyperv.com>
References: <1666034441-15424-1-git-send-email-longli@linuxonhyperv.com>
         <1666034441-15424-13-git-send-email-longli@linuxonhyperv.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-10-17 at 12:20 -0700, longli@linuxonhyperv.com wrote:
> diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
> new file mode 100644
> index 000000000000..57e5f9dca454
> --- /dev/null
> +++ b/drivers/infiniband/hw/mana/main.c

[...]

> +static int mana_gd_destroy_doorbell_page(struct gdma_context *gc,
> +					 int doorbell_page)
> +{
> +	struct gdma_destroy_resource_range_req req = {};
> +	struct gdma_resp_hdr resp = {};
> +	int err;
> +
> +	mana_gd_init_req_hdr(&req.hdr, GDMA_DESTROY_RESOURCE_RANGE,
> +			     sizeof(req), sizeof(resp));
> +
> +	req.resource_type = GDMA_RESOURCE_DOORBELL_PAGE;
> +	req.num_resources = 1;
> +	req.allocated_resources = doorbell_page;
> +
> +	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
> +	if (err || resp.status) {
> +		dev_err(gc->dev,
> +			"Failed to destroy doorbell page: ret %d, 0x%x\n",
> +			err, resp.status);
> +		return err ? err : -EPROTO;

Minor nit: the preferred style is:
		return err ?: -EPROTO;

a few other occurences below.

> +	}
> +
> +	return 0;
> +}

[...]

> +int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct ib_umem *umem,
> +				 mana_handle_t *gdma_region)
> +{
> +	struct gdma_dma_region_add_pages_req *add_req = NULL;
> +	struct gdma_create_dma_region_resp create_resp = {};
> +	struct gdma_create_dma_region_req *create_req;
> +	size_t num_pages_cur, num_pages_to_handle;
> +	unsigned int create_req_msg_size;
> +	struct hw_channel_context *hwc;
> +	struct ib_block_iter biter;
> +	size_t max_pgs_create_cmd;
> +	struct gdma_context *gc;
> +	size_t num_pages_total;
> +	struct gdma_dev *mdev;
> +	unsigned long page_sz;
> +	void *request_buf;
> +	unsigned int i;
> +	int err;
> +
> +	mdev = dev->gdma_dev;
> +	gc = mdev->gdma_context;
> +	hwc = gc->hwc.driver_data;
> +
> +	/* Hardware requires dma region to align to chosen page size */
> +	page_sz = ib_umem_find_best_pgsz(umem, PAGE_SZ_BM, 0);
> +	if (!page_sz) {
> +		ibdev_dbg(&dev->ib_dev, "failed to find page size.\n");
> +		return -ENOMEM;
> +	}
> +	num_pages_total = ib_umem_num_dma_blocks(umem, page_sz);
> +
> +	max_pgs_create_cmd =
> +		(hwc->max_req_msg_size - sizeof(*create_req)) / sizeof(u64);
> +	num_pages_to_handle =
> +		min_t(size_t, num_pages_total, max_pgs_create_cmd);
> +	create_req_msg_size =
> +		struct_size(create_req, page_addr_list, num_pages_to_handle);
> +
> +	request_buf = kzalloc(hwc->max_req_msg_size, GFP_KERNEL);
> +	if (!request_buf)
> +		return -ENOMEM;
> +
> +	create_req = request_buf;
> +	mana_gd_init_req_hdr(&create_req->hdr, GDMA_CREATE_DMA_REGION,
> +			     create_req_msg_size, sizeof(create_resp));
> +
> +	create_req->length = umem->length;
> +	create_req->offset_in_page = umem->address & (page_sz - 1);
> +	create_req->gdma_page_type = order_base_2(page_sz) - PAGE_SHIFT;
> +	create_req->page_count = num_pages_total;
> +	create_req->page_addr_list_len = num_pages_to_handle;
> +
> +	ibdev_dbg(&dev->ib_dev, "size_dma_region %lu num_pages_total %lu\n",
> +		  umem->length, num_pages_total);
> +
> +	ibdev_dbg(&dev->ib_dev, "page_sz %lu offset_in_page %u\n",
> +		  page_sz, create_req->offset_in_page);
> +
> +	ibdev_dbg(&dev->ib_dev, "num_pages_to_handle %lu, gdma_page_type %u",
> +		  num_pages_to_handle, create_req->gdma_page_type);
> +
> +	__rdma_umem_block_iter_start(&biter, umem, page_sz);
> +
> +	for (i = 0; i < num_pages_to_handle; ++i) {
> +		dma_addr_t cur_addr;
> +
> +		__rdma_block_iter_next(&biter);
> +		cur_addr = rdma_block_iter_dma_address(&biter);
> +
> +		create_req->page_addr_list[i] = cur_addr;
> +	}
> +
> +	err = mana_gd_send_request(gc, create_req_msg_size, create_req,
> +				   sizeof(create_resp), &create_resp);
> +	if (err || create_resp.hdr.status) {
> +		ibdev_dbg(&dev->ib_dev,
> +			  "Failed to create DMA region: %d, 0x%x\n", err,
> +			  create_resp.hdr.status);
> +		if (!err)
> +			err = -EPROTO;
> +
> +		kfree(request_buf);
> +		return err;

Minor nit: you can avoid a little code doplication replacing the above
2 lines with:
		goto out;

and ...

> +	}
> +
> +	*gdma_region = create_resp.dma_region_handle;
> +	ibdev_dbg(&dev->ib_dev, "Created DMA region with handle 0x%llx\n",
> +		  *gdma_region);
> +
> +	num_pages_cur = num_pages_to_handle;
> +
> +	if (num_pages_cur < num_pages_total) {
> +		unsigned int add_req_msg_size;
> +		size_t max_pgs_add_cmd =
> +			(hwc->max_req_msg_size - sizeof(*add_req)) /
> +			sizeof(u64);
> +
> +		num_pages_to_handle =
> +			min_t(size_t, num_pages_total - num_pages_cur,
> +			      max_pgs_add_cmd);
> +
> +		/* Calculate the max num of pages that will be handled */
> +		add_req_msg_size = struct_size(add_req, page_addr_list,
> +					       num_pages_to_handle);
> +		add_req = request_buf;
> +
> +		while (num_pages_cur < num_pages_total) {
> +			struct gdma_general_resp add_resp = {};
> +			u32 expected_status = 0;
> +
> +			if (num_pages_cur + num_pages_to_handle <
> +			    num_pages_total) {
> +				/* Status indicating more pages are needed */
> +				expected_status = GDMA_STATUS_MORE_ENTRIES;
> +			}
> +
> +			memset(add_req, 0, add_req_msg_size);
> +
> +			mana_gd_init_req_hdr(&add_req->hdr,
> +					     GDMA_DMA_REGION_ADD_PAGES,
> +					     add_req_msg_size,
> +					     sizeof(add_resp));
> +			add_req->dma_region_handle = *gdma_region;
> +			add_req->page_addr_list_len = num_pages_to_handle;
> +
> +			for (i = 0; i < num_pages_to_handle; ++i) {
> +				dma_addr_t cur_addr =
> +					rdma_block_iter_dma_address(&biter);
> +				add_req->page_addr_list[i] = cur_addr;
> +				__rdma_block_iter_next(&biter);
> +
> +				ibdev_dbg(&dev->ib_dev,
> +					  "page_addr_list %lu addr 0x%llx\n",
> +					  num_pages_cur + i, cur_addr);
> +			}
> +
> +			err = mana_gd_send_request(gc, add_req_msg_size,
> +						   add_req, sizeof(add_resp),
> +						   &add_resp);
> +			if (err || add_resp.hdr.status != expected_status) {
> +				ibdev_dbg(&dev->ib_dev,
> +					  "Failed put DMA pages %u: %d,0x%x\n",
> +					  i, err, add_resp.hdr.status);
> +				err = -EPROTO;
> +				break;
> +			}
> +
> +			num_pages_cur += num_pages_to_handle;
> +			num_pages_to_handle =
> +				min_t(size_t, num_pages_total - num_pages_cur,
> +				      max_pgs_add_cmd);
> +			add_req_msg_size = sizeof(*add_req) +
> +					   num_pages_to_handle * sizeof(u64);
> +		}
> +	}
> +
> +	kfree(request_buf);
> +
> +	if (err)
> +		mana_ib_gd_destroy_dma_region(dev, create_resp.dma_region_handle);

... here:

	if (err)
		mana_ib_gd_destroy_dma_region(dev, create_resp.dma_region_handle);

out:
	kfree(request_buf);

> +
> +	return err;
> +}

[...]

> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
> new file mode 100644
> index 000000000000..fec7d4a06ace
> --- /dev/null
> +++ b/drivers/infiniband/hw/mana/qp.c
> @@ -0,0 +1,505 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2022, Microsoft Corporation. All rights reserved.
> + */
> +
> +#include "mana_ib.h"
> +
> +static int mana_ib_cfg_vport_steering(struct mana_ib_dev *dev,
> +				      struct net_device *ndev,
> +				      mana_handle_t default_rxobj,
> +				      mana_handle_t ind_table[],
> +				      u32 log_ind_tbl_size, u32 rx_hash_key_len,
> +				      u8 *rx_hash_key)
> +{
> +	struct mana_port_context *mpc = netdev_priv(ndev);
> +	struct mana_cfg_rx_steer_req *req = NULL;
> +	struct mana_cfg_rx_steer_resp resp = {};
> +	mana_handle_t *req_indir_tab;
> +	struct gdma_context *gc;
> +	struct gdma_dev *mdev;
> +	u32 req_buf_size;
> +	int i, err;
> +
> +	mdev = dev->gdma_dev;
> +	gc = mdev->gdma_context;
> +
> +	req_buf_size =
> +		sizeof(*req) + sizeof(mana_handle_t) * MANA_INDIRECT_TABLE_SIZE;
> +	req = kzalloc(req_buf_size, GFP_KERNEL);
> +	if (!req)
> +		return -ENOMEM;
> +
> +	mana_gd_init_req_hdr(&req->hdr, MANA_CONFIG_VPORT_RX, req_buf_size,
> +			     sizeof(resp));
> +
> +	req->vport = mpc->port_handle;
> +	req->rx_enable = 1;
> +	req->update_default_rxobj = 1;
> +	req->default_rxobj = default_rxobj;
> +	req->hdr.dev_id = mdev->dev_id;
> +
> +	/* If there are more than 1 entries in indirection table, enable RSS */
> +	if (log_ind_tbl_size)
> +		req->rss_enable = true;
> +
> +	req->num_indir_entries = MANA_INDIRECT_TABLE_SIZE;
> +	req->indir_tab_offset = sizeof(*req);
> +	req->update_indir_tab = true;
> +
> +	req_indir_tab = (mana_handle_t *)(req + 1);
> +	/* The ind table passed to the hardware must have
> +	 * MANA_INDIRECT_TABLE_SIZE entries. Adjust the verb
> +	 * ind_table to MANA_INDIRECT_TABLE_SIZE if required
> +	 */
> +	ibdev_dbg(&dev->ib_dev, "ind table size %u\n", 1 << log_ind_tbl_size);
> +	for (i = 0; i < MANA_INDIRECT_TABLE_SIZE; i++) {
> +		req_indir_tab[i] = ind_table[i % (1 << log_ind_tbl_size)];
> +		ibdev_dbg(&dev->ib_dev, "index %u handle 0x%llx\n", i,
> +			  req_indir_tab[i]);
> +	}
> +
> +	req->update_hashkey = true;
> +	if (rx_hash_key_len)
> +		memcpy(req->hashkey, rx_hash_key, rx_hash_key_len);
> +	else
> +		netdev_rss_key_fill(req->hashkey, MANA_HASH_KEY_SIZE);
> +
> +	ibdev_dbg(&dev->ib_dev, "vport handle %llu default_rxobj 0x%llx\n",
> +		  req->vport, default_rxobj);
> +
> +	err = mana_gd_send_request(gc, req_buf_size, req, sizeof(resp), &resp);
> +	if (err) {
> +		netdev_err(ndev, "Failed to configure vPort RX: %d\n", err);
> +		goto out;
> +	}
> +
> +	if (resp.hdr.status) {
> +		netdev_err(ndev, "vPort RX configuration failed: 0x%x\n",
> +			   resp.hdr.status);
> +		err = -EPROTO;

This is confusing: if this error condition is reached, both error and
succesful configuration will be logged. I guess an additional:

		goto out;

is needed.

> +	}
> +
> +	netdev_info(ndev, "Configured steering vPort %llu log_entries %u\n",
> +		    mpc->port_handle, log_ind_tbl_size);
> +
> +out:
> +	kfree(req);
> +	return err;
> +}
> +
> +static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
> +				 struct ib_qp_init_attr *attr,
> +				 struct ib_udata *udata)
> +{
> +	struct mana_ib_qp *qp = container_of(ibqp, struct mana_ib_qp, ibqp);
> +	struct mana_ib_dev *mdev =
> +		container_of(pd->device, struct mana_ib_dev, ib_dev);
> +	struct ib_rwq_ind_table *ind_tbl = attr->rwq_ind_tbl;
> +	struct mana_ib_create_qp_rss_resp resp = {};
> +	struct mana_ib_create_qp_rss ucmd = {};
> +	struct gdma_dev *gd = mdev->gdma_dev;
> +	mana_handle_t *mana_ind_table;
> +	struct mana_port_context *mpc;
> +	struct mana_context *mc;
> +	struct net_device *ndev;
> +	struct mana_ib_cq *cq;
> +	struct mana_ib_wq *wq;
> +	unsigned int ind_tbl_size;
> +	struct ib_cq *ibcq;
> +	struct ib_wq *ibwq;
> +	u32 port;
> +	int ret;
> +	int i;

This causes a build warning with clang:

../drivers/infiniband/hw/mana/qp.c:172:6: warning: variable 'i' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
        if (!mana_ind_table) {
            ^~~~~~~~~~~~~~~
../drivers/infiniband/hw/mana/qp.c:241:9: note: uninitialized use occurs here
        while (i-- > 0) {
               ^
../drivers/infiniband/hw/mana/qp.c:172:2: note: remove the 'if' if its condition is always false
        if (!mana_ind_table) {
        ^~~~~~~~~~~~~~~~~~~~~~
../drivers/infiniband/hw/mana/qp.c:113:7: note: initialize the variable 'i' to silence this warning
        int i;



> +
> +	mc = gd->driver_data;
> +
> +	if (!udata || udata->inlen < sizeof(ucmd))
> +		return -EINVAL;
> +
> +	ret = ib_copy_from_udata(&ucmd, udata, min(sizeof(ucmd), udata->inlen));
> +	if (ret) {
> +		ibdev_dbg(&mdev->ib_dev,
> +			  "Failed copy from udata for create rss-qp, err %d\n",
> +			  ret);
> +		return -EFAULT;
> +	}
> +
> +	if (attr->cap.max_recv_wr > MAX_SEND_BUFFERS_PER_QUEUE) {
> +		ibdev_dbg(&mdev->ib_dev,
> +			  "Requested max_recv_wr %d exceeding limit\n",
> +			  attr->cap.max_recv_wr);
> +		return -EINVAL;
> +	}
> +
> +	if (attr->cap.max_recv_sge > MAX_RX_WQE_SGL_ENTRIES) {
> +		ibdev_dbg(&mdev->ib_dev,
> +			  "Requested max_recv_sge %d exceeding limit\n",
> +			  attr->cap.max_recv_sge);
> +		return -EINVAL;
> +	}
> +
> +	ind_tbl_size = 1 << ind_tbl->log_ind_tbl_size;
> +	if (ind_tbl_size > MANA_INDIRECT_TABLE_SIZE) {
> +		ibdev_dbg(&mdev->ib_dev,
> +			  "Indirect table size %d exceeding limit\n",
> +			  ind_tbl_size);
> +		return -EINVAL;
> +	}
> +
> +	if (ucmd.rx_hash_function != MANA_IB_RX_HASH_FUNC_TOEPLITZ) {
> +		ibdev_dbg(&mdev->ib_dev,
> +			  "RX Hash function is not supported, %d\n",
> +			  ucmd.rx_hash_function);
> +		return -EINVAL;
> +	}
> +
> +	/* IB ports start with 1, MANA start with 0 */
> +	port = ucmd.port;
> +	if (port < 1 || port > mc->num_ports) {
> +		ibdev_dbg(&mdev->ib_dev, "Invalid port %u in creating qp\n",
> +			  port);
> +		return -EINVAL;
> +	}
> +	ndev = mc->ports[port - 1];
> +	mpc = netdev_priv(ndev);
> +
> +	ibdev_dbg(&mdev->ib_dev, "rx_hash_function %d port %d\n",
> +		  ucmd.rx_hash_function, port);
> +
> +	mana_ind_table = kcalloc(ind_tbl_size, sizeof(mana_handle_t),
> +				 GFP_KERNEL);
> +	if (!mana_ind_table) {
> +		ret = -ENOMEM;
> +		goto fail;
> +	}
> +
> +	qp->port = port;
> +
> +	for (i = 0; i < ind_tbl_size; i++) {
> +		struct mana_obj_spec wq_spec = {};
> +		struct mana_obj_spec cq_spec = {};
> +
> +		ibwq = ind_tbl->ind_tbl[i];
> +		wq = container_of(ibwq, struct mana_ib_wq, ibwq);
> +
> +		ibcq = ibwq->cq;
> +		cq = container_of(ibcq, struct mana_ib_cq, ibcq);
> +
> +		wq_spec.gdma_region = wq->gdma_region;
> +		wq_spec.queue_size = wq->wq_buf_size;
> +
> +		cq_spec.gdma_region = cq->gdma_region;
> +		cq_spec.queue_size = cq->cqe * COMP_ENTRY_SIZE;
> +		cq_spec.modr_ctx_id = 0;
> +		cq_spec.attached_eq = GDMA_CQ_NO_EQ;
> +
> +		ret = mana_create_wq_obj(mpc, mpc->port_handle, GDMA_RQ,
> +					 &wq_spec, &cq_spec, &wq->rx_object);
> +		if (ret)
> +			goto fail;
> +
> +		/* The GDMA regions are now owned by the WQ object */
> +		wq->gdma_region = GDMA_INVALID_DMA_REGION;
> +		cq->gdma_region = GDMA_INVALID_DMA_REGION;
> +
> +		wq->id = wq_spec.queue_index;
> +		cq->id = cq_spec.queue_index;
> +
> +		ibdev_dbg(&mdev->ib_dev,
> +			  "ret %d rx_object 0x%llx wq id %llu cq id %llu\n",
> +			  ret, wq->rx_object, wq->id, cq->id);
> +
> +		resp.entries[i].cqid = cq->id;
> +		resp.entries[i].wqid = wq->id;
> +
> +		mana_ind_table[i] = wq->rx_object;
> +	}
> +	resp.num_entries = i;
> +
> +	ret = mana_ib_cfg_vport_steering(mdev, ndev, wq->rx_object,
> +					 mana_ind_table,
> +					 ind_tbl->log_ind_tbl_size,
> +					 ucmd.rx_hash_key_len,
> +					 ucmd.rx_hash_key);
> +	if (ret)
> +		goto fail;
> +
> +	ret = ib_copy_to_udata(udata, &resp, sizeof(resp));
> +	if (ret) {
> +		ibdev_dbg(&mdev->ib_dev,
> +			  "Failed to copy to udata create rss-qp, %d\n",
> +			  ret);
> +		goto fail;
> +	}
> +
> +	kfree(mana_ind_table);
> +
> +	return 0;
> +
> +fail:
> +	while (i-- > 0) {
> +		ibwq = ind_tbl->ind_tbl[i];
> +		wq = container_of(ibwq, struct mana_ib_wq, ibwq);
> +		mana_destroy_wq_obj(mpc, GDMA_RQ, wq->rx_object);
> +	}
> +
> +	kfree(mana_ind_table);
> +
> +	return ret;
> +}


Cheers,

Paolo

