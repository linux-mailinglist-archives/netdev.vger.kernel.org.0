Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802DF3730B9
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 21:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbhEDTXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 15:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbhEDTXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 15:23:08 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4802C06174A;
        Tue,  4 May 2021 12:22:12 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1le0cN-0006Tn-3N; Tue, 04 May 2021 21:22:03 +0200
Date:   Tue, 4 May 2021 21:22:03 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Cc:     fw@strlen.de, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v3] netfilter: nf_conntrack: Add conntrack helper for
 ESP/IPsec
Message-ID: <20210504192203.GA12364@breakpoint.cc>
References: <20210426123743.GB975@breakpoint.cc>
 <20210503010646.11111-1-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210503010646.11111-1-Cole.Dishington@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cole Dishington <Cole.Dishington@alliedtelesis.co.nz> wrote:
> Introduce changes to add ESP connection tracking helper to netfilter
> conntrack. The connection tracking of ESP is based on IPsec SPIs. The
> underlying motivation for this patch was to allow multiple VPN ESP
> clients to be distinguished when using NAT.
> 
> Added config flag CONFIG_NF_CT_PROTO_ESP to enable the ESP/IPsec
> conntrack helper.
> 
> Signed-off-by: Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
> ---
> 
> Notes:
>     Thanks for your time reviewing!
>
>     Q.
>     > +static int esp_tuple_to_nlattr(struct sk_buff *skb,
>     > +                            const struct nf_conntrack_tuple *t)
>     > +{
>     > +     if (nla_put_be16(skb, CTA_PROTO_SRC_ESP_ID, t->src.u.esp.id) ||
>     > +         nla_put_be16(skb, CTA_PROTO_DST_ESP_ID, t->dst.u.esp.id))
>     > +             goto nla_put_failure;
>     
>     This exposes the 16 bit kernel-generated IDs, right?
>     Should this dump the real on-wire SPIs instead?
>     
>     Or is there are reason why the internal IDs need exposure?
>     
>     A.
>     I think I need to expose the internal esp ids here due to esp_nlattr_to_tuple().
>     If esp id was changed to real SPIs here I would be unable to lookup the correct
>     tuple (without IP addresses too).

Oh, right. I keep forgetting the ESP tracker hooks into the tuple
creation function.  In that case I think it would be good to include the
raw/on-wire ESP IDs as well when dumping so conntrack -L can print them.

The internal numbers are seemingly pointless, except that you need them
to populate the tuple, and can't obtain the internal numbers based on
the on-wire ESP ID.

The only other solution I see is to check presence of
CTA_IP_DST|CTA_IP_SRC in 'flags', then take the ip addresses from the
provided tuple, and do a lookup in the rhashtable with the addresses
and the raw esp values.

Obvious downside: This will force users to provide the ip address as
well, search based on ESP value alone won't work anymore.

[ Unless a full table walk is done, but that might be ambiguous
  without the ip addresses, as on-wire ESP may not be unique ].

>    changes in v3:
>     - Flush all esp entries for a given netns on nf_conntrack_proto_pernet_fini
>     - Replace _esp_table (and its spinlock) shared over netns with per netns linked lists and bitmap (for esp ids)
>     - Init IPv6 any address with IN6ADDR_ANY_INIT rather than ipv6_addr_set()
>     - Change l3num on hash key from u16 to u8
>     - Add selftests file for testing tracker with ipv4 and ipv6

Thanks for this.  Can you place the selftest in a 2/2 patch in v4?

checkpatch doesn't like some whitespace, but I did not see any critical
warnings.

> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> index 439379ca9ffa..4011be8c5e39 100644
> --- a/include/net/netfilter/nf_conntrack.h
> @@ -47,6 +49,10 @@ struct nf_conntrack_net {
>  	unsigned int users4;
>  	unsigned int users6;
>  	unsigned int users_bridge;
> +
> +#ifdef CONFIG_NF_CT_PROTO_ESP
> +	DECLARE_BITMAP(esp_id_map, 1024);

Can we avoid the magic number?

Either make this 1024 and then have the esp.c file use a define
based on ARRAY_SIZE + BITS_PER_TYPE to 'recompute' the 1024 (or whatever
the exact size give is), or add a #define and use that for the bitmap
declaration, then use that consistently in the esp.c file.

Or come up with an alternative solution.

>  #include <linux/types.h>
> diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
> diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
> index 806454e767bf..43cd1e78f790 100644
> --- a/include/net/netns/conntrack.h
> +++ b/include/net/netns/conntrack.h
> @@ -69,6 +69,20 @@ struct nf_gre_net {
>  };
>  #endif
>  
> +#ifdef CONFIG_NF_CT_PROTO_ESP
> +enum esp_conntrack {
> +	ESP_CT_UNREPLIED,
> +	ESP_CT_REPLIED,
> +	ESP_CT_MAX
> +};
> +
> +struct nf_esp_net {
> +	spinlock_t id_list_lock;
> +	struct list_head id_list;

Can you place the list_id/_lock in nf_conntrack_net structure?

The nf_esp_net is placed in 'struct net', the other one is allocated
only when the conntrack module is loaded.

> +	unsigned int esp_timeouts[ESP_CT_MAX];

This is fine.

>  	CTA_PROTO_ICMPV6_TYPE,
>  	CTA_PROTO_ICMPV6_CODE,
> +	CTA_PROTO_SRC_ESP_ID,
> +	CTA_PROTO_DST_ESP_ID,

See above, if the internal IDs have to be exposed,
this should be something like:

> +	CTA_PROTO_SRC_ESP_ID,
> +	CTA_PROTO_DST_ESP_ID,
> +	CTA_PROTO_SRC_ESP_SPI,
> +	CTA_PROTO_DST_ESP_SPI,

... with the latter two exposing the __be32 of the ESP tunnel.
You could also just re-use existing CTA_SRC_PORT/DST_PORT for the
internal esp ids given that ESP has no ports.

I will leave that up to you though, we don't have to avoid new
enums here.

> +#ifdef CONFIG_NF_CT_PROTO_ESP
> +	ret = nf_conntrack_esp_init();
> +	if (ret < 0)
> +		goto cleanup_sockopt;

Ouch, thats a bug in the existing code, I will send a patch.

> diff --git a/net/netfilter/nf_conntrack_proto_esp.c b/net/netfilter/nf_conntrack_proto_esp.c
> new file mode 100644
> index 000000000000..1bc0cb879bfd
> --- /dev/null
> +++ b/net/netfilter/nf_conntrack_proto_esp.c
> @@ -0,0 +1,741 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * <:copyright-gpl
> + * Copyright 2008 Broadcom Corp. All Rights Reserved.
> + * Copyright (C) 2021 Allied Telesis Labs NZ
> + *
> + * This program is free software; you can distribute it and/or modify it
> + * under the terms of the GNU General Public License (Version 2) as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> + * for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program.
> + * :>

The SPDX tag is enough, the GPL boilerplate can be removed.

> +static void free_esp_entry(struct nf_conntrack_net *cnet, struct _esp_entry *esp_entry)
> +{
> +	if (esp_entry) {
> +		/* Remove from all the hash tables */
> +		pr_debug("Removing entry %x from all tables", esp_entry->esp_id);
> +		list_del(&esp_entry->net_node);
> +		rhashtable_remove_fast(&ltable, &esp_entry->lnode, ltable_params);
> +		rhashtable_remove_fast(&rtable, &esp_entry->rnode, rtable_params);
> +		rhltable_remove(&incmpl_rtable, &esp_entry->incmpl_rlist, incmpl_rtable_params);
> +		clear_bit(esp_entry->esp_id - TEMP_SPI_START, cnet->esp_id_map);
> +		kfree(esp_entry);
> +	}
> +}
> +
> +/* Free an entry referred to by esp_id.
> + *
> + * NOTE:
> + * Per net linked list locking and unlocking is the responsibility of the calling function.

Why? I think it makes more sense to lock/unlock in free_esp_entry, when
the 'list_del(->net_node)' is done.

> + * NOTE: This function may block on per net list lock.

Is that important?  Its a spinlock, so noone should hold it for
long period. search_esp_entry_by_spi() has same comment and in that
case its not used in most cases.

> +	spin_lock(&esp_net->id_list_lock);
> +	list_add(&esp_entry->net_node, &esp_net->id_list);

spin_lock_bh() ?

> +		err = rhashtable_insert_fast(&rtable, &esp_entry->rnode, rtable_params);
> +		if (err) {
> +			struct nf_esp_net *esp_net = esp_pernet(net);
> +
> +			spin_lock(&esp_net->id_list_lock);

spin_lock_bh?  And why does the entire free_esp_entry_by_id() need this
lock?

> +		}
> +		esp_entry->l_spi = spi;
> +		esp_entry->l3num = tuple->src.l3num;
> +		esp_ip_addr_copy(esp_entry->l3num, &esp_entry->l_ip, &tuple->src.u3);
> +		esp_ip_addr_copy(esp_entry->l3num, &esp_entry->r_ip, &tuple->dst.u3);
> +
> +		/* Add entries to the hash tables */
> +
> +		calculate_key(net_hmix, esp_entry->l_spi, esp_entry->l3num, &esp_entry->l_ip,
> +			      &esp_entry->r_ip, &key);
> +		esp_entry_old = rhashtable_lookup_get_insert_key(&ltable, &key, &esp_entry->lnode,
> +								 ltable_params);
> +		if (esp_entry_old) {
> +			spin_lock(&esp_net->id_list_lock);
> +
> +			if (IS_ERR(esp_entry_old)) {
> +				free_esp_entry_by_id(net, esp_entry->esp_id);
> +				spin_unlock(&esp_net->id_list_lock);
> +				return false;
> +			}
> +
> +			free_esp_entry_by_id(net, esp_entry->esp_id);

This looks weird.  Both branches contain the same free_esp_entry_by_id() call.

I suspect this should be something like this:

	if (esp_entry_old) {
		free_esp_entry(net, esp_entry);

		if (IS_ERR(esp_entry_old))
			return false;

		esp_entry = esp_entry_old;

... because we want to remove the entry we allocated right before in the
same function, so why would be have to search by id?

> +		}
> +		/* esp_entry_old == NULL -- insertion successful */

Probably better to avoid this comment, and, if needed, add a 'insertion
raced, other CPU added same entry' or similar, in the if (esp_entry_old)
case.

Up to you.

> +/* Returns verdict for packet, and may modify conntrack */
> +int nf_conntrack_esp_packet(struct nf_conn *ct, struct sk_buff *skb,
> +			    unsigned int dataoff,
> +			    enum ip_conntrack_info ctinfo,
> +			    const struct nf_hook_state *state)
> +{
> +	int esp_id;
> +	struct nf_conntrack_tuple *tuple;
> +	unsigned int *timeouts = nf_ct_timeout_lookup(ct);
> +	struct nf_esp_net *esp_net = esp_pernet(nf_ct_net(ct));
> +
> +	if (!timeouts)
> +		timeouts = esp_net->esp_timeouts;
> +
> +	/* If we've seen traffic both ways, this is some kind of ESP
> +	 * stream.  Extend timeout.
> +	 */
> +	if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
> +		nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[ESP_CT_REPLIED]);
> +		/* Also, more likely to be important, and not a probe */
> +		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status)) {
> +			/* Was originally IPCT_STATUS but this is no longer an option.
> +			 * GRE uses assured for same purpose
> +			 */

Please remove the above comment, almost noone remembers what
IPCT_STATUS was 8-)

> +			esp_id = tuple->src.u.esp.id;
> +			if (esp_id >= TEMP_SPI_START && esp_id <= TEMP_SPI_MAX) {
> +				struct _esp_entry *esp_entry;
> +
> +				spin_lock(&esp_net->id_list_lock);
> +				esp_entry = find_esp_entry_by_id(esp_net, esp_id);

There should be no list walk from packet path.  I would suggest to add
another rhashtable for this, or switch entire id allocation to IDR.

If you go for idr, you can place the idr root in nf_esp_net since its
going to be used in lookup path too.  idr can be used with rcu (for
read accesses).

This is my mistake, I did not realize the need for per-id lookup via
this list, I thought the existing rhashtables already covered this.

I thought the only need for this list was to quickly remove all the
allocated entries on netns teardown.

[ walking a (shared across all netns) rhashtable on netns destruction
  can be expensive ]

> +void nf_ct_esp_pernet_flush(struct net *net)
> +{
> +	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
> +	struct nf_esp_net *esp_net = esp_pernet(net);
> +	struct list_head *pos, *tmp, *head = &esp_net->id_list;
> +	struct _esp_entry *esp_entry;
> +
> +	spin_lock(&esp_net->id_list_lock);
> +	list_for_each_safe(pos, tmp, head) {

list_for_each_entry_safe()?

> +		esp_entry = list_entry(pos, struct _esp_entry, net_node);
> +		free_esp_entry(cnet, esp_entry);
> +	}
> +	spin_unlock(&esp_net->id_list_lock);

I think it would be better to move the list lock/unlock to only cover
the single list_del operation to make it clear that this lock only
guards the list and nothing else.

> +/* Called when a conntrack entry has already been removed from the hashes
> + * and is about to be deleted from memory
> + */
> +void destroy_esp_conntrack_entry(struct nf_conn *ct)
> +{
> +	struct nf_conntrack_tuple *tuple;
> +	enum ip_conntrack_dir dir;
> +	int esp_id;
> +	struct net *net = nf_ct_net(ct);
> +	struct nf_esp_net *esp_net = esp_pernet(net);

Nit: some people (not me) are very obsessed with reverse xmas tree
ordering, i.e.

	struct nf_esp_net *esp_net = esp_pernet(net);
	struct net *net = nf_ct_net(ct);
	struct nf_conntrack_tuple *tuple;
	enum ip_conntrack_dir dir;
	int esp_id;

In addition, could you please use 'unsigned' except when you need to
store numbers < 0?

> +	 * but the free function handles repeated frees, so best to do them all.
> +	 */
> +	for (dir = IP_CT_DIR_ORIGINAL; dir < IP_CT_DIR_MAX; dir++) {
> +		tuple = nf_ct_tuple(ct, dir);
> +
> +		spin_lock(&esp_net->id_list_lock);
> +
> +		esp_id = tuple->src.u.esp.id;
> +		if (esp_id >= TEMP_SPI_START && esp_id <= TEMP_SPI_MAX)
> +			free_esp_entry_by_id(net, esp_id);

I find this repeated use of esp_id >= && <= ... confusing. Why is this
needed?

Could you move this down to where you need to protect illegal memory
accesses or similar, so this is just

   free_esp_entry_by_id(net, esp_id) ?

Also, I think it might be better to instead do this:

esp_id_src = tuple->src.u.esp.id;
tuple = nf_ct_tuple(ct, IP_CT_DIR_REPLY);
esp_id_repl = tuple->src.u.esp.id;

free_esp_entry_by_id(net, esp_id_orig);
if (esp_id_orig != esp_id_repl)
  free_esp_entry_by_id(net, esp_id_repl);

This avoids race with esp_id reallocation after the first
clear_bit().

I wonder if it would be possible to change how the assocation of the
reverse direction works.

1. Only use on-wire SPI value (no internal 'esp id' allocation anymore)

2. Use expectation infrastructure to associate the 'reverse' direction
   with the existing/orignal conntrack entry instead.

For ORIGINAL, the ESP Id gets split in two 16 bit halves, stored in the tuple
(so instead of tcp sport x dport y), it would be spi & 0xffff  && spi << 16.

This avoids size increase of the tuple, and we don't change the way tuples work,
i.e. all contents of the tuple are derived from packet header fields.

1. esp_pkt_to_tuple extracts the 32bit SPI, fills the tuple
   with the two 16bit halves.

2. esp_pkt_to_tuple does SPI lookup (just like now).
   found full match -> done

3. no match?
   Basically do what search_esp_entry_init_remote() does, i.e.
   check if its a 'reverse direction'.

Otherwise, assume the new connection is the reverse tunnel of an existing
connection.

Add an expectation for this connection, so it will be picked up as RELATED
rather than new. 

As far as I can see, all that is needed for the expectations can be
found using info stored in the rhashtable(s).

nf_conntrack_find_get() finds us the existing conntrack entry
that we need to pass to nf_ct_expect_alloc().

The needed tuple could just be stored in the rhltable that gets
searched in search_esp_entry_init_remote().

Everything else we need for nf_ct_expect_init() is already present
in the tuple.

This creates a related conntrack entry that is linked to the existing
connection.

Do you see anything that prevents this from working or has other,
undesireable properties vs. the existing proposal?

This would also be easier to review, since it could be layered:

First patch would just add a really simple ESP tracker that just
extracts the SPI, without any rhashtable usage.

Just enough code to make it so 'conntrack -L' or the older /proc file show each
address/spi as independent connection, rather than just the single
'generic' entry.

Then, add the rhashtable code and the hooks you already have to clear
out entries on netns removal and when a conntrack gets destroyed.

Then, in a 3rd patch, add the expectation code, so that a 'new'
connection turns into a related one if the rhtable/rhlist finds
something relevant.

What do you think?
