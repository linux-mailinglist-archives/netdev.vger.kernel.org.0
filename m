Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB458452F1
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 05:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfFND3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 23:29:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38632 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbfFND3P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 23:29:15 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 77D113082B5F;
        Fri, 14 Jun 2019 03:29:05 +0000 (UTC)
Received: from [10.72.12.57] (ovpn-12-57.pek2.redhat.com [10.72.12.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 165DB6085B;
        Fri, 14 Jun 2019 03:29:00 +0000 (UTC)
Subject: Re: [PATCH net-next] virtio_net: enable napi_tx by default
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, mst@redhat.com,
        Willem de Bruijn <willemb@google.com>
References: <20190613162457.143518-1-willemdebruijn.kernel@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c43051c5-144a-5aa4-2387-8fb42442f455@redhat.com>
Date:   Fri, 14 Jun 2019 11:28:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613162457.143518-1-willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Fri, 14 Jun 2019 03:29:15 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/6/14 上午12:24, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
>
> NAPI tx mode improves TCP behavior by enabling TCP small queues (TSQ).
> TSQ reduces queuing ("bufferbloat") and burstiness.
>
> Previous measurements have shown significant improvement for
> TCP_STREAM style workloads. Such as those in commit 86a5df1495cc
> ("Merge branch 'virtio-net-tx-napi'").
>
> There has been uncertainty about smaller possible regressions in
> latency due to increased reliance on tx interrupts.
>
> The above results did not show that, nor did I observe this when
> rerunning TCP_RR on Linux 5.1 this week on a pair of guests in the
> same rack. This may be subject to other settings, notably interrupt
> coalescing.
>
> In the unlikely case of regression, we have landed a credible runtime
> solution. Ethtool can configure it with -C tx-frames [0|1] as of
> commit 0c465be183c7 ("virtio_net: ethtool tx napi configuration").
>
> NAPI tx mode has been the default in Google Container-Optimized OS
> (COS) for over half a year, as of release M70 in October 2018,
> without any negative reports.
>
> Link: https://marc.info/?l=linux-netdev&m=149305618416472
> Link: https://lwn.net/Articles/507065/
> Signed-off-by: Willem de Bruijn <willemb@google.com>
>
> ---
>
> now that we have ethtool support and real production deployment,
> it seemed like a good time to revisit this discussion.


I agree to enable it by default. Need inputs from Michael. One possible 
issue is we may get some regression on the old machine without APICV, 
but consider most modern CPU has this feature, it probably doesn't matter.

Thanks


>
> ---
>   drivers/net/virtio_net.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 0d4115c9e20b..4f3de0ac8b0b 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -26,7 +26,7 @@
>   static int napi_weight = NAPI_POLL_WEIGHT;
>   module_param(napi_weight, int, 0444);
>   
> -static bool csum = true, gso = true, napi_tx;
> +static bool csum = true, gso = true, napi_tx = true;
>   module_param(csum, bool, 0444);
>   module_param(gso, bool, 0444);
>   module_param(napi_tx, bool, 0644);
