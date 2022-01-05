Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808214855CA
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241438AbiAEPYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:24:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241491AbiAEPYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:24:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10004C061245;
        Wed,  5 Jan 2022 07:24:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C145EB81C24;
        Wed,  5 Jan 2022 15:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DBAC36AE0;
        Wed,  5 Jan 2022 15:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641396281;
        bh=uvTf2jfh+MIhZI5PPr+ElM4TeMYS68HmJo8Y431Rbb8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XLLsY6/rbs/SuZzN5aITI0C9UZVuzQzHpif9Moqjc5iDwu95kw4Hm73Dxa0xDHa6S
         6KuYbA9QF6sCcoolwsAMdFB+RyRMc2TsK7jtJlTkNGpivyufe1kL05FUd9zkL+aVTk
         PadlCRQm1Lmn0xuvTzkux81vSoTMK86po9OpncyY+lci+XYxQn2x/dcyFtACygXDUu
         LwBWA4k536qgB8sTP3kpE4zG3qwo/0jPOPcTS0Gxsihzhk3Cw06qrqMXlrNw68whhh
         Dd9bjgwF9cz5vuDgMs/a8YW357Wi4qvt9BDbrfyzJZeCi70hf0fVgg741RpQI9/ICW
         Bna8M10ILkbMg==
Date:   Thu, 6 Jan 2022 00:24:35 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC 00/13] kprobe/bpf: Add support to attach multiple kprobes
Message-Id: <20220106002435.d73e4010c93462fbee9ef074@kernel.org>
In-Reply-To: <20220104080943.113249-1-jolsa@kernel.org>
References: <20220104080943.113249-1-jolsa@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  4 Jan 2022 09:09:30 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> hi,
> adding support to attach multiple kprobes within single syscall
> and speed up attachment of many kprobes.
> 
> The previous attempt [1] wasn't fast enough, so coming with new
> approach that adds new kprobe interface.

Yes, since register_kprobes() just registers multiple kprobes on
array. This is designed for dozens of kprobes.

> The attachment speed of of this approach (tested in bpftrace)
> is now comparable to ftrace tracer attachment speed.. fast ;-)

Yes, because that if ftrace, not kprobes.

> The limit of this approach is forced by using ftrace as attach
> layer, so it allows only kprobes on function's entry (plus
> return probes).

Note that you also need to multiply the number of instances.

> 
> This patchset contains:
>   - kprobes support to register multiple kprobes with current
>     kprobe API (patches 1 - 8)
>   - bpf support ot create new kprobe link allowing to attach
>     multiple addresses (patches 9 - 14)
> 
> We don't need to care about multiple probes on same functions
> because it's taken care on the ftrace_ops layer.

Hmm, I think there may be a time to split the "kprobe as an 
interface for the software breakpoint" and "kprobe as a wrapper
interface for the callbacks of various instrumentations", like
'raw_kprobe'(or kswbp) and 'kprobes'.
And this may be called as 'fprobe' as ftrace_ops wrapper.
(But if the bpf is enough flexible, this kind of intermediate layer
 may not be needed, it can use ftrace_ops directly, eventually)

Jiri, have you already considered to use ftrace_ops from the
bpf directly? Are there any issues?
(bpf depends on 'kprobe' widely?)

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
