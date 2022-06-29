Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD63555F663
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 08:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbiF2GJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 02:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbiF2GJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 02:09:52 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDAF101CE;
        Tue, 28 Jun 2022 23:09:49 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 145so228399pga.12;
        Tue, 28 Jun 2022 23:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YUWD4x3XecNA5fBamz2NgVzPrVjnQmLk6tCdDhuYr7o=;
        b=aalr5o8RhKWo57VBcPsaOnDLgPxE5dMrrgsQwSwyDOHzy9u+UY96YudnuoxEbfL6CK
         8qZKhgBzpHG0PRAZQCywHYSQ5b18BOc69jt48akHjCej+gP7jJXyqrDeQ+ccL1lpDSCl
         rtyaQ6YJ4PlOuAteVnvi5MjhOP9GLtpGEmvvHbiIvUwvx44EYBGBmuGIhcv0wrPx/+G1
         lXqWZHfmeRCD8Pm3IlkORD4+4tkVnRRXpKMwSTHtQBqraO7iUvufSE0xX78+Tsrb2RN6
         leAV2Sf6jHZMRJMHecuYQZbt3Y69lFysquyIw4H8RgpmFvWZswJ6pGzx5boOjnSS7+TA
         X7LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YUWD4x3XecNA5fBamz2NgVzPrVjnQmLk6tCdDhuYr7o=;
        b=OTN0Yw8gvUFYx6miDo9sepbaQISL4vzvE7oEvMP1Iqw/3xOSpDV3q0+bI5IjU+Q3tu
         ovLeC7nnrsRyu4Yxqiml17w2Db8bxxWJkuho4/Vt54IJLoV5GTG5c+2v8w6om4e902Yq
         QZ1Wxhhfeh1xnPPSOH9LtOmAF2Qof7YUXqxbvc14sCZPB3816DjktoPJiDKfBC4ul6j8
         QI+NuAyQWbele1ygSdrMI+2reAXNrWq8vUECHFLOuQ/hrHsk3/TmzCFjUFMtaeVHJcJq
         YdMCtbpi9aoA6TiSIJXHxX9xRjCIs/EX424wIaeBUqDOLor3GyXtes9Slnyx4PUDbQGQ
         AE5g==
X-Gm-Message-State: AJIora/yLGBaVUJWCxUDvFRpnJ3prq1cudAprP49HadYQdGB2UA/zBv1
        4ef0/VxV9z4oNrfE6eXGbWI=
X-Google-Smtp-Source: AGRyM1uZbTeiC93sfFoaaXK/U3z95/bT8fcVTnbSXPe3w+Bk9LMMQeQy4eFwWdYV7yKYvwVN3fDpfQ==
X-Received: by 2002:a63:8141:0:b0:40d:28fc:440f with SMTP id t62-20020a638141000000b0040d28fc440fmr1642137pgd.12.1656482989410;
        Tue, 28 Jun 2022 23:09:49 -0700 (PDT)
Received: from [192.168.50.247] ([103.84.139.165])
        by smtp.gmail.com with ESMTPSA id x9-20020a634849000000b0040d75537824sm10357972pgk.86.2022.06.28.23.09.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 23:09:48 -0700 (PDT)
Message-ID: <aee933e9-e07e-49df-94bf-a0ddea5da59e@gmail.com>
Date:   Wed, 29 Jun 2022 14:09:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] net: tipc: fix possible refcount leak in tipc_sk_create()
Content-Language: en-US
To:     Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "tgraf@suug.ch" <tgraf@suug.ch>
References: <20220629022402.10841-1-hbh25y@gmail.com>
 <DB9PR05MB9078334A4067BF8F84DF60D488BB9@DB9PR05MB9078.eurprd05.prod.outlook.com>
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <DB9PR05MB9078334A4067BF8F84DF60D488BB9@DB9PR05MB9078.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/6/29 11:49, Tung Quang Nguyen wrote:
>> sk need to be free when tipc_sk_insert fails. While tipc_sk_insert is hard
>> to fail, it's better to fix this.
> Incorrect English grammar. You should use a simple comment in changelog, for example: "Free sk in case tipc_sk_insert() fails."

Thanks a lot. I will fix this then send a v2.

Hangyu.

>>
>> Fixes: 07f6c4bc048a ("tipc: convert tipc reference table to use generic rhashtable")
>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
>> ---
>>   net/tipc/socket.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/net/tipc/socket.c b/net/tipc/socket.c
>> index 17f8c523e33b..43509c7e90fc 100644
>> --- a/net/tipc/socket.c
>> +++ b/net/tipc/socket.c
>> @@ -502,6 +502,7 @@ static int tipc_sk_create(struct net *net, struct socket *sock,
>>   	sock_init_data(sock, sk);
>>   	tipc_set_sk_state(sk, TIPC_OPEN);
>>   	if (tipc_sk_insert(tsk)) {
>> +		sk_free(sk);
>>   		pr_warn("Socket create failed; port number exhausted\n");
>>   		return -EINVAL;
>>   	}
>> --
>> 2.25.1
> 
