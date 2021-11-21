Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACBA45852D
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 17:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238413AbhKURBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 12:01:22 -0500
Received: from kylie.crudebyte.com ([5.189.157.229]:38861 "EHLO
        kylie.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238592AbhKURAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 12:00:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=GCTm8a1TeKdZq6+0dzPV/WSF9+hB7rLfwgR447PHKYE=; b=aTj7gOYEYY1/jbtpj526j+qNhM
        CIetpiBbmejU1a1N+/ttjtVR37dbE6s/LJywe3yhOvDjlbWy3+lk6watq0rLscOGpVH7jQ9mNxHtd
        2xvZfT/BZaoaQZyuNGsS1y3SQzqtiK9F3Z0NckRBPrDJlPmLRvqGDmIQ1GMpfpIKPmKEiEQM/jMQX
        tMs+QZpIIh3WY5prfcSAmwKOA2sTpClbe7jg17UoT56kP9Ati8vNAyDbPBeUOr2qGPOUMzo9NW5mB
        vN/X/Sz5/NPK0TRVSB3Vwdy9aJlmje9AisM9f6mkhwdTNm8OJ/B38bRZ3z95rBs6HaE2r0+HY1YMF
        f1r4A8Lm3H3SyADIzHGptv+/YP89kevWBy8w9qv7HINpZxVvH0NE3J9kyYwggwTEasWgqYPCmjUbj
        B2ojxfTzwKWx2CU8ecLG6hOi21I+Gi386e8meTZhLjeJpr6mEXw1dP+unnh64oB+9SNiR4tn9iBMO
        RskzG3s6RECg1mokt0ndXPzD4KsYYa1NT9uoP7VtAnkQ71ghmqbI5lTK8NdTCZ2Qzpp436Wjl1owS
        fibjS/C+qaWlVrOMCHV3LC4/LIiv0KYxDWnoZhUZkGNHMmYvS4OL+S9haZwHgBqzfiLm/OTnPcJtv
        +64PZ/fJ/3R3kaunN/2+NySXeoknY4TEodjHO36A4=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Nikolay Kichukov <nikolay@oldum.net>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v3 6/7] 9p/trans_virtio: support larger msize values
Date:   Sun, 21 Nov 2021 17:57:30 +0100
Message-ID: <4244024.q9Xco3kuGk@silver>
In-Reply-To: <YZl+eD6r0iIGzS43@codewreck.org>
References: <YZl+eD6r0iIGzS43@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sonntag, 21. November 2021 00:02:16 CET Dominique Martinet wrote:
> Christian,
> 
> Christian Schoenebeck wrote on Sat, Nov 20, 2021 at 03:46:19PM +0100:
> > > So in practice, you will be capped at 2MB as that is the biggest the
> > > slab will be able to hand over in a single chunk.
> > 
> > I did not encounter a 2MB limit here. But kmalloc() clearly has a 4MB
> > limit, so when trying an msize larger than 4MB it inevitably causes a
> > memory allocation error. In my tests this allocation error would always
> > happen immediately at mount time causing an instant kernel oops.
> 
> Interesting, I was assuming it'd have the same limit.

That's one of the things in the Linux kernel's memory allocation APIs that 
could be improved. IMO it should be clear to developers what the max. size for 
kmalloc() is, by either a dedicated function or a macro *and* that being 
officially and clearly documented. Right now it is more a "I think it is ..." 
and eventually trying out. You might use the value of MAX_ORDER, but does not 
feel like an official way to me.

> There must be some fallback path I didn't know about... I wonder if it
> handles non-contiguous memory ranges too then, in which case it's not as
> bad as I'd have expected depending on how finely it's willing to sew
> things back together: I'll check

AFAICS that was a misconception in the past in 9p code (I see 
is_vmalloc_addr() being used); there are basically two types of kernel buffers 
that you can allocate today:

1. Buffer with guaranteed contiguous physical pages, e.g. kmalloc():

   These are limited to exactly 4 MB.

or

2. Buffer with potential non-contiguous physical pages, e.g. vmalloc().

   For 32-bit systems the limit here is either 120 MB or 128 MB. On higher 
   systems it is usually only limited by the physical memory being available.

In both cases you get exactly one memory address that can very simply be 
treated by driver code as if that address was pointing to a single linear 
buffer, just like you would in regular user space apps.

However (2.) is not an option for 9p driver, because that memory type yields 
in non-logical addresses which cannot be accessed by a device through DMA. I 
actually tried replacing kmalloc() call by kvmalloc() as a quick hack for 
attempting to bypass the 4 MB limit without significant code changes, however 
it fails on QEMU side with the following QEMU error, as host cannot access 
such kind of memory address in general:

  virtio: bogus descriptor or out of resources

So in my very slow msize=128MB virtio stress test I ended up using kvmalloc() 
for 9p client side, plus alloc_pages() for virtio/DMA side and copying between 
the two sides back and forth as a hack. But copying should not be an option 
for production code, as it is very slow.

> > > Ideally we'd only allocate on an as-need basis, most of the protocol
> > > calls bound how much data is supposed to come back and we know how much
> > > we want to send (it's a format string actually, but we can majorate it
> > > quite easily), so one would need to adjust all protocol calls to pass
> > > this info to p9_client_rpc/p9_client_zc_rpc so it only allocates buffers
> > > as required, if necessary in multiple reasonably-sized segments (I'd
> > > love 2MB hugepages-backed folios...), and have all transports use these
> > > buffers.
> > 
> > It is not that bad in sense of pending work. One major thing that needs to
> > be done is to cap the majority of 9p message types to allocate only as
> > much as they need, which is for most message types <8k. Right now they
> > always simply kmalloc(msize), which hurts with increasing msize values.
> > That task does not need many changes though.
> 
> Yes, that could be a first step.
> Although frankly as I said if we're going to do this, we actual can
> majorate the actual max for all operations pretty easily thanks to the
> count parameter -- I guess it's a bit more work but we can put arbitrary
> values (e.g. 8k for all the small stuff) instead of trying to figure it
> out more precisely; I'd just like the code path to be able to do it so
> we only do that rechurn once.

Looks like we had a similar idea on this. My plan was something like this:

static int max_msg_size(enum msg_type) {
    switch (msg_type) {
        /* large zero copy messages */
        case Twrite:
        case Tread:
        case Treaddir:
            BUG_ON(true);

        /* small messages */
        case Tversion:
        ....
            return 8k; /* to be replaced with appropriate max value */
    }
}

That would be a quick start and allow to fine grade in future. It would also 
provide a safety net, e.g. the compiler would bark if a new message type is 
added in future.

> Note I've been rather aggressive with checkpatch warning fixes in my
> last update for 5.16, hopefully it won't conflict too much with your
> work... Let me deal with conflicts if it's a problem.

Good to know! I just tried a quick rebase, no conflicts fortunately.

> > > I have a rough idea on how to do all this but honestly less than 0 time
> > > for that, so happy to give advices or review any patch, but it's going
> > > to be a lot of work that stand in the way of really big IOs.
> > 
> > Reviews of the patches would actually help a lot to bring this overall
> > effort forward, but probably rather starting with the upcoming next
> > version of the kernel patches, not this old v3.
> 
> Happy to review anything you send over, yes :)

Perfect!

> Nikolay,
> 
> > > > (Not sure about this, I'll test these patches tomorrow, but since
> > > > something failed I'm not surprised you have less than what you could
> > > > have here: what do you get with a more reasonable value like 1M
> > > > first?)
> > 
> > It worked with 1MB, I can stick to this for the time being.
> > 
> > Are the kernel patches supposed to be included in the KVM host kernel or
> > would the guest kernel suffice?
> 
> The patches are only required in the guest.

Correct, plus preferably latest git version of QEMU, a.k.a upcoming QEMU 6.2 
release (already in hard freeze).

https://wiki.qemu.org/Planning/6.2
https://wiki.qemu.org/ChangeLog/6.2#9pfs

That QEMU 6.2 version is still limited to 4 MB virtio transfer size though.

I proposed patches for QEMU that allow up to 128 MB virtio transfer size. That 
ended in a very long discussion on qemu-devel and the conclusion that a 
refinement of the virtio specs should be done:
https://lore.kernel.org/all/cover.1633376313.git.qemu_oss@crudebyte.com/

Virtio spec changes proposed (v1):
https://github.com/oasis-tcs/virtio-spec/issues/122

You can probably subscribe on that virtio-spec issue if you want to receive 
updates on its progress.

Best regards,
Christian Schoenebeck


