Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17BA246C156
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 18:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhLGRKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 12:10:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36860 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239814AbhLGRKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 12:10:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03B22B81D71
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 17:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B98C341C3;
        Tue,  7 Dec 2021 17:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638896822;
        bh=ZB2ALhaSGs3qcTtFma/ISGlGvE0OkTJEIiqd6ggTHGY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OBdVVydQHbzCRsH8h2bwy/L6iQ7lHRMZL7T+drJqOHfk+8wh1WFlaEj6rpycQZj7l
         TgqGHPWOqTly0vhl3YnycmFvx20pGnbV/eSrRPkfAVhZdxeFhDXEkk5g50ZoqCz7qN
         G0yn0DO+JINokjs0ajF6MkPDhtzxgpm55j9M3i/xbh3DKqYv5nMPTMSMhW6I+rclV7
         R6qAv6mF9SDu1OCmr6CAtiwe1W+8R7yeUe6ZAwX3m2sN9rBIYoTc1qSYErl9s78Re6
         BgciwZet95O8OjXnNGjfjWOl/H4p44mFtwxxiQcvlh10v5SNh49pAEt3KnLYDhuJ8P
         5fb0JoIjUmeiQ==
Date:   Tue, 7 Dec 2021 09:07:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, linux-mm@kvack.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com,
        iamjoonsoo kim <iamjoonsoo.kim@lge.com>,
        akpm@linux-foundation.org, vbabka@suse.cz
Subject: Re: [RFC net-next 2/2] ipv6: ioam: Support for Buffer occupancy
 data field
Message-ID: <20211207090700.55725775@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1045511371.220520131.1638894949373.JavaMail.zimbra@uliege.be>
References: <20211206211758.19057-1-justin.iurman@uliege.be>
        <20211206211758.19057-3-justin.iurman@uliege.be>
        <20211206161625.55a112bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <262812089.220024115.1638878044162.JavaMail.zimbra@uliege.be>
        <20211207075037.6cda8832@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1045511371.220520131.1638894949373.JavaMail.zimbra@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Dec 2021 17:35:49 +0100 (CET) Justin Iurman wrote:
> > provides the best signal. Since the slab cache scales dynamically
> > (AFAIU) it's not really a big deal if it's full as long as there's
> > memory available on the system.  
> 
> Well, I got the same understanding as you. However, we do not provide a
> value meaning "X percent used" just because it wouldn't make much sense,
> as you pointed out. So I think it is sound to have the current value,
> even if it's a quite dynamic one. Indeed, what's important here is to
> know how many bytes are used and this is exactly what it does. If a node
> is under heavy load, the value would be hell high. The operator could
> define a threshold for each node resp. and detect abnormal values.

Hm, reading thru the quoted portion of the standard from the commit
message the semantics of the field are indeed pretty disappointing.
What's the value of defining a field in a standard if it's entirely
implementation specific? Eh.

> We probably want the metadata included for accuracy as well (e.g.,
> kmem_cache_size vs new function kmem_cache_full_size).

Does the standard support carrying arbitrary metadata?

Anyway, in general I personally don't have a good feeling about
implementing this field. Would be good to have a clear user who 
can justify the choice of slab vs something else. Wouldn't modern
deployments use some form of streaming telemetry for nodes within 
the same domain of control? I'm not sure I understand the value
of limited slab info in OAM when there's probably a more powerful
metric collection going on.

Patch 1 makes perfect sense, FWIW.
