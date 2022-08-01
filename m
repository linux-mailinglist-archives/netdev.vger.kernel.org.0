Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3CFA586FB6
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 19:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbiHARoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 13:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232441AbiHARox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 13:44:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DA81D310;
        Mon,  1 Aug 2022 10:44:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92AFBB80FE4;
        Mon,  1 Aug 2022 17:44:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168A8C433C1;
        Mon,  1 Aug 2022 17:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659375890;
        bh=QhdcxiP5hdvFcT0P+oIqjmgTAl2ERTJ0dwKan59w/Uk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gFXqWJi7SSrIKziZD8EfWQIpIaS4i5ooXDPtWEHp+Ej3aRu9x4Q9w0+YniUs2qcFl
         KtH8KZJ9iamwCFgIKFOo73UFO054zxN81qXKyF6R1PHWEPUdED2eSy1m9V1r1UzmU8
         /NMpNFFRzBGybWRxEojYpjm5GULfABOCJd1SdupgcDpi37z5rE62bdo5wNKPYFKhlq
         k8CKwC5vmWKLik0FwYzTuWy2Iy9WdpejX9opgamNpKIK8yTOWZUUvi9jd15vendvod
         0HgcWCaNKz8Csn+J4JW2YQw3lQ7EtJIndQ7DUPWYDh5jeJVTkF93NEHvkybXAEmoSi
         /NYnpXOLk8Z2Q==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 8F1C840736; Mon,  1 Aug 2022 14:44:47 -0300 (-03)
Date:   Mon, 1 Aug 2022 14:44:47 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        linux-perf-users@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>
Subject: Re: [PATCHv5 bpf-next 1/1] perf tools: Rework prologue generation
 code
Message-ID: <YugRD0jmlT3p4GNK@kernel.org>
References: <20220616202214.70359-1-jolsa@kernel.org>
 <20220616202214.70359-2-jolsa@kernel.org>
 <72122b4e-1056-7392-f9eb-6ea4c0a79529@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72122b4e-1056-7392-f9eb-6ea4c0a79529@iogearbox.net>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, Jun 20, 2022 at 02:43:22PM +0200, Daniel Borkmann escreveu:
> On 6/16/22 10:22 PM, Jiri Olsa wrote:
> > Some functions we use for bpf prologue generation are going to be
> > deprecated. This change reworks current code not to use them.
> > 
> > We need to replace following functions/struct:
> >     bpf_program__set_prep
> >     bpf_program__nth_fd
> >     struct bpf_prog_prep_result
> > 
> > Currently we use bpf_program__set_prep to hook perf callback before
> > program is loaded and provide new instructions with the prologue.
> > 
> > We replace this function/ality by taking instructions for specific
> > program, attaching prologue to them and load such new ebpf programs
> > with prologue using separate bpf_prog_load calls (outside libbpf
> > load machinery).
> > 
> > Before we can take and use program instructions, we need libbpf to
> > actually load it. This way we get the final shape of its instructions
> > with all relocations and verifier adjustments).
> > 
> > There's one glitch though.. perf kprobe program already assumes
> > generated prologue code with proper values in argument registers,
> > so loading such program directly will fail in the verifier.
> > 
> > That's where the fallback pre-load handler fits in and prepends
> > the initialization code to the program. Once such program is loaded
> > we take its instructions, cut off the initialization code and prepend
> > the prologue.
> > 
> > I know.. sorry ;-)
> > 
> > To have access to the program when loading this patch adds support to
> > register 'fallback' section handler to take care of perf kprobe programs.
> > The fallback means that it handles any section definition besides the
> > ones that libbpf handles.
> > 
> > The handler serves two purposes:
> >    - allows perf programs to have special arguments in section name
> >    - allows perf to use pre-load callback where we can attach init
> >      code (zeroing all argument registers) to each perf program
> > 
> > Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> Hey Arnaldo, if you get a chance, please take a look.

Sry, applied.

- Arnaldo
