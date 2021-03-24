Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C551134843B
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 22:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238682AbhCXV4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 17:56:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:41880 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231869AbhCXV4r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 17:56:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1616623005; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jBjOzdTCI5alb7jYcViZAPDiBK1WPc+e/WGWIJGXArw=;
        b=DhrbA/tVqf9uCoYm4s7RQxVbZPoHrfzVoKYTZe87BQllvWidEXlh2nk2bx0rbdUBodEtxv
        5MBMLQBq0AIVRlf6aApbV2mL3MSvYgoyvNbqO9iFWLZuFRNTjg+XolcmEzIdFIurCL1f0e
        gX4q/hXAT+x+6J8muKJK9agDrBMHc5U=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8E2D4AB9B;
        Wed, 24 Mar 2021 21:56:45 +0000 (UTC)
Date:   Wed, 24 Mar 2021 22:56:44 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Arjun Roy <arjunroy@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Arjun Roy <arjunroy.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Yang Shi <shy828301@gmail.com>, Roman Gushchin <guro@fb.com>
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
Message-ID: <YFu1nO3yYT5VVebo@dhcp22.suse.cz>
References: <20210316041645.144249-1-arjunroy.kdev@gmail.com>
 <YFCH8vzFGmfFRCvV@cmpxchg.org>
 <CAOFY-A23NBpJQ=mVQuvFib+cREAZ_wC5=FOMzv3YCO69E4qRxw@mail.gmail.com>
 <YFJ+5+NBOBiUbGWS@cmpxchg.org>
 <YFn8bLBMt7txj3AZ@dhcp22.suse.cz>
 <CAOFY-A22Pp3Z0apYBWtOJCD8TxfrbZ_HE9Xd6eUds8aEvRL+uw@mail.gmail.com>
 <YFsA78FfzICrnFf7@dhcp22.suse.cz>
 <CAOFY-A1+TT5EgT0oVEkGgHAaJavbLzbKp5fQx_uOrMtw-7VEiA@mail.gmail.com>
 <CALvZod6HQ=bG2K1YPofmD=7q3OX+FoRHbzLHcGAMSKOXtfn9dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod6HQ=bG2K1YPofmD=7q3OX+FoRHbzLHcGAMSKOXtfn9dw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 24-03-21 13:53:34, Shakeel Butt wrote:
[...]
> > Given that's the case, the options seem to be:
> > 1) Use a page flag - with the downside that they are a severely
> > limited resource,
> > 2) Use some bits inside page->memcg_data - this I believe Johannes had
> > reasons against, and it isn't always the case that MEMCG support is
> > enabled.
> > 3) Use compound_dtor - but I think this would have problems for the
> > prior reasons.
> 
> I don't think Michal is suggesting to use PageCompound() or
> PageHead(). He is suggesting to add a more general page flag
> (PageHasDestructor) and corresponding page->dtor, so other potential
> users can use it too.

Yes, that is eaxactly my point. If there is a page flag to use for a
specific destruction then we can use an already existing scheme. I have
fully digested Johannes' other reply so I might be still missing
something but fundamentally if sombody knows that the particular part of
the page is not used (most really should) then the page can claim
destructor by a flag and the freeing routine would just call that
callback. Or is there any reason why othe subsystems outside of
networking couldn't claim their own callback?
-- 
Michal Hocko
SUSE Labs
