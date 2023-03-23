Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED30A6C6462
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 11:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjCWKEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 06:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjCWKEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 06:04:13 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFBB1B9;
        Thu, 23 Mar 2023 03:04:11 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id u10so96583plz.7;
        Thu, 23 Mar 2023 03:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679565851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ltpiSqcH+iENGFwSc+EzcVWVTeVgKDyd1o+HaYuNOcU=;
        b=FIioC87Qgiv41rTGncN6kO8GPo+zjlTucRfuJRVKL+d58lS8UPqiQ7sBQgx85CXvX/
         xDpTrJ53x8grD8W5hyIaOcGxhjybW21yHhNdkvRxdXvvtGREri8VqmL5BAlYA+NPnaXJ
         KeIxrd+bx0P5r43rNLosr8wP/8fbSyWLKgAD1r2QE1Hhw28duNWEb77VMeux6ZN0yp9s
         0hjQbL5WO0/vHhw5VFm71JU7pR6XbPNo/vcyg8JEfIYteiR68oF+v/lNZWT6qQl7Hqg4
         rmqk40vzLpb7RbSL2PdOixfn6jDBnG3lqP0jPsSLzWeOH5m+4CPQUo5nhlYXZh8U9Amr
         Ksrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679565851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ltpiSqcH+iENGFwSc+EzcVWVTeVgKDyd1o+HaYuNOcU=;
        b=WceDks7056NqRpLNHLD2O1WAmequOJEnOHbGjlAZJSnEL2YIdbKej3cVl7LziSucKy
         V0Nj408gszWwA6500ZLkO1MJtUNkRCS8GsA4jN7uH0WnY5RGs0hcsChv7iGooLLK8GRn
         I7VddpVK77w3BANUrPNsDV8e0mUcL2kqZD0PKE3WT94pBDb5pcBRC6KHC6yxzNQUC4WJ
         AbxTfn+5G4kaekTSCMoZDWSIEad7aRNL8I2TFIn6UNBt77Foh22MgT7Je07PgF7SLUkZ
         WdPCHRyQYV/jMoJNW8jMlUpGdlTbZt7QgV6G8HLqBZPsVgYBHr6vw9vulZM5W//UyCn+
         l/0Q==
X-Gm-Message-State: AO0yUKXYyz2H9dc/PGLcF/ffTrEZt3SovTV+9zeoCKjblKjD2UStaLsM
        ypleJdD/uz6kmisf3pPjM6g=
X-Google-Smtp-Source: AK7set/Mj1KVx0fqxVGFpU3U+yREvqKy9bhqip47WBXgC2C1U+mkNZenaUb7bC6dl12PyGp6QC9udQ==
X-Received: by 2002:a17:90b:1bcc:b0:23f:b35a:534e with SMTP id oa12-20020a17090b1bcc00b0023fb35a534emr7136143pjb.29.1679565851047;
        Thu, 23 Mar 2023 03:04:11 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id m2-20020a17090a7f8200b0023efa52d2b6sm930234pjl.34.2023.03.23.03.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 03:04:10 -0700 (PDT)
From:   xu xin <xu.xin.sc@gmail.com>
X-Google-Original-From: xu xin <xu.xin16@zte.com.cn>
To:     linyunsheng@huawei.com, kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, jiang.xuexin@zte.com.cn,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        xu.xin16@zte.com.cn, yang.yang29@zte.com.cn,
        zhang.yunkai@zte.com.cn
Subject: Re: [PATCH] rps: process the skb directly if rps cpu not changed
Date:   Thu, 23 Mar 2023 10:04:06 +0000
Message-Id: <20230323100406.36858-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <ef94a525-c5f3-fa9f-d66d-d9dc62533e78@huawei.com>
References: <ef94a525-c5f3-fa9f-d66d-d9dc62533e78@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>On 2023/3/22 15:24, xu xin wrote:
>> [So sorry, I made a mistake in the reply title]
>> 
>> On 2023/3/21 20:12, yang.yang29@zte.com.cn wrote:
>>>> From: xu xin <xu.xin16@zte.com.cn>
>>>>
>>>> In the RPS procedure of NAPI receiving, regardless of whether the
>>>> rps-calculated CPU of the skb equals to the currently processing CPU, RPS
>>>> will always use enqueue_to_backlog to enqueue the skb to per-cpu backlog,
>>>> which will trigger a new NET_RX softirq.
>>>
>>> Does bypassing the backlog cause out of order problem for packet handling?
>>> It seems currently the RPS/RFS will ensure order delivery,such as:
>>> https://elixir.bootlin.com/linux/v6.3-rc3/source/net/core/dev.c#L4485
>>>
>>> Also, this is an optimization, it should target the net-next branch:
>>> [PATCH net-next] rps: process the skb directly if rps cpu not changed
>>>
>> 
>> Well, I thought the patch would't break the effort RFS tried to avoid "Out of
>> Order" packets. But thanks for your reminder, I rethink it again, bypassing the
>> backlog from "netif_receive_skb_list" will mislead RFS's judging if all
>> previous packets for the flow have been dequeued, where RFS thought all packets
>> have been dealed with, but actually they are still in skb lists. Fortunately,
>> bypassing the backlog from "netif_receive_skb" for a single skb is okay and won't
>> cause OOO packets because every skb is processed serially by RPS and sent to the
>> protocol stack as soon as possible.
>
>Suppose a lot of skbs have been queued to the backlog waiting to
>processed and passed to the stack when current_cpu is not the same
>as the target cpu,

Well.  I'm afraid that what we mean by current_cpu may be different. The
"current_cpu" in my patch refers to the cpu NAPI poll is running on (Or
the cpu that the skb origins from).

>then current_cpu is changed to be the same as the
>target cpu, with your patch, new skb will be processed and passed to
>the stack immediately, which may bypass the old skb in the backlog.
>
I think Nop, RFS procedure won't let target cpu switch into a new cpu
if there are still old skbs in the backlog of last recorded cpu. So the
target cpu of the new skb will never equal to current_cpu if old skb in the
backlog.
==========================================================================
Let me draw the situation you described: At the time of T1, the app runs
on cpu-0, so there are many packets queueing into the rxqueue-0 by RFS from
CPU-1(suppose NAPI poll processing on cpu-1). Then, suddenly at the time of
T2, the app tranfers to cpu-1, RFS know there are still old skb in rxqueue-0,
so get_rps_cpu will not return a value of cpu-1, but cpu-0 instead.

========================================================
When T1, app runs on cpu-0:
  APP
-----------------------------
|      |        |      |
|cpu-0 |        |cpu-1 |
|stack |        |stack |
|      |        |      |
   ^
  |=|
  |=|             | |
  |=|             | |
(rxqueue-0)      (rxqueue-1,empty)
   ^<--
       <--
         <--
	     <-- packet(poll on cpu1)
			
===========================================================
When T2, app tranfer to cpu-1, target cpu is still on cpu-0:
                  APP
----------------------------
|      |        |      |
|cpu-0 |        |cpu-1 |
|stack |        |stack |
|      |        |      |
   ^
   |
  |=|             | |
  |=|             | |
(rxqueue-0)      (rxqueue-2,empty)
   ^<--
       <--
         <--
            <-- packet(poll on cpu1)

===================================

Thanks for your reply.

>> 
>> If I'm correct, the code as follws can fix this.
>> 
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -5666,8 +5666,9 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
>>         if (static_branch_unlikely(&rps_needed)) {
>>                 struct rps_dev_flow voidflow, *rflow = &voidflow;
>>                 int cpu = get_rps_cpu(skb->dev, skb, &rflow);
>> +               int current_cpu = smp_processor_id();
>>  
>> -               if (cpu >= 0) {
>> +               if (cpu >= 0 && cpu != current_cpu) {
>>                         ret = enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
>>                         rcu_read_unlock();
>>                         return ret;
>> @@ -5699,11 +5700,15 @@ void netif_receive_skb_list_internal(struct list_head *head)
>>                 list_for_each_entry_safe(skb, next, head, list) {
>>                         struct rps_dev_flow voidflow, *rflow = &voidflow;
>>                         int cpu = get_rps_cpu(skb->dev, skb, &rflow);
>> +                       int current_cpu = smp_processor_id();
>>  
>>                         if (cpu >= 0) {
>>                                 /* Will be handled, remove from list */
>>                                 skb_list_del_init(skb);
>> -                               enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
>> +                               if (cpu != current_cpu)
>> +                                       enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
>> +                               else
>> +                                       __netif_receive_skb(skb);
>>                         }
>>                 }
>> 
>> 
>> Thanks.
>> 
>>>>
>>>> Actually, it's not necessary to enqueue it to backlog when rps-calculated
>>>> CPU id equals to the current processing CPU, and we can call
>>>> __netif_receive_skb or __netif_receive_skb_list to process the skb directly.
>>>> The benefit is that it can reduce the number of softirqs of NET_RX and reduce
>>>> the processing delay of skb.
>>>>
>>>> The measured result shows the patch brings 50% reduction of NET_RX softirqs.
>>>> The test was done on the QEMU environment with two-core CPU by iperf3.
>>>> taskset 01 iperf3 -c 192.168.2.250 -t 3 -u -R;
>>>> taskset 02 iperf3 -c 192.168.2.250 -t 3 -u -R;
>>>>
>>>> Previous RPS:
>>>> 		    	CPU0       CPU1
>>>> NET_RX:         45          0    (before iperf3 testing)
>>>> NET_RX:        1095         241   (after iperf3 testing)
>>>>
>>>> Patched RPS:
>>>>                 CPU0       CPU1
>>>> NET_RX:         28          4    (before iperf3 testing)
>>>> NET_RX:         573         32   (after iperf3 testing)
>>>
>>> Sincerely.
>>> Xu Xin
>> .
>> 
