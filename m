Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1B54431C3
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 16:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhKBPe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 11:34:58 -0400
Received: from todd.t-8ch.de ([159.69.126.157]:35263 "EHLO todd.t-8ch.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230370AbhKBPe5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 11:34:57 -0400
Date:   Tue, 2 Nov 2021 16:32:21 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1635867141;
        bh=5OvMbhfJq7+QGUzOTVZo8+8AZYHPyj8ag6BCpDM1akE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TT+zHTNU+xlgltSeNmmVjhdFBf4vwmViPqgi7i282urMt8n7mTzMU0Oy3TcIKWWys
         onsXZBYdmGFMobiBlypHRcgCPCNF1Vo6PPX8Zr1ZaJzmIC+uaKkjqLOCD2bte0LeZJ
         wHnHW8M8b/KnXJkbpmgB67Hoe7cakEGbfNEJhJes=
From:   Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/9p: autoload transport modules
Message-ID: <3e8fcaff-6a2e-4546-87c9-a58146e02e88@t-8ch.de>
References: <20211017134611.4330-1-linux@weissschuh.net>
 <YYEYMt543Hg+Hxzy@codewreck.org>
 <922a4843-c7b0-4cdc-b2a6-33bf089766e4@t-8ch.de>
 <YYEmOcEf5fjDyM67@codewreck.org>
 <ddf6b6c9-1d9b-4378-b2ee-b7ac4a622010@t-8ch.de>
 <YYFSBKXNPyIIFo7J@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YYFSBKXNPyIIFo7J@codewreck.org>
Jabber-ID: thomas@t-8ch.de
X-Accept: text/plain, text/html;q=0.2, text/*;q=0.1
X-Accept-Language: en-us, en;q=0.8, de-de;q=0.7, de;q=0.6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-02 23:58+0900, Dominique Martinet wrote:
> Thomas Weißschuh wrote on Tue, Nov 02, 2021 at 03:49:32PM +0100:
> > > I guess it wouldn't hurt to have 9p-tcp 9p-unix and 9p-fd aliases to the
> > > 9pnet module, but iirc these transports were more closely tied to the
> > > rest of 9pnet than the rest so it might take a while to do and I don't
> > > have much time for this right now...
> > > I'd rather not prepare for something I'll likely never get onto, so
> > > let's do this if there is progress.
> > > 
> > > Of course if you'd like to have a look that'd be more than welcome :-)
> > 
> > If you are still testing anyways, you could also try the attached patch.
> > (It requires the autload patch)
> > 
> > It builds fine and I see no reason for it not to work.
> 
> Thanks! I'll give it a spin.
> 
> 
> I was actually just testing the autoload one and I can't get it to work
> on my minimal VM, I guess there's a problem with the usermodhelper call
> to load module..
> 
> with 9p/9pnet loaded,
> running "mount -t 9p -o trans=virtio tmp /mnt"
> request_module("9p-%s", "virtio") returns -2 (ENOENT)

Can you retry without 9p/9pnet loaded and see if they are loaded by the mount
process?
The same autoloading functionality exists for filesystems using
request_module("fs-%s") in fs/filesystems.c
If that also doesn't work it would indicate an issue with the kernel setup in general.

> Looking at the code it should be running "modprobe -q -- 9p-virtio"
> which finds the module just fine, hence my supposition usermodhelper is
> not setup correctly
> 
> Do you happen to know what I need to do for it?

What is the value of CONFIG_MODPROBE_PATH?
And the contents of /proc/sys/kernel/modprobe?

> I've run out of time for today but will look tomorrow if you don't know.
> 
> (And since it doesn't apparently work out of the box on these minimal
> VMs I think I'll want the trans_fd module split to sit in linux-next
> for a bit longer than a few days, so will be next merge window)

Sure.

Thomas
