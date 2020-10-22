Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739A4295C54
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 11:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896244AbgJVJ7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 05:59:30 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:49935 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2896226AbgJVJ73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 05:59:29 -0400
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 655A05C19C9;
        Thu, 22 Oct 2020 17:59:25 +0800 (CST)
Subject: Re: [PATCH net] vdpa/mlx5: Fix miss to set VIRTIO_NET_S_LINK_UP for
 virtio_net_config
To:     Eli Cohen <elic@nvidia.com>
Cc:     netdev@vger.kernel.org, eli@mellanox.com
References: <1603098438-20200-1-git-send-email-wenxu@ucloud.cn>
 <b2ceb319-8447-b804-2965-4e5844b6fa36@redhat.com>
 <20201020074453.GA158482@mtl-vdi-166.wap.labs.mlnx>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <401b2eb1-f77b-f7d5-8d6f-03ec30e81d6a@ucloud.cn>
Date:   Thu, 22 Oct 2020 17:59:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201020074453.GA158482@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZHkseH0pNGUlCQh9MVkpNS0hITUtMTU5NS0xVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6K006LAw5Nz5IHUlLVghLQxUq
        GSMwCz5VSlVKTUtISE1LTE1OTEJOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFIQkpKNwY+
X-HM-Tid: 0a754fbfb6662087kuqy655a05c19c9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi mellanox team,


I test the mlx5 vdpa  in linux-5.9 and meet several problem.


# lspci | grep Ether | grep Dx
b3:00.0 Ethernet controller: Mellanox Technologies MT2892 Family [ConnectX-6 Dx]
b3:00.1 Ethernet controller: Mellanox Technologies MT2892 Family [ConnectX-6 Dx]

# ethtool -i net2
driver: mlx5e_rep
version: 5.9.0
firmware-version: 22.28.1002 (MT_0000000430)
expansion-rom-version:
bus-info: 0000:b3:00.0
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: no


init switchdev:


# echo 1 > /sys/class/net/net2/device/sriov_numvfs
# echo 0000:b3:00.2 > /sys/bus/pci/drivers/mlx5_core/unbind
# devlink dev eswitch set pci/0000:b3:00.0  mode switchdev encap enable

# modprobe vdpa vhost-vdpa mlx5_vdpa

# ip l set dev net2 vf 0 mac 52:90:01:00:02:13
# echo 0000:b3:00.2 > /sys/bus/pci/drivers/mlx5_core/bind


setup vm:

# qemu-system-x86_64 -name test  -enable-kvm -smp 16,sockets=2,cores=8,threads=1 -m 8192 -drive file=./centos7.qcow2,format=qcow2,if=none,id=drive-virtio-disk0 -device virtio-blk-pci,scsi=off,bus=pci.0,addr=0x7,drive=drive-virtio-disk0,id=virtio-disk0,bootindex=1 -netdev type=vhost-vdpa,vhostdev=/dev/vhost-vdpa-0,id=vhost-vdpa0 -device virtio-net-pci,netdev=vhost-vdpa0,page-per-vq=on,iommu_platform=on,id=net0,bus=pci.0,addr=0x3,disable-legacy=on -vnc 0.0.0.0:0


In the vm:  virtio net device  eth0 with ip address 10.0.0.75/24

On the host: VF0 rep device pf0vf0 with ip address 10.0.0.7/24


problem 1:

On the host:

# ping 10.0.0.75

Some times there will be loss packets.

And in the VM:

dmesg shows:

eth0: bad tso: type 100, size: 0

eth0: bad tso: type 10, size: 28


So I think maybe the vnet header is not init with 0?  And Then I clear the gso_type, gso_size and flags in the virtio_net driver.  There is no packets dropped.


problem 2:

In the vm: iperf -s

On the host: iperf -c 10.0.0.75 -t 100 -i 2.


The tcp connection can't established for the syn+ack with partail cum but not handle correct by hardware.

After I set the csum off  for eth0 in the vm, the problem is resolved. Although the mlx5_vnet support VIRTIO_NET_F_CSUM feature.



problem 3:


The iperf perofrmance not stable before I disable the pf0vf0 tso offload

#ethtool -K pf0vf0 tso off


I know the mlx5_vnet did not support feature VIRTIO_NET_F_GUEST_TSO4. But the hardware can't  cut the big tso packet to several small tcp packet and send to virtio  net device?




BR

wenxu

