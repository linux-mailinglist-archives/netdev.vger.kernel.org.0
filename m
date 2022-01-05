Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6B0485B69
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 23:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244921AbiAEWMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 17:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245029AbiAEWLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 17:11:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92E7C033271;
        Wed,  5 Jan 2022 14:10:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 799B5617D1;
        Wed,  5 Jan 2022 22:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B518C36AEB;
        Wed,  5 Jan 2022 22:10:51 +0000 (UTC)
Date:   Wed, 5 Jan 2022 17:10:49 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     xkernel.wang@foxmail.com
Cc:     mingo@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH v2] tracing: check the return value of kstrdup()
Message-ID: <20220105171049.5858901b@gandalf.local.home>
In-Reply-To: <tencent_3C2E330722056D7891D2C83F29C802734B06@qq.com>
References: <tencent_3C2E330722056D7891D2C83F29C802734B06@qq.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Masami, can you ack this ?

-- Steve


On Tue, 14 Dec 2021 09:28:02 +0800
xkernel.wang@foxmail.com wrote:

> From: Xiaoke Wang <xkernel.wang@foxmail.com>
> 
> kstrdup() returns NULL when some internal memory errors happen, it is
> better to check the return value of it so to catch the memory error in
> time.
> 
> Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
> ---
> Changelogs:
> Compare with the last email, this one is using my full name.
> And I am sorry that I did not notice the bugs in trace_boot.c had been
> already patched. So I removed the content about trace_boot.c.
> ---
>  kernel/trace/trace_uprobe.c | 5 +++++
>  1 files changed, 5 insertions(+)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 225ce56..173ff0f 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -1618,6 +1618,11 @@ create_local_trace_uprobe(char *name, unsigned long offs,
>  	tu->path = path;
>  	tu->ref_ctr_offset = ref_ctr_offset;
>  	tu->filename = kstrdup(name, GFP_KERNEL);
> +	if (!tu->filename) {
> +		ret = -ENOMEM;
> +		goto error;
> +	}
> +
>  	init_trace_event_call(tu);
>  
>  	ptype = is_ret_probe(tu) ? PROBE_PRINT_RETURN : PROBE_PRINT_NORMAL;

