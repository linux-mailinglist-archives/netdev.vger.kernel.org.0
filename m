Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E472509E38
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 13:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388705AbiDULIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 07:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388711AbiDULIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 07:08:46 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDA42DAB0
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 04:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650539155; x=1682075155;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Oscv6wV+a8Kca8VZQPYvzxlTm34KSnrqEqNSmCY0Ofo=;
  b=Z55N8huBIfmrHdNrjaalnfWbPDuFLfkKrCuoy/Aww+75o/xMeuSNbgvt
   2+u5jeHDlRFdzj1huw9oGWtahTXarhxKyj2RJyd+p+C0glGePAB6n2v9g
   mLTGR6qD88uyp9tmrUYlqLhXgrp9E96nO+RgKdtiKPy7WVVGsNqEdvY+r
   7GhdjNUMO54a73V7CuqUGMZmU8hzH79RxAMnaGsG5XTKmgiaMQ72D9yUp
   xU34wjLOQGEe2N52tt0cc1JtdzAc+Tr4nMROlBD18uNcudgqPM4IMJm+w
   7X5W/UtwvOFsOUERUJvyCL7TeU9/3VNd/GpC3W39qM5jeJsEEetS8bbTI
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="246212652"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="246212652"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 04:05:54 -0700
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="577166329"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.168.77]) ([10.249.168.77])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 04:05:52 -0700
Message-ID: <f224fc38-327c-6dac-d2cb-93f8b4ac5b82@intel.com>
Date:   Thu, 21 Apr 2022 19:05:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.0
Subject: Re: [PATCH] vDPA/ifcvf: allow userspace to suspend a queue
Content-Language: en-US
To:     Zhou Furong <furong.zhou@linux.intel.com>, jasowang@redhat.com,
        mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20220411031057.162485-1-lingshan.zhu@intel.com>
 <b24c4e3d-2792-da43-3335-5ed83c557565@linux.intel.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <b24c4e3d-2792-da43-3335-5ed83c557565@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/12/2022 2:55 PM, Zhou Furong wrote:
> Hi,
>
>> +bool ifcvf_get_vq_ready(struct ifcvf_hw *hw, u16 qid)
>> +{
>> +    struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
>> +    bool queue_enable;
>> +
>> +    vp_iowrite16(qid, &cfg->queue_select);
>> +    queue_enable = vp_ioread16(&cfg->queue_enable);
>> +
>> +    return (bool)queue_enable;
> queue_enable is bool, why cast? looks like remove the variable is better.
> return vp_ioread16(&cfg->queue_enable);
Hi, thanks for your comments. This cast tries to make some static 
checkers happy.
Please correct me if I misunderstood it:
vp_ioread16() returns an u16, and bool is not an one bit variable, it is 
C99 _Bool.
C99 defines _Bool to be true(expends to int 1) or false(expends to int 0).
I think this implies a bool is actually capable to store an u16.
so I am afraid some checkers may complain about "queue_enable = 
vp_ioread16(&cfg->queue_enable);",
a cast here can help us silence the checkers.

see http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf section 7.16
and https://www.kernel.org/doc/Documentation/process/coding-style.rst 
section 17

Thanks,
Zhu Lingshan
>
>>   static bool ifcvf_vdpa_get_vq_ready(struct vdpa_device *vdpa_dev, 
>> u16 qid)
>>   {
>>       struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>> +    bool ready;
>>   -    return vf->vring[qid].ready;
>> +    ready = ifcvf_get_vq_ready(vf, qid);
>> +
>> +    return ready;
> remove ready looks better
> return ifcvf_get_vq_ready(vf, qid);
>
>
> Best regards,
> Furong

