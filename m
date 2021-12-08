Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2055446DE16
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 23:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237158AbhLHWWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 17:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbhLHWWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 17:22:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8405CC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 14:18:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04983B82313
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 22:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368C8C00446;
        Wed,  8 Dec 2021 22:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639001906;
        bh=gfDuBq25+JQkcEgr3LjbrJGDATvs821KxAM+8cSLyeY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gunSvHRi/j+1ZpoXgCHqfXxRRiYK9Xo9KTMn5+gFQ3lxFAyXRcT9hVltteVoRAZdn
         AFDndDsMe/rS+o4YHnRDKEguoPovf4I+tLxYkWVQFWud4MBIWhigFOOaTY1ZP4DqBM
         EeE0DyVnSXanoxs7fd9klowJnhPSgfaiuZu+vEV+z/Cx0ad2+yi6UD5N2EKnYjtiGd
         LJ++9X1V9AWrBYBny6dhIUTzlsLn1HEn0L0vTVCdxGjrD5pyQv1G8fAyznCTQvDmmd
         IGJOcL2COIzbA0rK/QZ9baKEpix8H2iLLT4LWzW2/T+Wc8b6raPFbayH9AsYfUwnV/
         YkW9JjbCQbggg==
Date:   Wed, 8 Dec 2021 14:18:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, linux-mm@kvack.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com,
        iamjoonsoo kim <iamjoonsoo.kim@lge.com>,
        akpm@linux-foundation.org, vbabka@suse.cz
Subject: Re: [RFC net-next 2/2] ipv6: ioam: Support for Buffer occupancy
 data field
Message-ID: <20211208141825.3091923c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1665643630.220612437.1638900313011.JavaMail.zimbra@uliege.be>
References: <20211206211758.19057-1-justin.iurman@uliege.be>
        <20211206211758.19057-3-justin.iurman@uliege.be>
        <20211206161625.55a112bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <262812089.220024115.1638878044162.JavaMail.zimbra@uliege.be>
        <20211207075037.6cda8832@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1045511371.220520131.1638894949373.JavaMail.zimbra@uliege.be>
        <20211207090700.55725775@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1665643630.220612437.1638900313011.JavaMail.zimbra@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Dec 2021 19:05:13 +0100 (CET) Justin Iurman wrote:
> On Dec 7, 2021, at 6:07 PM, Jakub Kicinski kuba@kernel.org wrote:
> > Hm, reading thru the quoted portion of the standard from the commit
> > message the semantics of the field are indeed pretty disappointing.
> > What's the value of defining a field in a standard if it's entirely
> > implementation specific? Eh.  
> 
> True. But keep also in mind the scope of IOAM which is not to be
> deployed widely on the Internet. It is deployed on limited (aka private)
> domains where each node is therefore managed by the operator. So, I'm
> not really sure why you think that the implementation specific thing is
> a problem here. Context of "unit" is provided by the IOAM Namespace-ID
> attached to the trace, as well as each Node-ID if included. Again, it's
> up to the operator to interpret values accordingly, depending on each
> node (i.e., the operator has a large and detailed view of his domain; he
> knows if the buffer occupancy value "X" is abnormal or not for a
> specific node, he knows which unit is used for a specific node, etc).

It's quite likely I'm missing the point.

> >> We probably want the metadata included for accuracy as well (e.g.,
> >> kmem_cache_size vs new function kmem_cache_full_size).  
> > 
> > Does the standard support carrying arbitrary metadata?  
> 
> It says:
> 
>   "This field indicates the current status of the occupancy of the
>    common buffer pool used by a set of queues."
> 
> So, as long as metadata are part of it, I'd say yes it does, since bytes
> are allocated for that too. Does it make sense?

Indeed, but see below.

> > Anyway, in general I personally don't have a good feeling about
> > implementing this field. Would be good to have a clear user who
> > can justify the choice of slab vs something else. Wouldn't modern
> > deployments use some form of streaming telemetry for nodes within
> > the same domain of control? I'm not sure I understand the value
> > of limited slab info in OAM when there's probably a more powerful
> > metric collection going on.  
> 
> Do you believe this patch does not provide what is defined in the spec?
> If so, I'm open to any suggestions.

The opposite, in a sense. I think the patch does implement behavior
within a reasonable interpretation of the standard. But the feature
itself seems more useful for forwarding ASICs than Linux routers,
because Linux routers can run a full telemetry stack and all sort 
of advanced SW instrumentation. The use case for reporting kernel
memory use via IOAM's constrained interface does not seem particularly
practical since it's not providing a very strong signal on what's 
going on.

For switches running Linux the switch ASIC buffer occupancy can be read
via devlink-sb that'd seem like a better fit for me, but unfortunately
the devlink calls can sleep so we can't read such device info from the
datapath.

> > Patch 1 makes perfect sense, FWIW.  
> 
> Thanks for (all) the feedback, Jakub, I appreciate it.
