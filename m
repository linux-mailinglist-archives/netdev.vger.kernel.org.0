Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06D98D1F26
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 05:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732792AbfJJD7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 23:59:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33238 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732759AbfJJD7d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 23:59:33 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A7E86309843D;
        Thu, 10 Oct 2019 03:59:32 +0000 (UTC)
Received: from [10.72.12.46] (ovpn-12-46.pek2.redhat.com [10.72.12.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF1C160BE1;
        Thu, 10 Oct 2019 03:59:29 +0000 (UTC)
Subject: Re: [PATCH net] tun: remove possible false sharing in
 tun_flow_update()
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Zhang Yu <zhangyu31@baidu.com>, Wang Li <wangli39@baidu.com>,
        Li RongQing <lirongqing@baidu.com>
References: <20191009162002.19360-1-edumazet@google.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7c390fda-f892-9c44-3976-60d1d3035ebb@redhat.com>
Date:   Thu, 10 Oct 2019 11:59:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191009162002.19360-1-edumazet@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 10 Oct 2019 03:59:32 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/10 上午12:20, Eric Dumazet wrote:
> As mentioned in https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE#it-may-improve-performance
> a C compiler can legally transform
>
> if (e->queue_index != queue_index)
> 	e->queue_index = queue_index;
>
> to :
>
> 	e->queue_index = queue_index;
>
> Note that the code using jiffies has no issue, since jiffies
> has volatile attribute.
>
> if (e->updated != jiffies)
>      e->updated = jiffies;
>
> Fixes: 83b1bc122cab ("tun: align write-heavy flow entry members to a cache line")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Zhang Yu <zhangyu31@baidu.com>
> Cc: Wang Li <wangli39@baidu.com>
> Cc: Li RongQing <lirongqing@baidu.com>
> Cc: Jason Wang <jasowang@redhat.com>
> ---
>   drivers/net/tun.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 812dc3a65efbb9d1ee2724e73978dbc4803ec171..a8d3141582a53caf407dc9aff61c452998de068f 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -526,8 +526,8 @@ static void tun_flow_update(struct tun_struct *tun, u32 rxhash,
>   	e = tun_flow_find(head, rxhash);
>   	if (likely(e)) {
>   		/* TODO: keep queueing to old queue until it's empty? */
> -		if (e->queue_index != queue_index)
> -			e->queue_index = queue_index;
> +		if (READ_ONCE(e->queue_index) != queue_index)
> +			WRITE_ONCE(e->queue_index, queue_index);
>   		if (e->updated != jiffies)
>   			e->updated = jiffies;
>   		sock_rps_record_flow_hash(e->rps_rxhash);


Acked-by: Jason Wang <jasowang@redhat.com>


