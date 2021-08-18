Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534263F00AE
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 11:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbhHRJiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 05:38:00 -0400
Received: from mga14.intel.com ([192.55.52.115]:31816 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234956AbhHRJg5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 05:36:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10079"; a="216017220"
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="216017220"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 02:36:11 -0700
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="641264466"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 02:36:05 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mGHzK-00B45i-QA; Wed, 18 Aug 2021 12:35:58 +0300
Date:   Wed, 18 Aug 2021 12:35:58 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, Andy Shevchenko <andy@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 26/63] lib/string: Move helper functions out of
 string.c
Message-ID: <YRzUfib7a/APXztH@smile.fi.intel.com>
References: <20210818060533.3569517-1-keescook@chromium.org>
 <20210818060533.3569517-27-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818060533.3569517-27-keescook@chromium.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 11:04:56PM -0700, Kees Cook wrote:
> The core functions of string.c are those that may be implemented by
> per-architecture functions, or overloaded by FORTIFY_SOURCE. As a
> result, it needs to be built with __NO_FORTIFY. Without this, macros
> will collide with function declarations. This was accidentally working
> due to -ffreestanding (on some architectures). Make this deterministic
> by explicitly setting __NO_FORTIFY and move all the helper functions
> into string_helpers.c so that they gain the fortification coverage they
> had been missing.

No objections
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Cc: Andy Shevchenko <andy@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Andy Lavr <andy.lavr@gmail.com>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/arm/boot/compressed/string.c     |   1 +
>  arch/s390/lib/string.c                |   3 +
>  arch/x86/boot/compressed/misc.h       |   2 +
>  arch/x86/boot/compressed/pgtable_64.c |   2 +
>  arch/x86/lib/string_32.c              |   1 +
>  lib/string.c                          | 210 +-------------------------
>  lib/string_helpers.c                  | 193 +++++++++++++++++++++++
>  7 files changed, 208 insertions(+), 204 deletions(-)
> 
> diff --git a/arch/arm/boot/compressed/string.c b/arch/arm/boot/compressed/string.c
> index 8c0fa276d994..fcc678fce045 100644
> --- a/arch/arm/boot/compressed/string.c
> +++ b/arch/arm/boot/compressed/string.c
> @@ -5,6 +5,7 @@
>   * Small subset of simple string routines
>   */
>  
> +#define __NO_FORTIFY
>  #include <linux/string.h>
>  
>  /*
> diff --git a/arch/s390/lib/string.c b/arch/s390/lib/string.c
> index cfcdf76d6a95..392fb9f4f4db 100644
> --- a/arch/s390/lib/string.c
> +++ b/arch/s390/lib/string.c
> @@ -8,6 +8,9 @@
>   */
>  
>  #define IN_ARCH_STRING_C 1
> +#ifndef __NO_FORTIFY
> +# define __NO_FORTIFY
> +#endif
>  
>  #include <linux/types.h>
>  #include <linux/string.h>
> diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
> index 31139256859f..49bde196da9b 100644
> --- a/arch/x86/boot/compressed/misc.h
> +++ b/arch/x86/boot/compressed/misc.h
> @@ -14,6 +14,8 @@
>  #undef CONFIG_KASAN
>  #undef CONFIG_KASAN_GENERIC
>  
> +#define __NO_FORTIFY
> +
>  /* cpu_feature_enabled() cannot be used this early */
>  #define USE_EARLY_PGTABLE_L5
>  
> diff --git a/arch/x86/boot/compressed/pgtable_64.c b/arch/x86/boot/compressed/pgtable_64.c
> index 2a78746f5a4c..a1733319a22a 100644
> --- a/arch/x86/boot/compressed/pgtable_64.c
> +++ b/arch/x86/boot/compressed/pgtable_64.c
> @@ -1,3 +1,5 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include "misc.h"
>  #include <linux/efi.h>
>  #include <asm/e820/types.h>
>  #include <asm/processor.h>
> diff --git a/arch/x86/lib/string_32.c b/arch/x86/lib/string_32.c
> index d15fdae9656e..53b3f202267c 100644
> --- a/arch/x86/lib/string_32.c
> +++ b/arch/x86/lib/string_32.c
> @@ -11,6 +11,7 @@
>   * strings.
>   */
>  
> +#define __NO_FORTIFY
>  #include <linux/string.h>
>  #include <linux/export.h>
>  
> diff --git a/lib/string.c b/lib/string.c
> index 4fec38fc6e58..4e111d9dd6d5 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -6,20 +6,15 @@
>   */
>  
>  /*
> - * stupid library routines.. The optimized versions should generally be found
> - * as inline code in <asm-xx/string.h>
> + * This file should be used only for "library" routines that may have
> + * alternative implementations on specific architectures (generally
> + * found in <asm-xx/string.h>), or get overloaded by FORTIFY_SOURCE.
> + * (Specifically, this file is built with __NO_FORTIFY.)
>   *
> - * These are buggy as well..
> - *
> - * * Fri Jun 25 1999, Ingo Oeser <ioe@informatik.tu-chemnitz.de>
> - * -  Added strsep() which will replace strtok() soon (because strsep() is
> - *    reentrant and should be faster). Use only strsep() in new code, please.
> - *
> - * * Sat Feb 09 2002, Jason Thomas <jason@topic.com.au>,
> - *                    Matthew Hawkins <matt@mh.dropbear.id.au>
> - * -  Kissed strtok() goodbye
> + * Other helper functions should live in string_helpers.c.
>   */
>  
> +#define __NO_FORTIFY
>  #include <linux/types.h>
>  #include <linux/string.h>
>  #include <linux/ctype.h>
> @@ -254,40 +249,6 @@ ssize_t strscpy(char *dest, const char *src, size_t count)
>  EXPORT_SYMBOL(strscpy);
>  #endif
>  
> -/**
> - * strscpy_pad() - Copy a C-string into a sized buffer
> - * @dest: Where to copy the string to
> - * @src: Where to copy the string from
> - * @count: Size of destination buffer
> - *
> - * Copy the string, or as much of it as fits, into the dest buffer.  The
> - * behavior is undefined if the string buffers overlap.  The destination
> - * buffer is always %NUL terminated, unless it's zero-sized.
> - *
> - * If the source string is shorter than the destination buffer, zeros
> - * the tail of the destination buffer.
> - *
> - * For full explanation of why you may want to consider using the
> - * 'strscpy' functions please see the function docstring for strscpy().
> - *
> - * Returns:
> - * * The number of characters copied (not including the trailing %NUL)
> - * * -E2BIG if count is 0 or @src was truncated.
> - */
> -ssize_t strscpy_pad(char *dest, const char *src, size_t count)
> -{
> -	ssize_t written;
> -
> -	written = strscpy(dest, src, count);
> -	if (written < 0 || written == count - 1)
> -		return written;
> -
> -	memset(dest + written + 1, 0, count - written - 1);
> -
> -	return written;
> -}
> -EXPORT_SYMBOL(strscpy_pad);
> -
>  /**
>   * stpcpy - copy a string from src to dest returning a pointer to the new end
>   *          of dest, including src's %NUL-terminator. May overrun dest.
> @@ -530,46 +491,6 @@ char *strnchr(const char *s, size_t count, int c)
>  EXPORT_SYMBOL(strnchr);
>  #endif
>  
> -/**
> - * skip_spaces - Removes leading whitespace from @str.
> - * @str: The string to be stripped.
> - *
> - * Returns a pointer to the first non-whitespace character in @str.
> - */
> -char *skip_spaces(const char *str)
> -{
> -	while (isspace(*str))
> -		++str;
> -	return (char *)str;
> -}
> -EXPORT_SYMBOL(skip_spaces);
> -
> -/**
> - * strim - Removes leading and trailing whitespace from @s.
> - * @s: The string to be stripped.
> - *
> - * Note that the first trailing whitespace is replaced with a %NUL-terminator
> - * in the given string @s. Returns a pointer to the first non-whitespace
> - * character in @s.
> - */
> -char *strim(char *s)
> -{
> -	size_t size;
> -	char *end;
> -
> -	size = strlen(s);
> -	if (!size)
> -		return s;
> -
> -	end = s + size - 1;
> -	while (end >= s && isspace(*end))
> -		end--;
> -	*(end + 1) = '\0';
> -
> -	return skip_spaces(s);
> -}
> -EXPORT_SYMBOL(strim);
> -
>  #ifndef __HAVE_ARCH_STRLEN
>  /**
>   * strlen - Find the length of a string
> @@ -704,101 +625,6 @@ char *strsep(char **s, const char *ct)
>  EXPORT_SYMBOL(strsep);
>  #endif
>  
> -/**
> - * sysfs_streq - return true if strings are equal, modulo trailing newline
> - * @s1: one string
> - * @s2: another string
> - *
> - * This routine returns true iff two strings are equal, treating both
> - * NUL and newline-then-NUL as equivalent string terminations.  It's
> - * geared for use with sysfs input strings, which generally terminate
> - * with newlines but are compared against values without newlines.
> - */
> -bool sysfs_streq(const char *s1, const char *s2)
> -{
> -	while (*s1 && *s1 == *s2) {
> -		s1++;
> -		s2++;
> -	}
> -
> -	if (*s1 == *s2)
> -		return true;
> -	if (!*s1 && *s2 == '\n' && !s2[1])
> -		return true;
> -	if (*s1 == '\n' && !s1[1] && !*s2)
> -		return true;
> -	return false;
> -}
> -EXPORT_SYMBOL(sysfs_streq);
> -
> -/**
> - * match_string - matches given string in an array
> - * @array:	array of strings
> - * @n:		number of strings in the array or -1 for NULL terminated arrays
> - * @string:	string to match with
> - *
> - * This routine will look for a string in an array of strings up to the
> - * n-th element in the array or until the first NULL element.
> - *
> - * Historically the value of -1 for @n, was used to search in arrays that
> - * are NULL terminated. However, the function does not make a distinction
> - * when finishing the search: either @n elements have been compared OR
> - * the first NULL element was found.
> - *
> - * Return:
> - * index of a @string in the @array if matches, or %-EINVAL otherwise.
> - */
> -int match_string(const char * const *array, size_t n, const char *string)
> -{
> -	int index;
> -	const char *item;
> -
> -	for (index = 0; index < n; index++) {
> -		item = array[index];
> -		if (!item)
> -			break;
> -		if (!strcmp(item, string))
> -			return index;
> -	}
> -
> -	return -EINVAL;
> -}
> -EXPORT_SYMBOL(match_string);
> -
> -/**
> - * __sysfs_match_string - matches given string in an array
> - * @array: array of strings
> - * @n: number of strings in the array or -1 for NULL terminated arrays
> - * @str: string to match with
> - *
> - * Returns index of @str in the @array or -EINVAL, just like match_string().
> - * Uses sysfs_streq instead of strcmp for matching.
> - *
> - * This routine will look for a string in an array of strings up to the
> - * n-th element in the array or until the first NULL element.
> - *
> - * Historically the value of -1 for @n, was used to search in arrays that
> - * are NULL terminated. However, the function does not make a distinction
> - * when finishing the search: either @n elements have been compared OR
> - * the first NULL element was found.
> - */
> -int __sysfs_match_string(const char * const *array, size_t n, const char *str)
> -{
> -	const char *item;
> -	int index;
> -
> -	for (index = 0; index < n; index++) {
> -		item = array[index];
> -		if (!item)
> -			break;
> -		if (sysfs_streq(item, str))
> -			return index;
> -	}
> -
> -	return -EINVAL;
> -}
> -EXPORT_SYMBOL(__sysfs_match_string);
> -
>  #ifndef __HAVE_ARCH_MEMSET
>  /**
>   * memset - Fill a region of memory with the given value
> @@ -1221,27 +1047,3 @@ void *memchr_inv(const void *start, int c, size_t bytes)
>  	return check_bytes8(start, value, bytes % 8);
>  }
>  EXPORT_SYMBOL(memchr_inv);
> -
> -/**
> - * strreplace - Replace all occurrences of character in string.
> - * @s: The string to operate on.
> - * @old: The character being replaced.
> - * @new: The character @old is replaced with.
> - *
> - * Returns pointer to the nul byte at the end of @s.
> - */
> -char *strreplace(char *s, char old, char new)
> -{
> -	for (; *s; ++s)
> -		if (*s == old)
> -			*s = new;
> -	return s;
> -}
> -EXPORT_SYMBOL(strreplace);
> -
> -void fortify_panic(const char *name)
> -{
> -	pr_emerg("detected buffer overflow in %s\n", name);
> -	BUG();
> -}
> -EXPORT_SYMBOL(fortify_panic);
> diff --git a/lib/string_helpers.c b/lib/string_helpers.c
> index 3806a52ce697..bde13612c25d 100644
> --- a/lib/string_helpers.c
> +++ b/lib/string_helpers.c
> @@ -696,3 +696,196 @@ void kfree_strarray(char **array, size_t n)
>  	kfree(array);
>  }
>  EXPORT_SYMBOL_GPL(kfree_strarray);
> +
> +/**
> + * strscpy_pad() - Copy a C-string into a sized buffer
> + * @dest: Where to copy the string to
> + * @src: Where to copy the string from
> + * @count: Size of destination buffer
> + *
> + * Copy the string, or as much of it as fits, into the dest buffer.  The
> + * behavior is undefined if the string buffers overlap.  The destination
> + * buffer is always %NUL terminated, unless it's zero-sized.
> + *
> + * If the source string is shorter than the destination buffer, zeros
> + * the tail of the destination buffer.
> + *
> + * For full explanation of why you may want to consider using the
> + * 'strscpy' functions please see the function docstring for strscpy().
> + *
> + * Returns:
> + * * The number of characters copied (not including the trailing %NUL)
> + * * -E2BIG if count is 0 or @src was truncated.
> + */
> +ssize_t strscpy_pad(char *dest, const char *src, size_t count)
> +{
> +	ssize_t written;
> +
> +	written = strscpy(dest, src, count);
> +	if (written < 0 || written == count - 1)
> +		return written;
> +
> +	memset(dest + written + 1, 0, count - written - 1);
> +
> +	return written;
> +}
> +EXPORT_SYMBOL(strscpy_pad);
> +
> +/**
> + * skip_spaces - Removes leading whitespace from @str.
> + * @str: The string to be stripped.
> + *
> + * Returns a pointer to the first non-whitespace character in @str.
> + */
> +char *skip_spaces(const char *str)
> +{
> +	while (isspace(*str))
> +		++str;
> +	return (char *)str;
> +}
> +EXPORT_SYMBOL(skip_spaces);
> +
> +/**
> + * strim - Removes leading and trailing whitespace from @s.
> + * @s: The string to be stripped.
> + *
> + * Note that the first trailing whitespace is replaced with a %NUL-terminator
> + * in the given string @s. Returns a pointer to the first non-whitespace
> + * character in @s.
> + */
> +char *strim(char *s)
> +{
> +	size_t size;
> +	char *end;
> +
> +	size = strlen(s);
> +	if (!size)
> +		return s;
> +
> +	end = s + size - 1;
> +	while (end >= s && isspace(*end))
> +		end--;
> +	*(end + 1) = '\0';
> +
> +	return skip_spaces(s);
> +}
> +EXPORT_SYMBOL(strim);
> +
> +/**
> + * sysfs_streq - return true if strings are equal, modulo trailing newline
> + * @s1: one string
> + * @s2: another string
> + *
> + * This routine returns true iff two strings are equal, treating both
> + * NUL and newline-then-NUL as equivalent string terminations.  It's
> + * geared for use with sysfs input strings, which generally terminate
> + * with newlines but are compared against values without newlines.
> + */
> +bool sysfs_streq(const char *s1, const char *s2)
> +{
> +	while (*s1 && *s1 == *s2) {
> +		s1++;
> +		s2++;
> +	}
> +
> +	if (*s1 == *s2)
> +		return true;
> +	if (!*s1 && *s2 == '\n' && !s2[1])
> +		return true;
> +	if (*s1 == '\n' && !s1[1] && !*s2)
> +		return true;
> +	return false;
> +}
> +EXPORT_SYMBOL(sysfs_streq);
> +
> +/**
> + * match_string - matches given string in an array
> + * @array:	array of strings
> + * @n:		number of strings in the array or -1 for NULL terminated arrays
> + * @string:	string to match with
> + *
> + * This routine will look for a string in an array of strings up to the
> + * n-th element in the array or until the first NULL element.
> + *
> + * Historically the value of -1 for @n, was used to search in arrays that
> + * are NULL terminated. However, the function does not make a distinction
> + * when finishing the search: either @n elements have been compared OR
> + * the first NULL element was found.
> + *
> + * Return:
> + * index of a @string in the @array if matches, or %-EINVAL otherwise.
> + */
> +int match_string(const char * const *array, size_t n, const char *string)
> +{
> +	int index;
> +	const char *item;
> +
> +	for (index = 0; index < n; index++) {
> +		item = array[index];
> +		if (!item)
> +			break;
> +		if (!strcmp(item, string))
> +			return index;
> +	}
> +
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL(match_string);
> +
> +/**
> + * __sysfs_match_string - matches given string in an array
> + * @array: array of strings
> + * @n: number of strings in the array or -1 for NULL terminated arrays
> + * @str: string to match with
> + *
> + * Returns index of @str in the @array or -EINVAL, just like match_string().
> + * Uses sysfs_streq instead of strcmp for matching.
> + *
> + * This routine will look for a string in an array of strings up to the
> + * n-th element in the array or until the first NULL element.
> + *
> + * Historically the value of -1 for @n, was used to search in arrays that
> + * are NULL terminated. However, the function does not make a distinction
> + * when finishing the search: either @n elements have been compared OR
> + * the first NULL element was found.
> + */
> +int __sysfs_match_string(const char * const *array, size_t n, const char *str)
> +{
> +	const char *item;
> +	int index;
> +
> +	for (index = 0; index < n; index++) {
> +		item = array[index];
> +		if (!item)
> +			break;
> +		if (sysfs_streq(item, str))
> +			return index;
> +	}
> +
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL(__sysfs_match_string);
> +
> +/**
> + * strreplace - Replace all occurrences of character in string.
> + * @s: The string to operate on.
> + * @old: The character being replaced.
> + * @new: The character @old is replaced with.
> + *
> + * Returns pointer to the nul byte at the end of @s.
> + */
> +char *strreplace(char *s, char old, char new)
> +{
> +	for (; *s; ++s)
> +		if (*s == old)
> +			*s = new;
> +	return s;
> +}
> +EXPORT_SYMBOL(strreplace);
> +
> +void fortify_panic(const char *name)
> +{
> +	pr_emerg("detected buffer overflow in %s\n", name);
> +	BUG();
> +}
> +EXPORT_SYMBOL(fortify_panic);
> -- 
> 2.30.2
> 

-- 
With Best Regards,
Andy Shevchenko


