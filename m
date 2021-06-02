Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541013980D2
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 07:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbhFBFwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 01:52:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229779AbhFBFwc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 01:52:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A713161360;
        Wed,  2 Jun 2021 05:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622613050;
        bh=D52BA1TKwtARtppT4vzXwF1FMjDUS7v+afZJl5NMqhQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YAEe4BsGeoDBwhLRcW2MC+qqQPKO0RzuYvo855vjZ+7PlTdDhLa7hcMLN1hyLehy5
         cr8fSUnZVkuWitgEaiev4i+fkY8qpSuo2iPoduBxbbxlE2J/RpMyYDxfctDB0V44N0
         OeiOOWucg6Cb5DXQ0lXBPPGm3z11zg0is46/quMhY9DIO98PtSWrR0cK6PZ/YAw/CO
         FTD+lq2911PSop3DCY3/YF7/ZXAawuPzE2dJOtq2BBTreJ4mS0InA6q0TAg+K9ER4Z
         gz4N/x+wfz9CqieFL1G7O/QiMjnqLidqzBOAh+F9kcZd3YFvb0XCyoaSEnCVsUDCPh
         N3UiCLC2H4LMg==
Date:   Wed, 2 Jun 2021 08:50:46 +0300
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
Message-ID: <YLccNiOW8UGFowli@unreal>
References: <1621821978.04102-1-xuanzhuo@linux.alibaba.com>
 <36d1b92c-7dc5-f84e-ef86-980b15c39965@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <36d1b92c-7dc5-f84e-ef86-980b15c39965@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 10:37:14AM +0800, Jason Wang wrote:
> 
> 在 2021/5/24 上午10:06, Xuan Zhuo 写道:
> > On Mon, 24 May 2021 01:48:53 +0000, Guodeqing (A) <geffrey.guo@huawei.com> wrote:
> > > 
> > > > -----Original Message-----
> > > > From: Max Gurtovoy [mailto:mgurtovoy@nvidia.com]
> > > > Sent: Sunday, May 23, 2021 15:25
> > > > To: Guodeqing (A) <geffrey.guo@huawei.com>; mst@redhat.com
> > > > Cc: jasowang@redhat.com; davem@davemloft.net; kuba@kernel.org;
> > > > virtualization@lists.linux-foundation.org; netdev@vger.kernel.org
> > > > Subject: Re: [PATCH] virtio-net: fix the kzalloc/kfree mismatch problem
> > > > 
> > > > 
> > > > On 5/22/2021 11:02 AM, guodeqing wrote:
> > > > > If the virtio_net device does not suppurt the ctrl queue feature, the
> > > > > vi->ctrl was not allocated, so there is no need to free it.
> > > > you don't need this check.
> > > > 
> > > > from kfree doc:
> > > > 
> > > > "If @objp is NULL, no operation is performed."
> > > > 
> > > > This is not a bug. I've set vi->ctrl to be NULL in case !vi->has_cvq.
> > > > 
> > > > 
> > >    yes,  this is not a bug, the patch is just a optimization, because the vi->ctrl maybe
> > >    be freed which  was not allocated, this may give people a misunderstanding.
> > >    Thanks.
> > 
> > I think it may be enough to add a comment, and the code does not need to be
> > modified.
> > 
> > Thanks.
> 
> 
> Or even just leave the current code as is. A lot of kernel codes was wrote
> under the assumption that kfree() should deal with NULL.

It is not assumption but standard practice that can be seen as side
effect of "7) Centralized exiting of functions" section of coding-style.rst.

Thanks
