Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8E73EFE94
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 10:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239537AbhHRIFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 04:05:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239112AbhHRIDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 04:03:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4438D60EB5;
        Wed, 18 Aug 2021 08:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629273792;
        bh=5FpJoSsWAijWF1s+2IOmDRgN6RifYoWI9x/j4oSsSuo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eCjsWayN9W0nDaLKUgwVjLP37cSR+eyzVa0lW+E3UgnWM8Ed+d2Ht97prOHtEab2/
         X/x71YQb858la7JnAqUYjETDTaVoI228RR2bOvzi2OgjMVIlBlbZ/8S+YfbPlvuRmA
         qDyrCBWHP1jugX/jb0oNaBEO+69SPhZPEsL2XnfzI82tOaQvvxwQWf2JUtBdrTIfce
         C/L6LJmsBpGkFD6E+64WmOyCKq09uOEPezgI9Hl0j2zREAGQdwlgdGVajFmuLq70Dg
         dLof8zrC4r3wJKXv/W4ZxGmO8mrOtxCLU11Mxet2Amkm8KUuNk49BpAAlV2VYx+8An
         Dgwl0rIg9ooWw==
Date:   Wed, 18 Aug 2021 11:03:09 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Salil Mehta <salil.mehta@huawei.com>,
        Shannon Nelson <snelson@pensando.io>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: Re: [PATCH net-next 3/6] devlink: Count struct devlink consumers
Message-ID: <YRy+vc6nAZadagxT@unreal>
References: <cover.1628933864.git.leonro@nvidia.com>
 <d4d59d801f4521e562c9ecf2d8767077aaefb456.1628933864.git.leonro@nvidia.com>
 <20210816084741.1dd1c415@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRqKCVbjTZaSrSy+@unreal>
 <20210816090700.313a54ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816090700.313a54ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 09:07:00AM -0700, Jakub Kicinski wrote:
> On Mon, 16 Aug 2021 18:53:45 +0300 Leon Romanovsky wrote:
> > On Mon, Aug 16, 2021 at 08:47:41AM -0700, Jakub Kicinski wrote:
> > > On Sat, 14 Aug 2021 12:57:28 +0300 Leon Romanovsky wrote:  
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > The struct devlink itself is protected by internal lock and doesn't
> > > > need global lock during operation. That global lock is used to protect
> > > > addition/removal new devlink instances from the global list in use by
> > > > all devlink consumers in the system.
> > > > 
> > > > The future conversion of linked list to be xarray will allow us to
> > > > actually delete that lock, but first we need to count all struct devlink
> > > > users.  
> > > 
> > > Not a problem with this set but to state the obvious the global devlink
> > > lock also protects from concurrent execution of all the ops which don't
> > > take the instance lock (DEVLINK_NL_FLAG_NO_LOCK). You most likely know
> > > this but I thought I'd comment on an off chance it helps.  
> > 
> > The end goal will be something like that:
> > 1. Delete devlink lock
> > 2. Rely on xa_lock() while grabbing devlink instance (past devlink_try_get)
> > 3. Convert devlink->lock to be read/write lock to make sure that we can run
> > get query in parallel.
> > 4. Open devlink netlink to parallel ops, ".parallel_ops = true".
> 
> IIUC that'd mean setting eswitch mode would hold write lock on 
> the dl instance. What locks does e.g. registering a dl port take 
> then?

write lock, because we are adding port to devlink->port_list.
   9099 int devlink_port_register(struct devlink *devlink,
   9100                           struct devlink_port *devlink_port,
   9101                           unsigned int port_index)
   9102 {
   ...
   9115         list_add_tail(&devlink_port->list, &devlink->port_list);
