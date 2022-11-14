Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F744627DBB
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 13:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237148AbiKNM1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 07:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235865AbiKNM1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 07:27:48 -0500
X-Greylist: delayed 990 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Nov 2022 04:27:46 PST
Received: from mxout70.expurgate.net (mxout70.expurgate.net [91.198.224.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27ED622514;
        Mon, 14 Nov 2022 04:27:46 -0800 (PST)
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <prvs=5331a43a77=ms@dev.tdt.de>)
        id 1ouY2C-000MW2-He; Mon, 14 Nov 2022 12:53:52 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1ouY2B-000Ogm-0L; Mon, 14 Nov 2022 12:53:51 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id EAA09240049;
        Mon, 14 Nov 2022 12:53:49 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 44DA0240040;
        Mon, 14 Nov 2022 12:53:49 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id B9A1C228B9;
        Mon, 14 Nov 2022 12:53:48 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 14 Nov 2022 12:53:48 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Wei Yongjun <weiyongjun@huaweicloud.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        Matthew Daley <mattjd@gmail.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] net/x25: Fix skb leak in x25_lapb_receive_frame()
Organization: TDT AG
In-Reply-To: <20221114110519.514538-1-weiyongjun@huaweicloud.com>
References: <20221114110519.514538-1-weiyongjun@huaweicloud.com>
Message-ID: <ca0d14934e90d4767309cea20e6510dd@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.17
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-purgate-ID: 151534::1668426831-CA7FAB43-95A39ACC/0/0
X-purgate-type: clean
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-11-14 12:05, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> x25_lapb_receive_frame() using skb_copy() to get a private copy of
> skb, the new skb should be freed in the undersized/fragmented skb
> error handling path. Otherwise there is a memory leak.
> 
> Fixes: cb101ed2c3c7 ("x25: Handle undersized/fragmented skbs")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  net/x25/x25_dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/x25/x25_dev.c b/net/x25/x25_dev.c
> index 5259ef8f5242..748d8630ab58 100644
> --- a/net/x25/x25_dev.c
> +++ b/net/x25/x25_dev.c
> @@ -117,7 +117,7 @@ int x25_lapb_receive_frame(struct sk_buff *skb,
> struct net_device *dev,
> 
>  	if (!pskb_may_pull(skb, 1)) {
>  		x25_neigh_put(nb);
> -		return 0;
> +		goto drop;
>  	}
> 
>  	switch (skb->data[0]) {

Looks good to me.

Thanks.

Acked-by: Martin Schiller <ms@dev.tdt.de>
