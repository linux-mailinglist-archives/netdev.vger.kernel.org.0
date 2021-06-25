Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550B03B3C9E
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 08:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbhFYGZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 02:25:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50108 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230192AbhFYGZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 02:25:36 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15P63m3W101873;
        Fri, 25 Jun 2021 02:22:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : subject : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uVsRWEvCgZ0OGgHhSqkUOMwkE8AprqcvcntIio0357g=;
 b=X6LjzBfwyZiEQNIHA1KJyzCYKHKHWLiDnoWvN3cZH0G1wsWyniH+K6XqNNmr6i7K4onG
 kI/FoqrQDlkywPaUhnPGoQ10dwwvnzZzl8ivrZsGhbjPS21WXwr0QFrwO2CUO0gp3BIa
 dO9zoA6rIJMwxiHfE2ZsVAxxsLNAhIDz/3gTEylDe9SKb28WzZHRamw9fASZG6T4/L1S
 nHQ5d3FNvOzsCCu0RTJl/mmstSvhWdbbMVX7CSHNVsj/C8e9x230nx6ajuKYvbrVPupf
 1AWFILEGHGoLlyQKGQUWTd6wbF85CGeRyrSvVS4SPoufKsM+GbmkUenno8ndzfRqC4Qo /A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39d8cn2dac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jun 2021 02:22:39 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15P64Wbh107556;
        Fri, 25 Jun 2021 02:22:39 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39d8cn2d9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jun 2021 02:22:38 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15P672NX001791;
        Fri, 25 Jun 2021 06:22:37 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 399878skf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jun 2021 06:22:36 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15P6MYCX24379898
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 06:22:34 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1BE0EA404D;
        Fri, 25 Jun 2021 06:22:34 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 310CEA4040;
        Fri, 25 Jun 2021 06:22:26 +0000 (GMT)
Received: from [9.199.35.17] (unknown [9.199.35.17])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Jun 2021 06:22:25 +0000 (GMT)
From:   Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Subject: Re: [PATCH] x86 bpf: Fix extable offset calculation
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>
References: <CAADnVQJux+8n-vpuK9FqTLuj4cXrp04pGkpvKaUdAPXLQ4c-PQ@mail.gmail.com>
 <20210622110026.1157847-1-ravi.bangoria@linux.ibm.com>
 <CAADnVQKLwEEZJ=_=g8RfgOrt9b1XN=dM9bt515pOrru=ADQR1Q@mail.gmail.com>
Message-ID: <960b5e26-e97d-2b1a-4628-df8525c0728b@linux.ibm.com>
Date:   Fri, 25 Jun 2021 11:52:24 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAADnVQKLwEEZJ=_=g8RfgOrt9b1XN=dM9bt515pOrru=ADQR1Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6VtCpoh8XxZSvcgk4ewT25AeG1ziBwNy
X-Proofpoint-ORIG-GUID: bUC8hsl5fQCzVMerhgo_r0EnidDR65GM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_01:2021-06-24,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 priorityscore=1501 clxscore=1015 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250034
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/21 9:31 AM, Alexei Starovoitov wrote:
> On Tue, Jun 22, 2021 at 4:01 AM Ravi Bangoria
> <ravi.bangoria@linux.ibm.com> wrote:
>>
>> commit 4c5de127598e1 ("bpf: Emit explicit NULL pointer checks
>> for PROBE_LDX instructions.") is emitting couple of instructions
>> before actual load. Consider those additional instructions while
>> calculating extable offset.
>>
>> Fixes: 4c5de127598e1 ("bpf: Emit explicit NULL pointer checks for PROBE_LDX instructions.")
>> Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
>> ---
>>   arch/x86/net/bpf_jit_comp.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
>> index 2a2e290fa5d8..231a8178cc11 100644
>> --- a/arch/x86/net/bpf_jit_comp.c
>> +++ b/arch/x86/net/bpf_jit_comp.c
>> @@ -1297,7 +1297,7 @@ st:                       if (is_imm8(insn->off))
>>                          emit_ldx(&prog, BPF_SIZE(insn->code), dst_reg, src_reg, insn->off);
>>                          if (BPF_MODE(insn->code) == BPF_PROBE_MEM) {
>>                                  struct exception_table_entry *ex;
>> -                               u8 *_insn = image + proglen;
>> +                               u8 *_insn = image + proglen + (u8)(start_of_ldx - temp);
> 
> Great debugging and the fix. Thanks a lot.
> I've dropped (u8) cast, kept (), and applied to bpf tree.
> I think it looks cleaner without that cast.

Thanks.

> Could you send a followup patch with a selftest, so I don't make
> the same mistake again ? ;)

Unfortunately extable gets involved only for bad kernel pointers and
ideally there should not be any bad pointer in kernel. So there is no
easy way to create a proper selftest for this.

Ravi
