Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03EA7C3895
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 17:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389389AbfJAPI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 11:08:59 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:46864 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727005AbfJAPI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 11:08:59 -0400
Received: from pps.filterd (m0050095.ppops.net [127.0.0.1])
        by m0050095.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id x91F7FwP008688;
        Tue, 1 Oct 2019 16:08:52 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=FSSMpxX54OHY7J+e/t9W7VjsDZaPfT6TEWwtqMwuybE=;
 b=iV2hZbZpwZHCACceytHuuP7Sz6BAkGRa0IqaIQsrBg65/Rd2K9kn8f1TGSED7ofNIWiU
 +lSLaQ1AZ0oCF4xNndWcN51RGzq6eXds87oJXfSgHypihppQkIRk4jGDFWBIekmxUGIc
 ubtMBePR/T024J5OYL5qC5hMrryZN7qaytRr2vzhwSAx3QjmoVFcDSlCPRItQJY3+jUl
 kuC5EoK/UmRtIdX98ThSOZiFaP38LtzwmcyTTK8lfkl1JL8ExIvZv+f7wV6hPwnoSyFW
 b+A9ybrnOmbG+1qBkd4wMabP96qhBWJrWEq/7ctgPCwSHiRzANd+MRIf7DFQVhxiKc/3 XQ== 
Received: from prod-mail-ppoint3 (prod-mail-ppoint3.akamai.com [96.6.114.86] (may be forged))
        by m0050095.ppops.net-00190b01. with ESMTP id 2v9y248e7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Oct 2019 16:08:51 +0100
Received: from pps.filterd (prod-mail-ppoint3.akamai.com [127.0.0.1])
        by prod-mail-ppoint3.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x91F1uUQ000856;
        Tue, 1 Oct 2019 11:08:50 -0400
Received: from prod-mail-relay15.akamai.com ([172.27.17.40])
        by prod-mail-ppoint3.akamai.com with ESMTP id 2va2uyd8fv-1;
        Tue, 01 Oct 2019 11:08:49 -0400
Received: from [0.0.0.0] (prod-ssh-gw02.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay15.akamai.com (Postfix) with ESMTP id 9F28720068;
        Tue,  1 Oct 2019 15:08:48 +0000 (GMT)
Subject: Re: [PATCH 2/2] udp: only do GSO if # of segs > 1
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>
References: <1569881518-21885-1-git-send-email-johunt@akamai.com>
 <1569881518-21885-2-git-send-email-johunt@akamai.com>
 <CAKgT0UfXYHDiz7uf51araHXTizRQpQgi8tDqNp6nX2YzeOoZ3A@mail.gmail.com>
 <CA+FuTSfHxNw4P9sp83_DoMmb-5NQXwSn74CUH80Ai2MSjPcjZw@mail.gmail.com>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <53290360-a34a-3fc3-0fbc-dcbe19393d69@akamai.com>
Date:   Tue, 1 Oct 2019 08:08:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSfHxNw4P9sp83_DoMmb-5NQXwSn74CUH80Ai2MSjPcjZw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-01_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010136
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-01_07:2019-10-01,2019-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1908290000
 definitions=main-1910010137
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/1/19 5:22 AM, Willem de Bruijn wrote:
> On Mon, Sep 30, 2019 at 7:57 PM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
>>
>> On Mon, Sep 30, 2019 at 3:13 PM Josh Hunt <johunt@akamai.com> wrote:
>>>
>>> Prior to this change an application sending <= 1MSS worth of data and
>>> enabling UDP GSO would fail if the system had SW GSO enabled, but the
>>> same send would succeed if HW GSO offload is enabled. In addition to this
>>> inconsistency the error in the SW GSO case does not get back to the
>>> application if sending out of a real device so the user is unaware of this
>>> failure.
>>>
>>> With this change we only perform GSO if the # of segments is > 1 even
>>> if the application has enabled segmentation. I've also updated the
>>> relevant udpgso selftests.
>>>
>>> Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
>>> Signed-off-by: Josh Hunt <johunt@akamai.com>
>>> ---
>>>   net/ipv4/udp.c                       |  5 +++--
>>>   net/ipv6/udp.c                       |  5 +++--
>>>   tools/testing/selftests/net/udpgso.c | 16 ++++------------
>>>   3 files changed, 10 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
>>> index be98d0b8f014..ac0baf947560 100644
>>> --- a/net/ipv4/udp.c
>>> +++ b/net/ipv4/udp.c
>>> @@ -821,6 +821,7 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
>>>          int is_udplite = IS_UDPLITE(sk);
>>>          int offset = skb_transport_offset(skb);
>>>          int len = skb->len - offset;
>>> +       int datalen = len - sizeof(*uh);
>>>          __wsum csum = 0;
>>>
>>>          /*
>>> @@ -832,7 +833,7 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
>>>          uh->len = htons(len);
>>>          uh->check = 0;
>>>
>>> -       if (cork->gso_size) {
>>> +       if (cork->gso_size && datalen > cork->gso_size) {
>>>                  const int hlen = skb_network_header_len(skb) +
>>>                                   sizeof(struct udphdr);
>>>
>>
>> So what about the datalen == cork->gso_size case? That would only
>> generate one segment wouldn't it?
> 
> Segmentation drops packets in this boundary case (not sure why).
> 
>> Shouldn't the test really be "datalen < cork->gso_size"? That should
>> be the only check you need since if gso_size is 0 this statement would
>> always fail anyway.
>>
>> Thanks.
>>
>> - Alex
> 
> The original choice was made to match GSO behavior of other protocols.
> The drop occurs in protocol-independent skb_segment.
> 
> But I had not anticipated HW GSO to behave differently. With that,

Right and for HW GSO we don't call skb_segment().

> aligning the two makes sense. Especially as UDP GSO is exposed to
> userspace. Having to explicitly code a branch whether or not to pass
> UDP_SEGMENT on each send based on size is confusing.
> 
> gso_size is supplied by the user. That value need not be smaller than
> or equal to MTU minus headers. Some of the tests inside the branch,
> especially
> 
>        if (hlen + cork->gso_size > cork->fragsize) {
>                kfree_skb(skb);
>                return -EINVAL;
>        }
> 
> still need to be checked.
> 

Thanks for the review Willem. I will look at those checks and send a v2.

Thanks!
Josh
