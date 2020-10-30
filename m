Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B43729FF3F
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 08:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgJ3H6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 03:58:36 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:36616 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgJ3H6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 03:58:35 -0400
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 2BF895C1DCA;
        Fri, 30 Oct 2020 15:50:23 +0800 (CST)
Subject: Re: mlx5_vdpa problem
To:     Eli Cohen <elic@nvidia.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <401b2eb1-f77b-f7d5-8d6f-03ec30e81d6a@ucloud.cn>
 <258f86a8-d6ae-010a-11f8-c155b1df4723@ucloud.cn>
 <20201029124544.GC139728@mtl-vdi-166.wap.labs.mlnx>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <40968d30-f4c4-5f9c-5c6c-fe3d7e5571a3@ucloud.cn>
Date:   Fri, 30 Oct 2020 15:50:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201029124544.GC139728@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZThpLGk9NGRlKThoaVkpNS09LT09JSUhPTktVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MTI6Lzo5ND5MCU5CHQ4SDSwW
        Nz0KCylVSlVKTUtPS09PSUlITE1OVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFPQ05KNwY+
X-HM-Tid: 0a75787c737f2087kuqy2bf895c1dca
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eli,


Thanks for your reply.


I update the firmware to the lasted one

firmware-version: 22.28.4000 (MT_0000000430)


I find there are the same problems as my description.

It is the same for the test what your suggestion.

I did the experiment with two hosts so the host the
representor for your VF and the uplink representor are connected to an
ovs switch and other host is configured with ip address 10.0.0.7/24.

And the ovs enable hw-offload, So the packet don't go through rep port of VF.
But there are the same problems. I think it maybe a FW bug. Thx.

On 10/29/2020 8:45 PM, Eli Cohen wrote:
> On Thu, Oct 22, 2020 at 06:40:56PM +0800, wenxu wrote:
>
> Please make sure your firmware is updated.
>
> https://www.mellanox.com/support/firmware/connectx6dx
>
>> Hi mellanox team,
>>
>>
>> I test the mlx5 vdpa  in linux-5.9 and meet several problem.
>>
>>
>> # lspci | grep Ether | grep Dx
>> b3:00.0 Ethernet controller: Mellanox Technologies MT2892 Family [ConnectX-6 Dx]
>> b3:00.1 Ethernet controller: Mellanox Technologies MT2892 Family [ConnectX-6 Dx]
>>
>> # ethtool -i net2
>> driver: mlx5e_rep
>> version: 5.9.0
>> firmware-version: 22.28.1002 (MT_0000000430)
>> expansion-rom-version:
>> bus-info: 0000:b3:00.0
>> supports-statistics: yes
>> supports-test: no
>> supports-eeprom-access: no
>> supports-register-dump: no
>> supports-priv-flags: no
>>
>>
>> init switchdev:
>>
>>
>> # echo 1 > /sys/class/net/net2/device/sriov_numvfs
>> # echo 0000:b3:00.2 > /sys/bus/pci/drivers/mlx5_core/unbind
>> # devlink dev eswitch set pci/0000:b3:00.0  mode switchdev encap enable
>>
>> # modprobe vdpa vhost-vdpa mlx5_vdpa
>>
>> # ip l set dev net2 vf 0 mac 52:90:01:00:02:13
>> # echo 0000:b3:00.2 > /sys/bus/pci/drivers/mlx5_core/bind
>>
>>
>> setup vm:
>>
>> # qemu-system-x86_64 -name test  -enable-kvm -smp 16,sockets=2,cores=8,threads=1 -m 8192 -drive file=./centos7.qcow2,format=qcow2,if=none,id=drive-virtio-disk0 -device virtio-blk-pci,scsi=off,bus=pci.0,addr=0x7,drive=drive-virtio-disk0,id=virtio-disk0,bootindex=1 -netdev type=vhost-vdpa,vhostdev=/dev/vhost-vdpa-0,id=vhost-vdpa0 -device virtio-net-pci,netdev=vhost-vdpa0,page-per-vq=on,iommu_platform=on,id=net0,bus=pci.0,addr=0x3,disable-legacy=on -vnc 0.0.0.0:0
>>
>>
>> In the vm:  virtio net device  eth0 with ip address 10.0.0.75/24
>>
>> On the host: VF0 rep device pf0vf0 with ip address 10.0.0.7/24
>>
>>
>> problem 1:
>>
>> On the host:
>>
>> # ping 10.0.0.75
>>
>> Some times there will be loss packets.
>>
>> And in the VM:
>>
>> dmesg shows:
>>
>> eth0: bad tso: type 100, size: 0
>>
>> eth0: bad tso: type 10, size: 28
>>
>>
>> So I think maybe the vnet header is not init with 0?  And Then I clear the gso_type, gso_size and flags in the virtio_net driver.  There is no packets dropped.
>>
>>
>> problem 2:
>>
>> In the vm: iperf -s
>>
>> On the host: iperf -c 10.0.0.75 -t 100 -i 2.
>>
>>
>> The tcp connection can't established for the syn+ack with partail cum but not handle correct by hardware.
>>
>> After I set the csum off  for eth0 in the vm, the problem is resolved. Although the mlx5_vnet support VIRTIO_NET_F_CSUM feature.
>>
>>
>>
>> problem 3:
>>
>>
>> The iperf perofrmance not stable before I disable the pf0vf0 tso offload
>>
>> #ethtool -K pf0vf0 tso off
>>
>>
>> I know the mlx5_vnet did not support feature VIRTIO_NET_F_GUEST_TSO4. But the hardware can't  cut the big tso packet to several small tcp packet and send to virtio  net device?
>>
>>
>>
>>
>> BR
>>
>> wenxu
>>
>>
>>
