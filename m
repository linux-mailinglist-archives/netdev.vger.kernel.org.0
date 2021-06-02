Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2761C398A23
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhFBNBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 09:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229579AbhFBNBM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 09:01:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 670E8613F0;
        Wed,  2 Jun 2021 12:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622638769;
        bh=3pTJF8Uw7RKI6z+SHgf84kmB3egP8O9uPLS0sfmmP6Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jJwn1XKGECVm249aCOaXizl2zxEJYlGwPip5pQSbzBVOUKTcvSD3V7A9zz/XUjvHQ
         9Djj/PboHWd1g7J0td/yAkFnHr7/xp/DNc9SC6HJElgU+Yq3Pnh06qK+ukHfRtdXSy
         XXF3oNcIYUWB4WOFV78kiyer8pUebR94BImLxLZJ4K2hWcx7VYfSzyHsPk2Zlynwgj
         9GhKGKcrYSH4iZD6S8i27OoT1OpGN43ejs6RHOBC07KsJiIGhRTNAE5WugiEg/tKUL
         2CLYyn7DKXbPUlhiFDYFYujTOJzs5gD5C73M1PxgBzeNRcjel5X1Kjby1l2/XbTwGt
         fwoN8lqTLZKHg==
Date:   Wed, 2 Jun 2021 15:59:25 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Guodeqing (A)" <geffrey.guo@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "mst@redhat.com" <mst@redhat.com>
Subject: Re: [PATCH] virtio-net: fix the kzalloc/kfree mismatch problem
Message-ID: <YLeArcxMkty2n/Xz@unreal>
References: <1621821978.04102-1-xuanzhuo@linux.alibaba.com>
 <36d1b92c-7dc5-f84e-ef86-980b15c39965@redhat.com>
 <YLccNiOW8UGFowli@unreal>
 <abcc9911-67d8-8764-b986-d749187d4977@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <abcc9911-67d8-8764-b986-d749187d4977@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 03:19:46PM +0800, Jason Wang wrote:
> 
> 在 2021/6/2 下午1:50, Leon Romanovsky 写道:
> > On Mon, May 24, 2021 at 10:37:14AM +0800, Jason Wang wrote:
> > > 在 2021/5/24 上午10:06, Xuan Zhuo 写道:
> > > > On Mon, 24 May 2021 01:48:53 +0000, Guodeqing (A) <geffrey.guo@huawei.com> wrote:
> > > > > > -----Original Message-----
> > > > > > From: Max Gurtovoy [mailto:mgurtovoy@nvidia.com]
> > > > > > Sent: Sunday, May 23, 2021 15:25
> > > > > > To: Guodeqing (A) <geffrey.guo@huawei.com>; mst@redhat.com
> > > > > > Cc: jasowang@redhat.com; davem@davemloft.net; kuba@kernel.org;
> > > > > > virtualization@lists.linux-foundation.org; netdev@vger.kernel.org
> > > > > > Subject: Re: [PATCH] virtio-net: fix the kzalloc/kfree mismatch problem
> > > > > > 
> > > > > > 
> > > > > > On 5/22/2021 11:02 AM, guodeqing wrote:
> > > > > > > If the virtio_net device does not suppurt the ctrl queue feature, the
> > > > > > > vi->ctrl was not allocated, so there is no need to free it.
> > > > > > you don't need this check.
> > > > > > 
> > > > > > from kfree doc:
> > > > > > 
> > > > > > "If @objp is NULL, no operation is performed."
> > > > > > 
> > > > > > This is not a bug. I've set vi->ctrl to be NULL in case !vi->has_cvq.
> > > > > > 
> > > > > > 
> > > > >     yes,  this is not a bug, the patch is just a optimization, because the vi->ctrl maybe
> > > > >     be freed which  was not allocated, this may give people a misunderstanding.
> > > > >     Thanks.
> > > > I think it may be enough to add a comment, and the code does not need to be
> > > > modified.
> > > > 
> > > > Thanks.
> > > 
> > > Or even just leave the current code as is. A lot of kernel codes was wrote
> > > under the assumption that kfree() should deal with NULL.
> > It is not assumption but standard practice that can be seen as side
> > effect of "7) Centralized exiting of functions" section of coding-style.rst.
> > 
> > Thanks
> 
> 
> I don't see the connection to the centralized exiting.
> 
> Something like:
> 
> if (foo)
>     kfree(foo);
> 
> won't break the centralization.

The key words are "side effect". Once you centralize everything, you
won't want to see "if (foo) kfree(foo)" spaghetti code.

Of course such construction doesn't break anything, but the idea is
to reduce useless code and not add it.

Thanks

> 
> Thanks
> 
> 
> > 
> 
