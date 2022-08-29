Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05B05A4566
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 10:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiH2IrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 04:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiH2IrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 04:47:05 -0400
X-Greylist: delayed 516 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 29 Aug 2022 01:47:03 PDT
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C5D58B4D;
        Mon, 29 Aug 2022 01:47:03 -0700 (PDT)
Received: from [IPV6:2003:e9:d701:1d41:444a:bdf5:adf8:9c98] (p200300e9d7011d41444abdf5adf89c98.dip0.t-ipconnect.de [IPv6:2003:e9:d701:1d41:444a:bdf5:adf8:9c98])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 53E41C0470;
        Mon, 29 Aug 2022 10:38:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1661762302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q6WZrksaxTXAg1fPRdX78hmm/Gb5LHYbs8Mw+1HNcmI=;
        b=SHlCOcyf53HhexsTxTSm4VbcrsOdU5mGUx44XV9BtBFou8nlhJOIGkxtO0bhfMEc0NFu+D
        Gm0xFAAAU9DBWH2tfyEVHt6r8Ha+VRKApy+Spgbl6Qhr8gggT5ZAcwtg54vdPjKK7qmLca
        E5RgjT9ZS2NCDQpyzkfpHvD+MY+6vS8sgAyCJq8Gd5l75RVyzbwvJ/fiV9mbW1LAHSWHnS
        x32Go1pIYZdryIXwIgsxISGLdZyAaXXTLv+PaGtDPJrWljZ3Rj0oNfBUUjPKMvw/UsIG05
        LrAX7Hbk/mWMdHWeJqf8vnWRFH94LgQfhfcdUE85/lDE3RRdRWVntf0/5+WlrA==
Message-ID: <cbd7d863-4e30-a617-e751-57be0da8706c@datenfreihafen.org>
Date:   Mon, 29 Aug 2022 10:38:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] net: mac802154: Fix a condition in the receive path
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Alexander Aring <aahringo@redhat.com>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        stable@vger.kernel.org
References: <20220826142954.254853-1-miquel.raynal@bootlin.com>
 <CAK-6q+imPjpBxSZG7e5nxYYgtkrM5pfncxza9=vA+sq+eFQsUw@mail.gmail.com>
 <YwxOc+X7VpMhKv+4@kroah.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <YwxOc+X7VpMhKv+4@kroah.com>
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


Hello Greg.

On 29.08.22 07:28, Greg KH wrote:
> On Sun, Aug 28, 2022 at 08:16:20PM -0400, Alexander Aring wrote:
>> Hi,
>>
>> On Fri, Aug 26, 2022 at 10:31 AM Miquel Raynal
>> <miquel.raynal@bootlin.com> wrote:
>>>
>>> Upon reception, a packet must be categorized, either it's destination is
>>> the host, or it is another host. A packet with no destination addressing
>>> fields may be valid in two situations:
>>> - the packet has no source field: only ACKs are built like that, we
>>>    consider the host as the destination.
>>> - the packet has a valid source field: it is directed to the PAN
>>>    coordinator, as for know we don't have this information we consider we
>>>    are not the PAN coordinator.
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
>>>   net/mac802154/rx.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
>>> index b8ce84618a55..c439125ef2b9 100644
>>> --- a/net/mac802154/rx.c
>>> +++ b/net/mac802154/rx.c
>>> @@ -44,7 +44,7 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
>>>
>>>          switch (mac_cb(skb)->dest.mode) {
>>>          case IEEE802154_ADDR_NONE:
>>> -               if (mac_cb(skb)->dest.mode != IEEE802154_ADDR_NONE)
>>> +               if (hdr->source.mode != IEEE802154_ADDR_NONE)
>>>                          /* FIXME: check if we are PAN coordinator */
>>>                          skb->pkt_type = PACKET_OTHERHOST;
>>>                  else
>>
>>
>> This patch looks okay but it should not be addressed to stable. Leave
>> of course the fixes tag.
> 
> Why do that?  Do you not want this in the stable tree?

We want and we will leave the cc to stable in place, see below.

>> Wpan sends pull requests to net and they have their own way to get
>> into the stable tree when they are in net.
> 
> No, the normal method has been used for quite a while now.

I think Alex was refering to the times where netdev core changes have 
been brought to stable via a different route by DaveM.

This was never the case for ieee802154 though. We are such a small 
subsystem with little traffic that we followed the normal stable process 
and our patches ahve always been picked up by Sasha and the bots.

I will take this through my tree with stable cc and fixes tag preserved 
and it will go to Linux via net and follow the normal process.

regards
Stefan Schmidt
