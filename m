Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3398148D8B3
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 14:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbiAMNSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 08:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbiAMNSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 08:18:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED11C06173F;
        Thu, 13 Jan 2022 05:18:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AD2161CBF;
        Thu, 13 Jan 2022 13:18:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C56C36AEC;
        Thu, 13 Jan 2022 13:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642079930;
        bh=lMkWyLlAlXOZIe4Kwuf6/+sc7/oLafybf89vU4uIgeI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y5IbiB8W8SRoLO0l6HK+RQn6J3ptj4Wu1Gl8zh57OojMkHSWf9xuUQ/BXNJXD1X9p
         rqtJ9QT40y2NOhXLOnS15P50BgLIlOuAISAG6ZNVQHYPfv3umikHeDO/Ie82Gd9Sw4
         K6chRQnd7RXcGZ47AObJzyzQsYz+F3Y0cpDqsOkHPWpWF/O+kfTEMzyhVrR6uujL74
         mGuNBKhYLYKHPNgRk/qZOQkcPvw2h0b4FLizFCWnWBnXIBnKxJ3ZmU3/fA3wijmmtr
         tRQ50ievPyPmmJhdeXcTeKpkQrxUitKXDeVTj97CKJXjOWqpNB8FKftsbXiN8QHnM5
         BjMVTnntIaiKg==
Date:   Thu, 13 Jan 2022 22:18:45 +0900
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
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH v2 0/8] fprobe: Introduce fprobe function entry/exit
 probe
Message-Id: <20220113221845.1d4564212fe401ad3d624d0d@kernel.org>
In-Reply-To: <YeAatqQTKsrxmUkS@krava>
References: <164199616622.1247129.783024987490980883.stgit@devnote2>
        <Yd77SYWgtrkhFIYz@krava>
        <YeAatqQTKsrxmUkS@krava>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jan 2022 13:27:34 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> On Wed, Jan 12, 2022 at 05:01:15PM +0100, Jiri Olsa wrote:
> > On Wed, Jan 12, 2022 at 11:02:46PM +0900, Masami Hiramatsu wrote:
> > > Hi Jiri and Alexei,
> > > 
> > > Here is the 2nd version of fprobe. This version uses the
> > > ftrace_set_filter_ips() for reducing the registering overhead.
> > > Note that this also drops per-probe point private data, which
> > > is not used anyway.
> > > 
> > > This introduces the fprobe, the function entry/exit probe with
> > > multiple probe point support. This also introduces the rethook
> > > for hooking function return as same as kretprobe does. This
> > 
> > nice, I was going through the multi-user-graph support 
> > and was wondering that this might be a better way
> > 
> > > abstraction will help us to generalize the fgraph tracer,
> > > because we can just switch it from rethook in fprobe, depending
> > > on the kernel configuration.
> > > 
> > > The patch [1/8] and [7/8] are from your series[1]. Other libbpf
> > > patches will not be affected by this change.
> > 
> > I'll try the bpf selftests on top of this
> 
> I'm getting crash and stall when running bpf selftests,
> the fprobe sample module works fine, I'll check on that

Hmm, would you mean tools/testing/selftests/bpf/prog_tests/ ?
Let me check it too.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
