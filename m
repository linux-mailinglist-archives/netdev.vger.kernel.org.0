Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A753EF224
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 20:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbhHQSoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 14:44:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232351AbhHQSoh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 14:44:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98919604AC;
        Tue, 17 Aug 2021 18:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629225843;
        bh=tQruhJe1EpgromcFx02JFTrRlU2n72mWHK/gtNw2C+g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XYQnPp2H++Qi7JAE76x3G2dztN48+PlIffrnhsXUF5duc4tvvAhqKEUOrwAl6VTjb
         mP64DMWSYRr5lsu2UMnxT3Yp0JMYJl+shVbhsZ7eVG5vXjnNEW9yHoomVTutSr3pLE
         roQpfnappwxwj8oPq3KX5gzFk0rSi+jp4rw2FGeytEeXi55rfv+ZKCJdUv35O0pSYH
         hhqFF5xyb6yyH96KOZUYatgLVr/VTXvqgWgUMMpyA7UgHyNITViFj4n0hfzEmw+014
         xvzCkJ04T3XYNcPUEtuJn9cVHNMm9Od8mAhJDPY444TtougG5fYN87plqXKfHslZVd
         3nP6arA1/++WA==
Date:   Tue, 17 Aug 2021 11:44:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonas Bechtel <post@jbechtel.de>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: Re: ss command not showing raw sockets? (regression)
Message-ID: <20210817114402.78463d9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210817202135.6b42031f@mmluhan>
References: <20210815231738.7b42bad4@mmluhan>
        <20210816150800.28ef2e7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210817080451.34286807@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210817202135.6b42031f@mmluhan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Aug 2021 20:21:35 +0200 Jonas Bechtel wrote:
> On Tue, 17 Aug 2021 08:04:51 -0700
> Jakub Kicinski <kuba@kernel.org> wrote with subject
> > I had a look, I don't see anything out of the ordinary. I checked with
> > v4.6, I don't have a 4.4 box handy. It seems ss got support for
> > dumping over netlink in the 4.9. On a 4.4 kernel it should fall back
> > to using procfs tho, raw_show() calls inet_show_netlink() which
> > should fails and therefore the code should fall through to the old
> > procfs stuff.
> > 
> > No idea why that doesn't happen for you. Is this vanilla 4.4 or does
> > it have backports? Is there a /sys/module/raw_diag/ directory on your
> > system after you run those commands?  
> 
> It's was Knoppix distributed package. I don't know about the exact
> contents, there's also no hint in package description. I just know
> that it works without initrd, as it directly mounts the root disk.
> 
> No, there's /sys/module but no /sys/module/raw_diag/ neither before
> nor after running those commands.

Hm. Could you share the config for that kernel? I don't know Knoppix
but there should be a /boot/config-* or /proc/config.gz, hopefully.

> > Does setting PROC_NET_RAW make the newer iproute version work for
> > you?
> > 
> > $ PROC_NET_RAW=/proc/net/raw ss -awp  
> 
> Yes, this did the trick. (And again I was thinking programs were
> doing something "magical", but in the end it's just a file they
> access)
> 
> 
> Furthermore I checked with Linux 4.19.0 amd64 RT (Debian package;
> from package description: "This kernel includes the PREEMPT_RT
> realtime patch set."). With this kernel there was no need for
> PROC_NET_RAW. All iproute versions worked out of the box and showed
> even command name, pid and fd number (that's why ss traverses all
> /proc/[pids]/fd/ directories?).
> 
> 
> See attached log file, with kernel versions and iproute2 versions
> printed.
> 
> 
> @kuba With PROC_NET_RAW I consider the problem is found, isn't it? So
> I will not download/bisect<->build or otherwise investigate the
> problem until one of you explicitely asks me to do so.
> 
> I have now redirected invocation of command with set PROC_NET_RAW on
> my system, and may (try to) update to Linux 4.19.

I suspect the bisection would end up at the commit which added 
the netlink dump support, so you can hold off for now, yes.

My best guess right now is that Knoppix has a cut-down kernel 
config and we don't handle that case correctly.
