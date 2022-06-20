Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7752551932
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 14:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240227AbiFTMnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 08:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233887AbiFTMn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 08:43:27 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42445F9F;
        Mon, 20 Jun 2022 05:43:25 -0700 (PDT)
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o3GkV-0004H2-Co; Mon, 20 Jun 2022 14:43:23 +0200
Received: from [2a02:168:f656:0:d16a:7287:ccf0:4fff] (helo=localhost.localdomain)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o3GkU-000RhI-UM; Mon, 20 Jun 2022 14:43:22 +0200
Subject: Re: [PATCHv5 bpf-next 1/1] perf tools: Rework prologue generation
 code
To:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     linux-perf-users@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>
References: <20220616202214.70359-1-jolsa@kernel.org>
 <20220616202214.70359-2-jolsa@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <72122b4e-1056-7392-f9eb-6ea4c0a79529@iogearbox.net>
Date:   Mon, 20 Jun 2022 14:43:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220616202214.70359-2-jolsa@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26578/Mon Jun 20 10:06:11 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/16/22 10:22 PM, Jiri Olsa wrote:
> Some functions we use for bpf prologue generation are going to be
> deprecated. This change reworks current code not to use them.
> 
> We need to replace following functions/struct:
>     bpf_program__set_prep
>     bpf_program__nth_fd
>     struct bpf_prog_prep_result
> 
> Currently we use bpf_program__set_prep to hook perf callback before
> program is loaded and provide new instructions with the prologue.
> 
> We replace this function/ality by taking instructions for specific
> program, attaching prologue to them and load such new ebpf programs
> with prologue using separate bpf_prog_load calls (outside libbpf
> load machinery).
> 
> Before we can take and use program instructions, we need libbpf to
> actually load it. This way we get the final shape of its instructions
> with all relocations and verifier adjustments).
> 
> There's one glitch though.. perf kprobe program already assumes
> generated prologue code with proper values in argument registers,
> so loading such program directly will fail in the verifier.
> 
> That's where the fallback pre-load handler fits in and prepends
> the initialization code to the program. Once such program is loaded
> we take its instructions, cut off the initialization code and prepend
> the prologue.
> 
> I know.. sorry ;-)
> 
> To have access to the program when loading this patch adds support to
> register 'fallback' section handler to take care of perf kprobe programs.
> The fallback means that it handles any section definition besides the
> ones that libbpf handles.
> 
> The handler serves two purposes:
>    - allows perf programs to have special arguments in section name
>    - allows perf to use pre-load callback where we can attach init
>      code (zeroing all argument registers) to each perf program
> 
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Hey Arnaldo, if you get a chance, please take a look.

Thanks a lot,
Daniel
