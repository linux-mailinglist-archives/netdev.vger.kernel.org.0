Return-Path: <netdev+bounces-12229-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B979736D6E
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 15:35:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CECBA28125A
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:35:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A13015ADE;
	Tue, 20 Jun 2023 13:35:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081B22F5B
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:35:50 +0000 (UTC)
Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0252B1709
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 06:35:43 -0700 (PDT)
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 20 Jun 2023 15:35:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1687268140; bh=MrPcbeDrxr4HgoSu5jcB9aacR6fimi8U0dJzhnLFLjI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rTgv10FJqE2xoImwD8S1DoPammERUkajgGhkxUh+1hCIP7yRNC9OF3Z3IkHSnL8Zz
	 t/YiL38ZLRM1mWMJq1fwS1fcCt4ZLX7tRjYAGXnll9cX2vhE9lTkkEAHFva82hoLxz
	 yODGjEJyrrLBmkL3Xm/977lqFzMelkEr6wsnY2pw=
Received: from localhost (unknown [172.17.88.63])
	by mail-auth.avm.de (Postfix) with ESMTPSA id 7361582151;
	Tue, 20 Jun 2023 15:35:41 +0200 (CEST)
Date: Tue, 20 Jun 2023 15:35:41 +0200
From: Johannes Nixdorf <jnixdorf-oss@avm.de>
To: Nikolay Aleksandrov <razor@blackwall.org>
Cc: bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
	David Ahern <dsahern@gmail.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next v2 2/3] bridge: Add a limit on learned FDB
 entries
Message-ID: <ZJGrLYsT7CcavLeR@u-jnixdorf.ads.avm.de>
References: <20230619071444.14625-1-jnixdorf-oss@avm.de>
 <20230619071444.14625-3-jnixdorf-oss@avm.de>
 <aac18591-b06b-d48d-368a-99fc3ac50e24@blackwall.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aac18591-b06b-d48d-368a-99fc3ac50e24@blackwall.org>
X-purgate-ID: 149429::1687268140-8E7CAD8A-B5A0F401/0/0
X-purgate-type: clean
X-purgate-size: 4626
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 20, 2023 at 09:55:31AM +0300, Nikolay Aleksandrov wrote:
> On 6/19/23 10:14, Johannes Nixdorf wrote:
> > +/* Set a FDB flag that implies the entry was not learned, and account
> > + * for changes in the learned status.
> > + */
> > +static void __fdb_set_flag_not_learned(struct net_bridge *br,
> > +				       struct net_bridge_fdb_entry *fdb,
> > +				       long nr)
> > +{
> > +	WARN_ON_ONCE(!(BIT(nr) & BR_FDB_NOT_LEARNED_MASK));
> 
> Please use *_bit

Can you tell me which *_bit helper you had in mind? The shortest option I could
come up with the ones I found seemed needlessly verbose and wasteful:

  static const unsigned long br_fdb_not_learned_mask = BR_FDB_NOT_LEARNED_MASK;
  ...
  WARN_ON_ONCE(test_bit(nr, &br_fdb_not_learned_mask));

> > +
> > +	/* learned before, but we set a flag that implies it's manually added */
> > +	if (!(fdb->flags & BR_FDB_NOT_LEARNED_MASK))
> 
> Please use *_bit

This will be fixed by the redesign to get rid of my use of hash_lock
(proposed later in this mail), as I'll only have to test one bit and can
use test_and_clear_bit then.

> > +		br->fdb_cur_learned_entries--;
> > +	set_bit(nr, &fdb->flags);
> > +}
> 
> Having a helper that conditionally decrements only is counterintuitive and
> people can get confused. Either add 2 helpers for inc/dec and use
> them where appropriate or don't use helpers at all.

The *_set_bit helper can only cause the count to drop, as there
is currently no flag that could turn a manually added entry back into
a dynamically learned one.

The analogous helper that increments the value would be *_clear_bit,
which I did not add because it has no users.

> > +	spin_unlock_bh(&br->hash_lock);
> > +}
> > +
> >   /* When a static FDB entry is deleted, the HW address from that entry is
> >    * also removed from the bridge private HW address list and updates all
> >    * the ports with needed information.
> > @@ -321,6 +353,8 @@ static void fdb_del_hw_addr(struct net_bridge *br, const unsigned char *addr)
> >   static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
> >   		       bool swdev_notify)
> >   {
> > +	bool learned = !(f->flags & BR_FDB_NOT_LEARNED_MASK);
> 
> *_bit

I do not know a *_bit helper that would help me test the intersection
of multiple bits on both sides. Do you have any in mind?

> > +
> >   	return fdb;
> >   }
> > @@ -894,7 +940,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
> >   			}
> >   			if (unlikely(test_bit(BR_FDB_ADDED_BY_USER, &flags)))
> > -				set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
> > +				fdb_set_flag_not_learned(br, fdb, BR_FDB_ADDED_BY_USER);
> 
> Unacceptable to take hash_lock and block all learning here, eventual
> consistency is ok or some other method that is much lighter and doesn't
> block all learning or requires a lock.

At the time of writing v2, this seemed difficult because we want to test
multiple bits and increment a counter, but remembering that clear_bit
is never called for the bits I care about I came up with the following
approach:

  a) Add a new flag BR_FDB_DYNAMIC_LEARNED, which is set to 1 iff
     BR_FDB_ADDED_BY_USER or BR_FDB_LOCAL are set in br_create.
     Every time BR_FDB_ADDED_BY_USER or BR_FDB_LOCAL is set, also clear
     BR_FDB_DYNAMIC_LEARNED, and decrement the count if it was 1 before.
     This solves the problem of testing two bits at once, and would not
     have been possible if we had a code path that could clear both bits,
     as it is not as easy to decide when to set BR_FDB_DYNAMIC_LEARNED
     again in that case.
  b) Replace the current count with an atomic_t.

I'll change it this way for v3.

> >   		return -EMSGSIZE;
> >   #ifdef CONFIG_BRIDGE_VLAN_FILTERING
> > diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> > index 2119729ded2b..df079191479e 100644
> > --- a/net/bridge/br_private.h
> > +++ b/net/bridge/br_private.h
> > @@ -275,6 +275,8 @@ enum {
> >   	BR_FDB_LOCKED,
> >   };
> > +#define BR_FDB_NOT_LEARNED_MASK (BIT(BR_FDB_LOCAL) | BIT(BR_FDB_ADDED_BY_USER))
> 
> Not learned sounds confusing and doesn't accurately describe the entry.
> BR_FDB_DYNAMIC_LEARNED perhaps or some other name, that doesn't cause
> double negatives (not not learned).

Your proposal would not have captured the mask, as it describes all the
opposite cases, which were _not_ dynamically learned.

But with the proposed new flag from the hash_lock comment we can trivially
flip the meaning, so I went with your proposed name there.

