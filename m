Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270E7485BBD
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 23:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245091AbiAEWgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 17:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245076AbiAEWgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 17:36:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89AEC061245;
        Wed,  5 Jan 2022 14:35:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5810661959;
        Wed,  5 Jan 2022 22:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE562C36AE9;
        Wed,  5 Jan 2022 22:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641422158;
        bh=l2bbx0LHTO/L7P3VNZiHw+zTXDGa08QwMj6L6igP6mE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RO9DTf7DaTyjiuOKLmONBAJT+NldUfWstTr+ddU6H2iac0pttlm9ggh//4D5BpHRb
         WxXjRqGQK9b5IgBiOEqnuqKcl4p/c+qnw/+YtuUCYcYZljA/ucNjG+bS3h7xQFo3W6
         7e4NduV5l69rnONXoCZ+rP2fjAyJZrAVlzzBpyj2/1WTF7Gh0k841OVE9KNhj0AraW
         Ug9JNxQScKhGKYClvTl7eJYttfemI3uN+nhzGIunoAlg+n8k9MbfI4BRJ12Ee5KH4X
         8XyhsOSwJYyfdEqsY/Pt5Tk4Yy2dlDRwfbs1MJCYJxek2penA5kb/m5j0xfF0pKmif
         PHCzbCQadq9vQ==
Date:   Thu, 6 Jan 2022 07:35:54 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     xkernel.wang@foxmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH v2] tracing: check the return value of kstrdup()
Message-Id: <20220106073554.cc42866d46bd8fe4ed7ecd24@kernel.org>
In-Reply-To: <20220105171049.5858901b@gandalf.local.home>
References: <tencent_3C2E330722056D7891D2C83F29C802734B06@qq.com>
        <20220105171049.5858901b@gandalf.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Jan 2022 17:10:49 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Masami, can you ack this ?

Yes, this is actual bug. Thanks for fixing!

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Fixes: 33ea4b24277b ("perf/core: Implement the 'perf_uprobe' PMU")

> 
> -- Steve
> 
> 
> On Tue, 14 Dec 2021 09:28:02 +0800
> xkernel.wang@foxmail.com wrote:
> 
> > From: Xiaoke Wang <xkernel.wang@foxmail.com>
> > 
> > kstrdup() returns NULL when some internal memory errors happen, it is
> > better to check the return value of it so to catch the memory error in
> > time.
> > 
> > Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
> > ---
> > Changelogs:
> > Compare with the last email, this one is using my full name.
> > And I am sorry that I did not notice the bugs in trace_boot.c had been
> > already patched. So I removed the content about trace_boot.c.
> > ---
> >  kernel/trace/trace_uprobe.c | 5 +++++
> >  1 files changed, 5 insertions(+)
> > 
> > diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> > index 225ce56..173ff0f 100644
> > --- a/kernel/trace/trace_uprobe.c
> > +++ b/kernel/trace/trace_uprobe.c
> > @@ -1618,6 +1618,11 @@ create_local_trace_uprobe(char *name, unsigned long offs,
> >  	tu->path = path;
> >  	tu->ref_ctr_offset = ref_ctr_offset;
> >  	tu->filename = kstrdup(name, GFP_KERNEL);
> > +	if (!tu->filename) {
> > +		ret = -ENOMEM;
> > +		goto error;
> > +	}
> > +
> >  	init_trace_event_call(tu);
> >  
> >  	ptype = is_ret_probe(tu) ? PROBE_PRINT_RETURN : PROBE_PRINT_NORMAL;
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
