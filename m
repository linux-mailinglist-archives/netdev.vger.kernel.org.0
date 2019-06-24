Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 603665192D
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbfFXQzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:55:40 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51380 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728732AbfFXQzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:55:40 -0400
Received: by mail-wm1-f66.google.com with SMTP id 207so80543wma.1
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 09:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L6EvC0unTsrEA1opta1UlvCpT65PELY6P/sIGXuUzsM=;
        b=U2C4ZVSSvyCI04TVte086soWZQ9evOjfs842Sx7bzZHcpuiX7A0piGmNy1nnzlF2mJ
         nK9x6hyI9INxJfd0VMbsNlYgqtciK8AqPibLJqBsWS9DE67Jh1GJTBLCOBwq21ypIM63
         wPtUnxz0jCogXM0S7fYFPHhCy5vQ/GaExB+0WQIiP2Fp1mtCC03RUJ915UNkjgqFzfyi
         qM5hareAeP0hCLeV12JM/RVOqupg+YCYQlBBQUUh8khklBZjDH1eGWxkBk4RP8vYchx5
         rYH6mMlMzKsDSt3TlmUYivf2umHwjF8PqjTEZYQgMN89aRQz40UsSpvbqp3CnlNRsnLe
         PIQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L6EvC0unTsrEA1opta1UlvCpT65PELY6P/sIGXuUzsM=;
        b=gAiM2B9NAFkD3pMK0Ot4JtUHWIJxidjPwaUV0XlqZCSDqBncWf2YTYuppaoJpUAXYG
         rJuXF28ZZl3iAJq40kBSJaTy+WwWUzQ/hPjyudHSbcD83dyuVAb8n63PdG4zGpVSJvnf
         Sy9nBoC1qUjUs0GOFxst794Vp11oaNka53o2b6MTuzLX9EOLZ1pF2FAP/0FA59dNwY0I
         iyIy5ae7pbO/JgpKdU3TPI3Jylorq9XFP0Hpv8/Q8wayOC15mQfCRHmcyrdID+ON+Ovm
         6uFdYZvRDvTfj2fWCUnrlH0RLCvUDbQAd0MLfgc3lBmmgZ7XaFhZ2zhPJnS071MGK0IG
         l79A==
X-Gm-Message-State: APjAAAXtN6TGLnMkB0XKE/AgUu8Q457kCv1K8pPuJ7t3zem7UgTfe02N
        J1ycdKrfLrjh3I8Glf8TY67JZ2zbItg=
X-Google-Smtp-Source: APXvYqy0WhBPDbrVZ2B9CbRE6EbF4sISjmvc7L7zGxmuz0tLKpowXEaSvsrC76wawPP9S3vfq7YhlQ==
X-Received: by 2002:a1c:f415:: with SMTP id z21mr17548532wma.34.1561395336335;
        Mon, 24 Jun 2019 09:55:36 -0700 (PDT)
Received: from [10.8.2.125] ([193.47.165.251])
        by smtp.googlemail.com with ESMTPSA id z76sm80807wmc.16.2019.06.24.09.55.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 09:55:35 -0700 (PDT)
Subject: Re: [PATCH rdma-next v1 11/12] IB/mlx5: Implement DEVX dispatching
 event
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-12-leon@kernel.org>
 <20190624120338.GD5479@mellanox.com>
From:   Yishai Hadas <yishaih@dev.mellanox.co.il>
Message-ID: <3a2e53f8-e7dd-3e01-c7c7-99d41f711d87@dev.mellanox.co.il>
Date:   Mon, 24 Jun 2019 19:55:32 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190624120338.GD5479@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/2019 3:03 PM, Jason Gunthorpe wrote:
> On Tue, Jun 18, 2019 at 08:15:39PM +0300, Leon Romanovsky wrote:
>> From: Yishai Hadas <yishaih@mellanox.com>
>>
>> Implement DEVX dispatching event by looking up for the applicable
>> subscriptions for the reported event and using their target fd to
>> signal/set the event.
>>
>> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
>> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>>   drivers/infiniband/hw/mlx5/devx.c         | 362 +++++++++++++++++++++-
>>   include/uapi/rdma/mlx5_user_ioctl_verbs.h |   5 +
>>   2 files changed, 357 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
>> index 304b13e7a265..49fdce95d6d9 100644
>> +++ b/drivers/infiniband/hw/mlx5/devx.c
>> @@ -34,6 +34,11 @@ struct devx_async_data {
>>   	struct mlx5_ib_uapi_devx_async_cmd_hdr hdr;
>>   };
>>   
>> +struct devx_async_event_data {
>> +	struct list_head list; /* headed in ev_queue->event_list */
>> +	struct mlx5_ib_uapi_devx_async_event_hdr hdr;
>> +};
>> +
>>   /* first level XA value data structure */
>>   struct devx_event {
>>   	struct xarray object_ids; /* second XA level, Key = object id */
>> @@ -54,7 +59,9 @@ struct devx_event_subscription {
>>   				   * devx_obj_event->obj_sub_list
>>   				   */
>>   	struct list_head obj_list; /* headed in devx_object */
>> +	struct list_head event_list; /* headed in ev_queue->event_list */
>>   
>> +	u8  is_cleaned:1;
> 
> There is a loose bool 'is_obj_related' that should be combined with
> this bool bitfield as well.
> 

OK

>>   static void devx_cleanup_subscription(struct mlx5_ib_dev *dev,
>> -				      struct devx_event_subscription *sub)
>> +				      struct devx_event_subscription *sub,
>> +				      bool file_close)
>>   {
>> -	list_del_rcu(&sub->file_list);
>> +	if (sub->is_cleaned)
>> +		goto end;
>> +
>> +	sub->is_cleaned = 1;
>>   	list_del_rcu(&sub->xa_list);
>>   
>>   	if (sub->is_obj_related) {
>> @@ -1303,10 +1355,15 @@ static void devx_cleanup_subscription(struct mlx5_ib_dev *dev,
>>   		}
>>   	}
>>   
>> -	if (sub->eventfd)
>> -		eventfd_ctx_put(sub->eventfd);
>> +end:
>> +	if (file_close) {
>> +		if (sub->eventfd)
>> +			eventfd_ctx_put(sub->eventfd);
>>   
>> -	kfree_rcu(sub, rcu);
>> +		list_del_rcu(&sub->file_list);
>> +		/* subscription may not be used by the read API any more */
>> +		kfree_rcu(sub, rcu);
>> +	}
> 
> Dis like this confusing file_close stuff, just put this in the single place
> that calls this with the true bool
> 

OK, will do.

>> +static int deliver_event(struct devx_event_subscription *event_sub,
>> +			 const void *data)
>> +{
>> +	struct ib_uobject *fd_uobj = event_sub->fd_uobj;
>> +	struct devx_async_event_file *ev_file;
>> +	struct devx_async_event_queue *ev_queue;
>> +	struct devx_async_event_data *event_data;
>> +	unsigned long flags;
>> +	bool omit_data;
>> +
>> +	ev_file = container_of(fd_uobj, struct devx_async_event_file,
>> +			       uobj);
>> +	ev_queue = &ev_file->ev_queue;
>> +	omit_data = ev_queue->flags &
>> +		MLX5_IB_UAPI_DEVX_CREATE_EVENT_CHANNEL_FLAGS_OMIT_EV_DATA;
>> +
>> +	if (omit_data) {
>> +		spin_lock_irqsave(&ev_queue->lock, flags);
>> +		if (!list_empty(&event_sub->event_list)) {
>> +			spin_unlock_irqrestore(&ev_queue->lock, flags);
>> +			return 0;
>> +		}
>> +
>> +		list_add_tail(&event_sub->event_list, &ev_queue->event_list);
>> +		spin_unlock_irqrestore(&ev_queue->lock, flags);
>> +		wake_up_interruptible(&ev_queue->poll_wait);
>> +		return 0;
>> +	}
>> +
>> +	event_data = kzalloc(sizeof(*event_data) +
>> +			     (omit_data ? 0 : sizeof(struct mlx5_eqe)),
>> +			     GFP_ATOMIC);
> 
> omit_data is always false here
> 

Correct, will clean it up.

>> +	if (!event_data) {
>> +		spin_lock_irqsave(&ev_queue->lock, flags);
>> +		ev_queue->is_overflow_err = 1;
>> +		spin_unlock_irqrestore(&ev_queue->lock, flags);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	event_data->hdr.cookie = event_sub->cookie;
>> +	memcpy(event_data->hdr.out_data, data, sizeof(struct mlx5_eqe));
>> +
>> +	spin_lock_irqsave(&ev_queue->lock, flags);
>> +	list_add_tail(&event_data->list, &ev_queue->event_list);
>> +	spin_unlock_irqrestore(&ev_queue->lock, flags);
>> +	wake_up_interruptible(&ev_queue->poll_wait);
>> +
>> +	return 0;
>> +}
>> +
>> +static void dispatch_event_fd(struct list_head *fd_list,
>> +			      const void *data)
>> +{
>> +	struct devx_event_subscription *item;
>> +
>> +	list_for_each_entry_rcu(item, fd_list, xa_list) {
>> +		if (!get_file_rcu((struct file *)item->object))
>> +			continue;
>> +
>> +		if (item->eventfd) {
>> +			eventfd_signal(item->eventfd, 1);
>> +			fput(item->object);
>> +			continue;
>> +		}
>> +
>> +		deliver_event(item, data);
>> +		fput(item->object);
>> +	}
>> +}
>> +
>>   static int devx_event_notifier(struct notifier_block *nb,
>>   			       unsigned long event_type, void *data)
>>   {
>> -	return NOTIFY_DONE;
>> +	struct mlx5_devx_event_table *table;
>> +	struct mlx5_ib_dev *dev;
>> +	struct devx_event *event;
>> +	struct devx_obj_event *obj_event;
>> +	u16 obj_type = 0;
>> +	bool is_unaffiliated;
>> +	u32 obj_id;
>> +
>> +	/* Explicit filtering to kernel events which may occur frequently */
>> +	if (event_type == MLX5_EVENT_TYPE_CMD ||
>> +	    event_type == MLX5_EVENT_TYPE_PAGE_REQUEST)
>> +		return NOTIFY_OK;
>> +
>> +	table = container_of(nb, struct mlx5_devx_event_table, devx_nb.nb);
>> +	dev = container_of(table, struct mlx5_ib_dev, devx_event_table);
>> +	is_unaffiliated = is_unaffiliated_event(dev->mdev, event_type);
>> +
>> +	if (!is_unaffiliated)
>> +		obj_type = get_event_obj_type(event_type, data);
>> +	event = xa_load(&table->event_xa, event_type | (obj_type << 16));
>> +	if (!event)
>> +		return NOTIFY_DONE;
> 
> event should be in the rcu as well

Do we really need this ? I didn't see a flow that really requires that.
> 
>> +	if (is_unaffiliated) {
>> +		dispatch_event_fd(&event->unaffiliated_list, data);
>> +		return NOTIFY_OK;
>> +	}
>> +
>> +	obj_id = devx_get_obj_id_from_event(event_type, data);
>> +	rcu_read_lock();
>> +	obj_event = xa_load(&event->object_ids, obj_id);
>> +	if (!obj_event) {
>> +		rcu_read_unlock();
>> +		return NOTIFY_DONE;
>> +	}
>> +
>> +	dispatch_event_fd(&obj_event->obj_sub_list, data);
>> +
>> +	rcu_read_unlock();
>> +	return NOTIFY_OK;
>>   }
>>   
>>   void mlx5_ib_devx_init_event_table(struct mlx5_ib_dev *dev)
>> @@ -2221,7 +2444,7 @@ void mlx5_ib_devx_cleanup_event_table(struct mlx5_ib_dev *dev)
>>   		event = entry;
>>   		list_for_each_entry_safe(sub, tmp, &event->unaffiliated_list,
>>   					 xa_list)
>> -			devx_cleanup_subscription(dev, sub);
>> +			devx_cleanup_subscription(dev, sub, false);
>>   		kfree(entry);
>>   	}
>>   	mutex_unlock(&dev->devx_event_table.event_xa_lock);
>> @@ -2329,18 +2552,126 @@ static const struct file_operations devx_async_cmd_event_fops = {
>>   static ssize_t devx_async_event_read(struct file *filp, char __user *buf,
>>   				     size_t count, loff_t *pos)
>>   {
>> -	return -EINVAL;
>> +	struct devx_async_event_file *ev_file = filp->private_data;
>> +	struct devx_async_event_queue *ev_queue = &ev_file->ev_queue;
>> +	struct devx_event_subscription *event_sub;
>> +	struct devx_async_event_data *uninitialized_var(event);
>> +	int ret = 0;
>> +	size_t eventsz;
>> +	bool omit_data;
>> +	void *event_data;
>> +
>> +	omit_data = ev_queue->flags &
>> +		MLX5_IB_UAPI_DEVX_CREATE_EVENT_CHANNEL_FLAGS_OMIT_EV_DATA;
>> +
>> +	spin_lock_irq(&ev_queue->lock);
>> +
>> +	if (ev_queue->is_overflow_err) {
>> +		ev_queue->is_overflow_err = 0;
>> +		spin_unlock_irq(&ev_queue->lock);
>> +		return -EOVERFLOW;
>> +	}
>> +
>> +	while (list_empty(&ev_queue->event_list)) {
>> +		spin_unlock_irq(&ev_queue->lock);
>> +
>> +		if (filp->f_flags & O_NONBLOCK)
>> +			return -EAGAIN;
>> +
>> +		if (wait_event_interruptible(ev_queue->poll_wait,
>> +			    (!list_empty(&ev_queue->event_list) ||
>> +			     ev_queue->is_destroyed))) {
>> +			return -ERESTARTSYS;
>> +		}
>> +
>> +		if (list_empty(&ev_queue->event_list) &&
>> +		    ev_queue->is_destroyed)
>> +			return -EIO;
> 
> All these tests should be under the lock.

We can't call wait_event_interruptible() above which may sleep under the 
lock, correct ? are you referring to the list_empty() and is_destroyed ?

By the way looking in uverb code [1], similar code which is not done 
under the lock as of here..

[1] 
https://elixir.bootlin.com/linux/latest/source/drivers/infiniband/core/uverbs_main.c#L244


> 
> Why don't we return EIO as soon as is-destroyed happens? What is the
> point of flushing out the accumulated events?

It follows the above uverb code/logic that returns existing events even 
in that case, also the async command events in this file follows that 
logic, I suggest to stay consistent.
> 
>> +
>> +		spin_lock_irq(&ev_queue->lock);
>> +	}
>> +
>> +	if (omit_data) {
>> +		event_sub = list_first_entry(&ev_queue->event_list,
>> +					struct devx_event_subscription,
>> +					event_list);
>> +		eventsz = sizeof(event_sub->cookie);
>> +		event_data = &event_sub->cookie;
>> +	} else {
>> +		event = list_first_entry(&ev_queue->event_list,
>> +				      struct devx_async_event_data, list);
>> +		eventsz = sizeof(struct mlx5_eqe) +
>> +			sizeof(struct mlx5_ib_uapi_devx_async_event_hdr);
>> +		event_data = &event->hdr;
>> +	}
>> +
>> +	if (eventsz > count) {
>> +		spin_unlock_irq(&ev_queue->lock);
>> +		return -ENOSPC;
> 
> This is probably the wrong errno

OK, will change to -EINVAL as in uverbs
https://elixir.bootlin.com/linux/latest/source/drivers/infiniband/core/uverbs_main.c#L254

> 
>> +	}
>> +
>> +	if (omit_data)
>> +		list_del_init(&event_sub->event_list);
>> +	else
>> +		list_del(&event->list);
>> +
>> +	spin_unlock_irq(&ev_queue->lock);
>> +
>> +	if (copy_to_user(buf, event_data, eventsz))
>> +		ret = -EFAULT;
>> +	else
>> +		ret = eventsz;
> 
> This is really poorly ordered, EFAULT will cause the event to be lost. :(

Agree but apparently rare case .. see also the below notes.

> 
> Maybe the event should be re-added on error? Tricky.

What will happen if another copy_to_user may then fail again (loop ?) 
... not sure that we want to get into this tricky handling ...

As of above, It follows the logic from uverbs at that area.
https://elixir.bootlin.com/linux/latest/source/drivers/infiniband/core/uverbs_main.c#L267

> 
>> +	if (!omit_data)
>> +		kfree(event);
>> +	return ret;
>>   }
>>   
>>   static __poll_t devx_async_event_poll(struct file *filp,
>>   				      struct poll_table_struct *wait)
>>   {
>> -	return 0;
>> +	struct devx_async_event_file *ev_file = filp->private_data;
>> +	struct devx_async_event_queue *ev_queue = &ev_file->ev_queue;
>> +	__poll_t pollflags = 0;
>> +
>> +	poll_wait(filp, &ev_queue->poll_wait, wait);
>> +
>> +	spin_lock_irq(&ev_queue->lock);
>> +	if (ev_queue->is_destroyed)
>> +		pollflags = EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
>> +	else if (!list_empty(&ev_queue->event_list))
>> +		pollflags = EPOLLIN | EPOLLRDNORM;
>> +	spin_unlock_irq(&ev_queue->lock);
>> +
>> +	return pollflags;
>>   }
>>   
>>   static int devx_async_event_close(struct inode *inode, struct file *filp)
>>   {
>> +	struct ib_uobject *uobj = filp->private_data;
>> +	struct devx_async_event_file *ev_file =
>> +		container_of(uobj, struct devx_async_event_file, uobj);
>> +	struct devx_event_subscription *event_sub, *event_sub_tmp;
>> +	struct devx_async_event_data *entry, *tmp;
>> +
>> +	mutex_lock(&ev_file->dev->devx_event_table.event_xa_lock);
>> +	/* delete the subscriptions which are related to this FD */
>> +	list_for_each_entry_safe(event_sub, event_sub_tmp,
>> +				 &ev_file->subscribed_events_list, file_list)
>> +		devx_cleanup_subscription(ev_file->dev, event_sub, true);
>> +	mutex_unlock(&ev_file->dev->devx_event_table.event_xa_lock);
>> +
>> +	/* free the pending events allocation */
>> +	if (!(ev_file->ev_queue.flags &
>> +	    MLX5_IB_UAPI_DEVX_CREATE_EVENT_CHANNEL_FLAGS_OMIT_EV_DATA)) {
>> +		spin_lock_irq(&ev_file->ev_queue.lock);
>> +		list_for_each_entry_safe(entry, tmp,
>> +					 &ev_file->ev_queue.event_list, list)
>> +			kfree(entry); /* read can't come any nore */
> 
> spelling

OK

> 
>> +		spin_unlock_irq(&ev_file->ev_queue.lock);
>> +	}
>>   	uverbs_close_fd(filp);
>> +	put_device(&ev_file->dev->ib_dev.dev);
>>   	return 0;
>>   }
>>   
>> @@ -2374,6 +2705,17 @@ static int devx_hot_unplug_async_cmd_event_file(struct ib_uobject *uobj,
>>   static int devx_hot_unplug_async_event_file(struct ib_uobject *uobj,
>>   					    enum rdma_remove_reason why)
>>   {
>> +	struct devx_async_event_file *ev_file =
>> +		container_of(uobj, struct devx_async_event_file,
>> +			     uobj);
>> +	struct devx_async_event_queue *ev_queue = &ev_file->ev_queue;
>> +
>> +	spin_lock_irq(&ev_queue->lock);
>> +	ev_queue->is_destroyed = 1;
>> +	spin_unlock_irq(&ev_queue->lock);
>> +
>> +	if (why == RDMA_REMOVE_DRIVER_REMOVE)
>> +		wake_up_interruptible(&ev_queue->poll_wait);
> 
> Why isn't this wakeup always done?

Maybe you are right and this can be always done to wake up any readers 
as the 'is_destroyed' was set.

By the way, any idea why it was done as such in uverbs [1] for similar 
flow ? also the command events follows that.


[1]
https://elixir.bootlin.com/linux/latest/source/drivers/infiniband/core/uverbs_std_types.c#L207
