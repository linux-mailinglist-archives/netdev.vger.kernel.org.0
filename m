Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0A15DB5B1
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441236AbfJQSSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:18:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438601AbfJQSSC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 14:18:02 -0400
Received: from localhost (unknown [192.55.54.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78A0420659;
        Thu, 17 Oct 2019 18:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571336280;
        bh=SR+bTSpFdod0Pmckp7adJ/ibEnctQOUUmhnuvOQCrjY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RkTngsv/1miXtFdWrcmt1WxD7vnDnHdpunA+SOr9P2/TvBDfb8M9X/TVQm8/BNYl1
         /ah1UqwxSf42djwPhxXDYrM8gkSc8vvloXnEcxjykfTzwn+2CKdx5qfuktu09gIoOU
         Fe8DldLn8f7+VsWb+IdxBoFJS4qSBQmy0O3JoTiM=
Date:   Thu, 17 Oct 2019 11:18:00 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andrey Konovalov <andreyknvl@google.com>
Cc:     linux-usb@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Windsor <dwindsor@gmail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH RFC 3/3] vhost, kcov: collect coverage from vhost_worker
Message-ID: <20191017181800.GB1094415@kroah.com>
References: <cover.1571333592.git.andreyknvl@google.com>
 <af26317c0efd412dd660e81d548a173942f8a0ad.1571333592.git.andreyknvl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af26317c0efd412dd660e81d548a173942f8a0ad.1571333592.git.andreyknvl@google.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 07:44:15PM +0200, Andrey Konovalov wrote:
> This patch adds kcov_remote_start/kcov_remote_stop annotations to the
> vhost_worker function, which is responsible for processing vhost works.
> Since vhost_worker is spawned when a vhost device instance is created,
> the common kcov handle is used for kcov_remote_start/stop annotations.
> 
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> ---
>  drivers/vhost/vhost.c | 15 +++++++++++++++
>  drivers/vhost/vhost.h |  3 +++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 36ca2cf419bf..71a349f6b352 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -357,7 +357,13 @@ static int vhost_worker(void *data)
>  		llist_for_each_entry_safe(work, work_next, node, node) {
>  			clear_bit(VHOST_WORK_QUEUED, &work->flags);
>  			__set_current_state(TASK_RUNNING);
> +#ifdef CONFIG_KCOV
> +			kcov_remote_start(dev->kcov_handle);
> +#endif

Shouldn't you hide these #ifdefs in a .h file?  This is not a "normal"
kernel coding style at all.

>  			work->fn(work);
> +#ifdef CONFIG_KCOV
> +			kcov_remote_stop();
> +#endif
>  			if (need_resched())
>  				schedule();
>  		}
> @@ -546,6 +552,9 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
>  
>  	/* No owner, become one */
>  	dev->mm = get_task_mm(current);
> +#ifdef CONFIG_KCOV
> +	dev->kcov_handle = current->kcov_handle;
> +#endif
>  	worker = kthread_create(vhost_worker, dev, "vhost-%d", current->pid);
>  	if (IS_ERR(worker)) {
>  		err = PTR_ERR(worker);
> @@ -571,6 +580,9 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
>  	if (dev->mm)
>  		mmput(dev->mm);
>  	dev->mm = NULL;
> +#ifdef CONFIG_KCOV
> +	dev->kcov_handle = 0;
> +#endif
>  err_mm:
>  	return err;
>  }
> @@ -682,6 +694,9 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>  	if (dev->worker) {
>  		kthread_stop(dev->worker);
>  		dev->worker = NULL;
> +#ifdef CONFIG_KCOV
> +		dev->kcov_handle = 0;
> +#endif
>  	}
>  	if (dev->mm)
>  		mmput(dev->mm);
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index e9ed2722b633..010ca1ebcbd5 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -173,6 +173,9 @@ struct vhost_dev {
>  	int iov_limit;
>  	int weight;
>  	int byte_weight;
> +#ifdef CONFIG_KCOV
> +	u64 kcov_handle;
> +#endif

Why is this a #ifdef at all here?

thanks,

greg k-h
