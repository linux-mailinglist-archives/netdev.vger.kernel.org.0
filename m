Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5FE26DCD5A
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 00:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjDJWPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 18:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjDJWPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 18:15:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E28131
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 15:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681164905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VDd3HjoS8oa69sUdzA2zyCnS0oqks4NjlLJ/OnIvYgA=;
        b=d/GxpU2rAGIWlwlktdqiqs8iuc1S/aI0tRw6xkuCNZDdy+yRXON9Ik1oEJQBqgSbfwmtYh
        vFSNqkYhc2tt7sxOA0JAYR/oDE2QIYSL8lXBQeYjzh0/rMnaz5uIfe3ekmtTrFNd0jGQwt
        Arz5TyMEuN1nHG0Q56r2YeYRwRhG+v8=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-8I9nbbHNMKyMt4UrA5xOIg-1; Mon, 10 Apr 2023 18:15:04 -0400
X-MC-Unique: 8I9nbbHNMKyMt4UrA5xOIg-1
Received: by mail-il1-f198.google.com with SMTP id z13-20020a056e02088d00b00326098d01d9so945051ils.2
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 15:15:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681164903; x=1683756903;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VDd3HjoS8oa69sUdzA2zyCnS0oqks4NjlLJ/OnIvYgA=;
        b=ACoDxQxZBKTkTOkx4n6DPIOEOneHemyxUo0zHIQFOYa9Ukw7+ai05Hlf0qjtOIIwWv
         PzytnA7khiqJokeuC95i9yu3BeTU4BVusqdY6M9j2jGVKTwdx1aQmZzY7NSgWgrKKr7a
         qk0Rhxjvhyie3TJbToc4neSxWcsOCRM7TF8NC+E+1zs4kI18t9+Cwy0QTlykyydQKu4/
         VZhsJmwUhI2Azb8LHA4Cv12BZlBJ1B6kVbfQf5pShOk04S9ynMZmyeOQTNl7DLu+p3jx
         e5x8cCt8HgyA11IA4YVQFPOeISSNmlr1Bq53ElTJ9Av93PY8NHvRfhEaFdMS9O1LNEGg
         k+2Q==
X-Gm-Message-State: AAQBX9cTbcWpvo5xjN9s+rna38bfJXpGJKiLSUpdeQas6BCzocTX7thJ
        0qjTFNZ0a0tSUy7gusutGYLHrpvpbZiXdUBMBs5uihsx5jW1H2MEjEb+GsPo67gq2VzuGQQLcxN
        69ySz/m8w2BkgQoni
X-Received: by 2002:a92:d081:0:b0:328:8a35:83b6 with SMTP id h1-20020a92d081000000b003288a3583b6mr5118052ilh.8.1681164903292;
        Mon, 10 Apr 2023 15:15:03 -0700 (PDT)
X-Google-Smtp-Source: AKy350ac5qzdi1O0DqPK3I0OiMETvi/H5VHAqWwvBHQm3WPQnIyNP5+oYR3o5uXzQLR0OvIkqz2IRw==
X-Received: by 2002:a92:d081:0:b0:328:8a35:83b6 with SMTP id h1-20020a92d081000000b003288a3583b6mr5118041ilh.8.1681164903005;
        Mon, 10 Apr 2023 15:15:03 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c19-20020a056e020bd300b0032722299321sm3117332ilu.21.2023.04.10.15.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 15:15:02 -0700 (PDT)
Date:   Mon, 10 Apr 2023 16:15:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>, <simon.horman@corigine.com>
Subject: Re: [PATCH v8 vfio 5/7] vfio/pds: Add support for dirty page
 tracking
Message-ID: <20230410161501.0a22bfa6.alex.williamson@redhat.com>
In-Reply-To: <20230404190141.57762-6-brett.creeley@amd.com>
References: <20230404190141.57762-1-brett.creeley@amd.com>
        <20230404190141.57762-6-brett.creeley@amd.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Apr 2023 12:01:39 -0700
Brett Creeley <brett.creeley@amd.com> wrote:
> +static int
> +pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
> +		      struct rb_root_cached *ranges, u32 nnodes,
> +		      u64 *page_size)
> +{
> +	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
> +	u64 region_start, region_size, region_page_size;
> +	struct pds_lm_dirty_region_info *region_info;
> +	struct interval_tree_node *node = NULL;
> +	struct pci_dev *pdev = pds_vfio->pdev;
> +	u8 max_regions = 0, num_regions;
> +	dma_addr_t regions_dma = 0;
> +	u32 num_ranges = nnodes;
> +	u32 page_count;
> +	u16 len;
> +	int err;
> +
> +	dev_dbg(&pdev->dev, "vf%u: Start dirty page tracking\n", pds_vfio->vf_id);
> +
> +	if (pds_vfio_dirty_is_enabled(pds_vfio))
> +		return -EINVAL;
> +
> +	pds_vfio_dirty_set_enabled(pds_vfio);
> +
> +	/* find if dirty tracking is disabled, i.e. num_regions == 0 */
> +	err = pds_vfio_dirty_status_cmd(pds_vfio, 0, &max_regions, &num_regions);
> +	if (num_regions) {
> +		dev_err(&pdev->dev, "Dirty tracking already enabled for %d regions\n",
> +			num_regions);
> +		err = -EEXIST;
> +		goto err_out;
> +	} else if (!max_regions) {
> +		dev_err(&pdev->dev, "Device doesn't support dirty tracking, max_regions %d\n",
> +			max_regions);
> +		err = -EOPNOTSUPP;
> +		goto err_out;
> +	} else if (err) {
> +		dev_err(&pdev->dev, "Failed to get dirty status, err %pe\n",
> +			ERR_PTR(err));
> +		goto err_out;
> +	}
> +
> +	/* Only support 1 region for now. If there are any large gaps in the
> +	 * VM's address regions, then this would be a waste of memory as we are
> +	 * generating 2 bitmaps (ack/seq) from the min address to the max
> +	 * address of the VM's address regions. In the future, if we support
> +	 * more than one region in the device/driver we can split the bitmaps
> +	 * on the largest address region gaps. We can do this split up to the
> +	 * max_regions times returned from the dirty_status command.
> +	 */

Large gaps in a VM are very possible, particularly after QEMU has
relocated RAM above 4GB to above the reserved hypertransport range on
AMD systems.  Thanks,

Alex

> +	max_regions = 1;
> +	if (num_ranges > max_regions) {
> +		vfio_combine_iova_ranges(ranges, nnodes, max_regions);
> +		num_ranges = max_regions;
> +	}
> +
> +	node = interval_tree_iter_first(ranges, 0, ULONG_MAX);
> +	if (!node) {
> +		err = -EINVAL;
> +		goto err_out;
> +	}
> +
> +	region_size = node->last - node->start + 1;
> +	region_start = node->start;
> +	region_page_size = *page_size;
> +
> +	len = sizeof(*region_info);
> +	region_info = kzalloc(len, GFP_KERNEL);
> +	if (!region_info) {
> +		err = -ENOMEM;
> +		goto err_out;
> +	}
> +
> +	page_count = DIV_ROUND_UP(region_size, region_page_size);
> +
> +	region_info->dma_base = cpu_to_le64(region_start);
> +	region_info->page_count = cpu_to_le32(page_count);
> +	region_info->page_size_log2 = ilog2(region_page_size);
> +
> +	regions_dma = dma_map_single(pds_vfio->coredev, (void *)region_info, len,
> +				     DMA_BIDIRECTIONAL);
> +	if (dma_mapping_error(pds_vfio->coredev, regions_dma)) {
> +		err = -ENOMEM;
> +		kfree(region_info);
> +		goto err_out;
> +	}
> +
> +	err = pds_vfio_dirty_enable_cmd(pds_vfio, regions_dma, max_regions);
> +	dma_unmap_single(pds_vfio->coredev, regions_dma, len, DMA_BIDIRECTIONAL);
> +	/* page_count might be adjusted by the device,
> +	 * update it before freeing region_info DMA
> +	 */
> +	page_count = le32_to_cpu(region_info->page_count);
> +
> +	dev_dbg(&pdev->dev, "region_info: regions_dma 0x%llx dma_base 0x%llx page_count %u page_size_log2 %u\n",
> +		regions_dma, region_start, page_count, (u8)ilog2(region_page_size));
> +
> +	kfree(region_info);
> +	if (err)
> +		goto err_out;
> +
> +	err = pds_vfio_dirty_alloc_bitmaps(dirty, page_count);
> +	if (err) {
> +		dev_err(&pdev->dev, "Failed to alloc dirty bitmaps: %pe\n",
> +			ERR_PTR(err));
> +		goto err_out;
> +	}
> +
> +	err = pds_vfio_dirty_alloc_sgl(pds_vfio, page_count);
> +	if (err) {
> +		dev_err(&pdev->dev, "Failed to alloc dirty sg lists: %pe\n",
> +			ERR_PTR(err));
> +		goto err_free_bitmaps;
> +	}
> +
> +	dirty->region_start = region_start;
> +	dirty->region_size = region_size;
> +	dirty->region_page_size = region_page_size;
> +
> +	pds_vfio_print_guest_region_info(pds_vfio, max_regions);
> +
> +	return 0;
> +
> +err_free_bitmaps:
> +	pds_vfio_dirty_free_bitmaps(dirty);
> +err_out:
> +	pds_vfio_dirty_set_disabled(pds_vfio);
> +	return err;
> +}

