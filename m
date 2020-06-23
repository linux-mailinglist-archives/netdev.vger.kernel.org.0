Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892482052F9
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 15:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732631AbgFWNCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 09:02:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:45885 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729504AbgFWNCl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 09:02:41 -0400
IronPort-SDR: rBRh7GIDsPaTaPRb8hH2DmKolhjsu/Yz0qCbRUR+ZBXZeWIWQxalGBCKKnX+cAT8LCvl/JShlu
 uZDaPzZ9yBMA==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="132460669"
X-IronPort-AV: E=Sophos;i="5.75,271,1589266800"; 
   d="scan'208";a="132460669"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 06:02:19 -0700
IronPort-SDR: o+R2OoFeoWQA/J4RHm1r+9v8/K4tYupPJS7dDz4jqfOZVec75U7bER/7+AImsM9moUAvKTpryt
 aNbDAebtm6GQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,271,1589266800"; 
   d="scan'208";a="263331773"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga007.fm.intel.com with ESMTP; 23 Jun 2020 06:02:15 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jniZ6-00FMmi-6o; Tue, 23 Jun 2020 16:02:16 +0300
Date:   Tue, 23 Jun 2020 16:02:16 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com, andriin@fb.com,
        arnaldo.melo@gmail.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux@rasmusvillemoes.dk, joe@perches.com, pmladek@suse.com,
        rostedt@goodmis.org, sergey.senozhatsky@gmail.com, corbet@lwn.net,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 bpf-next 6/8] printk: extend test_printf to test %pT
 BTF-based format specifier
Message-ID: <20200623130216.GW2428291@smile.fi.intel.com>
References: <1592914031-31049-1-git-send-email-alan.maguire@oracle.com>
 <1592914031-31049-7-git-send-email-alan.maguire@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592914031-31049-7-git-send-email-alan.maguire@oracle.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 01:07:09PM +0100, Alan Maguire wrote:
> Add tests to verify basic type display and to iterate through all
> enums, structs, unions and typedefs ensuring expected behaviour
> occurs.  Since test_printf can be built as a module we need to
> export a BTF kind iterator function to allow us to iterate over
> all names of a particular BTF kind.
> 
> These changes add up to approximately 20,000 new tests covering
> all enum, struct, union and typedefs in vmlinux BTF.
> 
> Individual tests are also added for int, char, struct, enum
> and typedefs which verify output is as expected.

...

>  #include <linux/mm.h>
>  
>  #include <linux/property.h>

+ blank line, you see, headers are grouped.

> +#include <linux/bpf.h>
> +#include <linux/btf.h>
> +#include <linux/skbuff.h>

> +#define	__TEST_BTF(fmt, type, ptr, expected)				       \
> +	test(expected, "%pT"fmt, ptr)
> +
> +#define TEST_BTF_C(type, var, ...)					       \
> +	do {								       \
> +		type var = __VA_ARGS__;					       \
> +		struct btf_ptr *ptr = BTF_PTR_TYPE(&var, type);		       \

> +		pr_debug("type %s: %pTc", #type, ptr);			       \

Hmm... Can't we modify test() (or underneath macros / functions) to do this?

> +		__TEST_BTF("c", type, ptr, "(" #type ")" #__VA_ARGS__);	       \
> +	} while (0)
> +
> +#define TEST_BTF(fmt, type, var, expected, ...)				       \
> +	do {								       \
> +		type var = __VA_ARGS__;					       \
> +		struct btf_ptr *ptr = BTF_PTR_TYPE(&var, type);		       \
> +		pr_debug("type %s: %pT"fmt, #type, ptr);		       \
> +		__TEST_BTF(fmt, type, ptr, expected);			       \
> +	} while (0)

...

> +static void __init
> +btf_print_kind(u8 kind, const char *kind_name, u64 fillval)
> +{

> +	const char *fmt1 = "%pT", *fmt2 = "%pTN", *fmt3 = "%pT0";

This is hard to read. Provide a simple data structure or an array.

> +	const char *name, *fmt = fmt1;
> +	int i, res1, res2, res3, res4;
> +	char type_name[256];
> +	char *buf, *buf2;
> +	u8 *dummy_data;
> +	s32 id = 0;
> +
> +	dummy_data = kzalloc(BTF_MAX_DATA_SIZE, GFP_KERNEL);

check?

> +	/* fill our dummy data with supplied fillval. */
> +	for (i = 0; i < BTF_MAX_DATA_SIZE; i++)
> +		dummy_data[i] = fillval;

> +	buf = kzalloc(BTF_MAX_DATA_SIZE, GFP_KERNEL);
> +	buf2 = kzalloc(BTF_MAX_DATA_SIZE, GFP_KERNEL);

Ditto.

> +	for (;;) {
> +		name = btf_vmlinux_next_type_name(kind, &id);
> +		if (!name)
> +			break;
> +
> +		total_tests++;
> +
> +		snprintf(type_name, sizeof(type_name), "%s%s",
> +			 kind_name, name);
> +
> +		res1 = snprintf(buf, BTF_MAX_DATA_SIZE, fmt1,
> +				BTF_PTR_TYPE(dummy_data, type_name));
> +		res2 = snprintf(buf, 0, fmt1,
> +				BTF_PTR_TYPE(dummy_data, type_name));
> +		res3 = snprintf(buf, BTF_MAX_DATA_SIZE, fmt2,
> +				BTF_PTR_TYPE(dummy_data, type_name));
> +		res4 = snprintf(buf, BTF_MAX_DATA_SIZE, fmt3,
> +				BTF_PTR_TYPE(dummy_data, type_name));
> +
> +		(void) snprintf(buf, BTF_MAX_DATA_SIZE, "%pT",
> +				BTF_PTR_TYPE(dummy_data, type_name));
> +		(void) snprintf(buf2, BTF_MAX_DATA_SIZE, "%pT",
> +				BTF_PTR_TYPE(dummy_data, type_name));
> +
> +		/*
> +		 * Ensure return value is > 0 and identical irrespective
> +		 * of whether we pass in a big enough buffer;
> +		 * also ensure that printing names always results in as
> +		 * long/longer buffer length.
> +		 */
> +		if (res1 <= 0 || res2 <= 0 || res3 <= 0 || res4 <= 0) {
> +			if (res3 <= 0)
> +				fmt = fmt2;
> +			if (res4 <= 0)
> +				fmt = fmt3;

> +			pr_warn("snprintf(%s%s); %d <= 0 (fmt %s)",
> +				kind_name, name,
> +				res1 <= 0 ? res1 : res2 <= 0 ? res2 :
> +				res3 <= 0 ? res3 : res4, fmt);
> +			failed_tests++;

For these kind of prints you can use a new macro, right?

> +		} else if (res1 != res2) {

> +			pr_warn("snprintf(%s%s): %d (to buf) != %d (no buf)",
> +				kind_name, name, res1, res2);
> +			failed_tests++;

Ditto.

> +		} else if (res3 > res2) {

> +			pr_warn("snprintf(%s%s); %d (no names) > %d (names)",
> +				kind_name, name, res3, res2);
> +			failed_tests++;

Ditto.

> +		} else if (strcmp(buf, buf2) != 0) {

> +			/* Safe and unsafe buffers should match. */
> +			pr_warn("snprintf(%s%s); safe != unsafe",
> +				kind_name, name);
> +			pr_warn("safe: %s", buf);
> +			pr_warn("unsafe: %s", buf2);
> +			failed_tests++;

Perhaps also makes sense in a macro then somebody may reuse in the future.
That said, the first warning here somehow cryptic, please be more human friendly.

> +		} else {
> +			pr_debug("Printed %s%s (%d bytes)",
> +				 kind_name, name, res1);
> +		}
> +	}
> +	kfree(dummy_data);
> +	kfree(buf);
> +	kfree(buf2);
> +}

...

> +	TEST_BTF_C(int, testint, 1234);
> +	TEST_BTF("cN", int, testint, "1234", 1234);

We use small letter macros in other cases. So can you?


...

> +	/* typedef struct */
> +	TEST_BTF_C(atomic_t, testtype, {.counter = (int)1,});
> +	TEST_BTF("cN", atomic_t, testtype, "{1,}", {.counter = 1,});
> +	/* typedef with 0 value should be printed at toplevel */
> +	TEST_BTF("c", atomic_t, testtype, "(atomic_t){}", {.counter = 0,});
> +	TEST_BTF("cN", atomic_t, testtype, "{}", {.counter = 0,});
> +	TEST_BTF("c0", atomic_t, testtype, "(atomic_t){.counter = (int)0,}",
> +		 {.counter = 0,});
> +	TEST_BTF("cN0", atomic_t, testtype, "{0,}", {.counter = 0,});

For one type, provide a data structure filled with test data and use loops.
Same for all similar places over the code.

...

> +	u64 fillvals[] = { 0x0, 0xffffffffffffffff, 0x0123456789abcdef };

U64_MAX?

-- 
With Best Regards,
Andy Shevchenko


