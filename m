Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F801E5CAB
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 12:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387709AbgE1KGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 06:06:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49020 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387648AbgE1KGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 06:06:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590660391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tnVLq9gOlF/Y0CKh5mHb/8VGvnVEAONI1W/k6ECLs88=;
        b=FVxxSUst6jsvDjapzed7SPVSeEK6KHqj4IF3iqyqXHWn42sSCyoad8JdOXhOI3dE2XYrYw
        sPDLmjajIckz4N9yk82nKj0wifTRGG185oAXktQE/ljZgL9SjGOEpY9G27KIHDgz+Ved5z
        cQZqfudKULEvlXJXv0ttdi78zb5TGb0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-USNhnFjkO8quSonUUamdyQ-1; Thu, 28 May 2020 06:06:24 -0400
X-MC-Unique: USNhnFjkO8quSonUUamdyQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6AEE9107ACF2;
        Thu, 28 May 2020 10:06:23 +0000 (UTC)
Received: from [10.72.13.125] (ovpn-13-125.pek2.redhat.com [10.72.13.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2804E5D9F3;
        Thu, 28 May 2020 10:06:16 +0000 (UTC)
Subject: Re: [PATCH] vdpa: bypass waking up vhost_woker for vdpa vq kick
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com
References: <1590471145-4436-1-git-send-email-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a21bf980-c001-4728-0f08-69494f31fe98@redhat.com>
Date:   Thu, 28 May 2020 18:06:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1590471145-4436-1-git-send-email-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/5/26 下午1:32, Zhu Lingshan wrote:
> Standard vhost devices rely on waking up a vhost_worker to kick
> a virtquque. However vdpa devices have hardware backends, so it
> does not need this waking up routin. In this commit, vdpa device
> will kick a virtqueue directly, reduce the performance overhead
> caused by waking up a vhost_woker.


Thanks for the patch. It would be helpful if you can share some 
performance numbers.

And the title should be "vhost-vdpa:" instead of "vdpa:"

This patch is important since we want to get rid of ktrhead and 
use_mm()/unuse_mm() stuffs which allows us to implement doorbell mapping.


>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> ---
>   drivers/vhost/vdpa.c | 100 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 100 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 0968361..d3a2aca 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -287,6 +287,66 @@ static long vhost_vdpa_get_vring_num(struct vhost_vdpa *v, u16 __user *argp)
>   
>   	return 0;
>   }
> +void vhost_vdpa_poll_stop(struct vhost_virtqueue *vq)
> +{
> +	vhost_poll_stop(&vq->poll);
> +}
> +
> +int vhost_vdpa_poll_start(struct vhost_virtqueue *vq)
> +{
> +	struct vhost_poll *poll = &vq->poll;
> +	struct file *file = vq->kick;
> +	__poll_t mask;
> +
> +
> +	if (poll->wqh)
> +		return 0;
> +
> +	mask = vfs_poll(file, &poll->table);
> +	if (mask)
> +		vq->handle_kick(&vq->poll.work);
> +	if (mask & EPOLLERR) {
> +		vhost_poll_stop(poll);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}


So this basically a duplication of vhost_poll_start()?


> +
> +static long vhost_vdpa_set_vring_kick(struct vhost_virtqueue *vq,
> +				      void __user *argp)
> +{
> +	bool pollstart = false, pollstop = false;
> +	struct file *eventfp, *filep = NULL;
> +	struct vhost_vring_file f;
> +	long r;
> +
> +	if (copy_from_user(&f, argp, sizeof(f)))
> +		return -EFAULT;
> +
> +	eventfp = f.fd == -1 ? NULL : eventfd_fget(f.fd);
> +	if (IS_ERR(eventfp)) {
> +		r = PTR_ERR(eventfp);
> +		return r;
> +	}
> +
> +	if (eventfp != vq->kick) {
> +		pollstop = (filep = vq->kick) != NULL;
> +		pollstart = (vq->kick = eventfp) != NULL;
> +	} else
> +		filep = eventfp;
> +
> +	if (pollstop && vq->handle_kick)
> +		vhost_vdpa_poll_stop(vq);
> +
> +	if (filep)
> +		fput(filep);
> +
> +	if (pollstart && vq->handle_kick)
> +		r = vhost_vdpa_poll_start(vq);
> +
> +	return r;
> +}
>   
>   static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>   				   void __user *argp)
> @@ -316,6 +376,11 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>   		return 0;
>   	}
>   
> +	if (cmd == VHOST_SET_VRING_KICK) {
> +		r = vhost_vdpa_set_vring_kick(vq, argp);
> +		return r;
> +	}
> +
>   	if (cmd == VHOST_GET_VRING_BASE)
>   		vq->last_avail_idx = ops->get_vq_state(v->vdpa, idx);
>   
> @@ -667,6 +732,39 @@ static void vhost_vdpa_free_domain(struct vhost_vdpa *v)
>   	v->domain = NULL;
>   }
>   
> +static int vhost_vdpa_poll_worker(wait_queue_entry_t *wait, unsigned int mode,
> +				  int sync, void *key)
> +{
> +	struct vhost_poll *poll = container_of(wait, struct vhost_poll, wait);
> +	struct vhost_virtqueue *vq = container_of(poll, struct vhost_virtqueue,
> +						  poll);
> +
> +	if (!(key_to_poll(key) & poll->mask))
> +		return 0;
> +
> +	vq->handle_kick(&vq->poll.work);
> +
> +	return 0;
> +}
> +
> +void vhost_vdpa_poll_init(struct vhost_dev *dev)
> +{
> +	struct vhost_virtqueue *vq;
> +	struct vhost_poll *poll;
> +	int i;
> +
> +	for (i = 0; i < dev->nvqs; i++) {
> +		vq = dev->vqs[i];
> +		poll = &vq->poll;
> +		if (vq->handle_kick) {
> +			init_waitqueue_func_entry(&poll->wait,
> +						  vhost_vdpa_poll_worker);
> +			poll->work.fn = vq->handle_kick;


Why this is needed?


> +		}
> +
> +	}
> +}
> +
>   static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>   {
>   	struct vhost_vdpa *v;
> @@ -697,6 +795,8 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>   	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0,
>   		       vhost_vdpa_process_iotlb_msg);
>   
> +	vhost_vdpa_poll_init(dev);
> +
>   	dev->iotlb = vhost_iotlb_alloc(0, 0);
>   	if (!dev->iotlb) {
>   		r = -ENOMEM;


So my feeling here is that you want to reuse the infrastructure in 
vhost.c as much as possible

If this is true, let's just avoid duplicating the codes. How about 
adding something like in vhost_poll_wakeup():


     struct vhost_poll *poll = container_of(wait, struct vhost_poll, wait);
     struct vhost_work *work = &poll->work;

     if (!(key_to_poll(key) & poll->mask))
         return 0;

     if (!poll->dev->use_worker)
         work->fn(work);
     else
         vhost_poll_queue(poll);


Then modify vhost_dev_init() to set use_worker (all true except for vdpa)?


Thanks

