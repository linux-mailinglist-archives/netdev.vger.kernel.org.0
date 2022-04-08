Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF1B4F8C24
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 05:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbiDHBcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 21:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbiDHBcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 21:32:14 -0400
Received: from mail.meizu.com (edge05.meizu.com [157.122.146.251])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2452706C6;
        Thu,  7 Apr 2022 18:30:11 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail12.meizu.com
 (172.16.1.108) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 8 Apr
 2022 09:30:09 +0800
Received: from [172.16.137.70] (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Fri, 8 Apr
 2022 09:30:08 +0800
Message-ID: <2c29b3cd-ec23-f9c8-ae9f-d713ce3dd4f0@meizu.com>
Date:   Fri, 8 Apr 2022 09:30:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] libbpf: potential NULL dereference in
 usdt_manager_attach_usdt()
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1649299098-2069-1-git-send-email-baihaowen@meizu.com>
 <CAEf4BzbByQ8OUuACyLEHewPsFjfUpH8Yr1x2+Db5xtGgnPXhrQ@mail.gmail.com>
From:   baihaowen <baihaowen@meizu.com>
In-Reply-To: <CAEf4BzbByQ8OUuACyLEHewPsFjfUpH8Yr1x2+Db5xtGgnPXhrQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        NICE_REPLY_A,SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 4/8/22 3:04 AM, Andrii Nakryiko 写道:
> On Wed, Apr 6, 2022 at 7:38 PM Haowen Bai <baihaowen@meizu.com> wrote:
>> link could be null but still dereference bpf_link__destroy(&link->link)
>> and it will lead to a null pointer access.
>>
>> Signed-off-by: Haowen Bai <baihaowen@meizu.com>
>> ---
>>  tools/lib/bpf/usdt.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
>> index 1bce2eab5e89..b02ebc4ba57c 100644
>> --- a/tools/lib/bpf/usdt.c
>> +++ b/tools/lib/bpf/usdt.c
>> @@ -996,7 +996,7 @@ struct bpf_link *usdt_manager_attach_usdt(struct usdt_manager *man, const struct
>>         link = calloc(1, sizeof(*link));
>>         if (!link) {
>>                 err = -ENOMEM;
>> -               goto err_out;
>> +               goto link_err;
> this is not a complete fix because there are two more similar goto
> err_out; above which you didn't fix. I think better fix is to just add
> if (link) check before bpf_link__destroy(), which is what I did
> locally when applying.
>
>
>>         }
>>
>>         link->usdt_man = man;
>> @@ -1072,7 +1072,7 @@ struct bpf_link *usdt_manager_attach_usdt(struct usdt_manager *man, const struct
>>
>>  err_out:
>>         bpf_link__destroy(&link->link);
>> -
>> +link_err:
>>         free(targets);
>>         hashmap__free(specs_hash);
>>         if (elf)
>> --
>> 2.7.4
>>
Thank you for your kindness help. :)

-- 
Haowen Bai

