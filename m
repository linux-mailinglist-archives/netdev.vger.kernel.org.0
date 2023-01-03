Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556AB65C9B1
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 23:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238794AbjACWbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 17:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238068AbjACWbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 17:31:11 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266C3E24;
        Tue,  3 Jan 2023 14:31:05 -0800 (PST)
Received: from fedcomp.. (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 86DEC419E9CB;
        Tue,  3 Jan 2023 22:31:02 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 86DEC419E9CB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1672785062;
        bh=nQsquKCgBcLgQieVOG04ot3VHyn1Sman9uwZ5WiSKhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R6QGFxZjzbCS2e4JKCul3q4pTmnJIcqTxPs1u827cjvYkrwv89hXj7nHQY2VC6UWA
         QdHZYTU5XZ4ZgsBmaiJGwJRO7ZWv6hfvdF38PgAGeBGwj4sAGiza7zAKlOnBn4WKjO
         FiTxSWjlGL8wXovie2FeOc2VOcIvRheqT0p9cKJw=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>
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
Subject: Re: [PATCH v2] wifi: ath9k: hif_usb: clean up skbs if ath9k_hif_usb_rx_stream() fails
Date:   Wed,  4 Jan 2023 01:30:52 +0300
Message-Id: <20230103223052.303666-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <875ydn49h2.fsf@toke.dk>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hmm, so in the other error cases (if SKB allocation fails), we just
> 'goto err' and call the receive handler for the packets already in
> skb_pool. Why can't we do the same here?

If SKB allocation fails, then the packets already in skb_pool should be
processed by htc rx handler, yes. About the other two cases: if pkt_tag or
pkt_len is invalid, then the whole SKB is considered invalid and dropped.
That is what the statistics macros tell. So I think we should not process
packets from skb_pool which are associated with a dropped SKB. And so just
free them instead.

> Also, I think there's another bug in that function, which this change
> will make worse? Specifically, in the start of that function,
> hif_dev->remain_skb is moved to skb_pool[0], but not cleared from
> hif_dev itself. So if we then hit the invalid check and free it, the
> next time the function is called, we'll get the same remain_skb pointer,
> which has now been freed.

Sorry, I missed that somehow.
Moving 'hif_dev->rx_remain_len = index - MAX_RX_BUF_SIZE;' after
"ath9k_htc: RX memory allocation error\n" error path should be done, too.
hif_dev->rx_remain_len is zeroed after remain_skb processing, so we cannot
reference hif_dev->remain_skb unless we explicitly allocate successfully a
new one (making rx_remain_len non zero).

> So I think we'll need to clear out hif_dev->remain_skb after moving it
> to skb_pool. Care to add that as well?

Yes, this must be done. I'll add it to patch v3.
