Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9FA211604
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgGAW3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:29:00 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:10134 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725771AbgGAW27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 18:28:59 -0400
X-Greylist: delayed 1366 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jul 2020 18:28:59 EDT
Received: from pps.filterd (m0122331.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 061Lrwcg006919;
        Wed, 1 Jul 2020 23:02:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=P96JFBXVyHt85Gh5PYQ4Ee3kDLcMExA/cDXSyYIEwgQ=;
 b=cMZd285DPh3zYED0z60ZKRdfyekvm88MtbIeXIs84pExvO4ArSqjkSma7y9uX8nAM8EQ
 zb07TdkICz7taKqbss/WkMQNkCOzWNNFjGdL0xV7XVKxF5+bok7+sO/1esw8RxC/9Bb5
 0uYUTCb+07ILFFLj+aq2M7Wc5YucD91dPySFBP7fVbwAeWeLIkqTboJIBHzmXvgIXJ7S
 6Eq3rGJdpMc6Gwuge0kuWZ3el18pSod49srUs5eqyaVu7bTya2EbBJqmpfTXglDZVJie
 +DFmyXY6HM9K7NTFWHaJLVxA9+ncxu2hQwf+WCu/GdYIdJ3LI11zvFVddpaoqTyIIe/N Zg== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 31wu08t74s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jul 2020 23:02:09 +0100
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 061M23ck007821;
        Wed, 1 Jul 2020 15:02:08 -0700
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint5.akamai.com with ESMTP id 31x43aqjmg-1;
        Wed, 01 Jul 2020 15:02:08 -0700
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id E79A43B147;
        Wed,  1 Jul 2020 22:02:07 +0000 (GMT)
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     jonas.bonn@netrounds.com, Paolo Abeni <pabeni@redhat.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200623134259.8197-1-mzhivich@akamai.com>
 <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
 <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
 <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <c4db67ab-d01f-402a-757b-cd6949e1f7f5@akamai.com>
Date:   Wed, 1 Jul 2020 15:02:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-01_15:2020-07-01,2020-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxlogscore=621 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010151
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-01_15:2020-07-01,2020-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxlogscore=574 priorityscore=1501 lowpriorityscore=0
 clxscore=1011 malwarescore=0 cotscore=-2147483648 suspectscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007010152
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/1/20 12:58 PM, Cong Wang wrote:
> On Wed, Jul 1, 2020 at 9:05 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>>
>> On Tue, Jun 30, 2020 at 2:08 PM Josh Hunt <johunt@akamai.com> wrote:
>>> Do either of you know if there's been any development on a fix for this
>>> issue? If not we can propose something.
>>
>> If you have a reproducer, I can look into this.
> 
> Does the attached patch fix this bug completely?
> 
> Thanks.
> 

Hey Cong

Unfortunately we don't have a reproducer that would be easy to share, 
however your patch makes sense to me at a high-level. We will test and 
let you know if this fixes our problem.

Thanks!
Josh
