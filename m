Return-Path: <netdev+bounces-9261-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AED07284E3
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:26:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 102531C20FF6
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:26:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5F90174E8;
	Thu,  8 Jun 2023 16:26:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B956B3B407
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:26:09 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED381270F;
	Thu,  8 Jun 2023 09:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686241564; x=1717777564;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=1Ix6mB8UFb8SSOuSRxqsX7mIqiQc4nCyUN2OzGZ9Vw8=;
  b=QSqMalvl40gfsLHsWhIdhBNbc6lWL6qs5U4VFWEFmFWVldDt/TWjfdOF
   jkn/1U5RRVfP3Q9+Q4EuEcxw1LDeIAz5FpyrfK/14mu4baH9Ixk64YKgR
   +lL9sz87TREDGgXICwFm+J74X5S2W5KGLqo2664Z8fgTXLCoVxj3gPclq
   gjVPqvm4pM90AKO1FzHtB3YLevrfEOYY4D7SG4tKfm5AfNZpMJkVk9UHY
   BOTnSQGWAXSJuK9dt/BPINTERjWbLtJotS2kaDfWMoWExF7oeeOoKsBev
   HpQvGdEkzMn1W/wYFJSOlAEAz8YXUGvo1+vJV45dVbZyDcfdLwziZ6wUc
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="354847130"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="354847130"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 09:24:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="956790891"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="956790891"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga006.fm.intel.com with ESMTP; 08 Jun 2023 09:24:01 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1q7IQY-002Cny-1m;
	Thu, 08 Jun 2023 19:23:58 +0300
Date: Thu, 8 Jun 2023 19:23:58 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-hardening <linux-hardening@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>, Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	senozhatsky <senozhatsky@chromium.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	davem <davem@davemloft.net>, edumazet <edumazet@google.com>,
	kuba <kuba@kernel.org>, pabeni <pabeni@redhat.com>,
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
Subject: Re: [RFC PATCH 1/1] vsprintf: Warn on integer scanning overflows
Message-ID: <ZIIAnhriitHDR2Vq@smile.fi.intel.com>
References: <20230607223755.1610-1-richard@nod.at>
 <20230607223755.1610-2-richard@nod.at>
 <ZIHlZsPMZ2dI5/yG@smile.fi.intel.com>
 <1744246043.3699439.1686240873455.JavaMail.zimbra@nod.at>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1744246043.3699439.1686240873455.JavaMail.zimbra@nod.at>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 06:14:33PM +0200, Richard Weinberger wrote:
> ----- Ursprüngliche Mail -----
> > Von: "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>
> >>  	if (prefix_chars < max_chars) {
> >>  		rv = _parse_integer_limit(cp, base, &result, max_chars - prefix_chars);
> >> +		WARN_ON_ONCE(rv & KSTRTOX_OVERFLOW);
> > 
> > This seems incorrect. simple_strto*() are okay to overflow. It's by design.
> 
> Is this design decision also known to all users of scanf functions in the kernel?

We have test_scanf.c. Does it miss any test cases? Please add them!

-- 
With Best Regards,
Andy Shevchenko



