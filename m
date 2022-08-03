Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31F75889E7
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 11:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237687AbiHCJxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 05:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237911AbiHCJxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 05:53:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5676E28703
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 02:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659520386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kc/D6eFmNXdc/PlI526NFHqk9sVSNen1MCJD2u5ZFKQ=;
        b=CqSknuhT1nq55PdZ1ZzQQKuWqe0rs2mVHhN9kz75weTCVHGx4+3hGlF/P+hmYsJ3pHTpq4
        U0DzJZKCj4IInoYQF8RmyRstmb9we3+KLETflHYo8L7CqQ7uI5/Qnqvh64MdZ7l+mi300j
        m4KrwGERttKyVIbIikvorc3gOc7GVdk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-VvdGeYMLPhaxQBkXtxi7Zw-1; Wed, 03 Aug 2022 05:53:03 -0400
X-MC-Unique: VvdGeYMLPhaxQBkXtxi7Zw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A5E185A584;
        Wed,  3 Aug 2022 09:53:01 +0000 (UTC)
Received: from localhost (ovpn-13-216.pek2.redhat.com [10.72.13.216])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F5EC2166B26;
        Wed,  3 Aug 2022 09:53:00 +0000 (UTC)
Date:   Wed, 3 Aug 2022 17:52:57 +0800
From:   Baoquan He <bhe@redhat.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     akpm@linux-foundation.org, pmladek@suse.com,
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
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Sergei Shtylyov <sergei.shtylyov@gmail.com>
Subject: Re: [PATCH v2 08/13] tracing: Improve panic/die notifiers
Message-ID: <YupFeQ6AcfjUVpOW@MiWiFi-R3L-srv>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-9-gpiccoli@igalia.com>
 <YupBtiVkrmE7YQnr@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YupBtiVkrmE7YQnr@MiWiFi-R3L-srv>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/03/22 at 05:36pm, Baoquan He wrote:
> On 07/19/22 at 04:53pm, Guilherme G. Piccoli wrote:
> > Currently the tracing dump_on_oops feature is implemented
> > through separate notifiers, one for die/oops and the other
> > for panic - given they have the same functionality, let's
> > unify them.
> > 
> > Also improve the function comment and change the priority of
> > the notifier to make it execute earlier, avoiding showing useless
> > trace data (like the callback names for the other notifiers);
> > finally, we also removed an unnecessary header inclusion.
> > 
> > Cc: Petr Mladek <pmladek@suse.com>
> > Cc: Sergei Shtylyov <sergei.shtylyov@gmail.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> > 
> > ---
> > 
> > V2:
> > - Different approach; instead of using IDs to distinguish die and
> > panic events, rely on address comparison like other notifiers do
> > and as per Petr's suggestion;
> > 
> > - Removed ACK from Steven since the code changed.
> > 
> >  kernel/trace/trace.c | 55 ++++++++++++++++++++++----------------------
> >  1 file changed, 27 insertions(+), 28 deletions(-)
> > 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index b8dd54627075..2a436b645c70 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -19,7 +19,6 @@
> >  #include <linux/kallsyms.h>
> >  #include <linux/security.h>
> >  #include <linux/seq_file.h>
> > -#include <linux/notifier.h>
> >  #include <linux/irqflags.h>
> >  #include <linux/debugfs.h>
> >  #include <linux/tracefs.h>
> > @@ -9777,40 +9776,40 @@ static __init int tracer_init_tracefs(void)
> >  
> >  fs_initcall(tracer_init_tracefs);
> >  
> > -static int trace_panic_handler(struct notifier_block *this,
> > -			       unsigned long event, void *unused)
> > -{
> > -	if (ftrace_dump_on_oops)
> > -		ftrace_dump(ftrace_dump_on_oops);
> > -	return NOTIFY_OK;
> > -}
> > +static int trace_die_panic_handler(struct notifier_block *self,
> > +				unsigned long ev, void *unused);
> >  
> >  static struct notifier_block trace_panic_notifier = {
> > -	.notifier_call  = trace_panic_handler,
> > -	.next           = NULL,
> > -	.priority       = 150   /* priority: INT_MAX >= x >= 0 */
> > +	.notifier_call = trace_die_panic_handler,
> > +	.priority = INT_MAX - 1,
> >  };
> >  
> > -static int trace_die_handler(struct notifier_block *self,
> > -			     unsigned long val,
> > -			     void *data)
> > -{
> > -	switch (val) {
> > -	case DIE_OOPS:
> > -		if (ftrace_dump_on_oops)
> > -			ftrace_dump(ftrace_dump_on_oops);
> > -		break;
> > -	default:
> > -		break;
> > -	}
> > -	return NOTIFY_OK;
> > -}
> > -
> >  static struct notifier_block trace_die_notifier = {
> > -	.notifier_call = trace_die_handler,
> > -	.priority = 200
> > +	.notifier_call = trace_die_panic_handler,
> > +	.priority = INT_MAX - 1,
> >  };
> >  
> > +/*
> > + * The idea is to execute the following die/panic callback early, in order
> > + * to avoid showing irrelevant information in the trace (like other panic
> > + * notifier functions); we are the 2nd to run, after hung_task/rcu_stall
> > + * warnings get disabled (to prevent potential log flooding).
> > + */
> > +static int trace_die_panic_handler(struct notifier_block *self,
> > +				unsigned long ev, void *unused)
> > +{
> > +	if (!ftrace_dump_on_oops)
> > +		goto out;
> > +
> > +	if (self == &trace_die_notifier && ev != DIE_OOPS)
> > +		goto out;
> 
> Although the switch-case code of original trace_die_handler() is werid, 
> this unification is not much more comfortable. Just personal feeling
> from code style, not strong opinion. Leave it to trace reviewers.

Please ignore this comment.

I use b4 to grab this patchset and applied, and started to check patch
one by one. Then I realize it's all about cleanups which have got
consensus in earlier rounds. Hope it can be merged when other people's
concern is addressed, the whole series looks good to me, I have no
strong concern to them.

> 
> > +
> > +	ftrace_dump(ftrace_dump_on_oops);
> > +
> > +out:
> > +	return NOTIFY_DONE;
> > +}
> > +
> >  /*
> >   * printk is set to max of 1024, we really don't need it that big.
> >   * Nothing should be printing 1000 characters anyway.
> > -- 
> > 2.37.1
> > 
> 

