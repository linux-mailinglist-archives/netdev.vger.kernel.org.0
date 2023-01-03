Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A160265C1CC
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 15:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237899AbjACOW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 09:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238011AbjACOOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 09:14:54 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870B611445;
        Tue,  3 Jan 2023 06:14:51 -0800 (PST)
Received: from [IPV6:2003:e9:d713:1514:accc:688a:efc9:2199] (p200300e9d7131514accc688aefc92199.dip0.t-ipconnect.de [IPv6:2003:e9:d713:1514:accc:688a:efc9:2199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 8160BC03A4;
        Tue,  3 Jan 2023 15:14:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1672755288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vvZwNHE5dRkWjxoSZ1IH7ISFZfsS1G+0GFlUsVX0Nbs=;
        b=Nwc2URL0cBo7O4h8jcxqU8A0z5Pb2lWgMMPBGAXYk9yUDvhKzc7ZP1W25ioU+W8JCvVWtx
        lZsjAGUcWuB2XoArhgNCHxKZW8WJ6+8LcqPX3EGc7QTZCqgFKbVsUfpFzpxE6UDCfH91RQ
        Q8o2OWzM1gPvp/p6InznCPOaFSpQPWZFf4/jzH/RirvhhssmjP0tSMgLUcUhfLy+XKs4YL
        ccW0PbwURMMBNXS4WEP2yYT656FmJiXPNiM34arU6Qk2stSbSNBXmWWPfQHH3Mxjf7/OOf
        ORS4lYqDBX7EBbBL6R/keycxDh4xU3066o8P2XZ87RCgmQf2Z53aQPvRD81vFg==
Message-ID: <b1c095d1-6dee-b49d-52d4-a5ea84f36cfd@datenfreihafen.org>
Date:   Tue, 3 Jan 2023 15:14:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH wpan-next v2 3/6] ieee802154: Introduce a helper to
 validate a channel
Content-Language: en-US
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
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
References: <20221217000226.646767-1-miquel.raynal@bootlin.com>
 <20221217000226.646767-4-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20221217000226.646767-4-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Miquel.

On 17.12.22 01:02, Miquel Raynal wrote:
> This helper for now only checks if the page member and channel member
> are valid (in the specification range) and supported (by checking the
> device capabilities). Soon two new parameters will be introduced and
> having this helper will let us only modify its content rather than
> modifying the logic everywhere else in the subsystem.
> 
> There is not functional change.
> 
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>   include/net/cfg802154.h   | 11 +++++++++++
>   net/ieee802154/nl802154.c |  3 +--
>   2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> index 76d4f95e9974..11bedfa96371 100644
> --- a/include/net/cfg802154.h
> +++ b/include/net/cfg802154.h
> @@ -246,6 +246,17 @@ static inline void wpan_phy_net_set(struct wpan_phy *wpan_phy, struct net *net)
>   	write_pnet(&wpan_phy->_net, net);
>   }
>   
> +static inline bool ieee802154_chan_is_valid(struct wpan_phy *phy,
> +                                            u8 page, u8 channel)
> +{
> +        if (page > IEEE802154_MAX_PAGE ||
> +            channel > IEEE802154_MAX_CHANNEL ||
> +            !(phy->supported.channels[page] & BIT(channel)))
> +                return false;
> +
> +	return true;
> +}
> +

This patch has some indent problems.

Commit 6bbb25ee282b ("ieee802154: Introduce a helper to validate a channel")
----------------------------------------------------------------------------
ERROR: code indent should use tabs where possible
#31: FILE: include/net/cfg802154.h:250:
+                                            u8 page, u8 channel)$

WARNING: please, no spaces at the start of a line
#31: FILE: include/net/cfg802154.h:250:
+                                            u8 page, u8 channel)$

ERROR: code indent should use tabs where possible
#33: FILE: include/net/cfg802154.h:252:
+        if (page > IEEE802154_MAX_PAGE ||$

WARNING: please, no spaces at the start of a line
#33: FILE: include/net/cfg802154.h:252:
+        if (page > IEEE802154_MAX_PAGE ||$

ERROR: code indent should use tabs where possible
#34: FILE: include/net/cfg802154.h:253:
+            channel > IEEE802154_MAX_CHANNEL ||$

WARNING: please, no spaces at the start of a line
#34: FILE: include/net/cfg802154.h:253:
+            channel > IEEE802154_MAX_CHANNEL ||$

ERROR: code indent should use tabs where possible
#35: FILE: include/net/cfg802154.h:254:
+            !(phy->supported.channels[page] & BIT(channel)))$

WARNING: please, no spaces at the start of a line
#35: FILE: include/net/cfg802154.h:254:
+            !(phy->supported.channels[page] & BIT(channel)))$

ERROR: code indent should use tabs where possible
#36: FILE: include/net/cfg802154.h:255:
+                return false;$

WARNING: please, no spaces at the start of a line
#36: FILE: include/net/cfg802154.h:255:
+                return false;$

total: 5 errors, 5 warnings, 0 checks, 26 lines checked

regards
Stefan Schmidt
