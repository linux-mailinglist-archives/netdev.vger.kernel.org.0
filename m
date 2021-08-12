Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8BE3EA252
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 11:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236297AbhHLJqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 05:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234835AbhHLJqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 05:46:23 -0400
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64AE4C0613D5
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 02:45:58 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:438:1ff1:1071:f524])
        by albert.telenet-ops.be with bizsmtp
        id gZlv2500U1gJxCh06ZlvCo; Thu, 12 Aug 2021 11:45:56 +0200
Received: from geert (helo=localhost)
        by ramsan.of.borg with local-esmtp (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mE7Hf-002E9j-7z; Thu, 12 Aug 2021 11:45:55 +0200
Date:   Thu, 12 Aug 2021 11:45:55 +0200 (CEST)
From:   Geert Uytterhoeven <geert@linux-m68k.org>
X-X-Sender: geert@ramsan.of.borg
To:     Jeremy Kerr <jk@codeconstruct.com.au>
cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>, netdev@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>
Subject: Re: [PATCH net-next v3 01/16] mctp: Add MCTP base
In-Reply-To: <20210723082932.3570396-2-jk@codeconstruct.com.au>
Message-ID: <alpine.DEB.2.22.394.2108121139490.530553@ramsan.of.borg>
References: <20210723082932.3570396-1-jk@codeconstruct.com.au> <20210723082932.3570396-2-jk@codeconstruct.com.au>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 	Hi Jeremy,

CC kbuild

On Fri, 23 Jul 2021, Jeremy Kerr wrote:
> Add basic Kconfig, an initial (empty) af_mctp source object, and
> {AF,PF}_MCTP definitions, and the required selinux definitions.
>
> Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>

Thanks for your patch, which is now commit bc49d8169aa72295 ("mctp: Add
MCTP base") in net-next.

> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -1330,7 +1330,9 @@ static inline u16 socket_type_to_security_class(int family, int type, int protoc
> 			return SECCLASS_SMC_SOCKET;
> 		case PF_XDP:
> 			return SECCLASS_XDP_SOCKET;
> -#if PF_MAX > 45
> +		case PF_MCTP:
> +			return SECCLASS_MCTP_SOCKET;

When building an allmodconfig kernel, I got:

security/selinux/hooks.c: In function 'socket_type_to_security_class':
security/selinux/hooks.c:1334:32: error: 'SECCLASS_MCTP_SOCKET' undeclared (first use in this function); did you mean 'SECCLASS_SCTP_SOCKET'?
  1334 |                         return SECCLASS_MCTP_SOCKET;
       |                                ^~~~~~~~~~~~~~~~~~~~
       |                                SECCLASS_SCTP_SOCKET

> +#if PF_MAX > 46
> #error New address family defined, please update this function.
> #endif
> 		}
> diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
> index 62d19bccf3de..084757ff4390 100644
> --- a/security/selinux/include/classmap.h
> +++ b/security/selinux/include/classmap.h
> @@ -246,6 +246,8 @@ struct security_class_mapping secclass_map[] = {
> 	    NULL } },
> 	{ "xdp_socket",
> 	  { COMMON_SOCK_PERMS, NULL } },
> +	{ "mctp_socket",
> +	  { COMMON_SOCK_PERMS, NULL } },
> 	{ "perf_event",
> 	  { "open", "cpu", "kernel", "tracepoint", "read", "write", NULL } },
> 	{ "lockdown",

The needed definition should be auto-generated from the above file, but
there seems to be an issue with the dependencies, as the file was not
regenerated.

Manually removing security/selinux/flask.h in the build dir fixed the
issue.

I'm building in a separate build directory, using make -j 12.

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
