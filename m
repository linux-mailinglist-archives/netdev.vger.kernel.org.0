Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202E029E887
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 11:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgJ2KJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 06:09:16 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13879 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbgJ2KJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 06:09:14 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9a94cd0000>; Thu, 29 Oct 2020 03:09:17 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 29 Oct
 2020 10:09:09 +0000
Date:   Thu, 29 Oct 2020 12:09:06 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     "Michael S. Tsirkin" <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, <lingshan.zhu@intel.com>
Subject: Re: [PATCH] vhost: Use mutex to protect vq_irq setup
Message-ID: <20201029100906.GA137578@mtl-vdi-166.wap.labs.mlnx>
References: <20201028142004.GA100353@mtl-vdi-166.wap.labs.mlnx>
 <60e24a0e-0d72-51b3-216a-b3cf62fb1a58@redhat.com>
 <20201029073717.GA132479@mtl-vdi-166.wap.labs.mlnx>
 <7b92d057-75cc-8bee-6354-2fbefcd1850a@redhat.com>
 <20201029075035.GC132479@mtl-vdi-166.wap.labs.mlnx>
 <34c4c6c0-ca95-6940-1b3f-c8c6a9cee833@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <34c4c6c0-ca95-6940-1b3f-c8c6a9cee833@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603966157; bh=FGlDtQuDJoKIEGXin/GI+dJFzqeBXy5kpSfemYU1vqk=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:Content-Transfer-Encoding:
         In-Reply-To:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=qPKlbCzVNk/7rapIFfIHekIVPJwnTTaLkEJAZwcehTZP+UYIUxS/23OZteUFt6X4h
         D8qMTMgXfspLaLu1EpSX77gGnCBGvEw9DzTaXlNcltZd2s3VtZ0Nl+tQDPzJ70D5Xv
         Tbc097SYffYIsI8KS9w4SQ5GsHs58vTV4CZJgVUWo4t8DVBEGLX/Q6NQ9K92uEodaR
         c48RhvCdNEmFovsYMtzbQyns8Y3QcoqYREP/7whIzqPy6cec3dT+ix2WLVOztcze/M
         8NXz0UgVSIHPZWWykmRAQcPdTunv1GUVvuv7zBUJWoDht/tL5qZI8f0HGuRSFyiK7z
         u3nZ4zcyEhJVA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 04:08:24PM +0800, Jason Wang wrote:
>=20
> On 2020/10/29 =E4=B8=8B=E5=8D=883:50, Eli Cohen wrote:
> > On Thu, Oct 29, 2020 at 03:39:24PM +0800, Jason Wang wrote:
> > > On 2020/10/29 =E4=B8=8B=E5=8D=883:37, Eli Cohen wrote:
> > > > On Thu, Oct 29, 2020 at 03:03:24PM +0800, Jason Wang wrote:
> > > > > On 2020/10/28 =E4=B8=8B=E5=8D=8810:20, Eli Cohen wrote:
> > > > > > Both irq_bypass_register_producer() and irq_bypass_unregister_p=
roducer()
> > > > > > require process context to run. Change the call context lock fr=
om
> > > > > > spinlock to mutex to protect the setup process to avoid deadloc=
ks.
> > > > > >=20
> > > > > > Fixes: 265a0ad8731d ("vhost: introduce vhost_vring_call")
> > > > > > Signed-off-by: Eli Cohen<elic@nvidia.com>
> > > > > Hi Eli:
> > > > >=20
> > > > > During review we spot that the spinlock is not necessary. And it =
was already
> > > > > protected by vq mutex. So it was removed in this commit:
> > > > >=20
> > > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/commit/?id=3D86e182fe12ee5869022614457037097c70fe2ed1
> > > > >=20
> > > > > Thanks
> > > > >=20
> > > > I see, thanks.
> > > >=20
> > > > BTW, while testing irq bypassing, I noticed that qemu started crash=
ing
> > > > and I fail to boot the VM? Is that a known issue. I checked using
> > > > updated master branch of qemu updated yesterday.
> > > Not known yet.
> > >=20
> > >=20
> > > > Any ideas how to check this further?
> > > I would be helpful if you can paste the calltrace here.
> > >=20
> > I am not too familiar with qemu. Assuming I am using virsh start to boo=
t
> > the VM, how can I get the call trace?
>=20
>=20
> You probably need to configure qemu with --enable-debug. Then after VM is
> launching, you can use gdb to attach to the qemu process, then gdb may
> report a calltrace if qemu crashes.
>=20

I run qemu from the console (no virsh) and I get this message:

*** stack smashing detected ***: terminated
Aborted (core dumped)

When I run coredumpctl debug on the core file I see this backtrace:

#0  __GI_raise (sig=3Dsig@entry=3D6) at ../sysdeps/unix/sysv/linux/raise.c:=
50
#1  0x00007f0ca5b95895 in __GI_abort () at abort.c:79
#2  0x00007f0ca5bf0857 in __libc_message (action=3Daction@entry=3Ddo_abort,=
 fmt=3Dfmt@entry=3D0x7f0ca5d01c14 "*** %s ***: terminated\n") at ../sysdeps=
/posix/libc_fatal.c:155
#3  0x00007f0ca5c8177a in __GI___fortify_fail (msg=3Dmsg@entry=3D0x7f0ca5d0=
1bfc "stack smashing detected") at fortify_fail.c:26
#4  0x00007f0ca5c81746 in __stack_chk_fail () at stack_chk_fail.c:24
#5  0x000055ce01cd4d4e in vhost_vdpa_set_backend_cap (dev=3D0x55ce03800370)=
 at ../hw/virtio/vhost-vdpa.c:256
#6  0x000055ce01cbc42c in vhost_dev_set_features (dev=3Ddev@entry=3D0x55ce0=
3800370, enable_log=3D<optimized out>) at ../hw/virtio/vhost.c:820
#7  0x000055ce01cbf5b8 in vhost_dev_start (hdev=3Dhdev@entry=3D0x55ce038003=
70, vdev=3Dvdev@entry=3D0x55ce045edc70) at ../hw/virtio/vhost.c:1701
#8  0x000055ce01a57eab in vhost_net_start_one (dev=3D0x55ce045edc70, net=3D=
0x55ce03800370) at ../hw/net/vhost_net.c:246
#9  vhost_net_start (dev=3Ddev@entry=3D0x55ce045edc70, ncs=3D0x55ce04601510=
, total_queues=3Dtotal_queues@entry=3D1) at ../hw/net/vhost_net.c:351
#10 0x000055ce01cdafbc in virtio_net_vhost_status (status=3D<optimized out>=
, n=3D0x55ce045edc70) at ../hw/net/virtio-net.c:281
#11 virtio_net_set_status (vdev=3D0x55ce045edc70, status=3D<optimized out>)=
 at ../hw/net/virtio-net.c:362
#12 0x000055ce01c7015b in virtio_set_status (vdev=3Dvdev@entry=3D0x55ce045e=
dc70, val=3Dval@entry=3D15 '\017') at ../hw/virtio/virtio.c:1957
#13 0x000055ce01bdf4e8 in virtio_pci_common_write (opaque=3D0x55ce045e5ae0,=
 addr=3D<optimized out>, val=3D<optimized out>, size=3D<optimized out>) at =
../hw/virtio/virtio-pci.c:1258
#14 0x000055ce01ce05fc in memory_region_write_accessor
    (mr=3Dmr@entry=3D0x55ce045e64c0, addr=3D20, value=3Dvalue@entry=3D0x7f0=
c9ec6f7b8, size=3Dsize@entry=3D1, shift=3D<optimized out>, mask=3Dmask@entr=
y=3D255, attrs=3D...) at ../softmmu/memory.c:484
#15 0x000055ce01cdf11e in access_with_adjusted_size
    (addr=3Daddr@entry=3D20, value=3Dvalue@entry=3D0x7f0c9ec6f7b8, size=3Ds=
ize@entry=3D1, access_size_min=3D<optimized out>, access_size_max=3D<optimi=
zed out>, access_fn=3D
    0x55ce01ce0570 <memory_region_write_accessor>, mr=3D0x55ce045e64c0, att=
rs=3D...) at ../softmmu/memory.c:545
#16 0x000055ce01ce2933 in memory_region_dispatch_write (mr=3Dmr@entry=3D0x5=
5ce045e64c0, addr=3D20, data=3D<optimized out>, op=3D<optimized out>, attrs=
=3Dattrs@entry=3D...)
    at ../softmmu/memory.c:1494
#17 0x000055ce01c81380 in flatview_write_continue
    (fv=3Dfv@entry=3D0x7f0980000b90, addr=3Daddr@entry=3D4261412884, attrs=
=3Dattrs@entry=3D..., ptr=3Dptr@entry=3D0x7f0ca674f028, len=3Dlen@entry=3D1=
, addr1=3D<optimized out>, l=3D<optimized out>, mr=3D0x55ce045e64c0) at
/images/eli/src/newgits/qemu/include/qemu/host-utils.h:164
#18 0x000055ce01c842c5 in flatview_write (len=3D1, buf=3D0x7f0ca674f028, at=
trs=3D..., addr=3D4261412884, fv=3D0x7f0980000b90) at ../softmmu/physmem.c:=
2807
#19 address_space_write (as=3D0x55ce02740800 <address_space_memory>, addr=
=3D4261412884, attrs=3D..., buf=3Dbuf@entry=3D0x7f0ca674f028, len=3D1) at .=
./softmmu/physmem.c:2899
#20 0x000055ce01c8435a in address_space_rw (as=3D<optimized out>, addr=3D<o=
ptimized out>, attrs=3D...,=20
    attrs@entry=3D..., buf=3Dbuf@entry=3D0x7f0ca674f028, len=3D<optimized o=
ut>, is_write=3D<optimized out>) at ../softmmu/physmem.c:2909
#21 0x000055ce01cb0d76 in kvm_cpu_exec (cpu=3Dcpu@entry=3D0x55ce03827620) a=
t ../accel/kvm/kvm-all.c:2539
#22 0x000055ce01d2ea75 in kvm_vcpu_thread_fn (arg=3Darg@entry=3D0x55ce03827=
620) at ../accel/kvm/kvm-cpus.c:49
#23 0x000055ce01f05559 in qemu_thread_start (args=3D0x7f0c9ec6f9b0) at ../u=
til/qemu-thread-posix.c:521
#24 0x00007f0ca5d43432 in start_thread (arg=3D<optimized out>) at pthread_c=
reate.c:477
#25 0x00007f0ca5c71913 in clone () at ../sysdeps/unix/sysv/linux/x86_64/clo=
ne.S:95

The assert at frame 5 looks to me false.



> Thanks
>=20
>=20
