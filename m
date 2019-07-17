Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFEE36C253
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 22:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfGQUvw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Jul 2019 16:51:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50442 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726063AbfGQUvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 16:51:52 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6HKmAtE079156
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 16:51:50 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tt9fnm02r-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 16:51:49 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Wed, 17 Jul 2019 21:51:47 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 17 Jul 2019 21:51:45 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6HKpiG036438084
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 20:51:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE4AD4C040;
        Wed, 17 Jul 2019 20:51:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51DF34C044;
        Wed, 17 Jul 2019 20:51:44 +0000 (GMT)
Received: from [9.145.191.210] (unknown [9.145.191.210])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Jul 2019 20:51:44 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH bpf] bpf: fix narrower loads on s390
From:   Ilya Leoshkevich <iii@linux.ibm.com>
In-Reply-To: <CAH3MdRV-qsJnyZVV1GnxRZ4=3KXTvKSgETp90fyevxycmAiHmA@mail.gmail.com>
Date:   Wed, 17 Jul 2019 22:51:43 +0200
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com
Content-Transfer-Encoding: 8BIT
References: <20190716115910.23093-1-iii@linux.ibm.com>
 <CAH3MdRWGVDjW8cA9EbnFjK8ko1EqeyDyC_LoRTsxhLsYn1fZtw@mail.gmail.com>
 <CAH3MdRU-u1Gn6uj2D=mzXvdC2RDWas3Ec0QXObKsLac1GwuREQ@mail.gmail.com>
 <98C6AA13-A44D-4FF1-BA73-1BD446BD773A@linux.ibm.com>
 <4311B5C3-8D1B-4958-9CDE-450662A7851D@linux.ibm.com>
 <CAH3MdRV-qsJnyZVV1GnxRZ4=3KXTvKSgETp90fyevxycmAiHmA@mail.gmail.com>
To:     Y Song <ys114321@gmail.com>
X-Mailer: Apple Mail (2.3445.9.1)
X-TM-AS-GCONF: 00
x-cbid: 19071720-0008-0000-0000-000002FE739D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071720-0009-0000-0000-0000226BEF8A
Message-Id: <B91434A8-6056-49E2-852D-6DE5FFD53B29@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-17_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907170235
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Am 17.07.2019 um 18:25 schrieb Y Song <ys114321@gmail.com>:
> 
> On Wed, Jul 17, 2019 at 3:36 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>> 
>> 
>> Here is a better one: len=0x11223344 and we would like to do
>> ((u8 *)&len)[3].
>> 
>> len is represented as `11 22 33 44` in memory, so the desired result is
>> 0x44. It can be obtained by doing (*(u32 *)&len) & 0xff, but today the
>> verifier does ((*(u32 *)&len) >> 24) & 0xff instead.
> 
> What you described above for the memory layout all makes sense.
> The root cause is for big endian, we should do *((u8 *)&len + 3).
> This is exactly what macros in test_pkt_md_access.c tries to do.
> 
> if  __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> #define TEST_FIELD(TYPE, FIELD, MASK)                                   \
>        {                                                               \
>                TYPE tmp = *(volatile TYPE *)&skb->FIELD;               \
>                if (tmp != ((*(volatile __u32 *)&skb->FIELD) & MASK))   \
>                        return TC_ACT_SHOT;                             \
>        }
> #else
> #define TEST_FIELD_OFFSET(a, b) ((sizeof(a) - sizeof(b)) / sizeof(b))
> #define TEST_FIELD(TYPE, FIELD, MASK)                                   \
>        {                                                               \
>                TYPE tmp = *((volatile TYPE *)&skb->FIELD +             \
>                              TEST_FIELD_OFFSET(skb->FIELD, TYPE));     \
>                if (tmp != ((*(volatile __u32 *)&skb->FIELD) & MASK))   \
>                        return TC_ACT_SHOT;                             \
>        }
> #endif
> 
> Could you check whether your __BYTE_ORDER__ is set
> correctly or not for this case? You may need to tweak Makefile
> if you are doing cross compilation, I am not sure how as I
> did not have environment.

I’m building natively on s390.

Here is the (formatted) preprocessed C code for the first condition:

{
	__u8 tmp = *((volatile __u8 *)&skb->len +
		((sizeof(skb->len) - sizeof(__u8)) / sizeof(__u8)));
	if (tmp != ((*(volatile __u32 *)&skb->len) & 0xFF)) return 2;
};

So I believe the endianness is chosen correctly.

Here is the clang-generated BPF bytecode for the first condition:

# llvm-objdump -d test_pkt_md_access.o
0000000000000000 process:
       0:	71 21 00 03 00 00 00 00	r2 = *(u8 *)(r1 + 3)
       1:	61 31 00 00 00 00 00 00	r3 = *(u32 *)(r1 + 0)
       2:	57 30 00 00 00 00 00 ff	r3 &= 255
       3:	5d 23 00 1d 00 00 00 00	if r2 != r3 goto +29 <LBB0_10>

This also looks good to me.

Finally, here is the verifier-generated BPF bytecode:

# bpftool prog dump xlated id 14
; TEST_FIELD(__u8,  len, 0xFF);
   0: (61) r2 = *(u32 *)(r1 +104)
   1: (bc) w2 = w2
   2: (74) w2 >>= 24
   3: (bc) w2 = w2
   4: (54) w2 &= 255
   5: (bc) w2 = w2

Here we can see the shift that I'm referring to. I believe we should
translate *(u8 *)(r1 + 3) in this case without this shift on big-endian
machines.

Best regards,
Ilya
