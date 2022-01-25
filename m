Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 748FA49B659
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 15:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239952AbiAYOe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 09:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238760AbiAYObS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 09:31:18 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A8BC061744;
        Tue, 25 Jan 2022 06:28:15 -0800 (PST)
Received: from [IPV6:2003:e9:d71e:a9f7:7a7b:6f31:a637:f96b] (p200300e9d71ea9f77a7b6f31a637f96b.dip0.t-ipconnect.de [IPv6:2003:e9:d71e:a9f7:7a7b:6f31:a637:f96b])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id D586DC0100;
        Tue, 25 Jan 2022 15:28:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1643120893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+mZVwNKBxOE5acabiK0Iz46vtPviphuOslEbYACtLUk=;
        b=XNFHQViA0f+nCjqISEvKHTXdm2GxA33cEDMrWExk5ut26pUMJ6ffzOxMzXhvQxf8H/Ew25
        RqF092opPOc2G2u6qP1xgSE1rF/9gheT30kJlHBXAMgwBBi6F9FIYZWgyFVfzmNxoUGhub
        LWIieW5wYHWW+2z/C26HWuwBfqDi/fWXvnG5uOYG1HeBH75Y1umxZnGiUfj1MMPeV04yL6
        5cbUm3CdypVLnYsAU//O2HMHKOarHI0eGxZCsJG1AZNFnE7+Dw7foskGJA0kMUYB6AKnPI
        Tu07d9iztkf1uRicIT/0omzkDVc5lzSl+zt2X31S8ujCghC6WVpA2q05L9pM2A==
Message-ID: <d3cab1bb-184d-73f9-7bd8-8eefc5e7e70c@datenfreihafen.org>
Date:   Tue, 25 Jan 2022 15:28:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [wpan v3 1/6] net: ieee802154: hwsim: Ensure proper channel
 selection at probe time
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20220125121426.848337-1-miquel.raynal@bootlin.com>
 <20220125121426.848337-2-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220125121426.848337-2-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello.

On 25.01.22 13:14, Miquel Raynal wrote:
> Drivers are expected to set the PHY current_channel and current_page
> according to their default state. The hwsim driver is advertising being
> configured on channel 13 by default but that is not reflected in its own
> internal pib structure. In order to ensure that this driver consider the
> current channel as being 13 internally, we at least need to set the
> pib->channel field to 13.
> 
> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>   drivers/net/ieee802154/mac802154_hwsim.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
> index 8caa61ec718f..00ec188a3257 100644
> --- a/drivers/net/ieee802154/mac802154_hwsim.c
> +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> @@ -786,6 +786,7 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
>   		goto err_pib;
>   	}
>   
> +	pib->page = 13;

You want to set channel not page here.

>   	rcu_assign_pointer(phy->pib, pib);
>   	phy->idx = idx;
>   	INIT_LIST_HEAD(&phy->edges);
> 

regards
Stefan Schmidt
