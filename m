Return-Path: <netdev+bounces-6751-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DE8A717CC6
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 12:05:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B94FB1C20D64
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 10:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82ABD13AC1;
	Wed, 31 May 2023 10:05:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BB8D2F6
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 10:05:38 +0000 (UTC)
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF829F;
	Wed, 31 May 2023 03:05:36 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id d9443c01a7336-1b02750ca0dso6277055ad.0;
        Wed, 31 May 2023 03:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685527536; x=1688119536;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HeKTOYgsOHmbs8G4uF5AubnU8n6wTCs2dizwLG2Gqpc=;
        b=WQQ5ksPHTMS2XAS93kRWeN7Mmemr0cTNE6GQ4QcJ8s4G9RK3V6UPpl4VtAabLWMvUi
         5uqy3DltMJr0UYN+AUZHX0/2m465WdkWc/FMykMWuRHxevSWV38g8mwMDxEMXrz2ukxB
         dGJFKtEUItBKBP9i7L2MWIqm6TE/T2hXs4CobpkKe4Fl1kYH4SM4d0KM8GqBvOeACOPP
         SCibaW34oc3WJiBQzArUoshAPTu8OzJ6LLmV3Efgi8CnZxvN6z+5i1hji78ucyFHhdTv
         VI5DC+QdcQNzp7CNtqpWfEXD4Pl1KstC18FsD68t0lTV2sE/NV5L+4nsVSSbv5QbD3bd
         q7oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685527536; x=1688119536;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HeKTOYgsOHmbs8G4uF5AubnU8n6wTCs2dizwLG2Gqpc=;
        b=EddL4OC2D4IfV4N9FAViGSFQeDWyBOhqakSEhL8aFGByfVUoBj7G/e0NqNOJOBqkBh
         5kgYh26HdkGGGmvBzMzMFrhN+wNy91wIPzn53yqfFeYor9/tT1w2IoihduJMU8cmQNCU
         evAC7O1u27gFGQzNHK148E7mFhtaY1ILDqjcX8v5y4fmcIt+wLgGaRUijJXm19l/rURz
         ykWKMoM8soMl1YtBS8wwspOjhmx6JF+Xv+ypSjZRhBGMELx7nG3YsHeM21YXwO9zOe3l
         uuN5nacA1I+YF5fRgD9p7LrTELZKt9vIQHwtjV43OyWnP9qJSY9nHi6HGxDK9XJUH4jQ
         y0gg==
X-Gm-Message-State: AC+VfDzjWjQlmSQiyErpTg/fqlZ22rgjoo4AHb2CASpQpMAtLNltoxoh
	kf7NBBmanKD4lF4OYHT6yC8=
X-Google-Smtp-Source: ACHHUZ7lfarClMDji6Z2FjENK1gvREcg+iERVgXDzG/A4xsurL7EgPnXGNSw2nThy8ItrF8pfyqABw==
X-Received: by 2002:a17:902:e54e:b0:1a9:6467:aa8d with SMTP id n14-20020a170902e54e00b001a96467aa8dmr2214163plf.1.1685527536203;
        Wed, 31 May 2023 03:05:36 -0700 (PDT)
Received: from [127.0.0.1] ([2404:c140:1f03::caf2])
        by smtp.gmail.com with ESMTPSA id o7-20020a170902bcc700b001aaed55aff3sm940994pls.137.2023.05.31.03.05.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 03:05:35 -0700 (PDT)
Message-ID: <ebdc1731-3647-8b58-c66c-db5bb09f5bfa@gmail.com>
Date: Wed, 31 May 2023 18:05:29 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] net: sched: fix possible OOB write in fl_set_geneve_opt()
To: Simon Horman <simon.horman@corigine.com>
Cc: jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, simon.horman@netronome.com,
 pieter.jansen-van-vuuren@amd.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20230529043615.4761-1-hbh25y@gmail.com>
 <ZHXf29es/yh3r6jq@corigine.com>
 <e9925aef-fefc-24b9-dea3-bd3bcca01b35@gmail.com>
 <ZHb/nPuTMja3giSP@corigine.com>
Content-Language: en-US
From: Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <ZHb/nPuTMja3giSP@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 31/5/2023 16:04, Simon Horman wrote:
> On Wed, May 31, 2023 at 01:38:49PM +0800, Hangyu Hua wrote:
>> On 30/5/2023 19:36, Simon Horman wrote:
>>> [Updated Pieter's email address, dropped old email address of mine]
>>>
>>> On Mon, May 29, 2023 at 12:36:15PM +0800, Hangyu Hua wrote:
>>>> If we send two TCA_FLOWER_KEY_ENC_OPTS_GENEVE packets and their total
>>>> size is 252 bytes(key->enc_opts.len = 252) then
>>>> key->enc_opts.len = opt->length = data_len / 4 = 0 when the third
>>>> TCA_FLOWER_KEY_ENC_OPTS_GENEVE packet enters fl_set_geneve_opt. This
>>>> bypasses the next bounds check and results in an out-of-bounds.
>>>>
>>>> Fixes: 0a6e77784f49 ("net/sched: allow flower to match tunnel options")
>>>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
>>>
>>> Hi Hangyu Hua,
>>>
>>> Thanks. I think I see the problem too.
>>> But I do wonder, is this more general than Geneve options?
>>> That is, can this occur with any sequence of options, that
>>> consume space in enc_opts (configured in fl_set_key()) that
>>> in total are more than 256 bytes?
>>>
>>
>> I think you are right. It is a good idea to add check in fl_set_vxlan_opt
>> and fl_set_erspan_opt and fl_set_gtp_opt too.
>> But they should be submitted as other patches. fl_set_geneve_opt has already
>> check this with the following code:
>>
>> static int fl_set_geneve_opt(const struct nlattr *nla, struct fl_flow_key
>> *key,
>> 			     int depth, int option_len,
>> 			     struct netlink_ext_ack *extack)
>> {
>> ...
>> 		if (new_len > FLOW_DIS_TUN_OPTS_MAX) {
>> 			NL_SET_ERR_MSG(extack, "Tunnel options exceeds max size");
>> 			return -ERANGE;
>> 		}
>> ...
>> }
>>
>> This bug will only be triggered under this special
>> condition(key->enc_opts.len = 252). So I think it will be better understood
>> by submitting this patch independently.
> 
> A considered approach sounds good to me.
> 
> I do wonder, could the bounds checks be centralised in the caller?
> Maybe not if it doesn't know the length that will be consumed.
> 

This may make code more complex. I am not sure if it is necessary to do 
this.

>> By the way, I think memset's third param should be option_len in
>> fl_set_vxlan_opt and fl_set_erspan_opt. Do I need to submit another patch to
>> fix all these issues?
> 
> I think that in general one fix per patch is best.

I see. I will try to handle these issues.

> 
> Some minor nits.
> 
> 1. As this is a fix for networking code it is probably targeted
>     at the net, as opposed to net-next, tree. This should be indicated
>     in the patch subject.
> 
> 	 Subject: [PATCH net v2] ...
> 
> 2. I think the usual patch prefix for this file, of late,
>     has been 'net/sched: flower: '
> 
> 	 Subject: [PATCH net v2]  net/sched: flower: ...
> 

Get it. I will send a v2 later.

