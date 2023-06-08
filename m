Return-Path: <netdev+bounces-9246-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 311B27283B8
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 17:27:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94791281717
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 15:27:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D04314AA8;
	Thu,  8 Jun 2023 15:27:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14A528F3
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 15:27:46 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B42A172E;
	Thu,  8 Jun 2023 08:27:43 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 2496D1FDE6;
	Thu,  8 Jun 2023 15:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1686238062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YjexGMdyJWeBEjd6xCsB5dyXSs2Z5hB+eEW3odtxG74=;
	b=SfueeyNYTBrTihKqx8oxJyfXgJUEO72qrEaWzKN9n/xvcrRpUuC7wTlr5iQ5JU20AoKVk+
	RIlBFvY+Q+Do9PokOXqyijq2TF/CAdHol/tiqVodfAgEosBNsgNhjvbDhDhwUi/3kUlSxU
	tJXq1cRpat2EYGkHF7TOihaLs/AntV8=
Received: from suse.cz (unknown [10.100.208.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 162EF2C141;
	Thu,  8 Jun 2023 15:27:41 +0000 (UTC)
Date: Thu, 8 Jun 2023 17:27:40 +0200
From: Petr Mladek <pmladek@suse.com>
To: Kees Cook <keescook@chromium.org>
Cc: Richard Weinberger <richard@nod.at>, linux-hardening@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
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
	John Fastabend <john.fastabend@gmail.com>
Subject: Re: [RFC PATCH 0/1] Integer overflows while scanning for integers
Message-ID: <ZIHzbBXlxEz6As9N@alley>
References: <20230607223755.1610-1-richard@nod.at>
 <202306071634.51BBAFD14@keescook>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202306071634.51BBAFD14@keescook>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed 2023-06-07 16:36:12, Kees Cook wrote:
> On Thu, Jun 08, 2023 at 12:37:54AM +0200, Richard Weinberger wrote:
> > Hi!
> > 
> > Lately I wondered whether users of integer scanning functions check
> > for overflows.
> > To detect such overflows around scanf I came up with the following
> > patch. It simply triggers a WARN_ON_ONCE() upon an overflow.
> > 
> > After digging into various scanf users I found that the network device
> > naming code can trigger an overflow.
> > 
> > e.g:
> > $ ip link add 1 type veth peer name 9999999999
> > $ ip link set name "%d" dev 1
> > 
> > It will trigger the following WARN_ON_ONCE():
> > ------------[ cut here ]------------
> > WARNING: CPU: 2 PID: 433 at lib/vsprintf.c:3701 vsscanf+0x6ce/0x990
> 
> Hm, it's considered a bug if a WARN or BUG can be reached from
> userspace,

Good point. WARN() does not look like the right way in this case.

Another problem is that some users use panic_on_warn. In this case,
the above "ip" command calls would trigger panic(). And it does not
look like an optimal behavior.

I know there already are some WARN_ONs for similar situations, e.g.
set_field_width() or set_precision(). But these do not get random
values. And it would actually be nice to introduce something like
INFO() that would be usable for these less serious problems where
the backtrace is useful but they should never trigger panic().

> so this probably needs to be rearranged (or callers fixed).
> Do we need to change the scanf API for sane use inside the kernel?

It seems that userspace implementation of sscanf() and vsscanf()
returns -ERANGE in this case. It might be a reasonable solution.

Well, there is a risk of introducing security problems. The error
value might cause an underflow/overflow when the caller does not expect
a negative value.

Alternative solution would be to update the "ip" code so that it
reads the number separately and treat zero return value as
-EINVAL.

Best Regards,
Petr

