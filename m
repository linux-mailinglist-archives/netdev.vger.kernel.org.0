Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3473535263
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 19:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344188AbiEZRFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 13:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236465AbiEZRFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 13:05:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F907B8BCF;
        Thu, 26 May 2022 10:05:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C04FFB821A7;
        Thu, 26 May 2022 17:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66BFC385A9;
        Thu, 26 May 2022 17:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653584732;
        bh=ttHzwS3+6S8DIxLTSpaMeV6rBTKrdyWH2+ueiD9zPlc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xbe6Gj1hwRN5QopnG6IFiIurq0CwPC3mdG3u/S+0mpto2x2Vq2VHu3eDGf6SlcoCr
         WoF9Shyy//0VEjfIFAxbhQJrW9b32gS+MreTVjchsyb84oBV6s2UffWpC+T3xs9VrO
         PdsG0tDJL/hSGsbZMTNm2E4LYv56TY2Gd2cj/wrM=
Date:   Thu, 26 May 2022 10:05:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org
Subject: Re: [PATCH v3] ftrace: Add FTRACE_MCOUNT_MAX_OFFSET to avoid adding
 weak functions
Message-Id: <20220526100530.6ef0a17084f6abab77d8b2ba@linux-foundation.org>
In-Reply-To: <20220526103810.026560dd@gandalf.local.home>
References: <20220526103810.026560dd@gandalf.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 May 2022 10:38:10 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> If an unused weak function was traced, it's call to fentry will still
> exist, which gets added into the __mcount_loc table. Ftrace will use
> kallsyms to retrieve the name for each location in __mcount_loc to display
> it in the available_filter_functions and used to enable functions via the
> name matching in set_ftrace_filter/notrace. Enabling these functions do
> nothing but enable an unused call to ftrace_caller. If a traced weak
> function is overridden, the symbol of the function would be used for it,
> which will either created duplicate names, or if the previous function was
> not traced, it would be incorrectly listed in available_filter_functions
> as a function that can be traced.

This might be dependent on binutils version.  In some situations the
unused __weak function might be dropped altogether.  This change
(https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=d1bcae833b32f1)
tripped up recordmcount
(https://lore.kernel.org/all/20220518181828.645877-1-naveen.n.rao@linux.vnet.ibm.com/T/#u).

The kexec fix will be to just give up on using __weak.

