Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C97DF457ED3
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 16:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237572AbhKTPJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 10:09:49 -0500
Received: from kylie.crudebyte.com ([5.189.157.229]:43977 "EHLO
        kylie.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhKTPJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 10:09:49 -0500
X-Greylist: delayed 1221 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Nov 2021 10:09:49 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=J1uXot19sq40KhBVoO/2frmljl7T+O0vbEX5x0lP4h4=; b=YVuXK/eiLgE/DbdrLn+gyIqkLv
        BJro/IcVdCE3eOjCdRHMO5QNO/Xbv2KgWEQK1wj1LqRA+lbj4sL77b3lAqsmCbBEL4AA479iYBRFK
        fgl6PHd/woQm31FLpMUnAUuSJjURKwRG5r8UoZvSE9Dz/R5VDuDh0+B289nYCcWOgAy4Swu5Wh64N
        V3bXh5jCyiTEs5RYTqd5nyiwNvm0YCtHdjN0f48etnpUZWQh8HSJXo7Bso7x23wD55wPConaTiUtb
        u2UIuxv1+59ZmsYSIYWrwzyU/jHDnLS09mmT2XSkKIDtVAwc8Rz3I542ByLPfNWw8A0f5deGNhVui
        XfuN6pXNqyxgPPDkVysX7yI8x9zz2TUXCgwbXpbXQN+YOwiF9mtFCrIRi2PGLCMUxIA3jvNJX3VG8
        mkZS5XoZP6dJ3B/V0ArMGyAQa719O379DIwlWtMogvPIsLjMc980zOEg5dBVyA2lQ8B7HJq39wIfR
        0AewHHgqSt6BUaA/mvwl0ue5bFn8ZmNF21KCCeqoPWr2vJdt1ppBHmgNp9e6SxqnqlzDmFPriVTef
        llgWNdN4s1iN5tME2z8gCivpFaLC/nnq0jyzNLkJqIkM5NM5XMV0qWB/sE0U5l0QbrYIdgbX3yUne
        DK2WJZ4kMYnmkntZ1ZPlD0a/efPR8lGXN3qpr0bIo=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Nikolay Kichukov <nikolay@oldum.net>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v3 6/7] 9p/trans_virtio: support larger msize values
Date:   Sat, 20 Nov 2021 15:46:19 +0100
Message-ID: <2717208.9V0g2NVZY4@silver>
In-Reply-To: <YZjfxT24by0Cse6q@codewreck.org>
References: <cover.1632327421.git.linux_oss@crudebyte.com> <cef6a6c6f8313a609ef104cc64ee6cf9d0ed6adb.camel@oldum.net> <YZjfxT24by0Cse6q@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Samstag, 20. November 2021 12:45:09 CET Dominique Martinet wrote:
> (Thanks for restarting this thread, this had totally slipped out of my
> mind...)

Hi guys,

I have (more or less) silently been working on these patches on all ends in 
the meantime. If desired I try to find some time next week to summarize 
current status of this overall effort and what still needs to be done.

> Nikolay Kichukov wrote on Sat, Nov 20, 2021 at 12:20:35PM +0100:
> > When the client mounts the share via virtio, requested msize is:
> > 10485760 or 104857600
> > 
> > however the mount succeeds with:
> > msize=507904 in the end as per the /proc filesystem. This is less than
> > the previous maximum value.
> 
> (Not sure about this, I'll test these patches tomorrow, but since
> something failed I'm not surprised you have less than what you could
> have here: what do you get with a more reasonable value like 1M first?)

The highest 'msize' value possible for me with this particular version of the 
kernel patches is 4186212 (so slightly below 4MB).

Some benchmarks, linear reading a 12 GB file:

msize    average      notes

8 kB     52.0 MB/s    default msize of Linux kernel <v5.15
128 kB   624.8 MB/s   default msize of Linux kernel >=v5.15
512 kB   1961 MB/s    current max. msize with any Linux kernel <=v5.15
1 MB     2551 MB/s    this msize would violate current virtio specs
2 MB     2521 MB/s    this msize would violate current virtio specs
4 MB     2628 MB/s    planned milestone

That does not mean it already makes sense to use these patches in this version 
as is to increase overall performance yet, but the numbers already suggest 
that increasing msize can improve performance on large sequential I/O. There 
are still some things to do though to fix other use patterns from slowing down 
with rising msize, which I will describe in a separate email.

I also have an experimental version of kernel patches and QEMU that goes as 
high as msize=128MB. But that's a highly hacked version that copies buffers 
between 9p client level and virtio level back and forth and with intentional 
large buffer sizes on every 9p message type. This was solely meant as a stress 
test, i.e. whether it was possible to go as high as virtio's theoretical 
protocol limit in the first place, and whether it was stable. This stress test 
was not about performance at all. And yes, I had it running with 128MB for 
weeks without issues (except of being very slow of course due to hacks used).

> > In addition to the above, when the kernel on the guest boots and loads
> > 9pfs support, the attached memory allocation failure trace is generated.
> > 
> > Is anyone else seeing similar and was anybody able to get msize set to
> > 10MB via virtio protocol with these patches?
> 
> I don't think the kernel would ever allow this with the given code, as
> the "common" part of 9p is not smart enough to use scatter-gather and
> tries to do a big allocation (almost) the size of the msize:
> 
> ---
>         clnt->fcall_cache =
>                 kmem_cache_create_usercopy("9p-fcall-cache", clnt->msize,
>                                            0, 0, P9_HDRSZ + 4,
>                                            clnt->msize - (P9_HDRSZ + 4),
>                                            NULL);
> 
> ...
> 		fc->sdata = kmem_cache_alloc(c->fcall_cache, GFP_NOFS);
> ---
> So in practice, you will be capped at 2MB as that is the biggest the
> slab will be able to hand over in a single chunk.

I did not encounter a 2MB limit here. But kmalloc() clearly has a 4MB limit, 
so when trying an msize larger than 4MB it inevitably causes a memory 
allocation error. In my tests this allocation error would always happen 
immediately at mount time causing an instant kernel oops.

> It'll also make allocation failures quite likely as soon as the system
> has had some uptime (depending on your workload, look at /proc/buddyinfo
> if your machines normally have 2MB chunks available), so I would really
> not recommend running with buffers bigger than e.g. 512k on real
> workloads -- it looks great on benchmarks, especially as it's on its own
> slab so as long as you're doing a lot of requests it will dish out
> buffers fast, but it'll likely be unreliable over time.
> (oh, and we allocate two of these per request...)
> 
> 
> The next step to support large buffers really would be splitting htat
> buffer to:
>  1/ not allocate huge buffers for small metadata ops, e.g. an open call
> certainly doesn't need to allocate 10MB of memory
>  2/ support splitting the buffer in some scattergather array
> 
> Ideally we'd only allocate on an as-need basis, most of the protocol
> calls bound how much data is supposed to come back and we know how much
> we want to send (it's a format string actually, but we can majorate it
> quite easily), so one would need to adjust all protocol calls to pass
> this info to p9_client_rpc/p9_client_zc_rpc so it only allocates buffers
> as required, if necessary in multiple reasonably-sized segments (I'd
> love 2MB hugepages-backed folios...), and have all transports use these
> buffers.

It is not that bad in sense of pending work. One major thing that needs to be 
done is to cap the majority of 9p message types to allocate only as much as 
they need, which is for most message types <8k. Right now they always simply 
kmalloc(msize), which hurts with increasing msize values. That task does not 
need many changes though.

> I have a rough idea on how to do all this but honestly less than 0 time
> for that, so happy to give advices or review any patch, but it's going
> to be a lot of work that stand in the way of really big IOs.

Reviews of the patches would actually help a lot to bring this overall effort 
forward, but probably rather starting with the upcoming next version of the 
kernel patches, not this old v3.

> > [    1.527981] 9p: Installing v9fs 9p2000 file system support
> > [    1.528173] ------------[ cut here ]------------
> > [    1.528174] WARNING: CPU: 1 PID: 791 at mm/page_alloc.c:5356
> > __alloc_pages+0x1ed/0x290
> This warning is exactly what I was saying about the allocation cap:
> you've requested an allocation that was bigger than the max __alloc_page
> is willing to provide (MAX_ORDER, 11, so 2MB as I was saying)

Best regards,
Christian Schoenebeck


