Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E284A2C5F18
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 04:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388967AbgK0DxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 22:53:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51622 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726908AbgK0DxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 22:53:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606449201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SzWUasFbh+ss1wzTbk2nMb/2xT+F5CZGRE9hJTNxirg=;
        b=RhitAHqFmXm6bbOEZqeoHmEX0QCigpS92aTaP+Ga7U+fUh3cKFQEEGZTS+KjrdYJzILs+A
        rTmdL3L19ULDEBt7vjGyCDfYpLh6mG2JUSwlkdumZ71L56iPc4jUAdV7QYHhoHlU1KnB8V
        i+dxCXb9Bf+bRDEw6mgI4BK7Z+riMck=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-5cU5D7mFP9apiwLKa8gFXA-1; Thu, 26 Nov 2020 22:53:17 -0500
X-MC-Unique: 5cU5D7mFP9apiwLKa8gFXA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 166F01005D50;
        Fri, 27 Nov 2020 03:53:16 +0000 (UTC)
Received: from [10.72.13.168] (ovpn-13-168.pek2.redhat.com [10.72.13.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D11D60BF1;
        Fri, 27 Nov 2020 03:53:10 +0000 (UTC)
Subject: Re: [PATCH 0/7] Introduce vdpa management tool
To:     Parav Pandit <parav@nvidia.com>,
        virtualization@lists.linux-foundation.org
Cc:     mst@redhat.com, elic@nvidia.com, netdev@vger.kernel.org,
        =?UTF-8?B?6LCi5rC45ZCJ?= <xieyongji@bytedance.com>
References: <20201112064005.349268-1-parav@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5b2235f6-513b-dbc9-3670-e4c9589b4d1f@redhat.com>
Date:   Fri, 27 Nov 2020 11:53:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201112064005.349268-1-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/11/12 下午2:39, Parav Pandit wrote:
> This patchset covers user requirements for managing existing vdpa devices,
> using a tool and its internal design notes for kernel drivers.
>
> Background and user requirements:
> ----------------------------------
> (1) Currently VDPA device is created by driver when driver is loaded.
> However, user should have a choice when to create or not create a vdpa device
> for the underlying parent device.
>
> For example, mlx5 PCI VF and subfunction device supports multiple classes of
> device such netdev, vdpa, rdma. Howevever it is not required to always created
> vdpa device for such device.
>
> (2) In another use case, a device may support creating one or multiple vdpa
> device of same or different class such as net and block.
> Creating vdpa devices at driver load time further limits this use case.
>
> (3) A user should be able to monitor and query vdpa queue level or device level
> statistics for a given vdpa device.
>
> (4) A user should be able to query what class of vdpa devices are supported
> by its parent device.
>
> (5) A user should be able to view supported features and negotiated features
> of the vdpa device.
>
> (6) A user should be able to create a vdpa device in vendor agnostic manner
> using single tool.
>
> Hence, it is required to have a tool through which user can create one or more
> vdpa devices from a parent device which addresses above user requirements.
>
> Example devices:
> ----------------
>   +-----------+ +-----------+ +---------+ +--------+ +-----------+
>   |vdpa dev 0 | |vdpa dev 1 | |rdma dev | |netdev  | |vdpa dev 3 |
>   |type=net   | |type=block | |mlx5_0   | |ens3f0  | |type=net   |
>   +----+------+ +-----+-----+ +----+----+ +-----+--+ +----+------+
>        |              |            |            |         |
>        |              |            |            |         |
>   +----+-----+        |       +----+----+       |    +----+----+
>   |  mlx5    +--------+       |mlx5     +-------+    |mlx5     |
>   |pci vf 2  |                |pci vf 4 |            |pci sf 8 |
>   |03:00:2   |                |03:00.4  |            |mlx5_sf.8|
>   +----+-----+                +----+----+            +----+----+
>        |                           |                      |
>        |                      +----+-----+                |
>        +----------------------+mlx5      +----------------+
>                               |pci pf 0  |
>                               |03:00.0   |
>                               +----------+
>
> vdpa tool:
> ----------
> vdpa tool is a tool to create, delete vdpa devices from a parent device. It is a
> tool that enables user to query statistics, features and may be more attributes
> in future.
>
> vdpa tool command draft:
> ------------------------
> (a) List parent devices which supports creating vdpa devices.
> It also shows which class types supported by this parent device.
> In below command example two parent devices support vdpa device creation.
> First is PCI VF whose bdf is 03.00:2.
> Second is PCI VF whose name is 03:00.4.
> Third is PCI SF whose name is mlx5_core.sf.8
>
> $ vdpa parentdev list
> vdpasim
>    supported_classes
>      net
> pci/0000:03.00:3
>    supported_classes
>      net block
> pci/0000:03.00:4
>    supported_classes
>      net block
> auxiliary/mlx5_core.sf.8
>    supported_classes
>      net
>
> (b) Now add a vdpa device of networking class and show the device.
> $ vdpa dev add parentdev pci/0000:03.00:2 type net name foo0 $ vdpa dev show foo0
> foo0: parentdev pci/0000:03.00:2 type network parentdev vdpasim vendor_id 0 max_vqs 2 max_vq_size 256
>
> (c) Show features of a vdpa device
> $ vdpa dev features show foo0
> supported
>    iommu platform
>    version 1
>
> (d) Dump vdpa device statistics
> $ vdpa dev stats show foo0
> kickdoorbells 10
> wqes 100
>
> (e) Now delete a vdpa device previously created.
> $ vdpa dev del foo0
>
> vdpa tool support in this patchset:
> -----------------------------------
> vdpa tool is created to create, delete and query vdpa devices.
> examples:
> Show vdpa parent device that supports creating, deleting vdpa devices.
>
> $ vdpa parentdev show
> vdpasim:
>    supported_classes
>      net
>
> $ vdpa parentdev show -jp
> {
>      "show": {
>         "vdpasim": {
>            "supported_classes": {
>               "net"
>          }
>      }
> }
>
> Create a vdpa device of type networking named as "foo2" from the parent device vdpasim:
>
> $ vdpa dev add parentdev vdpasim type net name foo2
>
> Show the newly created vdpa device by its name:
> $ vdpa dev show foo2
> foo2: type network parentdev vdpasim vendor_id 0 max_vqs 2 max_vq_size 256
>
> $ vdpa dev show foo2 -jp
> {
>      "dev": {
>          "foo2": {
>              "type": "network",
>              "parentdev": "vdpasim",
>              "vendor_id": 0,
>              "max_vqs": 2,
>              "max_vq_size": 256
>          }
>      }
> }
>
> Delete the vdpa device after its use:
> $ vdpa dev del foo2
>
> vdpa tool support by kernel:
> ----------------------------
> vdpa tool user interface will be supported by existing vdpa kernel framework,
> i.e. drivers/vdpa/vdpa.c It services user command through a netlink interface.
>
> Each parent device registers supported callback operations with vdpa subsystem
> through which vdpa device(s) can be managed.
>
> FAQs:
> -----
> 1. Where does userspace vdpa tool reside which users can use?
> Ans: vdpa tool can possibly reside in iproute2 [1] as it enables user to
> create vdpa net devices.
>
> 2. Why not create and delete vdpa device using sysfs/configfs?
> Ans:
> (a) A device creation may involve passing one or more attributes.
> Passing multiple attributes and returning error code and more verbose
> information for invalid attributes cannot be handled by sysfs/configfs.
>
> (b) netlink framework is rich that enables user space and kernel driver to
> provide nested attributes.
>
> (c) Exposing device specific file under sysfs without net namespace
> awareness exposes details to multiple containers. Instead exposing
> attributes via a netlink socket secures the communication channel with kernel.
>
> (d) netlink socket interface enables to run syscaller kernel tests.
>
> 3. Why not use ioctl() interface?
> Ans: ioctl() interface replicates the necessary plumbing which already
> exists through netlink socket.
>
> 4. What happens when one or more user created vdpa devices exist for a
> parent PCI VF or SF and such parent device is removed?
> Ans: All user created vdpa devices are removed that belong to a parent.
>
> [1] git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git
>
> Next steps:
> -----------
> (a) Post this patchset and iproute2/vdpa inclusion, remaining two drivers
> will be coverted to support vdpa tool instead of creating unmanaged default
> device on driver load.
> (b) More net specific parameters such as mac, mtu will be added.
> (c) Features bits get and set interface will be added.


Adding Yong Ji for sharing some thoughts from the view of userspace vDPA 
device.

Thanks


