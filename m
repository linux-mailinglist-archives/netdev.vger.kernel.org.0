Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36A12A4A49
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 16:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgKCPqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 10:46:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgKCPqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 10:46:54 -0500
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66170C0613D1;
        Tue,  3 Nov 2020 07:46:54 -0800 (PST)
Received: from pps.filterd (m0122331.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A3FTsAT027253;
        Tue, 3 Nov 2020 15:46:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=RnVOJCENc6qbHet0OD2KAbaT7ByBVdARSO3pp4wh3+A=;
 b=oHyGjl+e83shdNfXLEOtrkQaFIYWGJNmVRuEG7+UwRo+k1cqH3YZnxNi529c6s/uIACr
 KANw6Rly6wEqQ1h0ciqBpj0Ce3hAwNqpox6fkG+hwqU5H8TjLnIYjpmk7uEglaw4puFp
 Zba3wW8Ua/0J/BryfaTfvSVrJ/Qul/ui7B6TxQDMBE+YzT1ARSAaB+zDpyKR8TjpjUKb
 A93ZPLqSNqzPH9GqghcdULmUmxbFn7hWXhbHIO6hQyLF7aiuYD+5wp5xWR/OSQ5xbe3U
 q+oMk48+LJ/qFzobfci8QSa7cAOmCwKbO0mQF46oMZZ18ttgQrs8JC1l1anOzysxEqgZ bg== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 34jhkaurjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 15:46:29 +0000
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 0A3FZIkF011393;
        Tue, 3 Nov 2020 10:46:28 -0500
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint6.akamai.com with ESMTP id 34h38xqm4j-1;
        Tue, 03 Nov 2020 10:46:28 -0500
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id 1E7E33DBC5;
        Tue,  3 Nov 2020 15:46:28 +0000 (GMT)
Subject: Re: [PATCH stable] net: sch_generic: fix the missing new qdisc
 assignment bug
To:     Yunsheng Lin <linyunsheng@huawei.com>, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     Joakim.Tjernlund@infinera.com, xiyou.wangcong@gmail.com,
        johunt@akamai.com, jhs@mojatatu.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        john.fastabend@gmail.com, eric.dumazet@gmail.com, dsahern@gmail.com
References: <1604373938-211588-1-git-send-email-linyunsheng@huawei.com>
From:   Vishwanath Pai <vpai@akamai.com>
Message-ID: <aed8d765-6ac7-bc8b-b8c2-e2c8832865bf@akamai.com>
Date:   Tue, 3 Nov 2020 10:46:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1604373938-211588-1-git-send-email-linyunsheng@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_08:2020-11-03,2020-11-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030107
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_08:2020-11-03,2020-11-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 clxscore=1011
 malwarescore=0 mlxscore=0 impostorscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030107
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 184.51.33.61)
 smtp.mailfrom=vpai@akamai.com smtp.helo=prod-mail-ppoint6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/20 10:25 PM, Yunsheng Lin wrote:
 > commit 2fb541c862c9 ("net: sch_generic: aviod concurrent reset and 
enqueue op for lockless qdisc")
 >
 > When the above upstream commit is backported to stable kernel,
 > one assignment is missing, which causes two problems reported
 > by Joakim and Vishwanath, see [1] and [2].
 >
 > So add the assignment back to fix it.
 >
 > 1. 
https://urldefense.com/v3/__https://www.spinics.net/lists/netdev/msg693916.html__;!!GjvTz_vk!AqzcoNtwXeDu-vDNRKnOiOWYmi4B-2atZZExjZTvpp2jeJ9asOyQBVUtQyBp$
 > 2. 
https://urldefense.com/v3/__https://www.spinics.net/lists/netdev/msg695131.html__;!!GjvTz_vk!AqzcoNtwXeDu-vDNRKnOiOWYmi4B-2atZZExjZTvpp2jeJ9asOyQBQlaitCQ$
 >
 > Fixes: 749cc0b0c7f3 ("net: sch_generic: aviod concurrent reset and 
enqueue op for lockless qdisc")
 > Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
 > ---
 >  net/sched/sch_generic.c | 3 +++
 >  1 file changed, 3 insertions(+)
 >
 > diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
 > index 0e275e1..6e6147a 100644
 > --- a/net/sched/sch_generic.c
 > +++ b/net/sched/sch_generic.c
 > @@ -1127,10 +1127,13 @@ static void dev_deactivate_queue(struct 
net_device *dev,
 >                   void *_qdisc_default)
 >  {
 >      struct Qdisc *qdisc = rtnl_dereference(dev_queue->qdisc);
 > +    struct Qdisc *qdisc_default = _qdisc_default;
 >
 >      if (qdisc) {
 >          if (!(qdisc->flags & TCQ_F_BUILTIN))
 >              set_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state);
 > +
 > +        rcu_assign_pointer(dev_queue->qdisc, qdisc_default);
 >      }
 >  }
 >

I have tested the patch on v5.4.71 and it fixes our issues.

Tested-by: Vishwanath Pai <vpai@akamai.com>

