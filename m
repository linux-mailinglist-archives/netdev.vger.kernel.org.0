Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 053F365C897
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 22:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbjACVFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 16:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbjACVEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 16:04:36 -0500
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3265E140D6;
        Tue,  3 Jan 2023 13:04:35 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1672779873; bh=qyIjFinFityRMegIbRBQ0PW0rEHzPyNxjyFmnFCju74=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=OqJ6s5aS9ol7+Z3Q1KJY0H6pLRFHCicC55Ndp9L7dz0ccrvVv+yvwtl0slItF5wl7
         90JQXzIirW2+kOpDZZJk5oHkm/50naHmn+RyGoZICaVUCxZuz8uTxtQVR9feh9Np8Q
         hSwSqn908yv5toaWdIEul5I+0kL4052W6F1z57iDi1zN38/JIRz70iMw2N8H2CAGCr
         athRsV2I1k1wLQ3OwrvI46+f+eddhiBo8kPNR5v3MS1qofBhEpQqatQeX/IfCZ5tYC
         doMxqzcd7gj3HF3+i+nwbDkQMfIRA2MBcFWm6RcFuB+tIYg0I+HZ7tU0V8vNG6Ka7Z
         7fIB4iw3xdOyA==
To:     Fedor Pchelkin <pchelkin@ispras.ru>, Kalle Valo <kvalo@kernel.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sujith <Sujith.Manoharan@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+e008dccab31bd3647609@syzkaller.appspotmail.com,
        syzbot+6692c72009680f7c4eb2@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] wifi: ath9k: htc_hst: free skb in ath9k_htc_rx_msg()
 if there is no callback function
In-Reply-To: <20230103143202.274163-1-pchelkin@ispras.ru>
References: <20230103143202.274163-1-pchelkin@ispras.ru>
Date:   Tue, 03 Jan 2023 22:04:31 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87358r49eo.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fedor Pchelkin <pchelkin@ispras.ru> writes:

> It is stated that ath9k_htc_rx_msg() either frees the provided skb or
> passes its management to another callback function. However, the skb is
> not freed in case there is no another callback function, and Syzkaller was
> able to cause a memory leak. Also minor comment fix.
>
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
>
> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
> Reported-by: syzbot+e008dccab31bd3647609@syzkaller.appspotmail.com
> Reported-by: syzbot+6692c72009680f7c4eb2@syzkaller.appspotmail.com
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
> v1->v2: added Reported-by tag
>
>  drivers/net/wireless/ath/ath9k/htc_hst.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
> index ca05b07a45e6..7d5041eb5f29 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_hst.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
> @@ -391,7 +391,7 @@ static void ath9k_htc_fw_panic_report(struct htc_target *htc_handle,
>   * HTC Messages are handled directly here and the obtained SKB
>   * is freed.
>   *
> - * Service messages (Data, WMI) passed to the corresponding
> + * Service messages (Data, WMI) are passed to the corresponding
>   * endpoint RX handlers, which have to free the SKB.
>   */
>  void ath9k_htc_rx_msg(struct htc_target *htc_handle,
> @@ -478,6 +478,8 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
>  		if (endpoint->ep_callbacks.rx)
>  			endpoint->ep_callbacks.rx(endpoint->ep_callbacks.priv,
>  						  skb, epid);
> +		else
> +			kfree_skb(skb);

Shouldn't this be 'goto invalid' like all the other error paths in that
function?

-Toke
