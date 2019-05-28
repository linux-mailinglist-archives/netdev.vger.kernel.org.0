Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46C022C322
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfE1J1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:27:09 -0400
Received: from www62.your-server.de ([213.133.104.62]:38292 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbfE1J1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 05:27:09 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hVYNu-0007zl-Nl; Tue, 28 May 2019 11:27:06 +0200
Received: from [178.197.249.12] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hVYNu-000SH9-Gg; Tue, 28 May 2019 11:27:06 +0200
Subject: Re: [PATCH bpf-next v3 0/3] tools: bpftool: add an option for debug
 output from libbpf and verifier
To:     Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
References: <20190524103648.15669-1-quentin.monnet@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <862b6e54-5386-8bce-f672-eb6a25874a22@iogearbox.net>
Date:   Tue, 28 May 2019 11:27:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190524103648.15669-1-quentin.monnet@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25463/Tue May 28 09:57:22 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/24/2019 12:36 PM, Quentin Monnet wrote:
> Hi,
> This series adds an option to bpftool to make it print additional
> information via libbpf and the kernel verifier when attempting to load
> programs.
> 
> A new API function is added to libbpf in order to pass the log_level from
> bpftool with the bpf_object__* part of the API.
> 
> Options for a finer control over the log levels to use for libbpf and the
> verifier could be added in the future, if desired.
> 
> v3:
> - Fix and clarify commit logs.
> 
> v2:
> - Do not add distinct options for libbpf and verifier logs, just keep the
>   one that sets all log levels to their maximum. Rename the option.
> - Do not offer a way to pick desired log levels. The choice is "use the
>   option to print all logs" or "stick with the defaults".
> - Do not export BPF_LOG_* flags to user header.
> - Update all man pages (most bpftool operations use libbpf and may print
>   libbpf logs). Verifier logs are only used when attempting to load
>   programs for now, so bpftool-prog.rst and bpftool.rst remain the only
>   pages updated in that regard.
> 
> Previous discussion available at:
> https://lore.kernel.org/bpf/20190523105426.3938-1-quentin.monnet@netronome.com/
> https://lore.kernel.org/bpf/20190429095227.9745-1-quentin.monnet@netronome.com/
> 
> Quentin Monnet (3):
>   tools: bpftool: add -d option to get debug output from libbpf
>   libbpf: add bpf_object__load_xattr() API function to pass log_level
>   tools: bpftool: make -d option print debug output from verifier
> 
>  .../bpf/bpftool/Documentation/bpftool-btf.rst |  4 +++
>  .../bpftool/Documentation/bpftool-cgroup.rst  |  4 +++
>  .../bpftool/Documentation/bpftool-feature.rst |  4 +++
>  .../bpf/bpftool/Documentation/bpftool-map.rst |  4 +++
>  .../bpf/bpftool/Documentation/bpftool-net.rst |  4 +++
>  .../bpftool/Documentation/bpftool-perf.rst    |  4 +++
>  .../bpftool/Documentation/bpftool-prog.rst    |  5 ++++
>  tools/bpf/bpftool/Documentation/bpftool.rst   |  4 +++
>  tools/bpf/bpftool/bash-completion/bpftool     |  2 +-
>  tools/bpf/bpftool/main.c                      | 16 ++++++++++-
>  tools/bpf/bpftool/main.h                      |  1 +
>  tools/bpf/bpftool/prog.c                      | 27 ++++++++++++-------
>  tools/lib/bpf/Makefile                        |  2 +-
>  tools/lib/bpf/libbpf.c                        | 20 +++++++++++---
>  tools/lib/bpf/libbpf.h                        |  6 +++++
>  tools/lib/bpf/libbpf.map                      |  5 ++++
>  16 files changed, 96 insertions(+), 16 deletions(-)
> 

Applied, thanks!
