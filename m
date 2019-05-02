Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 901D9111C8
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 05:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfEBDFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 23:05:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44140 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbfEBDFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 23:05:20 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hM210-0001NK-Lx; Thu, 02 May 2019 03:04:06 +0000
Date:   Thu, 2 May 2019 04:04:06 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Wenbin Zeng <wenbin.zeng@gmail.com>
Cc:     davem@davemloft.net, bfields@fieldses.org, jlayton@kernel.org,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        wenbinzeng@tencent.com, dsahern@gmail.com,
        nicolas.dichtel@6wind.com, willy@infradead.org,
        edumazet@google.com, jakub.kicinski@netronome.com,
        tyhicks@canonical.com, chuck.lever@oracle.com, neilb@suse.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 1/3] nsfs: add evict callback into struct
 proc_ns_operations
Message-ID: <20190502030406.GT23075@ZenIV.linux.org.uk>
References: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
 <1556692945-3996-2-git-send-email-wenbinzeng@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556692945-3996-2-git-send-email-wenbinzeng@tencent.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 01, 2019 at 02:42:23PM +0800, Wenbin Zeng wrote:
> The newly added evict callback shall be called by nsfs_evict(). Currently
> only put() callback is called in nsfs_evict(), it is not able to release
> all netns refcount, for example, a rpc client holds two netns refcounts,
> these refcounts are supposed to be released when the rpc client is freed,
> but the code to free rpc client is normally triggered by put() callback
> only when netns refcount gets to 0, specifically:
>     refcount=0 -> cleanup_net() -> ops_exit_list -> free rpc client
> But netns refcount will never get to 0 before rpc client gets freed, to
> break the deadlock, the code to free rpc client can be put into the newly
> added evict callback.
> 
> Signed-off-by: Wenbin Zeng <wenbinzeng@tencent.com>
> ---
>  fs/nsfs.c               | 2 ++
>  include/linux/proc_ns.h | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/fs/nsfs.c b/fs/nsfs.c
> index 60702d6..5939b12 100644
> --- a/fs/nsfs.c
> +++ b/fs/nsfs.c
> @@ -49,6 +49,8 @@ static void nsfs_evict(struct inode *inode)
>  	struct ns_common *ns = inode->i_private;
>  	clear_inode(inode);
>  	ns->ops->put(ns);
> +	if (ns->ops->evict)
> +		ns->ops->evict(ns);

What's to guarantee that ns will not be freed by ->put()?
Confused...
