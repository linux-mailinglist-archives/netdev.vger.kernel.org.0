Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123854D2E63
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 12:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbiCILsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 06:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbiCILsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 06:48:30 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8DD60CEE;
        Wed,  9 Mar 2022 03:47:30 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KD9Kq5Hgwz1GCKR;
        Wed,  9 Mar 2022 19:42:39 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 19:47:28 +0800
Subject: Re: [RFC PATCH bpf-next v2 0/3] bpf: support string key in htab
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Joanne Koong <joannekoong@fb.com>
References: <20220214111337.3539-1-houtao1@huawei.com>
 <20220217035041.axk46atz7j4svi2k@ast-mbp.dhcp.thefacebook.com>
 <3b968224-c086-a8b6-159a-55db7ec46011@huawei.com>
 <CAADnVQ+z75P0sryoGhgUwrHRMr2Jw=eFO4eCRe0Ume554si9Zg@mail.gmail.com>
 <ecc04a70-0b57-62ef-ab52-e7169845d789@huawei.com>
 <CAADnVQJUJp3YBcpESwR3Q1U6GS1mBM=Vp-qYuQX7eZOaoLjdUA@mail.gmail.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <daea3845-ab03-12df-ec3b-a645dcee5aaf@huawei.com>
Date:   Wed, 9 Mar 2022 19:47:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQJUJp3YBcpESwR3Q1U6GS1mBM=Vp-qYuQX7eZOaoLjdUA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2/27/2022 11:08 AM, Alexei Starovoitov wrote:
> On Sat, Feb 26, 2022 at 4:16 AM Hou Tao <houtao1@huawei.com> wrote:
>>
>> For now, our case is a write-once case, so only lookup is considered.
>> When data set is bigger than 128KB, hash table has better lookup performance as
>> show below:
>>
>> | lookup all elem (ms) | 4K  | 16K  | 64K  | 128K  | 256K  | 512K  | 1M     | 2M     | 4M      | 7M      |
>> | -------------------- | --- | ---- | ---- | ----- | ----- | ----- | ------ | ------ | ------- | ------- |
>> | hash                 | 3.3 | 12.7 | 47   | 90.6  | 185.9 | 382.3 | 788.5  | 1622.4 | 3296    | 6248.7  |
>> | tries                | 2   | 10   | 45.9 | 111.6 | 274.6 | 688.9 | 1747.2 | 4394.5 | 11229.8 | 27148.8 |
>> | tst                  | 3.8 | 16.4 | 61.3 | 139.1 | 313.9 | 707.3 | 1641.3 | 3856.1 | 9002.3  | 19793.8 |
> 
> Yeah. It's hard to beat hash lookup when it's hitting a good case of O(1),
> but what are the chances that it stays this way?
> Are you saying you can size up the table and populate to good % just once?
>
Yes. for our case the hash table is populated only once. During these test the
hash table is populated firstly by inserting all strings into the table and then
do the lookup. The strings for all tests come from the same string set.

> If so it's probably better to replace all strings with something
> like a good hash
A strong one like sha1sum and using the string as hash-table value just
as proposed in previous email ?

> 7M elements is not a lot. A hash producing 8 or 16 bytes will have close
> to zero false positives.
> And in case of "populate the table once" the hash seed can be
> precomputed and adjusted, so you can guarantee zero collisions
> for 7M strings. While lookup part can still have 0.001% chance
> of a false positive there could be a way to deal with it after lookup.
>
I can try the above method. But the lookup procedure will be slowed done by
calculating a good hash and the memory usage will not reduced.

>> Ternary search tree always has better memory usage:
>>
>> | memory usage (MB) | 4K  | 16K | 64K  | 128K | 256K | 512K | 1M   | 2M    | 4M    | 7M     |
>> | ----------------- | --- | --- | ---- | ---- | ---- | ---- | ---- | ----- | ----- | ------ |
>> | hash              | 2.2 | 8.9 | 35.5 | 71   | 142  | 284  | 568  | 1136  | 2272  | 4302.5 |
>> | tries             | 2.1 | 8.5 | 34   | 68   | 136  | 272  | 544  | 1088  | 2176  | 4106.9 |
>> | tst               | 0.5 | 1.6 | 5.6  | 10.6 | 20.3 | 38.6 | 73.1 | 138.6 | 264.6 | 479.5  |
>>
> 
> Ternary search tree looks amazing.
> Since you have a prototype can you wrap it into a new type of bpf map
> and post the patches?
Will do.

> I wonder what data structures look like to achieve such memory efficiency.
The lower memory usage partially is due to the string set for test is full file
paths and these paths share the same prefix. And ternary search tree reduces the
memory usage by sharing the common prefix.
> .
> 
