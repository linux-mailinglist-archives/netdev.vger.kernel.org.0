Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA0F2F2681
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 04:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731189AbhALDFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 22:05:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55176 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728472AbhALDFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 22:05:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610420646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/q+3diGbNbiDTDR3ZpUe92kzq2qzz2QYzsJFq+WzsIY=;
        b=RVEo7gZuQUDkEyItDUst3gYVugDSQ8N8B5t75TmqB8xANK+7coHCeA152+qRITfnzWFrJE
        ipTgSbQKqsBdyQP3lMk4Z+8Oz1HJiql1pt5cq43AC4zozacHKbiDLYvnOEK7Q0Qvjftlov
        IVeIUcDqopb5ucBNuYDevyGy31B9j3k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-niF-ownANeyDKdF3x8ahXQ-1; Mon, 11 Jan 2021 22:04:03 -0500
X-MC-Unique: niF-ownANeyDKdF3x8ahXQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26BAE1842140;
        Tue, 12 Jan 2021 03:04:02 +0000 (UTC)
Received: from [10.72.12.225] (ovpn-12-225.pek2.redhat.com [10.72.12.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BB301001281;
        Tue, 12 Jan 2021 03:03:55 +0000 (UTC)
Subject: Re: [PATCH net-next 0/2] Introduce XDP_FLAGS_NO_TX flag
To:     Charlie Somerville <charlie@charlie.bz>, davem@davemloft.net,
        kuba@kernel.org, mst@redhat.com
Cc:     netdev@vger.kernel.org, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20210109024950.4043819-1-charlie@charlie.bz>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ee57b0ed-89e2-675e-b080-0059c181a2be@redhat.com>
Date:   Tue, 12 Jan 2021 11:03:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210109024950.4043819-1-charlie@charlie.bz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/9 上午10:49, Charlie Somerville wrote:
> This patch series introduces a new flag XDP_FLAGS_NO_TX which prevents
> the allocation of additional send queues for XDP programs.


This part I don't understand. Is such flag a must? I think the answer is 
probably not.

Why not simply do:

1) if we had sufficient TX queues, use dedicated TX queues for XDP_TX
2) if we don't, simple synchronize through spin_lock[1]

Thanks

[1] https://www.spinics.net/lists/bpf/msg32587.html


>
> Included in this patch series is an implementation of XDP_FLAGS_NO_TX
> for the virtio_net driver. This flag is intended to be advisory - not
> all drivers must implement support for it.
>
> Many virtualised environments only provide enough virtio_net send queues
> for the number of processors allocated to the VM:
>
> # nproc
> 8
> # ethtool --show-channels ens3
> Channel parameters for ens3:
> Pre-set maximums:
> RX:     0
> TX:     0
> Other:      0
> Combined:   8
>
> In this configuration XDP is unusable because the virtio_net driver
> always tries to allocate an extra send queue for each processor - even
> if the XDP the program never uses the XDP_TX functionality.
>
> While XDP_TX is still unavailable in these environments, this new flag
> expands the set of XDP programs that can be used.
>
> This is my first contribution to the kernel, so apologies if I've sent
> this to the wrong list. I have tried to cc relevant maintainers but
> it's possible I may have missed some people. I'm looking forward to
> receiving feedback on this change.
>
> Charlie Somerville (2):
>    xdp: Add XDP_FLAGS_NO_TX flag
>    virtio_net: Implement XDP_FLAGS_NO_TX support
>
>   drivers/net/virtio_net.c     | 17 +++++++++++++----
>   include/uapi/linux/if_link.h |  5 ++++-
>   2 files changed, 17 insertions(+), 5 deletions(-)
>

