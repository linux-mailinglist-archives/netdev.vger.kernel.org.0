Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7865EA7FC
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 16:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbiIZOJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 10:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234914AbiIZOIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 10:08:40 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186ED24D;
        Mon, 26 Sep 2022 05:19:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 68BA31F8AA;
        Mon, 26 Sep 2022 12:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664193738; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z5yBy6W2fnTZVXsf//nbkl+cALY92UVk+B+WQamcjzo=;
        b=teQ+cileX93nVAfM0CquqykdkJ/g++nir/f0UTviBL1F8Lost0M1xCMd+msl2JwjyhVHJz
        BFxhuR0Uc2//hJBcT52KonqOfKhHjOZSpulwLUcCCi8Cywz7EK9dqg3iICMQ7yQH3WwF9n
        B+6jAM0rkgp/jFwShic1qOItxFZQMJQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 49AE3139BD;
        Mon, 26 Sep 2022 12:02:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id E1C5D8qUMWM5RAAAMHmgww
        (envelope-from <mhocko@suse.com>); Mon, 26 Sep 2022 12:02:18 +0000
Date:   Mon, 26 Sep 2022 14:02:17 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org, vbabka@suse.cz,
        akpm@linux-foundation.org, urezki@gmail.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH mm] mm: fix BUG with kvzalloc+GFP_ATOMIC
Message-ID: <YzGUyWlYd15uLu7G@dhcp22.suse.cz>
References: <20220923103858.26729-1-fw@strlen.de>
 <Yy20toVrIktiMSvH@dhcp22.suse.cz>
 <20220923133512.GE22541@breakpoint.cc>
 <YzFZf0Onm6/UH7/I@dhcp22.suse.cz>
 <20220926075639.GA908@breakpoint.cc>
 <YzFplwSxwwsLpzzX@dhcp22.suse.cz>
 <YzFxHlYoncuDl2fM@dhcp22.suse.cz>
 <20220926100800.GB12777@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926100800.GB12777@breakpoint.cc>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 26-09-22 12:08:00, Florian Westphal wrote:
> Michal Hocko <mhocko@suse.com> wrote:
> > +		old_tbl = rht_dereference_rcu(ht->tbl, ht);
> > +		size = tbl->size;
> > +
> > +		data = ERR_PTR(-EBUSY);
> > +
> > +		if (rht_grow_above_75(ht, tbl))
> > +			size *= 2;
> > +		/* Do not schedule more than one rehash */
> > +		else if (old_tbl != tbl)
> > +			return data;
> > +
> > +		data = ERR_PTR(-ENOMEM);
> > +
> > +		rcu_read_unlock();
> > +		new_tbl = bucket_table_alloc(ht, size, GFP_KERNEL);
> > +		rcu_read_lock();
> 
> I don't think this is going to work, there can be callers that
> rely on rcu protected data structures getting free'd.

The caller of this function drops RCU for each retry, why should be the
called function any special?
-- 
Michal Hocko
SUSE Labs
