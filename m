Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA2A23C788
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 10:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgHEIMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 04:12:48 -0400
Received: from mga05.intel.com ([192.55.52.43]:39677 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727871AbgHEIMq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 04:12:46 -0400
IronPort-SDR: xHBtm1HA7bcU+eooC+BqvXmoPmwQpqI+laV7EjmuVlCqPqBSiXpD/1PBX0Xilc1ebYAen4pMnB
 xQ+w7ta4kxew==
X-IronPort-AV: E=McAfee;i="6000,8403,9703"; a="237350863"
X-IronPort-AV: E=Sophos;i="5.75,436,1589266800"; 
   d="scan'208";a="237350863"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2020 01:12:45 -0700
IronPort-SDR: 4QSMl8T/kxatAOYHl9zTcF9CN17ob74/YGIHvnj02G7zZnkY1Chvgl6U5B7azVSyWfgVGVbLYA
 d2yFsdDpbHXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,436,1589266800"; 
   d="scan'208";a="330861726"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.255.30.121]) ([10.255.30.121])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Aug 2020 01:12:42 -0700
Subject: Re: [PATCH V5 4/6] vhost_vdpa: implement IRQ offloading in vhost_vdpa
To:     Jason Wang <jasowang@redhat.com>, alex.williamson@redhat.com,
        mst@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com
References: <20200731065533.4144-1-lingshan.zhu@intel.com>
 <20200731065533.4144-5-lingshan.zhu@intel.com>
 <4c711720-b4ff-6f09-61cb-2d305daa69c8@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <1aebeab4-6de1-1776-065f-01fb4bafcd79@intel.com>
Date:   Wed, 5 Aug 2020 16:12:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <4c711720-b4ff-6f09-61cb-2d305daa69c8@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/5/2020 4:06 PM, Jason Wang wrote:
>
> On 2020/7/31 下午2:55, Zhu Lingshan wrote:
>> +static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
>> +{
>> +    struct vhost_virtqueue *vq = &v->vqs[qid];
>> +    const struct vdpa_config_ops *ops = v->vdpa->config;
>> +    struct vdpa_device *vdpa = v->vdpa;
>> +    int ret, irq;
>> +
>> +    spin_lock(&vq->call_ctx.ctx_lock);
>> +    irq = ops->get_vq_irq(vdpa, qid);
>
>
> Btw, this assumes that get_vq_irq is mandatory. This looks wrong since 
> there's no guarantee that the vDPA device driver can see irq. And this 
> break vdpa simulator.
>
> Let's add a check and make it optional by document this assumption in 
> the vdpa.h.
fix soon. Thanks!
>
> Thanks
>
>
>> +    if (!vq->call_ctx.ctx || irq < 0) {
>> +        spin_unlock(&vq->call_ctx.ctx_lock);
>> +        return;
>> +    }
>> +
>
