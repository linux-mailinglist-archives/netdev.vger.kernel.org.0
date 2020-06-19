Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A499200620
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 12:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732324AbgFSKQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 06:16:34 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:59904 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729195AbgFSKQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 06:16:32 -0400
Received: from jade.amanokami.net (unknown [IPv6:2400:4051:61:600:e972:d773:e99a:4f79])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 4B53C552;
        Fri, 19 Jun 2020 12:16:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1592561789;
        bh=Zg5Ii/zR+0IIXoYvMVV4qoS4KL1w3pwchMjpkxHuLN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G0QVD31aQ+QD7qhCNkZWps6T2Pj8hdxTT6TBQMG85FLV+1Oo7+qCh6hyIaEG3aZCQ
         9E8Br3Dwy1ZxNVj8mCqSdjFIGZm0HHGvBJZNSu0QFyWT4isJ4IfMe32r3ts84KG3Pt
         Vs2cYCX2UHoVPw0A9dkxb8U9z0gbuoXmHEjbBfFM=
Date:   Fri, 19 Jun 2020 19:16:19 +0900
From:   Paul Elder <paul.elder@ideasonboard.com>
To:     Damian Hobson-Garcia <dhobsong@igel.co.jp>
Cc:     viro@zeniv.linux.org.uk, sustrik@250bpm.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        David.Laight@aculab.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v3 1/1] eventfd: implementation of EFD_MASK flag
Message-ID: <20200619101619.GD2073@jade.amanokami.net>
References: <1444873328-8466-1-git-send-email-dhobsong@igel.co.jp>
 <1444873328-8466-2-git-send-email-dhobsong@igel.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1444873328-8466-2-git-send-email-dhobsong@igel.co.jp>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Damian, Martin, and all,

I came across this (quite old by now) patch to extend eventfd's polling
functionality. I was wondering what happened to it (why it hasn't been
merged yet) and if we could, or what is needed to, move it forward.

I was thinking to use it for V4L2 events support via polling in the V4L2
compatibility layer for libcamera [1]. We can signal V4L2 buffer
availability POLLOUT via write(), but there is no way to signal V4L2
events, as they are signaled via POLLPRI.


Thank you,

Paul

[1] https://libcamera.org/docs.html#id1

On Thu, Oct 15, 2015 at 10:42:08AM +0900, Damian Hobson-Garcia wrote:
> From: Martin Sustrik <sustrik@250bpm.com>
> 
> When implementing network protocols in user space, one has to implement
> fake file descriptors to represent the sockets for the protocol.
> 
> Polling on such fake file descriptors is a problem (poll/select/epoll
> accept only true file descriptors) and forces protocol implementers to use
> various workarounds resulting in complex, non-standard and convoluted APIs.
> 
> More generally, ability to create full-blown file descriptors for
> userspace-to-userspace signalling is missing. While eventfd(2) goes half
> the way towards this goal it has follwoing shorcomings:
> 
> I.  There's no way to signal POLLPRI, POLLHUP etc.
> II. There's no way to signal arbitrary combination of POLL* flags. Most
>     notably, simultaneous !POLLIN and !POLLOUT, which is a perfectly valid
>     combination for a network protocol (rx buffer is empty and tx buffer is
>     full), cannot be signaled using eventfd.
> 
> This patch implements new EFD_MASK flag which solves the above problems.
> 
> The semantics of EFD_MASK are as follows:
> 
> eventfd(2):
> 
> If eventfd is created with EFD_MASK flag set, it is initialised in such a
> way as to signal no events on the file descriptor when it is polled on.
> The 'initval' argument is ignored.
> 
> write(2):
> 
> User is allowed to write only buffers containing a 32-bit value
> representing any combination of event flags as defined by the poll(2)
> function (POLLIN, POLLOUT, POLLERR, POLLHUP etc.). Specified events
> will be signaled when polling (select, poll, epoll) on the eventfd is
> done later on.
> 
> read(2):
> 
> read is not supported and will fail with EINVAL.
> 
> select(2), poll(2) and similar:
> 
> When polling on the eventfd marked by EFD_MASK flag, all the events
> specified in last written event flags shall be signaled.
> 
> Signed-off-by: Martin Sustrik <sustrik@250bpm.com>
> 
> [dhobsong@igel.co.jp: Rebased, and resubmitted for Linux 4.3]
> Signed-off-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
> ---
>  fs/eventfd.c                 | 102 ++++++++++++++++++++++++++++++++++++++-----
>  include/linux/eventfd.h      |  16 +------
>  include/uapi/linux/eventfd.h |  33 ++++++++++++++
>  3 files changed, 126 insertions(+), 25 deletions(-)
>  create mode 100644 include/uapi/linux/eventfd.h
> 
> diff --git a/fs/eventfd.c b/fs/eventfd.c
> index 8d0c0df..1310779 100644
> --- a/fs/eventfd.c
> +++ b/fs/eventfd.c
> @@ -2,6 +2,7 @@
>   *  fs/eventfd.c
>   *
>   *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
> + *  Copyright (C) 2013  Martin Sustrik <sustrik@250bpm.com>
>   *
>   */
>  
> @@ -22,18 +23,31 @@
>  #include <linux/proc_fs.h>
>  #include <linux/seq_file.h>
>  
> +#define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
> +#define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE | EFD_MASK)
> +#define EFD_MASK_VALID_EVENTS (POLLIN | POLLPRI | POLLOUT | POLLERR | POLLHUP)
> +
>  struct eventfd_ctx {
>  	struct kref kref;
>  	wait_queue_head_t wqh;
> -	/*
> -	 * Every time that a write(2) is performed on an eventfd, the
> -	 * value of the __u64 being written is added to "count" and a
> -	 * wakeup is performed on "wqh". A read(2) will return the "count"
> -	 * value to userspace, and will reset "count" to zero. The kernel
> -	 * side eventfd_signal() also, adds to the "count" counter and
> -	 * issue a wakeup.
> -	 */
> -	__u64 count;
> +	union {
> +		/*
> +		 * Every time that a write(2) is performed on an eventfd, the
> +		 * value of the __u64 being written is added to "count" and a
> +		 * wakeup is performed on "wqh". A read(2) will return the
> +		 * "count" value to userspace, and will reset "count" to zero.
> +		 * The kernel side eventfd_signal() also, adds to the "count"
> +		 * counter and issue a wakeup.
> +		 */
> +		__u64 count;
> +
> +		/*
> +		 * When using eventfd in EFD_MASK mode this stracture stores the
> +		 * current events to be signaled on the eventfd (events member)
> +		 * along with opaque user-defined data (data member).
> +		 */
> +		__u32 events;
> +	};
>  	unsigned int flags;
>  };
>  
> @@ -134,6 +148,14 @@ static unsigned int eventfd_poll(struct file *file, poll_table *wait)
>  	return events;
>  }
>  
> +static unsigned int eventfd_mask_poll(struct file *file, poll_table *wait)
> +{
> +	struct eventfd_ctx *ctx = file->private_data;
> +
> +	poll_wait(file, &ctx->wqh, wait);
> +	return ctx->events;
> +}
> +
>  static void eventfd_ctx_do_read(struct eventfd_ctx *ctx, __u64 *cnt)
>  {
>  	*cnt = (ctx->flags & EFD_SEMAPHORE) ? 1 : ctx->count;
> @@ -239,6 +261,14 @@ static ssize_t eventfd_read(struct file *file, char __user *buf, size_t count,
>  	return put_user(cnt, (__u64 __user *) buf) ? -EFAULT : sizeof(cnt);
>  }
>  
> +static ssize_t eventfd_mask_read(struct file *file, char __user *buf,
> +			    size_t count,
> +			    loff_t *ppos)
> +{
> +	return -EINVAL;
> +}
> +
> +
>  static ssize_t eventfd_write(struct file *file, const char __user *buf, size_t count,
>  			     loff_t *ppos)
>  {
> @@ -286,6 +316,28 @@ static ssize_t eventfd_write(struct file *file, const char __user *buf, size_t c
>  	return res;
>  }
>  
> +static ssize_t eventfd_mask_write(struct file *file, const char __user *buf,
> +			     size_t count,
> +			     loff_t *ppos)
> +{
> +	struct eventfd_ctx *ctx = file->private_data;
> +	__u32 events;
> +
> +	if (count < sizeof(events))
> +		return -EINVAL;
> +	if (copy_from_user(&events, buf, sizeof(events)))
> +		return -EFAULT;
> +	if (events & ~EFD_MASK_VALID_EVENTS)
> +		return -EINVAL;
> +	spin_lock_irq(&ctx->wqh.lock);
> +	memcpy(&ctx->events, &events, sizeof(ctx->events));
> +	if (waitqueue_active(&ctx->wqh))
> +		wake_up_locked_poll(&ctx->wqh,
> +			(unsigned long)ctx->events);
> +	spin_unlock_irq(&ctx->wqh.lock);
> +	return sizeof(ctx->events);
> +}
> +
>  #ifdef CONFIG_PROC_FS
>  static void eventfd_show_fdinfo(struct seq_file *m, struct file *f)
>  {
> @@ -296,6 +348,16 @@ static void eventfd_show_fdinfo(struct seq_file *m, struct file *f)
>  		   (unsigned long long)ctx->count);
>  	spin_unlock_irq(&ctx->wqh.lock);
>  }
> +
> +static void eventfd_mask_show_fdinfo(struct seq_file *m, struct file *f)
> +{
> +	struct eventfd_ctx *ctx = f->private_data;
> +
> +	spin_lock_irq(&ctx->wqh.lock);
> +	seq_printf(m, "eventfd-mask: %x\n",
> +		ctx->events);
> +	spin_unlock_irq(&ctx->wqh.lock);
> +}
>  #endif
>  
>  static const struct file_operations eventfd_fops = {
> @@ -309,6 +371,17 @@ static const struct file_operations eventfd_fops = {
>  	.llseek		= noop_llseek,
>  };
>  
> +static const struct file_operations eventfd_mask_fops = {
> +#ifdef CONFIG_PROC_FS
> +	.show_fdinfo	= eventfd_mask_show_fdinfo,
> +#endif
> +	.release	= eventfd_release,
> +	.poll		= eventfd_mask_poll,
> +	.read		= eventfd_mask_read,
> +	.write		= eventfd_mask_write,
> +	.llseek		= noop_llseek,
> +};
> +
>  /**
>   * eventfd_fget - Acquire a reference of an eventfd file descriptor.
>   * @fd: [in] Eventfd file descriptor.
> @@ -392,6 +465,7 @@ struct file *eventfd_file_create(unsigned int count, int flags)
>  {
>  	struct file *file;
>  	struct eventfd_ctx *ctx;
> +	const struct file_operations *fops;
>  
>  	/* Check the EFD_* constants for consistency.  */
>  	BUILD_BUG_ON(EFD_CLOEXEC != O_CLOEXEC);
> @@ -406,10 +480,16 @@ struct file *eventfd_file_create(unsigned int count, int flags)
>  
>  	kref_init(&ctx->kref);
>  	init_waitqueue_head(&ctx->wqh);
> -	ctx->count = count;
> +	if (flags & EFD_MASK) {
> +		ctx->events = 0;
> +		fops = &eventfd_mask_fops;
> +	} else {
> +		ctx->count = count;
> +		fops = &eventfd_fops;
> +	}
>  	ctx->flags = flags;
>  
> -	file = anon_inode_getfile("[eventfd]", &eventfd_fops, ctx,
> +	file = anon_inode_getfile("[eventfd]", fops, ctx,
>  				  O_RDWR | (flags & EFD_SHARED_FCNTL_FLAGS));
>  	if (IS_ERR(file))
>  		eventfd_free_ctx(ctx);
> diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
> index ff0b981..87de343 100644
> --- a/include/linux/eventfd.h
> +++ b/include/linux/eventfd.h
> @@ -8,23 +8,11 @@
>  #ifndef _LINUX_EVENTFD_H
>  #define _LINUX_EVENTFD_H
>  
> +#include <uapi/linux/eventfd.h>
> +
>  #include <linux/fcntl.h>
>  #include <linux/wait.h>
>  
> -/*
> - * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
> - * new flags, since they might collide with O_* ones. We want
> - * to re-use O_* flags that couldn't possibly have a meaning
> - * from eventfd, in order to leave a free define-space for
> - * shared O_* flags.
> - */
> -#define EFD_SEMAPHORE (1 << 0)
> -#define EFD_CLOEXEC O_CLOEXEC
> -#define EFD_NONBLOCK O_NONBLOCK
> -
> -#define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
> -#define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
> -
>  struct file;
>  
>  #ifdef CONFIG_EVENTFD
> diff --git a/include/uapi/linux/eventfd.h b/include/uapi/linux/eventfd.h
> new file mode 100644
> index 0000000..097dcad
> --- /dev/null
> +++ b/include/uapi/linux/eventfd.h
> @@ -0,0 +1,33 @@
> +/*
> + *  Copyright (C) 2013 Martin Sustrik <sustrik@250bpm.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + */
> +
> +#ifndef _UAPI_LINUX_EVENTFD_H
> +#define _UAPI_LINUX_EVENTFD_H
> +
> +/* For O_CLOEXEC */
> +#include <linux/fcntl.h>
> +#include <linux/types.h>
> +
> +/*
> + * CAREFUL: Check include/asm-generic/fcntl.h when defining
> + * new flags, since they might collide with O_* ones. We want
> + * to re-use O_* flags that couldn't possibly have a meaning
> + * from eventfd, in order to leave a free define-space for
> + * shared O_* flags.
> + */
> +
> +/* Provide semaphore-like semantics for reads from the eventfd. */
> +#define EFD_SEMAPHORE (1 << 0)
> +/* Provide event mask semantics for the eventfd. */
> +#define EFD_MASK (1 << 1)
> +/*  Set the close-on-exec (FD_CLOEXEC) flag on the eventfd. */
> +#define EFD_CLOEXEC O_CLOEXEC
> +/*  Create the eventfd in non-blocking mode. */
> +#define EFD_NONBLOCK O_NONBLOCK
> +#endif /* _UAPI_LINUX_EVENTFD_H */
> -- 
> 1.9.1
