Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1EB53D85E7
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 04:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbhG1C3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 22:29:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233223AbhG1C3s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 22:29:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84F0D60F9D;
        Wed, 28 Jul 2021 02:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627439387;
        bh=BVDbpAxM+frKsf51jnSBcTwiQH8xLbDYLBzUc0RtR0M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l6M3v8Dq2RJdZLdrHlrRgTadlXo18w0hg79Ao53CwSywiG4PH3Rc4TbpW57kIzW1S
         pm6M6TV3FKuJCCcFSdzyGO71jyln5VcPtaUD9nOLMKg6Qx6n9Kx3C8uHVNO61i3M2u
         2SBMrLoYyWf49yVEfJt1aNS6NaEHgz5YEVHAERBnWdRvrBzlOIrmaM1ZZbV07FGLbm
         1uBebQ83iDB2f9hacpYv/eNbd5+KlFwLEzan/vnD+OXejhk1MnQvLRBZOVtKw5ga3w
         8WxfmT0ZIlecIgkas59dvSbF0KnQ7Su6ay6kZawGxUukuAv3MWwRrmhymS3vQE/f/P
         G4AuC1SuQNLjg==
Date:   Tue, 27 Jul 2021 21:32:17 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 04/64] stddef: Introduce struct_group() helper macro
Message-ID: <20210728023217.GC35706@embeddedor>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-5-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727205855.411487-5-keescook@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 01:57:55PM -0700, Kees Cook wrote:
> Kernel code has a regular need to describe groups of members within a
> structure usually when they need to be copied or initialized separately
> from the rest of the surrounding structure. The generally accepted design
> pattern in C is to use a named sub-struct:
> 
> 	struct foo {
> 		int one;
> 		struct {
> 			int two;
> 			int three;
> 		} thing;
> 		int four;
> 	};
> 
> This would allow for traditional references and sizing:
> 
> 	memcpy(&dst.thing, &src.thing, sizeof(dst.thing));
> 
> However, doing this would mean that referencing struct members enclosed
> by such named structs would always require including the sub-struct name
> in identifiers:
> 
> 	do_something(dst.thing.three);
> 
> This has tended to be quite inflexible, especially when such groupings
> need to be added to established code which causes huge naming churn.
> Three workarounds exist in the kernel for this problem, and each have
> other negative properties.
> 
> To avoid the naming churn, there is a design pattern of adding macro
> aliases for the named struct:
> 
> 	#define f_three thing.three
> 
> This ends up polluting the global namespace, and makes it difficult to
> search for identifiers.
> 
> Another common work-around in kernel code avoids the pollution by avoiding
> the named struct entirely, instead identifying the group's boundaries using
> either a pair of empty anonymous structs of a pair of zero-element arrays:
> 
> 	struct foo {
> 		int one;
> 		struct { } start;
> 		int two;
> 		int three;
> 		struct { } finish;
> 		int four;
> 	};
> 
> 	struct foo {
> 		int one;
> 		int start[0];
> 		int two;
> 		int three;
> 		int finish[0];
> 		int four;
> 	};
> 
> This allows code to avoid needing to use a sub-struct name for member
> references within the surrounding structure, but loses the benefits of
> being able to actually use such a struct, making it rather fragile. Using
> these requires open-coded calculation of sizes and offsets. The efforts
> made to avoid common mistakes include lots of comments, or adding various
> BUILD_BUG_ON()s. Such code is left with no way for the compiler to reason
> about the boundaries (e.g. the "start" object looks like it's 0 bytes
> in length and is not structurally associated with "finish"), making bounds
> checking depend on open-coded calculations:
> 
> 	if (length > offsetof(struct foo, finish) -
> 		     offsetof(struct foo, start))
> 		return -EINVAL;
> 	memcpy(&dst.start, &src.start, length);
> 
> However, the vast majority of places in the kernel that operate on
> groups of members do so without any identification of the grouping,
> relying either on comments or implicit knowledge of the struct contents,
> which is even harder for the compiler to reason about, and results in
> even more fragile manual sizing, usually depending on member locations
> outside of the region (e.g. to copy "two" and "three", use the start of
> "four" to find the size):
> 
> 	BUILD_BUG_ON((offsetof(struct foo, four) <
> 		      offsetof(struct foo, two)) ||
> 		     (offsetof(struct foo, four) <
> 		      offsetof(struct foo, three));
> 	if (length > offsetof(struct foo, four) -
> 		     offsetof(struct foo, two))
> 		return -EINVAL;
> 	memcpy(&dst.two, &src.two, length);
> 
> And both of the prior two idioms additionally appear to write beyond the
> end of the referenced struct member, forcing the compiler to ignore any
> attempt to perform bounds checking.
> 
> In order to have a regular programmatic way to describe a struct
> region that can be used for references and sizing, can be examined for
> bounds checking, avoids forcing the use of intermediate identifiers,
> and avoids polluting the global namespace, introduce the struct_group()
> macro. This macro wraps the member declarations to create an anonymous
> union of an anonymous struct (no intermediate name) and a named struct
> (for references and sizing):
> 
> 	struct foo {
> 		int one;
> 		struct_group(thing,
> 			int two,
> 			int three,
> 		);
> 		int four;
> 	};
> 
> 	if (length > sizeof(src.thing))
> 		return -EINVAL;
> 	memcpy(&dst.thing, &src.thing, length);
> 	do_something(dst.three);
> 
> There are some rare cases where the resulting struct_group() needs
> attributes added, so struct_group_attr() is also introduced to allow
> for specifying struct attributes (e.g. __align(x) or __packed).
> 
> Co-developed-by: Keith Packard <keithpac@amazon.com>
> Signed-off-by: Keith Packard <keithpac@amazon.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Love it! :)

Thanks
--
Gustavo

> ---
>  include/linux/stddef.h | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/include/linux/stddef.h b/include/linux/stddef.h
> index 998a4ba28eba..cf7f866944f9 100644
> --- a/include/linux/stddef.h
> +++ b/include/linux/stddef.h
> @@ -36,4 +36,38 @@ enum {
>  #define offsetofend(TYPE, MEMBER) \
>  	(offsetof(TYPE, MEMBER)	+ sizeof_field(TYPE, MEMBER))
>  
> +/**
> + * struct_group_attr(NAME, ATTRS, MEMBERS)
> + *
> + * Used to create an anonymous union of two structs with identical
> + * layout and size: one anonymous and one named. The former can be
> + * used normally without sub-struct naming, and the latter can be
> + * used to reason about the start, end, and size of the group of
> + * struct members. Includes structure attributes argument.
> + *
> + * @NAME: The name of the mirrored sub-struct
> + * @ATTRS: Any struct attributes (normally empty)
> + * @MEMBERS: The member declarations for the mirrored structs
> + */
> +#define struct_group_attr(NAME, ATTRS, MEMBERS) \
> +	union { \
> +		struct { MEMBERS } ATTRS; \
> +		struct { MEMBERS } ATTRS NAME; \
> +	}
> +
> +/**
> + * struct_group(NAME, MEMBERS)
> + *
> + * Used to create an anonymous union of two structs with identical
> + * layout and size: one anonymous and one named. The former can be
> + * used normally without sub-struct naming, and the latter can be
> + * used to reason about the start, end, and size of the group of
> + * struct members.
> + *
> + * @NAME: The name of the mirrored sub-struct
> + * @MEMBERS: The member declarations for the mirrored structs
> + */
> +#define struct_group(NAME, MEMBERS)	\
> +	struct_group_attr(NAME, /* no attrs */, MEMBERS)
> +
>  #endif
> -- 
> 2.30.2
> 
