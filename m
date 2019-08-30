Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1395A40EF
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 01:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbfH3XUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 19:20:54 -0400
Received: from www62.your-server.de ([213.133.104.62]:58384 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728208AbfH3XUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 19:20:53 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i3qCI-00049A-KX; Sat, 31 Aug 2019 01:20:50 +0200
Received: from [178.197.249.19] (helo=pc-63.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i3qCI-0007Op-E9; Sat, 31 Aug 2019 01:20:50 +0200
Subject: Re: [PATCH bpf-next v2 0/4] tools: bpftool: improve bpftool build
 experience
To:     Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Lorenz Bauer <lmb@cloudflare.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
References: <20190830110040.31257-1-quentin.monnet@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <238303e7-3d73-cf29-eb04-4a77a5a504fe@iogearbox.net>
Date:   Sat, 31 Aug 2019 01:20:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190830110040.31257-1-quentin.monnet@netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25557/Fri Aug 30 10:30:29 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/30/19 1:00 PM, Quentin Monnet wrote:
> Hi,
> This set attempts to make it easier to build bpftool, in particular when
> passing a specific output directory. This is a follow-up to the
> conversation held last month by Lorenz, Ilya and Jakub [0].
> 
> The first patch is a minor fix to bpftool's Makefile, regarding the
> retrieval of kernel version (which currently prints a non-relevant make
> warning on some invocations).
> 
> Second patch improves the Makefile commands to support more "make"
> invocations, or to fix building with custom output directory. On Jakub's
> suggestion, a script is also added to BPF selftests in order to keep track
> of the supported build variants.
> 
> Building bpftool with "make tools/bpf" from the top of the repository
> generates files in "libbpf/" and "feature/" directories under tools/bpf/
> and tools/bpf/bpftool/. The third patch ensures such directories are taken
> care of on "make clean", and add them to the relevant .gitignore files.
> 
> At last, fourth patch is a sligthly modified version of Ilya's fix
> regarding libbpf.a appearing twice on the linking command for bpftool.
> 
> [0] https://lore.kernel.org/bpf/CACAyw9-CWRHVH3TJ=Tke2x8YiLsH47sLCijdp=V+5M836R9aAA@mail.gmail.com/
> 
> v2:
> - Return error from check script if one of the make invocations returns
>    non-zero (even if binary is successfully produced).
> - Run "make clean" from bpf/ and not only bpf/bpftool/ in that same script,
>    when relevant.
> - Add a patch to clean up generated "feature/" and "libbpf/" directories.
> 
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Cc: Ilya Leoshkevich <iii@linux.ibm.com>
> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
> 
> Quentin Monnet (4):
>    tools: bpftool: ignore make built-in rules for getting kernel version
>    tools: bpftool: improve and check builds for different make
>      invocations
>    tools: bpf: account for generated feature/ and libbpf/ directories
>    tools: bpftool: do not link twice against libbpf.a in Makefile
> 
>   tools/bpf/.gitignore                          |   1 +
>   tools/bpf/Makefile                            |   5 +-
>   tools/bpf/bpftool/.gitignore                  |   2 +
>   tools/bpf/bpftool/Makefile                    |  28 ++--
>   tools/testing/selftests/bpf/Makefile          |   3 +-
>   .../selftests/bpf/test_bpftool_build.sh       | 143 ++++++++++++++++++
>   6 files changed, 167 insertions(+), 15 deletions(-)
>   create mode 100755 tools/testing/selftests/bpf/test_bpftool_build.sh
> 

Applied, thanks!
