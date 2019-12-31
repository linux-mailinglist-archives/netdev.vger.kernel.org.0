Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8920F12D61A
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 05:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfLaET5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 23:19:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50432 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfLaET4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 23:19:56 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D0F2D13EF099B;
        Mon, 30 Dec 2019 20:19:55 -0800 (PST)
Date:   Mon, 30 Dec 2019 20:19:55 -0800 (PST)
Message-Id: <20191230.201955.97738480102485597.davem@davemloft.net>
To:     vdronov@redhat.com
Cc:     linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        richardcochran@gmail.com, aviro@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ptp: fix the race between the release of ptp_clock
 and cdev
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191227022627.24476-1-vdronov@redhat.com>
References: <20191208195340.GX4203@ZenIV.linux.org.uk>
        <20191227022627.24476-1-vdronov@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Dec 2019 20:19:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladis Dronov <vdronov@redhat.com>
Date: Fri, 27 Dec 2019 03:26:27 +0100

> In a case when a ptp chardev (like /dev/ptp0) is open but an underlying
> device is removed, closing this file leads to a race. This reproduces
> easily in a kvm virtual machine:
 . ..
> This happens in:
> 
> static void __fput(struct file *file)
> {   ...
>     if (file->f_op->release)
>         file->f_op->release(inode, file); <<< cdev is kfree'd here
>     if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL &&
>              !(mode & FMODE_PATH))) {
>         cdev_put(inode->i_cdev); <<< cdev fields are accessed here
> 
> Namely:
> 
> __fput()
>   posix_clock_release()
>     kref_put(&clk->kref, delete_clock) <<< the last reference
>       delete_clock()
>         delete_ptp_clock()
>           kfree(ptp) <<< cdev is embedded in ptp
>   cdev_put
>     module_put(p->owner) <<< *p is kfree'd, bang!
> 
> Here cdev is embedded in posix_clock which is embedded in ptp_clock.
> The race happens because ptp_clock's lifetime is controlled by two
> refcounts: kref and cdev.kobj in posix_clock. This is wrong.
> 
> Make ptp_clock's sysfs device a parent of cdev with cdev_device_add()
> created especially for such cases. This way the parent device with its
> ptp_clock is not released until all references to the cdev are released.
> This adds a requirement that an initialized but not exposed struct
> device should be provided to posix_clock_register() by a caller instead
> of a simple dev_t.
> 
> This approach was adopted from the commit 72139dfa2464 ("watchdog: Fix
> the race between the release of watchdog_core_data and cdev"). See
> details of the implementation in the commit 233ed09d7fda ("chardev: add
> helper function to register char devs with a struct device").
> 
> Link: https://lore.kernel.org/linux-fsdevel/20191125125342.6189-1-vdronov@redhat.com/T/#u
> Analyzed-by: Stephen Johnston <sjohnsto@redhat.com>
> Analyzed-by: Vern Lovejoy <vlovejoy@redhat.com>
> Signed-off-by: Vladis Dronov <vdronov@redhat.com>

Applied, thanks.
