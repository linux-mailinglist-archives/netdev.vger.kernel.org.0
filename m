Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06700D6D64
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 04:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfJOC6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 22:58:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37338 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbfJOC6T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 22:58:19 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6E5CB307D84D;
        Tue, 15 Oct 2019 02:58:19 +0000 (UTC)
Received: from [10.72.12.168] (ovpn-12-168.pek2.redhat.com [10.72.12.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 239CD60127;
        Tue, 15 Oct 2019 02:58:14 +0000 (UTC)
Subject: Re: [PATCH RFC v4 0/5] vhost: ring format independence
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
References: <20191013113940.2863-1-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6c54460c-d958-78fb-cd6e-eac97cc2c00f@redhat.com>
Date:   Tue, 15 Oct 2019 10:58:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191013113940.2863-1-mst@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 15 Oct 2019 02:58:19 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/13 下午7:41, Michael S. Tsirkin wrote:
> This adds infrastructure required for supporting
> multiple ring formats.
>
> The idea is as follows: we convert descriptors to an
> independent format first, and process that converting to
> iov later.
>
> The point is that we have a tight loop that fetches
> descriptors, which is good for cache utilization.
> This will also allow all kind of batching tricks -
> e.g. it seems possible to keep SMAP disabled while
> we are fetching multiple descriptors.
>
> This seems to perform exactly the same as the original
> code already based on a microbenchmark.
> Lightly tested.
> More testing would be very much appreciated.
>
> To use new code:
> 	echo 1 > /sys/module/vhost_test/parameters/newcode
> or
> 	echo 1 > /sys/module/vhost_net/parameters/newcode
>
> changes from v3:
>          - fixed error handling in case of indirect descriptors
>          - add BUG_ON to detect buffer overflow in case of bugs
>                  in response to comment by Jason Wang
>          - minor code tweaks
>
> Changes from v2:
> 	- fixed indirect descriptor batching
>                  reported by Jason Wang
>
> Changes from v1:
> 	- typo fixes


I've just done some quick benchmark with testpmd + vhost_net txonly.

With 256 queue size, no difference but in 1024 queue size 1% regression 
of PPS were found.

Thanks


>
>
> Michael S. Tsirkin (5):
>    vhost: option to fetch descriptors through an independent struct
>    vhost/test: add an option to test new code
>    vhost: batching fetches
>    vhost/net: add an option to test new code
>    vhost: last descriptor must have NEXT clear
>
>   drivers/vhost/net.c   |  32 ++++-
>   drivers/vhost/test.c  |  19 ++-
>   drivers/vhost/vhost.c | 328 +++++++++++++++++++++++++++++++++++++++++-
>   drivers/vhost/vhost.h |  20 ++-
>   4 files changed, 385 insertions(+), 14 deletions(-)
>
