Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCA31CA055
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 03:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgEHByS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 21:54:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44776 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726509AbgEHByS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 21:54:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588902857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8is+as/IWe32hsvVt9oXkFSeTwtP1mvlBgfZZAeexYQ=;
        b=HXQyu7Z55XmLp+BkUP3Z25rQm7RwGsvYkdPn4ikMkhx9GWSLrzjhlazTwPSBBqWR4ZDe/T
        At36i2EWGwZt16imh9BsUKtsSe8698RaUjDZpVrf66gLT63L5zES9aCcQ0gQMiTaQL21WP
        JfWrsCHzI2P5o9cvOS8jM2hTyN4FUgM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-hkaK7xe3NF6q51s7VNlBWg-1; Thu, 07 May 2020 21:54:15 -0400
X-MC-Unique: hkaK7xe3NF6q51s7VNlBWg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DDF6835BC5;
        Fri,  8 May 2020 01:54:14 +0000 (UTC)
Received: from [10.72.13.98] (ovpn-13-98.pek2.redhat.com [10.72.13.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BCD765D9C5;
        Fri,  8 May 2020 01:54:06 +0000 (UTC)
Subject: Re: [PATCH net-next 2/2] virtio-net: fix the XDP truesize calculation
 for mergeable buffers
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
References: <20200506061633.16327-1-jasowang@redhat.com>
 <20200506061633.16327-2-jasowang@redhat.com>
 <20200506033259-mutt-send-email-mst@kernel.org>
 <789fc6e6-9667-a609-c777-a9b1fed72f41@redhat.com>
 <20200506075807-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0e59287f-8333-c715-da03-91306cef9878@redhat.com>
Date:   Fri, 8 May 2020 09:54:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200506075807-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/5/6 下午8:08, Michael S. Tsirkin wrote:
> On Wed, May 06, 2020 at 04:21:15PM +0800, Jason Wang wrote:
>> On 2020/5/6 下午3:37, Michael S. Tsirkin wrote:
>>> On Wed, May 06, 2020 at 02:16:33PM +0800, Jason Wang wrote:
>>>> We should not exclude headroom and tailroom when XDP is set. So this
>>>> patch fixes this by initializing the truesize from PAGE_SIZE when XDP
>>>> is set.
>>>>
>>>> Cc: Jesper Dangaard Brouer<brouer@redhat.com>
>>>> Signed-off-by: Jason Wang<jasowang@redhat.com>
>>> Seems too aggressive, we do not use up the whole page for the size.
>>>
>>>
>>>
>> For XDP yes, we do:
>>
>> static unsigned int get_mergeable_buf_len(struct receive_queue *rq,
>>                        struct ewma_pkt_len *avg_pkt_len,
>>                        unsigned int room)
>> {
>>      const size_t hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
>>      unsigned int len;
>>
>>      if (room)
>>          return PAGE_SIZE - room;
>>
>> ...
>>
>> Thanks
> Hmm. But that's only for new buffers. Buffers that were outstanding
> before xdp was attached don't use the whole page, do they?


They don't and in either case, we've encoded truesize in the ctx. Any 
issue you saw?


>
>
>
>
> Also, with TCP smallqueues blocking the queue like that might be a problem.
> Could you try and check performance impact of this?


I'm not sure I get you, TCP small queue is more about TX I guess. And 
since we've invalidated the vnet header, the performance of XDP_PASS 
won't be good.


> I looked at what other drivers do and I see they tend to copy the skb
> in XDP_PASS case. ATM we don't normally - but should we?


My understanding is XDP runs before skb, so I don't get here. Or maybe 
you can point me the driver you mentioned here? I've checked i40e and 
mlx5e, both of them build skb after XDP.

Thanks

>

