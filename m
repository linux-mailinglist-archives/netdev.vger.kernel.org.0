Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18DD613D02A
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 23:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730653AbgAOWhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 17:37:19 -0500
Received: from www62.your-server.de ([213.133.104.62]:57334 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729697AbgAOWhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 17:37:19 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1irrHp-0003XL-1w; Wed, 15 Jan 2020 23:37:17 +0100
Received: from [178.197.249.11] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1irrHo-000480-On; Wed, 15 Jan 2020 23:37:16 +0100
Subject: Re: [bpf PATCH v2 0/8] Fixes for sockmap/tls from more complex BPF
 progs
To:     John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, song@kernel.org,
        jonathan.lemon@gmail.com
References: <20200111061206.8028-1-john.fastabend@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5cde124f-9ba4-b178-7fb6-e8340e23faee@iogearbox.net>
Date:   Wed, 15 Jan 2020 23:37:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200111061206.8028-1-john.fastabend@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25696/Wed Jan 15 14:34:23 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/20 7:11 AM, John Fastabend wrote:
> To date our usage of sockmap/tls has been fairly simple, the BPF programs
> did only well-defined pop, push, pull and apply/cork operations.
> 
> Now that we started to push more complex programs into sockmap we uncovered
> a series of issues addressed here. Further OpenSSL3.0 version should be
> released soon with kTLS support so its important to get any remaining
> issues on BPF and kTLS support resolved.
> 
> Additionally, I have a patch under development to allow sockmap to be
> enabled/disabled at runtime for Cilium endpoints. This allows us to stress
> the map insert/delete with kTLS more than previously where Cilium only
> added the socket to the map when it entered ESTABLISHED state and never
> touched it from the control path side again relying on the sockets own
> close() hook to remove it.
> 
> To test I have a set of test cases in test_sockmap.c that expose these
> issues. Once we get fixes here merged and in bpf-next I'll submit the
> tests to bpf-next tree to ensure we don't regress again. Also I've run
> these patches in the Cilium CI with OpenSSL (master branch) this will
> run tools such as netperf, ab, wrk2, curl, etc. to get a broad set of
> testing.
> 
> I'm aware of two more issues that we are working to resolve in another
> couple (probably two) patches. First we see an auth tag corruption in
> kTLS when sending small 1byte chunks under stress. I've not pinned this
> down yet. But, guessing because its under 1B stress tests it must be
> some error path being triggered. And second we need to ensure BPF RX
> programs are not skipped when kTLS ULP is loaded. This breaks some of
> the sockmap selftests when running with kTLS. I'll send a follow up
> for this.
> 
> v2: I dropped a patch that added !0 size check in tls_push_record
>      this originated from a panic I caught awhile ago with a trace
>      in the crypto stack. But I can not reproduce it anymore so will
>      dig into that and send another patch later if needed. Anyways
>      after a bit of thought it would be nicer if tls/crypto/bpf didn't
>      require special case handling for the !0 size.
> 
> John Fastabend (8):
>    bpf: sockmap/tls, during free we may call tcp_bpf_unhash() in loop
>    bpf: sockmap, ensure sock lock held during tear down
>    bpf: sockmap/tls, push write_space updates through ulp updates
>    bpf: sockmap, skmsg helper overestimates push, pull, and pop bounds
>    bpf: sockmap/tls, msg_push_data may leave end mark in place
>    bpf: sockmap/tls, tls_sw can create a plaintext buf > encrypt buf
>    bpf: sockmap/tls, skmsg can have wrapped skmsg that needs extra
>      chaining
>    bpf: sockmap/tls, fix pop data with SK_DROP return code
> 
>   include/linux/skmsg.h | 13 +++++++++----
>   include/net/tcp.h     |  6 ++++--
>   net/core/filter.c     | 11 ++++++-----
>   net/core/skmsg.c      |  2 ++
>   net/core/sock_map.c   |  7 ++++++-
>   net/ipv4/tcp_bpf.c    |  5 +----
>   net/ipv4/tcp_ulp.c    |  6 ++++--
>   net/tls/tls_main.c    | 10 +++++++---
>   net/tls/tls_sw.c      | 31 +++++++++++++++++++++++++++----
>   9 files changed, 66 insertions(+), 25 deletions(-)
> 

Applied, thanks!
