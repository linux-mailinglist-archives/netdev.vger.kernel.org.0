Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A97B48B292
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 10:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbfHMIeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 04:34:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36682 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727429AbfHMIeC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 04:34:02 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 61660A4D31;
        Tue, 13 Aug 2019 08:34:02 +0000 (UTC)
Received: from [10.72.12.191] (ovpn-12-191.pek2.redhat.com [10.72.12.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0514F1001B33;
        Tue, 13 Aug 2019 08:34:00 +0000 (UTC)
Subject: Re: tun: mark small packets as owned by the tap sock
To:     Dave Jones <davej@codemonkey.org.uk>,
        Alexis Bauvin <abauvin@scaleway.com>
Cc:     netdev@vger.kernel.org
References: <git-mailbomb-linux-master-4b663366246be1d1d4b1b8b01245b2e88ad9e706@kernel.org>
 <20190812221954.GA13314@codemonkey.org.uk>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6b16739e-ab96-9c93-9636-5b80b81c2b20@redhat.com>
Date:   Tue, 13 Aug 2019 16:33:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812221954.GA13314@codemonkey.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 13 Aug 2019 08:34:02 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/8/13 上午6:19, Dave Jones wrote:
> On Wed, Aug 07, 2019 at 12:30:07AM +0000, Linux Kernel wrote:
>   > Commit:     4b663366246be1d1d4b1b8b01245b2e88ad9e706
>   > Parent:     16b2084a8afa1432d14ba72b7c97d7908e178178
>   > Web:        https://git.kernel.org/torvalds/c/4b663366246be1d1d4b1b8b01245b2e88ad9e706
>   > Author:     Alexis Bauvin <abauvin@scaleway.com>
>   > AuthorDate: Tue Jul 23 16:23:01 2019 +0200
>   >
>   >     tun: mark small packets as owned by the tap sock
>   >
>   >     - v1 -> v2: Move skb_set_owner_w to __tun_build_skb to reduce patch size
>   >
>   >     Small packets going out of a tap device go through an optimized code
>   >     path that uses build_skb() rather than sock_alloc_send_pskb(). The
>   >     latter calls skb_set_owner_w(), but the small packet code path does not.
>   >
>   >     The net effect is that small packets are not owned by the userland
>   >     application's socket (e.g. QEMU), while large packets are.
>   >     This can be seen with a TCP session, where packets are not owned when
>   >     the window size is small enough (around PAGE_SIZE), while they are once
>   >     the window grows (note that this requires the host to support virtio
>   >     tso for the guest to offload segmentation).
>   >     All this leads to inconsistent behaviour in the kernel, especially on
>   >     netfilter modules that uses sk->socket (e.g. xt_owner).
>   >
>   >     Fixes: 66ccbc9c87c2 ("tap: use build_skb() for small packet")
>   >     Signed-off-by: Alexis Bauvin <abauvin@scaleway.com>
>   >     Acked-by: Jason Wang <jasowang@redhat.com>
>
> This commit breaks ipv6 routing when I deployed on it a linode.
> It seems to work briefly after boot, and then silently all packets get
> dropped. (Presumably, it's dropping RA or ND packets)
>
> With this reverted, everything works as it did in rc3.
>
> 	Dave


Hi:

Two questions:

- Are you using XDP for TUN?

- Does it work before 66ccbc9c87c2? If yes, could you show us the result 
of net_dropmonitor?

Thanks


>
