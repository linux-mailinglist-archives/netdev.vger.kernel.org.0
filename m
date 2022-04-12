Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCB14FDA94
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 12:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354254AbiDLH7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 03:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352958AbiDLHOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 03:14:41 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D3B326C3
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 23:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649746531; x=1681282531;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dNuzupcsdiCrltG7y+ecXDHzYTJCC5YfKzyqOEkYIas=;
  b=GmDX+EACIC7lEbp1eCd5nOo6IaQW9DZT7OfvzngA4OEwJtDcOgNACT2x
   ubFjmF8TT+llw400RE8vMxXelTm2SFLLqx3dhuJefpN2+xtb/6dVlz+fV
   1f3qzGUiY8CDJCHmHxKX01XAFvHO17npk7aLdfQfJsCG1gVTw+89j3ROQ
   I9PEN/HECpSsZ/00hAWWgNOUbMRKNLYUn4hyhU9TrMKPvAKxY8/l4mEbC
   8ZN/KDOAUTlnGO/zykFh5IXHuIkcWLdTRak/Cv9oRiIOdTwYXDQO1gywa
   jax+jbISU1wftW+NHtaOMmsPON88NvYW0i11qSKaLH8avLAppjypk/llF
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10314"; a="244176288"
X-IronPort-AV: E=Sophos;i="5.90,253,1643702400"; 
   d="scan'208";a="244176288"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 23:55:31 -0700
X-IronPort-AV: E=Sophos;i="5.90,253,1643702400"; 
   d="scan'208";a="572617263"
Received: from zhoufuro-mobl.ccr.corp.intel.com (HELO [10.249.171.224]) ([10.249.171.224])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 23:55:29 -0700
Message-ID: <b24c4e3d-2792-da43-3335-5ed83c557565@linux.intel.com>
Date:   Tue, 12 Apr 2022 14:55:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] vDPA/ifcvf: allow userspace to suspend a queue
Content-Language: en-US
To:     Zhu Lingshan <lingshan.zhu@intel.com>, jasowang@redhat.com,
        mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20220411031057.162485-1-lingshan.zhu@intel.com>
From:   Zhou Furong <furong.zhou@linux.intel.com>
In-Reply-To: <20220411031057.162485-1-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> +bool ifcvf_get_vq_ready(struct ifcvf_hw *hw, u16 qid)
> +{
> +	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
> +	bool queue_enable;
> +
> +	vp_iowrite16(qid, &cfg->queue_select);
> +	queue_enable = vp_ioread16(&cfg->queue_enable);
> +
> +	return (bool)queue_enable;
queue_enable is bool, why cast? looks like remove the variable is better.
return vp_ioread16(&cfg->queue_enable);

>   static bool ifcvf_vdpa_get_vq_ready(struct vdpa_device *vdpa_dev, u16 qid)
>   {
>   	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
> +	bool ready;
>   
> -	return vf->vring[qid].ready;
> +	ready = ifcvf_get_vq_ready(vf, qid);
> +
> +	return ready;
remove ready looks better
return ifcvf_get_vq_ready(vf, qid);


Best regards,
Furong
