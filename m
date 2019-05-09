Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 789CC193D7
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 22:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfEIUwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 16:52:19 -0400
Received: from fieldses.org ([173.255.197.46]:33884 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726682AbfEIUwT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 May 2019 16:52:19 -0400
Received: by fieldses.org (Postfix, from userid 2815)
        id 96DCC1E19; Thu,  9 May 2019 16:52:18 -0400 (EDT)
Date:   Thu, 9 May 2019 16:52:18 -0400
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     Wenbin Zeng <wenbin.zeng@gmail.com>
Cc:     viro@zeniv.linux.org.uk, davem@davemloft.net, jlayton@kernel.org,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        wenbinzeng@tencent.com, dsahern@gmail.com,
        nicolas.dichtel@6wind.com, willy@infradead.org,
        edumazet@google.com, jakub.kicinski@netronome.com,
        tyhicks@canonical.com, chuck.lever@oracle.com, neilb@suse.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 0/3] auth_gss: netns refcount leaks when use-gss-proxy==1
Message-ID: <20190509205218.GA23548@fieldses.org>
References: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for figuring this out!

I guess I'll take these patches (with the one fix in your response to
Al) through the nfsd tree, unless someone tells me otherwise.  (The
original bug was introduced through nfsd.)

How serious are the consequences of the leak?  I'm wondering if it's
worth a stable cc or not.

--b.

On Wed, May 01, 2019 at 02:42:22PM +0800, Wenbin Zeng wrote:
> This patch series fixes an auth_gss bug that results in netns refcount leaks when use-gss-proxy is set to 1.
> 
> The problem was found in privileged docker containers with gssproxy service enabled and /proc/net/rpc/use-gss-proxy set to 1, the corresponding struct net->count ends up at 2 after container gets killed, the consequence is that the struct net cannot be freed.
> 
> It turns out that write_gssp() called gssp_rpc_create() to create a rpc client, this increases net->count by 2; rpcsec_gss_exit_net() is supposed to decrease net->count but it never gets called because its call-path is:
> 	net->count==0 -> cleanup_net -> ops_exit_list -> rpcsec_gss_exit_net
> Before rpcsec_gss_exit_net() gets called, net->count cannot reach 0, this is a deadlock situation.
> 
> To fix the problem, we must break the deadlock, rpcsec_gss_exit_net() should move out of the put() path and find another chance to get called, I think nsfs_evict() is a good place to go, when netns inode gets evicted we call rpcsec_gss_exit_net() to free the rpc client, this requires a new callback i.e. evict to be added in struct proc_ns_operations, and add netns_evict() as one of netns_operations as well.
> 
> Wenbin Zeng (3):
>   nsfs: add evict callback into struct proc_ns_operations
>   netns: add netns_evict into netns_operations
>   auth_gss: fix deadlock that blocks rpcsec_gss_exit_net when
>     use-gss-proxy==1
> 
>  fs/nsfs.c                      |  2 ++
>  include/linux/proc_ns.h        |  1 +
>  include/net/net_namespace.h    |  1 +
>  net/core/net_namespace.c       | 12 ++++++++++++
>  net/sunrpc/auth_gss/auth_gss.c |  9 ++++++---
>  5 files changed, 22 insertions(+), 3 deletions(-)
> 
> -- 
> 1.8.3.1
