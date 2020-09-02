Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF4525A880
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 11:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgIBJUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 05:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgIBJUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 05:20:38 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1A9C061244;
        Wed,  2 Sep 2020 02:20:32 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id m6so4451926wrn.0;
        Wed, 02 Sep 2020 02:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kNovpcBjY3OJoSKngD8WFeH1jtc653D7V7UZ7cA2HmU=;
        b=YDayWfHl0r/ASB6MAPJHiM1u/3l4tD5gGOiy8T7BrGnL5C8732ge7l6sTR0dFPUqyL
         JWZJsSh0tcgGyztUs7tBumDYbMz7of+GA+4PkXtpUx/eQZxwMhAA3cn6AMrhsI0RSeT7
         sL9auK/olzR0jzlgv5u5NIwhlzqeGMEPpWJ90hRMAaij0xmtIx53ifhSPZiOc3HD/vJ6
         XACihecsSvc0yzJuQbGN16wx3ttlaGkUS+0lEyh0a2wqjAKyzXOAtj/WXffu1VVNMLBO
         Vn/1mYJdeJq9qztpLFn/ZYZPGN4aLjeJqvCotW6KjKNq57Qyx97zV+TxJR0mF12mfGId
         Ww6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kNovpcBjY3OJoSKngD8WFeH1jtc653D7V7UZ7cA2HmU=;
        b=koaRC8TNPtJwI+IFD8TmPbdPBkeF9ZZDqj3SFIEeMSFaoVIhdIJ8rl7fef/V6F+N0e
         wZ0393ywwlPj1fh0o5P0w5Q9+1vXP2C5KqSESRzipHpFXTqTtuwbuBNOs0JISNDtT3Ga
         FeqpQVJt7k7DdKvDDTbvvxuOgaKd4DKkj/NeirgEpbaIaFG1q05boYb7OGcRBtyvgDnp
         YgEhEb9x5tpwysMPwJf5IIK23rkDlhYE0HuHXADzatC9HdnbXphT8ryAdnHGoV1a04IT
         SGPJvE6+fFZpp2jn0Mb333WkocmIdSKuump8TxRcj/6KCOgzZUVvsJDAsMy5dF0Wl0pn
         JbBA==
X-Gm-Message-State: AOAM531vDqlWwOD9hyhjn14TG5aMiI3kLOLEiFCP0LcBgu28mkwjhF5/
        pJuPL0WMHCVAUCPwm7RZ7NOCESzjgA8=
X-Google-Smtp-Source: ABdhPJxm04CPMrrJZv8GWOAg0OSDxGCrmu8/aR01yOMfxAXwQfeuq69O/Q7409WzjBHg0wfHZ5H84g==
X-Received: by 2002:adf:82cb:: with SMTP id 69mr6242562wrc.222.1599038431424;
        Wed, 02 Sep 2020 02:20:31 -0700 (PDT)
Received: from [192.168.8.147] ([37.170.201.185])
        by smtp.gmail.com with ESMTPSA id 31sm5163412wrd.26.2020.09.02.02.20.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 02:20:30 -0700 (PDT)
Subject: Re: [PATCH net-next] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@huawei.com
References: <1598921718-79505-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpVtb3Cks-LacZ865=C8r-_8ek1cy=n3SxELYGxvNgkPtw@mail.gmail.com>
 <511bcb5c-b089-ab4e-4424-a83c6e718bfa@huawei.com>
 <CAM_iQpW1c1TOKWLxm4uGvCUzK0mKKeDg1Y+3dGAC04pZXeCXcw@mail.gmail.com>
 <f81b534a-5845-ae7d-b103-434232c0f5ff@huawei.com>
 <1f7208e6-8667-e542-88dd-bd80a6c59fd2@gmail.com>
 <6984825d-1ef7-bf58-75fe-cee1bafe3c1a@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <df8423fb-63ed-604d-df4d-a94be5b47b31@gmail.com>
Date:   Wed, 2 Sep 2020 11:20:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <6984825d-1ef7-bf58-75fe-cee1bafe3c1a@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/2/20 1:14 AM, Yunsheng Lin wrote:
> On 2020/9/2 15:32, Eric Dumazet wrote:
>>
>>
>> On 9/1/20 11:34 PM, Yunsheng Lin wrote:
>>
>>>
>>> I am not familiar with TCQ_F_CAN_BYPASS.
>>> From my understanding, the problem is that there is no order between
>>> qdisc enqueuing and qdisc reset.
>>
>> Thw qdisc_reset() should be done after rcu grace period, when there is guarantee no enqueue is in progress.
>>
>> qdisc_destroy() already has a qdisc_reset() call, I am not sure why qdisc_deactivate() is also calling qdisc_reset()
> 
> That is a good point.
> Do we allow skb left in qdisc when the qdisc is deactivated state?
> And qdisc_destroy() is not always called after qdisc_deactivate() is called.
> If we allow skb left in qdisc when the qdisc is deactivated state, then it is
> huge change of semantics for qdisc_deactivate(), and I am not sure how many
> cases will affected by this change.

All I am saying is that the qdisc_reset() in qdisc_deactivate() seems
at the wrong place.

This certainly can be deferred _after_ the rcu grace period we already have in dev_deactivate_many()

Something like this nicer patch.

 net/sched/sch_generic.c |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)


diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 265a61d011dfaa7ec0f8fb8aaede920784f690c9..0eaa99e4f8de643724c0942ee1a2e9516eed65c0 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1131,24 +1131,10 @@ EXPORT_SYMBOL(dev_activate);
 
 static void qdisc_deactivate(struct Qdisc *qdisc)
 {
-       bool nolock = qdisc->flags & TCQ_F_NOLOCK;
-
        if (qdisc->flags & TCQ_F_BUILTIN)
                return;
-       if (test_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state))
-               return;
-
-       if (nolock)
-               spin_lock_bh(&qdisc->seqlock);
-       spin_lock_bh(qdisc_lock(qdisc));
 
        set_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state);
-
-       qdisc_reset(qdisc);
-
-       spin_unlock_bh(qdisc_lock(qdisc));
-       if (nolock)
-               spin_unlock_bh(&qdisc->seqlock);
 }
 
 static void dev_deactivate_queue(struct net_device *dev,
@@ -1184,6 +1170,9 @@ static bool some_qdisc_is_busy(struct net_device *dev)
                val = (qdisc_is_running(q) ||
                       test_bit(__QDISC_STATE_SCHED, &q->state));
 
+               if (!val)
+                       qdisc_reset(q);
+
                spin_unlock_bh(root_lock);
 
                if (val)
@@ -1213,10 +1202,7 @@ void dev_deactivate_many(struct list_head *head)
                dev_watchdog_down(dev);
        }
 
-       /* Wait for outstanding qdisc-less dev_queue_xmit calls.
-        * This is avoided if all devices are in dismantle phase :
-        * Caller will call synchronize_net() for us
-        */
+       /* Wait for outstanding dev_queue_xmit calls. */
        synchronize_net();
 
        /* Wait for outstanding qdisc_run calls. */


