Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D2B1CA07E
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 04:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgEHCGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 22:06:09 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51442 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbgEHCGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 22:06:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588903568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dZbF9/bTjanUhF5OVHEwVOjq8OzxNOAAj9TnQsQ5YVI=;
        b=X2lOtDhgTvZL+O6DMOKYALPbKIhKq78WdjLIHCDa6IVOyez4RONIAckEJfv9uV1PjdoDaN
        SHrMapXc1lm7YaBkF6Ta58bitKzoSFbxoN45+eqsInYEDmkr03x2iwMSR6WuVOLkRc6qrs
        AZ9v1BuM7GZG0LqH3TuVkG7fepZK19Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-z4dO6uWFND20sqjohZIG_Q-1; Thu, 07 May 2020 22:06:06 -0400
X-MC-Unique: z4dO6uWFND20sqjohZIG_Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFD891895957;
        Fri,  8 May 2020 02:06:03 +0000 (UTC)
Received: from [10.72.13.98] (ovpn-13-98.pek2.redhat.com [10.72.13.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 835E269C88;
        Fri,  8 May 2020 02:05:47 +0000 (UTC)
Subject: Re: [PATCH net-next v2 21/33] virtio_net: add XDP frame size in two
 code paths
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     sameehj@amazon.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        zorik@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com
References: <158824557985.2172139.4173570969543904434.stgit@firesoul>
 <158824572816.2172139.1358700000273697123.stgit@firesoul>
 <20200506163414-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6e86e5de-8558-0f3b-53ce-ab0f611cc649@redhat.com>
Date:   Fri, 8 May 2020 10:05:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200506163414-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/5/7 上午4:34, Michael S. Tsirkin wrote:
> On Thu, Apr 30, 2020 at 01:22:08PM +0200, Jesper Dangaard Brouer wrote:
>> The virtio_net driver is running inside the guest-OS. There are two
>> XDP receive code-paths in virtio_net, namely receive_small() and
>> receive_mergeable(). The receive_big() function does not support XDP.
>>
>> In receive_small() the frame size is available in buflen. The buffer
>> backing these frames are allocated in add_recvbuf_small() with same
>> size, except for the headroom, but tailroom have reserved room for
>> skb_shared_info. The headroom is encoded in ctx pointer as a value.
>>
>> In receive_mergeable() the frame size is more dynamic. There are two
>> basic cases: (1) buffer size is based on a exponentially weighted
>> moving average (see DECLARE_EWMA) of packet length. Or (2) in case
>> virtnet_get_headroom() have any headroom then buffer size is
>> PAGE_SIZE. The ctx pointer is this time used for encoding two values;
>> the buffer len "truesize" and headroom. In case (1) if the rx buffer
>> size is underestimated, the packet will have been split over more
>> buffers (num_buf info in virtio_net_hdr_mrg_rxbuf placed in top of
>> buffer area). If that happens the XDP path does a xdp_linearize_page
>> operation.
>>
>> Cc: Jason Wang<jasowang@redhat.com>
>> Signed-off-by: Jesper Dangaard Brouer<brouer@redhat.com>
> Acked-by: Michael S. Tsirkin<mst@redhat.com>


Note that we do:

         xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM + vi->hdr_len;

So using PAGE_SIZE here is probably not correct.

Thanks

>

