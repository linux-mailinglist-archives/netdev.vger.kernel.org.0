Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E65822A10D
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 23:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732677AbgGVVG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 17:06:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53924 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726447AbgGVVGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 17:06:25 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ML49ow107103;
        Wed, 22 Jul 2020 17:06:23 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32ecpaxggc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 17:06:23 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06ML0rto032441;
        Wed, 22 Jul 2020 21:01:20 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 32brq85eh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 21:01:20 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06ML1HuS59703400
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jul 2020 21:01:17 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFABEA4054;
        Wed, 22 Jul 2020 21:01:17 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7360DA4060;
        Wed, 22 Jul 2020 21:01:17 +0000 (GMT)
Received: from tuxmaker.linux.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 22 Jul 2020 21:01:17 +0000 (GMT)
From:   Schnelle <svens@linux.ibm.com>
To:     seth.forshee@canonical.com
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: test_bpf regressions on s390 since 5.4
References: <20200716152306.GH3644@ubuntu-x1>
Date:   Wed, 22 Jul 2020 23:01:17 +0200
In-Reply-To: <20200716152306.GH3644@ubuntu-x1> (seth forshee's message of
        "Thu, 16 Jul 2020 10:23:06 -0500")
Message-ID: <yt9dtuxzs1r6.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_13:2020-07-22,2020-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=9 bulkscore=0 spamscore=9
 impostorscore=0 clxscore=1011 suspectscore=3 phishscore=0 malwarescore=0
 priorityscore=1501 adultscore=0 mlxlogscore=101 mlxscore=9
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007220128
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Seth,

seth.forshee@canonical.com writes:

> The tests in lib/test_bpf.c were all passing in 5.4 when using the JIT,
> but some are failing in 5.7/5.8. Some of the failures are due to the
> removal of BPF_SIZE_MAX causing some expected failures to pass, which I
> have already send a patch for [1]. The remaining failures appear to be
> regressions. I haven't tried 5.5 or 5.6, so I'm not sure exactly when
> they first appeared.
>
> These are the tests which currently fail:
>
>  test_bpf: #37 INT: MUL_X jited:1 ret -1 != 1 FAIL (1 times)
>  test_bpf: #42 INT: SUB jited:1 ret -55 != 11 FAIL (1 times)
>  test_bpf: #44 INT: MUL jited:1 ret 439084800 != 903446258 FAIL (1 times)
>  test_bpf: #49 INT: shifts by register jited:1 ret -617 != -1 FAIL (1 times)
>  test_bpf: #371 JNE signed compare, test 1 jited:1 ret 2 != 1 FAIL (1 times)
>  test_bpf: #372 JNE signed compare, test 2 jited:1 ret 2 != 1 FAIL (1 times)
>  test_bpf: #374 JNE signed compare, test 4 jited:1 ret 1 != 2 FAIL (1 times)
>  test_bpf: #375 JNE signed compare, test 5 jited:1 ret 2 != 1 FAIL (1 times)

The problem seems to be that the s390 JIT code generates a clgfi (compare
logical 64 - 32 Bit) for JNE:

kernel: test_bpf: #37 INT: MUL_X 
bpf_jit: flen=8 proglen=66 pass=4 image=0000000035b17790 from=insmod pid=574
kernel: JIT code: 00000000: a7 f4 00 03 07 e0 eb bf f0 70 00 24 c0 e1 ff ff
kernel: JIT code: 00000010: ff ff c0 21 ff ff ff ff c0 31 00 00 00 03 b9 0c
kernel: JIT code: 00000020: 00 23 c2 2e ff ff ff fd a7 84 00 04 a7 f4 00 05
kernel: JIT code: 00000030: c0 e1 00 00 00 01 b9 04 00 2e eb bf f0 70 00 04
kernel: JIT code: 00000040: 07 fe
kernel: 000003ff800a0a48: a7f40003            brc        15,000003ff800a0a4e
kernel: 000003ff800a0a4c: 07e0                bcr        14,%r0
kernel: 000003ff800a0a4e: ebbff0700024        stmg       %r11,%r15,112(%r15)
kernel: 000003ff800a0a54: c0e1ffffffff        lgfi       %r14,-1
kernel: 000003ff800a0a5a: c021ffffffff        lgfi       %r2,-1
kernel: 000003ff800a0a60: c03100000003        lgfi       %r3,3
kernel: 000003ff800a0a66: b90c0023            msgr       %r2,%r3
kernel: 000003ff800a0a6a: c22efffffffd        clgfi      %r2,4294967293
kernel: 000003ff800a0a70: a7840004            brc        8,000003ff800a0a78
kernel: 000003ff800a0a74: a7f40005            brc        15,000003ff800a0a7e
kernel: 000003ff800a0a78: c0e100000001        lgfi       %r14,1
kernel: 000003ff800a0a7e: b904002e            lgr        %r2,%r14
kernel: 000003ff800a0a82: ebbff0700004        lmg        %r11,%r15,112(%r15)
kernel: 000003ff800a0a88: 07fe                bcr        15,%r14
kernel: jited:1 ret -1 != 1 FAIL (1 times)

which in the MUL_X case compares than 0xfffffffffffffffd with
0xfffffffd, which is wrong. Changing this to a proper compare fixes all
the test cases for me. Thanks for reporting!

Regards
Sven
