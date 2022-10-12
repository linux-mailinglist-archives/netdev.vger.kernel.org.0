Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 550125FC3F2
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 12:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiJLKui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 06:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJLKuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 06:50:37 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C6211461;
        Wed, 12 Oct 2022 03:50:36 -0700 (PDT)
Received: from [IPV6:2003:e9:d70e:f1c1:fef2:18a8:26e3:47fd] (p200300e9d70ef1c1fef218a826e347fd.dip0.t-ipconnect.de [IPv6:2003:e9:d70e:f1c1:fef2:18a8:26e3:47fd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 712B6C0434;
        Wed, 12 Oct 2022 12:50:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1665571834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eZdUB4TdR9pVIZFU+Ykt4nl3W4RJ8yzKYdJcXtjdCLo=;
        b=ERrQsfNcg8/rqosvUhEEqwOWWMTVWlS6pIm9yZWy88fpsZWKKmFaRd8U5hyoXf+zoQI4Ys
        1u6iWsYbYa2sf2E6kgcCUvMs8AzKeVMbiXDqyhUwC6+Uqwn6Cz6atA3PPkMn8WJfU2Nz5d
        1KqcW8mDsWI8zjSHWA7a8hiUTpwLeFXMD1DcHhtkq5+lqPMC5BFwaCb5t8N8ema0/OktBc
        gt2xiHuLQLp3EX6wBDjCyH6Fpf/XGtokzz1DcUY+C/BC4uD8Hm1atjXwYs6qQD8Suwow3G
        tOGJ1RDRDCEOFRkXaIxh9nCTn+fqfGFiSirU8YaRVbGq3SFebBeAnF4wF054Yg==
Message-ID: <e0e2a450-e70a-fffb-9c9d-6108347e2eaa@datenfreihafen.org>
Date:   Wed, 12 Oct 2022 12:50:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH wpan/next v4 8/8] mac802154: Ensure proper scan-level
 filtering
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
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20221007085310.503366-1-miquel.raynal@bootlin.com>
 <20221007085310.503366-9-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20221007085310.503366-9-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Miquel.

On 07.10.22 10:53, Miquel Raynal wrote:
> We now have a fine grained filtering information so let's ensure proper
> filtering in scan mode, which means that only beacons are processed.
> 
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>   net/mac802154/rx.c | 16 ++++++++++++----
>   1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> index 14bc646b9ab7..4d799b477a7f 100644
> --- a/net/mac802154/rx.c
> +++ b/net/mac802154/rx.c
> @@ -34,6 +34,7 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
>   		       struct sk_buff *skb, const struct ieee802154_hdr *hdr)
>   {
>   	struct wpan_dev *wpan_dev = &sdata->wpan_dev;
> +	struct wpan_phy *wpan_phy = sdata->local->hw.phy;
>   	__le16 span, sshort;
>   	int rc;
>   
> @@ -42,6 +43,17 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
>   	span = wpan_dev->pan_id;
>   	sshort = wpan_dev->short_addr;
>   
> +	/* Level 3 filtering: Only beacons are accepted during scans */
> +	if (sdata->required_filtering == IEEE802154_FILTERING_3_SCAN &&
> +	    sdata->required_filtering > wpan_phy->filtering) {
> +		if (mac_cb(skb)->type != IEEE802154_FC_TYPE_BEACON) {
> +			dev_dbg(&sdata->dev->dev,
> +				"drop !beacon frame (0x%x) during scan\n",

This ! before the beacon looks like a typo. Please fix.

> +				mac_cb(skb)->type);
> +			goto fail;
> +		}
> +	}
> +
>   	switch (mac_cb(skb)->dest.mode) {
>   	case IEEE802154_ADDR_NONE:
>   		if (hdr->source.mode != IEEE802154_ADDR_NONE)
> @@ -277,10 +289,6 @@ void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb)
>   
>   	ieee802154_monitors_rx(local, skb);
>   
> -	/* TODO: Handle upcomming receive path where the PHY is at the
> -	 * IEEE802154_FILTERING_NONE level during a scan.
> -	 */
> -
>   	/* Level 1 filtering: Check the FCS by software when relevant */
>   	if (local->hw.phy->filtering == IEEE802154_FILTERING_NONE) {
>   		crc = crc_ccitt(0, skb->data, skb->len);

When trying to apply the patch it did not work:

Failed to apply patch:
error: patch failed: net/mac802154/rx.c:42
error: net/mac802154/rx.c: patch does not apply
hint: Use 'git am --show-current-patch=diff' to see the failed patch
Applying: mac802154: Ensure proper scan-level filtering
Patch failed at 0001 mac802154: Ensure proper scan-level filtering

On top of what tree or branch is this? Maybe you based it on some not 
applied patches? Please rebase against wpan-next and re-submit. The rest 
of the patches got applied.

Thanks for the ongoing work on this.

regards
Stefan Schmidt
