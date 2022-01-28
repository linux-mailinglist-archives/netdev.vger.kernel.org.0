Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4AC049F0CE
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345217AbiA1CFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235461AbiA1CFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:05:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8570CC061714;
        Thu, 27 Jan 2022 18:05:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46577B8241F;
        Fri, 28 Jan 2022 02:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6D5C340E5;
        Fri, 28 Jan 2022 02:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643335530;
        bh=H0rwTxzxbzLWGDz4SbAOCgeCMcGp1dobsc6sNArg19M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e+oA/NCl6QRJofHlgD5vvd5xXbHYr4qfUdSgkljV9Fgn89Ee6fcpGKHhtuAkw3uN5
         vPTiL+445ULGsxf8xwENYpxnnTYatvHLDNH4v3sPsgC0+UW56ARRGipihSXmGzQnxT
         4tLQ8B2V64c/qtmR8Qgcog6J5RP7vfPnzbnBS/1nXlaBKK3i7di5Gk2cINNpyWV7wv
         STaeDTWVB7ouB4uoBBIZp73yUzcqpKNFzPx9EubETzXvwMi7q9Mc3gvCH+twrDWqk5
         FWFd2yU5uha52Axa4GhfLvqhLh57vDvOwiyIH6LVPbg5ua+C8AAraFII9YOn60xkId
         2Tc3srfCOzoLw==
Date:   Fri, 28 Jan 2022 11:05:23 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v5 1/9] ftrace: Add ftrace_set_filter_ips function
Message-Id: <20220128110523.de0e36317a34d48b793a7f6b@kernel.org>
In-Reply-To: <YfApT8uAoCODPAGu@krava>
References: <164311269435.1933078.6963769885544050138.stgit@devnote2>
        <164311270629.1933078.4596694198103138848.stgit@devnote2>
        <20220125110659.2cc8df29@gandalf.local.home>
        <YfApT8uAoCODPAGu@krava>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

On Tue, 25 Jan 2022 17:46:07 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> On Tue, Jan 25, 2022 at 11:06:59AM -0500, Steven Rostedt wrote:
> 
> SNIP
> 
> > > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > > index be5f6b32a012..39350aa38649 100644
> > > --- a/kernel/trace/ftrace.c
> > > +++ b/kernel/trace/ftrace.c
> > > @@ -4958,7 +4958,7 @@ ftrace_notrace_write(struct file *file, const char __user *ubuf,
> > >  }
> > >  
> > >  static int
> > > -ftrace_match_addr(struct ftrace_hash *hash, unsigned long ip, int remove)
> > > +__ftrace_match_addr(struct ftrace_hash *hash, unsigned long ip, int remove)
> > >  {
> > >  	struct ftrace_func_entry *entry;
> > >  
> > > @@ -4976,9 +4976,25 @@ ftrace_match_addr(struct ftrace_hash *hash, unsigned long ip, int remove)
> > >  	return add_hash_entry(hash, ip);
> > >  }
> > >  
> > > +static int
> > > +ftrace_match_addr(struct ftrace_hash *hash, unsigned long *ips,
> > > +		  unsigned int cnt, int remove)
> > > +{
> > > +	unsigned int i;
> > > +	int err;
> > > +
> > > +	for (i = 0; i < cnt; i++) {
> > > +		err = __ftrace_match_addr(hash, ips[i], remove);
> > > +		if (err)
> > > +			return err;
> > 
> > On error should we revert what was done?
> > 
> > 			goto err;
> > > +	}
> > > +	return 0;
> > 
> > err:
> > 	for (i--; i >= 0; i--)
> > 		__ftrace_match_addr(hash, ips[i], !remove);
> > 	return err;
> > 
> > Although it may not matter as it looks like it is only used on a temporary
> > hash. But either it should be commented that is the case, or we do the above
> > just to be more robust.
> 
> yes, that's the case.. it populates just the hash at this point
> and if __ftrace_match_addr fails, the thehash is relased after
> jumping to out_regex_unlock
> 
> > 
> > > +}
> > > +
> > >  static int
> > >  ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
> > > -		unsigned long ip, int remove, int reset, int enable)
> > > +		unsigned long *ips, unsigned int cnt,
> > > +		int remove, int reset, int enable)
> > >  {
> > >  	struct ftrace_hash **orig_hash;
> > >  	struct ftrace_hash *hash;
> > > @@ -5008,8 +5024,8 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
> > >  		ret = -EINVAL;
> > >  		goto out_regex_unlock;
> > >  	}
> > > -	if (ip) {
> > > -		ret = ftrace_match_addr(hash, ip, remove);
> > > +	if (ips) {
> > > +		ret = ftrace_match_addr(hash, ips, cnt, remove);
> > >  		if (ret < 0)
> > >  			goto out_regex_unlock;
> > >  	}
> > > @@ -5026,10 +5042,10 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
> > >  }
> > >  
> > >  static int
> > > -ftrace_set_addr(struct ftrace_ops *ops, unsigned long ip, int remove,
> > > -		int reset, int enable)
> > > +ftrace_set_addr(struct ftrace_ops *ops, unsigned long *ips, unsigned int cnt,
> > > +		int remove, int reset, int enable)
> > >  {
> > > -	return ftrace_set_hash(ops, NULL, 0, ip, remove, reset, enable);
> > > +	return ftrace_set_hash(ops, NULL, 0, ips, cnt, remove, reset, enable);
> > >  }
> > >  
> > >  #ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
> > > @@ -5634,10 +5650,29 @@ int ftrace_set_filter_ip(struct ftrace_ops *ops, unsigned long ip,
> > >  			 int remove, int reset)
> > >  {
> > >  	ftrace_ops_init(ops);
> > > -	return ftrace_set_addr(ops, ip, remove, reset, 1);
> > > +	return ftrace_set_addr(ops, &ip, 1, remove, reset, 1);
> > >  }
> > >  EXPORT_SYMBOL_GPL(ftrace_set_filter_ip);
> > >  
> > > +/**
> > > + * ftrace_set_filter_ips - set a functions to filter on in ftrace by addresses
> > 
> > 		- set functions to filter on ...
> 
> will fix,

So, I wrote a below change for the next version. Is that OK for you?

Thank you,

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f305e18f699f..a28b1bdb234a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4985,8 +4985,13 @@ ftrace_match_addr(struct ftrace_hash *hash, unsigned long *ips,
 
 	for (i = 0; i < cnt; i++) {
 		err = __ftrace_match_addr(hash, ips[i], remove);
-		if (err)
+		if (err) {
+			/*
+			 * This expects the @hash is a temporary hash and if this
+			 * fails the caller must free the @hash.
+			 */
 			return err;
+		}
 	}
 	return 0;
 }
@@ -5649,7 +5654,7 @@ int ftrace_set_filter_ip(struct ftrace_ops *ops, unsigned long ip,
 EXPORT_SYMBOL_GPL(ftrace_set_filter_ip);
 
 /**
- * ftrace_set_filter_ips - set a functions to filter on in ftrace by addresses
+ * ftrace_set_filter_ips - set functions to filter on in ftrace by addresses
  * @ops - the ops to set the filter with
  * @ips - the array of addresses to add to or remove from the filter.
  * @cnt - the number of addresses in @ips








> 
> thanks,
> jirka
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
