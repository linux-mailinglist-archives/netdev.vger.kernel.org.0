Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31E18D4E27
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 09:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbfJLH52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 03:57:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37110 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728812AbfJLH52 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 03:57:28 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DF6853066FA7;
        Sat, 12 Oct 2019 07:57:27 +0000 (UTC)
Received: from [10.72.12.150] (ovpn-12-150.pek2.redhat.com [10.72.12.150])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F050600D1;
        Sat, 12 Oct 2019 07:57:23 +0000 (UTC)
Subject: Re: [PATCH net-next 0/3] vhost_net: access ptr ring using tap recvmsg
To:     prashantbhole.linux@gmail.com,
        "Michael S . Tsirkin" <mst@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     David Ahern <dsahern@gmail.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20191012015357.1775-1-prashantbhole.linux@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8f319697-34e1-fde5-65f3-7db8dc723982@redhat.com>
Date:   Sat, 12 Oct 2019 15:57:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191012015357.1775-1-prashantbhole.linux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Sat, 12 Oct 2019 07:57:27 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/12 上午9:53, prashantbhole.linux@gmail.com wrote:
> From: Prashant Bhole <prashantbhole.linux@gmail.com>
>
> vhost_net needs to peek tun packet sizes to allocate virtio buffers.
> Currently it directly accesses tap ptr ring to do it. Jason Wang
> suggested to achieve this using msghdr->msg_control and modifying the
> behavior of tap recvmsg.


Note this may use more indirect calls, this could be optimized in the 
future by doing XDP/skb receiving by vhost_net its own.


>
> This change will be useful in future in case of virtio-net XDP
> offload. Where packets will be XDP processed in tap recvmsg and vhost
> will see only non XDP_DROP'ed packets.
>
> Patch 1: reorganizes the tun_msg_ctl so that it can be extended by
>   the means of different commands. tap sendmsg recvmsg will behave
>   according to commands.
>
> Patch 2: modifies recvmsg implementation to produce packet pointers.
>   vhost_net uses recvmsg API instead of ptr_ring_consume().
>
> Patch 3: removes ptr ring usage in vhost and functions those export
>   ptr ring from tun/tap.
>
> Prashant Bhole (3):
>    tuntap: reorganize tun_msg_ctl usage
>    vhost_net: user tap recvmsg api to access ptr ring
>    tuntap: remove usage of ptr ring in vhost_net
>
>   drivers/net/tap.c      | 44 ++++++++++++++---------
>   drivers/net/tun.c      | 45 +++++++++++++++---------
>   drivers/vhost/net.c    | 79 ++++++++++++++++++++++--------------------
>   include/linux/if_tun.h |  9 +++--
>   4 files changed, 103 insertions(+), 74 deletions(-)


It would be helpful that if you can share some performance numbers here.

Thanks

