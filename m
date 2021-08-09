Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9117F3E458F
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 14:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbhHIMZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 08:25:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34232 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234427AbhHIMZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 08:25:24 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 179C4dTD120634;
        Mon, 9 Aug 2021 08:24:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=BgVL1+G8Ey7SqGZEmnaIbENFNmXVn+5pmm36QbO8AKY=;
 b=GlLdTUyVPYQZ4WAoy++Xyu9sCz9fnXQYiSj0P67YoMcWR6LsCyAPfBkFEQU1FfJUhW+6
 UpDaLG5eqNTAx534Cgh/N7Dtcj5v8Rn9Gi7yxeY0UhpIJI+E4QmYCB3RfP83Yutobyys
 OTeHp3vwWXJZonJFQJUiyjXG5jZn4P34tJgEY6K3otgmxFoA5jwbQz5W/gY02BhAXQXK
 eJKWJ/fj7z6GmZH0wSI3dGaf0h/NOXmvWgV3TmypgX21NfmfNL4LDSyz+4vAoshwIya4
 mOJyFkv2kG43XzphoS6EWyUeBQ5ojsxnJoFcrv0qoWTa89k9WOrAbA/37L/kuUYNv+P/ EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aax401u4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 08:24:48 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 179C4hW0120939;
        Mon, 9 Aug 2021 08:24:48 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aax401u3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 08:24:47 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 179CMjlP013137;
        Mon, 9 Aug 2021 12:24:46 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3a9hehkjda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 12:24:45 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 179CLW7w58458394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 12:21:32 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C3FFA4059;
        Mon,  9 Aug 2021 12:24:42 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6220AA4040;
        Mon,  9 Aug 2021 12:24:41 +0000 (GMT)
Received: from sig-9-145-77-113.uk.ibm.com (unknown [9.145.77.113])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Aug 2021 12:24:41 +0000 (GMT)
Message-ID: <2f97353921497b8d603cd5fff05e136d4bfcb430.camel@linux.ibm.com>
Subject: Re: [PATCH bpf-next 4/7] s390: bpf: Fix off-by-one in tail call
 count limiting
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        illusionist.neo@gmail.com, zlim.lnx@gmail.com,
        paulburton@kernel.org, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, luke.r.nels@gmail.com, bjorn@kernel.org,
        hca@linux.ibm.com, gor@linux.ibm.com, davem@davemloft.net,
        udknight@gmail.com
Date:   Mon, 09 Aug 2021 14:24:41 +0200
In-Reply-To: <20210809093437.876558-5-johan.almbladh@anyfinetworks.com>
References: <20210809093437.876558-1-johan.almbladh@anyfinetworks.com>
         <20210809093437.876558-5-johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rwzRpzdXrjvRgHUtGzCzJIaoo0Nuon75
X-Proofpoint-GUID: -vKr8Omei-mg5vPaDn2ubMCiF4c8BZ4W
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_04:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 spamscore=0
 impostorscore=0 clxscore=1011 mlxlogscore=999 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090093
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-08-09 at 11:34 +0200, Johan Almbladh wrote:
> Before, the eBPF JIT allowed up to MAX_TAIL_CALL_CNT + 1 tail calls.
> Now, precisely MAX_TAIL_CALL_CNT is allowed, which is in line with the
> behaviour of the interpreter. Verified with the test_bpf test suite
> on qemu-system-s390x.
> 
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> ---
>  arch/s390/net/bpf_jit_comp.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/net/bpf_jit_comp.c
> b/arch/s390/net/bpf_jit_comp.c
> index 88419263a89a..f6cdf13285ed 100644
> --- a/arch/s390/net/bpf_jit_comp.c
> +++ b/arch/s390/net/bpf_jit_comp.c
> @@ -1363,7 +1363,7 @@ static noinline int bpf_jit_insn(struct bpf_jit
> *jit, struct bpf_prog *fp,
>                                  jit->prg);
>  
>                 /*
> -                * if (tail_call_cnt++ > MAX_TAIL_CALL_CNT)
> +                * if (tail_call_cnt++ >= MAX_TAIL_CALL_CNT)
>                  *         goto out;
>                  */
>  
> @@ -1377,8 +1377,8 @@ static noinline int bpf_jit_insn(struct bpf_jit
> *jit, struct bpf_prog *fp,
>                 EMIT6_DISP_LH(0xeb000000, 0x00fa, REG_W1, REG_W0,
> REG_15, off);
>                 /* clij %w1,MAX_TAIL_CALL_CNT,0x2,out */

This comment needs to be updated as well.

>                 patch_2_clij = jit->prg;
> -               EMIT6_PCREL_RIEC(0xec000000, 0x007f, REG_W1,
> MAX_TAIL_CALL_CNT,
> -                                2, jit->prg);
> +               EMIT6_PCREL_RIEC(0xec000000, 0x007f, REG_W1,
> +                                MAX_TAIL_CALL_CNT - 1, 2, jit->prg);
>  
>                 /*
>                  * prog = array->ptrs[index];

With that:

Tested-by: Ilya Leoshkevich <iii@linux.ibm.com>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>

