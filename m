Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE461E17DD
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 00:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbgEYWUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 18:20:47 -0400
Received: from www62.your-server.de ([213.133.104.62]:52050 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgEYWUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 18:20:47 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jdLSf-0002Yh-1y; Tue, 26 May 2020 00:20:45 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jdLSe-000DIV-R2; Tue, 26 May 2020 00:20:44 +0200
Subject: Re: [PATCH bpf-next v2] tools: bpftool: make capability check account
 for new BPF caps
To:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
References: <20200523010247.20654-1-quentin@isovalent.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e9dbf916-1c22-29f4-77ef-2a587eca6f2a@iogearbox.net>
Date:   Tue, 26 May 2020 00:20:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200523010247.20654-1-quentin@isovalent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25823/Mon May 25 14:23:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/23/20 3:02 AM, Quentin Monnet wrote:
> Following the introduction of CAP_BPF, and the switch from CAP_SYS_ADMIN
> to other capabilities for various BPF features, update the capability
> checks (and potentially, drops) in bpftool for feature probes. Because
> bpftool and/or the system might not know of CAP_BPF yet, some caution is
> necessary:
> 
> - If compiled and run on a system with CAP_BPF, check CAP_BPF,
>    CAP_SYS_ADMIN, CAP_PERFMON, CAP_NET_ADMIN.
> 
> - Guard against CAP_BPF being undefined, to allow compiling bpftool from
>    latest sources on older systems. If the system where feature probes
>    are run does not know of CAP_BPF, stop checking after CAP_SYS_ADMIN,
>    as this should be the only capability required for all the BPF
>    probing.
> 
> - If compiled from latest sources on a system without CAP_BPF, but later
>    executed on a newer system with CAP_BPF knowledge, then we only test
>    CAP_SYS_ADMIN. Some probes may fail if the bpftool process has
>    CAP_SYS_ADMIN but misses the other capabilities. The alternative would
>    be to redefine the value for CAP_BPF in bpftool, but this does not
>    look clean, and the case sounds relatively rare anyway.
> 
> Note that libcap offers a cap_to_name() function to retrieve the name of
> a given capability (e.g. "cap_sys_admin"). We do not use it because
> deriving the names from the macros looks simpler than using
> cap_to_name() (doing a strdup() on the string) + cap_free() + handling
> the case of failed allocations, when we just want to use the name of the
> capability in an error message.
> 
> The checks when compiling without libcap (i.e. root versus non-root) are
> unchanged.
> 
> v2:
> - Do not allocate cap_list dynamically.
> - Drop BPF-related capabilities when running with "unprivileged", even
>    if we didn't have the full set in the first place (in v1, we would
>    skip dropping them in that case).
> - Keep track of what capabilities we have, print the names of the
>    missing ones for privileged probing.
> - Attempt to drop only the capabilities we actually have.
> - Rename a couple variables.
> 
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>

Applied, thanks!
