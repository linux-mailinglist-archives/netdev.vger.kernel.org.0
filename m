Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A9F59E37D
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 14:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241729AbiHWMWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 08:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243684AbiHWMUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 08:20:08 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14213EF9D8;
        Tue, 23 Aug 2022 02:42:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5202D34299;
        Tue, 23 Aug 2022 09:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661247748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a5e+aBtB4V09GgYckhU7qkp/jydUu2L/ktWuXDsvUUg=;
        b=OKRFeR44shGwU0EljaE1Yk98KkScecHFvhrQ5yejUOssX5zl4uJX8SMi15/0k+AdOOx/Il
        1MMu5RDHls3J7toCCAhfVHlseTgH3LpppxNutvATRuchyb5zxA1BYToFrVbXH0DgMKUqVQ
        G28kJ+yPjCDh98TnptwlS13a3X6saZw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3FA8313AB7;
        Tue, 23 Aug 2022 09:42:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id x1afDgShBGP9eQAAMHmgww
        (envelope-from <mhocko@suse.com>); Tue, 23 Aug 2022 09:42:28 +0000
Date:   Tue, 23 Aug 2022 11:42:27 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Oliver Sang <oliver.sang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mm: page_counter: remove unneeded atomic ops for
 low/min
Message-ID: <YwShA6npuK0ZsjPI@dhcp22.suse.cz>
References: <20220822001737.4120417-1-shakeelb@google.com>
 <20220822001737.4120417-2-shakeelb@google.com>
 <YwNSlZFPMgclrSCz@dhcp22.suse.cz>
 <YwNX+vq9svMynVgW@dhcp22.suse.cz>
 <CALvZod720nwfP68OM2QtyyWJpOV5aO8xF6iuN0U2hpX9Pzj8PA@mail.gmail.com>
 <YwOeocdkF/lacpKn@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwOeocdkF/lacpKn@dhcp22.suse.cz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 22-08-22 17:20:02, Michal Hocko wrote:
> On Mon 22-08-22 07:55:58, Shakeel Butt wrote:
> > On Mon, Aug 22, 2022 at 3:18 AM Michal Hocko <mhocko@suse.com> wrote:
[...]
> > > Unless I have missed anything this shouldn't break the correctness but I
> > > still have to think about the proportional distribution of the
> > > protection because that adds to the complexity here.
> > 
> > The patch is not changing any semantics. It is just removing an
> > unnecessary atomic xchg() for a specific scenario (min > 0 && min <
> > usage). I don't think there will be any change related to proportional
> > distribution of the protection.
> 
> Yes, I suspect you are right. I just remembered previous fixes
> like 503970e42325 ("mm: memcontrol: fix memory.low proportional
> distribution") which just made me nervous that this is a tricky area.
> 
> I will have another look tomorrow with a fresh brain and send an ack.

I cannot spot any problem. But I guess it would be good to have a little
comment to explain that races on the min_usage update (mentioned by Roman)
are acceptable and savings from atomic update are preferred.

The worst case I can imagine would be something like uncharge 4kB racing
with charge 2MB. The first reduces the protection (min_usage) while the other one
misses that update and doesn't increase it. But even then the effect
shouldn't be really large. At least I have hard time imagine this would
throw things off too much.
-- 
Michal Hocko
SUSE Labs
