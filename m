Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4096514A31C
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 12:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730130AbgA0LhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 06:37:07 -0500
Received: from www62.your-server.de ([213.133.104.62]:50590 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbgA0LhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 06:37:07 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iw2H7-0000Fy-9E; Mon, 27 Jan 2020 12:09:49 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iw2H6-00054j-PT; Mon, 27 Jan 2020 12:09:48 +0100
Subject: Re: [PATCH] selftests/bpf: Elide a check for LLVM versions that can't
 compile it
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     shuah@kernel.org, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, kernel-team@android.com,
        Jesper Dangaard Brouer <brouer@redhat.com>
References: <20200124180839.185837-1-palmerdabbelt@google.com>
 <87ftg4fvmo.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dcbed741-a16f-0057-6589-e2d2e41e9bfc@iogearbox.net>
Date:   Mon, 27 Jan 2020 12:09:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87ftg4fvmo.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25707/Sun Jan 26 12:40:28 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/20 9:27 PM, Toke Høiland-Jørgensen wrote:
> Palmer Dabbelt <palmerdabbelt@google.com> writes:
> 
>> The current stable LLVM BPF backend fails to compile the BPF selftests
>> due to a compiler bug.  The bug has been fixed in trunk, but that fix
>> hasn't landed in the binary packages I'm using yet (Fedora arm64).
>> Without this workaround the tests don't compile for me.
>>
>> This patch triggers a preprocessor warning on LLVM versions that
>> definitely have the bug.  The test may be conservative (ie, I'm not sure
>> if 9.1 will have the fix), but it should at least make the current set
>> of stable releases work together.
>>
>> See https://reviews.llvm.org/D69438 for more information on the fix.  I
>> obtained the workaround from
>> https://lore.kernel.org/linux-kselftest/aed8eda7-df20-069b-ea14-f06628984566@gmail.com/T/
>>
>> Fixes: 20a9ad2e7136 ("selftests/bpf: add CO-RE relocs array tests")
>> Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
> 
> Having to depend on the latest trunk llvm to compile the selftests is
> definitely unfortunate. I believe there are some tests that won't work
> at all without trunk llvm (the fentry/fexit stuff comes to mind;
> although I'm not sure if they'll fail to compile, just fail to run?).
> Could we extend this type of checking to any such case?

Yeah, Palmer, are you saying that with this fix you're able to run through
all of the BPF test suite on bpf-next with clang/llvm 9.0?

So far policy has been that tests run always on latest trunk to also cover
llvm changes in BPF backend to make sure there are no regressions there. OT:
perhaps we should have a 'make deps' target in BPF selftests to make it easier
for developers to spin up a latest test env to run selftests in.
