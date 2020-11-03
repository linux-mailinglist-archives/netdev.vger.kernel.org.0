Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4E92A3ECA
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 09:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgKCIUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 03:20:15 -0500
Received: from linux.microsoft.com ([13.77.154.182]:59370 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbgKCIUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 03:20:14 -0500
Received: from [192.168.0.114] (unknown [49.207.216.192])
        by linux.microsoft.com (Postfix) with ESMTPSA id 2C66920B4905;
        Tue,  3 Nov 2020 00:20:08 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2C66920B4905
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1604391614;
        bh=HbEbQz+EauvQoznebwDeRtdchvf0ccH1vXyEBqePynI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=o7H296iXCemOmtcOaSOA1R4y7gkYxXRBAacpjbj1C8j/ik3lOvsvhlz5D3IyvnYF7
         8fmvhlDDiZ1bRvuwzHUNTM4d7rbGAeShJjfG6dd7qdUDh+x1oBFNhaMzdMaO7RFZF1
         9Q4/fNWs4cO4/+Rk7oHqgaURA6CjVMDIqdl2SShs=
Subject: Re: [net-next V3 6/8] net: sched: convert tasklets to use new
 tasklet_setup() API
To:     Eric Dumazet <edumazet@google.com>,
        Allen Pais <allen.lkml@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Alexander Aring <alex.aring@gmail.com>,
        stefan@datenfreihafen.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev <netdev@vger.kernel.org>,
        Romain Perier <romain.perier@gmail.com>
References: <20201103070947.577831-1-allen.lkml@gmail.com>
 <20201103070947.577831-7-allen.lkml@gmail.com>
 <CANn89iJ4Z=Z+iSHoQQhTS+QGyfU_TOeWNC3Sjszc=DeZ3-bJUw@mail.gmail.com>
From:   Allen Pais <apais@linux.microsoft.com>
Message-ID: <4e8b4ddb-bccd-ddad-3071-afef1b1590c9@linux.microsoft.com>
Date:   Tue, 3 Nov 2020 13:50:06 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CANn89iJ4Z=Z+iSHoQQhTS+QGyfU_TOeWNC3Sjszc=DeZ3-bJUw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>
>> In preparation for unconditionally passing the
>> struct tasklet_struct pointer to all tasklet
>> callbacks, switch to using the new tasklet_setup()
>> and from_tasklet() to pass the tasklet pointer explicitly.
>>
>> Signed-off-by: Romain Perier <romain.perier@gmail.com>
>> Signed-off-by: Allen Pais <apais@linux.microsoft.com>
>> ---
>>   net/sched/sch_atm.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
>> index 1c281cc81f57..390d972bb2f0 100644
>> --- a/net/sched/sch_atm.c
>> +++ b/net/sched/sch_atm.c
>> @@ -466,10 +466,10 @@ drop: __maybe_unused
>>    * non-ATM interfaces.
>>    */
>>
>> -static void sch_atm_dequeue(unsigned long data)
>> +static void sch_atm_dequeue(struct tasklet_struct *t)
>>   {
>> -       struct Qdisc *sch = (struct Qdisc *)data;
>> -       struct atm_qdisc_data *p = qdisc_priv(sch);
>> +       struct atm_qdisc_data *p = from_tasklet(p, t, task);
>> +       struct Qdisc *sch = (struct Qdisc *)((char *)p - sizeof(struct Qdisc));
> 
> Hmm... I think I prefer not burying implementation details in
> net/sched/sch_atm.c and instead
> define a helper in include/net/pkt_sched.h
> 
> diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
> index 4ed32e6b020145afb015c3c07d2ec3a613f1311d..15b1b30f454e4837cd1fc07bb3ff6b4f178b1d39
> 100644
> --- a/include/net/pkt_sched.h
> +++ b/include/net/pkt_sched.h
> @@ -24,6 +24,11 @@ static inline void *qdisc_priv(struct Qdisc *q)
>          return &q->privdata;
>   }
> 
> +static inline struct Qdisc *qdisc_from_priv(void *priv)
> +{
> +       return container_of(priv, struct Qdisc, privdata);
> +}
> +
>   /*
>      Timer resolution MUST BE < 10% of min_schedulable_packet_size/bandwidth
> 

Sure, I will have it updated and resent. Thanks.
