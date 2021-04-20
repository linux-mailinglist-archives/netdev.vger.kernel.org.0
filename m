Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C1C36506C
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 04:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbhDTClq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 22:41:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42896 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229493AbhDTClq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 22:41:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618886475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QCpz0nhIq8lZv1yHAICQ2/pm22I/BSVi7uKhG1j2+KA=;
        b=LjrbaFoLyVpNVaT8WG1KxlQ+QKJc59egPhNTZp//dhY3QU79y30vgLbGAu87+z834nGo9g
        Zb8qE9lEXPGibIiMvLKX/kS6JUei9/HJMd+/Qdd0uieRw1UU1gP1GkJzWZMfSA8rHJ+CMD
        iMhjVQQpwwSW8gpqCzDmeTC4aKWnZ7o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-cgdyGORQOYCBCvttY1xtfQ-1; Mon, 19 Apr 2021 22:41:12 -0400
X-MC-Unique: cgdyGORQOYCBCvttY1xtfQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4845910054F6;
        Tue, 20 Apr 2021 02:41:11 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-125.pek2.redhat.com [10.72.13.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E665C2B1B1;
        Tue, 20 Apr 2021 02:41:05 +0000 (UTC)
Subject: Re: [PATCH net-next v3] virtio-net: page_to_skb() use build_skb when
 there's sufficient tailroom
From:   Jason Wang <jasowang@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <20210416091615.25198-1-xuanzhuo@linux.alibaba.com>
 <e48bb6f-48c1-681-3288-72cd7b9661c3@linux.intel.com>
 <aa55b487-44bb-1596-d310-9b74b9ba47fe@redhat.com>
Message-ID: <87e01595-de5f-bf52-5769-1d05a455b62b@redhat.com>
Date:   Tue, 20 Apr 2021 10:41:03 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <aa55b487-44bb-1596-d310-9b74b9ba47fe@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/4/20 上午10:38, Jason Wang 写道:
>>> :
>>> +    /* hdr_valid means no XDP, so we can copy the vnet header */
>>> +    if (hdr_valid) {
>>> +        hdr = skb_vnet_hdr(skb);
>>> +        memcpy(hdr, hdr_p, hdr_len);
>>
>> and hdr_p is dereferenced here.
>
>
> Right, I tend to recover the way to copy hdr and set meta just after 
> alloc/build_skb().
>
> Thanks 


Btw, since the patch modifies a critical path of virtio-net I suggest to 
test the following cases:

1) netperf TCP stream
2) netperf UDP with packet size from 64 to PAGE_SIZE
3) XDP_PASS with 1)
4) XDP_PASS with 2)
5) XDP metadata with 1)
6) XDP metadata with 2)

Thanks

