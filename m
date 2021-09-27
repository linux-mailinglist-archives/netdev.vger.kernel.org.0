Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3B4419854
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 17:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbhI0QBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 12:01:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21064 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235119AbhI0QBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 12:01:01 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18REKx5Q007041;
        Mon, 27 Sep 2021 11:59:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TSI1+pBdww/acHjoBgYoNmQQaxs1wAUJXY3RfJQrd7A=;
 b=amt2qfUGwT+2E2zLcmDghUIyhxCQhkVnVF2EzL4oypVb4NdL0vPdMWUrjRFoPchzEduz
 ngKwei3TB58D6lNH4GsHOsEXI+mC4A3mCuQVCID8knsPCBty9lCvPOVdPb1UZYZiiQJ6
 QX2+t7HqkHleXlBgkATeiJmvRStSgS+0gar1QD+IbQqcz5HmzBKQga/m92RhH4E65ZW8
 dkxVQCaPaB5uwyC3Yrs41BJRpKtbsNq9fN3iyNFpWJPJcM86rbpymCeF/lsbEG4fj706
 /hoRrQLlvXdyHGV51UDuQXz+SeGC/Il5+80aV9VwgjU2ALnXZ+daQ3cKIh+eLGKIrBY7 sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bagryr87u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 11:59:02 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18RFx2Rf022917;
        Mon, 27 Sep 2021 11:59:02 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bagryr871-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 11:59:02 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18RFvGDw021450;
        Mon, 27 Sep 2021 15:58:59 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3b9u1jnh00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 15:58:59 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18RFwtWW39715262
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 15:58:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9F744C044;
        Mon, 27 Sep 2021 15:58:55 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE30B4C052;
        Mon, 27 Sep 2021 15:58:54 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.4.236])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Sep 2021 15:58:54 +0000 (GMT)
Subject: Re: [PATCH RESEND bpf] bpf, s390: Fix potential memory leak about
 jit_data
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>
References: <1632726374-7154-1-git-send-email-yangtiezhu@loongson.cn>
 <e9665315bc2f244d50d026863476e72e3d9b8067.camel@linux.ibm.com>
 <c02febfc-03e6-848a-8fb0-5bd6802c1869@iogearbox.net>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <0cc48f4d-f6c0-ab11-64b0-bc219fbfe777@de.ibm.com>
Date:   Mon, 27 Sep 2021 17:58:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <c02febfc-03e6-848a-8fb0-5bd6802c1869@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5dfteAHKWgX1N3leXmfyQCOEMZgLKMOz
X-Proofpoint-GUID: Yf2UnylgHMRxoqLdR8DUKBXDi3U7i7tI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-27_06,2021-09-24_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1011 priorityscore=1501 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109270106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 27.09.21 um 17:26 schrieb Daniel Borkmann:
> On 9/27/21 1:33 PM, Ilya Leoshkevich wrote:
>> On Mon, 2021-09-27 at 15:06 +0800, Tiezhu Yang wrote:
>>> Make sure to free jit_data through kfree() in the error path.
>>>
>>> Fixes: 1c8f9b91c456 ("bpf: s390: add JIT support for multi-function
>>> programs")
>>> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
>>> ---
>>>
>>> RESEND due to the following reason:
>>> [Can not connect to recipient's server because of unstable
>>> network or firewall filter. rcpt handle timeout, last handle
>>> info: Can not connect to vger.kernel.org]
>>>
>>>   arch/s390/net/bpf_jit_comp.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Nice catch, thanks!
>>
>> Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>

Makes sense.
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

> 
> Given s390, I presume this would be routed to Linus via Heiko/Vasily?

Yes, applied to the s390 tree.

Interestingly enough b4 cannot find the patch email on lore.
Looks like Tiezhu Yang has indeed connection issues with vger.
CC Konstantin, in case he knows something.

