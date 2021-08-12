Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07873EA35B
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 13:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236728AbhHLLPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 07:15:54 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:40694 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbhHLLPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 07:15:53 -0400
Received: from pecola.lan (unknown [159.196.93.152])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 091382012C;
        Thu, 12 Aug 2021 19:15:25 +0800 (AWST)
Message-ID: <63a6e8ad8a8ae908aa73a3f910b98692c1a9aa37.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next v3 01/16] mctp: Add MCTP base
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>, netdev@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>
Date:   Thu, 12 Aug 2021 19:15:24 +0800
In-Reply-To: <alpine.DEB.2.22.394.2108121139490.530553@ramsan.of.borg>
References: <20210723082932.3570396-1-jk@codeconstruct.com.au>
         <20210723082932.3570396-2-jk@codeconstruct.com.au>
         <alpine.DEB.2.22.394.2108121139490.530553@ramsan.of.borg>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

Thanks for the testing!

> When building an allmodconfig kernel, I got:

[...]

I don't see this on a clean allmodconfig build, nor when building the
previous commit then the MCTP commit with something like:

  git checkout bc49d81^
  make O=obj.allmodconfig allmodconfig
  make O=obj.allmodconfig -j16
  git checkout bc49d81
  make O=obj.allmodconfig -j16

- but it seems like it might be up to the ordering of a parallel build.

From your description, it does sound like it's not regenerating flask.h;
the kbuild rules would seem to have a classmap.h -> flask.h dependency:

  $(addprefix $(obj)/,$(selinux-y)): $(obj)/flask.h
  
  quiet_cmd_flask = GEN     $(obj)/flask.h $(obj)/av_permissions.h
        cmd_flask = scripts/selinux/genheaders/genheaders $(obj)/flask.h $(obj)/av_permissions.h
  
  targets += flask.h av_permissions.h
  $(obj)/flask.h: $(src)/include/classmap.h FORCE
  	$(call if_changed,flask)

however, classmap.h is #include-ed as part of the genheaders binary
build, rather than read at runtime; maybe $(obj)/flask.h should depend
on the genheaders binary, rather than $(src)/include/classmap.h ?

If you can reproduce, can you compare the ctimes with:

  stat scripts/selinux/genheaders/genheaders security/selinux/flask.h

in your object dir?

Cheers,


Jeremy

