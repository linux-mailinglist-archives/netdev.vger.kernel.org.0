Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6EC596695
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 03:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238121AbiHQBPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 21:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiHQBPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 21:15:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54645B06C;
        Tue, 16 Aug 2022 18:15:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3125F61372;
        Wed, 17 Aug 2022 01:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CDDC433C1;
        Wed, 17 Aug 2022 01:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660698929;
        bh=kgrDUM1IeYaKVZSxpexysq6jAjWPEHhPCf6k+JgUmBI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f0Lr18xvYFl1Frp0AfEsYlCpKNsH28lycFf8LMt2nUxc8ACj9jdZppT8XeYFfm1lr
         pk+RDSkCHI7tSh+ScmVysQzVU8vtJ/vjdVo/+LmmN1DyU48SW3DHlA/W+tZZxHKZ1j
         RvtEmytQRngi0vjJay9e2YkxmJbY5z0okQq3rx7HET3ca7hlOVjNnB+Tivm18kL6ac
         vYYjCDD3qb12lTw34sgc2suDrBIAaWpEVKMp+qMnj6PZWft5qg9VDK9gTNfB3lylZI
         iiSj1PYtMvoQLGidl69e57MLivPPYi2/cYPEOic1lke1beJ4KRkCIGsWt9GC6AeEEq
         EJ0orNO4ZNZ4Q==
Date:   Tue, 16 Aug 2022 18:15:28 -0700
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
Message-ID: <20220816181528.5128bc06@kernel.org>
In-Reply-To: <YvtVN195TS1xpEN7@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
        <5a93c5aad99d79f028d349cb7e3c128c65d5d7e2.1660362668.git.bobby.eshleman@bytedance.com>
        <20220816123701-mutt-send-email-mst@kernel.org>
        <20220816110717.5422e976@kernel.org>
        <YvtAktdB09tM0Ykr@bullseye>
        <20220816160755.7eb11d2e@kernel.org>
        <YvtVN195TS1xpEN7@bullseye>
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

On Tue, 16 Aug 2022 08:29:04 +0000 Bobby Eshleman wrote:
> > We've been burnt in the past by people doing the "let me just pick
> > these useful pieces out of netdev" thing. Makes life hard both for
> > maintainers and users trying to make sense of the interfaces.
> > 
> > What comes to mind if you're just after queuing is that we already
> > bastardized the CoDel implementation (include/net/codel_impl.h).
> > If CoDel is good enough for you maybe that's the easiest way?
> > Although I suspect that you're after fairness not early drops.
> > Wireless folks use CoDel as a second layer queuing. (CC: Toke)
> 
> That is certainly interesting to me. Sitting next to "codel_impl.h" is
> "include/net/fq_impl.h", and it looks like it may solve the datagram
> flooding issue. The downside to this approach is the baking of a
> specific policy into vsock... which I don't exactly love either.
> 
> I'm not seeing too many other of these qdisc bastardizations in
> include/net, are there any others that you are aware of?

Just what wireless uses (so codel and fq as you found out), nothing
else comes to mind.

> > Eh, I was hoping it was a side channel of an existing virtio_net 
> > which is not the case. Given the zero-config requirement IDK if 
> > we'll be able to fit this into netdev semantics :(  
> 
> It's certainly possible that it may not fit :/ I feel that it partially
> depends on what we mean by zero-config. Is it "no config required to
> have a working socket" or is it "no config required, but also no
> tuning/policy/etc... supported"?

The value of tuning vs confusion of a strange netdev floating around
in the system is hard to estimate upfront. 

The nice thing about using a built-in fq with no user visible knobs is
that there's no extra uAPI. We can always rip it out and replace later.
And it shouldn't be controversial, making the path to upstream smoother.
