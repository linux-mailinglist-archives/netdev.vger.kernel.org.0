Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57C1D8A293
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 17:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfHLPqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 11:46:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51296 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725648AbfHLPqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 11:46:38 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CFiYvx083677
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 11:46:37 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ubb1781w2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 11:46:37 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <gor@linux.ibm.com>;
        Mon, 12 Aug 2019 16:46:35 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 12 Aug 2019 16:46:33 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7CFkWoI57082008
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Aug 2019 15:46:32 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CBC152052;
        Mon, 12 Aug 2019 15:46:32 +0000 (GMT)
Received: from localhost (unknown [9.152.212.191])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 18FBB5204F;
        Mon, 12 Aug 2019 15:46:32 +0000 (GMT)
Date:   Mon, 12 Aug 2019 17:46:30 +0200
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        heiko.carstens@de.ibm.com
Subject: Re: [PATCH bpf] s390/bpf: fix lcgr instruction encoding
References: <20190812150332.98109-1-iii@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190812150332.98109-1-iii@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19081215-0012-0000-0000-0000033DE566
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19081215-0013-0000-0000-00002177F1E1
Message-Id: <your-ad-here.call-01565624790-ext-8747@work.hours>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-12_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908120175
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 05:03:32PM +0200, Ilya Leoshkevich wrote:
> "masking, test in bounds 3" fails on s390, because
> BPF_ALU64_IMM(BPF_NEG, BPF_REG_2, 0) ignores the top 32 bits of
> BPF_REG_2. The reason is that JIT emits lcgfr instead of lcgr.
> The associated comment indicates that the code was intended to emit lcgr
> in the first place, it's just that the wrong opcode was used.
> 
> Fix by using the correct opcode.
> 
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---
>  arch/s390/net/bpf_jit_comp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
> index e636728ab452..6299156f9738 100644
> --- a/arch/s390/net/bpf_jit_comp.c
> +++ b/arch/s390/net/bpf_jit_comp.c
> @@ -863,7 +863,7 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp, int i
>  		break;
>  	case BPF_ALU64 | BPF_NEG: /* dst = -dst */
>  		/* lcgr %dst,%dst */
> -		EMIT4(0xb9130000, dst_reg, dst_reg);
> +		EMIT4(0xb9030000, dst_reg, dst_reg);
>  		break;
>  	/*
>  	 * BPF_FROM_BE/LE
> -- 
> 2.21.0
> 
Please add
Fixes: 054623105728 ("s390/bpf: Add s390x eBPF JIT compiler backend")
or whatever it should be. With that:
Acked-by: Vasily Gorbik <gor@linux.ibm.com>

