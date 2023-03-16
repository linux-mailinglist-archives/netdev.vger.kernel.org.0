Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3566BD5F9
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 17:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbjCPQig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 12:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbjCPQiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 12:38:19 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6DBE6FF8;
        Thu, 16 Mar 2023 09:37:27 -0700 (PDT)
Received: from [192.168.2.51] (p5dd0da05.dip0.t-ipconnect.de [93.208.218.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 0B01EC0221;
        Thu, 16 Mar 2023 17:36:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1678984584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gB2n8L9LDG0zUksZGIFHI3PqIyQp1ppiuPgLfRLF62k=;
        b=HNUYHew/ljMpC+MXcRH4tRbuk8NJf2xBGPSjdjSuhhYKepq+eaeHDlInfkV2G56bs9DPdn
        e6VHp/++P5O+4q3ACEmhZyGjLQ/nl6dO8Cwoq/aNGQiNuo1WROel0a9noIdgRNtWUXu/0N
        XNCURoFOxVq7X1zz2j0nOERyIh80pi4ndR/4ylEycSadKhxLgEUjaTDYvUWA+PytvtwDnk
        edZFudcHbwRK55npnBA9MiwdIAiHFhdV4I0RyirGlK77pgr1lUp5gwmHvXzOWgmNYMLdjt
        cc1csE8lOIOl7I7wug/day9d0NQcNCtNQDKQ3MWKf82NmCADD662Mc51vgPJEw==
Message-ID: <99dccb18-d16e-0b5b-586d-59a7649f68c4@datenfreihafen.org>
Date:   Thu, 16 Mar 2023 17:36:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] mac802154: Rename kfree_rcu() to kvfree_rcu_mightsleep()
Content-Language: en-US
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        linux-kernel@vger.kernel.org
Cc:     Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-wpan@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        boqun.feng@gmail.com, paulmck@kernel.org, urezki@gmail.com
References: <20230310013144.970964-1-joel@joelfernandes.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20230310013144.970964-1-joel@joelfernandes.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Joel.

On 10.03.23 02:31, Joel Fernandes (Google) wrote:
> The k[v]free_rcu() macro's single-argument form is deprecated.
> Therefore switch to the new k[v]free_rcu_mightsleep() variant. The goal
> is to avoid accidental use of the single-argument forms, which can
> introduce functionality bugs in atomic contexts and latency bugs in
> non-atomic contexts.
> 
> The callers are holding a mutex so the context allows blocking. Hence
> using the API with a single argument will be fine, but use its new name.
> 
> There is no functionality change with this patch.
> 
> Fixes: 57588c71177f ("mac802154: Handle passive scanning")
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
> Please Ack the patch but we can carry it through the RCU tree as well if
> needed, as it is not a bug per-se and we are not dropping the old API before
> the next release.

The "but we can carry it" part throws me off here. Not sure if you want 
this through the RCU tree (I suppose). In that case see my ack below.

If you want me to take it through my wpan tree instead let me know.

>   net/mac802154/scan.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
> index 9b0933a185eb..5c191bedd72c 100644
> --- a/net/mac802154/scan.c
> +++ b/net/mac802154/scan.c
> @@ -52,7 +52,7 @@ static int mac802154_scan_cleanup_locked(struct ieee802154_local *local,
>   	request = rcu_replace_pointer(local->scan_req, NULL, 1);
>   	if (!request)
>   		return 0;
> -	kfree_rcu(request);
> +	kvfree_rcu_mightsleep(request);
>   
>   	/* Advertize first, while we know the devices cannot be removed */
>   	if (aborted)
> @@ -403,7 +403,7 @@ int mac802154_stop_beacons_locked(struct ieee802154_local *local,
>   	request = rcu_replace_pointer(local->beacon_req, NULL, 1);
>   	if (!request)
>   		return 0;
> -	kfree_rcu(request);
> +	kvfree_rcu_mightsleep(request);
>   
>   	nl802154_beaconing_done(wpan_dev);
>   


Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>

regards
Stefan Schmidt
