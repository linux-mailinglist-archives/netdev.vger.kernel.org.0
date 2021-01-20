Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696082FC8CE
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbhATDZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 22:25:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47798 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728133AbhATDYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 22:24:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611113003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p66laDTr1B6Q5naOwBpyBU0QwMyd3LCvYkkvKvp7/Zo=;
        b=PkbMSsrrDw90o0l1cIqsS36RQHTK31CRR4ngWiyybpLoAVObLdlV+/9lYwEVyMe0DIxNxl
        Y56k07TvS9WOw7lST438XrfSRT2UHu2uhc2cz3JrM+NLgfRdzKV6zbjvI65lGaCgzEHLU/
        KC+hmT05fST+qwefTOVA5lDDrLPrNV4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-aRwCRJpnON6rqjOGrmUoaw-1; Tue, 19 Jan 2021 22:23:19 -0500
X-MC-Unique: aRwCRJpnON6rqjOGrmUoaw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3D50806660;
        Wed, 20 Jan 2021 03:23:16 +0000 (UTC)
Received: from [10.72.13.124] (ovpn-13-124.pek2.redhat.com [10.72.13.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B31027CAA;
        Wed, 20 Jan 2021 03:23:07 +0000 (UTC)
Subject: Re: [PATCH net-next v2 2/7] virtio-net, xsk: distinguish XDP_TX and
 XSK XMIT ctx
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <1610970895.0597434-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <fc6d27c7-6f00-4871-65d0-dffdcb2e1925@redhat.com>
Date:   Wed, 20 Jan 2021 11:23:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1610970895.0597434-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/18 下午7:54, Xuan Zhuo wrote:
> On Mon, 18 Jan 2021 14:45:16 +0800, Jason Wang <jasowang@redhat.com> wrote:
>> On 2021/1/16 上午10:59, Xuan Zhuo wrote:
>>> If support xsk, a new ptr will be recovered during the
>>> process of freeing the old ptr. In order to distinguish between ctx sent
>>> by XDP_TX and ctx sent by xsk, a struct is added here to distinguish
>>> between these two situations. virtnet_xdp_type.type It is used to
>>> distinguish different ctx, and virtnet_xdp_type.offset is used to record
>>> the offset between "true ctx" and virtnet_xdp_type.
>>>
>>> The newly added virtnet_xsk_hdr will be used for xsk.
>>>
>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>
>> Any reason that you can't simply encode the type in the pointer itself
>> as we used to do?
>>
>> #define VIRTIO_XSK_FLAG    BIT(1)
>>
>> ?
> Since xdp socket does not use xdp_frame, we will encounter three data types when
> recycling: skb, xdp_frame, xdp socket.


Just to make sure we are in the same page. Currently, the pointer type 
is encoded with 1 bit in the pointer. Can we simply use 2 bit to 
distinguish skb, xdp, xsk?

Thanks


>

