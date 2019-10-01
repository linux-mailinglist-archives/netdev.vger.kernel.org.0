Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E45AC376F
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 16:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389033AbfJAObX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 10:31:23 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:49246 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727051AbfJAObX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 10:31:23 -0400
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id x91EQvBl011402;
        Tue, 1 Oct 2019 15:31:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=TZwthGp0YG1tpxtdCgZGLFaRW8H+CHtmcDIyCZpa+us=;
 b=IZF+N8RjQ6+FFQ47MsSvelyN/rsNRwZL9BjDuW8uE9/Z6frnPVmbGmVC4YyH0ltxulzE
 OtIfjPLI9l/V1Q3oMMMN/4ksLywIK+SeapUwNFFaYiYjhgpz5iQW8G/ZSgxJ+NmtEF0j
 GHmTDdjRX89N45nQihHkWCknVvZUp4NR7jHc1XohRgHdLdgaxnLzctmnNV1tYGOwF4aZ
 4v6J4HFD8IsU75XY4uYjKrynwLfVdcWNMlC4S5XjvH7i0yjKZ0nA34Sau8A8Ycsze3wW
 Fpckh2fheiGzf8Sv30gaOI1drfoeoIntuSsz72PiOeQvKmIuLqCa+5fJIA6UN54QhQXA vA== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by m0050096.ppops.net-00190b01. with ESMTP id 2v9yxawfjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Oct 2019 15:31:08 +0100
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x91EHQ3m030556;
        Tue, 1 Oct 2019 10:31:07 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint6.akamai.com with ESMTP id 2va2uw4hn6-1;
        Tue, 01 Oct 2019 10:31:07 -0400
Received: from [0.0.0.0] (caldecot.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 02C6D1FC6D;
        Tue,  1 Oct 2019 14:31:05 +0000 (GMT)
Subject: Re: [PATCH 1/2] udp: fix gso_segs calculations
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>
References: <1569881518-21885-1-git-send-email-johunt@akamai.com>
 <CAKgT0Ue092M4pMa8EjrqdF6KADK8WtFhA=17K3fuqW5=xKAeNg@mail.gmail.com>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <0ccbb266-d3ad-e53b-ecbe-49bffdcc63aa@akamai.com>
Date:   Tue, 1 Oct 2019 07:31:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0Ue092M4pMa8EjrqdF6KADK8WtFhA=17K3fuqW5=xKAeNg@mail.gmail.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 adultscore=0 impostorscore=0 clxscore=1015 phishscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1908290000
 definitions=main-1910010130
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/30/19 4:51 PM, Alexander Duyck wrote:
> On Mon, Sep 30, 2019 at 3:15 PM Josh Hunt <johunt@akamai.com> wrote:
>>
>> Commit dfec0ee22c0a ("udp: Record gso_segs when supporting UDP segmentation offload")
>> added gso_segs calculation, but incorrectly got sizeof() the pointer and
>> not the underlying data type. It also does not account for v6 UDP GSO segs.
>>
>> Fixes: dfec0ee22c0a ("udp: Record gso_segs when supporting UDP segmentation offload")
>> Signed-off-by: Josh Hunt <johunt@akamai.com>
>> ---
>>   net/ipv4/udp.c | 2 +-
>>   net/ipv6/udp.c | 2 ++
>>   2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
>> index cf755156a684..be98d0b8f014 100644
>> --- a/net/ipv4/udp.c
>> +++ b/net/ipv4/udp.c
>> @@ -856,7 +856,7 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
>>
>>                  skb_shinfo(skb)->gso_size = cork->gso_size;
>>                  skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
>> -               skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(uh),
>> +               skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(*uh),
>>                                                           cork->gso_size);
>>                  goto csum_partial;
>>          }
>> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
>> index aae4938f3dea..eb9a9934ac05 100644
>> --- a/net/ipv6/udp.c
>> +++ b/net/ipv6/udp.c
>> @@ -1143,6 +1143,8 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
>>
>>                  skb_shinfo(skb)->gso_size = cork->gso_size;
>>                  skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
>> +               skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(*uh),
>> +                                                        cork->gso_size);
>>                  goto csum_partial;
>>          }
>>
> 
> Fix looks good to me.
> 
> You might also want to add the original commit since you are also
> addressing IPv6 changes which are unrelated to my commit that your
> referenced:
> Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
> 
> Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 

Thanks for the review Alex. I will make those changes and spin a v2.

Thanks!
Josh
