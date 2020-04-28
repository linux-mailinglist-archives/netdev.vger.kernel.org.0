Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C091BB895
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 10:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgD1INq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 04:13:46 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25493 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726765AbgD1INp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 04:13:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588061624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YyRKuzpWR77tocYAqun+YTjfRtHpPA8xvoTqR86LZ0M=;
        b=NTEZFyhlHemPrIR9QkcZhAQkpW+dkONboek+55ynMQ5kmRehZu8CiKIaC/k5TUtCgjezxV
        jGsS4+0IHPLL4aQ6aPvtSpQFcGBKB0g9Ndibpj6Ga0ac1FdkRGmnZ6veC+LfljkGWOfTT0
        0CdnbX2yTB3d+0xLhQ8r3BAq1TAVv4Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-zbElCxm3MAqo-lGPyHfa2Q-1; Tue, 28 Apr 2020 04:13:35 -0400
X-MC-Unique: zbElCxm3MAqo-lGPyHfa2Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A758A107B7C5;
        Tue, 28 Apr 2020 08:13:33 +0000 (UTC)
Received: from [10.72.13.181] (ovpn-13-181.pek2.redhat.com [10.72.13.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C9F860D53;
        Tue, 28 Apr 2020 08:13:23 +0000 (UTC)
Subject: Re: [PATCH net-next 0/3] vsock: support network namespace
To:     Stefano Garzarella <sgarzare@redhat.com>, davem@davemloft.net,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        netdev@vger.kernel.org
References: <20200116172428.311437-1-sgarzare@redhat.com>
 <20200427142518.uwssa6dtasrp3bfc@steredhat>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <224cdc10-1532-7ddc-f113-676d43d8f322@redhat.com>
Date:   Tue, 28 Apr 2020 16:13:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427142518.uwssa6dtasrp3bfc@steredhat>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/27 =E4=B8=8B=E5=8D=8810:25, Stefano Garzarella wrote:
> Hi David, Michael, Stefan,
> I'm restarting to work on this topic since Kata guys are interested to
> have that, especially on the guest side.
>
> While working on the v2 I had few doubts, and I'd like to have your
> suggestions:
>
>   1. netns assigned to the device inside the guest
>
>     Currently I assigned this device to 'init_net'. Maybe it is better
>     if we allow the user to decide which netns assign to the device
>     or to disable this new feature to have the same behavior as before
>     (host reachable from any netns).
>     I think we can handle this in the vsock core and not in the single
>     transports.
>
>     The simplest way that I found, is to add a new
>     IOCTL_VM_SOCKETS_ASSIGN_G2H_NETNS to /dev/vsock to enable the featu=
re
>     and assign the device to the same netns of the process that do the
>     ioctl(), but I'm not sure it is clean enough.
>
>     Maybe it is better to add new rtnetlink messages, but I'm not sure =
if
>     it is feasible since we don't have a netdev device.
>
>     What do you suggest?


As we've discussed, it should be a netdev probably in either guest or=20
host side. And it would be much simpler if we want do implement=20
namespace then. No new API is needed.

Thanks


>
>
>   2. netns assigned in the host
>
>      As Michael suggested, I added a new /dev/vhost-vsock-netns to allo=
w
>      userspace application to use this new feature, leaving to
>      /dev/vhost-vsock the previous behavior (guest reachable from any
>      netns).
>
>      I like this approach, but I had these doubts:
>
>      - I need to allocate a new minor for that device (e.g.
>        VHOST_VSOCK_NETNS_MINOR) or is there an alternative way that I c=
an
>        use?
>
>      - It is vhost-vsock specific, should we provide something handled =
in
>        the vsock core, maybe centralizing the CID allocation and adding=
 a
>        new IOCTL or rtnetlink message like for the guest side?
>        (maybe it could be a second step, and for now we can continue wi=
th
>        the new device)
>
>
> Thanks for the help,
> Stefano
>
>
> On Thu, Jan 16, 2020 at 06:24:25PM +0100, Stefano Garzarella wrote:
>> RFC -> v1:
>>   * added 'netns' module param to vsock.ko to enable the
>>     network namespace support (disabled by default)
>>   * added 'vsock_net_eq()' to check the "net" assigned to a socket
>>     only when 'netns' support is enabled
>>
>> RFC: https://patchwork.ozlabs.org/cover/1202235/
>>
>> Now that we have multi-transport upstream, I started to take a look to
>> support network namespace in vsock.
>>
>> As we partially discussed in the multi-transport proposal [1], it coul=
d
>> be nice to support network namespace in vsock to reach the following
>> goals:
>> - isolate host applications from guest applications using the same por=
ts
>>    with CID_ANY
>> - assign the same CID of VMs running in different network namespaces
>> - partition VMs between VMMs or at finer granularity
>>
>> This new feature is disabled by default, because it changes vsock's
>> behavior with network namespaces and could break existing applications=
.
>> It can be enabled with the new 'netns' module parameter of vsock.ko.
>>
>> This implementation provides the following behavior:
>> - packets received from the host (received by G2H transports) are
>>    assigned to the default netns (init_net)
>> - packets received from the guest (received by H2G - vhost-vsock) are
>>    assigned to the netns of the process that opens /dev/vhost-vsock
>>    (usually the VMM, qemu in my tests, opens the /dev/vhost-vsock)
>>      - for vmci I need some suggestions, because I don't know how to d=
o
>>        and test the same in the vmci driver, for now vmci uses the
>>        init_net
>> - loopback packets are exchanged only in the same netns
>>
>> I tested the series in this way:
>> l0_host$ qemu-system-x86_64 -m 4G -M accel=3Dkvm -smp 4 \
>>              -drive file=3D/tmp/vsockvm0.img,if=3Dvirtio --nographic \
>>              -device vhost-vsock-pci,guest-cid=3D3
>>
>> l1_vm$ echo 1 > /sys/module/vsock/parameters/netns
>>
>> l1_vm$ ip netns add ns1
>> l1_vm$ ip netns add ns2
>>   # same CID on different netns
>> l1_vm$ ip netns exec ns1 qemu-system-x86_64 -m 1G -M accel=3Dkvm -smp =
2 \
>>              -drive file=3D/tmp/vsockvm1.img,if=3Dvirtio --nographic \
>>              -device vhost-vsock-pci,guest-cid=3D4
>> l1_vm$ ip netns exec ns2 qemu-system-x86_64 -m 1G -M accel=3Dkvm -smp =
2 \
>>              -drive file=3D/tmp/vsockvm2.img,if=3Dvirtio --nographic \
>>              -device vhost-vsock-pci,guest-cid=3D4
>>
>>   # all iperf3 listen on CID_ANY and port 5201, but in different netns
>> l1_vm$ ./iperf3 --vsock -s # connection from l0 or guests started
>>                             # on default netns (init_net)
>> l1_vm$ ip netns exec ns1 ./iperf3 --vsock -s
>> l1_vm$ ip netns exec ns1 ./iperf3 --vsock -s
>>
>> l0_host$ ./iperf3 --vsock -c 3
>> l2_vm1$ ./iperf3 --vsock -c 2
>> l2_vm2$ ./iperf3 --vsock -c 2
>>
>> [1] https://www.spinics.net/lists/netdev/msg575792.html
>>
>> Stefano Garzarella (3):
>>    vsock: add network namespace support
>>    vsock/virtio_transport_common: handle netns of received packets
>>    vhost/vsock: use netns of process that opens the vhost-vsock device
>>
>>   drivers/vhost/vsock.c                   | 29 ++++++++++++-----
>>   include/linux/virtio_vsock.h            |  2 ++
>>   include/net/af_vsock.h                  |  7 +++--
>>   net/vmw_vsock/af_vsock.c                | 41 +++++++++++++++++++----=
--
>>   net/vmw_vsock/hyperv_transport.c        |  5 +--
>>   net/vmw_vsock/virtio_transport.c        |  2 ++
>>   net/vmw_vsock/virtio_transport_common.c | 12 ++++++--
>>   net/vmw_vsock/vmci_transport.c          |  5 +--
>>   8 files changed, 78 insertions(+), 25 deletions(-)
>>
>> --=20
>> 2.24.1
>>

