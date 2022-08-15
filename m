Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8DA592FE7
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 15:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbiHON3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 09:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbiHON2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 09:28:48 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B701F62F
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 06:28:47 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id w3so9590087edc.2
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 06:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc;
        bh=qAMLSmufRDtzwaGivcSTlS4Hfd7XjPtp5rKgfmvwQ2Y=;
        b=maLMGBrq281dQnY1yHnjv9/Q+gea5WWtT6jYJdHart0Ll+h0VaxFtK1fx73axbwdMh
         cxsO/J9CHwkOXS8RDk43q1WMhjmSnSkYpZ3NOlpCCelpY78cotjlNCqyF6+N9YK3cFyR
         qCHU8C9Dkd2TffiuQkXptb/wZtOXa1DwcLx4A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc;
        bh=qAMLSmufRDtzwaGivcSTlS4Hfd7XjPtp5rKgfmvwQ2Y=;
        b=BxWdTFLjBCO7pi3/x7H7R9uf3HKX7XNP1KHKRHPlFhGe2+HCMxJospCysxeZAhyQKd
         Xj9gqp0M6d6nkG6fS2rJN5Cu6MPfDLRQ1wbv5j3khKtkgOnEqEODGA4Ee+OxLUDrYThM
         iW2y3kZRCZFczGnTICWD2SjqNGTDInOQ0K658FgXW9SBvzxzWzci1N9ByeD1/QIW48Eg
         dr5Wnt/3Sud4ccqJ2sC+aG9/NacUtJCpPgHL37oH/pSV69OgaPHjinzwHe8c5yP2zH5y
         kYzNByO1EP8rtGOmZn79HK7Ib0jzAVU+4oVRuhvjgUfgvbNwGanq80uHJzkg++mAffn5
         BW3g==
X-Gm-Message-State: ACgBeo283o4wewejt3n9tyZCi4ttnh0ECwGgYy7mZNJxriD/We4on0Au
        vRO3OHw5Qiq6eP3zYTdePxPjMg==
X-Google-Smtp-Source: AA6agR7LeSLcVbwXq3/KMBB/4NolyBoPQiSArvGA4Equk2AwkQ4jZPQeeX3aOlCbyYy9Ly4w55cPVQ==
X-Received: by 2002:a05:6402:194d:b0:43d:8001:984b with SMTP id f13-20020a056402194d00b0043d8001984bmr14485132edz.327.1660570126092;
        Mon, 15 Aug 2022 06:28:46 -0700 (PDT)
Received: from cloudflare.com (79.184.200.53.ipv4.supernova.orange.pl. [79.184.200.53])
        by smtp.gmail.com with ESMTPSA id t7-20020a170906948700b0072b32de7794sm4072394ejx.70.2022.08.15.06.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 06:28:45 -0700 (PDT)
References: <20220815130107.149345-1-jakub@cloudflare.com>
 <20220815132137.GB5059@katalix.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Haowei Yan <g1042620637@gmail.com>
Subject: Re: [PATCH net v2] l2tp: Serialize access to sk_user_data with sock
 lock
Date:   Mon, 15 Aug 2022 15:26:51 +0200
In-reply-to: <20220815132137.GB5059@katalix.com>
Message-ID: <875yittz3n.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 02:21 PM +01, Tom Parkin wrote:
> [[PGP Signed Part:Undecided]]
> On  Mon, Aug 15, 2022 at 15:01:07 +0200, Jakub Sitnicki wrote:
>> sk->sk_user_data has multiple users, which are not compatible with each
>> other. To synchronize the users, any check-if-unused-and-set access to the
>> pointer has to happen with sock lock held.
>> 
>> l2tp currently fails to grab the lock when modifying the underlying tunnel
>> socket. Fix it by adding appropriate locking.
>> 
>> We don't to grab the lock when l2tp clears sk_user_data, because it happens
>> only in sk->sk_destruct, when the sock is going away.
>> 
>> v2:
>> - update Fixes to point to origin of the bug
>> - use real names in Reported/Tested-by tags
>> 
>> Fixes: 3557baabf280 ("[L2TP]: PPP over L2TP driver core")
>
> This still seems wrong to me.
>
> In 3557baabf280 pppol2tp_connect checks/sets sk_user_data with
> lock_sock held.

I think you are referring to the PPP-over-L2TP socket, not the UDP
socket. In pppol2tp_prepare_tunnel_socket() @ 3557baabf280 we're not
holding the sock lock over the UDP socket, AFAICT.

>
>> Reported-by: Haowei Yan <g1042620637@gmail.com>
>> Tested-by: Haowei Yan <g1042620637@gmail.com>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>> Cc: Tom Parkin <tparkin@katalix.com>
>> 
>>  net/l2tp/l2tp_core.c | 17 +++++++++++------
>>  1 file changed, 11 insertions(+), 6 deletions(-)
>> 
>> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
>> index 7499c51b1850..9f5f86bfc395 100644
>> --- a/net/l2tp/l2tp_core.c
>> +++ b/net/l2tp/l2tp_core.c
>> @@ -1469,16 +1469,18 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
>>  		sock = sockfd_lookup(tunnel->fd, &ret);
>>  		if (!sock)
>>  			goto err;
>> -
>> -		ret = l2tp_validate_socket(sock->sk, net, tunnel->encap);
>> -		if (ret < 0)
>> -			goto err_sock;
>>  	}
>>  
>> +	sk = sock->sk;
>> +	lock_sock(sk);
>> +
>> +	ret = l2tp_validate_socket(sk, net, tunnel->encap);
>> +	if (ret < 0)
>> +		goto err_sock;
>> +
>>  	tunnel->l2tp_net = net;
>>  	pn = l2tp_pernet(net);
>>  
>> -	sk = sock->sk;
>>  	sock_hold(sk);
>>  	tunnel->sock = sk;
>>  
>> @@ -1504,7 +1506,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
>>  
>>  		setup_udp_tunnel_sock(net, sock, &udp_cfg);
>>  	} else {
>> -		sk->sk_user_data = tunnel;
>> +		rcu_assign_sk_user_data(sk, tunnel);
>>  	}
>>  
>>  	tunnel->old_sk_destruct = sk->sk_destruct;
>> @@ -1518,6 +1520,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
>>  	if (tunnel->fd >= 0)
>>  		sockfd_put(sock);
>>  
>> +	release_sock(sk);
>>  	return 0;
>>  
>>  err_sock:
>> @@ -1525,6 +1528,8 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
>>  		sock_release(sock);
>>  	else
>>  		sockfd_put(sock);
>> +
>> +	release_sock(sk);
>>  err:
>>  	return ret;
>>  }
>> -- 
>> 2.35.3
>> 

