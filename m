Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A345A457D
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 10:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiH2Iw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 04:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiH2Iw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 04:52:57 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45E43E75B;
        Mon, 29 Aug 2022 01:52:56 -0700 (PDT)
Received: from [IPV6:2003:e9:d701:1d41:444a:bdf5:adf8:9c98] (p200300e9d7011d41444abdf5adf89c98.dip0.t-ipconnect.de [IPv6:2003:e9:d701:1d41:444a:bdf5:adf8:9c98])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 2E315C040C;
        Mon, 29 Aug 2022 10:52:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1661763173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iQ5Dq6aO7k3wThAyTmRb5rc7/WX+rXnICW9j+3SuS4g=;
        b=KDPkutYIE5yP5HSJFWizVWmOQKBZs43E5JToRFTN0ckLi9tA68csIs2y8IU0DXAKu1GCqn
        OkE7qU0U0krvmHygQFUKjOEOreba8CTK4veqI0JQFD+qgvZBoyQYNgI8rwRGs+kWTfe7jN
        B9XlyszWC5Gjmsxm8g1NEMCMO4ms1cYsGZ1UKBRcmyFaE6Tr2gbaoRORGi6o0I75wmDHdb
        In0xUdb83KLK7cO8e3rVXwwHa3a8MXQb/tUySbghVhHcbDHErojlm9T9P+SygoZs2Prt5X
        nxc3M+mMJ3TVsPZ/nSM4SSTG0+VeTyiqzO9AU7AwyBIczjj0NMio2yD77RaB9Q==
Message-ID: <57b7d918-1da1-f490-4882-5ed25ea17503@datenfreihafen.org>
Date:   Mon, 29 Aug 2022 10:52:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] net: mac802154: Fix a condition in the receive path
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        stable@vger.kernel.org
References: <20220826142954.254853-1-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220826142954.254853-1-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello Miquel.

On 26.08.22 16:29, Miquel Raynal wrote:
> Upon reception, a packet must be categorized, either it's destination is
> the host, or it is another host. A packet with no destination addressing
> fields may be valid in two situations:
> - the packet has no source field: only ACKs are built like that, we
>    consider the host as the destination.
> - the packet has a valid source field: it is directed to the PAN
>    coordinator, as for know we don't have this information we consider we
>    are not the PAN coordinator.
> 
> There was likely a copy/paste error made during a previous cleanup
> because the if clause is now containing exactly the same condition as in
> the switch case, which can never be true. In the past the destination
> address was used in the switch and the source address was used in the
> if, which matches what the spec says.
> 
> Cc: stable@vger.kernel.org
> Fixes: ae531b9475f6 ("ieee802154: use ieee802154_addr instead of *_sa variants")
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>   net/mac802154/rx.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> index b8ce84618a55..c439125ef2b9 100644
> --- a/net/mac802154/rx.c
> +++ b/net/mac802154/rx.c
> @@ -44,7 +44,7 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
>   
>   	switch (mac_cb(skb)->dest.mode) {
>   	case IEEE802154_ADDR_NONE:
> -		if (mac_cb(skb)->dest.mode != IEEE802154_ADDR_NONE)
> +		if (hdr->source.mode != IEEE802154_ADDR_NONE)
>   			/* FIXME: check if we are PAN coordinator */
>   			skb->pkt_type = PACKET_OTHERHOST;
>   		else


This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
