Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77ADB6A858F
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 16:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjCBPs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 10:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjCBPs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 10:48:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2565B193D5
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 07:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677772092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=07sLndxtEbNcERZvee6i0lRr3/Y/p7RWfWIjrJTakUw=;
        b=c62yZc5qubV+6pmmtW3Ns8pNWmbm+qjOd/E0rtWlb2Qx7zdQ6khrU9+AKhmVNLihYqogvn
        4NmjMLQyqhdY3n0v9FGyXSGIpmjyfa5lnUV8bgQoG44gxFz1c0hH1yhzQT68wBc/bZwaQQ
        M/IH4vFvTZ9dtE6L9ujLsZwlrxy7L2o=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-393-vdxrwq4HMkSog8PcIPi-7w-1; Thu, 02 Mar 2023 10:48:07 -0500
X-MC-Unique: vdxrwq4HMkSog8PcIPi-7w-1
Received: by mail-wm1-f69.google.com with SMTP id r7-20020a05600c35c700b003eb3f2c4fb4so1259700wmq.6
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 07:48:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677772084;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=07sLndxtEbNcERZvee6i0lRr3/Y/p7RWfWIjrJTakUw=;
        b=W6JGdRsAARPidEHvVYVWTIHID/5gEKSVYUMVp45bN/h5zbVE/mClDPNDcrHCwnfUcL
         z4I3nTsWXdIh3npCvNJp9f47PsOOCrMNi9YH8+0tV/Lt3AdoJqbM6qM4GERGLAMp2l5G
         DTsbHW94NPGdEVoCriZqNqaC3Kb5lnnS6ywbfBSPiObA7VlKFkSDEZexSlb+9j5MtbIv
         fIkLRPchyKuV/F4wfzTqZTrLGnglcPPTlI2bSFiV56giBDnxNwWs2qlztJx2n13WPYvG
         jlKlg75148hk9wpmj+37Zuj0qa5xtPOY6YoiV2zykB/hsNcHwtBMskJVWjrddWRXXbb6
         4/9g==
X-Gm-Message-State: AO0yUKVVvF+UHXgQvfhlt5YkJ/HLjVFZUWJUtWVR9bnbcsKEcCnw6Yox
        iw6zbxkbFA7aRz0P9tExNp+sJBaEJpHazzBX4qD/xyPLGz8rXSrjhsR+sFNtAo97XluTVl6usr7
        IBKQ4vKUW9RqX6IBWy1AGHA==
X-Received: by 2002:a05:6000:1a42:b0:2c3:be89:7c2a with SMTP id t2-20020a0560001a4200b002c3be897c2amr1809004wry.13.1677772084120;
        Thu, 02 Mar 2023 07:48:04 -0800 (PST)
X-Google-Smtp-Source: AK7set/EzktI0OlHucSuQTWKTKC3fqx8GzoJhXbuJEu5Rqstra/4hZCkq7D6l1IWXwedBvmq/luXbw==
X-Received: by 2002:a05:6000:1a42:b0:2c3:be89:7c2a with SMTP id t2-20020a0560001a4200b002c3be897c2amr1808989wry.13.1677772083843;
        Thu, 02 Mar 2023 07:48:03 -0800 (PST)
Received: from sgarzare-redhat (c-115-213.cust-q.wadsl.it. [212.43.115.213])
        by smtp.gmail.com with ESMTPSA id s18-20020a7bc392000000b003eb20d4d4a8sm3202128wmj.44.2023.03.02.07.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 07:48:03 -0800 (PST)
Date:   Thu, 2 Mar 2023 16:48:00 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 6/8] vdpa_sim: use kthread worker
Message-ID: <20230302154800.z3i4fpjlvtb74efu@sgarzare-redhat>
References: <20230302113421.174582-1-sgarzare@redhat.com>
 <20230302113421.174582-7-sgarzare@redhat.com>
 <ZADA/GgpbDoi+SzU@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZADA/GgpbDoi+SzU@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 04:30:04PM +0100, Simon Horman wrote:
>On Thu, Mar 02, 2023 at 12:34:19PM +0100, Stefano Garzarella wrote:
>> Let's use our own kthread to run device jobs.
>> This allows us more flexibility, especially we can attach the kthread
>> to the user address space when vDPA uses user's VA.
>>
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>>  drivers/vdpa/vdpa_sim/vdpa_sim.h |  3 ++-
>>  drivers/vdpa/vdpa_sim/vdpa_sim.c | 17 ++++++++++++-----
>>  2 files changed, 14 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
>> index acee20faaf6a..ce83f9130a5d 100644
>> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
>> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
>> @@ -57,7 +57,8 @@ struct vdpasim_dev_attr {
>>  struct vdpasim {
>>  	struct vdpa_device vdpa;
>>  	struct vdpasim_virtqueue *vqs;
>> -	struct work_struct work;
>> +	struct kthread_worker *worker;
>> +	struct kthread_work work;
>>  	struct vdpasim_dev_attr dev_attr;
>>  	/* spinlock to synchronize virtqueue state */
>>  	spinlock_t lock;
>> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> index a6ee830efc38..6feb29726c2a 100644
>> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> @@ -11,8 +11,8 @@
>>  #include <linux/module.h>
>>  #include <linux/device.h>
>>  #include <linux/kernel.h>
>> +#include <linux/kthread.h>
>>  #include <linux/slab.h>
>> -#include <linux/sched.h>
>>  #include <linux/dma-map-ops.h>
>>  #include <linux/vringh.h>
>>  #include <linux/vdpa.h>
>> @@ -116,7 +116,7 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim)
>>  static const struct vdpa_config_ops vdpasim_config_ops;
>>  static const struct vdpa_config_ops vdpasim_batch_config_ops;
>>
>> -static void vdpasim_work_fn(struct work_struct *work)
>> +static void vdpasim_work_fn(struct kthread_work *work)
>>  {
>>  	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
>>
>> @@ -159,7 +159,13 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
>>
>>  	vdpasim = vdpa_to_sim(vdpa);
>>  	vdpasim->dev_attr = *dev_attr;
>> -	INIT_WORK(&vdpasim->work, vdpasim_work_fn);
>> +
>> +	kthread_init_work(&vdpasim->work, vdpasim_work_fn);
>> +	vdpasim->worker = kthread_create_worker(0, "vDPA sim worker: %s",
>> +						dev_attr->name);
>> +	if (IS_ERR(vdpasim->worker))
>> +		goto err_iommu;
>
>Branching to err_iommu will result in a call to put_device(dev)...

Good catch!

>
>> +
>>  	spin_lock_init(&vdpasim->lock);
>>  	spin_lock_init(&vdpasim->iommu_lock);
>
>... but dev is not initialised until the line following this hunk,
>which is:
>
>	dev = &vdpasim->vdpa.dev;
>
>In order to avoid leaking dev I _think_ the correct approach
>is to move the initialisation of dev above the branch to
>err_iommu, perhaps above the call to kthread_init_work()
>is a good place.

Yep, I agree. I'll fix in v3.

Thanks,
Stefano

>
>This does move the assignment outside the locks above.
>But I _think_ that is ok.
>
>> @@ -212,7 +218,7 @@ EXPORT_SYMBOL_GPL(vdpasim_create);
>>
>>  void vdpasim_schedule_work(struct vdpasim *vdpasim)
>>  {
>> -	schedule_work(&vdpasim->work);
>> +	kthread_queue_work(vdpasim->worker, &vdpasim->work);
>>  }
>>  EXPORT_SYMBOL_GPL(vdpasim_schedule_work);
>>
>> @@ -612,7 +618,8 @@ static void vdpasim_free(struct vdpa_device *vdpa)
>>  	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>>  	int i;
>>
>> -	cancel_work_sync(&vdpasim->work);
>> +	kthread_cancel_work_sync(&vdpasim->work);
>> +	kthread_destroy_worker(vdpasim->worker);
>>
>>  	for (i = 0; i < vdpasim->dev_attr.nvqs; i++) {
>>  		vringh_kiov_cleanup(&vdpasim->vqs[i].out_iov);
>> --
>> 2.39.2
>>
>

