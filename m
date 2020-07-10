Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2073521B7D7
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 16:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgGJOJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 10:09:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726820AbgGJOJa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 10:09:30 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F09B20748;
        Fri, 10 Jul 2020 14:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594390170;
        bh=5fxYRNZaEf3WwSNJCGI+SYYktTeEynst8KjYwY2HCws=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ySwyUu3s7Op9GTBAs25t+cSBeExY6KM961X5qZHaNoswi+zL45hkTUktIDyprPRBK
         mOH0YvQkDOJ8Z4MEdMenrOVsR7T5aJKTgqmOR06+cs+H6ufX4qaLg96EUH6+GCCdkF
         dQjeYxkhT4RmHTy/OCSIhxnNn2rDnDytCK/IPF7I=
Date:   Fri, 10 Jul 2020 23:09:21 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Dominik Czarnota <dominik.czarnota@trailofbits.com>,
        stable@vger.kernel.org, Jessica Yu <jeyu@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Will Deacon <will@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matteo Croce <mcroce@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] kprobes: Do not expose probe addresses to
 non-CAP_SYSLOG
Message-Id: <20200710230921.7199e51fa19a7dce53823835@kernel.org>
In-Reply-To: <20200702232638.2946421-5-keescook@chromium.org>
References: <20200702232638.2946421-1-keescook@chromium.org>
        <20200702232638.2946421-5-keescook@chromium.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  2 Jul 2020 16:26:37 -0700
Kees Cook <keescook@chromium.org> wrote:

> The kprobe show() functions were using "current"'s creds instead
> of the file opener's creds for kallsyms visibility. Fix to use
> seq_file->file->f_cred.

This looks good to me.

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>

Thanks!

> 
> Cc: stable@vger.kernel.org
> Fixes: 81365a947de4 ("kprobes: Show address of kprobes if kallsyms does")
> Fixes: ffb9bd68ebdb ("kprobes: Show blacklist addresses as same as kallsyms does")
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  kernel/kprobes.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index d4de217e4a91..2e97febeef77 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -2448,7 +2448,7 @@ static void report_probe(struct seq_file *pi, struct kprobe *p,
>  	else
>  		kprobe_type = "k";
>  
> -	if (!kallsyms_show_value(current_cred()))
> +	if (!kallsyms_show_value(pi->file->f_cred))
>  		addr = NULL;
>  
>  	if (sym)
> @@ -2540,7 +2540,7 @@ static int kprobe_blacklist_seq_show(struct seq_file *m, void *v)
>  	 * If /proc/kallsyms is not showing kernel address, we won't
>  	 * show them here either.
>  	 */
> -	if (!kallsyms_show_value(current_cred()))
> +	if (!kallsyms_show_value(m->file->f_cred))
>  		seq_printf(m, "0x%px-0x%px\t%ps\n", NULL, NULL,
>  			   (void *)ent->start_addr);
>  	else
> -- 
> 2.25.1
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
