Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3E41BE143
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 16:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgD2Ofm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 10:35:42 -0400
Received: from www62.your-server.de ([213.133.104.62]:42142 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727807AbgD2Ofm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 10:35:42 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jTnoI-00042a-RP; Wed, 29 Apr 2020 16:35:38 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jTnoI-0002VG-IC; Wed, 29 Apr 2020 16:35:38 +0200
Subject: Re: [PATCH bpf-next v2 2/3] tools: bpftool: allow unprivileged users
 to probe features
To:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Richard Palethorpe <rpalethorpe@suse.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
References: <20200429130534.11823-1-quentin@isovalent.com>
 <20200429130534.11823-3-quentin@isovalent.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0f883adc-1e8c-4b76-4b4e-98d95081993a@iogearbox.net>
Date:   Wed, 29 Apr 2020 16:35:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200429130534.11823-3-quentin@isovalent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25797/Wed Apr 29 14:06:14 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/20 3:05 PM, Quentin Monnet wrote:
> There is demand for a way to identify what BPF helper functions are
> available to unprivileged users. To do so, allow unprivileged users to
> run "bpftool feature probe" to list BPF-related features. This will only
> show features accessible to those users, and may not reflect the full
> list of features available (to administrators) on the system.
> 
> To avoid the case where bpftool is inadvertently run as non-root and
> would list only a subset of the features supported by the system when it
> would be expected to list all of them, running as unprivileged is gated
> behind the "unprivileged" keyword passed to the command line. When used
> by a privileged user, this keyword allows to drop the CAP_SYS_ADMIN and
> to list the features available to unprivileged users. Note that this
> addsd a dependency on libpcap for compiling bpftool.
> 
> Note that there is no particular reason why the probes were restricted
> to root, other than the fact I did not need them for unprivileged and
> did not bother with the additional checks at the time probes were added.
> 
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>   .../bpftool/Documentation/bpftool-feature.rst |  10 +-
>   tools/bpf/bpftool/Makefile                    |   2 +-
>   tools/bpf/bpftool/bash-completion/bpftool     |   2 +-
>   tools/bpf/bpftool/feature.c                   | 100 +++++++++++++++---
>   4 files changed, 99 insertions(+), 15 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-feature.rst b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
> index b04156cfd7a3..ca085944e4cf 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-feature.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
> @@ -19,7 +19,7 @@ SYNOPSIS
>   FEATURE COMMANDS
>   ================
>   
> -|	**bpftool** **feature probe** [*COMPONENT*] [**full**] [**macros** [**prefix** *PREFIX*]]
> +|	**bpftool** **feature probe** [*COMPONENT*] [**full**] [**unprivileged**] [**macros** [**prefix** *PREFIX*]]
>   |	**bpftool** **feature help**

Looks good to me, thanks! There is one small thing missing which is updating
do_help() to display the same as above from bpftool help, but rest lgtm.
