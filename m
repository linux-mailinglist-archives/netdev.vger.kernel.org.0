Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B065222AD
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 19:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348230AbiEJRde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 13:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348194AbiEJRd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 13:33:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4435229ED3C;
        Tue, 10 May 2022 10:29:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFAFB61929;
        Tue, 10 May 2022 17:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2BFC385C2;
        Tue, 10 May 2022 17:29:23 +0000 (UTC)
Date:   Tue, 10 May 2022 13:29:22 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Xiaoming Ni <nixiaoming@huawei.com>
Cc:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        <akpm@linux-foundation.org>, <bhe@redhat.com>, <pmladek@suse.com>,
        <kexec@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>,
        <coresight@lists.linaro.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-alpha@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-edac@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
        <linux-leds@vger.kernel.org>, <linux-mips@vger.kernel.org>,
        <linux-parisc@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-remoteproc@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-um@lists.infradead.org>,
        <linux-xtensa@linux-xtensa.org>, <netdev@vger.kernel.org>,
        <openipmi-developer@lists.sourceforge.net>, <rcu@vger.kernel.org>,
        <sparclinux@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <x86@kernel.org>, <kernel-dev@igalia.com>, <kernel@gpiccoli.net>,
        <halves@canonical.com>, <fabiomirmar@gmail.com>,
        <alejandro.j.jimenez@oracle.com>,
        <andriy.shevchenko@linux.intel.com>, <arnd@arndb.de>,
        <bp@alien8.de>, <corbet@lwn.net>, <d.hatayama@jp.fujitsu.com>,
        <dave.hansen@linux.intel.com>, <dyoung@redhat.com>,
        <feng.tang@intel.com>, <gregkh@linuxfoundation.org>,
        <mikelley@microsoft.com>, <hidehiro.kawai.ez@hitachi.com>,
        <jgross@suse.com>, <john.ogness@linutronix.de>,
        <keescook@chromium.org>, <luto@kernel.org>, <mhiramat@kernel.org>,
        <mingo@redhat.com>, <paulmck@kernel.org>, <peterz@infradead.org>,
        <senozhatsky@chromium.org>, <stern@rowland.harvard.edu>,
        <tglx@linutronix.de>, <vgoyal@redhat.com>, <vkuznets@redhat.com>,
        <will@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Valentin Schneider <valentin.schneider@arm.com>
Subject: Re: [PATCH 18/30] notifier: Show function names on notifier
 routines if DEBUG_NOTIFIERS is set
Message-ID: <20220510132922.61883db0@gandalf.local.home>
In-Reply-To: <9f44aae6-ec00-7ede-ec19-6e67ceb74510@huawei.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
        <20220427224924.592546-19-gpiccoli@igalia.com>
        <9f44aae6-ec00-7ede-ec19-6e67ceb74510@huawei.com>
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

On Thu, 28 Apr 2022 09:01:13 +0800
Xiaoming Ni <nixiaoming@huawei.com> wrote:

> > +#ifdef CONFIG_DEBUG_NOTIFIERS
> > +	{
> > +		char sym_name[KSYM_NAME_LEN];
> > +
> > +		pr_info("notifiers: registered %s()\n",
> > +			notifier_name(n, sym_name));
> > +	}  
> 
> Duplicate Code.
> 
> Is it better to use __func__ and %pS?
> 
> pr_info("%s: %pS\n", __func__, n->notifier_call);
> 
> 
> > +#endif

Also, don't sprinkle #ifdef in C code. Instead:

	if (IS_ENABLED(CONFIG_DEBUG_NOTIFIERS))
		pr_info("notifers: regsiter %ps()\n",
			n->notifer_call);


Or define a print macro at the start of the C file that is a nop if it is
not defined, and use the macro.

-- Steve
