Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08641C1D7E
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 21:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730420AbgEATBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 15:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729766AbgEATBh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 15:01:37 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E56D0216FD;
        Fri,  1 May 2020 19:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588359697;
        bh=YO7TyX0Z7RPOmGLtACV+lV3CwsmKjanuOFBqcDZUCi4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sqlk1ktjOJV7RaTL+ff/j0w5oDtmYQpBqykPEat2hDx5YtNJRmOpdUH9BDoaHGDoK
         I2MqiYl6MZmU7k2rWzkH4J95VKdDRDFarPZDWBEOKmmEH2hjPIoA9ZlgJv1VBNkkD8
         7aL3U60xEQXHU/ehu9nJZhK2dJqFX6sHNBUARJ9U=
Date:   Fri, 1 May 2020 12:01:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next V2] net: sched: fallback to qdisc noqueue if
 default qdisc setup fail
Message-ID: <20200501120135.51fc2b1b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200501135602.0671c73d@carbon>
References: <158824694174.2180470.8094886910962590764.stgit@firesoul>
        <20200430124549.3272afb1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200501135602.0671c73d@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 1 May 2020 13:56:02 +0200 Jesper Dangaard Brouer wrote:
> On Thu, 30 Apr 2020 12:45:49 -0700
> Jakub Kicinski <kuba@kernel.org> wrote:
> 
> > On Thu, 30 Apr 2020 13:42:22 +0200 Jesper Dangaard Brouer wrote:  
> > > Currently if the default qdisc setup/init fails, the device ends up with
> > > qdisc "noop", which causes all TX packets to get dropped.
> > > 
> > > With the introduction of sysctl net/core/default_qdisc it is possible
> > > to change the default qdisc to be more advanced, which opens for the
> > > possibility that Qdisc_ops->init() can fail.
> > > 
> > > This patch detect these kind of failures, and choose to fallback to
> > > qdisc "noqueue", which is so simple that its init call will not fail.
> > > This allows the interface to continue functioning.
> > > 
> > > V2:
> > > As this also captures memory failures, which are transient, the
> > > device is not kept in IFF_NO_QUEUE state.  This allows the net_device
> > > to retry to default qdisc assignment.
> > > 
> > > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>    
> > 
> > I have mixed feelings about this one, I wonder if I'm the only one.
> > Seems like failure to allocate the default qdisc is pretty critical,
> > the log message may be missed, especially in the boot time noise.
> > 
> > I think a WARN_ON() is in order here, I'd personally just replace the
> > netdev_info with a WARN_ON, without the fallback.  
> 
> It is good that we agree that failure to default qdisc is pretty
> critical.  I guess we disagree on whether (1) we keep network
> functioning in a degraded state, (2) drop all packets on net_device
> such that people notice.
> 
> This change propose (1) keeping the box functioning.  For me it was a
> pretty bad experience, that when I pushed a new kernel over the network
> to my embedded box, then I lost all network connectivity.  I
> fortunately had serial console access (as this was not an OpenWRT box
> but a full devel board) so I could debug, but I could no-longer upgrade
> the kernel.  I clearly noticed, as the box was not operational, but I
> guess most people would just give up at this point. (Imagine a small
> OpenWRT box config setting default_qdisc to fq_codel, which brick the
> box as it cannot allocate memory).
> 
> I hope that people will notice this degrade state, when they start to
> transfer data to the device.  Because running 'noqueue' on a physical
> device will result in net_crit_ratelimited() messages below:
> 
>  [86971.609318] Virtual device eth0 asks to queue packet!
>  [86971.622183] Virtual device eth0 asks to queue packet!
>  [86971.627510] Virtual device eth0 asks to queue packet!

Both ways have advantages, I guess. I don't feel strongly, 
but I do think that WARN_ON() is in order here.
