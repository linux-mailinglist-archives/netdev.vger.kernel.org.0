Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83612052B2
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 14:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732625AbgFWMkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 08:40:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:43994 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729667AbgFWMkQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 08:40:16 -0400
IronPort-SDR: gpBueS7DOmCnqwOvGG1aSv1LxeztbThOqTj2rMqDBtfy0mHrlvUX9d7aCJmibfWTQ3JKXx9Ojc
 ayo6wgpExhcg==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="132456225"
X-IronPort-AV: E=Sophos;i="5.75,271,1589266800"; 
   d="scan'208";a="132456225"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 05:40:16 -0700
IronPort-SDR: 5lRppJexD/ARHDG5mePXGJ6sfnJXLRvXiDKtvitz2J+G7BLb6RJ6uxLoFK4H0s7hzIyWJkiQF1
 s23kOdoFhmpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,271,1589266800"; 
   d="scan'208";a="293186482"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga002.jf.intel.com with ESMTP; 23 Jun 2020 05:40:11 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jniDk-00FMag-OT; Tue, 23 Jun 2020 15:40:12 +0300
Date:   Tue, 23 Jun 2020 15:40:12 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com, andriin@fb.com,
        arnaldo.melo@gmail.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux@rasmusvillemoes.dk, joe@perches.com, pmladek@suse.com,
        rostedt@goodmis.org, sergey.senozhatsky@gmail.com, corbet@lwn.net,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 bpf-next 4/8] printk: add type-printing %pT format
 specifier which uses BTF
Message-ID: <20200623124012.GV2428291@smile.fi.intel.com>
References: <1592914031-31049-1-git-send-email-alan.maguire@oracle.com>
 <1592914031-31049-5-git-send-email-alan.maguire@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592914031-31049-5-git-send-email-alan.maguire@oracle.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 01:07:07PM +0100, Alan Maguire wrote:
> printk supports multiple pointer object type specifiers (printing
> netdev features etc).  Extend this support using BTF to cover
> arbitrary types.

Is there any plans to cover (all?) existing %p extensions?

> "%pT"

One letter namespace is quite busy area. Perhaps %pOT ?

> specifies the typed format, and the pointer
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

I don't see how it looks on a real console when kernel dumps something.
Care to provide? These examples better to have documented.

> printk output is truncated at 1024 bytes.  For cases where overflow
> is likely, the compact/no type names display modes may be used.

How * is handled? (I mean %*pOT case)

...

> +#define	BTF_PTR_TYPE(ptrval, typeval) \
> +	(&((struct btf_ptr){.ptr = ptrval, .type = #typeval}))
> +
> +#define BTF_PTR_ID(ptrval, idval) \
> +	(&((struct btf_ptr){.ptr = ptrval, .id = idval}))

Wouldn't be better if these will leave in its own (linker) section?

...

> +static noinline_for_stack
> +char *btf_string(char *buf, char *end, void *ptr, struct printf_spec spec,
> +		 const char *fmt)
> +{

> +	struct btf_ptr *bp = (struct btf_ptr *)ptr;

Unneeded casting.

> +	u8 btf_kind = BTF_KIND_TYPEDEF;
> +	const struct btf_type *t;
> +	const struct btf *btf;
> +	char *buf_start = buf;
> +	const char *btf_type;
> +	u64 flags = 0, mod;
> +	s32 btf_id;
> +
> +	if (check_pointer(&buf, end, ptr, spec))
> +		return buf;
> +
> +	if (check_pointer(&buf, end, bp->ptr, spec))
> +		return buf;

> +	while (isalnum(*fmt)) {
> +		mod = btf_modifier_flag(*fmt);
> +		if (!mod)
> +			break;
> +		flags |= mod;
> +		fmt++;
> +	}

Can't we have explicitly all handled flags here, like other extensions do?

> +	btf = bpf_get_btf_vmlinux();
> +	if (IS_ERR_OR_NULL(btf))
> +		return ptr_to_id(buf, end, bp->ptr, spec);
> +
> +	if (bp->type != NULL) {
> +		btf_type = bp->type;
> +
> +		if (strncmp(bp->type, "struct ", strlen("struct ")) == 0) {
> +			btf_kind = BTF_KIND_STRUCT;
> +			btf_type += strlen("struct ");
> +		} else if (strncmp(btf_type, "union ", strlen("union ")) == 0) {
> +			btf_kind = BTF_KIND_UNION;
> +			btf_type += strlen("union ");
> +		} else if (strncmp(btf_type, "enum ", strlen("enum ")) == 0) {
> +			btf_kind = BTF_KIND_ENUM;
> +			btf_type += strlen("enum ");
> +		}

Can't you provide a simple structure and do this in a loop?
Or even something like match_[partial]string() to implement?

> +		if (strlen(btf_type) == 0)

Interesting way of checking btf_type == '\0'.

> +			return ptr_to_id(buf, end, bp->ptr, spec);
> +
> +		/*
> +		 * Assume type specified is a typedef as there's not much
> +		 * benefit in specifying int types other than wasting time
> +		 * on BTF lookups; we optimize for the most useful path.
> +		 *
> +		 * Fall back to BTF_KIND_INT if this fails.
> +		 */
> +		btf_id = btf_find_by_name_kind(btf, btf_type, btf_kind);
> +		if (btf_id < 0)
> +			btf_id = btf_find_by_name_kind(btf, btf_type,
> +						       BTF_KIND_INT);
> +	} else if (bp->id > 0)
> +		btf_id = bp->id;
> +	else
> +		return ptr_to_id(buf, end, bp->ptr, spec);
> +

> +	if (btf_id > 0)
> +		t = btf_type_by_id(btf, btf_id);
> +	if (btf_id <= 0 || !t)
> +		return ptr_to_id(buf, end, bp->ptr, spec);

This can be easily incorporated in previous conditional tree.

> +	buf += btf_type_snprintf_show(btf, btf_id, bp->ptr, buf,
> +				      end - buf_start, flags);
> +
> +	return widen_string(buf, buf - buf_start, end, spec);
> +}

-- 
With Best Regards,
Andy Shevchenko


