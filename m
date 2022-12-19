Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90053650A54
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 11:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbiLSKrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 05:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbiLSKrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 05:47:40 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F207679;
        Mon, 19 Dec 2022 02:47:38 -0800 (PST)
Received: from [IPV6:2003:e9:d70f:33e:d1f9:2e05:da8a:5704] (p200300e9d70f033ed1f92e05da8a5704.dip0.t-ipconnect.de [IPv6:2003:e9:d70f:33e:d1f9:2e05:da8a:5704])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 455E9C0072;
        Mon, 19 Dec 2022 11:47:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1671446855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JYZySaiFdXLXW0/PWwE0B52mvQ/TZatlTS/FttBQT6Y=;
        b=REwfu87/R/osO1DQTT1gVg4ogVpxvGsEpc0q1vKtLKOLmSwwJUn1MtucRECRhmdSgzQtJc
        yrsDJHSe90/SsVyqD6YmyUrC7g/hTQ3akgnKmDPyR8grH0z29JEUy4NfeRnljijsR2P5tZ
        JnVn/a9UOgJiazYndjaUc02cUDImSBqLTE7J4yvmn1Uyv0fg1eSxhSMNokwCFS52l4F/s0
        ARhYxY0gFktnw9qPHCaEBPLYSNiS1tl2GJV/4NUANEB+06kXrsrCVaRUoBCDGjjk6OTYZc
        DIWTw9d16KO71LJDVJuVtRaocFfM+YXC/EF2busSHCs+iGR1e+oa4o8ImV4xtw==
Message-ID: <d6a75127-1b29-0260-b0ad-ceb88edcdd49@datenfreihafen.org>
Date:   Mon, 19 Dec 2022 11:47:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH wpan] mac802154: Fix possible double free upon parsing
 error
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org
Cc:     David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>
References: <20221216235742.646134-1-miquel.raynal@bootlin.com>
Content-Language: en-US
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20221216235742.646134-1-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 17.12.22 00:57, Miquel Raynal wrote:
> Commit 4d1c7d87030b ("mac802154: Move an skb free within the rx path")
> tried to simplify error handling within the receive path by moving the
> kfree_skb() call at the very end of the top-level function but missed
> one kfree_skb() called upon frame parsing error. Prevent this possible
> double free from happening.
> 
> Fixes: 4d1c7d87030b ("mac802154: Move an skb free within the rx path")
> Reported-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>   net/mac802154/rx.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> index c2aae2a6d6a6..97bb4401dd3e 100644
> --- a/net/mac802154/rx.c
> +++ b/net/mac802154/rx.c
> @@ -213,7 +213,6 @@ __ieee802154_rx_handle_packet(struct ieee802154_local *local,
>   	ret = ieee802154_parse_frame_start(skb, &hdr);
>   	if (ret) {
>   		pr_debug("got invalid frame\n");
> -		kfree_skb(skb);
>   		return;
>   	}
>   

This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
