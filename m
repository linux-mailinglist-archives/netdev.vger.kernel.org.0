Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBDB1B51F3
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 03:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgDWBgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 21:36:42 -0400
Received: from mail.hallyn.com ([178.63.66.53]:53178 "EHLO mail.hallyn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbgDWBgm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 21:36:42 -0400
Received: by mail.hallyn.com (Postfix, from userid 1001)
        id AFB809D0; Wed, 22 Apr 2020 20:36:39 -0500 (CDT)
Date:   Wed, 22 Apr 2020 20:36:39 -0500
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
Subject: Re: [PATCH v2 6/7] loopfs: start attaching correct namespace during
 loop_add()
Message-ID: <20200423013639.GB2982@mail.hallyn.com>
References: <20200422145437.176057-1-christian.brauner@ubuntu.com>
 <20200422145437.176057-7-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422145437.176057-7-christian.brauner@ubuntu.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 04:54:36PM +0200, Christian Brauner wrote:
> Tag loop devices with the namespace the loopfs instance was mounted in.
> This has the consequence that loopfs devices carry the correct sysfs
> permissions for all their core files. All other devices files will
> continue to be correctly owned by the initial namespaces. Here is sample
> output:
> 
> root@b1:~# mount -t loop loop /mnt
> root@b1:~# ln -sf /mnt/loop-control /dev/loop-control
> root@b1:~# losetup -f
> /dev/loop8
> root@b1:~# ln -sf /mnt/loop8 /dev/loop8
> root@b1:~# ls -al /sys/class/block/loop8
> lrwxrwxrwx 1 root root 0 Apr  7 13:06 /sys/class/block/loop8 -> ../../devices/virtual/block/loop8
> root@b1:~# ls -al /sys/class/block/loop8/
> total 0
> drwxr-xr-x  9 root   root       0 Apr  7 13:06 .
> drwxr-xr-x 18 nobody nogroup    0 Apr  7 13:07 ..
> -r--r--r--  1 root   root    4096 Apr  7 13:06 alignment_offset
> lrwxrwxrwx  1 nobody nogroup    0 Apr  7 13:07 bdi -> ../../bdi/7:8
> -r--r--r--  1 root   root    4096 Apr  7 13:06 capability
> -r--r--r--  1 root   root    4096 Apr  7 13:06 dev
> -r--r--r--  1 root   root    4096 Apr  7 13:06 discard_alignment
> -r--r--r--  1 root   root    4096 Apr  7 13:06 events
> -r--r--r--  1 root   root    4096 Apr  7 13:06 events_async
> -rw-r--r--  1 root   root    4096 Apr  7 13:06 events_poll_msecs
> -r--r--r--  1 root   root    4096 Apr  7 13:06 ext_range
> -r--r--r--  1 root   root    4096 Apr  7 13:06 hidden
> drwxr-xr-x  2 nobody nogroup    0 Apr  7 13:07 holders
> -r--r--r--  1 root   root    4096 Apr  7 13:06 inflight
> drwxr-xr-x  2 nobody nogroup    0 Apr  7 13:07 integrity
> drwxr-xr-x  3 nobody nogroup    0 Apr  7 13:07 mq
> drwxr-xr-x  2 root   root       0 Apr  7 13:06 power
> drwxr-xr-x  3 nobody nogroup    0 Apr  7 13:07 queue
> -r--r--r--  1 root   root    4096 Apr  7 13:06 range
> -r--r--r--  1 root   root    4096 Apr  7 13:06 removable
> -r--r--r--  1 root   root    4096 Apr  7 13:06 ro
> -r--r--r--  1 root   root    4096 Apr  7 13:06 size
> drwxr-xr-x  2 nobody nogroup    0 Apr  7 13:07 slaves
> -r--r--r--  1 root   root    4096 Apr  7 13:06 stat
> lrwxrwxrwx  1 nobody nogroup    0 Apr  7 13:07 subsystem -> ../../../../class/block
> drwxr-xr-x  2 root   root       0 Apr  7 13:06 trace
> -rw-r--r--  1 root   root    4096 Apr  7 13:06 uevent
> root@b1:~#
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>

I was a *bit* worried about not taking a reference to the
user namespace, but it doesn't look like the chain of
loop_remove() -> del_gendisk() -> device_del() will allow any later
access through sysfs, so I guess it's fine.

Reviewed-by: Serge Hallyn <serge@hallyn.com>

> ---
> /* v2 */
> unchanged
> - Christian Brauner <christian.brauner@ubuntu.com>:
>   - Adapted commit message otherwise unchanged.
> ---
>  drivers/block/loop.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 8e21d4b33e01..2dc53bad4b48 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -2212,6 +2212,10 @@ static int loop_add(struct loop_device **l, int i, struct inode *inode)
>  	disk->private_data	= lo;
>  	disk->queue		= lo->lo_queue;
>  	sprintf(disk->disk_name, "loop%d", i);
> +#ifdef CONFIG_BLK_DEV_LOOPFS
> +	if (loopfs_i_sb(inode))
> +		disk->user_ns = loopfs_i_sb(inode)->s_user_ns;
> +#endif
>  
>  	add_disk(disk);
>  
> -- 
> 2.26.1
