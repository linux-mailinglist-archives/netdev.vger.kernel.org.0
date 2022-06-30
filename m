Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A53561EEE
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 17:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbiF3PQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 11:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234926AbiF3PQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 11:16:24 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAFE31DEC;
        Thu, 30 Jun 2022 08:16:22 -0700 (PDT)
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o6vtv-000CUa-31; Thu, 30 Jun 2022 17:16:15 +0200
Received: from [2a02:168:f656:0:d16a:7287:ccf0:4fff] (helo=localhost.localdomain)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o6vtu-0006tj-Qf; Thu, 30 Jun 2022 17:16:14 +0200
Subject: Re: [PATCH bpf-next] bpftool: Allow disabling features at compile
 time
To:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220629143951.74851-1-quentin@isovalent.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9ffd4b6b-0073-cfef-5889-cb4d0b838f8e@iogearbox.net>
Date:   Thu, 30 Jun 2022 17:16:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220629143951.74851-1-quentin@isovalent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26589/Thu Jun 30 10:08:14 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/29/22 4:39 PM, Quentin Monnet wrote:
> Some dependencies for bpftool are optional, and the associated features
> may be left aside at compilation time depending on the available
> components on the system (libraries, BTF, clang version, etc.).
> Sometimes, it is useful to explicitly leave some of those features aside
> when compiling, even though the system would support them. For example,
> this can be useful:
> 
>      - for testing bpftool's behaviour when the feature is not present,
>      - for copmiling for a different system, where some libraries are
>        missing,
>      - for producing a lighter binary,
>      - for disabling features that do not compile correctly on older
>        systems - although this is not supposed to happen, this is
>        currently the case for skeletons support on Linux < 5.15, where
>        struct bpf_perf_link is not defined in kernel BTF.
> 
> For such cases, we introduce, in the Makefile, some environment
> variables that can be used to disable those features: namely,
> BPFTOOL_FEATURE_NO_LIBBFD, BPFTOOL_FEATURE_NO_LIBCAP, and
> BPFTOOL_FEATURE_NO_SKELETONS.
> 
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>   tools/bpf/bpftool/Makefile | 20 ++++++++++++++++++--
>   1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index c19e0e4c41bd..b3dd6a1482f6 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -93,8 +93,24 @@ INSTALL ?= install
>   RM ?= rm -f
>   
>   FEATURE_USER = .bpftool
> -FEATURE_TESTS = libbfd disassembler-four-args zlib libcap \
> -	clang-bpf-co-re
> +FEATURE_TESTS := disassembler-four-args zlib
> +
> +# Disable libbfd (for disassembling JIT-compiled programs) by setting
> +# BPFTOOL_FEATURE_NO_LIBBFD
> +ifeq ($(BPFTOOL_FEATURE_NO_LIBBFD),)
> +  FEATURE_TESTS += libbfd
> +endif
> +# Disable libcap (for probing features available to unprivileged users) by
> +# setting BPFTOOL_FEATURE_NO_LIBCAP
> +ifeq ($(BPFTOOL_FEATURE_NO_LIBCAP),)
> +  FEATURE_TESTS += libcap
> +endif

The libcap one I think is not really crucial, so that lgtm. The other ones I would
keep as requirement so we don't encourage distros to strip away needed functionality
for odd reasons. At min, I think the libbfd is a must, imho.

> +# Disable skeletons (e.g. for profiling programs or showing PIDs of processes
> +# associated to BPF objects) by setting BPFTOOL_FEATURE_NO_SKELETONS
> +ifeq ($(BPFTOOL_FEATURE_NO_SKELETONS),)
> +  FEATURE_TESTS += clang-bpf-co-re
> +endif
> +
>   FEATURE_DISPLAY = libbfd disassembler-four-args zlib libcap \
>   	clang-bpf-co-re
>   
> 

