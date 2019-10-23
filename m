Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD92E26BF
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 00:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392084AbfJWW4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 18:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727831AbfJWW4U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 18:56:20 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77AFA21929;
        Wed, 23 Oct 2019 22:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571871379;
        bh=pH0FnxHuQ4uryY+5yag7Co6S+Z3nSAfsh/gAbdxNnLk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NZLyOT+ZqApYNjFfkvN4E7nfBNCZAjOdC/wzoETDChxjDRKMAXrf0iSDA2NpO1dAl
         n3jrJoabu0ncBYm24CEnLneZZFelnIqDG07Oa2FG2xVneQxq6qjLqnh4rNvt1Xk8HB
         diUUCetS09WEi0qR/QGP/DU2B2gikuUL57m32dSk=
Date:   Wed, 23 Oct 2019 15:56:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     linux-kernel@vger.kernel.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gfx@lists.freedesktop.org,
        Vishal Kulkarni <vishal@chelsio.com>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH v4] string-choice: add yesno(), onoff(),
 enableddisabled(), plural() helpers
Message-Id: <20191023155619.43e0013f0c8c673a5c508c1e@linux-foundation.org>
In-Reply-To: <20191023131308.9420-1-jani.nikula@intel.com>
References: <20191023131308.9420-1-jani.nikula@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Oct 2019 16:13:08 +0300 Jani Nikula <jani.nikula@intel.com> wrot=
e:

> The kernel has plenty of ternary operators to choose between constant
> strings, such as condition ? "yes" : "no", as well as value =3D=3D 1 ? ""=
 :
> "s":
>=20
> $ git grep '? "yes" : "no"' | wc -l
> 258
> $ git grep '? "on" : "off"' | wc -l
> 204
> $ git grep '? "enabled" : "disabled"' | wc -l
> 196
> $ git grep '? "" : "s"' | wc -l
> 25
>=20
> Additionally, there are some occurences of the same in reverse order,
> split to multiple lines, or otherwise not caught by the simple grep.
>=20
> Add helpers to return the constant strings. Remove existing equivalent
> and conflicting functions in i915, cxgb4, and USB core. Further
> conversion can be done incrementally.
>=20
> The main goal here is to abstract recurring patterns, and slightly clean
> up the code base by not open coding the ternary operators.

Fair enough.

> --- /dev/null
> +++ b/include/linux/string-choice.h
> @@ -0,0 +1,31 @@
> +/* SPDX-License-Identifier: MIT */
> +/*
> + * Copyright =A9 2019 Intel Corporation
> + */
> +
> +#ifndef __STRING_CHOICE_H__
> +#define __STRING_CHOICE_H__
> +
> +#include <linux/types.h>
> +
> +static inline const char *yesno(bool v)
> +{
> +	return v ? "yes" : "no";
> +}
> +
> +static inline const char *onoff(bool v)
> +{
> +	return v ? "on" : "off";
> +}
> +
> +static inline const char *enableddisabled(bool v)
> +{
> +	return v ? "enabled" : "disabled";
> +}
> +
> +static inline const char *plural(long v)
> +{
> +	return v =3D=3D 1 ? "" : "s";
> +}
> +
> +#endif /* __STRING_CHOICE_H__ */

These aren't very good function names.  Better to create a kernel-style
namespace such as "choice_" and then add the expected underscores:

choice_yes_no()
choice_enabled_disabled()
choice_plural()

(Example: note that slabinfo.c already has an "onoff()").


Also, I worry that making these functions inline means that each .o
file will contain its own copy of the strings ("yes", "no", "enabled",
etc) if the .c file calls the relevant helper.  I'm not sure if the
linker is smart enough (yet) to fix this up.  If not, we will end up
with a smaller kernel by uninlining these functions.=20
lib/string-choice.c would suit.

And doing this will cause additional savings: calling a single-arg
out-of-line function generates less .text than calling yesno().  When I
did this:=20

--- a/include/linux/string-choice.h~string-choice-add-yesno-onoff-enableddi=
sabled-plural-helpers-fix
+++ a/include/linux/string-choice.h
@@ -8,10 +8,7 @@
=20
 #include <linux/types.h>
=20
-static inline const char *yesno(bool v)
-{
-	return v ? "yes" : "no";
-}
+const char *yesno(bool v);
=20
 static inline const char *onoff(bool v)
 {

The text segment of drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.o
(78 callsites) shrunk by 118 bytes.

