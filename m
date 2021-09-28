Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2734241B1E8
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 16:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241069AbhI1OS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 10:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240488AbhI1OS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 10:18:58 -0400
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6665C06161C;
        Tue, 28 Sep 2021 07:17:18 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id 4509125FE; Tue, 28 Sep 2021 10:17:18 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 4509125FE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1632838638;
        bh=V1v25WDPu4S65BGeMIG9F3Uek6zupyB1HkMjnsUWjjY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BkT+hA8zMLrUfTIYhc0zv215cClyhWm3iXoQZNNGIYsf0mIpYGE6uzhPwrA2mkjvb
         8VKXVmuP/J1NWFZAd7CmIEmmkgbbvRNe8Bs/fLZ3CeNB8jlsCmSBEmlH30Tse+jx+m
         6x7Lg665vUxRR2jRpTa/NQFB3lVTFK2ursVK3fN0=
Date:   Tue, 28 Sep 2021 10:17:18 -0400
From:   "bfields@fieldses.org" <bfields@fieldses.org>
To:     Trond Myklebust <trondmy@hammerspace.com>
Cc:     "neilb@suse.com" <neilb@suse.com>,
        "kolga@netapp.com" <kolga@netapp.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "tyhicks@canonical.com" <tyhicks@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wanghai38@huawei.com" <wanghai38@huawei.com>,
        "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "christian.brauner@ubuntu.com" <christian.brauner@ubuntu.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "kuniyu@amazon.co.jp" <kuniyu@amazon.co.jp>,
        "timo@rothenpieler.org" <timo@rothenpieler.org>,
        "jiang.wang@bytedance.com" <jiang.wang@bytedance.com>,
        "wenbin.zeng@gmail.com" <wenbin.zeng@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Rao.Shoaib@oracle.com" <Rao.Shoaib@oracle.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "tom@talpey.com" <tom@talpey.com>
Subject: Re: [PATCH net 2/2] auth_gss: Fix deadlock that blocks
 rpcsec_gss_exit_net when use-gss-proxy==1
Message-ID: <20210928141718.GC25415@fieldses.org>
References: <20210928031440.2222303-1-wanghai38@huawei.com>
 <20210928031440.2222303-3-wanghai38@huawei.com>
 <a845b544c6592e58feeaff3be9271a717f53b383.camel@hammerspace.com>
 <20210928134952.GA25415@fieldses.org>
 <77051a059fa19a7ae2390fbda7f8ab6f09514dfc.camel@hammerspace.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <77051a059fa19a7ae2390fbda7f8ab6f09514dfc.camel@hammerspace.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 02:04:49PM +0000, Trond Myklebust wrote:
> On Tue, 2021-09-28 at 09:49 -0400, bfields@fieldses.org wrote:
> > On Tue, Sep 28, 2021 at 01:30:17PM +0000, Trond Myklebust wrote:
> > > On Tue, 2021-09-28 at 11:14 +0800, Wang Hai wrote:
> > > > When use-gss-proxy is set to 1, write_gssp() creates a rpc client
> > > > in
> > > > gssp_rpc_create(), this increases the netns refcount by 2, these
> > > > refcounts are supposed to be released in rpcsec_gss_exit_net(),
> > > > but
> > > > it
> > > > will never happen because rpcsec_gss_exit_net() is triggered only
> > > > when
> > > > the netns refcount gets to 0, specifically:
> > > >     refcount=0 -> cleanup_net() -> ops_exit_list ->
> > > > rpcsec_gss_exit_net
> > > > It is a deadlock situation here, refcount will never get to 0
> > > > unless
> > > > rpcsec_gss_exit_net() is called. So, in this case, the netns
> > > > refcount
> > > > should not be increased.
> > > > 
> > > > In this case, xprt will take a netns refcount which is not
> > > > supposed
> > > > to be taken. Add a new flag to rpc_create_args called
> > > > RPC_CLNT_CREATE_NO_NET_REF for not increasing the netns refcount.
> > > > 
> > > > It is safe not to hold the netns refcount, because when
> > > > cleanup_net(), it
> > > > will hold the gssp_lock and then shut down the rpc client
> > > > synchronously.
> > > > 
> > > > 
> > > I don't like this solution at all. Adding this kind of flag is
> > > going to
> > > lead to problems down the road.
> > > 
> > > Is there any reason whatsoever why we need this RPC client to exist
> > > when there is no active knfsd server? IOW: Is there any reason why
> > > we
> > > shouldn't defer creating this RPC client for when knfsd starts up
> > > in
> > > this net namespace, and why we can't shut it down when knfsd shuts
> > > down?
> > 
> > The rpc create is done in the context of the process that writes to
> > /proc/net/rpc/use-gss-proxy to get the right namespaces.  I don't
> > know
> > how hard it would be capture that information for a later create.
> > 
> 
> svcauth_gss_proxy_init() uses the net namespace SVC_NET(rqstp) (i.e.
> the knfsd namespace) in the call to gssp_accept_sec_context_upcall().
> 
> IOW: the net namespace used in the call to find the RPC client is the
> one set up by knfsd, and so if use-gss-proxy was set in a different
> namespace than the one used by knfsd, then it won't be found.

Right.  If you've got multiple containers, you don't want to find a
gss-proxy from a different container.

--b.
