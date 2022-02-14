Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489B04B4219
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 07:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240880AbiBNGsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 01:48:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240879AbiBNGsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 01:48:23 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0335714E
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 22:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644821296; x=1676357296;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FBHMKfFPGo0TGwC6l1DTAiTJrrkHkE8hb1KxLZLpYYc=;
  b=TWPZvvo5lHyk7MIMt4q8yAMp/RCYkE7s3s3NFyUqWdF/9Jq8Dso3+rI6
   ECTdGFJ+khdqwiFUQTOvg8MTY5INCSsN/C9qEGwA4ZgGgYR1ia2BKlJCh
   1UQ+PELTZvOK4eql61s3HUQOyX+dV/TNCxrzS7o4L02MHW99GY/7fdz8U
   qd09dZXsmbSsD1UA+kDyNH5UzHTa96ugR9x1mFjCYOFIIiF9Opywcs1S1
   lVK2TzEHDZSSPPMSn4A+RUZpLQkAu0frisJ2JmMnYK9R8XXqpjCERXJ4o
   EFcbX+X+8N1jX1B7IirMmdgH4AI/pEwGhFoNeV0+51cSeZaKJdT6MTMa6
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="250233846"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="250233846"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 22:48:15 -0800
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="543242491"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.175.112]) ([10.249.175.112])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 22:48:14 -0800
Message-ID: <a882f4d3-fdda-1ee7-d520-7dde0f5508fd@intel.com>
Date:   Mon, 14 Feb 2022 14:48:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.1
Subject: Re: [PATCH V4 3/4] vhost_vdpa: don't setup irq offloading when
 irq_num < 0
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20220203072735.189716-1-lingshan.zhu@intel.com>
 <20220203072735.189716-4-lingshan.zhu@intel.com>
 <850f56f6-870f-deb3-da6a-6df6e238e234@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <850f56f6-870f-deb3-da6a-6df6e238e234@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/14/2022 2:28 PM, Jason Wang wrote:
>
> 在 2022/2/3 下午3:27, Zhu Lingshan 写道:
>> When irq number is negative(e.g., -EINVAL), the virtqueue
>> may be disabled or the virtqueues are sharing a device irq.
>> In such case, we should not setup irq offloading for a virtqueue.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vhost/vdpa.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>> index 851539807bc9..c4fcacb0de3a 100644
>> --- a/drivers/vhost/vdpa.c
>> +++ b/drivers/vhost/vdpa.c
>> @@ -96,6 +96,10 @@ static void vhost_vdpa_setup_vq_irq(struct 
>> vhost_vdpa *v, u16 qid)
>>       if (!ops->get_vq_irq)
>>           return;
>>   +    irq = ops->get_vq_irq(vdpa, qid);
>> +    if (irq < 0)
>> +        return;
>> +
>>       irq = ops->get_vq_irq(vdpa, qid);
>
>
> So the get_vq_irq() will be called twice?
yes, the latter one should be removed
>
>
>> irq_bypass_unregister_producer(&vq->call_ctx.producer);
>>       if (!vq->call_ctx.ctx || irq < 0)
>
>
> We're already checked irq against 0 here.
sure, will remove this

Thanks!
>
>
> Thanks
>
>

