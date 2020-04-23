Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59EC01B51F9
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 03:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgDWBh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 21:37:57 -0400
Received: from mail.hallyn.com ([178.63.66.53]:53220 "EHLO mail.hallyn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbgDWBh5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 21:37:57 -0400
Received: by mail.hallyn.com (Postfix, from userid 1001)
        id 44E5B9D0; Wed, 22 Apr 2020 20:37:54 -0500 (CDT)
Date:   Wed, 22 Apr 2020 20:37:54 -0500
From:   "Serge E. Hallyn" <serge@hallyn.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Serge Hallyn <serge@hallyn.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saravana Kannan <saravanak@google.com>,
        Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Tom Gundersen <teg@jklm.no>,
        Christian Kellner <ckellner@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        Steve Barber <smbarber@google.com>,
        Dylan Reid <dgreid@google.com>,
        Filipe Brandenburger <filbranden@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Benjamin Elder <bentheelder@google.com>,
        Akihiro Suda <suda.kyoto@gmail.com>
Subject: Re: [PATCH v2 7/7] loopfs: only show devices in their correct
 instance
Message-ID: <20200423013754.GC2982@mail.hallyn.com>
References: <20200422145437.176057-1-christian.brauner@ubuntu.com>
 <20200422145437.176057-8-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422145437.176057-8-christian.brauner@ubuntu.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 04:54:37PM +0200, Christian Brauner wrote:
> Since loopfs devices belong to a loopfs instance they have no business
> polluting the host's devtmpfs mount and should not propagate out of the
> namespace they belong to.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>

Reviewed-by: Serge Hallyn <serge@hallyn.com>

> ---
> /* v2 */
> unchanged
> ---
>  drivers/base/devtmpfs.c | 4 ++--
>  drivers/block/loop.c    | 4 +++-
>  include/linux/device.h  | 3 +++
>  3 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
> index c9017e0584c0..77371ceb88fa 100644
> --- a/drivers/base/devtmpfs.c
> +++ b/drivers/base/devtmpfs.c
> @@ -111,7 +111,7 @@ int devtmpfs_create_node(struct device *dev)
>  	const char *tmp = NULL;
>  	struct req req;
>  
> -	if (!thread)
> +	if (!thread || dev->no_devnode)
>  		return 0;
>  
>  	req.mode = 0;
> @@ -138,7 +138,7 @@ int devtmpfs_delete_node(struct device *dev)
>  	const char *tmp = NULL;
>  	struct req req;
>  
> -	if (!thread)
> +	if (!thread || dev->no_devnode)
>  		return 0;
>  
>  	req.name = device_get_devnode(dev, NULL, NULL, NULL, &tmp);
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 2dc53bad4b48..5548151b9f11 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -2213,8 +2213,10 @@ static int loop_add(struct loop_device **l, int i, struct inode *inode)
>  	disk->queue		= lo->lo_queue;
>  	sprintf(disk->disk_name, "loop%d", i);
>  #ifdef CONFIG_BLK_DEV_LOOPFS
> -	if (loopfs_i_sb(inode))
> +	if (loopfs_i_sb(inode)) {
>  		disk->user_ns = loopfs_i_sb(inode)->s_user_ns;
> +		disk_to_dev(disk)->no_devnode = true;
> +	}
>  #endif
>  
>  	add_disk(disk);
> diff --git a/include/linux/device.h b/include/linux/device.h
> index ac8e37cd716a..c69ef1c5a0ef 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -523,6 +523,8 @@ struct dev_links_info {
>   *		  sync_state() callback.
>   * @dma_coherent: this particular device is dma coherent, even if the
>   *		architecture supports non-coherent devices.
> + * @no_devnode: whether device nodes associated with this device are kept out
> + *		of devtmpfs (e.g. due to separate filesystem)
>   *
>   * At the lowest level, every device in a Linux system is represented by an
>   * instance of struct device. The device structure contains the information
> @@ -622,6 +624,7 @@ struct device {
>      defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL)
>  	bool			dma_coherent:1;
>  #endif
> +	bool			no_devnode:1;
>  };
>  
>  static inline struct device *kobj_to_dev(struct kobject *kobj)
> -- 
> 2.26.1
