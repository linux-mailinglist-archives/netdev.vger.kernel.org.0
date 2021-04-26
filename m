Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F088D36B28D
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 13:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbhDZLy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 07:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbhDZLy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 07:54:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB509C061574;
        Mon, 26 Apr 2021 04:54:14 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lazoP-0000DT-H6; Mon, 26 Apr 2021 13:54:01 +0200
Date:   Mon, 26 Apr 2021 13:54:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Cc:     fw@strlen.de, pablo@netfilter.org, kadlec@netfilter.org,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_conntrack: Add conntrack helper for
 ESP/IPsec
Message-ID: <20210426115401.GB19277@breakpoint.cc>
References: <20210414154021.GE14932@breakpoint.cc>
 <20210420223514.10827-1-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420223514.10827-1-Cole.Dishington@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cole Dishington <Cole.Dishington@alliedtelesis.co.nz> wrote:
> @@ -90,6 +90,8 @@ enum ctattr_l4proto {
>  	CTA_PROTO_ICMPV6_ID,
>  	CTA_PROTO_ICMPV6_TYPE,
>  	CTA_PROTO_ICMPV6_CODE,
> +	CTA_PROTO_SRC_ESP_ID,
> +	CTA_PROTO_DST_ESP_ID,
>  	__CTA_PROTO_MAX
>  };


> diff --git a/net/netfilter/nf_conntrack_proto_esp.c b/net/netfilter/nf_conntrack_proto_esp.c
> new file mode 100644
> index 000000000000..f17ce8a9439f
> --- /dev/null
> +++ b/net/netfilter/nf_conntrack_proto_esp.c
> @@ -0,0 +1,736 @@
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
> + */
> +/******************************************************************************
> + * Filename:       nf_conntrack_proto_esp.c
> + * Author:         Pavan Kumar
> + * Creation Date:  05/27/04
> + *

Can you remove this changelog?  The history isn't relevant for upstream.
You can add credits to the commit message if you like.

> +	struct rhash_head lnode;
> +	struct rhash_head rnode;
> +	struct rhlist_head incmpl_rlist;
> +
> +	u16 esp_id;
> +
> +	u32 l_spi;
> +	u32 r_spi;
> +
> +	u16 l3num;

Minor nit: you can save a few bytes by placing the two u16 next to each
other.

> +	union nf_inet_addr l_ip;
> +	union nf_inet_addr r_ip;
> +
> +	u32 alloc_time_jiffies;
> +	struct net *net;
> +};
> +
> +struct _esp_hkey {
> +	u16 l3num;

Nit: l3num can be u8.

> +static inline void esp_ip_addr_set_any(int af, union nf_inet_addr *a)
> +{
> +	if (af == AF_INET6)
> +		ipv6_addr_set(&a->in6, 0, 0, 0, 0);

Alternative is a->in6 = IN6ADDR_ANY_INIT , up to you.

You could also remove the if (af ... conditional and just zero
everything.

Also, with very few exceptions, we try to avoid 'inline' keyword in .c
files.

> +static inline void esp_ip_addr_copy(int af, union nf_inet_addr *dst,
> +				    const union nf_inet_addr *src)
> +{
> +	if (af == AF_INET6)
> +		ipv6_addr_prefix_copy(&dst->in6, &src->in6, 128);

Alternative is to dst->in6 = src->in6.

> +static inline void calculate_key(const u32 net_hmix, const u32 spi,
> +				 const u16 l3num,

l3num can be u8.

> +int nf_conntrack_esp_init(void)
> +{
> +	int i;
> +	int ret = 0;
> +
> +	spin_lock_bh(&esp_table_lock);

This lock isn't needed.  There is no way this function
can be executed concurrently.

> +	/* Check if esphdr already associated with a pre-existing connection:
> +	 *   if no, create a new connection, missing the r_spi;
> +	 *   if yes, check if we have seen the source IP:
> +	 *             if no, fill in r_spi in the pre-existing connection.
> +	 */
> +	spin_lock_bh(&esp_table_lock);

Can you remove this lock?

It would be very unfortunate if we lose rhashtable ability of parallel
insert & lockless lookups.

> +	esp_entry = search_esp_entry_by_spi(net, spi, tuple->src.l3num,
> +					    &tuple->src.u3, &tuple->dst.u3);
> +	if (!esp_entry) {
> +		struct _esp_hkey key = {};
> +		union nf_inet_addr any;
> +		u32 net_hmix = net_hash_mix(net);
> +		int err;
> +
> +		esp_entry = alloc_esp_entry(net);
> +		if (!esp_entry) {
> +			pr_debug("All esp connection slots in use\n");
> +			spin_unlock_bh(&esp_table_lock);
> +			return false;
> +		}
> +		esp_entry->l_spi = spi;
> +		esp_entry->l3num = tuple->src.l3num;
> +		esp_ip_addr_copy(esp_entry->l3num, &esp_entry->l_ip, &tuple->src.u3);
> +		esp_ip_addr_copy(esp_entry->l3num, &esp_entry->r_ip, &tuple->dst.u3);
> +
> +		/* Add entries to the hash tables */
> +
> +		err = rhashtable_insert_fast(&ltable, &esp_entry->lnode, ltable_params);
> +		if (err) {

... without lock, this can fail with -EEXIST.

You could remove the esp_table_lock and change the above
rhashtable_insert_fast() to something like:

esp_entry_old = rhashtable_lookup_get_insert_fast(&ltable, &esp_entry->lnode ltable_params);
if (esp_entry_old) {
	if (IS_ERR(esp_entry_old)) {
		esp_table_free_entry_by_esp_id(net, esp_entry->esp_id);
		return false;
	}

	esp_table_free_entry_by_esp_id(net, esp_entry->esp_id);
	/* insertion raced, use existing entry */
	esp_entry = esp_entry_old;
}
/* esp_entry_old == NULL -- insertion successful */

This should allow removal of the esp_table_lock spinlock.

> +#ifdef CONFIG_NF_CONNTRACK_PROCFS
> +/* print private data for conntrack */
> +static void esp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
> +{
> +	seq_printf(s, "l_spi=%x, r_spi=%x ", ct->proto.esp.l_spi, ct->proto.esp.r_spi);

Thanks, this looks good.

> +			nf_conntrack_event_cache(IPCT_ASSURED, ct);
> +
> +			/* Retrieve SPIs of original and reply from esp_entry.
> +			 * Both directions should contain the same esp_entry,
> +			 * so just check the first one.
> +			 */
> +			tuple = nf_ct_tuple(ct, IP_CT_DIR_ORIGINAL);
> +			esp_id = tuple->src.u.esp.id;
> +			if (esp_id >= TEMP_SPI_START && esp_id <= TEMP_SPI_MAX) {
> +				spin_lock_bh(&esp_table_lock);
> +				esp_entry = esp_table[esp_id - TEMP_SPI_START];

This esp_table[] has to be removed.

1. It breaks netns isolation
2. It forces contention on a single spinlock.

As far as I understand, this table also serves as a resource limiter to
avoid eating up too much resources.

So, how about adding a espid bitmap to struct nf_conntrack_net?

Something like this:

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -63,6 +63,9 @@ struct nf_conntrack_net {
 	struct delayed_work ecache_dwork;
 	struct netns_ct *ct_net;
 #endif
+#ifdef CONFIG_NF_CT_PROTO_ESP
+	DECLARE_BITMAP(esp_id_map, 1024);
+#endif
 };
 
 #include <linux/types.h>
diff --git a/net/netfilter/nf_conntrack_proto_esp.c b/net/netfilter/nf_conntrack_proto_esp.c
index f17ce8a9439f..ce4d5864c480 100644
--- a/net/netfilter/nf_conntrack_proto_esp.c
+++ b/net/netfilter/nf_conntrack_proto_esp.c
@@ -341,24 +340,28 @@ static void esp_table_free_entry_by_esp_id(struct net *net, u16 esp_id)
  */
 struct _esp_table *alloc_esp_entry(struct net *net)
 {
-	int idx;
+	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
 	struct _esp_table *esp_entry = NULL;
+	int idx;
 
-	/* Find the first unused slot */
-	for (idx = 0; idx < ESP_MAX_CONNECTIONS; idx++) {
-		if (esp_table[idx])
-			continue;
+again:
+	idx = find_first_zero_bit(cnet->esp_id_map, 1024);
+	if (idx >= 1024)
+		return NULL;
 
-		esp_table[idx] = kmalloc(sizeof(*esp_entry), GFP_ATOMIC);
-		if (!esp_table[idx])
-			return NULL;
-		memset(esp_table[idx], 0, sizeof(struct _esp_table));
-		esp_table[idx]->esp_id = idx + TEMP_SPI_START;
-		esp_table[idx]->alloc_time_jiffies = nfct_time_stamp;
-		esp_table[idx]->net = net;
-		esp_entry = esp_table[idx];
-		break;
+	if (test_and_set_bit(cnet->esp_id_map, idx))
+		goto again; /* raced */
+
+	esp_entry = kmalloc(sizeof(*esp_entry), GFP_ATOMIC);
+	if (!esp_entry) {
+		clear_bit(cnet->esp_id_map, idx);
+		return NULL;
 	}
+
+	esp_entry->esp_id = idx + TEMP_SPI_START;
+	esp_entry->alloc_time_jiffies = nfct_time_stamp;
+	esp_entry->net = net;
+
 	return esp_entry;
 }


I have a few more concerns:

AFAICS there is no guarantee that an allocated esp table entry is backed
by a conntrack entry.

So, there must be a way to reap all allocated esp_entry structs
when a network namespace goes down.

Perhaps you could add a pernet (nf_conntrack_net) spinlock+list head
that appends each allocated entry to that list.

Then, on conntrack removal, in addition to removal from the rhash
tables, add a list_del().

On network namespace destruction, walk this list and remove all
remaining entries (those that are still around after removal of all
the conntrack objects).

Does that make sense to you?

> +static int esp_tuple_to_nlattr(struct sk_buff *skb,
> +			       const struct nf_conntrack_tuple *t)
> +{
> +	if (nla_put_be16(skb, CTA_PROTO_SRC_ESP_ID, t->src.u.esp.id) ||
> +	    nla_put_be16(skb, CTA_PROTO_DST_ESP_ID, t->dst.u.esp.id))
> +		goto nla_put_failure;

This exposes the 16 bit kernel-generated IDs, right?
Should this dump the real on-wire SPIs instead?

Or is there are reason why the internal IDs need exposure?
