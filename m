Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3333D4DF7
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 09:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbfJLHb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 03:31:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45098 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726821AbfJLHb5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 03:31:57 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C683D36961;
        Sat, 12 Oct 2019 07:31:56 +0000 (UTC)
Received: from [10.72.12.150] (ovpn-12-150.pek2.redhat.com [10.72.12.150])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4361C600D1;
        Sat, 12 Oct 2019 07:31:51 +0000 (UTC)
Subject: Re: [PATCH RFC v1 0/2] vhost: ring format independence
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20191011134358.16912-1-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b24b3c9e-3a5d-fa5e-8218-ea7def0e5a39@redhat.com>
Date:   Sat, 12 Oct 2019 15:31:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191011134358.16912-1-mst@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Sat, 12 Oct 2019 07:31:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/11 下午9:45, Michael S. Tsirkin wrote:
> So the idea is as follows: we convert descriptors to an
> independent format first, and process that converting to
> iov later.
>
> The point is that we have a tight loop that fetches
> descriptors, which is good for cache utilization.
> This will also allow all kind of batching tricks -
> e.g. it seems possible to keep SMAP disabled while
> we are fetching multiple descriptors.
>
> And perhaps more importantly, this is a very good fit for the packed
> ring layout, where we get and put descriptors in order.
>
> This patchset seems to already perform exactly the same as the original
> code already based on a microbenchmark.  More testing would be very much
> appreciated.
>
> Biggest TODO before this first step is ready to go in is to
> batch indirect descriptors as well.
>
> Integrating into vhost-net is basically
> s/vhost_get_vq_desc/vhost_get_vq_desc_batch/ -
> or add a module parameter like I did in the test module.


It would be better to convert vhost_net then I can do some benchmark on 
that.

Thanks


>
>
>
> Michael S. Tsirkin (2):
>    vhost: option to fetch descriptors through an independent struct
>    vhost: batching fetches
>
>   drivers/vhost/test.c  |  19 ++-
>   drivers/vhost/vhost.c | 333 +++++++++++++++++++++++++++++++++++++++++-
>   drivers/vhost/vhost.h |  20 ++-
>   3 files changed, 365 insertions(+), 7 deletions(-)
>
