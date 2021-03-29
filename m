Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80D734D047
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 14:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhC2MnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 08:43:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21290 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231400AbhC2Mmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 08:42:32 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12TCXX4i184245;
        Mon, 29 Mar 2021 08:42:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=h1zE9n5c0hlt1PROjfx0pTaVLD/oTEhrqI+hnRec3y0=;
 b=V/T0NNOUMIPft/bmPZBq+/Kt53pNUMREcobwRGkOxQwHJWswm1FyeTO91JCF6fzqe+09
 d0Sl53hBlTMN6qGfXR7J1z4GrDI+m5WHOoakjUBbOIlBXC3zRgwyw6HB+M8VmcLN65Tm
 1Vhtw4WRU6wRU9zJCIrNa6oGsgt8rl1zCbBIHD+VF6+qgajVAoFJJ4TOterjdEYNdB/Y
 SRP+HomKXKv7mLTczRbZlOuMCoSI3YT9zng6wPM08BaNawIjSbzljdj1NkjjE9FluxBJ
 x6WK8EqLH7hAAVKd6ZdMVRF7E8FuM7l6hxf6M9FxAECyvsoee56vcGb4R7qoM3yJ7D5X Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jpbvaand-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 08:42:06 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12TCXbir184598;
        Mon, 29 Mar 2021 08:42:06 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jpbvaamf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 08:42:05 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12TCMi8v012170;
        Mon, 29 Mar 2021 12:42:04 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 37hvb89t2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 12:42:04 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12TCg1Cs28180932
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 12:42:01 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 468E2A4065;
        Mon, 29 Mar 2021 12:42:01 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5EA0A405F;
        Mon, 29 Mar 2021 12:41:59 +0000 (GMT)
Received: from [9.145.24.127] (unknown [9.145.24.127])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Mar 2021 12:41:59 +0000 (GMT)
Subject: Re: [PATCH net v2] net: Reset MAC header for direct packet
 transmission
To:     Eric Dumazet <edumazet@google.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev <netdev@vger.kernel.org>
References: <20210329071716.12235-1-kurt@linutronix.de>
 <CANn89iJfLQwADLMw6A9J103qM=1y3O6ki1hQMb3cDuJVrwAkrg@mail.gmail.com>
 <878s661cc2.fsf@kurt>
 <CANn89iL6rQ_KqxyTBDDKtU-um_w=OhBywNwMrr+fki3UWdKVLg@mail.gmail.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <d949388f-6027-23be-2e2a-2f37d84e9f27@linux.ibm.com>
Date:   Mon, 29 Mar 2021 14:41:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CANn89iL6rQ_KqxyTBDDKtU-um_w=OhBywNwMrr+fki3UWdKVLg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6_aepRK3ZuMlbSUF2Fw5k4iNirvcjpKj
X-Proofpoint-ORIG-GUID: JMlNIpVc6D4lj3hdsWQiIITskVe7zf34
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_08:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 clxscore=1011 spamscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103290097
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.03.21 14:13, Eric Dumazet wrote:
> On Mon, Mar 29, 2021 at 12:30 PM Kurt Kanzenbach <kurt@linutronix.de> wrote:
>>
>> On Mon Mar 29 2021, Eric Dumazet wrote:
>>> Note that last year, I addressed the issue differently in commit
>>> 96cc4b69581db68efc9749ef32e9cf8e0160c509
>>> ("macvlan: do not assume mac_header is set in macvlan_broadcast()")
>>> (amended with commit 1712b2fff8c682d145c7889d2290696647d82dab
>>> "macvlan: use skb_reset_mac_header() in macvlan_queue_xmit()")
>>>
>>> My reasoning was that in TX path, when ndo_start_xmit() is called, MAC
>>> header is essentially skb->data,
>>> so I was hoping to _remove_ skb_reset_mac_header(skb) eventually from
>>> the fast path (aka __dev_queue_xmit),
>>> because most drivers do not care about MAC header, they just use skb->data.
>>>
>>> I understand it is more difficult to review drivers instead of just
>>> adding more code in  __dev_direct_xmit()
>>>
>>> In hsr case, I do not really see why the existing check can not be
>>> simply reworked ?
>>
>> It can be reworked, no problem. I just thought it might be better to add
>> it to the generic code just in case there are more drivers suffering
>> from the issue.
> 
> Note that I have a similar issue pending in ipvlan.
> 
> Still, I think I prefer the non easy way to not add more stuff in fast path.
> 

Can we apply this fix (and propagate it to stable), and then remove the
skb_reset_mac_header() from _both_ xmit paths through net-next?
