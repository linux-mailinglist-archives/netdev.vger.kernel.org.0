Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E49E511764
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 14:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbiD0MZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 08:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233930AbiD0MZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 08:25:47 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9146C4132E;
        Wed, 27 Apr 2022 05:22:35 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1B9681F74B;
        Wed, 27 Apr 2022 12:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651062154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bPJVJ/mvoFlMUFOZPBJ+knXZSOjq1aUlwWwkq9LhQTo=;
        b=n6Zsmd3ZvSPkPhiIdXXfFL6ehZn8AL7BshvVE3p+w5JDx9muTQd5wKkGExHgczFgQH8G4e
        d8rlT0rW81Ve1qiYTkNlC1dukAx4Q4DIDccyG20zh1OfPZXR6eF7ygx84SM0nBfFl5krNz
        Ihf/Jng1e1v9VeCT1AdFdSHRSN77vjg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CD64F13A39;
        Wed, 27 Apr 2022 12:22:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id AT8+MYk1aWLfOAAAMHmgww
        (envelope-from <mkoutny@suse.com>); Wed, 27 Apr 2022 12:22:33 +0000
Date:   Wed, 27 Apr 2022 14:22:32 +0200
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Vasily Averin <vvs@openvz.org>, Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>, kernel@openvz.org,
        Florian Westphal <fw@strlen.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH memcg v4] net: set proper memcg for net_init hooks
 allocations
Message-ID: <20220427122232.GA9823@blackbody.suse.cz>
References: <YmdeCqi6wmgiSiWh@carbon>
 <33085523-a8b9-1bf6-2726-f456f59015ef@openvz.org>
 <CALvZod4oaj9MpBDVUp9KGmnqu4F3UxjXgOLkrkvmRfFjA7F1dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod4oaj9MpBDVUp9KGmnqu4F3UxjXgOLkrkvmRfFjA7F1dw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 26, 2022 at 10:23:32PM -0700, Shakeel Butt <shakeelb@google.com> wrote:
> [...]
> >
> > +static inline struct mem_cgroup *get_mem_cgroup_from_obj(void *p)
> > +{
> > +       struct mem_cgroup *memcg;
> > +
> 
> Do we need memcg_kmem_enabled() check here or maybe
> mem_cgroup_from_obj() should be doing memcg_kmem_enabled() instead of
> mem_cgroup_disabled() as we can have "cgroup.memory=nokmem" boot
> param.

I reckon such a guard is on the charge side and readers should treat
NULL and root_mem_group equally. Or is there a case when these two are
different? 

(I can see it's different semantics when stored in current->active_memcg
(and active_memcg() getter) but for such "outer" callers like here it
seems equal.)

Regards,
Michal

