Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A17A267220
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 17:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfGLPPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 11:15:12 -0400
Received: from www62.your-server.de ([213.133.104.62]:45880 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbfGLPPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 11:15:12 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlxGJ-0007bi-K7; Fri, 12 Jul 2019 17:15:03 +0200
Received: from [2a02:1205:5069:fce0:c5f9:cd68:79d4:446d] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlxGJ-000X25-CS; Fri, 12 Jul 2019 17:15:03 +0200
Subject: Re: [PATCH 0/2] Fold checksum at the end of bpf_csum_diff and fix
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Paolo Pisati <p.pisati@gmail.com>
Cc:     20190710231439.GD32439@tassilo.jf.intel.com,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiong Wang <jiong.wang@netronome.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1562837513-745-1-git-send-email-p.pisati@gmail.com>
 <CAEf4BzbGLmuZ48vFUCrDW6VC7_YrkW_0NpgpgXNQEzF_dEqgnA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8bd99845-4d59-f0a4-3b50-ab6d539b36bc@iogearbox.net>
Date:   Fri, 12 Jul 2019 17:15:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzbGLmuZ48vFUCrDW6VC7_YrkW_0NpgpgXNQEzF_dEqgnA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25508/Fri Jul 12 10:10:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/12/2019 01:50 AM, Andrii Nakryiko wrote:
> On Thu, Jul 11, 2019 at 2:32 AM Paolo Pisati <p.pisati@gmail.com> wrote:
>> From: Paolo Pisati <paolo.pisati@canonical.com>
>>
>> After applying patch 0001, all checksum implementations i could test (x86-64, arm64 and
>> arm), now agree on the return value.
>>
>> Patch 0002 fix the expected return value for test #13: i did the calculation manually,
>> and it correspond.
>>
>> Unfortunately, after applying patch 0001, other test cases now fail in
>> test_verifier:

Thanks for catching, sigh. :/

>> $ sudo ./tools/testing/selftests/bpf/test_verifier
>> ...
>> #417/p helper access to variable memory: size = 0 allowed on NULL (ARG_PTR_TO_MEM_OR_NULL) FAIL retval 65535 != 0
>> #419/p helper access to variable memory: size = 0 allowed on != NULL stack pointer (ARG_PTR_TO_MEM_OR_NULL) FAIL retval 65535 != 0
>> #423/p helper access to variable memory: size possible = 0 allowed on != NULL packet pointer (ARG_PTR_TO_MEM_OR_NULL) FAIL retval 65535 != 0
> 
> I'm not entirely sure this fix is correct, given these failures, to be honest.
> 
> Let's wait for someone who understands intended semantics for
> bpf_csum_diff, before changing returned value so drastically.
> 
> But in any case, fixes for these test failures should be in your patch
> series as well.

Your change would actually break applications. The bpf_csum_diff() helper is
heavily used with cascading so one result can be fed into another bpf_csum_diff()
call as seed. Quick test on x86-64:

static int __init foo(void)
{
        u8 data[32 * sizeof(u32)];
        u32 res1, res2, res3;
        int i;

        prandom_bytes(data, sizeof(data));
        res1 = csum_fold(csum_partial(data, sizeof(data), 0));
        for (i = sizeof(u32); i < sizeof(data); i += sizeof(u32)) {
                res2 = csum_fold(csum_partial(data, i, 0));
                res2 = csum_fold(csum_partial(data+i, sizeof(data)-i, res2));
                res3 = csum_partial(data, i, 0);
                res3 = csum_fold(csum_partial(data+i, sizeof(data)-i, res3));
                printk("%8d: [%4x (reference), %4x (unfolded), %4x (folded)]\n", i, res1, res3, res2);
        }
        return -1;
}

Gives for all three:

[19113.233942]        4: [6b70 (reference), 6b70 (unfolded), 223d (folded)]
[19113.233943]        8: [6b70 (reference), 6b70 (unfolded), a812 (folded)]
[19113.233943]       12: [6b70 (reference), 6b70 (unfolded), 1c26 (folded)]
[19113.233944]       16: [6b70 (reference), 6b70 (unfolded), 4f76 (folded)]
[19113.233944]       20: [6b70 (reference), 6b70 (unfolded), 2801 (folded)]
[19113.233945]       24: [6b70 (reference), 6b70 (unfolded),  b63 (folded)]
[19113.233945]       28: [6b70 (reference), 6b70 (unfolded), 2fe0 (folded)]
[19113.233946]       32: [6b70 (reference), 6b70 (unfolded), 18a2 (folded)]
[19113.233946]       36: [6b70 (reference), 6b70 (unfolded), 2597 (folded)]
[19113.233947]       40: [6b70 (reference), 6b70 (unfolded), 2f8e (folded)]
[19113.233947]       44: [6b70 (reference), 6b70 (unfolded), b8af (folded)]
[19113.233948]       48: [6b70 (reference), 6b70 (unfolded), fb8b (folded)]
[19113.233948]       52: [6b70 (reference), 6b70 (unfolded), e9c0 (folded)]
[19113.233949]       56: [6b70 (reference), 6b70 (unfolded), 6af1 (folded)]
[19113.233949]       60: [6b70 (reference), 6b70 (unfolded), d7f4 (folded)]
[19113.233949]       64: [6b70 (reference), 6b70 (unfolded), 8bc6 (folded)]
[19113.233950]       68: [6b70 (reference), 6b70 (unfolded), 8718 (folded)]
[19113.233950]       72: [6b70 (reference), 6b70 (unfolded), 27d8 (folded)]
[19113.233951]       76: [6b70 (reference), 6b70 (unfolded), a2db (folded)]
[19113.233952]       80: [6b70 (reference), 6b70 (unfolded),  3fd (folded)]
[19113.233952]       84: [6b70 (reference), 6b70 (unfolded), 4be5 (folded)]
[19113.233952]       88: [6b70 (reference), 6b70 (unfolded), 41ad (folded)]
[19113.233953]       92: [6b70 (reference), 6b70 (unfolded), ca9b (folded)]
[19113.233953]       96: [6b70 (reference), 6b70 (unfolded), f8ec (folded)]
[19113.233954]      100: [6b70 (reference), 6b70 (unfolded), 5451 (folded)]
[19113.233954]      104: [6b70 (reference), 6b70 (unfolded),  763 (folded)]
[19113.233955]      108: [6b70 (reference), 6b70 (unfolded), e37c (folded)]
[19113.233955]      112: [6b70 (reference), 6b70 (unfolded), 4ee6 (folded)]
[19113.233956]      116: [6b70 (reference), 6b70 (unfolded), 4f73 (folded)]
[19113.233956]      120: [6b70 (reference), 6b70 (unfolded), 1cfd (folded)]
[19113.233957]      124: [6b70 (reference), 6b70 (unfolded), 7d1a (folded)]

I'll take a look next week wrt fixing this uniformly for all archs.

Thanks,
Daniel
