Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF2F94D3C
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 20:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbfHSSop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 14:44:45 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:27396 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726959AbfHSSoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 14:44:44 -0400
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id x7JIhEnP005832;
        Mon, 19 Aug 2019 19:44:40 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=njC4VpILwuWrWLYQRAZQ9GnA2xJHawpormW/amweweI=;
 b=W+8EOXq7eDBoCC/kOCDNoxxUcsKSXesOLQDwtPW8K9YFeQ2Vl8t+PrDAFJUjCVl+icz0
 xiGG5/0KrLQgvWXKjx2nSl5L4SaIcto2RP4JI8ye/wLBq2YEd9rI7o0nFrFkxlqJ4LI9
 wItwNhNCS3moZI9zKqL2hrulbqrYolVfx4ogQ+OL0ZSjjumtVHQnliirbMR6T7X+ccx1
 cJpYIdwUddWZhYNBt3vcVPRkNN6TJVFP8w7SGZLGd/X2Rzi5s0fW6kVw/E0ayzDTaXj9
 fp+YzeH93dxpHfRQKKhfDqNsO1Wa1Z2BiV1HVG6plR+fJbW4NMOYZnAASC6QwJpumofw Vw== 
Received: from prod-mail-ppoint8 (prod-mail-ppoint8.akamai.com [96.6.114.122] (may be forged))
        by m0050096.ppops.net-00190b01. with ESMTP id 2uea0b2j1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Aug 2019 19:44:39 +0100
Received: from pps.filterd (prod-mail-ppoint8.akamai.com [127.0.0.1])
        by prod-mail-ppoint8.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x7JIVuOc026500;
        Mon, 19 Aug 2019 14:44:39 -0400
Received: from prod-mail-relay15.akamai.com ([172.27.17.40])
        by prod-mail-ppoint8.akamai.com with ESMTP id 2uecwvyav8-1;
        Mon, 19 Aug 2019 14:44:38 -0400
Received: from [172.29.170.83] (bos-lpjec.kendall.corp.akamai.com [172.29.170.83])
        by prod-mail-relay15.akamai.com (Postfix) with ESMTP id 8AB4A2006C;
        Mon, 19 Aug 2019 18:44:38 +0000 (GMT)
Subject: Re: [PATCH net] tcp: make sure EPOLLOUT wont be missed
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Vladimir Rutsky <rutsky@google.com>
References: <20190817042622.91497-1-edumazet@google.com>
 <b9ab6b03-664c-eb81-0fbd-6f696276d9aa@akamai.com>
 <c31d7c04-9d6f-aefb-500e-5b9b635ff221@gmail.com>
From:   Jason Baron <jbaron@akamai.com>
Openpgp: preference=signencrypt
Autocrypt: addr=jbaron@akamai.com; prefer-encrypt=mutual; keydata=
 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
 JeQ7iQ==
Message-ID: <21a28c54-1f13-4941-4374-ac67a326c6ab@akamai.com>
Date:   Mon, 19 Aug 2019 14:40:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <c31d7c04-9d6f-aefb-500e-5b9b635ff221@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-19_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908190192
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-19_04:2019-08-19,2019-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 bulkscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908190193
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/17/19 12:26 PM, Eric Dumazet wrote:
> 
> 
> On 8/17/19 4:19 PM, Jason Baron wrote:
>>
>>
>> On 8/17/19 12:26 AM, Eric Dumazet wrote:
>>> As Jason Baron explained in commit 790ba4566c1a ("tcp: set SOCK_NOSPACE
>>> under memory pressure"), it is crucial we properly set SOCK_NOSPACE
>>> when needed.
>>>
>>> However, Jason patch had a bug, because the 'nonblocking' status
>>> as far as sk_stream_wait_memory() is concerned is governed
>>> by MSG_DONTWAIT flag passed at sendmsg() time :
>>>
>>>     long timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
>>>
>>> So it is very possible that tcp sendmsg() calls sk_stream_wait_memory(),
>>> and that sk_stream_wait_memory() returns -EAGAIN with SOCK_NOSPACE
>>> cleared, if sk->sk_sndtimeo has been set to a small (but not zero)
>>> value.
>>
>> Is MSG_DONTWAIT not set in this case? The original patch was intended
>> only for the explicit non-blocking case. The epoll manpage says:
>> "EPOLLET flag should use nonblocking file descriptors". So the original
>> intention was not to impact the blocking case. This seems to me like
>> a different use-case.
>>
> 
> I guess the problem is how we define 'non-blocking' ...
> 
> SO_SNDTIMEO can be used by application to implement a variation of non-blocking,
> by waiting for a socket event with a short timeout, to maybe recover
> from memory pressure conditions in a more efficient way than simply looping.
> 
> Note that the man page for epoll() only _suggests_ to use nonblocking file descriptors.
> 
> <quote>
>        The  suggested  way  to use epoll as an edge-triggered (EPOLLET)
>        interface is as follows:
> 
>               i   with nonblocking file descriptors; and
> 
>               ii  by  waiting  for  an  event  only  after  read(2)  or
>                   write(2) return EAGAIN.
> </quote>
> 
> 

Ok, seems reasonable:
Acked-by: Jason Baron <jbaron@akamai.com>

I found a similar pattern in net/smc/smc_tx.c, which I also just sent a
patch for.

Thanks,

-Jason



