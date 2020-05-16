Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFE71D5D83
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 03:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgEPBCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 21:02:42 -0400
Received: from www62.your-server.de ([213.133.104.62]:55712 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgEPBCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 21:02:41 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZlDr-0004n3-DS; Sat, 16 May 2020 03:02:39 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZlDr-00078q-5W; Sat, 16 May 2020 03:02:39 +0200
Subject: Re: [bpf-next PATCH v2 00/12] bpf: selftests, test_sockmap
 improvements
To:     John Fastabend <john.fastabend@gmail.com>, lmb@cloudflare.com,
        jakub@cloudflare.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org
References: <158939706939.15176.10993188758954570904.stgit@john-Precision-5820-Tower>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b2233fba-09b0-a530-780e-c8ed238c6dee@iogearbox.net>
Date:   Sat, 16 May 2020 03:02:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <158939706939.15176.10993188758954570904.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25813/Fri May 15 14:16:29 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/20 9:12 PM, John Fastabend wrote:
> Note: requires fixes listed below to be merged into bpf-next before
>        applied.
> 
> Update test_sockmap to add ktls tests and in the process make output
> easier to understand and reduce overall runtime significantly. Before
> this series test_sockmap did a poor job of tracking sent bytes causing
> the recv thread to wait for a timeout even though all expected bytes
> had been received. Doing this many times causes significant delays.
> Further, we did many redundant tests because the send/recv test we used
> was not specific to the parameters we were testing. For example testing
> a failure case that always fails many times with different send sizes
> is mostly useless. If the test condition catches 10B in the kernel code
> testing 100B, 1kB, 4kB, and so on is just noise.
> 
> The main motivation for this is to add ktls tests, the last patch. Until
> now I have been running these locally but we haven't had them checked in
> to selftests. And finally I'm hoping to get these pushed into the libbpf
> test infrastructure so we can get more testing. For that to work we need
> ability to white and blacklist tests based on kernel features so we add
> that here as well.
> 
> The new output looks like this broken into test groups with subtest
> counters,
> 
>   $ time sudo ./test_sockmap
>   # 1/ 6  sockmap:txmsg test passthrough:OK
>   # 2/ 6  sockmap:txmsg test redirect:OK
>   ...
>   #22/ 1 sockhash:txmsg test push/pop data:OK
>   Pass: 22 Fail: 0
> 
>   real    0m9.790s
>   user    0m0.093s
>   sys     0m7.318s
> 
> The old output printed individual subtest and was rather noisy
> 
>   $ time sudo ./test_sockmap
>   [TEST 0]: (1, 1, 1, sendmsg, pass,): PASS
>   ...
>   [TEST 823]: (16, 1, 100, sendpage, ... ,pop (1599,1609),): PASS
>   Summary: 824 PASSED 0 FAILED
> 
>   real    0m56.761s
>   user    0m0.455s
>   sys     0m31.757s
> 
> So we are able to reduce time from ~56s to ~10s. To recover older more
> verbose output simply run with --verbose option. To whitelist and
> blacklist tests use the new --whitelist and --blacklist flags added. For
> example to run cork sockhash tests but only ones that don't have a receive
> hang (used to test negative cases) we could do,
> 
>   $ ./test_sockmap --whitelist="cork" --blacklist="sockmap,hang"
> 
> Requires these two fixes from net tree,
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=3e104c23816220919ea1b3fd93fabe363c67c484
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=81aabbb9fb7b4b1efd073b62f0505d3adad442f3
> 
> v1->v2: Addressed Jakub's comments, exit to _exit and strerror typo.
>          Added Jakubs Reviewed-by tag, Thanks!
> 
> ---
> 
> John Fastabend (12):
>        bpf: sockmap, msg_pop_data can incorrecty set an sge length
>        bpf: sockmap, bpf_tcp_ingress needs to subtract bytes from sg.size
>        bpf: selftests, move sockmap bpf prog header into progs
>        bpf: selftests, remove prints from sockmap tests
>        bpf: selftests, sockmap test prog run without setting cgroup
>        bpf: selftests, print error in test_sockmap error cases
>        bpf: selftests, improve test_sockmap total bytes counter
>        bpf: selftests, break down test_sockmap into subtests
>        bpf: selftests, provide verbose option for selftests execution
>        bpf: selftests, add whitelist option to test_sockmap
>        bpf: selftests, add blacklist to test_sockmap
>        bpf: selftests, add ktls tests to test_sockmap
> 
> 
>   .../selftests/bpf/progs/test_sockmap_kern.h        |  299 +++++++
>   tools/testing/selftests/bpf/test_sockmap.c         |  913 ++++++++++----------
>   tools/testing/selftests/bpf/test_sockmap_kern.h    |  451 ----------
>   3 files changed, 770 insertions(+), 893 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_kern.h
>   delete mode 100644 tools/testing/selftests/bpf/test_sockmap_kern.h

Applied 3-12, thanks!
