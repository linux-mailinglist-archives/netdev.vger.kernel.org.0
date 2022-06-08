Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F577543750
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 17:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244395AbiFHP0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 11:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244543AbiFHP0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 11:26:10 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FAB13F439;
        Wed,  8 Jun 2022 08:22:39 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nyxW0-00004u-8F; Wed, 08 Jun 2022 17:22:36 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nyxVz-000O7y-Rn; Wed, 08 Jun 2022 17:22:35 +0200
Subject: Re: [PATCH v2 1/1] libbpf: replace typeof with __typeof__
To:     James Hilliard <james.hilliard1@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20220608064004.1493239-1-james.hilliard1@gmail.com>
 <b05401b0-308e-03a2-af94-4ecc5322fd1f@iogearbox.net>
 <CADvTj4pUd2zH8M6BBQGVf9C3dpfhfFEN9ogwKXODj+sarzqPcg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3230febd-d346-8348-76e7-b9548f01cb87@iogearbox.net>
Date:   Wed, 8 Jun 2022 17:22:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CADvTj4pUd2zH8M6BBQGVf9C3dpfhfFEN9ogwKXODj+sarzqPcg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26566/Wed Jun  8 10:05:45 2022)
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/8/22 3:04 PM, James Hilliard wrote:
> On Wed, Jun 8, 2022 at 6:50 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 6/8/22 8:40 AM, James Hilliard wrote:
>>> It seems the gcc preprocessor breaks when typeof is used with
>>> macros.
>>>
>>> Fixes errors like:
>>> error: expected identifier or '(' before '#pragma'
>>>     106 | SEC("cgroup/bind6")
>>>         | ^~~
>>>
>>> error: expected '=', ',', ';', 'asm' or '__attribute__' before '#pragma'
>>>     114 | char _license[] SEC("license") = "GPL";
>>>         | ^~~
>>>
>>> Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
>>> ---
>>> Changes v1 -> v2:
>>>     - replace typeof with __typeof__ instead of changing pragma macros
>>> ---
>>>    tools/lib/bpf/bpf_core_read.h   | 16 ++++++++--------
>>>    tools/lib/bpf/bpf_helpers.h     |  4 ++--
>>>    tools/lib/bpf/bpf_tracing.h     | 24 ++++++++++++------------
>>>    tools/lib/bpf/btf.h             |  4 ++--
>>>    tools/lib/bpf/libbpf_internal.h |  6 +++---
>>>    tools/lib/bpf/usdt.bpf.h        |  6 +++---
>>>    tools/lib/bpf/xsk.h             | 12 ++++++------
>>>    7 files changed, 36 insertions(+), 36 deletions(-)
>>>
>>> diff --git a/tools/lib/bpf/bpf_core_read.h b/tools/lib/bpf/bpf_core_read.h
>>> index fd48b1ff59ca..d3a88721c9e7 100644
>>> --- a/tools/lib/bpf/bpf_core_read.h
>>> +++ b/tools/lib/bpf/bpf_core_read.h
>>> @@ -111,7 +111,7 @@ enum bpf_enum_value_kind {
>>>    })
>>>
>>>    #define ___bpf_field_ref1(field)    (field)
>>> -#define ___bpf_field_ref2(type, field)       (((typeof(type) *)0)->field)
>>> +#define ___bpf_field_ref2(type, field)       (((__typeof__(type) *)0)->field)
>>>    #define ___bpf_field_ref(args...)                                       \
>>>        ___bpf_apply(___bpf_field_ref, ___bpf_narg(args))(args)
>>>
>>
>> Can't we just add the below?
>>
>> #ifndef typeof
>> # define typeof __typeof__
>> #endif
> 
>  From what I can tell it's not actually missing, but rather is
> preprocessed differently
> as the errors seem to be macro related.

Are you saying that the above suggestion wouldn't work? Do you have some more
details? I'm mainly wondering if there's a way where we could prevent letting
typeof() usage slip through in future given from kernel side people are used
to it.

> I did also find this change which seems related:
> https://github.com/torvalds/linux/commit/8faf7fc597d59b142af41ddd4a2d59485f75f88a
> 
>>
>> Thanks,
>> Daniel

