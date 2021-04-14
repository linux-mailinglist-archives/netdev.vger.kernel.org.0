Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B205F35F7FF
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbhDNPlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbhDNPk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 11:40:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5558C061574;
        Wed, 14 Apr 2021 08:40:32 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lWhcr-0005bm-LX; Wed, 14 Apr 2021 17:40:21 +0200
Date:   Wed, 14 Apr 2021 17:40:21 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_conntrack: Add conntrack helper for
 ESP/IPsec
Message-ID: <20210414154021.GE14932@breakpoint.cc>
References: <20210414035327.31018-1-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414035327.31018-1-Cole.Dishington@alliedtelesis.co.nz>
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

Thanks for the effort to upstream out of tree code.

A couple of comments and questions below.

Preface: AFAIU this tracker aims to 'soft-splice' two independent
ESP connections, i.e.:

saddr:spi1 -> daddr
daddr:spi2 <- saddr

So that we basically get this conntrack:

saddr,daddr,spi1 (original)   daddr,saddr,spi2 (remote)

This can't be done as-is, because we don't know spi2 at the time the
first ESP packet is received.

The solution implemented here is introduction of a 'virtual esp id',
computed when first ESP packet is received, so conntrack really stores:

saddr,daddr,ID (original)   daddr,saddr,ID (remote)

Because the ID is never carried on the wire, this tracker hooks into
pkt_to_tuple() infra so that the conntrack tuple gets populated
as-needed.

If I got that right, I think it would be good to place some description
like this in the source code, this is unlike all the other trackers.

> index 000000000000..2441e031c68e
> --- /dev/null
> +++ b/include/linux/netfilter/nf_conntrack_proto_esp.h
> @@ -0,0 +1,25 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _CONNTRACK_PROTO_ESP_H
> +#define _CONNTRACK_PROTO_ESP_H
> +#include <asm/byteorder.h>
> +
> +/* ESP PROTOCOL HEADER */
> +
> +struct esphdr {
> +	__u32 spi;
> +};
> +
> +struct nf_ct_esp {
> +	unsigned int stream_timeout;
> +	unsigned int timeout;
> +};
> +
> +#ifdef __KERNEL__
> +#include <net/netfilter/nf_conntrack_tuple.h>
> +
> +void destroy_esp_conntrack_entry(struct nf_conn *ct);
> +
> +bool esp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
> +		      struct net *net, struct nf_conntrack_tuple *tuple);
> +#endif /* __KERNEL__ */

No need for the __KERNEL__, this header is not exposed to userspace
(only those in include/uapi/).

>  			struct {
>  				__be16 key;
>  			} gre;
> +			struct {
> +				__be16 spi;

__be32 ?

I now see that this "spi" seems to be allocated by the esp tracker.
Maybe 'esp_id' or something like that?

It doesn't appear to be related to the ESP header SPI value.

> --- a/include/net/netns/conntrack.h
> +++ b/include/net/netns/conntrack.h
> @@ -69,6 +69,27 @@ struct nf_gre_net {
>  };
>  #endif
>  
> +#ifdef CONFIG_NF_CT_PROTO_ESP
> +#define ESP_MAX_PORTS      1000
> +#define HASH_TAB_SIZE  ESP_MAX_PORTS

ESP? Ports?  Should this be 'slots'?  Maybe a comment helps, I don't
expect to see ports in an ESP tracker.

> +enum esp_conntrack {
> +	ESP_CT_UNREPLIED,
> +	ESP_CT_REPLIED,
> +	ESP_CT_MAX
> +};
> +
> +struct nf_esp_net {
> +	rwlock_t esp_table_lock;

This uses a rwlock but i only see writer locks being taken.
So this either should use a spinlock, or reader-parts should
take readlock, not wrlock.

(but also see below).

> +	struct hlist_head ltable[HASH_TAB_SIZE];
> +	struct hlist_head rtable[HASH_TAB_SIZE];
> +	/* Initial lookup for remote end until rspi is known */
> +	struct hlist_head incmpl_rtable[HASH_TAB_SIZE];
> +	struct _esp_table *esp_table[ESP_MAX_PORTS];
> +	unsigned int esp_timeouts[ESP_CT_MAX];
> +};

This is large structure -- >32kb.

Could this be moved to nf_conntrack_net?

It would also be good to not allocate these hash slots until after conntrack
is needed.

The esp_timeouts[] can be kept to avoid module dep problems.

(But also see below, I'm not sure homegrown hash table is the way to go).

>  struct ct_pcpu {
> diff --git a/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h b/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
> index 64390fac6f7e..9bbd76c325d2 100644
> --- a/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
> +++ b/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
> @@ -39,6 +39,9 @@ union nf_conntrack_man_proto {
..
> +#if 0
> +#define ESP_DEBUG 1
> +#define DEBUGP(format, args...) printk(KERN_DEBUG "%s: " format, __func__, ## args)
> +#else
> +#undef ESP_DEBUG
> +#define DEBUGP(x, args...)
> +#endif

I suggest to get rid of all of DEBUGP(), either drop them, or, in cases
where they are useful, switch to pr_debug().

> +#define TEMP_SPI_START 1500
> +#define TEMP_SPI_MAX   (TEMP_SPI_START + ESP_MAX_PORTS - 1)

I think this could use an explanation.

> +struct _esp_table {
> +	/* Hash table nodes for each required lookup
> +	 * lnode: l_spi, l_ip, r_ip
> +	 * rnode: r_spi, r_ip
> +	 * incmpl_rnode: r_ip
> +	 */
> +	struct hlist_node lnode;
> +	struct hlist_node rnode;
> +	struct hlist_node incmpl_rnode;
> +
> +	u32 l_spi;
> +	u32 r_spi;
> +	u32 l_ip;
> +	u32 r_ip;

Hmm, ipv4 only.  Could this be changed to also support ipv6?

At least this should use 'union nf_inet_addr' or add a full
struct nf_conntrack_tuple to get src/dst/+SPIs in one entry.

> +	u16 tspi;

Whats the tspi? (Might be clear later after reading the entire
file, but for sure could use a comment).

> +	unsigned long allocation_time;

Perhaps use alloc_time_jiffies to make it clear what units are expected
here.  Or, better yet, use 'u32 alloc_time_jiffies' and nfct_time_stamp,
which is just 32bit jiffies (needs less space and is sufficient for
'older/more recent than' logic.

> +/* Allocate a free IPSEC table entry.
> + * NOTE: The ESP entry table must be locked prior to calling this function.
> + */
> +struct _esp_table *alloc_esp_entry(struct net *net)
> +{
> +	struct nf_esp_net *net_esp = esp_pernet(net);
> +	struct _esp_table **esp_table = net_esp->esp_table;
> +	struct _esp_table *esp_entry = NULL;
> +	int idx = 0;
> +
> +	/* Find the first unused slot */
> +	for (; idx < ESP_MAX_PORTS; idx++) {
> +		if (esp_table[idx])
> +			continue;
> +
> +		esp_table[idx] = kmalloc(sizeof(*esp_entry), GFP_ATOMIC);
> +		memset(esp_table[idx], 0, sizeof(struct _esp_table));

Missing NULL/ENOMEM check.

However, it would be nice to avoid this kmalloc completely, but so far I
can't find a way, since this gets inserted/retrieved from pkt_to_tuple, before
nf_conn is inserted/looked up.

1. spi * 2 (local, remote)
2. 3 node pointers for the tables (might be able to use only 2?)

Thats 56 bytes total on x86_64, and would fit into the ct->proto storage
(its a union, currently @ 60 bytes).

The addresses are already stored in the nf_conn entry itself.

Unfortunately I don't see a way to leverage this (we can't recurse/do
lookups into the conntrack table either).

> +static struct _esp_table *search_esp_entry_init_remote(struct nf_esp_net *net_esp,
> +						       const u32 src_ip)
> +{
> +	struct _esp_table **esp_table = net_esp->esp_table;
> +	struct _esp_table *esp_entry = NULL;
> +	u32 hash = 0;
> +	int first_entry = -1;
> +
> +	hash = calculate_hash(0, src_ip, 0);
> +	hlist_for_each_entry(esp_entry, &net_esp->incmpl_rtable[hash],
> +			     incmpl_rnode) {
> +		DEBUGP("Checking against incmpl_rtable entry %x (%p) with l_spi %x r_spi %x r_ip %x\n",
> +		       esp_entry->tspi, esp_entry, esp_entry->l_spi,
> +		       esp_entry->r_spi, esp_entry->r_ip);
> +		if (src_ip == esp_entry->r_ip && esp_entry->l_spi != 0 &&
> +		    esp_entry->r_spi == 0) {
> +			DEBUGP("Matches entry %x", esp_entry->tspi);
> +			if (first_entry == -1) {
> +				DEBUGP("First match\n");
> +				first_entry = esp_entry->tspi - TEMP_SPI_START;
> +			} else if (esp_table[first_entry]->allocation_time >
> +				   esp_entry->allocation_time) {

This needs time_after() etc. to avoid errors when jiffy counter wraps.
Alternatively, look at nf_ct_is_expired(), copy that and use "nfct_time_stamp"
instead of jiffies (its 32bit jiffies, even on 64bit to save space in
nf_conn struct).

> +struct _esp_table *search_esp_entry_by_spi(struct net *net, const __u32 spi,
> +					   const __u32 src_ip, const __u32 dst_ip)
> +{
> +	struct nf_esp_net *net_esp = esp_pernet(net);
> +	struct _esp_table *esp_entry = NULL;
> +	u32 hash = 0;
> +
> +	/* Check for matching established session or repeated initial LAN side */
> +	/* LAN side first */
> +	hash = calculate_hash(spi, src_ip, dst_ip);
> +	hlist_for_each_entry(esp_entry, &net_esp->ltable[hash], lnode) {
> +		DEBUGP
> +		    ("Checking against ltable entry %x (%p) with l_spi %x l_ip %x r_ip %x\n",
> +		     esp_entry->tspi, esp_entry, esp_entry->l_spi,
> +		     esp_entry->l_ip, esp_entry->r_ip);
> +		if (spi == esp_entry->l_spi && src_ip == esp_entry->l_ip &&
> +		    dst_ip == esp_entry->r_ip) {
> +			/* When r_spi is set this is an established session. When not set it's
> +			 * a repeated initial packet from LAN side. But both cases are treated
> +			 * the same.
> +			 */
> +			DEBUGP("Matches entry %x", esp_entry->tspi);
> +			return esp_entry;
> +		}
> +	}

The first lookup should normally find an entry, correct?

> +	/* Established remote side */
> +	hash = calculate_hash(spi, src_ip, 0);
> +	hlist_for_each_entry(esp_entry, &net_esp->rtable[hash], rnode) {
> +		DEBUGP
> +		    ("Checking against rtable entry %x (%p) with l_spi %x r_spi %x r_ip %x\n",
> +		     esp_entry->tspi, esp_entry, esp_entry->l_spi,
> +		     esp_entry->r_spi, esp_entry->r_ip);
> +		if (spi == esp_entry->r_spi && src_ip == esp_entry->r_ip &&
> +		    esp_entry->l_spi != 0) {
[..]

> +	/* Incomplete remote side */
> +	esp_entry = search_esp_entry_init_remote(net_esp, src_ip);
> +	if (esp_entry) {
> +		esp_entry->r_spi = spi;
> +		/* Remove entry from incmpl_rtable and add to rtable */
> +		DEBUGP("Completing entry %x with remote SPI info",
> +		       esp_entry->tspi);
> +		hlist_del_init(&esp_entry->incmpl_rnode);
> +		hash = calculate_hash(spi, src_ip, 0);
> +		hlist_add_head(&esp_entry->rnode, &net_esp->rtable[hash]);
> +		return esp_entry;
> +	}
> +
> +	DEBUGP("No Entry\n");
> +	return NULL;
> +}
> +
> +/* invert esp part of tuple */
> +bool nf_conntrack_invert_esp_tuple(struct nf_conntrack_tuple *tuple,
> +				   const struct nf_conntrack_tuple *orig)
> +{
> +	tuple->dst.u.esp.spi = orig->dst.u.esp.spi;
> +	tuple->src.u.esp.spi = orig->src.u.esp.spi;
> +	return true;
> +}
> +
> +/* esp hdr info to tuple */
> +bool esp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
> +		      struct net *net, struct nf_conntrack_tuple *tuple)
> +{
> +	struct nf_esp_net *net_esp = esp_pernet(net);
> +	struct esphdr _esphdr, *esphdr;
> +	struct _esp_table *esp_entry = NULL;
> +	u32 spi = 0;
> +
> +	esphdr = skb_header_pointer(skb, dataoff, sizeof(_esphdr), &_esphdr);
> +	if (!esphdr) {
> +		/* try to behave like "nf_conntrack_proto_generic" */
> +		tuple->src.u.all = 0;
> +		tuple->dst.u.all = 0;
> +		return true;
> +	}
> +	spi = ntohl(esphdr->spi);
> +
> +	DEBUGP("Enter pkt_to_tuple() with spi %x\n", spi);
> +	/* check if esphdr has a new SPI:
> +	 *   if no, update tuple with correct tspi;
> +	 *   if yes, check if we have seen the source IP:
> +	 *             if yes, update the ESP tables update the tuple with correct tspi
> +	 *             if no, create a new entry
> +	 */
> +	write_lock_bh(&net_esp->esp_table_lock);

So all CPUs serialize on this lock.  I'm concerned this will cause
performance regression, ATM ESP is handled by generic tracker; after
this is applied it will be handled here.

At the very least this should use read lock only and upgrade to wrlock
if needed only.

> +	esp_entry = search_esp_entry_by_spi(net, spi, tuple->src.u3.ip,
> +					    tuple->dst.u3.ip);
> +	if (!esp_entry) {
> +		u32 hash = 0;
> +
> +		esp_entry = alloc_esp_entry(net);
> +		if (!esp_entry) {
> +			DEBUGP("All entries in use\n");
> +			write_unlock_bh(&net_esp->esp_table_lock);
> +			return false;
> +		}
> +		esp_entry->l_spi = spi;
> +		esp_entry->l_ip = tuple->src.u3.ip;
> +		esp_entry->r_ip = tuple->dst.u3.ip;
> +		/* Add entries to the hash tables */
> +		hash = calculate_hash(spi, esp_entry->l_ip, esp_entry->r_ip);
> +		hlist_add_head(&esp_entry->lnode, &net_esp->ltable[hash]);
> +		hash = calculate_hash(0, 0, esp_entry->r_ip);
> +		hlist_add_head(&esp_entry->incmpl_rnode,
> +			       &net_esp->incmpl_rtable[hash]);
> +	}
> +
> +	DEBUGP
> +	    ("entry_info: tspi %u l_spi 0x%x r_spi 0x%x l_ip %x r_ip %x srcIP %x dstIP %x\n",
> +	     esp_entry->tspi, esp_entry->l_spi, esp_entry->r_spi,
> +	     esp_entry->l_ip, esp_entry->r_ip, tuple->src.u3.ip,
> +	     tuple->dst.u3.ip);
> +
> +	tuple->dst.u.esp.spi = esp_entry->tspi;
> +	tuple->src.u.esp.spi = esp_entry->tspi;
> +	write_unlock_bh(&net_esp->esp_table_lock);
> +	return true;
> +}
> +
> +#ifdef CONFIG_NF_CONNTRACK_PROCFS
> +/* print private data for conntrack */
> +static void esp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
> +{
> +	seq_printf(s, "timeout=%u, stream_timeout=%u ",
> +		   (ct->proto.esp.timeout / HZ),
> +		   (ct->proto.esp.stream_timeout / HZ));

What is ct->proto.esp.{timeout,stream_timeout} for?
I don't see where/how its used.

> +/* Returns verdict for packet, and may modify conntrack */
> +int nf_conntrack_esp_packet(struct nf_conn *ct, struct sk_buff *skb,
> +			    unsigned int dataoff,
> +			    enum ip_conntrack_info ctinfo,
> +			    const struct nf_hook_state *state)
> +{
> +	unsigned int *timeouts = nf_ct_timeout_lookup(ct);
> +#ifdef ESP_DEBUG
> +	const struct iphdr *iph;
> +	struct esphdr _esphdr, *esphdr;
> +
> +	iph = ip_hdr(skb);

This will treat ipv6 as ipv4 header, no?

> +	if (!timeouts)
> +		timeouts = esp_pernet(nf_ct_net(ct))->esp_timeouts;
> +
> +	if (!nf_ct_is_confirmed(ct)) {
> +		ct->proto.esp.stream_timeout = timeouts[ESP_CT_REPLIED];
> +		ct->proto.esp.timeout = timeouts[ESP_CT_UNREPLIED];

So first packet inits these, but apart from esp_print_conntrack() i see
no readers.

> +/* Called when a conntrack entry has already been removed from the hashes
> + * and is about to be deleted from memory
> + */
> +void destroy_esp_conntrack_entry(struct nf_conn *ct)
> +{
> +	struct nf_conntrack_tuple *tuple = NULL;
> +	enum ip_conntrack_dir dir;
> +	u16 tspi = 0;
> +	struct net *net = nf_ct_net(ct);
> +	struct nf_esp_net *net_esp = esp_pernet(net);
> +
> +	write_lock_bh(&net_esp->esp_table_lock);
> +
> +	/* Probably all the ESP entries referenced in this connection are the same,
> +	 * but the free function handles repeated frees, so best to do them all.
> +	 */
> +	for (dir = IP_CT_DIR_ORIGINAL; dir < IP_CT_DIR_MAX; dir++) {
> +		tuple = nf_ct_tuple(ct, dir);
> +
> +		tspi = tuple->src.u.esp.spi;
> +		if (tspi >= TEMP_SPI_START && tspi <= TEMP_SPI_MAX) {
> +			DEBUGP("Deleting src tspi %x (dir %i)\n", tspi, dir);
> +			esp_table_free_entry_by_tspi(net, tspi);
> +		}
> +		tuple->src.u.esp.spi = 0;
> +		tspi = tuple->dst.u.esp.spi;
> +		if (tspi >= TEMP_SPI_START && tspi <= TEMP_SPI_MAX) {
> +			DEBUGP("Deleting dst tspi %x (dir %i)\n", tspi, dir);
> +			esp_table_free_entry_by_tspi(net, tspi);
> +		}
> +		tuple->dst.u.esp.spi = 0;
> +	}
> +

Questions:
Could this use rhashtable(s) instead of the homegrown table?

This would allow:
 1. use of shared rhashtables for the namespaces, since netns could be
 part of key. That in turn avoids the need to allocate memory for each
 different netns.
 2. automatically provides rcu-guarded read access & parallel inserts.

Could this tracker store the current local and remove SPI as seen on
wire?  It could be stored in the proto.esp stash so its not part of the
hash key.

That would allow to export/print it to userspace, so conntrack tool or
/proc could show the real SPI used by local and remote.

3. How hard is it to add ipv6 support?

If its out-of-scope it could be restricted to NFPROTO_IPV4 and have
generic-tracker behaviour for ipv6.

I might have more questions later, I need to spend a bit more time on
this.
