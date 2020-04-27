Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1101BA421
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 14:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgD0M6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 08:58:37 -0400
Received: from www62.your-server.de ([213.133.104.62]:42782 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgD0M6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 08:58:37 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jT3LG-0007xP-CK; Mon, 27 Apr 2020 14:58:34 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jT3LG-000LPn-3h; Mon, 27 Apr 2020 14:58:34 +0200
Subject: Re: [PATCH bpf-next] tools: bpftool: allow unprivileged users to
 probe features
To:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Richard Palethorpe <rpalethorpe@suse.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
References: <20200423160455.28509-1-quentin@isovalent.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <bbde573f-edd8-0d39-556e-98842e0328f7@iogearbox.net>
Date:   Mon, 27 Apr 2020 14:58:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200423160455.28509-1-quentin@isovalent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25795/Mon Apr 27 14:00:10 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/23/20 6:04 PM, Quentin Monnet wrote:
> There is demand for a way to identify what BPF helper functions are
> available to unprivileged users. To do so, allow unprivileged users to
> run "bpftool feature probe" to list BPF-related features. This will only
> show features accessible to those users, and may not reflect the full
> list of features available (to administrators) on the system. For
> non-JSON output, print an informational message stating so at the top of
> the list.
> 
> Note that there is no particular reason why the probes were restricted
> to root, other than the fact I did not need them for unprivileged and
> did not bother with the additional checks at the time probes were added.
> 
> Cc: Richard Palethorpe <rpalethorpe@suse.com>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>   .../bpftool/Documentation/bpftool-feature.rst |  4 +++
>   tools/bpf/bpftool/feature.c                   | 32 +++++++++++++------
>   2 files changed, 26 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-feature.rst b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
> index b04156cfd7a3..313888e87249 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-feature.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
> @@ -49,6 +49,10 @@ DESCRIPTION
>   		  Keyword **kernel** can be omitted. If no probe target is
>   		  specified, probing the kernel is the default behaviour.
>   
> +		  Running this command as an unprivileged user will dump only
> +		  the features available to the user, which usually represent a
> +		  small subset of the parameters supported by the system.
> +

Looks good. I wonder whether the unprivileged should be gated behind an explicit
subcommand e.g. `--unprivileged`. My main worry is that if there's a misconfiguration
the emitted macro/ header file will suddenly contain a lot less defines and it might
go unnoticed if some optimizations in the BPF code are then compiled out by accident.
Maybe it would make sense to have a feature test for libcap and then also allow for
root to check on features for unpriv this way?

>   	**bpftool feature probe dev** *NAME* [**full**] [**macros** [**prefix** *PREFIX*]]
>   		  Probe network device for supported eBPF features and dump
>   		  results to the console.
> diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
> index 88718ee6a438..f455bc5fcc64 100644
> --- a/tools/bpf/bpftool/feature.c
> +++ b/tools/bpf/bpftool/feature.c
> @@ -471,6 +471,11 @@ probe_prog_type(enum bpf_prog_type prog_type, bool *supported_types,
>   		}
>   
>   	res = bpf_probe_prog_type(prog_type, ifindex);
> +	/* Probe may succeed even if program load fails, for unprivileged users
> +	 * check that we did not fail because of insufficient permissions
> +	 */
> +	if (geteuid() && errno == EPERM)
> +		res = false;
>   
>   	supported_types[prog_type] |= res;
>   
