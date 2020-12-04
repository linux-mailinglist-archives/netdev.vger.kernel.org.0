Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E462CF1E7
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 17:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730699AbgLDQ2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 11:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgLDQ2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 11:28:39 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145C8C061A4F;
        Fri,  4 Dec 2020 08:27:59 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1klDw1-002Wmj-9K; Fri, 04 Dec 2020 17:27:53 +0100
Message-ID: <16181fc69db48a0ed012788345967c4356169aff.camel@sipsolutions.net>
Subject: Re: [PATCH net] mac80211: mesh: fix mesh_pathtbl_init() error path
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        linux-wireless@vger.kernel.org
Date:   Fri, 04 Dec 2020 17:27:52 +0100
In-Reply-To: <cac552ce70a747f078738a7167f0a75bc52fac7c.camel@sipsolutions.net>
References: <20201204162428.2583119-1-eric.dumazet@gmail.com>
         (sfid-20201204_172435_837291_23D69393) <cac552ce70a747f078738a7167f0a75bc52fac7c.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-12-04 at 17:26 +0100, Johannes Berg wrote:
> On Fri, 2020-12-04 at 08:24 -0800, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> > 
> > If tbl_mpp can not be allocated, we call mesh_table_free(tbl_path)
> > while tbl_path rhashtable has not yet been initialized, which causes
> > panics.
> 
> Thanks Eric!
> 
> I was going to ask how you ran into this ...
> 
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> 
> Until I saw this - but doesn't syzbot normally want a
> "syzbot+somehashid@..." as the reported-by?
> 
> 
> > --- a/net/mac80211/mesh_pathtbl.c
> > +++ b/net/mac80211/mesh_pathtbl.c
> > @@ -60,6 +60,7 @@ static struct mesh_table *mesh_table_alloc(void)
> >  	atomic_set(&newtbl->entries,  0);
> >  	spin_lock_init(&newtbl->gates_lock);
> >  	spin_lock_init(&newtbl->walk_lock);
> > +	rhashtable_init(&newtbl->rhead, &mesh_rht_params);
> >  
> >  	return newtbl;
> >  }
> > @@ -773,9 +774,6 @@ int mesh_pathtbl_init(struct ieee80211_sub_if_data *sdata)
> >  		goto free_path;
> >  	}
> >  
> > -	rhashtable_init(&tbl_path->rhead, &mesh_rht_params);
> > -	rhashtable_init(&tbl_mpp->rhead, &mesh_rht_params);
> > 
> 
> Hmm. There were two calls, now there's only one? Is that a bug, or am I
> missing something?

Umm, never mind.

johannes

