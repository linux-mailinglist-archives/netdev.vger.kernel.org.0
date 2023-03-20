Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8CA6C1370
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 14:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjCTNbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 09:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbjCTNbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 09:31:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40D7658C
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 06:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679319032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Av2ZgVuRdRDfE6k8gz4vNUpCE8kbGYe8mvkDt1VZWM=;
        b=GwUajg+rfYfNFUaF1HMjKCMMt5pv93dJTKN5rqUlRIpt//qFNZr/ptIXwIoV0fTsa0Sy/r
        xtzgpT55L91668teQjcwpbZEw1o82PDoWweoWJk5pXybDUIRB14zW2XB9BSkbx18cSDHlu
        Ed2C7lb6Cy1U+myEbw2NPqacFrhktj0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-230-ZjKmZe5MMyWy-J8yP5anFw-1; Mon, 20 Mar 2023 09:30:30 -0400
X-MC-Unique: ZjKmZe5MMyWy-J8yP5anFw-1
Received: by mail-ed1-f70.google.com with SMTP id b1-20020aa7dc01000000b004ad062fee5eso17365984edu.17
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 06:30:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679319030;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Av2ZgVuRdRDfE6k8gz4vNUpCE8kbGYe8mvkDt1VZWM=;
        b=YQkVw83tcG7QESD5prrWCerEXowikQ450IYVnD+lM6PjeMOW+RZLViEYh0ZUGesAD9
         fkSwfvCwK2UbAusNiNs2h41uiMDzGiBJhF2gdMbfP4+/ZzM6JNOqB4u5YDeaKUYXCAzx
         RVnIFmyBYothyvpQVk/TAzfsqA8msMnyTWmdoEZi/p6jxmKA0MHhJjIv9oDxV3hPwmno
         TXPhRL6GATkd+vKfIaj1kdbi4xVDyOLVVaroc5e552+I9YWBaQoLymqSJYTW7fv8vxKa
         6yisA4kBJKJLHP2vydKWnpt/NrntStRSyGJxXmg1p6zUShGjI68GM0tvwaFRTVPJEd7Y
         EegA==
X-Gm-Message-State: AO0yUKVCVtVlgvVd17OEcE3VSbb5ajTKQo22VEZ6Bt8YzgM8N2xNb+KK
        FEfc3p/CFpQiY0v6qkW91BnHzuQ7rUnWXRGcwc1rToWpLYh+CpTf3lr/mRhdC+8c+sXcTOkUbdO
        iIlQJMBafq1tv4gv0
X-Received: by 2002:a17:906:3fcf:b0:92d:6078:3878 with SMTP id k15-20020a1709063fcf00b0092d60783878mr6880737ejj.33.1679319029911;
        Mon, 20 Mar 2023 06:30:29 -0700 (PDT)
X-Google-Smtp-Source: AK7set/wjS2guRdO5BN4Q4rtceVV00MihcjPgmuum1XV555sJA6pp9UlWbzzk6fCvAEHFKweM5LhQQ==
X-Received: by 2002:a17:906:3fcf:b0:92d:6078:3878 with SMTP id k15-20020a1709063fcf00b0092d60783878mr6880719ejj.33.1679319029637;
        Mon, 20 Mar 2023 06:30:29 -0700 (PDT)
Received: from [192.168.42.100] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id p23-20020a1709066a9700b008d53ea69227sm4413535ejr.224.2023.03.20.06.30.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 06:30:29 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <870ba7b7-c38b-f4af-2087-688e9ae5a15d@redhat.com>
Date:   Mon, 20 Mar 2023 14:30:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, jbrouer@redhat.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH v4 net-next 2/2] net: introduce budget_squeeze to help us
 tune rx behavior
Content-Language: en-US
To:     Jason Xing <kerneljasonxing@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230315092041.35482-1-kerneljasonxing@gmail.com>
 <20230315092041.35482-3-kerneljasonxing@gmail.com>
 <20230316172020.5af40fe8@kernel.org>
 <CAL+tcoDNvMUenwNEH2QByEY7cS1qycTSw1TLFSnNKt4Q0dCJUw@mail.gmail.com>
 <20230316202648.1f8c2f80@kernel.org>
 <CAL+tcoD+BoXsEBS5T_kvuUzDTuF3N7kO1eLqwNP3Wy6hps+BBA@mail.gmail.com>
In-Reply-To: <CAL+tcoD+BoXsEBS5T_kvuUzDTuF3N7kO1eLqwNP3Wy6hps+BBA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 17/03/2023 05.11, Jason Xing wrote:
> On Fri, Mar 17, 2023 at 11:26 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Fri, 17 Mar 2023 10:27:11 +0800 Jason Xing wrote:
>>>> That is the common case, and can be understood from the napi trace
>>>
>>> Thanks for your reply. It is commonly happening every day on many servers.
>>
>> Right but the common issue is the time squeeze, not budget squeeze,
> 
> Most of them are about time, so yes.
> 
>> and either way the budget squeeze doesn't really matter because
>> the softirq loop will call us again soon, if softirq itself is
>> not scheduled out.
>>

I agree, the budget squeeze count doesn't provide much value as it
doesn't indicate something critical (softirq loop will call us again
soon).  The time squeeze event is more critical and something that is
worth monitoring.

I see value in this patch, because it makes it possible monitor the time
squeeze events.  Currently the counter is "polluted" by the budget
squeeze, making it impossible to get a proper time squeeze signal.
Thus, I see this patch as a fix to a old problem.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

That said (see below), besides monitoring time squeeze counter, I
recommend adding some BPF monitoring to capture latency issues...

>> So if you want to monitor a meaningful event in your fleet, I think
>> a better event to monitor is the number of times ksoftirqd was woken
>> up and latency of it getting onto the CPU.
> 
> It's a good point. Thanks for your advice.

I'm willing to help you out writing a BPF-based tool that can help you
identify the issue Jakub describe above. Of high latency from when
softIRQ is raised until softIRQ processing runs on the CPU.

I have this bpftrace script[1] available that does just that:

  [1] 
https://github.com/xdp-project/xdp-project/blob/master/areas/latency/softirq_net_latency.bt

Perhaps you can take the latency historgrams and then plot a heatmap[2]
in your monitoring platform.

  [2] https://www.brendangregg.com/heatmaps.html

--Jesper

