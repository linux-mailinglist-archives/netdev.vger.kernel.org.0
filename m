Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CBD4EDF7C
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 19:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiCaRT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 13:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiCaRT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 13:19:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E93DFD14;
        Thu, 31 Mar 2022 10:17:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51C96B8218F;
        Thu, 31 Mar 2022 17:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C98DC34110;
        Thu, 31 Mar 2022 17:17:34 +0000 (UTC)
Date:   Thu, 31 Mar 2022 13:17:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <michal.lkml@markovi.net>,
        ndesaulniers <ndesaulniers@google.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] tracing: do not export user_events uapi
Message-ID: <20220331131732.5e2305ee@gandalf.local.home>
In-Reply-To: <602770698.200731.1648742848915.JavaMail.zimbra@efficios.com>
References: <20220330201755.29319-1-mathieu.desnoyers@efficios.com>
        <20220330162152.17b1b660@gandalf.local.home>
        <CAK7LNATm5FjZsXL6aKUMhXwQAqTuO9+LmAk3LGjpAib7NZBDmg@mail.gmail.com>
        <20220331081337.07ddf251@gandalf.local.home>
        <602770698.200731.1648742848915.JavaMail.zimbra@efficios.com>
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

On Thu, 31 Mar 2022 12:07:28 -0400 (EDT)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
> index 8b3d241a31c2..823d7b09dcba 100644
> --- a/kernel/trace/trace_events_user.c
> +++ b/kernel/trace/trace_events_user.c
> @@ -18,7 +18,7 @@
>  #include <linux/tracefs.h>
>  #include <linux/types.h>
>  #include <linux/uaccess.h>
> -#include <uapi/linux/user_events.h>
> +#include <linux/user_events.h>
>  #include "trace.h"
>  #include "trace_dynevent.h"
> 
> Including <linux/user_events.h> will continue to work even when the header is
> moved to uapi in the future.

Actually, when I thought of this, I was thinking more of:

diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index 846c27bc7aef..0f3aa855cf72 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -18,7 +18,11 @@
 #include <linux/tracefs.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
+#ifdef CONFIG_COMPILE_TEST
+#include <linux/user_events.h>
+#else
 #include <uapi/linux/user_events.h>
+#endif
 #include "trace.h"
 #include "trace_dynevent.h"
 
That way, when we take it out of broken state, it will fail to compile, and
remind us to put it back into the uapi directory.

-- Steve
