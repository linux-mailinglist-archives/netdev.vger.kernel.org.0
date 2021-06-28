Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0194B3B5B4E
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 11:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbhF1JdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 05:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:32900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232426AbhF1JdL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 05:33:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D96461C5A;
        Mon, 28 Jun 2021 09:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624872646;
        bh=tko4HhpTn1KfqSQcG6rk256TdCkSHRTiZNDg1gfOL1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mdirt+wh3MtaZ7eNyZ9G3nbYCW5idUpb0uLyW3y3Pff8g1i8FeRt120hCx8rMfLOA
         LnRoyQZ6znqLxXb5WQ4POqk3nvJJlxgEnyIMLyf/4xRDnJ3jrCYholI79Dx7JQswRh
         BPPsck43uFy1epGSrPj0zjj0CnIzhGXT51/oNF84=
Date:   Mon, 28 Jun 2021 11:30:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, bpf@vger.kernel.org,
        wsd_upstream@mediatek.com, chao.song@mediatek.com,
        kuohong.wang@mediatek.com
Subject: Re: [PATCH 4/4] drivers: net: mediatek: initial implementation of
 ccmni
Message-ID: <YNmWwSsZ02iigiHC@kroah.com>
References: <YNS4GzYHpxMWIH+1@kroah.com>
 <20210628071829.14925-1-rocco.yue@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210628071829.14925-1-rocco.yue@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 03:18:30PM +0800, Rocco Yue wrote:
> On Thu, 2021-06-24 at 18:51 +0200, Greg KH wrote:
> On Thu, Jun 24, 2021 at 11:55:02PM +0800, Rocco Yue wrote:
> >> On Thu, 2021-06-24 at 14:23 +0200, Greg KH wrote:
> >> On Thu, Jun 24, 2021 at 07:53:49PM +0800, Rocco Yue wrote:
> >>> 
> >>> not have exports that no one uses.  Please add the driver to this patch
> >>> series when you resend it.
> >>> 
> >> 
> >> I've just took a look at what the Linux staging tree is. It looks like
> >> a good choice for the current ccmni driver.
> >> 
> >> honstly, If I simply upload the relevant driver code B that calls
> >> A (e.g. ccmni_rx_push), there is still a lack of code to call B.
> >> This seems to be a continuty problem, unless all drivers codes are
> >> uploaded (e.g. power on modem, get hardware status, complete tx/rx flow).
> > 
> > Great, send it all!  Why is it different modules, it's only for one
> > chunk of hardware, no need to split it up into tiny pieces.  That way
> > only causes it to be more code overall.
> > 
> >> 
> >> Thanks~
> >> 
> >> Can I resend patch set as follows:
> >> (1) supplement the details of pureip for patch 1/4;
> >> (2) the document of ccmni.rst still live in the Documentation/...
> >> (3) modify ccmni and move it into the drivers/staging/...
> > 
> > for drivers/staging/ the code needs to be "self contained" in that it
> > does not require adding anything outside of the directory for it.
> > 
> > If you still require this core networking change, that needs to be
> > accepted first by the networking developers and maintainers.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Hi Greg,
> 
> I am grateful for your help.
> 
> Both ccmni change and networking changes are needed, because as far
> as I know, usually a device type should have at least one device to
> use it, and pureip is what the ccmni driver needs, so I uploaded the
> networking change and ccmni driver together;
> 
> Since MTK’s modem driver has a large amount of code and strong code
> coupling, it takes some time to clean up them. At this stage, it may
> be difficult to upstream all the codes together.

Why?  Just dump the whole thing in a drivers/staging/mtk/ directory
structure and all should be fine.

> During this period, even if ccmni is incomplete, can I put the ccmni
> driver initial code in the driver/staging first ? After that, we will
> gradually implement more functions of ccmni in the staging tree, and
> we can also gradually sort out and clean up modem driver in the staging.

I do not know, let's see the code first.  But we can not add frameworks
with no in-kernel users, as that does not make any sense at all.

> In addition, due to the requirements of GKI 2.0,

That is a Google requirement, not a kernel.org requirement.  Please work
with Google if you have questions/issues about that, there is NOTHING we
can do about that here in the community for obvious reasons.

> if ccmni device
> uses RAWIP or NONE, it will hit ipv6 issue; and if ccmni uses
> a device type other than PUREIP/RAWIP/NONE, there will be tethering
> ebpf offload or clat ebpf offload can not work problems.
> 
> I hope PUREIP and ccmni can be accepted by the Linux community.

As I stated before you need to have an in-kernel user for us to be able
to accept frameworks and functions into the tree.  Otherwise Linux would
quickly become unmanagable and unmaintainable.  Would you want to try to
maintain code with no in-tree users?  What would you do if you were in
our position?

But for networking flags like this that go into userspace, I do not know
what the maintainers of the networking stack require, so that really is
up to them, not me.

thanks,

greg k-h
