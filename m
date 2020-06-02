Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE071EBD48
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 15:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgFBNoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 09:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgFBNoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 09:44:24 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0164AC08C5C0
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 06:44:24 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id r9so2991935wmh.2
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 06:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CskodHFdxep/vcp6vFQSXsfjQM+WXmjm/RDBRbDkFyM=;
        b=O3/BkwSUEM9rGNCgYlH2f51zgTXBn1FdXwR+RNgHZ49kWoPxAQeV7KOEXakFFpCF+9
         zuvsyBb6z4c/T1yRG2ocag+A9IIJpJLGjgeEKdjbVCVpdjyYnODtp6MruLiOC30VNl3K
         4En9abU7GLhJyXsc3/LjHP124M+TcFp6D8q/7MS7FJ/tQ5qvYY8+W9ZiSfzEdAXyCT8P
         Y5Vf64YXhM96JlS6fv91ihMpHp4uPNnNUr/GVriD3Ca709Hu21QoTIS/Y4GArfRpn3E8
         NNFy2h+ysZjg1uHc5qZhFPtxJTSlO6YRDX56N7G063kAzASR1EcQcWCsA367dCuQvjL5
         WTGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CskodHFdxep/vcp6vFQSXsfjQM+WXmjm/RDBRbDkFyM=;
        b=mfCoqqmLcKMrn80YAxkYeV5h3Qt5FUVQYL/B68IsUAvs+KsbE2u7Ja4FoTnbw/PBQ0
         iYMBDJuj4eVtCdOyqHobE4VT2c/gG4i74hastSBrk+bFPjPxeD0w3ieqaCCjtMD4ZhK9
         Q8JOrDKE/07LJpBJtoDlEpi3wHf/S4Dr0ZP409wfu5kdR6Z9Ar1k7NgA3xPpgK9jptIJ
         QilckS7UVmIgy5PcuUprpqQAG7E39yswHtjsaYe3gF9VlAZWMN955fecgbVai+Ny3Y3t
         EPtqBagpCiw5ShPu/4jBVKZRchVm6vWuK6CS2GRW2i0awimjdz6r24tUOF3N5OcZUQgp
         iZ2w==
X-Gm-Message-State: AOAM530FiSZxjzXLfFIBGCulLJ8MJ8wRGl7kK2DQw3iE/QDiBgZHuurb
        Jooj1bF1Y0fl36iiolBczj4=
X-Google-Smtp-Source: ABdhPJyvt9TvOrggsyPY9kWUc/qaSlmHeKOl6aI7MVJGQJ67XhVS/xejwtahUW1CcZ+YkVeVJ+m+Sg==
X-Received: by 2002:a7b:c005:: with SMTP id c5mr4159038wmb.22.1591105462645;
        Tue, 02 Jun 2020 06:44:22 -0700 (PDT)
Received: from [10.55.3.147] ([173.38.220.42])
        by smtp.gmail.com with ESMTPSA id z7sm3859082wrt.6.2020.06.02.06.44.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2020 06:44:22 -0700 (PDT)
Subject: Re: [PATCH] seg6: Fix slab-out-of-bounds in fl6_update_dst()
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        alex.aring@gmail.com
Cc:     netdev@vger.kernel.org, David Lebrun <david.lebrun@uclouvain.be>
References: <20200602065155.18272-1-yuehaibing@huawei.com>
 <e8e9f99e-9123-9a9a-f5b7-123e11800c06@gmail.com>
From:   Ahmed Abdelsalam <ahabdels@gmail.com>
Message-ID: <47f995e6-843b-5c97-d688-16da8c42c925@gmail.com>
Date:   Tue, 2 Jun 2020 15:44:20 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <e8e9f99e-9123-9a9a-f5b7-123e11800c06@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I’m already working on a fix for this bug.

This patch leads to a bigger semantic problem as it will send SRv6 
packets to the second segment not the first segment (as is does not 
exist in the SRH).

Please see my explanation below.

The main issue is the seg6_validate_srh() which is used to validate SRH 
for two cases:

case1: SRH of data-plane SRv6 packets to be processed /forwarded by the 
Linux kernel.
Case2: SRH of the netlink message received  from user-space (iproute2)

In case1, the SRH can be encoded in the Reduced way and the 
seg6_validate_srh() now handles this case correctly.

In case2, the SRH shouldn’t be encoded in the Reduced way otherwise we 
lose the first segment (i.e., the first hop).

The current issue is that the seg6_validate_srh() allow SRH of case2 to 
be encoded in the Reduced way. Hence the out-of-bounds problem.

I’m working on patch to verify the SRH differently depending if it is 
part of received SRv6 packet or a netlink message.


Ahmed

On 02/06/2020 15:20, Eric Dumazet wrote:
> 
> 
> On 6/1/20 11:51 PM, YueHaibing wrote:
>> When update flowi6 daddr in fl6_update_dst() for srcrt, the used index
>> of segments should be segments_left minus one per RFC8754
>> (section 4.3.1.1) S15 S16. Otherwise it may results in an out-of-bounds
>> read.
>>
>> Reported-by: syzbot+e8c028b62439eac42073@syzkaller.appspotmail.com
>> Fixes: 0cb7498f234e ("seg6: fix SRH processing to comply with RFC8754")
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>   net/ipv6/exthdrs.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
>> index 5a8bbcdcaf2b..f5304bf33ab1 100644
>> --- a/net/ipv6/exthdrs.c
>> +++ b/net/ipv6/exthdrs.c
>> @@ -1353,7 +1353,7 @@ struct in6_addr *fl6_update_dst(struct flowi6 *fl6,
>>   	{
>>   		struct ipv6_sr_hdr *srh = (struct ipv6_sr_hdr *)opt->srcrt;
>>   
>> -		fl6->daddr = srh->segments[srh->segments_left];
>> +		fl6->daddr = srh->segments[srh->segments_left - 1];
>>   		break;
>>   	}
>>   	default:
>>
> 
> 1) Any reason you do not cc the author of the buggy patch ?
>     I also cced David Lebrun <david.lebrun@uclouvain.be> to get more eyes.
> 
> 2) What happens if segments_left == 0 ?
> 
