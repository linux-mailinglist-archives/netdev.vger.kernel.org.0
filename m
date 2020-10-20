Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F5129349E
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 08:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403760AbgJTGN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 02:13:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55996 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391969AbgJTGN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 02:13:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603174403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wAhzmxdGMaPH2K6G8brb+MS2EAJ7Xgyblnfd/oBjiTQ=;
        b=MzswtTp+8BcXqY0iQmu2EJQnHf6g2j6JFUNf0dQR8sJjW896eQ0x7KHubzaIJjoNJpQ9bc
        LzQUugqq4liox7/5McwP+t++AJeJ94Q/3x5APWV3V5M6dhH17JKgVsjDta+6Z8F8waCxtF
        OzVksag9frREy1jPbYJgOlDOLfMLl88=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-n0i3K6bjMdWt8pKIgMOSHA-1; Tue, 20 Oct 2020 02:13:19 -0400
X-MC-Unique: n0i3K6bjMdWt8pKIgMOSHA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3F0B57051;
        Tue, 20 Oct 2020 06:13:16 +0000 (UTC)
Received: from [10.72.13.171] (ovpn-13-171.pek2.redhat.com [10.72.13.171])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE2BD60BF3;
        Tue, 20 Oct 2020 06:13:07 +0000 (UTC)
Subject: Re: [PATCH net v2] Revert "virtio-net: ethtool configurable RXCSUM"
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20201018103122.454967-1-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a061697d-844d-bb98-7009-69760fe9918c@redhat.com>
Date:   Tue, 20 Oct 2020 14:13:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201018103122.454967-1-mst@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/20 上午1:32, Michael S. Tsirkin wrote:
> This reverts commit 3618ad2a7c0e78e4258386394d5d5f92a3dbccf8.
>
> When the device does not have a control vq (e.g. when using a
> version of QEMU based on upstream v0.10 or older, or when specifying
> ctrl_vq=off,ctrl_rx=off,ctrl_vlan=off,ctrl_rx_extra=off,ctrl_mac_addr=off
> for the device on the QEMU command line), that commit causes a crash:
>
> [   72.229171] kernel BUG at drivers/net/virtio_net.c:1667!
> [   72.230266] invalid opcode: 0000 [#1] PREEMPT SMP
> [   72.231172] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.9.0-rc8-02934-g3618ad2a7c0e7 #1
> [   72.231172] EIP: virtnet_send_command+0x120/0x140
> [   72.231172] Code: 00 0f 94 c0 8b 7d f0 65 33 3d 14 00 00 00 75 1c 8d 65 f4 5b 5e 5f 5d c3 66 90 be 01 00 00 00 e9 6e ff ff ff 8d b6 00
> +00 00 00 <0f> 0b e8 d9 bb 82 00 eb 17 8d b4 26 00 00 00 00 8d b4 26 00 00 00
> [   72.231172] EAX: 0000000d EBX: f72895c0 ECX: 00000017 EDX: 00000011
> [   72.231172] ESI: f7197800 EDI: ed69bd00 EBP: ed69bcf4 ESP: ed69bc98
> [   72.231172] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010246
> [   72.231172] CR0: 80050033 CR2: 00000000 CR3: 02c84000 CR4: 000406f0
> [   72.231172] Call Trace:
> [   72.231172]  ? __virt_addr_valid+0x45/0x60
> [   72.231172]  ? ___cache_free+0x51f/0x760
> [   72.231172]  ? kobject_uevent_env+0xf4/0x560
> [   72.231172]  virtnet_set_guest_offloads+0x4d/0x80
> [   72.231172]  virtnet_set_features+0x85/0x120
> [   72.231172]  ? virtnet_set_guest_offloads+0x80/0x80
> [   72.231172]  __netdev_update_features+0x27a/0x8e0
> [   72.231172]  ? kobject_uevent+0xa/0x20
> [   72.231172]  ? netdev_register_kobject+0x12c/0x160
> [   72.231172]  register_netdevice+0x4fe/0x740
> [   72.231172]  register_netdev+0x1c/0x40
> [   72.231172]  virtnet_probe+0x728/0xb60
> [   72.231172]  ? _raw_spin_unlock+0x1d/0x40
> [   72.231172]  ? virtio_vdpa_get_status+0x1c/0x20
> [   72.231172]  virtio_dev_probe+0x1c6/0x271
> [   72.231172]  really_probe+0x195/0x2e0
> [   72.231172]  driver_probe_device+0x26/0x60
> [   72.231172]  device_driver_attach+0x49/0x60
> [   72.231172]  __driver_attach+0x46/0xc0
> [   72.231172]  ? device_driver_attach+0x60/0x60
> [   72.231172]  bus_add_driver+0x197/0x1c0
> [   72.231172]  driver_register+0x66/0xc0
> [   72.231172]  register_virtio_driver+0x1b/0x40
> [   72.231172]  virtio_net_driver_init+0x61/0x86
> [   72.231172]  ? veth_init+0x14/0x14
> [   72.231172]  do_one_initcall+0x76/0x2e4
> [   72.231172]  ? rdinit_setup+0x2a/0x2a
> [   72.231172]  do_initcalls+0xb2/0xd5
> [   72.231172]  kernel_init_freeable+0x14f/0x179
> [   72.231172]  ? rest_init+0x100/0x100
> [   72.231172]  kernel_init+0xd/0xe0
> [   72.231172]  ret_from_fork+0x1c/0x30
> [   72.231172] Modules linked in:
> [   72.269563] ---[ end trace a6ebc4afea0e6cb1 ]---
>
> The reason is that virtnet_set_features now calls virtnet_set_guest_offloads
> unconditionally, it used to only call it when there is something
> to configure.
>
> If device does not have a control vq, everything breaks.
>
> Looking at this some more, I noticed that it's not really checking the
> hardware too much. E.g.
>
>          if ((dev->features ^ features) & NETIF_F_LRO) {
>                  if (features & NETIF_F_LRO)
>                          offloads |= GUEST_OFFLOAD_LRO_MASK &
>                                      vi->guest_offloads_capable;
>                  else
>                          offloads &= ~GUEST_OFFLOAD_LRO_MASK;
>          }
>
> and
>
>                                  (1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
>                                  (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
>                                  (1ULL << VIRTIO_NET_F_GUEST_UFO))
>
> But there's no guarantee that e.g. VIRTIO_NET_F_GUEST_TSO6 is set.
>
> If it isn't command should not send it.
>
> Further
>
> static int virtnet_set_features(struct net_device *dev,
>                                  netdev_features_t features)
> {
>          struct virtnet_info *vi = netdev_priv(dev);
>          u64 offloads = vi->guest_offloads;
>
> seems wrong since guest_offloads is zero initialized,


I'm not sure I get here.

Did you mean vi->guest_offloads?

We initialize it during probe

     for (i = 0; i < ARRAY_SIZE(guest_offloads); i++)
         if (virtio_has_feature(vi->vdev, guest_offloads[i]))
             set_bit(guest_offloads[i], &vi->guest_offloads);


> it does not reflect the state after reset which comes from
> the features.
>
> Revert the original commit for now.
>
> Cc: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Fixes: 3618ad2a7c0e7 ("virtio-net: ethtool configurable RXCSUM")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
> changes from v1:
> 	- clarify how to reproduce the bug in the log
>
>
>   drivers/net/virtio_net.c | 50 +++++++++++-----------------------------
>   1 file changed, 13 insertions(+), 37 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index d2d2c4a53cf2..21b71148c532 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -68,8 +68,6 @@ static const unsigned long guest_offloads[] = {
>   				(1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
>   				(1ULL << VIRTIO_NET_F_GUEST_UFO))
>   
> -#define GUEST_OFFLOAD_CSUM_MASK (1ULL << VIRTIO_NET_F_GUEST_CSUM)
> -
>   struct virtnet_stat_desc {
>   	char desc[ETH_GSTRING_LEN];
>   	size_t offset;
> @@ -2524,48 +2522,29 @@ static int virtnet_get_phys_port_name(struct net_device *dev, char *buf,
>   	return 0;
>   }
>   
> -static netdev_features_t virtnet_fix_features(struct net_device *netdev,
> -					      netdev_features_t features)
> -{
> -	/* If Rx checksum is disabled, LRO should also be disabled. */
> -	if (!(features & NETIF_F_RXCSUM))
> -		features &= ~NETIF_F_LRO;
> -
> -	return features;
> -}
> -
>   static int virtnet_set_features(struct net_device *dev,
>   				netdev_features_t features)
>   {
>   	struct virtnet_info *vi = netdev_priv(dev);
> -	u64 offloads = vi->guest_offloads;
> +	u64 offloads;
>   	int err;
>   
> -	/* Don't allow configuration while XDP is active. */
> -	if (vi->xdp_queue_pairs)
> -		return -EBUSY;
> -
>   	if ((dev->features ^ features) & NETIF_F_LRO) {
> +		if (vi->xdp_queue_pairs)
> +			return -EBUSY;
> +
>   		if (features & NETIF_F_LRO)
> -			offloads |= GUEST_OFFLOAD_LRO_MASK &
> -				    vi->guest_offloads_capable;
> +			offloads = vi->guest_offloads_capable;
>   		else
> -			offloads &= ~GUEST_OFFLOAD_LRO_MASK;
> +			offloads = vi->guest_offloads_capable &
> +				   ~GUEST_OFFLOAD_LRO_MASK;
> +
> +		err = virtnet_set_guest_offloads(vi, offloads);
> +		if (err)
> +			return err;
> +		vi->guest_offloads = offloads;
>   	}
>   
> -	if ((dev->features ^ features) & NETIF_F_RXCSUM) {
> -		if (features & NETIF_F_RXCSUM)
> -			offloads |= GUEST_OFFLOAD_CSUM_MASK &
> -				    vi->guest_offloads_capable;
> -		else
> -			offloads &= ~GUEST_OFFLOAD_CSUM_MASK;
> -	}
> -
> -	err = virtnet_set_guest_offloads(vi, offloads);
> -	if (err)
> -		return err;
> -
> -	vi->guest_offloads = offloads;
>   	return 0;
>   }
>   
> @@ -2584,7 +2563,6 @@ static const struct net_device_ops virtnet_netdev = {
>   	.ndo_features_check	= passthru_features_check,
>   	.ndo_get_phys_port_name	= virtnet_get_phys_port_name,
>   	.ndo_set_features	= virtnet_set_features,
> -	.ndo_fix_features	= virtnet_fix_features,
>   };
>   
>   static void virtnet_config_changed_work(struct work_struct *work)
> @@ -3035,10 +3013,8 @@ static int virtnet_probe(struct virtio_device *vdev)
>   	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
>   	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
>   		dev->features |= NETIF_F_LRO;
> -	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)) {
> -		dev->hw_features |= NETIF_F_RXCSUM;
> +	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
>   		dev->hw_features |= NETIF_F_LRO;
> -	}
>   
>   	dev->vlan_features = dev->features;
>   

