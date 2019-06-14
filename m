Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36F324552E
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 09:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbfFNHBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 03:01:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37190 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbfFNHBa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 03:01:30 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6B8CF30821B2;
        Fri, 14 Jun 2019 07:01:29 +0000 (UTC)
Received: from [10.72.12.190] (ovpn-12-190.pek2.redhat.com [10.72.12.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 69070605CF;
        Fri, 14 Jun 2019 07:01:24 +0000 (UTC)
Subject: Re: [PATCH net-next] virtio_net: enable napi_tx by default
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        Willem de Bruijn <willemb@google.com>
References: <20190613162457.143518-1-willemdebruijn.kernel@gmail.com>
 <c43051c5-144a-5aa4-2387-8fb42442f455@redhat.com>
 <20190614013506-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8c0317a3-16e2-8246-a25d-3a3f9337edec@redhat.com>
Date:   Fri, 14 Jun 2019 15:01:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190614013506-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 14 Jun 2019 07:01:29 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/6/14 下午2:00, Michael S. Tsirkin wrote:
> On Fri, Jun 14, 2019 at 11:28:59AM +0800, Jason Wang wrote:
>> On 2019/6/14 上午12:24, Willem de Bruijn wrote:
>>> From: Willem de Bruijn <willemb@google.com>
>>>
>>> NAPI tx mode improves TCP behavior by enabling TCP small queues (TSQ).
>>> TSQ reduces queuing ("bufferbloat") and burstiness.
>>>
>>> Previous measurements have shown significant improvement for
>>> TCP_STREAM style workloads. Such as those in commit 86a5df1495cc
>>> ("Merge branch 'virtio-net-tx-napi'").
>>>
>>> There has been uncertainty about smaller possible regressions in
>>> latency due to increased reliance on tx interrupts.
>>>
>>> The above results did not show that, nor did I observe this when
>>> rerunning TCP_RR on Linux 5.1 this week on a pair of guests in the
>>> same rack. This may be subject to other settings, notably interrupt
>>> coalescing.
>>>
>>> In the unlikely case of regression, we have landed a credible runtime
>>> solution. Ethtool can configure it with -C tx-frames [0|1] as of
>>> commit 0c465be183c7 ("virtio_net: ethtool tx napi configuration").
>>>
>>> NAPI tx mode has been the default in Google Container-Optimized OS
>>> (COS) for over half a year, as of release M70 in October 2018,
>>> without any negative reports.
>>>
>>> Link: https://marc.info/?l=linux-netdev&m=149305618416472
>>> Link: https://lwn.net/Articles/507065/
>>> Signed-off-by: Willem de Bruijn <willemb@google.com>
>>>
>>> ---
>>>
>>> now that we have ethtool support and real production deployment,
>>> it seemed like a good time to revisit this discussion.
>>
>> I agree to enable it by default. Need inputs from Michael. One possible
>> issue is we may get some regression on the old machine without APICV, but
>> consider most modern CPU has this feature, it probably doesn't matter.
>>
>> Thanks
>>
> Right. If the issue does arise we can always add e.g. a feature flag
> to control the default from the host.
>

Yes.

So

Acked-by: Jason Wang <jasowang@redhat.com>


