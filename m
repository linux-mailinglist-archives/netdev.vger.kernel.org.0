Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4C91A051F
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 05:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgDGDGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 23:06:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35264 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgDGDGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 23:06:53 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jLeXx-00Cj0A-0P; Tue, 07 Apr 2020 03:05:05 +0000
Date:   Tue, 7 Apr 2020 04:05:04 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Levi <ppbuk5246@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, gnault@redhat.com,
        nicolas.dichtel@6wind.com, edumazet@google.com,
        lirongqing@baidu.com, tglx@linutronix.de, johannes.berg@intel.com,
        dhowells@redhat.com, daniel@iogearbox.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netns: dangling pointer on netns bind mount point.
Message-ID: <20200407030504.GX23230@ZenIV.linux.org.uk>
References: <20200407023512.GA25005@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407023512.GA25005@ubuntu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 07, 2020 at 11:35:46AM +0900, Levi wrote:
> When we try to bind mount on network namespace (ex) /proc/{pid}/ns/net,
> inode's private data can have dangling pointer to net_namespace that was
> already freed in below case.
> 
>     1. Forking the process.
>     2. [PARENT] Waiting the Child till the end.
>     3. [CHILD] call unshare for creating new network namespace
>     4. [CHILD] Bind mount with /proc/self/ns/net to some mount point.
>     5. [CHILD] Exit child.
>     6. [PARENT] Try to setns with binded mount point
> 
> In step 5, net_namespace made by child process'll be freed,
> But in bind mount point, it still held the pointer to net_namespace made
> by child process.
> In this situation, when parent try to call "setns" systemcall with the
> bind mount point, parent process try to access to freed memory, That
> makes memory corruption.
> 
> This patch fix the above scenario by increaseing reference count.

This can't be the right fix.

> +#ifdef CONFIG_NET_NS
> +	if (!(flag & CL_COPY_MNT_NS_FILE) && is_net_ns_file(root)) {
> +		ns = get_proc_ns(d_inode(root));
> +		if (ns == NULL || ns->ops->type != CLONE_NEWNET) {
> +			err = -EINVAL;
> +
> +			goto out_free;
> +		}
> +
> +		net = to_net_ns(ns);
> +		net = get_net(net);

No.  This is completely wrong.  You have each struct mount pointing to
that sucker to grab an extra reference on an object; you do *NOT* drop
said reference when struct mount is destroyed.  You are papering over
a dangling pointer of some sort by introducing a trivially exploitable
leak that happens to hit your scenario.

Hell, do (your step 4 + umount your mountpoint) in a loop, then watch what
happens to refcounts with that patch.

This is bollocks; the reference is *NOT* in struct mount.  At all.
It's not even in struct dentry.  What it's attached to is struct
inode and it should be pinned as long as that inode is alive -
it's dropped in nsfs_evict().  And if _that_ gets called while
dentry is still pinned (as ->mnt_root of something), you have
much worse problems.

Could you post a reproducer, preferably one that would trigger an oops
on mainline?
