Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA2E693E70
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 07:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjBMGme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 01:42:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjBMGmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 01:42:33 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E49EB7B;
        Sun, 12 Feb 2023 22:42:32 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id w20-20020a17090a8a1400b00233d7314c1cso3303966pjn.5;
        Sun, 12 Feb 2023 22:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hVUvPkXs4Ywuf2kLv5h95wUJZtWIOtfLbqg816I4d4o=;
        b=kSbNWvvpPT0n+ZVoQC2EvmGR9rl7eWAHxPPuFYX6AMoWNMsT4Nm5v5618sD2wZkDwQ
         BUkqGRAebS/32cWOJkWI1ZeTXd0QpDzzlVknJ5jaXX8vVQS/+GlmqiH6jUp2vSBXTNEl
         ze9lOMpoYfgs8sZetTL05zAd2KLBDJnnRybLZZFreEZ0CS14MhYCMXequyMitNLijyvw
         /I7UI4VMjOlpbTEeqrlYpplON8GGJ+1uruJQnCcsRC/FA88tE3u/L+l+dRfP9YCrdfTj
         9MhT6Ou0zDuuvRlewXy0uUm59k6nCcvXGSGXOPHr1ipgu2QEXbWfbvH2E4kkYrpRJjv2
         vz1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hVUvPkXs4Ywuf2kLv5h95wUJZtWIOtfLbqg816I4d4o=;
        b=YJrbRK1e8qP4nD+SECywn+lqwmGeQvpZPqbFpubJSdZEeToJb2n41SzxTe0WTVN3cE
         mbUDX7X1jmeopNm1d5hVHeM8vHBUW81yknm8FvHYz5VzZqJIsqHUucQve/JNLsI7P8z7
         y2vFV57nBmpBDvHefOvD8LlbbU510dafww7R2Ud3Df7CPNgZj75xkP6HenORn0ODI9Yx
         /wb4UtI2NMT36zyS59FatMcEXzgODoNCTcGkxJ/Y98nnci5SjUdJQA0Tobd4ZmLjxkx4
         OZ16me8/1Up24QhJXWmWg/FjFzH5HQd3qkGbG/g/uUQLGwHz9Gk7Ed+VS2EeqoFPX3B0
         ZQMQ==
X-Gm-Message-State: AO0yUKXrQl+vKcaNBnr4UJtNIYDNQMMJxItFx7UzLQDklv15DYMUUP8K
        9ZO61fYD3j8uwCotgZqLx13+xrDKiVCRk0egxyQ=
X-Google-Smtp-Source: AK7set9WTQk/JnFkaZO3GOqOxEPlG1zHwghIwus3gUWcV6LQ+Kzf2dZuRhb6NfK+0q6BjyqOTXJNNA==
X-Received: by 2002:a17:902:f685:b0:199:2ee:6248 with SMTP id l5-20020a170902f68500b0019902ee6248mr24946567plg.0.1676270552117;
        Sun, 12 Feb 2023 22:42:32 -0800 (PST)
Received: from [192.168.50.247] ([129.227.150.140])
        by smtp.gmail.com with ESMTPSA id j3-20020a170902c3c300b00199418629d5sm3064548plj.13.2023.02.12.22.42.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Feb 2023 22:42:31 -0800 (PST)
Message-ID: <4c1e4e28-1dea-9750-348d-cb36bd5f5286@gmail.com>
Date:   Mon, 13 Feb 2023 14:42:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] net: netfilter: fix possible refcount leak in
 ctnetlink_create_conntrack()
To:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230210071730.21525-1-hbh25y@gmail.com>
 <20230210103250.GC17303@breakpoint.cc> <Y+ZrvJZ2lJPhYFtq@salvia>
 <20230212125320.GA780@breakpoint.cc>
Content-Language: en-US
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <20230212125320.GA780@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/2/2023 20:53, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>> One way would be to return 0 in that case (in
>>> nf_conntrack_hash_check_insert()).  What do you think?
>>
>> This is misleading to the user that adds an entry via ctnetlink?
>>
>> ETIMEDOUT also looks a bit confusing to report to userspace.
>> Rewinding: if the intention is to deal with stale conntrack extension,
>> for example, helper module has been removed while this entry was
>> added. Then, probably call EAGAIN so nfnetlink has a chance to retry
>> transparently?
> 
> Seems we first need to add a "bool *inserted" so we know when the ct
> entry went public.
>
I don't think so.

nf_conntrack_hash_check_insert(struct nf_conn *ct)
{
...
	/* The caller holds a reference to this object */
	refcount_set(&ct->ct_general.use, 2);			// [1]
	__nf_conntrack_hash_insert(ct, hash, reply_hash);
	nf_conntrack_double_unlock(hash, reply_hash);
	NF_CT_STAT_INC(net, insert);
	local_bh_enable();

	if (!nf_ct_ext_valid_post(ct->ext)) {
		nf_ct_kill(ct);					// [2]
		NF_CT_STAT_INC_ATOMIC(net, drop);
		return -ETIMEDOUT;
	}
...
}

We set ct->ct_general.use to 2 in nf_conntrack_hash_check_insert()([1]). 
nf_ct_kill willn't put the last refcount. So ct->master will not be 
freed in this way. But this means the situation not only causes 
ct->master's refcount leak but also releases ct whose refcount is still 
1 in nf_conntrack_free() (in ctnetlink_create_conntrack() err1).

I think it may be a good idea to set ct->ct_general.use to 0 after 
nf_ct_kill() ([2]) to put the caller's reference. What do you think?

Thanks,
Hangyu

> I'll also have a look at switching to a refcount based model for
> all extensions that reference external objects, this would avoid
> the entire problem, but thats likely more intrusive.
