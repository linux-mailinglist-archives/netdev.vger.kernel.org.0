Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD2E6112DC
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiJ1Ndh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 09:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiJ1Ndg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:33:36 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6A887FA2;
        Fri, 28 Oct 2022 06:33:34 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id ECA271D2D;
        Fri, 28 Oct 2022 15:33:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1666964012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HdcN1BhGsBnPPVO/4wBz4n/Y9QzgaC0l5BN3K5+ViG4=;
        b=T3uh6XpYtihejeUVixiLjJApNOt95SQFEbnhQ5NIBEPsh3+7mcK5fxHvQcwMmYfO/OgAAW
        lN/6NHmPNsML3aNK+L8nwY3+cxzEQUmKu7YFytUXCZyvXjDB/CoQi7wyyXnNeNWj2Us8Gf
        CUImSGkSGnTezvO3z+KOR3qtrtF/fKnY3pT/lIybaTDp1azsqRONxDOEAlXtJ9DZWEgLHD
        4edf7kT6NFI6UAGMTehj/GSBmcXSej/IzhHUsMXXDTHR4Prl4Ly7ghogF95Ei2u3Fp3HS5
        j8eHJ8M2fR0AqIuRyTkMfz7ww7YC1OTQ1HocwzsYLuDf7U52UxEEwlV59R/iUw==
MIME-Version: 1.0
Date:   Fri, 28 Oct 2022 15:33:31 +0200
From:   Michael Walle <michael@walle.cc>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Robert Marko <robert.marko@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH 5/5] net: mvpp2: Consider NVMEM cells as possible MAC
 address source
In-Reply-To: <20221028092337.822840-6-miquel.raynal@bootlin.com>
References: <20221028092337.822840-1-miquel.raynal@bootlin.com>
 <20221028092337.822840-6-miquel.raynal@bootlin.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <30660579be1f7c964eafa825246916ac@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-10-28 11:23, schrieb Miquel Raynal:
> The ONIE standard describes the organization of tlv (type-length-value)
> arrays commonly stored within NVMEM devices on common networking
> hardware.
> 
> Several drivers already make use of NVMEM cells for purposes like
> retrieving a default MAC address provided by the manufacturer.
> 
> What made ONIE tables unusable so far was the fact that the information
> where "dynamically" located within the table depending on the
> manufacturer wishes, while Linux NVMEM support only allowed statically
> defined NVMEM cells. Fortunately, this limitation was eventually 
> tackled
> with the introduction of discoverable cells through the use of NVMEM
> layouts, making it possible to extract and consistently use the content
> of tables like ONIE's tlv arrays.
> 
> Parsing this table at runtime in order to get various information is 
> now
> possible. So, because many Marvell networking switches already follow
> this standard, let's consider using NVMEM cells as a new valid source 
> of
> information when looking for a base MAC address, which is one of the
> primary uses of these new fields. Indeed, manufacturers following the
> ONIE standard are encouraged to provide a default MAC address there, so
> let's eventually use it if no other MAC address has been found using 
> the
> existing methods.
> 
> Link: 
> https://opencomputeproject.github.io/onie/design-spec/hw_requirements.html
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
> 
> Hello, I suppose my change is safe but I don't want to break existing
> setups so a review on this would be welcome!
> 
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index eb0fb8128096..7c8c323f4411 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -6104,6 +6104,12 @@ static void mvpp2_port_copy_mac_addr(struct
> net_device *dev, struct mvpp2 *priv,
>  		}
>  	}
> 
> +	if (!of_get_mac_address(to_of_node(fwnode), hw_mac_addr)) {

Mh, the driver already does a fwnode_get_mac_address() which might
fetch it from OF. But that variant doesn't try to get the mac address
via nvmem; in contrast to the of_get_mac_address() variant which will
also try NVMEM.
Maybe it would be better to just use device_get_ethdev_address() and
extend that one to also try the nvmem store. Just to align all the
different variants to get a mac address.

-michael

> +		*mac_from = "nvmem cell";
> +		eth_hw_addr_set(dev, hw_mac_addr);
> +		return;
> +	}
> +
>  	*mac_from = "random";
>  	eth_hw_addr_random(dev);
>  }
