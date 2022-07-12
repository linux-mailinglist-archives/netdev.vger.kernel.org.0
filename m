Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7415720C2
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbiGLQZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233501AbiGLQZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:25:44 -0400
X-Greylist: delayed 1807 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 12 Jul 2022 09:25:43 PDT
Received: from lizzy.crudebyte.com (lizzy.crudebyte.com [91.194.90.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2CACAF26
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 09:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Content-ID:
        Content-Description; bh=DR3HV1SiIkmW4IR/q6IEoMYBeifoU6ydrhuDi/6K044=; b=JLWBp
        gHkHeaKR9uoySe7mI5RXdMk5eM3CvX4kJVb2YrdP9Twm3QzZ6S+Y6wVFRAp7WWQFdtJ3BuwtWhWN6
        8wRfR0767mXO3VYp73AtO09kpTLimCxsrF/3/ZCxz36rMROSaL+yvUVGgXHon14kaFFxQbsd8TwxP
        UyBbL+8DGTfAto/gBpbuFDXy84qAP2ebfuh3uMDTAewXMmwDdeITuhrWWBnWwP8ozOdyW2x8yNdhM
        wIv7Or4GdQneIDuoeaDlaIdmZQvathN7kMCPiIg+BoyOF+60uWcuIezRHxkAlxOzrjl9/omsM6awR
        M5jCAFZ1uohM1amebgFDe2AlMpaxA==;
Message-Id: <cover.1657636554.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Tue, 12 Jul 2022 16:35:54 +0200
Subject: [PATCH v5 00/11] remove msize limit in virtio transport
To:     v9fs-developer@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series aims to get get rid of the current 500k 'msize' limitation in
the 9p virtio transport, which is currently a bottleneck for performance
of 9p mounts.

To avoid confusion: it does remove the msize limit for the virtio transport,
on 9p client level though the anticipated milestone for this series is now
a max. 'msize' of 4 MB. See patch 7 for reason why.

This is a follow-up of the following series and discussion:
https://lore.kernel.org/all/cover.1640870037.git.linux_oss@crudebyte.com/

Latest version of this series:
https://github.com/cschoenebeck/linux/commits/9p-virtio-drop-msize-cap


OVERVIEW OF PATCHES:

* Patches 1..6 remove the msize limitation from the 'virtio' transport
  (i.e. the 9p 'virtio' transport itself actually supports >4MB now, tested
  successfully with an experimental QEMU version and some dirty 9p Linux
  client hacks up to msize=128MB).

* Patch 7 limits msize for all transports to 4 MB for now as >4MB would need
  more work on 9p client level (see commit log of patch 7 for details).

* Patches 8..11 tremendously reduce unnecessarily huge 9p message sizes and
  therefore provide performance gain as well. So far, almost all 9p messages
  simply allocated message buffers exactly msize large, even for messages
  that actually just needed few bytes. So these patches make sense by
  themselves, independent of this overall series, however for this series
  even more, because the larger msize, the more this issue would have hurt
  otherwise.


PREREQUISITES:

If you are testing with QEMU then please either use QEMU 6.2 or higher, or
at least apply the following patch on QEMU side:

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
    exactly msize large. As patch 10 already divided the 9p message types
    into few message size categories, maybe it would make sense to use e.g.
    4 separate caches for those memory category (e.g. 4k, 8k, msize/2,
    msize). Might be worth a benchmark test.

Testing and feedback appreciated!

v4 -> v5:

  * Exclude RDMA transport from buffer size reduction. [patch 11]

Christian Schoenebeck (11):
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
 net/9p/client.c         |  68 +++++++--
 net/9p/protocol.c       | 154 ++++++++++++++++++++
 net/9p/protocol.h       |   2 +
 net/9p/trans_virtio.c   | 304 +++++++++++++++++++++++++++++++++++-----
 6 files changed, 484 insertions(+), 49 deletions(-)

-- 
2.30.2

