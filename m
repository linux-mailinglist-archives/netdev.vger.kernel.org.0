Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE16595E2A
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 16:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbiHPOOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 10:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiHPOOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 10:14:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834A2AFAF9;
        Tue, 16 Aug 2022 07:14:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FB9561007;
        Tue, 16 Aug 2022 14:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756B3C433C1;
        Tue, 16 Aug 2022 14:14:37 +0000 (UTC)
Date:   Tue, 16 Aug 2022 10:14:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, senozhatsky@chromium.org,
        stern@rowland.harvard.edu, tglx@linutronix.de, vgoyal@redhat.com,
        vkuznets@redhat.com, will@kernel.org,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>
Subject: Re: [PATCH v2 08/13] tracing: Improve panic/die notifiers
Message-ID: <20220816101445.184ebb7c@gandalf.local.home>
In-Reply-To: <20220719195325.402745-9-gpiccoli@igalia.com>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
        <20220719195325.402745-9-gpiccoli@igalia.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jul 2022 16:53:21 -0300
"Guilherme G. Piccoli" <gpiccoli@igalia.com> wrote:


Sorry for the late review, but this fell to the bottom of my queue :-/

> +/*
> + * The idea is to execute the following die/panic callback early, in order
> + * to avoid showing irrelevant information in the trace (like other panic
> + * notifier functions); we are the 2nd to run, after hung_task/rcu_stall
> + * warnings get disabled (to prevent potential log flooding).
> + */
> +static int trace_die_panic_handler(struct notifier_block *self,
> +				unsigned long ev, void *unused)
> +{
> +	if (!ftrace_dump_on_oops)
> +		goto out;
> +
> +	if (self == &trace_die_notifier && ev != DIE_OOPS)
> +		goto out;

I really hate gotos that are not for clean ups.

> +
> +	ftrace_dump(ftrace_dump_on_oops);
> +
> +out:
> +	return NOTIFY_DONE;
> +}
> +

Just do:

static int trace_die_panic_handler(struct notifier_block *self,
				unsigned long ev, void *unused)
{
	if (!ftrace_dump_on_oops)
		return NOTIFY_DONE;

	/* The die notifier requires DIE_OOPS to trigger */
	if (self == &trace_die_notifier && ev != DIE_OOPS)
		return NOTIFY_DONE;

	ftrace_dump(ftrace_dump_on_oops);

	return NOTIFY_DONE;
}


Thanks,

Other than that, Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
