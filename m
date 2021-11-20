Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255784580DE
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 00:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236830AbhKTXFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 18:05:45 -0500
Received: from nautica.notk.org ([91.121.71.147]:49294 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236806AbhKTXFo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Nov 2021 18:05:44 -0500
X-Greylist: delayed 40626 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Nov 2021 18:05:44 EST
Received: by nautica.notk.org (Postfix, from userid 108)
        id D6004C009; Sun, 21 Nov 2021 00:02:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1637449359; bh=+h+v5WoHCnvJZTz4S+KWLOEg0q3JUAhaF9Le2Ttzzdw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=zi+Di05NvmQb0FPe4t7GaxTYczlDIYk4ZowTzQPAjbzNil6tJPiz3uevJkaan44Wf
         rDNyb/NApmS8Nxb69yC/hQykjdZpp3QJtNtDgIJzhsrV94ReJD0bEJmcEpbdLm6Xwi
         wyinjKPWaMsvzZV2BJ83LCwBjLzIGWHh1cW2/K6JmvzrTMQ08ajf8Ze5NnHhYPahE7
         CaWMaaZFXdKBwLNwPoVEsid2e5I2u+ZX4MBMlecX+GNXOQLLLjEJnWIhAbbhdN0nDm
         0tZEBQHhYdfzitkrMH6fcCWo30aPTiiRCM8m714baAUjTG05w817qauiChkQ/zBbZE
         tFmw8HweKD5aA==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 7B309C009;
        Sun, 21 Nov 2021 00:02:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1637449358; bh=+h+v5WoHCnvJZTz4S+KWLOEg0q3JUAhaF9Le2Ttzzdw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=AGAPj+62nUhZHRXe7M2yvA9YTANCxcXJq9zYxBItl/82mx/7IFaunqqJ8xiS8N4S3
         zyPznc3G1Ndf42MtAch3jq0UGJhcbyzkbbrJQzJMULWnOnmqzueNUwx9mkbZhysP7V
         1PUoA+gJNjY3ONLwxqqP5Ls3/JsDLgBOMPljGxn1Ks+wXqZogvWMSEC804Z34cwPHz
         GLLbRv46IqHwg5gvgZYOW2FfRW9YjjvfO6mcfOqXbJatt/Dru0JMBZON45tbWwfrWG
         xb/TjxiPb8/D2KEEAuyroj0yJcjjvy5fYEdSVjZPCd7ZEFOaPPRzbfH06TPDu4i/8T
         JPHkh+GmmQWgQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id b53fd81b;
        Sat, 20 Nov 2021 23:02:32 +0000 (UTC)
Date:   Sun, 21 Nov 2021 08:02:16 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        Nikolay Kichukov <nikolay@oldum.net>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v3 6/7] 9p/trans_virtio: support larger msize values
Message-ID: <YZl+eD6r0iIGzS43@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8d781f45b6a6fb434aa386dccb7f8f424ec1ffbe.camel@oldum.net>
 <2717208.9V0g2NVZY4@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Christian,

Christian Schoenebeck wrote on Sat, Nov 20, 2021 at 03:46:19PM +0100:
> > So in practice, you will be capped at 2MB as that is the biggest the
> > slab will be able to hand over in a single chunk.
> 
> I did not encounter a 2MB limit here. But kmalloc() clearly has a 4MB limit, 
> so when trying an msize larger than 4MB it inevitably causes a memory 
> allocation error. In my tests this allocation error would always happen 
> immediately at mount time causing an instant kernel oops.

Interesting, I was assuming it'd have the same limit.
There must be some fallback path I didn't know about... I wonder if it
handles non-contiguous memory ranges too then, in which case it's not as
bad as I'd have expected depending on how finely it's willing to sew
things back together: I'll check

> > Ideally we'd only allocate on an as-need basis, most of the protocol
> > calls bound how much data is supposed to come back and we know how much
> > we want to send (it's a format string actually, but we can majorate it
> > quite easily), so one would need to adjust all protocol calls to pass
> > this info to p9_client_rpc/p9_client_zc_rpc so it only allocates buffers
> > as required, if necessary in multiple reasonably-sized segments (I'd
> > love 2MB hugepages-backed folios...), and have all transports use these
> > buffers.
> 
> It is not that bad in sense of pending work. One major thing that needs to be 
> done is to cap the majority of 9p message types to allocate only as much as 
> they need, which is for most message types <8k. Right now they always simply 
> kmalloc(msize), which hurts with increasing msize values. That task does not 
> need many changes though.

Yes, that could be a first step.
Although frankly as I said if we're going to do this, we actual can
majorate the actual max for all operations pretty easily thanks to the
count parameter -- I guess it's a bit more work but we can put arbitrary
values (e.g. 8k for all the small stuff) instead of trying to figure it
out more precisely; I'd just like the code path to be able to do it so
we only do that rechurn once.

Note I've been rather aggressive with checkpatch warning fixes in my
last update for 5.16, hopefully it won't conflict too much with your
work... Let me deal with conflicts if it's a problem.

> > I have a rough idea on how to do all this but honestly less than 0 time
> > for that, so happy to give advices or review any patch, but it's going
> > to be a lot of work that stand in the way of really big IOs.
> 
> Reviews of the patches would actually help a lot to bring this overall effort 
> forward, but probably rather starting with the upcoming next version of the 
> kernel patches, not this old v3.

Happy to review anything you send over, yes :)



Nikolay,

> > > (Not sure about this, I'll test these patches tomorrow, but since
> > > something failed I'm not surprised you have less than what you could
> > > have here: what do you get with a more reasonable value like 1M
> > > first?)
> 
> It worked with 1MB, I can stick to this for the time being.
> 
> Are the kernel patches supposed to be included in the KVM host kernel or
> would the guest kernel suffice?

The patches are only required in the guest.

-- 
Dominique
