Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF2B420404
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 23:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbhJCVK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 17:10:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231484AbhJCVKZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 17:10:25 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EED961266;
        Sun,  3 Oct 2021 21:08:36 +0000 (UTC)
Date:   Sun, 3 Oct 2021 17:08:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>, netdev@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>
Subject: Re: [PATCH net-next v3 01/16] mctp: Add MCTP base
Message-ID: <20211003170835.0e157b78@rorschach.local.home>
In-Reply-To: <63a6e8ad8a8ae908aa73a3f910b98692c1a9aa37.camel@codeconstruct.com.au>
References: <20210723082932.3570396-1-jk@codeconstruct.com.au>
        <20210723082932.3570396-2-jk@codeconstruct.com.au>
        <alpine.DEB.2.22.394.2108121139490.530553@ramsan.of.borg>
        <63a6e8ad8a8ae908aa73a3f910b98692c1a9aa37.camel@codeconstruct.com.au>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Aug 2021 19:15:24 +0800
Jeremy Kerr <jk@codeconstruct.com.au> wrote:

> Hi Geert,
> 
> Thanks for the testing!
> 
> > When building an allmodconfig kernel, I got:  
> 
> [...]
> 
> I don't see this on a clean allmodconfig build, nor when building the
> previous commit then the MCTP commit with something like:
> 
>   git checkout bc49d81^
>   make O=obj.allmodconfig allmodconfig
>   make O=obj.allmodconfig -j16
>   git checkout bc49d81
>   make O=obj.allmodconfig -j16
> 
> - but it seems like it might be up to the ordering of a parallel build.
> 
> >From your description, it does sound like it's not regenerating flask.h;  
> the kbuild rules would seem to have a classmap.h -> flask.h dependency:
> 
>   $(addprefix $(obj)/,$(selinux-y)): $(obj)/flask.h
>   
>   quiet_cmd_flask = GEN     $(obj)/flask.h $(obj)/av_permissions.h
>         cmd_flask = scripts/selinux/genheaders/genheaders $(obj)/flask.h $(obj)/av_permissions.h
>   
>   targets += flask.h av_permissions.h
>   $(obj)/flask.h: $(src)/include/classmap.h FORCE
>   	$(call if_changed,flask)
> 
> however, classmap.h is #include-ed as part of the genheaders binary
> build, rather than read at runtime; maybe $(obj)/flask.h should depend
> on the genheaders binary, rather than $(src)/include/classmap.h ?
> 
> If you can reproduce, can you compare the ctimes with:
> 
>   stat scripts/selinux/genheaders/genheaders security/selinux/flask.h

I just hit the exact same issue. I build with O=../build/ and by removing
security/selinux/flask.h and av_permission.h, it built fine afterward.
Appears to be a dependency issue.

-- Steve

> 
> in your object dir?
> 
> Cheers,
> 
> 
> Jeremy
> 

