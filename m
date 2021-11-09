Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E6E44B1E1
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 18:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240657AbhKIRX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 12:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237296AbhKIRX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 12:23:59 -0500
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26124C061764;
        Tue,  9 Nov 2021 09:21:13 -0800 (PST)
Received: by fieldses.org (Postfix, from userid 2815)
        id 974F7A80; Tue,  9 Nov 2021 12:21:11 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 974F7A80
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1636478471;
        bh=7Yfhs6mgnlAbRfDJtqysXWuoXj0URoLB6EAUKOJhcUo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F/j1fnRLd7T2nDlO4VRk53OAJPUuArhmrTcTA33IWgZrQ2Zu4ojzg9ng6mgl8O44i
         buWApg3fqk90hJemS9xChQ62jrufahKwuwiy+BQ7bjQFYMWG2TOvfT558Uvjc9IAmd
         f/YrFzNAhUTOqxATZRYin11SScH2fAr+fCdV5pN0=
Date:   Tue, 9 Nov 2021 12:21:11 -0500
From:   "bfields@fieldses.org" <bfields@fieldses.org>
To:     "wanghai (M)" <wanghai38@huawei.com>
Cc:     Trond Myklebust <trondmy@hammerspace.com>,
        "neilb@suse.com" <neilb@suse.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "tyhicks@canonical.com" <tyhicks@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "christian.brauner@ubuntu.com" <christian.brauner@ubuntu.com>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "tom@talpey.com" <tom@talpey.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "timo@rothenpieler.org" <timo@rothenpieler.org>,
        "jiang.wang@bytedance.com" <jiang.wang@bytedance.com>,
        "kuniyu@amazon.co.jp" <kuniyu@amazon.co.jp>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Rao.Shoaib@oracle.com" <Rao.Shoaib@oracle.com>,
        "wenbin.zeng@gmail.com" <wenbin.zeng@gmail.com>,
        "kolga@netapp.com" <kolga@netapp.com>
Subject: Re: [PATCH net 2/2] auth_gss: Fix deadlock that blocks
 rpcsec_gss_exit_net when use-gss-proxy==1
Message-ID: <20211109172111.GA5227@fieldses.org>
References: <a845b544c6592e58feeaff3be9271a717f53b383.camel@hammerspace.com>
 <20210928134952.GA25415@fieldses.org>
 <77051a059fa19a7ae2390fbda7f8ab6f09514dfc.camel@hammerspace.com>
 <20210928141718.GC25415@fieldses.org>
 <cc92411f242290b85aa232e7220027b875942f30.camel@hammerspace.com>
 <20210928145747.GD25415@fieldses.org>
 <8b0e774bdb534c69b0612103acbe61c628fde9b1.camel@hammerspace.com>
 <20210928154300.GE25415@fieldses.org>
 <20210929211211.GC20707@fieldses.org>
 <ba12c503-401d-9b22-be83-7645c619d9d1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ba12c503-401d-9b22-be83-7645c619d9d1@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 09:56:03AM +0800, wanghai (M) wrote:
> 
> 在 2021/9/30 5:12, bfields@fieldses.org 写道:
> >On Tue, Sep 28, 2021 at 11:43:00AM -0400, bfields@fieldses.org wrote:
> >>On Tue, Sep 28, 2021 at 03:36:58PM +0000, Trond Myklebust wrote:
> >>>What is the use case here? Starting the gssd daemon or knfsd in
> >>>separate chrooted environments? We already know that they have to be
> >>>started in the same net namespace, which pretty much ensures it has to
> >>>be the same container.
> >>Somehow I forgot that knfsd startup is happening in some real process's
> >>context too (not just a kthread).
> >>
> >>OK, great, I agree, that sounds like it should work.

Ugh, took me a while to get back to this and I went down a couple dead
ends.

The result from selinux's point of view is that rpc.nfsd is doing things
it previously only expected gssproxy to do.  Fixable with an update to
selinux policy.  And easily fixed in the meantime by cut-and-pasting the
suggestions from the logs.

Still, the result's that mounts fail when you update the kernel, which
seems a violation of our usual rules about regressions.  I'd like to do
better.

--b.
