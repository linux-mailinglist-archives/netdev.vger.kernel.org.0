Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97EE86DCD42
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 00:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjDJWGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 18:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjDJWGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 18:06:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17ED1BCE
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 15:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681164342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JDZhCwGo8x3+STKd4yRTec3uFmFqrpXKNILuRc0wVDM=;
        b=L2sIAFvAT2baJMBezUrXufrgAO7Gld3mBBpT7P0G43ThXFJcfKCkjnBCYHt/112M4jeJM7
        KC9roqaxIZMMwnJPUcilnXwBR1BQy/GLuKHvqWU9ncZe5AXB8qdYxlqWPd/fUeG2TB/KhZ
        ro5ll54sLtjvQGmHmXkffzhJsRhUqZs=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-S5-TWaqGNA-A1URwUoeG_g-1; Mon, 10 Apr 2023 18:05:40 -0400
X-MC-Unique: S5-TWaqGNA-A1URwUoeG_g-1
Received: by mail-io1-f70.google.com with SMTP id i141-20020a6b3b93000000b00758a1ed99c2so4530176ioa.1
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 15:05:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681164340; x=1683756340;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JDZhCwGo8x3+STKd4yRTec3uFmFqrpXKNILuRc0wVDM=;
        b=ET/8eqX8FaPCVzgH3hSl0GyyMktK1K2HMs4gbOmNDwseeWHORw/9UYe3l2pJOHJL5q
         Pqd3sPzAkasxLXIi9eNFl4VXz7LYmqSZ3Zaui4dh5gflUqFdisl3plX62V+FsJh3fJkO
         RKT2B5jDnJLbIHuHgqAy+hkAaJc+ovRBwQjnZg29BLdvy/d+uAAYCDq2IuF1NdHsmen4
         tjLIRrpuLMshu1nRLOLBzXStMHnh5gwDxM9T5ePLFS3tQI+esAZrWejsDthvvIDun6a4
         3KRsyfWe3zLHlM947KoY4c1vb0XoZTNs7byxAvM+pg1gq8yjdR1UkgBXwL0fWG1boxu/
         fnVQ==
X-Gm-Message-State: AAQBX9cUTY+1eSmW1cSRiBdoVylaZjVAhJxWmf+c2Nz0o43AWpthymWc
        UciVUQc08KOL8dfCGPGsHYKZuahiQewlouOZy/P9A5r9x2N8eMffLcdsv1VxNxEISMSy0VyY61D
        BqYr+TC6pPQJ3JRTn
X-Received: by 2002:a92:c501:0:b0:325:b96e:6709 with SMTP id r1-20020a92c501000000b00325b96e6709mr7822959ilg.11.1681164340168;
        Mon, 10 Apr 2023 15:05:40 -0700 (PDT)
X-Google-Smtp-Source: AKy350burg5KwX4O3ylWYs3MtOi8+a2A1RmfQ6dzHFH5uBLbtKPI0Hz4QDU2gr9Ku4MRNPG7lzR+ww==
X-Received: by 2002:a92:c501:0:b0:325:b96e:6709 with SMTP id r1-20020a92c501000000b00325b96e6709mr7822931ilg.11.1681164339894;
        Mon, 10 Apr 2023 15:05:39 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z12-20020a921a4c000000b003157b2c504bsm3174969ill.24.2023.04.10.15.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 15:05:39 -0700 (PDT)
Date:   Mon, 10 Apr 2023 16:05:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>, <simon.horman@corigine.com>
Subject: Re: [PATCH v8 vfio 4/7] vfio/pds: Add VFIO live migration support
Message-ID: <20230410160538.35c1a5a6.alex.williamson@redhat.com>
In-Reply-To: <20230404190141.57762-5-brett.creeley@amd.com>
References: <20230404190141.57762-1-brett.creeley@amd.com>
        <20230404190141.57762-5-brett.creeley@amd.com>
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

On Tue, 4 Apr 2023 12:01:38 -0700
Brett Creeley <brett.creeley@amd.com> wrote:
> diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c
> new file mode 100644
> index 000000000000..855f5da9b99a
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/lm.c
> @@ -0,0 +1,479 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
> +
> +#include <linux/anon_inodes.h>
> +#include <linux/file.h>
> +#include <linux/fs.h>
> +#include <linux/highmem.h>
> +#include <linux/vfio.h>
> +#include <linux/vfio_pci_core.h>
> +
> +#include "vfio_dev.h"
> +#include "cmds.h"
> +
> +#define PDS_VFIO_LM_FILENAME	"pds_vfio_lm"
> +
> +const char *
> +pds_vfio_lm_state(enum vfio_device_mig_state state)
> +{
> +	switch (state) {
> +	case VFIO_DEVICE_STATE_ERROR:
> +		return "VFIO_DEVICE_STATE_ERROR";
> +	case VFIO_DEVICE_STATE_STOP:
> +		return "VFIO_DEVICE_STATE_STOP";
> +	case VFIO_DEVICE_STATE_RUNNING:
> +		return "VFIO_DEVICE_STATE_RUNNING";
> +	case VFIO_DEVICE_STATE_STOP_COPY:
> +		return "VFIO_DEVICE_STATE_STOP_COPY";
> +	case VFIO_DEVICE_STATE_RESUMING:
> +		return "VFIO_DEVICE_STATE_RESUMING";
> +	case VFIO_DEVICE_STATE_RUNNING_P2P:
> +		return "VFIO_DEVICE_STATE_RUNNING_P2P";
> +	default:
> +		return "VFIO_DEVICE_STATE_INVALID";
> +	}
> +
> +	return "VFIO_DEVICE_STATE_INVALID";

Seems a tad redundant.

> +}
> +
[snip]
> +struct file *
> +pds_vfio_step_device_state_locked(struct pds_vfio_pci_device *pds_vfio,
> +				  enum vfio_device_mig_state next)
> +{
> +	enum vfio_device_mig_state cur = pds_vfio->state;
> +	struct device *dev = &pds_vfio->pdev->dev;
> +	int err = 0;
> +
> +	dev_dbg(dev, "%s => %s\n",
> +		pds_vfio_lm_state(cur), pds_vfio_lm_state(next));
> +
> +	if (cur == VFIO_DEVICE_STATE_STOP && next == VFIO_DEVICE_STATE_STOP_COPY) {
> +		/* Device is already stopped
> +		 * create save device data file & get device state from firmware
> +		 */

Standard multi-line comment style please, we're not under net/ here.

> +		err = pds_vfio_get_save_file(pds_vfio);
> +		if (err)
> +			return ERR_PTR(err);
> +
> +		/* Get device state */
> +		err = pds_vfio_get_lm_state_cmd(pds_vfio);
> +		if (err) {
> +			pds_vfio_put_save_file(pds_vfio);
> +			return ERR_PTR(err);
> +		}
> +
> +		return pds_vfio->save_file->filep;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_STOP_COPY && next == VFIO_DEVICE_STATE_STOP) {
> +		/* Device is already stopped
> +		 * delete the save device state file
> +		 */
> +		pds_vfio_put_save_file(pds_vfio);
> +		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio,
> +						    PDS_LM_STA_NONE);
> +		return NULL;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_STOP && next == VFIO_DEVICE_STATE_RESUMING) {
> +		/* create resume device data file */
> +		err = pds_vfio_get_restore_file(pds_vfio);
> +		if (err)
> +			return ERR_PTR(err);
> +
> +		return pds_vfio->restore_file->filep;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_RESUMING && next == VFIO_DEVICE_STATE_STOP) {
> +		/* Set device state */
> +		err = pds_vfio_set_lm_state_cmd(pds_vfio);
> +		if (err)
> +			return ERR_PTR(err);
> +
> +		/* delete resume device data file */
> +		pds_vfio_put_restore_file(pds_vfio);
> +		return NULL;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_RUNNING && next == VFIO_DEVICE_STATE_RUNNING_P2P) {
> +		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio, PDS_LM_STA_IN_PROGRESS);
> +		/* Device should be stopped
> +		 * no interrupts, dma or change in internal state
> +		 */
> +		err = pds_vfio_suspend_device_cmd(pds_vfio);
> +		if (err)
> +			return ERR_PTR(err);
> +
> +		return NULL;
> +	}

The comment here, as well as the no-op transitions from STOP->P2P and
P2P->STOP has me concerned whether a device in this suspend state
really meets the definition of our P2P state.  The RUNNING_P2P state is
a quiescent state where the device must accept access, including
peer-to-peer DMA, but it cannot initiate DMA or interrupts.  Is that
consistent with this suspend state?  Thanks,

Alex

> +
> +	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && next == VFIO_DEVICE_STATE_RUNNING) {
> +		/* Device should be functional
> +		 * interrupts, dma, mmio or changes to internal state is allowed
> +		 */
> +		err = pds_vfio_resume_device_cmd(pds_vfio);
> +		if (err)
> +			return ERR_PTR(err);
> +
> +		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio,
> +						    PDS_LM_STA_NONE);
> +		return NULL;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_STOP && next == VFIO_DEVICE_STATE_RUNNING_P2P)
> +		return NULL;
> +
> +	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && next == VFIO_DEVICE_STATE_STOP)
> +		return NULL;
> +
> +	return ERR_PTR(-EINVAL);
> +}

