Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0610465CA6D
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 00:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbjACXir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 18:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjACXiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 18:38:46 -0500
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F3A1DE;
        Tue,  3 Jan 2023 15:38:44 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1672789123; bh=ynOWW3LgPvjCduGH9UcbEQT2h4nu+eDS7sALdUj0jpY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=D8OcQedRKM45liJhzV0Gsvc5J21BGX3cCKwbp0W1Z3Pcf4G0/WaKzIJC1P/gbXrvI
         FUBeWWB2a+PiWWV9SRxRNNm5AAY3G6ZKKTcYtrDDy6deDufpCTZ+17HGyBdHthZ/gt
         l1P1B0zw5K/9wRjYjGWCrJ9yJr3tXRQXFCVvUxEkhmHVXJ7+gEx/wzsxz1uYpZTqPU
         IXbVmvacTjuMt8TOvKKlSVIbzhuEqmUN2u4PWhqVjgumjKZpugEb95qlpu/JxBU9mc
         qAfz4vD6463ACL1hUzo5bDa8kQy+Rr4/VuCIOdTb+POWYnG+atjhVkK+G63lxCWJ0u
         SSa3pjuKoTskA==
To:     Fedor Pchelkin <pchelkin@ispras.ru>, Kalle Valo <kvalo@kernel.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Zekun Shen <bruceshenzk@gmail.com>,
        Joe Perches <joe@perches.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH v2] wifi: ath9k: hif_usb: clean up skbs if
 ath9k_hif_usb_rx_stream() fails
In-Reply-To: <20230103223052.303666-1-pchelkin@ispras.ru>
References: <20230103223052.303666-1-pchelkin@ispras.ru>
Date:   Wed, 04 Jan 2023 00:38:42 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87tu172np9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fedor Pchelkin <pchelkin@ispras.ru> writes:

>> Hmm, so in the other error cases (if SKB allocation fails), we just
>> 'goto err' and call the receive handler for the packets already in
>> skb_pool. Why can't we do the same here?
>
> If SKB allocation fails, then the packets already in skb_pool should be
> processed by htc rx handler, yes. About the other two cases: if pkt_tag or
> pkt_len is invalid, then the whole SKB is considered invalid and dropped.
> That is what the statistics macros tell. So I think we should not process
> packets from skb_pool which are associated with a dropped SKB. And so just
> free them instead.

Hmm, okay, but if we're counting packets, your patch is not incrementing
any drop counters for the extra SKBs it's dropping either? They would
previously have been counted as 'RX_STAT_INC(hif_dev, skb_allocated)',
so shouldn't they now be counted as 'skb_dropped' as well? The single
counter increase inside the err if statements refers to the skb that's
the function parameter (which AFAICT is a different kind of skb than the
ones being allocated and processed in that loop? it's being split into
chunks or?).

>> Also, I think there's another bug in that function, which this change
>> will make worse? Specifically, in the start of that function,
>> hif_dev->remain_skb is moved to skb_pool[0], but not cleared from
>> hif_dev itself. So if we then hit the invalid check and free it, the
>> next time the function is called, we'll get the same remain_skb pointer,
>> which has now been freed.
>
> Sorry, I missed that somehow.
> Moving 'hif_dev->rx_remain_len = index - MAX_RX_BUF_SIZE;' after
> "ath9k_htc: RX memory allocation error\n" error path should be done, too.
> hif_dev->rx_remain_len is zeroed after remain_skb processing, so we cannot
> reference hif_dev->remain_skb unless we explicitly allocate successfully a
> new one (making rx_remain_len non zero).
>
>> So I think we'll need to clear out hif_dev->remain_skb after moving it
>> to skb_pool. Care to add that as well?
>
> Yes, this must be done. I'll add it to patch v3.

OK, cool!
