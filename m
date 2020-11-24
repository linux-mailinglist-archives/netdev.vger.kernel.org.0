Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302002C2CB1
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 17:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390338AbgKXQUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 11:20:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:54400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390253AbgKXQUh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 11:20:37 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52BA7206B7;
        Tue, 24 Nov 2020 16:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606234837;
        bh=yd+QKWkitCciGjPr96ntQMoPsKlnxIxjpeXnl8ke45Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wyPdqy3sGhL3E8GsQjXlNr6G+KBhWDWGhGGC755Gds6+qiPZEPWlXlkmWzi4EdTzk
         Z+hpNMtZc1hOggJ6MdDZQrTSIGrSrdfME2p6BipAop3X6wsorbNIbPIawA8yYYy2oP
         ByOuOH1FDhy1bxh6vSau74xzzQqu9NQmf/JnXbns=
Date:   Tue, 24 Nov 2020 08:20:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Leon Romanovsky <leon@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        virtualization@lists.linux-foundation.org,
        Amit Shah <amit@kernel.org>, Itay Aveksis <itayav@nvidia.com>,
        Ran Rozenstein <ranro@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: netconsole deadlock with virtnet
Message-ID: <20201124082035.3e658fa4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1133f1a4-6772-8aa3-41dd-edbc1ee76cee@redhat.com>
References: <20201117102341.GR47002@unreal>
        <20201117093325.78f1486d@gandalf.local.home>
        <X7SK9l0oZ+RTivwF@jagdpanzerIV.localdomain>
        <X7SRxB6C+9Bm+r4q@jagdpanzerIV.localdomain>
        <93b42091-66f2-bb92-6822-473167b2698d@redhat.com>
        <20201118091257.2ee6757a@gandalf.local.home>
        <20201123110855.GD3159@unreal>
        <20201123093128.701cf81b@gandalf.local.home>
        <20201123105252.1c295138@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201123140934.38748be3@gandalf.local.home>
        <20201123112130.759b9487@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1133f1a4-6772-8aa3-41dd-edbc1ee76cee@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 11:22:03 +0800 Jason Wang wrote:
> >> Perhaps you need the trylock in virtnet_poll_tx()?  
> > That could work. Best if we used normal lock if !!budget, and trylock
> > when budget is 0. But maybe that's too hairy.  
> 
> If we use trylock, we probably lose(or delay) tx notification that may 
> have side effects to the stack.

That's why I said only trylock with budget == 0. Only netpoll calls with
budget == 0, AFAIK.

> > I'm assuming all this trickiness comes from virtqueue_get_buf() needing
> > locking vs the TX path? It's pretty unusual for the completion path to
> > need locking vs xmit path.  
> 
> Two reasons for doing this:
> 
> 1) For some historical reason, we try to free transmitted tx packets in 
> xmit (see free_old_xmit_skbs() in start_xmit()), we can probably remove 
> this if we remove the non tx interrupt mode.
> 2) virtio core requires virtqueue_get_buf() to be synchronized with 
> virtqueue_add(), we probably can solve this but it requires some non 
> trivial refactoring in the virtio core
> 
> Btw, have a quick search, there are several other drivers that uses tx 
> lock in the tx NAPI.

Unless they do:

	netdev->priv_flags |= IFF_DISABLE_NETPOLL;

they are all broken.
