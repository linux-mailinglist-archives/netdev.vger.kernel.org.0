Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475BE4EC431
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 14:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244092AbiC3Mga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 08:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344866AbiC3MgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 08:36:04 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D606E8B6FF;
        Wed, 30 Mar 2022 05:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=5r9m0N7Ebt4DCTwFZFxwn33ND+9s0erw44BijSWL+Y0=; b=CkXZWJpFpOthNz+UISZglWXltQ
        tVPW0WRiECAn5TskpF9WewOLiWeKykzSJmtIX26gln19l9R46GIqMAILAk2tsVOKzxd/DqOcJqs7U
        KqUYMF7bKPd79rLVZzebcWhoSDt5e3caVZsyXTLWDkk7sthf7KloqvxOLLqZtF4DSVmXHKQMzzCe0
        tTFoYdpi8+bFDU1oJlhRGLHXvQkkTH472CfEd+Zja62rxNrSauWyNorRwJNAZurMbAk8XeQcunvCl
        wyvtITOTWLplJM3/h5fD1pEURtNGfKhVYFcF7NFOe4YP7IYnh/tQqRz8JeEg26QnSX+ELfJ9izXMf
        C+xNj7lGtMDeOzO4i2zRB2iaiEvMB+OcOEMemIoAMPLJAIju6qnFjdCfU1TSJ757/cDbB2Ppt7rBO
        Qt9rLivxVJKY0ilfwAiNDVl6hmAngrZxZ7RgD3QHlBc2LMo7DWvBU/ciO9485cGtX54sYT1gKnqrV
        kwiewZ/qmN5xH5NIRLV/Ee0gwvoONPH/Am0/ExdG4c9ofb+QEgHfdYSKZ1Hhc9JwqU+XgLNlrGZYR
        gFO0hjVLz9B0oMvpqM5TaL02kz5K5CKHDyzJxMXlfUvjC72bykZuK4XLBuAvMctbeOOqxIJ6LpU3u
        iEHS1Y1rG6UCmghOSVxaUzXbWnUtwQjkY14stjLUw=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     asmadeus@codewreck.org
Cc:     David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        David Howells <dhowells@redhat.com>, Greg Kurz <groug@kaod.org>
Subject: 9p fs-cache tests/benchmark (was: 9p fscache Duplicate cookie detected)
Date:   Wed, 30 Mar 2022 14:21:16 +0200
Message-ID: <3791738.ukkqOL8KQD@silver>
In-Reply-To: <Yj8WkjT+MsdFIfwr@codewreck.org>
References: <CAAZOf26g-L2nSV-Siw6mwWQv1nv6on8c0fWqB4bKmX73QAFzow@mail.gmail.com>
 <2582025.XdajAv7fHn@silver> <Yj8WkjT+MsdFIfwr@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I made some tests & benchmarks regarding the fs-cache issue of 9p, running
different kernel versions and kernel configurations in comparison.

Setup: all tests were running QEMU v7.0.0-rc0+ [3]. Linux guest system was
running 9p as root filesystem as described in the QEMU 9p root fs HOWTO [4]
and then I installed build tools into guest OS required for this test. In e=
ach
test run I compiled the same source files as parallel build (make -jN).
Between each run I deleted the build directory and rebooted the guest system
with different kernel config and restarted a build on guest. Results:

Case  Linux kernel version           .config  msize    cache  duration  hos=
t cpu  errors/warnings

A)    5.17.0+[2] + msize patches[1]  debug    4186112  mmap   20m 40s   ~80=
%      none
B)    5.17.0+[2] + msize patches[1]  debug    4186112  loose  31m 28s   ~35=
%      several errors (compilation completed)
C)    5.17.0+[2] + msize patches[1]  debug    507904   mmap   20m 25s   ~84=
%      none
D)    5.17.0+[2] + msize patches[1]  debug    507904   loose  31m 2s    ~33=
%      several errors (compilation completed)
E)    5.17.0+[2]                     debug    512000   mmap   23m 45s   ~75=
%      none
=46)    5.17.0+[2]                     debug    512000   loose  32m 6s    ~=
31%      several errors (compilation completed)
G)    5.17.0+[2]                     release  512000   mmap   23m 18s   ~76=
%      none
H)    5.17.0+[2]                     release  512000   loose  32m 33s   ~31=
%      several errors (compilation completed)
I)    5.17.0+[2] + msize patches[1]  release  4186112  mmap   20m 30s   ~83=
%      none
J)    5.17.0+[2] + msize patches[1]  release  4186112  loose  31m 21s   ~31=
%      several errors (compilation completed)
K)    5.10.84                        release  512000   mmap   39m 20s   ~80=
%      none
L)    5.10.84                        release  512000   loose  13m 40s   ~55=
%      none

[1] 9p msize patches v4 (2021-12-30): https://lore.kernel.org/netdev/cover.=
1640870037.git.linux_oss@crudebyte.com/
[2] Linux kernel "5.17.0+": SHA-1 710f5d627a98 ("Merge tag 'usb-5.18-rc1'",=
 2022-03-26 13:08:25)
[3] QEMU "v7.0.0-rc0+": SHA-1 1d60bb4b146 ("Merge tag 'pull-request-2022-03=
=2D15v2'", 2022-03-16 10:43:58)
[4] 9p as root filesystem: https://wiki.qemu.org/Documentation/9p_root_fs

As for fs-cache issues:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Disclaimer: I have not looked into the fs-cache sources yet, so I am not su=
re,
but my first impression is that probably something got broken with recent
fs-cache changes (see column errors, especially in comparison to case L) wh=
ich
did not generate any errors)? And also note the huge build duration=20
differences, especially in comparison to case L), so fs-cache (cache=3Dloos=
e)
also got significantly slower while cache=3Dmmap OTOH became significantly
faster?

About the errors: I actually already see errors with cache=3Dloose and rece=
nt
kernel version just when booting the guest OS. For these tests I chose some
sources which allowed me to complete the build to capture some benchmark as
well, I got some "soft" errors with those, but the build completed at least.
I had other sources OTOH which did not complete though and aborted with
certain invalid file descriptor errors, which I obviously could not use for
those benchmarks here.

debug/release .config: In the first runs with recent kernel 5.17.0+ I still
had debugging turned on, whereas the older kernel was optimized. So I repea=
ted
the tests of kernel 5.17.0+ with -O2 and debugging options turned off, but =
the
numbers only slightly improved. So debug vs. release does not seem to have a
significant impact on the results.

host cpu column: these were just very approximate numbers that I additional=
ly
wrote down to compare host CPU saturation during these tests.

As for latest msize patches (v4):
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D

large msize: In these tests there are a very large amount of rather small
chunk I/O in parallel, where a huge msize (e.g. 4MB) does not really bring
advantages. So this is different to my previous benchmarks which focused on
large chunk sequential I/O before, where large msize values could shine. You
can see that case A) is probably even a bit slower with msize=3D4MB, where =
I am
assuming that Treaddir requests still being msize large might hurt here with
msize=3D4MB in these tests. I still need to verify that though.

small msize: The results also suggest though that the msize patches bring
advantages with a smaller msize value in comparison to unpatched kernels. I
assume that's because of the last bunch of patches which reduce the size of
most 9p requests to what they really need, instead of simply allocating
always 'msize' for each 9p request as it is still right now on master.

  ...

And finally in response to your previous email, see below ...

On Samstag, 26. M=E4rz 2022 14:35:14 CEST asmadeus@codewreck.org wrote:
> (+David Howells in Cc as he's knows how that works better than me;
>  -syzbot lists as it doesn't really concern this bug)

+Greg Kurz, for 9p server part

> Christian Schoenebeck wrote on Sat, Mar 26, 2022 at 01:36:31PM +0100:
> > BTW, another issue that I am seeing for a long time affects the fs-cach=
e:
> > When I use cache=3Dmmap then things seem to be harmless, I periodically=
 see
> > messages like these, but that's about it:
> >=20
> > [90763.435562] FS-Cache: Duplicate cookie detected
> > [90763.436514] FS-Cache: O-cookie c=3D00dcb42f [p=3D00000003 fl=3D216 n=
c=3D0 na=3D0]
> > [90763.437795] FS-Cache: O-cookie d=3D0000000000000000{?} n=3D000000000=
0000000
> > [90763.440096] FS-Cache: O-key=3D[8] 'a7ab2c0000000000'
> > [90763.441656] FS-Cache: N-cookie c=3D00dcb4a7 [p=3D00000003 fl=3D2 nc=
=3D0 na=3D1]
> > [90763.446753] FS-Cache: N-cookie d=3D000000005b583d5a{9p.inode}
> > n=3D00000000212184fb [90763.448196] FS-Cache: N-key=3D[8] 'a7ab2c000000=
0000'
>=20
> hm, fscache code shouldn't be used for cache=3Dmmap, I'm surprised you can
> hit this...

I assume that you mean that 9p driver does not explicitly ask for fs-cache
being used for mmap. I see that 9p uses the kernel's generalized mmap
implementation:

https://github.com/torvalds/linux/blob/d888c83fcec75194a8a48ccd283953bdba7b=
2550/fs/9p/vfs_file.c#L481

I haven't dived further into this, but the kernel has to use some kind of
filesystem cache anyway to provide the mmap functionality, so I guess it ma=
kes
sense that I got those warning messages from the FS-Cache subsystem?

> > The real trouble starts when I use cache=3Dloose though, in this case I=
 get
> > all sorts of misbehaviours from time to time, especially complaining
> > about invalid file descriptors.
>=20
> ... but I did encouter these on cache=3Dloose/fscache, although I hadn't
> noticed any bad behaviour such as invalid file descriptors.
>=20
> > Any clues?
>=20
> Since I hadn't noticed real harm I didn't look too hard into it, I have
> a couple of ideas:
> - the cookie is just a truncated part of the inode number, it's possible
> we get real collisions because there are no guarantees there won't be
> identical inodes there.

I think with 'truncated' you actually mean what's going on 9p server (QEMU)
side, see below ...

> In particular, it's trivial to reproduce by exporting submounts:
>=20
> ## on host in export directory
> # mount -t tmpfs tmpfs m1
> # mount -t tmpfs tmpfs m2
> # echo foo > m1/a
> # echo bar > m2/a
> # ls -li m1 m2
> m1:
> total 4
> 2 -rw-r--r-- 1 asmadeus users 4 Mar 26 22:23 a
>=20
> m2:
> total 4
> 2 -rw-r--r-- 1 asmadeus users 4 Mar 26 22:23 a
>=20
> ## on client
> # /mnt/t/m*/a
> foo
> bar
> FS-Cache: Duplicate cookie detected
> FS-Cache: O-cookie c=3D0000099a [fl=3D4000 na=3D0 nA=3D0 s=3D-]
> FS-Cache: O-cookie V=3D00000006 [9p,tmp,]
> FS-Cache: O-key=3D[8] '0200000000000000'
> FS-Cache: N-cookie c=3D0000099b [fl=3D0 na=3D0 nA=3D0 s=3D-]
> FS-Cache: N-cookie V=3D00000006 [9p,tmp,]
> FS-Cache: N-key=3D[8] '0200000000000000'

With QEMU >=3D 5.2 you should see the following QEMU warning with your repr=
oducer:

"
qemu-system-x86_64: warning: 9p: Multiple devices detected in same VirtFS
export, which might lead to file ID collisions and severe misbehaviours on
guest! You should either use a separate export for each device shared from
host or use virtfs option 'multidevs=3Dremap'!
"

And after restarting QEMU with 'multidevs=3Dremap' you won't get such errors
anymore. I just tested this right now: without 'multidevs=3Dremap' I would =
get
those errors with your reproducer above, with 'multidevs=3Dremap' there were
no errors.

Background: the Linux 9p driver is using the 9p "QID path" as file ID, i.e.=
 as
key for looking up entries in the fs-cache:
https://github.com/torvalds/linux/blob/d888c83fcec75194a8a48ccd283953bdba7b=
2550/fs/9p/cache.c#L65

By default QEMU just uses the host file's inode number as "QID path". So if
you have multiple filesystems inside the exported tree, this can lead to
collisions. Usually we "should" place both the device ID number and inode
number into "QID path" to prevent that, but the problem is "QID path" is
currently only 64-bit large in the 9p protocol, so it is too small to hold
both device id and inode number:
http://ericvh.github.io/9p-rfc/rfc9p2000.html#anchor32

If 'multidevs=3Dremap' is passed to QEMU though then guaranteed unique "QID
path" numbers are generated, even if there are multiple filesystems mounted
inside the exported tree. So you won't get collisions in this case. This is
usually cost free, because we are using the fact that inode numbers are alw=
ays
sequentially generated by host file systems from 1 upwards. So on the left
hand side of inode numbers we usally have plenty of zeros and can prefix th=
em
with our own numbers there to prevent collissions while being able to squee=
ze
them into 64-bit.

> But as you can see despite the warning the content is properly
> different, and writing also works, so this probably isn't it... Although
> the fscache code we're using is totally different -- your dmesg output
> is from the "pre-netfs" code, so that might have gotten fixed as a side
> effect?
>=20
> - lifecycle diff=E9rence between inode and fscache entry.
> David pushed a patch a few years back to address this but it looks like
> it never got merged:
> https://lore.kernel.org/lkml/155231584487.2992.17466330160329385162.stgit=
@wa
> rthog.procyon.org.uk/
>=20
> the rationale is that we could evict the inode then reallocate it, and
> it'd generate a new fscache entry with the same key before the previous
> fscache entry had been freed.
> I'm not sure if that got fixed otherwise and it might not be possible
> anymore, I didn't follow that, but given

I don't know the current fs-cache implementation in the Linux kernel yet, s=
o I
can't comment on this part at this point.

>  - some other bug...
>=20
> If you have some kind of reproducer of invalid filedescriptor or similar
> errors I'd be happy to dig a bit more, I don't particularly like all
> aspect of our cache model but it's not good if it corrupts things.

Maybe you can reproduce this with the root fs setup [4] described above? As=
 I
said, I immediately get errors when guest OS is booting. So I don't have to
run something fancy to get errors with cache=3Dloose & recent kernel.

Best regards,
Christian Schoenebeck


