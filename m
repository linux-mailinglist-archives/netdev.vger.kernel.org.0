Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEFA61629F3
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 16:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgBRP4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 10:56:32 -0500
Received: from www62.your-server.de ([213.133.104.62]:38758 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbgBRP4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 10:56:32 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j45EX-00081J-6U; Tue, 18 Feb 2020 16:56:25 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j45EW-000VnX-Sy; Tue, 18 Feb 2020 16:56:24 +0100
Subject: Re: [PATCH bpf] bpf: Do not grab the bucket spinlock by default on
 htab batch ops
To:     Yonghong Song <yhs@fb.com>, Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20200214224302.229920-1-brianvv@google.com>
 <8ac06749-491f-9a77-3899-641b4f40afe2@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <63fa17bf-a109-65c1-6cc5-581dd84fc93b@iogearbox.net>
Date:   Tue, 18 Feb 2020 16:56:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <8ac06749-491f-9a77-3899-641b4f40afe2@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.1/25727/Tue Feb 18 15:05:00 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/20 4:43 PM, Yonghong Song wrote:
> On 2/14/20 2:43 PM, Brian Vazquez wrote:
>> Grabbing the spinlock for every bucket even if it's empty, was causing
>> significant perfomance cost when traversing htab maps that have only a
>> few entries. This patch addresses the issue by checking first the
>> bucket_cnt, if the bucket has some entries then we go and grab the
>> spinlock and proceed with the batching.
>>
>> Tested with a htab of size 50K and different value of populated entries.
>>
>> Before:
>>    Benchmark             Time(ns)        CPU(ns)
>>    ---------------------------------------------
>>    BM_DumpHashMap/1       2759655        2752033
>>    BM_DumpHashMap/10      2933722        2930825
>>    BM_DumpHashMap/200     3171680        3170265
>>    BM_DumpHashMap/500     3639607        3635511
>>    BM_DumpHashMap/1000    4369008        4364981
>>    BM_DumpHashMap/5k     11171919       11134028
>>    BM_DumpHashMap/20k    69150080       69033496
>>    BM_DumpHashMap/39k   190501036      190226162
>>
>> After:
>>    Benchmark             Time(ns)        CPU(ns)
>>    ---------------------------------------------
>>    BM_DumpHashMap/1        202707         200109
>>    BM_DumpHashMap/10       213441         210569
>>    BM_DumpHashMap/200      478641         472350
>>    BM_DumpHashMap/500      980061         967102
>>    BM_DumpHashMap/1000    1863835        1839575
>>    BM_DumpHashMap/5k      8961836        8902540
>>    BM_DumpHashMap/20k    69761497       69322756
>>    BM_DumpHashMap/39k   187437830      186551111
>>
>> Fixes: 057996380a42 ("bpf: Add batch ops to all htab bpf map")
>> Cc: Yonghong Song <yhs@fb.com>
>> Signed-off-by: Brian Vazquez <brianvv@google.com>
> 
> Acked-by: Yonghong Song <yhs@fb.com>

I must probably be missing something, but how is this safe? Presume we
traverse in the walk with bucket_cnt = 0. Meanwhile a different CPU added
entries to this bucket since not locked. Same reader on the other CPU with
bucket_cnt = 0 then starts to traverse the second
hlist_nulls_for_each_entry_safe() unlocked e.g. deleting entries?
