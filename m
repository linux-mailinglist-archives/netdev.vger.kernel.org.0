Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBD765291
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 09:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbfGKHhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 03:37:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54274 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbfGKHhI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 03:37:08 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3F0B9307D983;
        Thu, 11 Jul 2019 07:37:08 +0000 (UTC)
Received: from [10.72.12.56] (ovpn-12-56.pek2.redhat.com [10.72.12.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11B9F5D9DC;
        Thu, 11 Jul 2019 07:37:01 +0000 (UTC)
Subject: Re: [RFC] virtio-net: share receive_*() and add_recvbuf_*() with
 virtio-vsock
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20190710153707.twmzgmwqqw3pstos@steredhat>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9574bc38-4c5c-2325-986b-430e4a2b6661@redhat.com>
Date:   Thu, 11 Jul 2019 15:37:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190710153707.twmzgmwqqw3pstos@steredhat>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 11 Jul 2019 07:37:08 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/10 下午11:37, Stefano Garzarella wrote:
> Hi,
> as Jason suggested some months ago, I looked better at the virtio-net driver to
> understand if we can reuse some parts also in the virtio-vsock driver, since we
> have similar challenges (mergeable buffers, page allocation, small
> packets, etc.).
>
> Initially, I would add the skbuff in the virtio-vsock in order to re-use
> receive_*() functions.


Yes, that will be a good step.


> Then I would move receive_[small, big, mergeable]() and
> add_recvbuf_[small, big, mergeable]() outside of virtio-net driver, in order to
> call them also from virtio-vsock. I need to do some refactoring (e.g. leave the
> XDP part on the virtio-net driver), but I think it is feasible.
>
> The idea is to create a virtio-skb.[h,c] where put these functions and a new
> object where stores some attributes needed (e.g. hdr_len ) and status (e.g.
> some fields of struct receive_queue).


My understanding is we could be more ambitious here. Do you see any 
blocker for reusing virtio-net directly? It's better to reuse not only 
the functions but also the logic like NAPI to avoid re-inventing 
something buggy and duplicated.


> This is an idea of virtio-skb.h that
> I have in mind:
>      struct virtskb;


What fields do you want to store in virtskb? It looks to be exist 
sk_buff is flexible enough to us?


>
>      struct sk_buff *virtskb_receive_small(struct virtskb *vs, ...);
>      struct sk_buff *virtskb_receive_big(struct virtskb *vs, ...);
>      struct sk_buff *virtskb_receive_mergeable(struct virtskb *vs, ...);
>
>      int virtskb_add_recvbuf_small(struct virtskb*vs, ...);
>      int virtskb_add_recvbuf_big(struct virtskb *vs, ...);
>      int virtskb_add_recvbuf_mergeable(struct virtskb *vs, ...);
>
> For the Guest->Host path it should be easier, so maybe I can add a
> "virtskb_send(struct virtskb *vs, struct sk_buff *skb)" with a part of the code
> of xmit_skb().


I may miss something, but I don't see any thing that prevents us from 
using xmit_skb() directly.


>
> Let me know if you have in mind better names or if I should put these function
> in another place.
>
> I would like to leave the control part completely separate, so, for example,
> the two drivers will negotiate the features independently and they will call
> the right virtskb_receive_*() function based on the negotiation.


If it's one the issue of negotiation, we can simply change the 
virtnet_probe() to deal with different devices.


>
> I already started to work on it, but before to do more steps and send an RFC
> patch, I would like to hear your opinion.
> Do you think that makes sense?
> Do you see any issue or a better solution?


I still think we need to seek a way of adding some codes on virtio-net.c 
directly if there's no huge different in the processing of TX/RX. That 
would save us a lot time.

Thanks


>
> Thanks in advance,
> Stefano
