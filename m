Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C22C6126392
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 14:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfLSNcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 08:32:47 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:46572 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfLSNcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 08:32:47 -0500
Received: by mail-il1-f194.google.com with SMTP id t17so4832481ilm.13
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 05:32:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d6vE8/BisI3cyOUImMgDxi1RDAesuFjWD13xjjA8td4=;
        b=kWMiWCFnKbnntgNtM57WQF5ibc1lgWe15hXP1Nlu9YsKwgsWPXyGuImin/kKTqI5dy
         UaeTKrSG6vabAji4NjghpzX8f4Pimdq1nminTHmHTfBNtrt4OfnALie+8YCg5RDG6riZ
         ydUCub4VwAhUeNtP9Tq63ZP6WX29/cr/P/0H2Ve2cveIXdeEJKG2kiYFTG02151QPYQ6
         ErAjtjvJC5zfo1fVwapr/ul24mP2JZUvmQEuzn/IYYsszkGd9thO7mTZ7KG5x0psxCI1
         fJJ+9WAyS/1nb/dO96Q22nC6U8ZR9Ns71OYlfYnDVLFvfQRVxk9kviOX7rzs42Yvjg5i
         uTNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d6vE8/BisI3cyOUImMgDxi1RDAesuFjWD13xjjA8td4=;
        b=SuAd+3e1HiCpjlfg8WLDp5Nvyq1832IShcE9X6JzQxhRTXI08ccLmHIywXTHj+55uC
         uJV5H9Rr9wROQujdgpbKt/WdMDzc+SZV1rWF/j3/zHs4HVdDkiM0Ml5Ip4aEiLYZeNdG
         SLXSb+//hdXSg2ZIg2yGxXmz1wZT+RWitktD78pVXd7f1xaMwZ2T0qbkEF41ItaZjIrz
         3fuVo4CuohPOH1Nr4uNxC4rpxJBv5F0du3Hs/WzHwEtuC2OtSpeXdO6wISn3rYSFIvvt
         EUWMKz5eu/zRNaNwHBVcQGTBlUvJ0kbT1MFkGRY2eMJnOCGRBaa4GlJKdhNDs7VGVFSp
         z6Bw==
X-Gm-Message-State: APjAAAXylEAgM/vh1EMW/llFK6CC+xnvGSlx+ID3eI7aPO1UbNrPD23f
        89VzvgRLlGbr1r0Popj1Kae+ceUYPzc=
X-Google-Smtp-Source: APXvYqw6fHMRUbhkwwoISARwemeFbzzz0NDUulMSeHunXQklXXL1+VDe+jTKeSZZ69Qp/ygU9TyQSg==
X-Received: by 2002:a92:58ca:: with SMTP id z71mr6876296ilf.5.1576762366900;
        Thu, 19 Dec 2019 05:32:46 -0800 (PST)
Received: from [192.168.0.101] (198-84-204-252.cpe.teksavvy.com. [198.84.204.252])
        by smtp.googlemail.com with ESMTPSA id r2sm2348396ila.42.2019.12.19.05.32.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2019 05:32:45 -0800 (PST)
Subject: Re: [PATCH net 1/2] net/sched: cls_u32: fix refcount leak in the
 error path of u32_change()
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     Davide Caratti <dcaratti@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Vlad Buslov <vladbu@mellanox.com>, Roman Mashak <mrv@mojatatu.com>
References: <cover.1576623250.git.dcaratti@redhat.com>
 <ae83c6dc89f8642166dc32debc6ea7444eb3671d.1576623250.git.dcaratti@redhat.com>
 <bafb52ff-1ced-91a4-05d0-07d3fdc4f3e4@mojatatu.com>
Message-ID: <5b4239e5-6533-9f23-7a38-0ee4f6acbfe9@mojatatu.com>
Date:   Thu, 19 Dec 2019 08:32:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <bafb52ff-1ced-91a4-05d0-07d3fdc4f3e4@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Davide,

I ran your test on my laptop (4.19) and nothing dangled.
Looking at that area of the code difference 4.19 vs current net-next
there was a destroy() in there that migrated into the inner guts of
tcf_chain_tp_delete_empty() Vlad? My gut feeling is restoring the old
logic like this would work at least for u32:

------------
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 6a0eacafdb19..34a1d4e7e6e3 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2135,8 +2135,10 @@ static int tc_new_tfilter(struct sk_buff *skb, 
struct nlmsghdr *n,
         }

  errout:
-       if (err && tp_created)
+       if (err && tp_created) {
+               tcf_proto_destroy(tp, rtnl_held, true, NULL);
                 tcf_chain_tp_delete_empty(chain, tp, rtnl_held, NULL);
+       }
  errout_tp:
         if (chain) {
                 if (tp && !IS_ERR(tp))
-----

Maybe even better tcf_proto_put(tp, rtnl_held, NULL) directly instead
and no need for tcf_chain_tp_delete_empty().

Of course above not even compile tested and may have consequences
for other classifiers (flower would be a good test) and concurency
intentions. Thoughts?

cheers,
jamal

On 2019-12-18 9:23 a.m., Jamal Hadi Salim wrote:
> 
> On 2019-12-17 6:00 p.m., Davide Caratti wrote:
>> when users replace cls_u32 filters with new ones having wrong parameters,
>> so that u32_change() fails to validate them, the kernel doesn't roll-back
>> correctly, and leaves semi-configured rules.
>>
>> Fix this in u32_walk(), avoiding a call to the walker function on filters
>> that don't have a match rule connected. The side effect is, these "empty"
>> filters are not even dumped when present; but that shouldn't be a problem
>> as long as we are restoring the original behaviour, where semi-configured
>> filters were not even added in the error path of u32_change().
>>
>> Fixes: 6676d5e416ee ("net: sched: set dedicated tcf_walker flag when 
>> tp is empty")
>> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> 
> Hi Davide,
> 
> Great catch (and good test case addition),
> but I am not sure about the fix.
> 
> Unless I am  misunderstanding the flow is:
> You enter bad rules, validation fails, partial state had already been
> created (in this case root hts) before validation failure, you then
> leave the partial state in the kernel but when someone dumps you hide
> these bad tables?
> 
> It sounds like the root cause is there is a missing destroy()
> invocation somewhere during the create/validation failure - which is
> what needs fixing... Those dangling tables should not have been
> inserted; maybe somewhere along the code path for tc_new_tfilter().
> Note "replace" is essentially "create if it doesnt
> exist" semantic therefore NLM_F_CREATE will be set.
> 
> Since this is a core cls issue - I would check all other classifiers
> with similar aggrevation - make some attribute fail in the middle or
> end.
> Very likely only u32 is the victim.
> 
> cheers,
> jamal
> 

