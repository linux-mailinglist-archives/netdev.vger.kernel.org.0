Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C78C481CCC
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 15:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239819AbhL3OMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 09:12:15 -0500
Received: from lizzy.crudebyte.com ([91.194.90.13]:37057 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbhL3OMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 09:12:14 -0500
X-Greylist: delayed 2521 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Dec 2021 09:12:13 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Content-ID:
        Content-Description; bh=v0FOFCtrEu0tqoBce1riXue0DcgvfXWSveZUomzIpD4=; b=BZj7L
        5m6l9r8vB6k8aP9uI7khIbEuDNZucTxSLVLnaS41A8DoV9OlbsUeDDeIH9F+4AH4a5hRmP7ssAoTv
        PmP7KrFnJHRg5piFl0M1Y37OPiKfzsQLFBZGyJ5mFsPBQ2/JJXm+A4sLglk6wAaJX1ujBXBBrbwwZ
        72C39ZjXiV+vCGqkKMTWapynerxbSoc3nHPvStUagQW5HfyvkC98V91n00LicDK0Ey/cg1VwF2oU7
        TzIj9JcJ9nXFPqsNYy3JUCPoeK4KZlgo+w2D+fnI5u75+MVFdoO9tEo0OBEA2xfHzrPLZG+ehgEPW
        HTi5lg20afzXR825VuA7lHQEOxvmA==;
Message-Id: <cover.1640870037.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Thu, 30 Dec 2021 14:23:18 +0100
Subject: [PATCH v4 00/12] remove msize limit in virtio transport
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>,
        Nikolay Kichukov <nikolay@oldum.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series aims to get get rid of the current 500k 'msize' limitation in
the 9p virtio transport, which is currently a bottleneck for performance
of 9p mounts.

To avoid confusion: it does remove the msize limit for the virtio transport,
on 9p client level though the anticipated milestone for this series is now
a max. 'msize' of 4 MB. See patch 8 for reason why.

This is a follow-up of the following series and discussion:
https://lore.kernel.org/netdev/cover.1632327421.git.linux_oss@crudebyte.com/

Latest version of this series:
https://github.com/cschoenebeck/linux/commits/9p-virtio-drop-msize-cap


OVERVIEW OF PATCHES:

* Patch 1 is just a trivial info message for the user to know why his msize
  option got ignored by 9p client in case the value was larger than what is
  supported by this 9p driver.

* Patches 2..7 remove the msize limitation from the 'virtio' transport
  (i.e. the 9p 'virtio' transport itself actually supports >4MB now, tested
  successfully with an experimental QEMU version and some dirty 9p Linux
  client hacks up to msize=128MB).

* Patch 8 limits msize for all transports to 4 MB for now as >4MB would need
  more work on 9p client level (see commit log of patch 8 for details).

* Patches 9..12 tremendously reduce unnecessarily huge 9p message sizes and
  therefore provide performance gain as well. So far, almost all 9p messages
  simply allocated message buffers exactly msize large, even for messages
  that actually just needed few bytes. So these patches make sense by
  themselves, independent of this overall series, however for this series
  even more, because the larger msize, the more this issue would have hurt
  otherwise.


PREREQUISITES:

If you are testing with QEMU then please either use latest QEMU 6.2 release
or higher, or at least apply the following patch on QEMU side:

  https://lore.kernel.org/qemu-devel/E1mT2Js-0000DW-OH@lizzy.crudebyte.com/

That QEMU patch is required if you are using a user space app that
automatically retrieves an optimum I/O block size by obeying stat's
st_blksize, which 'cat' for instance is doing, e.g.:

	time cat test_rnd.dat > /dev/null

Otherwise please use a user space app for performance testing that allows
you to force a large block size and to avoid that QEMU issue, like 'dd'
for instance, in that case you don't need to patch QEMU.


KNOWN LIMITATION:

With this series applied I can run

  QEMU host <-> 9P virtio <-> Linux guest

with up to slightly below 4 MB msize [4186112 = (1024-2) * 4096]. If I try
to run it with exactly 4 MB (4194304) it currently hits a limitation on
QEMU side:

  qemu-system-x86_64: virtio: too many write descriptors in indirect table

That's because QEMU currently has a hard coded limit of max. 1024 virtio
descriptors per vring slot (i.e. per virtio message), see to do (1.) below.


STILL TO DO:

  1. Negotiating virtio "Queue Indirect Size" (MANDATORY):

    The QEMU issue described above must be addressed by negotiating the
    maximum length of virtio indirect descriptor tables on virtio device
    initialization. This would not only avoid the QEMU error above, but would
    also allow msize of >4MB in future. Before that change can be done on
    Linux and QEMU sides though, it first requires a change to the virtio
    specs. Work on that on the virtio specs is in progress:

    https://github.com/oasis-tcs/virtio-spec/issues/122

    This is not really an issue for testing this series. Just stick to max.
    msize=4186112 as described above and you will be fine. However for the
    final PR this should obviously be addressed in a clean way.

  2. Reduce readdir buffer sizes (optional - maybe later):

    This series already reduced the message buffers for most 9p message
    types. This does not include Treaddir though yet, which is still simply
    using msize. It would make sense to benchmark first whether this is
    actually an issue that hurts. If it does, then one might use already
    existing vfs knowledge to estimate the Treaddir size, or starting with
    some reasonable hard coded small Treaddir size first and then increasing
    it just on the 2nd Treaddir request if there are more directory entries
    to fetch.

  3. Add more buffer caches (optional - maybe later):

    p9_fcall_init() uses kmem_cache_alloc() instead of kmalloc() for very
    large buffers to reduce latency waiting for memory allocation to
    complete. Currently it does that only if the requested buffer size is
    exactly msize large. As patch 11 already divided the 9p message types
    into few message size categories, maybe it would make sense to use e.g.
    4 separate caches for those memory category (e.g. 4k, 8k, msize/2,
    msize). Might be worth a benchmark test.

Testing and feedback appreciated!

v3 -> v4:

  * Limit msize to 4 MB for all transports [NEW patch 8].

  * Avoid unnecessarily huge 9p message buffers
    [NEW patch 9] .. [NEW patch 12].

Christian Schoenebeck (12):
  net/9p: show error message if user 'msize' cannot be satisfied
  9p/trans_virtio: separate allocation of scatter gather list
  9p/trans_virtio: turn amount of sg lists into runtime info
  9p/trans_virtio: introduce struct virtqueue_sg
  net/9p: add trans_maxsize to struct p9_client
  9p/trans_virtio: support larger msize values
  9p/trans_virtio: resize sg lists to whatever is possible
  net/9p: limit 'msize' to KMALLOC_MAX_SIZE for all transports
  net/9p: split message size argument into 't_size' and 'r_size' pair
  9p: add P9_ERRMAX for 9p2000 and 9p2000.u
  net/9p: add p9_msg_buf_size()
  net/9p: allocate appropriate reduced message buffers

 include/net/9p/9p.h     |   3 +
 include/net/9p/client.h |   2 +
 net/9p/client.c         |  67 +++++++--
 net/9p/protocol.c       | 154 ++++++++++++++++++++
 net/9p/protocol.h       |   2 +
 net/9p/trans_virtio.c   | 304 +++++++++++++++++++++++++++++++++++-----
 6 files changed, 483 insertions(+), 49 deletions(-)

-- 
2.30.2

