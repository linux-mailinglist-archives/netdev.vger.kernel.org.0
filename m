Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578B23E143D
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 13:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241177AbhHEL4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 07:56:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51090 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230446AbhHEL4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 07:56:15 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175Bbbgm059583;
        Thu, 5 Aug 2021 07:55:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=P0A+EPyFLGGjQaOI5Psm0rIV1bbwaamMo2S5trAw1o0=;
 b=g9f7+RRqpJng0U+1AffAungIk0f50OV8+5qwayKeqt5QOa7BEa0RhtNM9g7YLwWG9tkt
 elByMHgDAuMVWFAnuNzFX1aKBkN23IP9g9Uts8WmHP3VpxSCXSSHwH/gsw5hOAZZ8qYx
 TR+Rpv6NvhxeJqkS9GeYpJsYntX4KbIqBDXl7yo8tPToYpOnGYsEQSYHBSCdTyLYNswy
 V8rrFOSZTQm6qJNJ8h5TQEal0hqk4wC90aRU+rH9fmqM4QElJ7rTe/8zPEJ/4kZMJj1F
 Qk0m4nnvLoKmY7CSGBphLx8Rd8KQsw5SWk3H9D4cYTRA+QrvXOvkv5nbQ0mY4KcdEKdq Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a8egq9h1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 07:55:58 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 175Btw6F179876;
        Thu, 5 Aug 2021 07:55:58 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a8egq9h0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 07:55:58 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 175Bpx2l016749;
        Thu, 5 Aug 2021 11:55:55 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3a4x5935bb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 11:55:55 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 175Bqq5P58524046
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Aug 2021 11:52:52 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E981CA406F;
        Thu,  5 Aug 2021 11:55:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C77EAA406A;
        Thu,  5 Aug 2021 11:55:51 +0000 (GMT)
Received: from [9.145.20.243] (unknown [9.145.20.243])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 Aug 2021 11:55:51 +0000 (GMT)
Subject: Re: [PATCH NET v3 5/7] vrf: use skb_expand_head in vrf_finish_output
To:     Vasily Averin <vvs@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <15eba3b2-80e2-5547-8ad9-167d810ad7e3@virtuozzo.com>
 <cover.1627891754.git.vvs@virtuozzo.com>
 <e4ca1ef1-56f3-5bce-eec8-617e24bc7b1a@virtuozzo.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <ccce7edb-54dd-e6bf-1e84-0ec320d8886c@linux.ibm.com>
Date:   Thu, 5 Aug 2021 14:55:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <e4ca1ef1-56f3-5bce-eec8-617e24bc7b1a@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rwo93foxGXxQ0O3DAyRi6fGT9gb2c79H
X-Proofpoint-ORIG-GUID: dhmrbn5khhUnSVVXn9MjsMc6OioutPoZ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-05_04:2021-08-05,2021-08-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=952 spamscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 mlxscore=0 impostorscore=0 adultscore=0 priorityscore=1501 clxscore=1011
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108050069
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.08.21 11:52, Vasily Averin wrote:
> Unlike skb_realloc_headroom, new helper skb_expand_head
> does not allocate a new skb if possible.
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> ---
>  drivers/net/vrf.c | 21 +++++++--------------
>  1 file changed, 7 insertions(+), 14 deletions(-)
> 

[...]

>  	/* Be paranoid, rather than too clever. */
>  	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
> -		struct sk_buff *skb2;
> -
> -		skb2 = skb_realloc_headroom(skb, LL_RESERVED_SPACE(dev));
> -		if (!skb2) {
> -			ret = -ENOMEM;
> -			goto err;
> +		skb = skb_expand_head(skb, hh_len);
> +		if (!skb) {
> +			skb->dev->stats.tx_errors++;
> +			return -ENOMEM;

Hello Vasily,

FYI, Coverity complains that we check skb != NULL here but then
still dereference skb->dev:


*** CID 1506214:  Null pointer dereferences  (FORWARD_NULL)
/drivers/net/vrf.c: 867 in vrf_finish_output()
861     	nf_reset_ct(skb);
862     
863     	/* Be paranoid, rather than too clever. */
864     	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
865     		skb = skb_expand_head(skb, hh_len);
866     		if (!skb) {
>>>     CID 1506214:  Null pointer dereferences  (FORWARD_NULL)
>>>     Dereferencing null pointer "skb".
867     			skb->dev->stats.tx_errors++;
868     			return -ENOMEM;
869     		}
870     	}
871     
872     	rcu_read_lock_bh();
