Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94F2016F058
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 21:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbgBYUqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 15:46:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727624AbgBYUqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 15:46:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC60520675;
        Tue, 25 Feb 2020 20:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582663576;
        bh=4IWGZkg45H4wwTJtRfLUUjItUN8vOEIOKvgXXkO48Ws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iOW/0dQ1nMgVUxUvb8Ly1JCK6yWLNLEbKpLGtLM2DH+s361gQ89XpGOTsitOHm4EP
         tIqB1M6SForyzr64pIxrAInpJwS0d/CIcxQ1Y21vGmYLN1ZXwMkkB3417fo0qskFcz
         hr8f7Pz6oOgNg54re0P8PRA5VfAD0+S8mXFWi8NI=
Date:   Tue, 25 Feb 2020 21:46:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     stable <stable@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        zdai@linux.vnet.ibm.com,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        zdai@us.ibm.com, David Miller <davem@davemloft.net>
Subject: Re: [RFC PATCH v2] e1000e: Use rtnl_lock to prevent race conditions
 between net and pci/pm
Message-ID: <20200225204613.GA14366@kroah.com>
References: <CAKgT0UdwqGGKvaSJ+3vd-_d-6t9MB=No+7SpkbOT2PnynRK+2w@mail.gmail.com>
 <20191007172559.11166.29328.stgit@localhost.localdomain>
 <681404C7-9015-4C64-B8FE-2C93D75A7318@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <681404C7-9015-4C64-B8FE-2C93D75A7318@canonical.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 05:42:26PM +0800, Kai-Heng Feng wrote:
> Hi Greg,
> 
> > On Oct 8, 2019, at 01:27, Alexander Duyck <alexander.duyck@gmail.com> wrote:
> > 
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > 
> > This patch is meant to address possible race conditions that can exist
> > between network configuration and power management. A similar issue was
> > fixed for igb in commit 9474933caf21 ("igb: close/suspend race in
> > netif_device_detach").
> > 
> > In addition it consolidates the code so that the PCI error handling code
> > will essentially perform the power management freeze on the device prior to
> > attempting a reset, and will thaw the device afterwards if that is what it
> > is planning to do. Otherwise when we call close on the interface it should
> > see it is detached and not attempt to call the logic to down the interface
> > and free the IRQs again.
> > 
> >> From what I can tell the check that was adding the check for __E1000_DOWN
> > in e1000e_close was added when runtime power management was added. However
> > it should not be relevant for us as we perform a call to
> > pm_runtime_get_sync before we call e1000_down/free_irq so it should always
> > be back up before we call into this anyway.
> > 
> > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> Please merge this commit, a7023819404ac9bd2bb311a4fafd38515cfa71ec to stable v5.14.
> 
> `modprobe -r e1000e` triggers a null pointer dereference [1] after the the following two patches are applied to v5.4.y:
> d635e7c4b34e6a630c7a1e8f1a8fd52c3e3ceea7 e1000e: Revert "e1000e: Make watchdog use delayed work"
> 21c6137939723ed6f5e4aec7882cdfc247304c27 e1000e: Drop unnecessary __E1000_DOWN bit twiddling

Now queued up, thanks.

greg k-h
