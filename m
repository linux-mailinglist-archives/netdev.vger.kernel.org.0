Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 396BD9C9B8
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 08:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbfHZG7P convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 26 Aug 2019 02:59:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25862 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729625AbfHZG7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 02:59:15 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7Q6vn0i125926
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 02:59:14 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2um8dakxkv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 02:59:14 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <naveen.n.rao@linux.vnet.ibm.com>;
        Mon, 26 Aug 2019 07:59:11 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 26 Aug 2019 07:59:09 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7Q6x8gc37028070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 06:59:08 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31AD1A4059;
        Mon, 26 Aug 2019 06:59:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCBD5A405B;
        Mon, 26 Aug 2019 06:59:07 +0000 (GMT)
Received: from localhost (unknown [9.124.35.18])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 26 Aug 2019 06:59:07 +0000 (GMT)
Date:   Mon, 26 Aug 2019 12:29:05 +0530
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: Re: [PATCH] bpf: handle 32-bit zext during constant blinding
To:     Jiong Wang <jiong.wang@netronome.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>, netdev@vger.kernel.org
References: <20190821192358.31922-1-naveen.n.rao@linux.vnet.ibm.com>
        <87zhk2faqg.fsf@netronome.com>
In-Reply-To: <87zhk2faqg.fsf@netronome.com>
MIME-Version: 1.0
User-Agent: astroid/0.15.0 (https://github.com/astroidmail/astroid)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
X-TM-AS-GCONF: 00
x-cbid: 19082606-4275-0000-0000-0000035D680B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082606-4276-0000-0000-0000386F9425
Message-Id: <1566802541.7onbueyw0d.naveen@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-26_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908260077
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiong Wang wrote:
> 
> Naveen N. Rao writes:
> 
>> Since BPF constant blinding is performed after the verifier pass, the
>> ALU32 instructions inserted for doubleword immediate loads don't have a
>> corresponding zext instruction. This is causing a kernel oops on powerpc
>> and can be reproduced by running 'test_cgroup_storage' with
>> bpf_jit_harden=2.
>>
>> Fix this by emitting BPF_ZEXT during constant blinding if
>> prog->aux->verifier_zext is set.
>>
>> Fixes: a4b1d3c1ddf6cb ("bpf: verifier: insert zero extension according to analysis result")
>> Reported-by: Michael Ellerman <mpe@ellerman.id.au>
>> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> 
> Thanks for the fix.
> 
> Reviewed-by: Jiong Wang <jiong.wang@netronome.com>
> 
> Just two other comments during review in case I am wrong on somewhere.
> 
>   - Use verifier_zext instead of bpf_jit_needs_zext() seems better, even
>     though the latter could avoid extending function argument.
> 
>     Because JIT back-ends look at verifier_zext, true means zext inserted
>     by verifier so JITs won't do the code-gen.
> 
>     Use verifier_zext is sort of keeping JIT blinding the same behaviour
>     has verifier even though blinding doesn't belong to verifier, but for
>     such insn patching, it could be seen as a extension of verifier,
>     therefore use verifier_zext seems better than bpf_jit_needs_zext() to
>     me.
>    
>   - JIT blinding is also escaping the HI32 randomization which happens
>     inside verifier, otherwise x86-64 regression should have caught this issue.

Jiong,
Thanks for the review.

Alexei, Daniel,
Can you please pick this up for v5.3. This is a regression and is 
causing a crash on powerpc.


- Naveen

