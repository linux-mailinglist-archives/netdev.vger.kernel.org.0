Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888095A45AD
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 11:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiH2JEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 05:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiH2JEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 05:04:22 -0400
X-Greylist: delayed 685 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 29 Aug 2022 02:04:20 PDT
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E305A3CA;
        Mon, 29 Aug 2022 02:04:20 -0700 (PDT)
Received: from [IPV6:2003:e9:d701:1d41:444a:bdf5:adf8:9c98] (p200300e9d7011d41444abdf5adf89c98.dip0.t-ipconnect.de [IPv6:2003:e9:d701:1d41:444a:bdf5:adf8:9c98])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 943E8C04DF;
        Mon, 29 Aug 2022 11:04:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1661763858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qHvwfHuNYAk8OvC72SRrqcUiCcrjxTKqL/yWDeOoZxU=;
        b=Kf2CAKty6v99mACoOIjIrdrwsaGCQapKVZwmoLzRNA1JCabAdEtyUAq4JD2FVf5cOYbQRv
        t4L5MY8NtJXmKwaRqKEKGnpnjsZcsz6VmKpQ9LQTsEE6H0qLVx6/us/tHaKgYFFOglUKkD
        xxppgraU0P4rIAQqwNdl1WgE0fkafMne1e3c8EsKrrZeSmv4+oCSRta8CMGVY/nJPfZOU7
        CrmgBgIAncImh279v6W+gR1M9ZLGVYBBL8yfv/3ik91OB+hBkzn3GFNc8r5sKLqj+I0pqf
        BFWcONs7mqJM/t3DIF/aCM6n27PwhKGE/uUrz3LZezfHXtqVF9EDAvFgxzm41Q==
Message-ID: <8c2f3ef3-af8b-f31b-8742-bdd7cace45d0@datenfreihafen.org>
Date:   Mon, 29 Aug 2022 11:04:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] net: mac802154: Fix a condition in the receive path
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>, linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
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
 <57b7d918-1da1-f490-4882-5ed25ea17503@datenfreihafen.org>
 <20220829110159.6321a85f@xps-13>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220829110159.6321a85f@xps-13>
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

Hello Miquel

On 29.08.22 11:01, Miquel Raynal wrote:
> Hi Stefan,
> 
> stefan@datenfreihafen.org wrote on Mon, 29 Aug 2022 10:52:52 +0200:
> 
>> Hello Miquel.
>>
>> On 26.08.22 16:29, Miquel Raynal wrote:
>>> Upon reception, a packet must be categorized, either it's destination is
>>> the host, or it is another host. A packet with no destination addressing
>>> fields may be valid in two situations:
>>> - the packet has no source field: only ACKs are built like that, we
>>>     consider the host as the destination.
>>> - the packet has a valid source field: it is directed to the PAN
>>>     coordinator, as for know we don't have this information we consider we
>>>     are not the PAN coordinator.
>>>
>>> There was likely a copy/paste error made during a previous cleanup
>>> because the if clause is now containing exactly the same condition as in
>>> the switch case, which can never be true. In the past the destination
>>> address was used in the switch and the source address was used in the
>>> if, which matches what the spec says.
>>>
>>> Cc: stable@vger.kernel.org
>>> Fixes: ae531b9475f6 ("ieee802154: use ieee802154_addr instead of *_sa variants")
>>> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
>>> ---
>>>    net/mac802154/rx.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
>>> index b8ce84618a55..c439125ef2b9 100644
>>> --- a/net/mac802154/rx.c
>>> +++ b/net/mac802154/rx.c
>>> @@ -44,7 +44,7 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
>>>    >   	switch (mac_cb(skb)->dest.mode) {
>>>    	case IEEE802154_ADDR_NONE:
>>> -		if (mac_cb(skb)->dest.mode != IEEE802154_ADDR_NONE)
>>> +		if (hdr->source.mode != IEEE802154_ADDR_NONE)
>>>    			/* FIXME: check if we are PAN coordinator */
>>>    			skb->pkt_type = PACKET_OTHERHOST;
>>>    		else
>>
>>
>> This patch has been applied to the wpan tree and will be
>> part of the next pull request to net. Thanks!
> 
> Great, thanks!
> 
> We should expect it not to apply until the tag mentioned in Fixes
> because in 2015 or so there was some cleaned done by Alexander which
> move things around a little bit, but I think we are fine skipping those
> older releases anyway.

The machinery behind stable handles this already. It checks for the 
fixes tag and also sees if patches apply.

regards
Stefan Schmidt
