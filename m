Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36DE595FB2
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 17:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbiHPPzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 11:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236315AbiHPPzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 11:55:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB7353D12;
        Tue, 16 Aug 2022 08:52:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95E4B61219;
        Tue, 16 Aug 2022 15:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43ABC433C1;
        Tue, 16 Aug 2022 15:52:41 +0000 (UTC)
Date:   Tue, 16 Aug 2022 11:52:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
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
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Sergei Shtylyov <sergei.shtylyov@gmail.com>
Subject: Re: [PATCH v2 08/13] tracing: Improve panic/die notifiers
Message-ID: <20220816115249.66cf8f15@gandalf.local.home>
In-Reply-To: <YvuwUAGi6PvY5kmR@rowland.harvard.edu>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
        <20220719195325.402745-9-gpiccoli@igalia.com>
        <20220816101445.184ebb7c@gandalf.local.home>
        <YvuwUAGi6PvY5kmR@rowland.harvard.edu>
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

On Tue, 16 Aug 2022 10:57:20 -0400
Alan Stern <stern@rowland.harvard.edu> wrote:

> > static int trace_die_panic_handler(struct notifier_block *self,
> > 				unsigned long ev, void *unused)
> > {
> > 	if (!ftrace_dump_on_oops)
> > 		return NOTIFY_DONE;
> > 
> > 	/* The die notifier requires DIE_OOPS to trigger */
> > 	if (self == &trace_die_notifier && ev != DIE_OOPS)
> > 		return NOTIFY_DONE;
> > 
> > 	ftrace_dump(ftrace_dump_on_oops);
> > 
> > 	return NOTIFY_DONE;
> > }  
> 
> Or better yet:
> 
> 	if (ftrace_dump_on_oops) {
> 
> 		/* The die notifier requires DIE_OOPS to trigger */
> 		if (self != &trace_die_notifier || ev == DIE_OOPS)
> 			ftrace_dump(ftrace_dump_on_oops);
> 	}
> 	return NOTIFY_DONE;
> 

That may be more consolidated but less easy to read and follow. This is far
from a fast path.

As I maintain this bike-shed, I prefer the one I suggested ;-)

-- Steve
