Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542842E9A47
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 17:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729368AbhADQHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 11:07:51 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:6748 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729359AbhADQHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 11:07:49 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff33d2d0000>; Mon, 04 Jan 2021 08:07:09 -0800
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 Jan 2021 16:07:07
 +0000
References: <1609355503-7981-1-git-send-email-roid@nvidia.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     Roi Dayan <roid@nvidia.com>
CC:     <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Petr Machata <me@pmachata.org>
Subject: Re: [PATCH iproute2] build: Fix link errors on some systems
In-Reply-To: <1609355503-7981-1-git-send-email-roid@nvidia.com>
Date:   Mon, 4 Jan 2021 17:07:03 +0100
Message-ID: <875z4cwus8.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609776429; bh=kae85lVJRzjkG8joHmgdz6IDau65H4UdESovU0IeXZo=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=OqbrZGFwrb81HDpqJ74P8oiTnP2Onr09OYqbyl4rIw6jURRkAZxNvLnMMj+c1yu1z
         BOMdgWxeyUKJQzpc8dUNtmnCFBKXv68br/3JII+BdLZtQS45vajG+bc/g3ZADB8ap9
         crzcRh9QTau5DNzZNK9st/c1Y7eDB64gpjCVlb8371Tx8zJ+O8V7w71dBdz1+H5Hht
         UNvBeQlVoDHYyVS3WODBspm1xd5aMKz7GnFbM13j3nfdkpQTIgCV3EmOBEoUZkIf80
         ltCeYeQ9L0kusc9UixQeeytJU15qwajuRvHwIxlSdPKjStNDmak0D7AmBb+xMX6au6
         9IhlRH6zQuxxg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Roi Dayan <roid@nvidia.com> writes:

> Since moving get_rate() and get_size() from tc to lib, on some
> systems we fail to link because of missing the math lib.
> Move the link flag from tc makefile to the main makefile.

Hmm, yeah, it gets optimized out on x86-64. The issue is reproducible
on any platform with -O0.

> ../lib/libutil.a(utils.o): In function `get_rate':
> utils.c:(.text+0x10dc): undefined reference to `floor'
> ../lib/libutil.a(utils.o): In function `get_size':
> utils.c:(.text+0x1394): undefined reference to `floor'
> ../lib/libutil.a(json_print.o): In function `sprint_size':
> json_print.c:(.text+0x14c0): undefined reference to `rint'
> json_print.c:(.text+0x14f4): undefined reference to `rint'
> json_print.c:(.text+0x157c): undefined reference to `rint'
>
> Fixes: f3be0e6366ac ("lib: Move get_rate(), get_rate64() from tc here")
> Fixes: 44396bdfcc0a ("lib: Move get_size() from tc here")
> Fixes: adbe5de96662 ("lib: Move sprint_size() from tc here, add print_size()")
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> ---
>  Makefile    | 1 +
>  tc/Makefile | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index e64c65992585..2a604ec58905 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -59,6 +59,7 @@ SUBDIRS=lib ip tc bridge misc netem genl tipc devlink rdma dcb man
>  
>  LIBNETLINK=../lib/libutil.a ../lib/libnetlink.a
>  LDLIBS += $(LIBNETLINK)
> +LDFLAGS += -lm
>  
>  all: config.mk
>  	@set -e; \
> diff --git a/tc/Makefile b/tc/Makefile
> index 5a517af20b7c..8d91900716c1 100644
> --- a/tc/Makefile
> +++ b/tc/Makefile
> @@ -110,7 +110,7 @@ ifneq ($(TC_CONFIG_NO_XT),y)
>  endif
>  
>  TCOBJ += $(TCMODULES)
> -LDLIBS += -L. -lm
> +LDLIBS += -L.
>  
>  ifeq ($(SHARED_LIBS),y)
>  LDLIBS += -ldl

This will work, but it will give a libm dependency to all the tools.
util.c currently tries not to do that:

	/* emulate ceil() without having to bring-in -lm and always be >= 1 */
	*val = t;
	if (*val < t)
		*val += 1;

I think that just adding an unnecessary -lm is more of a tidiness issue
than anything else. One way to avoid it is to split the -lm deps out
from util.c / json_print.c to like util_math.c / json_print_math.c. That
way they will be in an .o of their own, and won't be linked in unless
the binary in question needs the code. Then the binaries that do call it
can keep on linking in -lm like they did so far.

Thoughts?
