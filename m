Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257405965DA
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 01:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237280AbiHPXIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 19:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbiHPXIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 19:08:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F04923C3;
        Tue, 16 Aug 2022 16:08:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6371FCE1753;
        Tue, 16 Aug 2022 23:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3497C433D6;
        Tue, 16 Aug 2022 23:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660691277;
        bh=3I4HbxQ36qW8/prxIbqH7YvR6fuZU21LN4L1X2Kb2sg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e5llqCh7O8nBtOrMA9+TzyfWvm5CaeM2Ep3MfsKwJ5uVHa92pouvc2X/aQBApBpLG
         vPYhCwKdrOpYSE6q829srFpfR+EUJ5lUYYWle4diR4DkdlCCT18S6Gvu2/dRdXwsMH
         Y4dNp4hYnDS5WEknTTuzqJINTsH6AN8zGVveGIc7x3EKcsA7F4Z/uqXKPAParFna7S
         YTRGwwWImhnimSz5JuU1lbplIB2h0W7mnOIXnB2g6w0U+WIXDJMBWzJQuTUV3glnpW
         wP8SKGtI8D00muBxE6+seIgcyZdNHf7KKQZ4VeAca8/i8HI7e+1TaKkMVk63A7eC6C
         5o1O21Fn6yT6Q==
Date:   Tue, 16 Aug 2022 16:07:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bobby Eshleman <bobbyeshleman@gmail.com>
Cc:     Bobby Eshleman <bobby.eshleman@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Toke =?UTF-8?B?SMO4?= =?UTF-8?B?aWxhbmQtSsO4cmdlbnNlbg==?= 
        <toke@toke.dk>
Subject: Re: [PATCH 3/6] vsock: add netdev to vhost/virtio vsock
Message-ID: <20220816160755.7eb11d2e@kernel.org>
In-Reply-To: <YvtAktdB09tM0Ykr@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
        <5a93c5aad99d79f028d349cb7e3c128c65d5d7e2.1660362668.git.bobby.eshleman@bytedance.com>
        <20220816123701-mutt-send-email-mst@kernel.org>
        <20220816110717.5422e976@kernel.org>
        <YvtAktdB09tM0Ykr@bullseye>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Aug 2022 07:02:33 +0000 Bobby Eshleman wrote:
> > From a cursory look (and Documentation/ would be nice..) it feels
> > very wrong to me. Do you know of any uses of a netdev which would 
> > be semantically similar to what you're doing? Treating netdevs as
> > buildings blocks for arbitrary message passing solutions is something 
> > I dislike quite strongly.  
> 
> The big difference between vsock and "arbitrary message passing" is that
> vsock is actually constrained by the virtio device that backs it (made
> up of virtqueues and the underlying protocol). That virtqueue pair is
> acting like the queues on a physical NIC, so it actually makes sense to
> manage the queuing of vsock's device like we would manage the queueing
> of a real device.
> 
> Still, I concede that ignoring the netdev state is a probably bad idea.
> 
> That said, I also think that using packet scheduling in vsock is a good
> idea, and that ideally we can reuse Linux's already robust library of
> packet scheduling algorithms by introducing qdisc somehow.

We've been burnt in the past by people doing the "let me just pick
these useful pieces out of netdev" thing. Makes life hard both for
maintainers and users trying to make sense of the interfaces.

What comes to mind if you're just after queuing is that we already
bastardized the CoDel implementation (include/net/codel_impl.h).
If CoDel is good enough for you maybe that's the easiest way?
Although I suspect that you're after fairness not early drops.
Wireless folks use CoDel as a second layer queuing. (CC: Toke)

> > Could you recommend where I can learn more about vsocks?  
> 
> I think the spec is probably the best place to start[1].
> 
> [1]: https://docs.oasis-open.org/virtio/virtio/v1.2/virtio-v1.2.html

Eh, I was hoping it was a side channel of an existing virtio_net 
which is not the case. Given the zero-config requirement IDK if 
we'll be able to fit this into netdev semantics :(
