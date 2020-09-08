Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDB226081A
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 03:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbgIHBuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 21:50:23 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:47349 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728085AbgIHBuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 21:50:22 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0U8GTEPg_1599529820;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0U8GTEPg_1599529820)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Sep 2020 09:50:20 +0800
Date:   Tue, 8 Sep 2020 09:50:20 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Satoru Moriya <satoru.moriya@hds.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: tracepoint: fix print wrong sysctl_mem value
Message-ID: <20200908015020.GA56680@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20200907144757.43389-1-dust.li@linux.alibaba.com>
 <20200907105030.6e70adc6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907105030.6e70adc6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 07, 2020 at 10:50:30AM -0700, Jakub Kicinski wrote:
>On Mon,  7 Sep 2020 22:47:57 +0800 Dust Li wrote:
>> sysctl_mem is an point, and tracepoint entry do not support
>> been visited like an array. Use 3 long type to get sysctl_mem
>> instead.
>> 
>> tracpoint output with and without this fix:
>> - without fix:
>>    28821.074 sock:sock_exceed_buf_limit:proto:UDP
>>    sysctl_mem=-1741233440,19,322156906942464 allocated=19 sysctl_rmem=4096
>>    rmem_alloc=75008 sysctl_wmem=4096 wmem_alloc=1 wmem_queued=0
>>    kind=SK_MEM_RECV
>> 
>> - with fix:
>>   2126.136 sock:sock_exceed_buf_limit:proto:UDP
>>   sysctl_mem=18,122845,184266 allocated=19 sysctl_rmem=4096
>>   rmem_alloc=73728 sysctl_wmem=4096 wmem_alloc=1 wmem_queued=0
>>   kind=SK_MEM_RECV
>> 
>> Fixes: 3847ce32aea9fdf ("core: add tracepoints for queueing skb to rcvbuf")
>> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
>> ---
>>  include/trace/events/sock.h | 14 +++++++++-----
>>  1 file changed, 9 insertions(+), 5 deletions(-)
>> 
>> diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
>> index a966d4b5ab37..9118dd2353b7 100644
>> --- a/include/trace/events/sock.h
>> +++ b/include/trace/events/sock.h
>> @@ -98,7 +98,9 @@ TRACE_EVENT(sock_exceed_buf_limit,
>>  
>>  	TP_STRUCT__entry(
>>  		__array(char, name, 32)
>> -		__field(long *, sysctl_mem)
>> +		__field(long, sysctl_mem0)
>> +		__field(long, sysctl_mem1)
>> +		__field(long, sysctl_mem2)
>
>Why not make it an __array() ?
Yeah, it's better using an __array(), I will send a v2.
Thanks !

>
>>  		__field(long, allocated)
>>  		__field(int, sysctl_rmem)
>>  		__field(int, rmem_alloc)
