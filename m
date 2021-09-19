Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E7C410905
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 03:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240861AbhISBJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 21:09:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47994 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238518AbhISBI7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Sep 2021 21:08:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nL18oKTsJnXMuI7Uj1KcorP98hu2ZVKA/UF04jm1Rog=; b=IuJ5+f6CvGjzl2+XUSTeNtkIHP
        NVU6JQbZ3Zn2K8TjobQWj4uiiLaTKJSe+47n5iou3CbxcDZ9YSBnksW1ISma5c8rBBRYqApjO9DvX
        QfE0DHqj3Xd03QvzqucTqPEv4SKL4WtJGwFYom+c+wcnglzjK+joce6iiRn0eGPBgbcA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mRlIs-007HSt-2f; Sun, 19 Sep 2021 03:07:34 +0200
Date:   Sun, 19 Sep 2021 03:07:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next] ipmr: ip6mr: APIs to support adding more
 than MAXVIFS/MAXMIFS
Message-ID: <YUaNVvSGoQ1+vcoa@lunn.ch>
References: <20210917224123.410009-1-ssuryaextr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210917224123.410009-1-ssuryaextr@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 06:41:23PM -0400, Stephen Suryaputra wrote:
> MAXVIFS and MAXMIFS are too small (32) for certain applications. But
> they are defined in user header files  So, use a different definition
> CONFIG_IP_MROUTE_EXT_MAXVIFS that is configurable and different ioctl
> requests (MRT_xyz_EXT and MRT6_xyz_EXT) as well as a different structure
> for adding MFC (mfcctl_ext).
> 
> CONFIG_IP_MROUTE_EXT_MAXVIFS is bounded by the IF_SETSIZE (256) in
> mroute6.h.
> 
> This patch is extending the following RFC:
> http://patchwork.ozlabs.org/project/netdev/patch/m1eiis8uc6.fsf@fess.ebiederm.org/

Quoting the above URL:

> My goal is an API that works with just a recompile of existing
> applications, and an ABI that continues to work for old applications.

Does this really work? Does the distribution version of mrouted use
the kernel UAPI headers of the running kernel? Can i upgrade to a
newer kernel, with newer headers, and it automagically pulls in a new
mrouted built using the new kernel headers? I think not. ethtool has
its own copy of the kernel headers. mrouted uses
/usr/include/linux/mroute.h which is provided by
linux-libc-dev:amd64. That is not tied to the running kernel. What
about quagga?

So in effect, you have to ask the running kernel, what value is it
using for MAXVIFS? Which means it is much more than just a recompile.
So i doubt think you can achieve this goal.

Given that, i really think you should spend the time to do a proper
solution. Add a netlink based API, which does not have the 32 limit.
Make the kernel implementation be based on a linked list. Have the
ioctl interface simply return the first 32 entries and ignore anything
above that.

      Andrew
