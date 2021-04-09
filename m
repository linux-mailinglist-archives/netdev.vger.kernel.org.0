Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AECE35959C
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 08:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbhDIGgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 02:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233433AbhDIGgW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 02:36:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6905B610A4;
        Fri,  9 Apr 2021 06:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617950170;
        bh=Pa6sc6KdgMU8OPM8MPPDIysVIiBGA9HtFAZWYbwr3Ws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SfZgeUIJEHlgFk6MpgwpQoVi74BDBevhrltQqWRXemdWRQftn0W7eHlhaw4+zG3Xq
         +DhRc1xBdg37Ls/w6KoWhZJP5pTet8PvKHHVzZ5KEKcgJ84Y73K8dfOSMnZgUkr+RQ
         g/Svk8mUI3QGxTkWd1B63+Tl378y6YgBRtTTUcYg=
Date:   Fri, 9 Apr 2021 08:36:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jianmin Wang <jianmin@iscas.ac.cn>
Cc:     davem@davemloft.net, dzickus@redhat.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, omosnace@redhat.com, smueller@chronox.de,
        stable@vger.kernel.org, steffen.klassert@secunet.com
Subject: Re: Re: [PATCH] backports: crypto user - make NETLINK_CRYPTO work
Message-ID: <YG/11xcauoPY0sn+@kroah.com>
References: <YGs3Voq0codXCHbA@kroah.com>
 <20210408191148.51259-1-jianmin@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408191148.51259-1-jianmin@iscas.ac.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 07:11:48PM +0000, Jianmin Wang wrote:
> On Mon, Apr 05, 2021 at 16:14 UTC, Greg KH wrote:
> > On Mon, Apr 05, 2021 at 01:55:15PM +0000, Jianmin Wang wrote:
> > > There is same problem found in linux 4.19.y as upstream commit. The 
> > > changes of crypto_user_* and cryptouser.h files from upstream patch are merged into 
> > > crypto/crypto_user.c for backporting.
> > > 
> > > Upstream commit:
> > >     commit 91b05a7e7d8033a90a64f5fc0e3808db423e420a
> > >     Author: Ondrej Mosnacek <omosnace@redhat.com>
> > >     Date:   Tue,  9 Jul 2019 13:11:24 +0200
> > > 
> > >     Currently, NETLINK_CRYPTO works only in the init network namespace. It
> > >     doesn't make much sense to cut it out of the other network namespaces,
> > >     so do the minor plumbing work necessary to make it work in any network
> > >     namespace. Code inspired by net/core/sock_diag.c.
> > > 
> > >     Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> > >     Signed-off-by: default avatarHerbert Xu <herbert@gondor.apana.org.au>
> > > 
> > > Signed-off-by: Jianmin Wang <jianmin@iscas.ac.cn>
> > > ---
> > >  crypto/crypto_user.c        | 37 +++++++++++++++++++++++++------------
> > >  include/net/net_namespace.h |  3 +++
> > >  2 files changed, 28 insertions(+), 12 deletions(-)
> > 
> > How does this change fit with the stable kernel rules?  It looks to be a
> > new feature, if you need this, why not just use a newer kernel version?
> > What is preventing you from doing that?
> > 
> 
> This problem was found when we deployed new services on our container cluster, 
> while the new services need to invoke libkcapi in the container environment.
> 
> We have verified that the problem doesn't exist on newer kernel version. 
> However, due to many services and the cluster running on many server machines 
> whose host os are long-term linux distribution with linux 4.19 kernel, it will 
> cost too much to migrate them to newer os with newer kernel version. This is 
> why we need to fix the problem on linux 4.19.

But this is not a regression, but rather a "resolve an issue that has
never worked for new hardware", right?

And for that, moving to a new kernel seems like a wise thing to do to
me because we do not like backporting new features.  Distro kernel are
of course, free to do that if they wish.

thanks,

greg k-h
