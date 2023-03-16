Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18896BD614
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 17:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbjCPQm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 12:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjCPQm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 12:42:57 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F445AE110;
        Thu, 16 Mar 2023 09:42:24 -0700 (PDT)
Received: from [192.168.2.51] (p5dd0da05.dip0.t-ipconnect.de [93.208.218.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id F18ECC03A4;
        Thu, 16 Mar 2023 17:41:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1678984887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dIoqtcJzu1esglgGJt69EUsY55OJna6FV1+aLxNNeak=;
        b=Xbu11MtOA2RdwHy+5MUfW9qGDt+SjZDSB33nJ6y+zrFImNjUePKW2bWShVABm1CCT0Z39U
        9fJVPfyMO0Fl9XlyC9iqyhlOeQNdPbY/pQlfriiwNJii/hMTEKmn0SF/75dCHSCf+gXuSq
        LARKRPNMjQ18KUDfsUrvHY9EFpjbvq1ixMTxQE50ouvQg5BIFuGeY8iwxPsMhtve67ZqGo
        Lt/ErkpkLWFJet3kfdvhbO6m34Qw0ASkH1hltKR7lPSraydiu+c/+8KU0zZzOxzAXW0O0G
        cXrAMzT0uYWCKZcwhkHL0r3wmeNzs1T6uF8G8J1W77JQM57F1nUZN1KE6QQATQ==
Message-ID: <996f0981-98f4-5077-12b6-bb093bbd28be@datenfreihafen.org>
Date:   Thu, 16 Mar 2023 17:41:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 12/14] mac802154: Rename kfree_rcu() to
 kvfree_rcu_mightsleep()
Content-Language: en-US
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Alexander Aring <alex.aring@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Girault <david.girault@qorvo.com>
Cc:     "Paul E . McKenney" <paulmck@kernel.org>,
        Alexander Aring <aahringo@redhat.com>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230315181902.4177819-1-joel@joelfernandes.org>
 <20230315181902.4177819-12-joel@joelfernandes.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20230315181902.4177819-12-joel@joelfernandes.org>
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

Hello.

On 15.03.23 19:18, Joel Fernandes (Google) wrote:
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
> Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
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

I just saw that there is a v2 of this patch. My ACK still stands as for v1.


Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>

regards
Stefan Schmidt
