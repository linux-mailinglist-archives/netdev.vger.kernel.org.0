Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6EDB6EDD82
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbjDYIAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbjDYIAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:00:42 -0400
Received: from mail.codelabs.ch (mail.codelabs.ch [IPv6:2a02:168:860f:1::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5905274
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:00:35 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.codelabs.ch (Postfix) with ESMTP id 51DC3220002;
        Tue, 25 Apr 2023 10:00:34 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
        by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ieawm8FfJqww; Tue, 25 Apr 2023 10:00:33 +0200 (CEST)
Received: from [IPV6:2a01:8b81:5400:f500:369:4dc3:5127:cebd] (unknown [IPv6:2a01:8b81:5400:f500:369:4dc3:5127:cebd])
        by mail.codelabs.ch (Postfix) with ESMTPSA id 12443220001;
        Tue, 25 Apr 2023 10:00:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=strongswan.org;
        s=default; t=1682409633;
        bh=BjngSgd4TTM40E/D6PZJYwG08Pj7k0W+L3yUkTvfNGw=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=zGd7GDYf08zsDprR5pgWEIiloZq7SDZliI8Dtn3cvtdgxeyjcL5xLrlPnj12V5wn9
         EXMj7gsgxvklv+KOpgPsl4ymUBDv+RwVLFsFPIr17Mje/E86c78jgcpLCcOZc3Z4u5
         HO7gUfd7CZCslIjb72jvA1oa5R8j1W6n1vxQ/tDZFppMVFDs7UybYaE4TySLcOl3cM
         l5iq3d7MCJ/CDmXPR8UKy38Y+Y2dSqEnnXQMF7qoT0MEKBpe0pErIHZX5Cj7D3fUi2
         otKNJ3+YhkrB8Mq7MEHyjABmASn4CnPwKKUg8WEPYdP51CmNS2ecXONpz/IGv1leUx
         b4IQQiHjv2lRQ==
Message-ID: <8b8dbbc4-f956-8cbf-3700-1da366357a6f@strongswan.org>
Date:   Tue, 25 Apr 2023 10:00:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US, de-CH-frami
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
References: <6dcb6a58-2699-9cde-3e34-57c142dbcf14@strongswan.org>
 <ZEdmdDAwnuslrdvA@gondor.apana.org.au>
From:   Tobias Brunner <tobias@strongswan.org>
Subject: Re: [PATCH ipsec] xfrm: Ensure consistent address families when
 resolving templates
In-Reply-To: <ZEdmdDAwnuslrdvA@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Herbert,

> I'm confused.  By skipping, you're presumably referring to IPcomp.
> 
> For IPcomp, skipping should only occur on inbound, but your patch
> is changing a code path that's only invoked for outbound.  What's
> going on?

At least in theory, there could be applications for optional outbound 
templates, e.g. an optional ESP transform that's only applied to some of 
the traffic matching the policy (based on the selector on the state, 
which is matched against the original flow) followed by a mandatory AH 
transform (there could even be multiple optional transforms, e.g. using 
different algorithms, that are selectively applied to traffic).  No idea 
if anybody actually uses this, but the API allows configuring it.  And 
syzbot showed that some combinations are problematic.

Regards,
Tobias

