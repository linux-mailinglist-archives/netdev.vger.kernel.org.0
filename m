Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C09743FCAC
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 14:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhJ2MxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 08:53:19 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13992 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbhJ2MxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 08:53:11 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hgj0R6Q4VzZcQp;
        Fri, 29 Oct 2021 20:48:39 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 29 Oct 2021 20:50:38 +0800
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 29 Oct 2021 20:50:37 +0800
From:   Hou Tao <houtao1@huawei.com>
Subject: Re: [PATCH bpf-next] bpf: bpf_log() clean-up for kernel log output
To:     Martin KaFai Lau <kafai@fb.com>
CC:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20211026133819.4138245-1-houtao1@huawei.com>
 <20211026213502.s5arrmvh42tbymvv@kafai-mbp.dhcp.thefacebook.com>
Message-ID: <dde6894f-35ea-9be8-865b-a82f0007bb90@huawei.com>
Date:   Fri, 29 Oct 2021 20:50:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20211026213502.s5arrmvh42tbymvv@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 10/27/2021 5:35 AM, Martin KaFai Lau wrote:
> On Tue, Oct 26, 2021 at 09:38:19PM +0800, Hou Tao wrote:
>> An extra newline will output for bpf_log() with BPF_LOG_KERNEL level
>> as shown below:
>>
>> [   52.095704] BPF:The function test_3 has 12 arguments. Too many.
>> [   52.095704]
>> [   52.096896] Error in parsing func ptr test_3 in struct bpf_dummy_ops
>>
>> Now all bpf_log() are ended by newline, so just remove the extra newline.
> bpf_verifier_vlog is also called by btf_verifier_log.
> Not all of them is ended with newline.
Yes, you are right. I miss that.

>> Also there is no need to calculate the left userspace buffer size
>> for kernel log output and to truncate the output by '\0' which
>> has already been done by vscnprintf(), so only do these for
>> userspace log output.
>>
>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>> ---
>>  kernel/bpf/verifier.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index c6616e325803..7d4a313da86e 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -299,13 +299,13 @@ void bpf_verifier_vlog(struct bpf_verifier_log *log, const char *fmt,
>>  	WARN_ONCE(n >= BPF_VERIFIER_TMP_LOG_SIZE - 1,
>>  		  "verifier log line truncated - local buffer too short\n");
>>  
>> -	n = min(log->len_total - log->len_used - 1, n);
>> -	log->kbuf[n] = '\0';
>> -
>>  	if (log->level == BPF_LOG_KERNEL) {
>> -		pr_err("BPF:%s\n", log->kbuf);
>> +		pr_err("BPF:%s", log->kbuf);
> How about trim the tailing '\n' (if any) from kbuf?
> or just test if kbuf is ended with '\n'?
Testing whether or not kbuf is newline ended is OK for me.
Although it can not handle the output for the complex case (e.g.
btf_verifier_log_type(env, t, "vlen != 0")) in which a full line is break
into multiple parts and the newline is the last part, but it can handle
the output format for most btf_verifier_log()
(e.g. btf_verifier_log(env, "hdr_len not found")).
>
>>  		return;
>>  	}
>> +
>> +	n = min(log->len_total - log->len_used - 1, n);
>> +	log->kbuf[n] = '\0';
>>  	if (!copy_to_user(log->ubuf + log->len_used, log->kbuf, n + 1))
>>  		log->len_used += n;
>>  	else
>> -- 
>> 2.29.2
>>
> .

