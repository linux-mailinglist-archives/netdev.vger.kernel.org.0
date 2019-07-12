Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABBDB670B0
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 15:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbfGLN5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 09:57:09 -0400
Received: from www62.your-server.de ([213.133.104.62]:59714 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbfGLN5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 09:57:08 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlw2p-0001y6-61; Fri, 12 Jul 2019 15:57:03 +0200
Received: from [2a02:1205:5069:fce0:c5f9:cd68:79d4:446d] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlw2o-000Qyn-UD; Fri, 12 Jul 2019 15:57:02 +0200
Subject: Re: [PATCH bpf-next] selftests/bpf: remove logic duplication in
 test_verifier.c
To:     Krzesimir Nowak <krzesimir@kinvolk.io>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
References: <20190711010844.1285018-1-andriin@fb.com>
 <CAGGp+cETuvWUwET=6Mq5sWTJhi5+Rs2bw8xNP2NYZXAAuc6-Og@mail.gmail.com>
 <CAEf4Bzb1kE_jCbyye07-pVMT=914_Nrdh+R=QXA2qMssYP5brA@mail.gmail.com>
 <CAGGp+cHaV1EMXqeQvKN-p5gEZWcSgGfcbKimcS+C8u=dfeU=1Q@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d6ff6022-56f7-de63-d3e1-8949360296ca@iogearbox.net>
Date:   Fri, 12 Jul 2019 15:57:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CAGGp+cHaV1EMXqeQvKN-p5gEZWcSgGfcbKimcS+C8u=dfeU=1Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25508/Fri Jul 12 10:10:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/12/2019 09:53 AM, Krzesimir Nowak wrote:
> On Thu, Jul 11, 2019 at 4:43 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
>>
>> On Thu, Jul 11, 2019 at 5:13 AM Krzesimir Nowak <krzesimir@kinvolk.io> wrote:
>>>
>>> On Thu, Jul 11, 2019 at 3:08 AM Andrii Nakryiko <andriin@fb.com> wrote:
>>>>
>>>> test_verifier tests can specify single- and multi-runs tests. Internally
>>>> logic of handling them is duplicated. Get rid of it by making single run
>>>> retval specification to be a first retvals spec.
>>>>
>>>> Cc: Krzesimir Nowak <krzesimir@kinvolk.io>
>>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>>
>>> Looks good, one nit below.
>>>
>>> Acked-by: Krzesimir Nowak <krzesimir@kinvolk.io>
>>>
>>>> ---
>>>>  tools/testing/selftests/bpf/test_verifier.c | 37 ++++++++++-----------
>>>>  1 file changed, 18 insertions(+), 19 deletions(-)
>>>>
>>>> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
>>>> index b0773291012a..120ecdf4a7db 100644
>>>> --- a/tools/testing/selftests/bpf/test_verifier.c
>>>> +++ b/tools/testing/selftests/bpf/test_verifier.c
>>>> @@ -86,7 +86,7 @@ struct bpf_test {
>>>>         int fixup_sk_storage_map[MAX_FIXUPS];
>>>>         const char *errstr;
>>>>         const char *errstr_unpriv;
>>>> -       uint32_t retval, retval_unpriv, insn_processed;
>>>> +       uint32_t insn_processed;
>>>>         int prog_len;
>>>>         enum {
>>>>                 UNDEF,
>>>> @@ -95,16 +95,24 @@ struct bpf_test {
>>>>         } result, result_unpriv;
>>>>         enum bpf_prog_type prog_type;
>>>>         uint8_t flags;
>>>> -       __u8 data[TEST_DATA_LEN];
>>>>         void (*fill_helper)(struct bpf_test *self);
>>>>         uint8_t runs;
>>>> -       struct {
>>>> -               uint32_t retval, retval_unpriv;
>>>> -               union {
>>>> -                       __u8 data[TEST_DATA_LEN];
>>>> -                       __u64 data64[TEST_DATA_LEN / 8];
>>>> +       union {
>>>> +               struct {
>>>
>>> Maybe consider moving the struct definition outside to further the
>>> removal of the duplication?
>>
>> Can't do that because then retval/retval_unpriv/data won't be
>> accessible as a normal field of struct bpf_test. It has to be in
>> anonymous structs/unions, unfortunately.
>>
> 
> Ah, right.
> 
> Meh.
> 
> I tried something like this:
> 
> #define BPF_DATA_STRUCT \
>     struct { \
>         uint32_t retval, retval_unpriv; \
>         union { \
>             __u8 data[TEST_DATA_LEN]; \
>             __u64 data64[TEST_DATA_LEN / 8]; \
>         }; \
>     }
> 
> and then:
> 
>     union {
>         BPF_DATA_STRUCT;
>         BPF_DATA_STRUCT retvals[MAX_TEST_RUNS];
>     };
> 
> And that seems to compile at least. But question is: is this
> acceptably ugly or unacceptably ugly? :)

Both a bit ugly, but I'd have a slight preference towards the above,
perhaps a bit more readable like:

#define bpf_testdata_struct_t                                   \
        struct {                                                \
                uint32_t retval, retval_unpriv;                 \
                union {                                         \
                        __u8 data[TEST_DATA_LEN];               \
                        __u64 data64[TEST_DATA_LEN / 8];        \
                };                                              \
        }
        union {
                bpf_testdata_struct_t;
                bpf_testdata_struct_t retvals[MAX_TEST_RUNS];
        };

Thanks,
Daniel
