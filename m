Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00EDE609DED
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 11:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiJXJY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 05:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiJXJY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 05:24:56 -0400
X-Greylist: delayed 308 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 24 Oct 2022 02:24:54 PDT
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C11B1EAD6;
        Mon, 24 Oct 2022 02:24:50 -0700 (PDT)
Received: from [10.1.64.117] (unknown [217.17.28.204])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 85EC9C04DF;
        Mon, 24 Oct 2022 11:19:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1666603174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9C8n0HvPrUUkVdviYVLkXV4GrKjQbzZgaUI6KmUBM0Y=;
        b=UMVXK1r6CFwVdCj9yvkl6C6P7OkNIQW/jO90c8X6/quJSuLHG9F90ReBiUM47jr1Ii9eQG
        8Gk6n28wefuinqFKSsjxbdb3ipUijnGSCqwfTThW9bKCO/cxUwrOOC8iT873tS4cBJEd/F
        ohHtcGEQmgIK3OIG+u3rZOnfXt2CN/Yvoskh9TxzfORKxfZ+REUt5lU9MZaRB5QqH8JVGp
        syoWJSMsYszxKUlocrzFkKi7WScJ+ltCoq5XU4R9Y03RHIEh93COCtAUlhti3rHmZJP8Gh
        /C8z6FJiWw4IrqvLfNI6eJyTQWP5xOn2MMkXA36Jb3Raff35QSCN0RGkX50WwA==
Message-ID: <370df52d-8e9f-3628-36db-a59c1722e01f@datenfreihafen.org>
Date:   Mon, 24 Oct 2022 11:19:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH wpan] mac802154: Fix LQI recording
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
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        stable@vger.kernel.org
References: <20221020142535.1038885-1-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20221020142535.1038885-1-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 20.10.22 16:25, Miquel Raynal wrote:
> Back in 2014, the LQI was saved in the skb control buffer (skb->cb, or
> mac_cb(skb)) without any actual reset of this area prior to its use.
> 
> As part of a useful rework of the use of this region, 32edc40ae65c
> ("ieee802154: change _cb handling slightly") introduced mac_cb_init() to
> basically memset the cb field to 0. In particular, this new function got
> called at the beginning of mac802154_parse_frame_start(), right before
> the location where the buffer got actually filled.
> 
> What went through unnoticed however, is the fact that the very first
> helper called by device drivers in the receive path already used this
> area to save the LQI value for later extraction. Resetting the cb field
> "so late" led to systematically zeroing the LQI.
> 
> If we consider the reset of the cb field needed, we can make it as soon
> as we get an skb from a device driver, right before storing the LQI,
> as is the very first time we need to write something there.
> 
> Cc: stable@vger.kernel.org
> Fixes: 32edc40ae65c ("ieee802154: change _cb handling slightly")
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
> 
> Hello,
> 
> I am surprised the LQI was gone for all those years and nobody
> noticed it, so perhaps I did misinterpret slightly the situation, but I
> am pretty sure the cb area reset was erasing the LQI.
> 
> About the backports, they will likely fail on the older kernels because
> of some function/file moves, but I don't think we really care.
> 
> Cheers,
> Miquèl
> 
>   net/mac802154/rx.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> index d1f7b8df41fe..a4733a62911f 100644
> --- a/net/mac802154/rx.c
> +++ b/net/mac802154/rx.c
> @@ -134,7 +134,7 @@ static int
>   ieee802154_parse_frame_start(struct sk_buff *skb, struct ieee802154_hdr *hdr)
>   {
>   	int hlen;
> -	struct ieee802154_mac_cb *cb = mac_cb_init(skb);
> +	struct ieee802154_mac_cb *cb = mac_cb(skb);
>   
>   	skb_reset_mac_header(skb);
>   
> @@ -305,8 +305,9 @@ void
>   ieee802154_rx_irqsafe(struct ieee802154_hw *hw, struct sk_buff *skb, u8 lqi)
>   {
>   	struct ieee802154_local *local = hw_to_local(hw);
> +	struct ieee802154_mac_cb *cb = mac_cb_init(skb);
>   
> -	mac_cb(skb)->lqi = lqi;
> +	cb->lqi = lqi;
>   	skb->pkt_type = IEEE802154_RX_MSG;
>   	skb_queue_tail(&local->skb_queue, skb);
>   	tasklet_schedule(&local->tasklet);


This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
