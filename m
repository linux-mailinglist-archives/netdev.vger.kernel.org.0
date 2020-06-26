Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9F120AF79
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 12:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgFZKP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 06:15:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:42226 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgFZKP0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 06:15:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2DDA2AED6;
        Fri, 26 Jun 2020 10:15:24 +0000 (UTC)
Date:   Fri, 26 Jun 2020 12:15:23 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Alan Maguire <alan.maguire@oracle.com>, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com, andriin@fb.com,
        arnaldo.melo@gmail.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux@rasmusvillemoes.dk, joe@perches.com,
        andriy.shevchenko@linux.intel.com, corbet@lwn.net,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 bpf-next 4/8] printk: add type-printing %pT format
 specifier which uses BTF
Message-ID: <20200626101523.GM8444@alley>
References: <1592914031-31049-1-git-send-email-alan.maguire@oracle.com>
 <1592914031-31049-5-git-send-email-alan.maguire@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592914031-31049-5-git-send-email-alan.maguire@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 2020-06-23 13:07:07, Alan Maguire wrote:
> printk supports multiple pointer object type specifiers (printing
> netdev features etc).  Extend this support using BTF to cover
> arbitrary types.  "%pT" specifies the typed format, and the pointer
> argument is a "struct btf_ptr *" where struct btf_ptr is as follows:
> 
> struct btf_ptr {
>         void *ptr;
>         const char *type;
>         u32 id;
> };
> 
> Either the "type" string ("struct sk_buff") or the BTF "id" can be
> used to identify the type to use in displaying the associated "ptr"
> value.  A convenience function to create and point at the struct
> is provided:
> 
>         printk(KERN_INFO "%pT", BTF_PTR_TYPE(skb, struct sk_buff));
> 
> When invoked, BTF information is used to traverse the sk_buff *
> and display it.  Support is present for structs, unions, enums,
> typedefs and core types (though in the latter case there's not
> much value in using this feature of course).
> 
> Default output is indented, but compact output can be specified
> via the 'c' option.  Type names/member values can be suppressed
> using the 'N' option.  Zero values are not displayed by default
> but can be using the '0' option.  Pointer values are obfuscated
> unless the 'x' option is specified.  As an example:
> 
>   struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
>   pr_info("%pT", BTF_PTR_TYPE(skb, struct sk_buff));
> 
> ...gives us:
> 
> (struct sk_buff){
>  .transport_header = (__u16)65535,
>  .mac_header = (__u16)65535,
>  .end = (sk_buff_data_t)192,
>  .head = (unsigned char *)0x000000006b71155a,
>  .data = (unsigned char *)0x000000006b71155a,
>  .truesize = (unsigned int)768,
>  .users = (refcount_t){
>   .refs = (atomic_t){
>    .counter = (int)1,
>   },
>  },
>  .extensions = (struct skb_ext *)0x00000000f486a130,
> }
> 
> printk output is truncated at 1024 bytes.  For cases where overflow
> is likely, the compact/no type names display modes may be used.

Hmm, this scares me:

   1. The long message and many lines are going to stretch printk
      design in another dimensions.

   2. vsprintf() is important for debugging the system. It has to be
      stable. But the btf code is too complex.

I would strongly prefer to keep this outside vsprintf and printk.
Please, invert the logic and convert it into using separate printk()
call for each printed line.


More details:

Add 1: Long messages with many lines:

  IMHO, all existing printk() users are far below this limit. And this is
  even worse because there are many short lines. They would require
  double space to add prefixes (loglevel, timestamp, caller id) when
  printing to console.

  You might argue that 1024bytes are enough for you. But for how long?

  Now, we have huge troubles to make printk() lockless and thus more
  reliable. There is no way to allocate any internal buffers
  dynamically. People using kernel on small devices have problem
  with large static buffers.

  printk() is primary designed to print single line messages. There are
  many use cases where many lines are needed and they are solved by
  many separate printk() calls.


Add 2: Complex code:

  vsprintf() is currently called in printk() under logbuf_lock. It
  might block printk() on the entire system.

  Most existing %p<modifier> handlers are implemented by relatively
  simple routines inside lib/vsprinf.c. The other external routines
  look simple as well.

  btf looks like a huge beast to me. For example, probe_kernel_read()
  prevented boot recently, see the commit 2ac5a3bf7042a1c4abb
  ("vsprintf: Do not break early boot with probing addresses").


Best Regards,
Petr
