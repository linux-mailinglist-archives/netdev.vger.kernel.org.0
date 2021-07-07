Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A093BE9CE
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 16:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbhGGOfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 10:35:41 -0400
Received: from relay.sw.ru ([185.231.240.75]:60224 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231737AbhGGOfk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 10:35:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:Mime-Version:Message-Id:Subject:From
        :Date; bh=08OI5C7j0cvbYqKjdzRFoM6eP2tkZHqnlHAxjXF+wU8=; b=bLB2p8093DOGmjBCwI8
        AoQARARURi2EJ9Cer9tQKbjbl6FOCv/yefzG8CanjF6qIRMRJ2ueee88lpCTSPwmbTbVBReUbyVTQ
        SBi34puydgFh69ORincZ/XnBN9iLFDX+tBg3mOKlsaqbpp9kknqILECXBrRnQAmoLsk6G7XSYu4=;
Received: from [192.168.15.10] (helo=mikhalitsyn-laptop)
        by relay.sw.ru with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1m18bj-003D2b-7U; Wed, 07 Jul 2021 17:32:59 +0300
Date:   Wed, 7 Jul 2021 17:32:58 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: Re: [PATCHv4 iproute2] ip route: ignore ENOENT during save if
 RT_TABLE_MAIN is being dumped
Message-Id: <20210707173258.65e56645af867acfd145085b@virtuozzo.com>
In-Reply-To: <20210707073131.6e6ee75d@hermes.local>
References: <20210625104441.37756-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210629155116.23464-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210706083407.76deb4c0@hermes.local>
        <20210706184415.baf59983a9cb5de56050389c@virtuozzo.com>
        <20210706091821.7a5c2ce8@hermes.local>
        <20210706201757.46678b763f35ae41a12f48c1@virtuozzo.com>
        <20210706170545.680cfe43@hermes.local>
        <20210707152236.08ac5a20fc3be20adbb50879@virtuozzo.com>
        <20210707073131.6e6ee75d@hermes.local>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Jul 2021 07:31:31 -0700
Stephen Hemminger <stephen@networkplumber.org> wrote:

> On Wed, 7 Jul 2021 15:22:36 +0300
> Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:
> 
> > On Tue, 6 Jul 2021 17:05:45 -0700
> > Stephen Hemminger <stephen@networkplumber.org> wrote:
> > 
> > > On Tue, 6 Jul 2021 20:17:57 +0300
> > > Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:
> > >   
> > > > On Tue, 6 Jul 2021 09:18:21 -0700
> > > > Stephen Hemminger <stephen@networkplumber.org> wrote:
> > > >   
> > > > > On Tue, 6 Jul 2021 18:44:15 +0300
> > > > > Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:
> > > > >     
> > > > > > On Tue, 6 Jul 2021 08:34:07 -0700
> > > > > > Stephen Hemminger <stephen@networkplumber.org> wrote:
> > > > > >     
> > > > > > > On Tue, 29 Jun 2021 18:51:15 +0300
> > > > > > > Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:
> > > > > > >       
> > > > > > > > +	const struct rtnl_dump_filter_arg a[2] = {
> > > > > > > > +		{ .filter = filter, .arg1 = arg1,
> > > > > > > > +		  .errhndlr = errhndlr, .arg2 = arg2, .nc_flags = nc_flags, },
> > > > > > > > +		{ .filter = NULL,   .arg1 = NULL,
> > > > > > > > +		  .errhndlr = NULL, .arg2 = NULL, .nc_flags = 0, },
> > > > > > > >  	};      
> > > > > > > 
> > > > > > > I am OK with this as is. But you don't need to add initializers for fields
> > > > > > > that are 0/NULL (at least in C).      
> > > > > > 
> > > > > > Sure, I've made such explicit initializations just because in original
> > > > > > rtnl_dump_filter_nc() we already have them.
> > > > > > 
> > > > > > Do I need to resend with fixed initializations? ;)    
> > > > > 
> > > > > Not worth it    
> > > > 
> > > > Ok, thanks!
> > > >   
> > > 
> > > Looks like you need to send v5 anyway.
> > > 
> > > 
> > > checkpatch.pl ~/Downloads/PATCHv4-iproute2-ip-route-ignore-ENOENT-during-save-if-RT_TABLE_MAIN-is-being-dumped.patch 
> > > WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
> > > #62: 
> > > We started to use in-kernel filtering feature which allows to get only needed
> > > 
> > > WARNING: 'extened' may be misspelled - perhaps 'extended'?
> > > #84: 
> > > easily extened by changing SUPPRESS_ERRORS_INIT macro).
> > >        ^^^^^^^
> > > 
> > > WARNING: please, no space before tabs
> > > #111: FILE: include/libnetlink.h:109:
> > > + * ^Irtnl_dump_done()$
> > > 
> > > WARNING: please, no space before tabs
> > > #112: FILE: include/libnetlink.h:110:
> > > + * ^Irtnl_dump_error()$
> > > 
> > > WARNING: please, no space before tabs
> > > #116: FILE: include/libnetlink.h:114:
> > > + * ^Ierror handled as usual$
> > > 
> > > WARNING: please, no space before tabs
> > > #118: FILE: include/libnetlink.h:116:
> > > + * ^Ierror in nlmsg_type == NLMSG_DONE will be suppressed$
> > > 
> > > 
> > > WARNING: please, no space before tabs
> > > #120: FILE: include/libnetlink.h:118:
> > > + * ^Ierror in nlmsg_type == NLMSG_ERROR will be suppressed$
> > > 
> > > WARNING: please, no space before tabs
> > > #121: FILE: include/libnetlink.h:119:
> > > + * ^Iand nlmsg will be skipped$
> > > 
> > > total: 0 errors, 8 warnings, 183 lines checked  
> > 
> > Oh, sorry about that. I've sent v5 and checked with checkpatch.pl
> > I've send two options for v5 - with initializers fix and without :)
> > 
> > Regards,
> > Alex
> 
> Choose which ever initializer format you think looks best

Ha-ha! :) Let's take with empty initializers ;)

Thanks,
Alex
