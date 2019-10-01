Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77C72C3779
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 16:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388640AbfJAOcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 10:32:11 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:33010 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727018AbfJAOcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 10:32:10 -0400
Received: from pps.filterd (m0050093.ppops.net [127.0.0.1])
        by m0050093.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id x91EQx0Y005407;
        Tue, 1 Oct 2019 15:32:02 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=VYVjbTu/KWrqTkBt0gTP3HovLQdPo/90S3cyZlAKOpA=;
 b=UjPfa/jSwJUlkSXlh8vqlYozqNQWnpt/Ju9f8wRngN8IV/F/NtZVQRYqGC+WY9WWW2kz
 iuLquLZgqzL6Zn+OAVkgiAfr5vOodAbHXBSuytsnZpV95Mw47xeedsh4l5WzjQyVcueq
 kZ1Raer0E90UUSYQNVUrb0/71h02eX0zA0vXg/3i4Ony5es+LDOe73Sdi8Cs+5SI0sXM
 iuM7IgB3ysoa8AAxZ5Osdgart5Qz4YH/966m2EsyS+ww9xDFVoLmnprz/X7RXzKvFYz7
 XzfHAvXYM2wHcxyE0eXMoEG+U9AUmDEMvxg+AOglXyeK7P7EZq4j8PH5UBmjY7k1X+H+ DA== 
Received: from prod-mail-ppoint8 (prod-mail-ppoint8.akamai.com [96.6.114.122] (may be forged))
        by m0050093.ppops.net-00190b01. with ESMTP id 2v9xspr972-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Oct 2019 15:32:02 +0100
Received: from pps.filterd (prod-mail-ppoint8.akamai.com [127.0.0.1])
        by prod-mail-ppoint8.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x91EHPuu012603;
        Tue, 1 Oct 2019 10:32:01 -0400
Received: from prod-mail-relay15.akamai.com ([172.27.17.40])
        by prod-mail-ppoint8.akamai.com with ESMTP id 2va2uwynq2-1;
        Tue, 01 Oct 2019 10:32:01 -0400
Received: from [0.0.0.0] (prod-ssh-gw02.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay15.akamai.com (Postfix) with ESMTP id 03B0A20068;
        Tue,  1 Oct 2019 14:31:59 +0000 (GMT)
Subject: Re: [PATCH 1/2] udp: fix gso_segs calculations
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>
References: <1569881518-21885-1-git-send-email-johunt@akamai.com>
 <CAKgT0Ue092M4pMa8EjrqdF6KADK8WtFhA=17K3fuqW5=xKAeNg@mail.gmail.com>
 <CA+FuTSdkBpKtm48maiTWrRDuW0_ntvpkgXA_TvYZ6uOhf06duw@mail.gmail.com>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <c56ce4ea-f416-163e-80ea-eaefea264fa8@akamai.com>
Date:   Tue, 1 Oct 2019 07:31:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSdkBpKtm48maiTWrRDuW0_ntvpkgXA_TvYZ6uOhf06duw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-01_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010128
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-01_07:2019-10-01,2019-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1908290000
 definitions=main-1910010130
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/1/19 5:12 AM, Willem de Bruijn wrote:
> On Mon, Sep 30, 2019 at 7:51 PM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
>>
>> On Mon, Sep 30, 2019 at 3:15 PM Josh Hunt <johunt@akamai.com> wrote:
>>>
>>> Commit dfec0ee22c0a ("udp: Record gso_segs when supporting UDP segmentation offload")
>>> added gso_segs calculation, but incorrectly got sizeof() the pointer and
>>> not the underlying data type. It also does not account for v6 UDP GSO segs.
>>>
>>> Fixes: dfec0ee22c0a ("udp: Record gso_segs when supporting UDP segmentation offload")
>>> Signed-off-by: Josh Hunt <johunt@akamai.com>
>>> ---
>>>   net/ipv4/udp.c | 2 +-
>>>   net/ipv6/udp.c | 2 ++
>>>   2 files changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
>>> index cf755156a684..be98d0b8f014 100644
>>> --- a/net/ipv4/udp.c
>>> +++ b/net/ipv4/udp.c
>>> @@ -856,7 +856,7 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
>>>
>>>                  skb_shinfo(skb)->gso_size = cork->gso_size;
>>>                  skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
>>> -               skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(uh),
>>> +               skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(*uh),
>>>                                                           cork->gso_size);
>>>                  goto csum_partial;
>>>          }
>>> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
>>> index aae4938f3dea..eb9a9934ac05 100644
>>> --- a/net/ipv6/udp.c
>>> +++ b/net/ipv6/udp.c
>>> @@ -1143,6 +1143,8 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
>>>
>>>                  skb_shinfo(skb)->gso_size = cork->gso_size;
>>>                  skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
>>> +               skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(*uh),
>>> +                                                        cork->gso_size);
>>>                  goto csum_partial;
>>>          }
>>>
>>
>> Fix looks good to me.
>>
>> You might also want to add the original commit since you are also
>> addressing IPv6 changes which are unrelated to my commit that your
>> referenced:
>> Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
>>
>> Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> Acked-by: Willem de Bruijn <willemb@google.com>
> 
> If resending, please target net: [PATCH net v2]
> 

Thanks Willem. Yeah I should have targeted net originally. Will spin a v2.

Thanks!
Josh
