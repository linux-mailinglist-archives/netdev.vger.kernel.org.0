Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72ECB64D189
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 21:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiLNU4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 15:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiLNU4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 15:56:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDA31CB33
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 12:55:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F1D4B81975
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 20:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73872C433EF;
        Wed, 14 Dec 2022 20:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671051354;
        bh=jpv2VODk7ge8tP4uQHFkoy0T+a+fD/9PIiasprhlLeE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JxHKlqLiGkp503+3fGdGzxYajaeOh+t5XrOvNojuWvCCIOtG8I9P21l72+hnWaCGK
         BBn6rN8WmcbaI4bH/hMTPJkCa5G2EYgMSPLQ5cTczOyGKu4CNQttKiXO43LXmZIXBg
         P3szUXTlJi3ZqabFD+LQYBjrh8p5XvBHItyV/XJsQ4nI6VwuNVpyaBymV+X8x8N3t6
         DeSr8DMKzV1GDOJU5V871+AjyvtRUindVeWxVcTHzOTnUoXJBVwXNjL1gf0lhKJtzq
         aOLoVCH6bTFfCk0E6hnMW1bCDq22iWhS6tqSlR7AlG47vphhUE8Ga0U2oiSNEX0PPZ
         RyIUPQxmhqi0Q==
Date:   Wed, 14 Dec 2022 12:55:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 net] af_unix: Add error handling in af_unix_init().
Message-ID: <20221214125553.4e2a5cc5@kernel.org>
In-Reply-To: <20221214092008.47330-1-kuniyu@amazon.com>
References: <20221214092008.47330-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Dec 2022 18:20:08 +0900 Kuniyuki Iwashima wrote:
>  static int __init af_unix_init(void)
>  {
> -	int i, rc = -1;
> +	int i, rc;

This is just a cleanup, right? Let's skip it, it will conflict.

>  	BUILD_BUG_ON(sizeof(struct unix_skb_parms) > sizeof_field(struct sk_buff, cb));
>  
> @@ -3730,20 +3730,25 @@ static int __init af_unix_init(void)
>  	}
>  
>  	rc = proto_register(&unix_dgram_proto, 1);
> -	if (rc != 0) {
> +	if (rc) {
>  		pr_crit("%s: Cannot create unix_sock SLAB cache!\n", __func__);

Should this message be updated?

>  		goto out;
>  	}
>  
>  	rc = proto_register(&unix_stream_proto, 1);
> -	if (rc != 0) {
> +	if (rc) {
>  		pr_crit("%s: Cannot create unix_sock SLAB cache!\n", __func__);

And this?

> -		proto_unregister(&unix_dgram_proto);
> -		goto out;
> +		goto err_proto_register;
>  	}

