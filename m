Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2826136507E
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 04:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhDTCuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 22:50:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56869 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229508AbhDTCuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 22:50:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618886970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D+M/CVmWpN2JlBeA9vzyPmV1x08cJ5DnvfcIZr4tzGY=;
        b=HZRfiFU+RaLo6n6I6h0gCzZ3qLFtnPHHIoDu/peRL79gF1i6j1hWEKcAZt36dswmOyHFRh
        LWUbVwz70JVxbSpIBao/H/CfbcbfOKPg1hpoCCWglN6R25TGQ4j644KsF+KE5KGm3N+PqM
        Jm3wPn9x/uDjwnq+yizUkUkefOpw4MA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-6MdklkFiMneEFHK8ZXKjaQ-1; Mon, 19 Apr 2021 22:49:28 -0400
X-MC-Unique: 6MdklkFiMneEFHK8ZXKjaQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBD9A87A826;
        Tue, 20 Apr 2021 02:49:26 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-125.pek2.redhat.com [10.72.13.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A51B107D5C8;
        Tue, 20 Apr 2021 02:49:19 +0000 (UTC)
Subject: Re: [PATCH net-next v3] virtio-net: page_to_skb() use build_skb when
 there's sufficient tailroom
To:     David Ahern <dsahern@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
References: <20210416091615.25198-1-xuanzhuo@linux.alibaba.com>
 <ebaeb57a-924a-43e4-bd5f-e41ecce9ffe6@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <fadc2cdb-f6bd-394a-3bcd-9f0eaebddf26@redhat.com>
Date:   Tue, 20 Apr 2021 10:49:18 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <ebaeb57a-924a-43e4-bd5f-e41ecce9ffe6@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/4/20 上午12:48, David Ahern 写道:
> On 4/16/21 2:16 AM, Xuan Zhuo wrote:
>> In page_to_skb(), if we have enough tailroom to save skb_shared_info, we
>> can use build_skb to create skb directly. No need to alloc for
>> additional space. And it can save a 'frags slot', which is very friendly
>> to GRO.
>>
>> Here, if the payload of the received package is too small (less than
>> GOOD_COPY_LEN), we still choose to copy it directly to the space got by
>> napi_alloc_skb. So we can reuse these pages.
>>
>> Testing Machine:
>>      The four queues of the network card are bound to the cpu1.
>>
>> Test command:
>>      for ((i=0;i<5;++i)); do sockperf tp --ip 192.168.122.64 -m 1000 -t 150& done
>>
>> The size of the udp package is 1000, so in the case of this patch, there
>> will always be enough tailroom to use build_skb. The sent udp packet
>> will be discarded because there is no port to receive it. The irqsoftd
>> of the machine is 100%, we observe the received quantity displayed by
>> sar -n DEV 1:
>>
>> no build_skb:  956864.00 rxpck/s
>> build_skb:    1158465.00 rxpck/s
>>
> virtio_net is using napi_consume_skb, so napi_build_skb should show a
> small increase from build_skb.
>

Yes and we probably need to do this in receive_small().

Thanks

