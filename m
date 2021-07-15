Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553F73CA384
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 19:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhGORFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 13:05:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32814 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229566AbhGORFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 13:05:16 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16FGXn0v012101;
        Thu, 15 Jul 2021 13:02:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=8vgLQq9l+nNM/Hdk68v3quEVfm34OmIgKIW5AkzeIo0=;
 b=lbdEW+DJSX/RpScwDY/kkPxyeFxDfloY1VUBJQFTcvu7HoZJWqAWSH5Mdsx4ssAFmpWt
 hTsc0TOoZA8VcIYJoInJ557wOSgZxnh8R349aGL3yCM2Z5+/TDaL9TMwxBcxlisXgIKe
 wjR+gmalUceNAgZb7QLyHwZLechOEijlLUXuGX+1+mAiwJfAMybJDw54/2KWyugybGyq
 wOB28ZZo0N4BSLAcwpaHX06hSRhFi+0+rKm5FptuwmglI4yKoViPTlbjmGczsU0CzM0t
 7WF2PI9Xf6OcotWeL6N486EP8jFNvCOrjVB9YuI2kjZ3MMeCLfNo29KAfLt3DRn9AvDo Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39sc8md7ej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 13:02:09 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16FGY40q012618;
        Thu, 15 Jul 2021 13:02:08 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39sc8md7dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 13:02:08 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16FGqeeu017674;
        Thu, 15 Jul 2021 17:02:06 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 39q368ac4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 17:02:06 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16FGxqRA35717602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 16:59:52 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03A1CA405F;
        Thu, 15 Jul 2021 17:02:03 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47D55A4066;
        Thu, 15 Jul 2021 17:02:02 +0000 (GMT)
Received: from sig-9-145-173-31.de.ibm.com (unknown [9.145.173.31])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 15 Jul 2021 17:02:02 +0000 (GMT)
Message-ID: <2fbdf14a9e87d240411a420550cf8f797eac3f8c.camel@linux.ibm.com>
Subject: Re: [PATCH] s390/bpf: perform r1 range checking before accessing
 jit->seen_reg[r1]
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Colin King <colin.king@canonical.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 15 Jul 2021 19:02:01 +0200
In-Reply-To: <20210715125712.24690-1-colin.king@canonical.com>
References: <20210715125712.24690-1-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JJweny5O6Rjnt0vVKAetuL-hKLZfWS58
X-Proofpoint-ORIG-GUID: su5QzqVSbU4FlMflR-fe-ZtnMddkk1pE
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-15_10:2021-07-14,2021-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 suspectscore=0 impostorscore=0 clxscore=1011
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107150113
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-07-15 at 13:57 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently array jit->seen_reg[r1] is being accessed before the range
> checking of index r1. The range changing on r1 should be performed
> first since it will avoid any potential out-of-range accesses on the
> array seen_reg[] and also it is more optimal to perform checks on
> r1 before fetching data from the array.  Fix this by swapping the
> order of the checks before the array access.
> 
> Fixes: 054623105728 ("s390/bpf: Add s390x eBPF JIT compiler backend")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  arch/s390/net/bpf_jit_comp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/net/bpf_jit_comp.c
> b/arch/s390/net/bpf_jit_comp.c
> index 63cae0476bb4..2ae419f5115a 100644
> --- a/arch/s390/net/bpf_jit_comp.c
> +++ b/arch/s390/net/bpf_jit_comp.c
> @@ -112,7 +112,7 @@ static inline void reg_set_seen(struct bpf_jit
> *jit, u32 b1)
>  {
>         u32 r1 = reg2hex[b1];
>  
> -       if (!jit->seen_reg[r1] && r1 >= 6 && r1 <= 15)
> +       if (r1 >= 6 && r1 <= 15 && !jit->seen_reg[r1])
>                 jit->seen_reg[r1] = 1;
>  }
>  

Looks good to me, thanks!

Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Tested-by: Ilya Leoshkevich <iii@linux.ibm.com>

