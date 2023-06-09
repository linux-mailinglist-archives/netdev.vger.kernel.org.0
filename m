Return-Path: <netdev+bounces-9629-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 51B7172A0D6
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:03:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A21711C209F5
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 421EC1B915;
	Fri,  9 Jun 2023 17:03:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311FC171B4
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:03:07 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEAB1BD;
	Fri,  9 Jun 2023 10:03:06 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id AA04D21A86;
	Fri,  9 Jun 2023 17:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1686330184; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=REEDDTYjANwf4OYVzWw7svHHjEF/SXbfklTXuE905lA=;
	b=EBNbp4pA5hDPn36pel+HGgMRUTpI5M+3xek6bwhBJkIIqV6PK9wc3FqPA1Ilo8PmKXJ7DD
	5V1rDdeK/QSi0rMKdm5LIbTe/n9zH7N2OdhyL2krBe+FtcqKs6tzdb+2FsgQFgm6qf1evt
	c6pmx4EZfvvohKqa9+pJbZ9e1jxJVc4=
Received: from suse.cz (pmladek.tcp.ovpn2.prg.suse.de [10.100.208.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 9A8042C23D;
	Fri,  9 Jun 2023 17:03:03 +0000 (UTC)
Date: Fri, 9 Jun 2023 19:02:59 +0200
From: Petr Mladek <pmladek@suse.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Kees Cook <keescook@chromium.org>, Richard Weinberger <richard@nod.at>,
	linux-hardening@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 0/1] Integer overflows while scanning for integers
Message-ID: <ZINbQ3eyMB2OGfiN@alley>
References: <20230607223755.1610-1-richard@nod.at>
 <202306071634.51BBAFD14@keescook>
 <ZIHzbBXlxEz6As9N@alley>
 <9cd596d9-0ecb-29fc-fe18-f19b86a5ba44@rasmusvillemoes.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cd596d9-0ecb-29fc-fe18-f19b86a5ba44@rasmusvillemoes.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Added Linus into CC. Quick summary for him:

1. The original problem is best described in the cover letter, see
   https://lore.kernel.org/r/20230607223755.1610-1-richard@nod.at

2. I think that we actually have two problems:

     a) How to find a code where sscanf() might get invalid output.
	Such a code might require some special/better handling
	of this situation.

     b) How to eventually provide a useful message back to
	userspace.


On Fri 2023-06-09 12:10:29, Rasmus Villemoes wrote:
> On 08/06/2023 17.27, Petr Mladek wrote:
> > On Wed 2023-06-07 16:36:12, Kees Cook wrote:
> 
> > It seems that userspace implementation of sscanf() and vsscanf()
> > returns -ERANGE in this case. It might be a reasonable solution.
> 
> Well. _Some_ userspace implementation does that. It's not in POSIX.
> While "man scanf" lists that ERANGE error, it also explicitly says that:
> 
> CONFORMING TO
>        The functions fscanf(), scanf(), and sscanf() conform to C89 and
> C99 and POSIX.1-2001.  These standards do  not  specify  the
>        ERANGE error.
> 
> I can't figure out what POSIX actually says should or could happen with
> sscanf("99999999999999", "%i", &x);

It looks to me that it does not say anything about it. Even the latest
IEEE Std 1003.1-2017 says just this:

--- cut ---
RETURN VALUE
Upon successful completion, these functions shall return the number of
successfully matched and assigned input items; this number can be zero
in the event of an early matching failure. If the input ends before
the first conversion (if any) has completed, and without a matching
failure having occurred, EOF shall be returned. If an error occurs
before the first conversion (if any) has completed, and without
a matching failure having occurred, EOF shall be returned
and errno shall be set to indicate the error. If a read error
occurs, the error indicator for the stream shall be set.

ERRORS
For the conditions under which the fscanf() functions fail and may
fail, refer to fgetc or fgetwc.

In addition, the fscanf() function shall fail if:

[EILSEQ]
Input byte sequence does not form a valid character.
[ENOMEM]
Insufficient storage space is available.
In addition, the fscanf() function may fail if:

[EINVAL]
There are insufficient arguments.
--- cut ---

I do not see anything about overflow anywhere.

Well, the -ERANGE returned by the Linux implementation looks
quite practical.

> > Well, there is a risk of introducing security problems. The error
> > value might cause an underflow/overflow when the caller does not expect
> > a negative value.
> 
> There is absolutely no way we can start letting sscanf() return a
> negative err value, in exactly the same way we cannot possibly let
> vsnprintf() do that.

I agree.

> We can stop early, possibly with a WARNing if it's

Thinking more about it, the WARN() is a really big hammer even
if we introduced a never-panicking alternative, e.g. INFO()
or REPORT().

sscanf() does not know in which situation it is used and how
serious the overflow would be. I mean that it does not know
how to provide useful report and if it is needed at all.

Also WARN()-like report would only help with the 1st problem,
how find the code where the overflow might happen.
But it would not help to handle it a reasonable way.

> > Alternative solution would be to update the "ip" code so that it
> > reads the number separately and treat zero return value as
> > -EINVAL.
> 
> The netdev naming code _could_ be updated to just not use scanf at all
> or the bitmap of in-use numbers, just do the "sprintf(buf, fmt, i)" in a
> loop and stop when the name is not in use. That's a win as long as there
> are less than ~256 names already matching the pattern, but the
> performance absolutely tanks if there are many more than that. So I
> won't actually suggest that.

Yes, sscanf() might be replaced by a tricky code to better handle possible
wrong input.

Alternatively, we could provide sscanf_with_err() [*] which would
return the error codes. It might be used in situations where
the caller is ready to handle it.

For example, __dev_alloc_name() might return -ERANGE or -EINVAL.
As a result "ip" might exit with 2 status. It means an error
from kernel. __dev_alloc_name() might eventually print some
useful message into the kernel log. Normal user would not be
able to read it. But they might ask admin to check the kernel log...


My opinion:

1. I would prefer to avoid WARN() even when a non-panic alternative
   is used. It might be too noisy.

   Well, it might be acceptable when it is enabled only with some
   CONFIG_DEBUG_SSCANF. But the question is who would enable it.
   If a developer knew that the problem might be in sscanf() then
   they probably are close to the buggy code anyway.


2. The sscanf_with_err() [*] variant looks practical to actually
   handle the wrong input.


[*] sscanf_with_error() is super ugly name. Any better idea is
    welcome.

Best Regards,
Petr

