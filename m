Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682155EAA2B
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 17:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbiIZPTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 11:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236202AbiIZPSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 11:18:45 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF6680490;
        Mon, 26 Sep 2022 07:05:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0441021EBD;
        Mon, 26 Sep 2022 14:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664201146; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wuT0zYFTVb6wSKFv3e4a8+8ejDEu41HAn4lm9X+V3dY=;
        b=pxXA+YWa2Kcpb1MHyYsrT1t9v17FKJ/beYwwaHBKKXSbBL7RGdSwN8fCY7s0Q4B98macse
        j9lNMyAfkbbq2ULr08wt5rikiVeK8XZNVaZhRVvlUCW7DMXuxEIsd4TOkFaDUfLrK3HniN
        UZP6eozaJ4TUwnfIIy4wXyHlrT26xHA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D94D0139BD;
        Mon, 26 Sep 2022 14:05:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KLgrMrmxMWNSfwAAMHmgww
        (envelope-from <mhocko@suse.com>); Mon, 26 Sep 2022 14:05:45 +0000
Date:   Mon, 26 Sep 2022 16:05:45 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org, vbabka@suse.cz,
        akpm@linux-foundation.org, urezki@gmail.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH mm] mm: fix BUG with kvzalloc+GFP_ATOMIC
Message-ID: <YzGxuZ8jQ2sO4ZML@dhcp22.suse.cz>
References: <20220923103858.26729-1-fw@strlen.de>
 <Yy20toVrIktiMSvH@dhcp22.suse.cz>
 <20220923133512.GE22541@breakpoint.cc>
 <YzFZf0Onm6/UH7/I@dhcp22.suse.cz>
 <20220926075639.GA908@breakpoint.cc>
 <YzFplwSxwwsLpzzX@dhcp22.suse.cz>
 <YzFxHlYoncuDl2fM@dhcp22.suse.cz>
 <20220926100800.GB12777@breakpoint.cc>
 <YzGUyWlYd15uLu7G@dhcp22.suse.cz>
 <20220926130808.GD12777@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926130808.GD12777@breakpoint.cc>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 26-09-22 15:08:08, Florian Westphal wrote:
[...]
> To the best of my knowledge there are users of this interface that
> invoke it with rcu read lock held, and since those always nest, the
> rcu_read_unlock() won't move us to GFP_KERNEL territory.

Fiar point. I can see a comment above rhashtable_insert_fast which is
supposed to be used by drivers and explicitly documented to be
compatible with an atomic context. So the above is clearly a no-go

In that case I would propose to go with the patch going
http://lkml.kernel.org/r/YzFplwSxwwsLpzzX@dhcp22.suse.cz direction.
For that we could use an alternative implementation for the vmalloc
fallback for non-sleeping request in the future. A single branch for an
unlikely event is not nice but acceptable I would say. Especially if we
want to go in line with Linus' original "prevent hack for gfp_mask in
callers".
-- 
Michal Hocko
SUSE Labs
