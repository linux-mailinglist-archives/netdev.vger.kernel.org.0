Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDFFE2B2B
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 09:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408615AbfJXHc3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 24 Oct 2019 03:32:29 -0400
Received: from mga14.intel.com ([192.55.52.115]:60448 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404582AbfJXHc2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 03:32:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 00:32:28 -0700
X-IronPort-AV: E=Sophos;i="5.68,223,1569308400"; 
   d="scan'208";a="192102228"
Received: from jnikula-mobl3.fi.intel.com (HELO localhost) ([10.237.66.161])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 00:32:23 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gfx@lists.freedesktop.org,
        Vishal Kulkarni <vishal@chelsio.com>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH v4] string-choice: add yesno(), onoff(), enableddisabled(), plural() helpers
In-Reply-To: <20191023155619.43e0013f0c8c673a5c508c1e@linux-foundation.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20191023131308.9420-1-jani.nikula@intel.com> <20191023155619.43e0013f0c8c673a5c508c1e@linux-foundation.org>
Date:   Thu, 24 Oct 2019 10:32:20 +0300
Message-ID: <877e4uegzf.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Oct 2019, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 23 Oct 2019 16:13:08 +0300 Jani Nikula <jani.nikula@intel.com> wrote:
>
>> The kernel has plenty of ternary operators to choose between constant
>> strings, such as condition ? "yes" : "no", as well as value == 1 ? "" :
>> "s":
>> 
>> $ git grep '? "yes" : "no"' | wc -l
>> 258
>> $ git grep '? "on" : "off"' | wc -l
>> 204
>> $ git grep '? "enabled" : "disabled"' | wc -l
>> 196
>> $ git grep '? "" : "s"' | wc -l
>> 25
>> 
>> Additionally, there are some occurences of the same in reverse order,
>> split to multiple lines, or otherwise not caught by the simple grep.
>> 
>> Add helpers to return the constant strings. Remove existing equivalent
>> and conflicting functions in i915, cxgb4, and USB core. Further
>> conversion can be done incrementally.
>> 
>> The main goal here is to abstract recurring patterns, and slightly clean
>> up the code base by not open coding the ternary operators.
>
> Fair enough.
>
>> --- /dev/null
>> +++ b/include/linux/string-choice.h
>> @@ -0,0 +1,31 @@
>> +/* SPDX-License-Identifier: MIT */
>> +/*
>> + * Copyright © 2019 Intel Corporation
>> + */
>> +
>> +#ifndef __STRING_CHOICE_H__
>> +#define __STRING_CHOICE_H__
>> +
>> +#include <linux/types.h>
>> +
>> +static inline const char *yesno(bool v)
>> +{
>> +	return v ? "yes" : "no";
>> +}
>> +
>> +static inline const char *onoff(bool v)
>> +{
>> +	return v ? "on" : "off";
>> +}
>> +
>> +static inline const char *enableddisabled(bool v)
>> +{
>> +	return v ? "enabled" : "disabled";
>> +}
>> +
>> +static inline const char *plural(long v)
>> +{
>> +	return v == 1 ? "" : "s";
>> +}
>> +
>> +#endif /* __STRING_CHOICE_H__ */
>
> These aren't very good function names.  Better to create a kernel-style
> namespace such as "choice_" and then add the expected underscores:
>
> choice_yes_no()
> choice_enabled_disabled()
> choice_plural()

I was merely using existing function names used in several drivers in
the kernel. But I can rename no problem.

Are your suggestions the names we can settle on now, or should I expect
to receive more opinions, but only after I send v5?

> (Example: note that slabinfo.c already has an "onoff()").

Under tools/ though? I did mean to address all conflicts in this patch.

> Also, I worry that making these functions inline means that each .o
> file will contain its own copy of the strings ("yes", "no", "enabled",
> etc) if the .c file calls the relevant helper.  I'm not sure if the
> linker is smart enough (yet) to fix this up.  If not, we will end up
> with a smaller kernel by uninlining these functions. 
> lib/string-choice.c would suit.
>
> And doing this will cause additional savings: calling a single-arg
> out-of-line function generates less .text than calling yesno().  When I
> did this: 
>
> --- a/include/linux/string-choice.h~string-choice-add-yesno-onoff-enableddisabled-plural-helpers-fix
> +++ a/include/linux/string-choice.h
> @@ -8,10 +8,7 @@
>  
>  #include <linux/types.h>
>  
> -static inline const char *yesno(bool v)
> -{
> -	return v ? "yes" : "no";
> -}
> +const char *yesno(bool v);
>  
>  static inline const char *onoff(bool v)
>  {
>
> The text segment of drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.o
> (78 callsites) shrunk by 118 bytes.

So we've already been back and forth on that particular topic in the
history of this patch. v2 had lib/string-choice.c and no inlines [1].

In the end, starting to use functions, inline or not, will let us rework
the implementation as we see fit, without touching the callers.

Again, it's no problem to go back to lib/string-choice.c, *once* more,
and the effort is trivial, but the ping-pong is getting old.


BR,
Jani.


[1] http://lore.kernel.org/r/20190930141842.15075-1-jani.nikula@intel.com

-- 
Jani Nikula, Intel Open Source Graphics Center
