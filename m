Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F85195F79
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 21:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbgC0URB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 16:17:01 -0400
Received: from www62.your-server.de ([213.133.104.62]:37466 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbgC0URB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 16:17:01 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jHvPR-0006Dt-JP; Fri, 27 Mar 2020 21:16:53 +0100
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jHvPR-000N0M-7Z; Fri, 27 Mar 2020 21:16:53 +0100
Subject: Re: call for bpf progs. Re: [PATCHv2 bpf-next 5/5] selftests: bpf:
 add test for sk_assign
To:     Joe Stringer <joe@wand.net.nz>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin Lau <kafai@fb.com>,
        john fastabend <john.fastabend@gmail.com>
References: <20200325055745.10710-1-joe@wand.net.nz>
 <20200325055745.10710-6-joe@wand.net.nz>
 <82e8d147-b334-3d29-0312-7b087ac908f3@fb.com>
 <CACAyw99Eeu+=yD8UKazRJcknZi3D5zMJ4n=FVsxXi63DwhdxYA@mail.gmail.com>
 <20200326210719.den5isqxntnoqhmv@ast-mbp>
 <CAOftzPjyCNGEjBm4k3aKK+=AB-1STDbYbQK5sZbK6gTAo13XuA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c5e50f60-3872-b3ec-7038-737ca08f3077@iogearbox.net>
Date:   Fri, 27 Mar 2020 21:16:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAOftzPjyCNGEjBm4k3aKK+=AB-1STDbYbQK5sZbK6gTAo13XuA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25764/Fri Mar 27 14:11:26 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/27/20 8:06 PM, Joe Stringer wrote:
> On Thu, Mar 26, 2020 at 2:07 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>> The second concern was pruning, but iirc the experiments were inconclusive.
>> selftests/bpf only has old fb progs. Hence, I think, the step zero is for
>> everyone to contribute their bpf programs written in C. If we have both
>> cilium and cloudflare progs as selftests it will help a lot to guide such long
>> lasting verifier decisions.
> 
> How would you like to handle program changes over time for this?
> 
> In Cilium community we periodically rebuild bpf-next VM images for
> testing, and run every pull request against those images[0]. We also
> test against specific older kernels, currently 4.9 and 4.19. This
> allows us to get some sense for the impact of upstream changes while
> developing Cilium features, but unfortunately doesn't allow everyone
> using kernel selftests to get that feedback at least from the kernel
> tree. We also have a verifier complexity test script where we compile
> with the maximum number of features (to ideally generate the most
> complex programs possible) then attempt to load all of the various
> programs, and output the complexity count that the kernel reports[1,2]
> which we can track over time.
> 
> However Cilium BPF programs are actively developing and even if we
> merge these programs into the kernel tree, they will get out-of-date
> quickly. Up until recently everything was verifying fine compiling
> with LLVM7 and loading into bpf-next. Over the past month we started
> noticing new issues not with the existing implementation, but in *new*
> BPF features. As we increased complexity, our CI started failing
> against bpf-next[3] while they loaded fine on older kernels. We ended
> up mitigating by upgrading to LLVM-10. Long story short, there's
> several moving parts; changing BPF program implementations, changing
> the compiler toolchain, changing the kernel verifier. So my question
> is basically, where's the line of responsibility for what the kernel
> selftests are responsible for vs integration tests? How do we maintain
> those over time as the BPF programs and compiler changes?

I wonder whether it would make sense to create test cases which are based
on our cilium/cilium:latest docker image. Those would be run as part of
BPF kernel selftests as well as part of our own CI for every PR. I think
it could be some basic connectivity test, service mapping, etc with a
bunch of application containers.

One nice thing that just came to mind is that it would actually allow for
easy testing of latest clang/llvm git by rerunning the test script and
remapping them as a volume, e.g.:

   docker run -it -v /root/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-18.04/bin/clang:/bin/clang \
                  -v /root/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-18.04/bin/llc:/bin/llc \
          cilium/cilium:latest /bin/sh

Perhaps that would be more useful and always up to date than a copy of the
code base that would get stale next day? In the end in this context kernel
changes and/or llvm changes might be of interest to check whether anything
potentially blows up, so having a self-contained packaging might be useful.
Thoughts?

> Do we just parachute the ~11K LoC of Cilium datapath into the kernel
> tree once per cycle? Or should Cilium autobuild a verifier-test docker
> image that kernel testing scripts can pull & run? Or would it be
> helpful to have a separate GitHub project similar to libbpf that pulls
> out kernel selftests, Cilium progs, fb progs, cloudflare progs, etc
> automatically and centralizes a generic suite of BPF verifier
> integration tests? Some other option?
> 
> [0] https://github.com/cilium/packer-ci-build
> [1] https://github.com/cilium/cilium/blob/master/test/bpf/check-complexity.sh
> [2] https://github.com/cilium/cilium/blob/master/test/bpf/verifier-test.sh
> [3] https://github.com/cilium/cilium/issues/10517
> 

