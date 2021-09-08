Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230F04037D4
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 12:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348868AbhIHK2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 06:28:44 -0400
Received: from h4.fbrelay.privateemail.com ([131.153.2.45]:41238 "EHLO
        h4.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229781AbhIHK2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 06:28:43 -0400
Received: from MTA-06-4.privateemail.com (mta-06-1.privateemail.com [68.65.122.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h3.fbrelay.privateemail.com (Postfix) with ESMTPS id C166080C28;
        Wed,  8 Sep 2021 06:27:34 -0400 (EDT)
Received: from mta-06.privateemail.com (localhost [127.0.0.1])
        by mta-06.privateemail.com (Postfix) with ESMTP id 13F041800203;
        Wed,  8 Sep 2021 06:27:33 -0400 (EDT)
Received: from [192.168.0.46] (unknown [10.20.151.238])
        by mta-06.privateemail.com (Postfix) with ESMTPA id 4CC9218000BF;
        Wed,  8 Sep 2021 06:27:31 -0400 (EDT)
Date:   Wed, 08 Sep 2021 06:27:24 -0400
From:   Hamza Mahfooz <someguy@effective-light.com>
Subject: Re: [PATCH] wireguard: convert index_hashtable and pubkey_hashtable
 into rhashtables
To:     linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org
Message-Id: <OD24ZQ.IQOQXX8U0YST@effective-light.com>
In-Reply-To: <20210806044315.169657-1-someguy@effective-light.com>
References: <20210806044315.169657-1-someguy@effective-light.com>
X-Mailer: geary/40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ping

On Fri, Aug 6 2021 at 12:43:14 AM -0400, Hamza Mahfooz 
<someguy@effective-light.com> wrote:
> It is made mention of in commit e7096c131e516 ("net: WireGuard secure
> network tunnel"), that it is desirable to move away from the 
> statically
> sized hash-table implementation.
> 
> Signed-off-by: Hamza Mahfooz <someguy@effective-light.com>
> ---
>  drivers/net/wireguard/device.c     |   4 +
>  drivers/net/wireguard/device.h     |   2 +-
>  drivers/net/wireguard/noise.c      |   1 +
>  drivers/net/wireguard/noise.h      |   1 +
>  drivers/net/wireguard/peer.h       |   2 +-
>  drivers/net/wireguard/peerlookup.c | 190 
> ++++++++++++++---------------
>  drivers/net/wireguard/peerlookup.h |  27 ++--
>  7 files changed, 112 insertions(+), 115 deletions(-)
> 
> diff --git a/drivers/net/wireguard/device.c 
> b/drivers/net/wireguard/device.c
> index 551ddaaaf540..3bd43c9481ef 100644
> --- a/drivers/net/wireguard/device.c
> +++ b/drivers/net/wireguard/device.c
> @@ -243,7 +243,9 @@ static void wg_destruct(struct net_device *dev)
>  	skb_queue_purge(&wg->incoming_handshakes);
>  	free_percpu(dev->tstats);
>  	free_percpu(wg->incoming_handshakes_worker);
> +	wg_index_hashtable_destroy(wg->index_hashtable);
>  	kvfree(wg->index_hashtable);
> +	wg_pubkey_hashtable_destroy(wg->peer_hashtable);
>  	kvfree(wg->peer_hashtable);
>  	mutex_unlock(&wg->device_update_lock);
> 
> @@ -382,8 +384,10 @@ static int wg_newlink(struct net *src_net, 
> struct net_device *dev,
>  err_free_tstats:
>  	free_percpu(dev->tstats);
>  err_free_index_hashtable:
> +	wg_index_hashtable_destroy(wg->index_hashtable);
>  	kvfree(wg->index_hashtable);
>  err_free_peer_hashtable:
> +	wg_pubkey_hashtable_destroy(wg->peer_hashtable);
>  	kvfree(wg->peer_hashtable);
>  	return ret;
>  }
> diff --git a/drivers/net/wireguard/device.h 
> b/drivers/net/wireguard/device.h
> index 854bc3d97150..24980eb766af 100644
> --- a/drivers/net/wireguard/device.h
> +++ b/drivers/net/wireguard/device.h
> @@ -50,7 +50,7 @@ struct wg_device {
>  	struct multicore_worker __percpu *incoming_handshakes_worker;
>  	struct cookie_checker cookie_checker;
>  	struct pubkey_hashtable *peer_hashtable;
> -	struct index_hashtable *index_hashtable;
> +	struct rhashtable *index_hashtable;
>  	struct allowedips peer_allowedips;
>  	struct mutex device_update_lock, socket_update_lock;
>  	struct list_head device_list, peer_list;
> diff --git a/drivers/net/wireguard/noise.c 
> b/drivers/net/wireguard/noise.c
> index c0cfd9b36c0b..d42a0ff2be5d 100644
> --- a/drivers/net/wireguard/noise.c
> +++ b/drivers/net/wireguard/noise.c
> @@ -797,6 +797,7 @@ bool wg_noise_handshake_begin_session(struct 
> noise_handshake *handshake,
>  	new_keypair->i_am_the_initiator = handshake->state ==
>  					  HANDSHAKE_CONSUMED_RESPONSE;
>  	new_keypair->remote_index = handshake->remote_index;
> +	new_keypair->entry.index = handshake->entry.index;
> 
>  	if (new_keypair->i_am_the_initiator)
>  		derive_keys(&new_keypair->sending, &new_keypair->receiving,
> diff --git a/drivers/net/wireguard/noise.h 
> b/drivers/net/wireguard/noise.h
> index c527253dba80..ea705747e4e4 100644
> --- a/drivers/net/wireguard/noise.h
> +++ b/drivers/net/wireguard/noise.h
> @@ -72,6 +72,7 @@ struct noise_handshake {
> 
>  	u8 ephemeral_private[NOISE_PUBLIC_KEY_LEN];
>  	u8 remote_static[NOISE_PUBLIC_KEY_LEN];
> +	siphash_key_t skey;
>  	u8 remote_ephemeral[NOISE_PUBLIC_KEY_LEN];
>  	u8 precomputed_static_static[NOISE_PUBLIC_KEY_LEN];
> 
> diff --git a/drivers/net/wireguard/peer.h 
> b/drivers/net/wireguard/peer.h
> index 76e4d3128ad4..d5403fb7a6a0 100644
> --- a/drivers/net/wireguard/peer.h
> +++ b/drivers/net/wireguard/peer.h
> @@ -48,7 +48,7 @@ struct wg_peer {
>  	atomic64_t last_sent_handshake;
>  	struct work_struct transmit_handshake_work, clear_peer_work, 
> transmit_packet_work;
>  	struct cookie latest_cookie;
> -	struct hlist_node pubkey_hash;
> +	struct rhash_head pubkey_hash;
>  	u64 rx_bytes, tx_bytes;
>  	struct timer_list timer_retransmit_handshake, timer_send_keepalive;
>  	struct timer_list timer_new_handshake, timer_zero_key_material;
> diff --git a/drivers/net/wireguard/peerlookup.c 
> b/drivers/net/wireguard/peerlookup.c
> index f2783aa7a88f..2ea2ba85a33d 100644
> --- a/drivers/net/wireguard/peerlookup.c
> +++ b/drivers/net/wireguard/peerlookup.c
> @@ -7,18 +7,29 @@
>  #include "peer.h"
>  #include "noise.h"
> 
> -static struct hlist_head *pubkey_bucket(struct pubkey_hashtable 
> *table,
> -					const u8 pubkey[NOISE_PUBLIC_KEY_LEN])
> +struct pubkey_pair {
> +	u8 key[NOISE_PUBLIC_KEY_LEN];
> +	siphash_key_t skey;
> +};
> +
> +static u32 pubkey_hash(const void *data, u32 len, u32 seed)
>  {
> +	const struct pubkey_pair *pair = data;
> +
>  	/* siphash gives us a secure 64bit number based on a random key. 
> Since
> -	 * the bits are uniformly distributed, we can then mask off to get 
> the
> -	 * bits we need.
> +	 * the bits are uniformly distributed.
>  	 */
> -	const u64 hash = siphash(pubkey, NOISE_PUBLIC_KEY_LEN, &table->key);
> 
> -	return &table->hashtable[hash & (HASH_SIZE(table->hashtable) - 1)];
> +	return (u32)siphash(pair->key, len, &pair->skey);
>  }
> 
> +static const struct rhashtable_params wg_peer_params = {
> +	.key_len = NOISE_PUBLIC_KEY_LEN,
> +	.key_offset = offsetof(struct wg_peer, handshake.remote_static),
> +	.head_offset = offsetof(struct wg_peer, pubkey_hash),
> +	.hashfn = pubkey_hash
> +};
> +
>  struct pubkey_hashtable *wg_pubkey_hashtable_alloc(void)
>  {
>  	struct pubkey_hashtable *table = kvmalloc(sizeof(*table), 
> GFP_KERNEL);
> @@ -27,26 +38,25 @@ struct pubkey_hashtable 
> *wg_pubkey_hashtable_alloc(void)
>  		return NULL;
> 
>  	get_random_bytes(&table->key, sizeof(table->key));
> -	hash_init(table->hashtable);
> -	mutex_init(&table->lock);
> +	rhashtable_init(&table->hashtable, &wg_peer_params);
> +
>  	return table;
>  }
> 
>  void wg_pubkey_hashtable_add(struct pubkey_hashtable *table,
>  			     struct wg_peer *peer)
>  {
> -	mutex_lock(&table->lock);
> -	hlist_add_head_rcu(&peer->pubkey_hash,
> -			   pubkey_bucket(table, peer->handshake.remote_static));
> -	mutex_unlock(&table->lock);
> +	memcpy(&peer->handshake.skey, &table->key, sizeof(table->key));
> +	WARN_ON(rhashtable_insert_fast(&table->hashtable, 
> &peer->pubkey_hash,
> +				       wg_peer_params));
>  }
> 
>  void wg_pubkey_hashtable_remove(struct pubkey_hashtable *table,
>  				struct wg_peer *peer)
>  {
> -	mutex_lock(&table->lock);
> -	hlist_del_init_rcu(&peer->pubkey_hash);
> -	mutex_unlock(&table->lock);
> +	memcpy(&peer->handshake.skey, &table->key, sizeof(table->key));
> +	rhashtable_remove_fast(&table->hashtable, &peer->pubkey_hash,
> +			       wg_peer_params);
>  }
> 
>  /* Returns a strong reference to a peer */
> @@ -54,41 +64,54 @@ struct wg_peer *
>  wg_pubkey_hashtable_lookup(struct pubkey_hashtable *table,
>  			   const u8 pubkey[NOISE_PUBLIC_KEY_LEN])
>  {
> -	struct wg_peer *iter_peer, *peer = NULL;
> +	struct wg_peer *peer = NULL;
> +	struct pubkey_pair pair;
> +
> +	memcpy(pair.key, pubkey, NOISE_PUBLIC_KEY_LEN);
> +	memcpy(&pair.skey, &table->key, sizeof(pair.skey));
> 
>  	rcu_read_lock_bh();
> -	hlist_for_each_entry_rcu_bh(iter_peer, pubkey_bucket(table, pubkey),
> -				    pubkey_hash) {
> -		if (!memcmp(pubkey, iter_peer->handshake.remote_static,
> -			    NOISE_PUBLIC_KEY_LEN)) {
> -			peer = iter_peer;
> -			break;
> -		}
> -	}
> -	peer = wg_peer_get_maybe_zero(peer);
> +	peer = 
> wg_peer_get_maybe_zero(rhashtable_lookup_fast(&table->hashtable,
> +							     &pair,
> +							     wg_peer_params));
>  	rcu_read_unlock_bh();
> +
>  	return peer;
>  }
> 
> -static struct hlist_head *index_bucket(struct index_hashtable *table,
> -				       const __le32 index)
> +void wg_pubkey_hashtable_destroy(struct pubkey_hashtable *table)
> +{
> +	WARN_ON(atomic_read(&table->hashtable.nelems));
> +	rhashtable_destroy(&table->hashtable);
> +}
> +
> +static u32 index_hash(const void *data, u32 len, u32 seed)
>  {
> +	const __le32 *index = data;
> +
>  	/* Since the indices are random and thus all bits are uniformly
> -	 * distributed, we can find its bucket simply by masking.
> +	 * distributed, we can use them as the hash value.
>  	 */
> -	return &table->hashtable[(__force u32)index &
> -				 (HASH_SIZE(table->hashtable) - 1)];
> +
> +	return (__force u32)*index;
>  }
> 
> -struct index_hashtable *wg_index_hashtable_alloc(void)
> +static const struct rhashtable_params index_entry_params = {
> +	.key_len = sizeof(__le32),
> +	.key_offset = offsetof(struct index_hashtable_entry, index),
> +	.head_offset = offsetof(struct index_hashtable_entry, index_hash),
> +	.hashfn = index_hash
> +};
> +
> +struct rhashtable *wg_index_hashtable_alloc(void)
>  {
> -	struct index_hashtable *table = kvmalloc(sizeof(*table), 
> GFP_KERNEL);
> +	struct rhashtable *table = kvmalloc(sizeof(*table), GFP_KERNEL);
> 
>  	if (!table)
>  		return NULL;
> 
> -	hash_init(table->hashtable);
> -	spin_lock_init(&table->lock);
> +	rhashtable_init(table, &index_entry_params);
> +
>  	return table;
>  }
> 
> @@ -116,111 +139,86 @@ struct index_hashtable 
> *wg_index_hashtable_alloc(void)
>   * is another thing to consider moving forward.
>   */
> 
> -__le32 wg_index_hashtable_insert(struct index_hashtable *table,
> +__le32 wg_index_hashtable_insert(struct rhashtable *table,
>  				 struct index_hashtable_entry *entry)
>  {
>  	struct index_hashtable_entry *existing_entry;
> 
> -	spin_lock_bh(&table->lock);
> -	hlist_del_init_rcu(&entry->index_hash);
> -	spin_unlock_bh(&table->lock);
> +	wg_index_hashtable_remove(table, entry);
> 
>  	rcu_read_lock_bh();
> 
>  search_unused_slot:
>  	/* First we try to find an unused slot, randomly, while unlocked. */
>  	entry->index = (__force __le32)get_random_u32();
> -	hlist_for_each_entry_rcu_bh(existing_entry,
> -				    index_bucket(table, entry->index),
> -				    index_hash) {
> -		if (existing_entry->index == entry->index)
> -			/* If it's already in use, we continue searching. */
> -			goto search_unused_slot;
> -	}
> 
> -	/* Once we've found an unused slot, we lock it, and then 
> double-check
> -	 * that nobody else stole it from us.
> -	 */
> -	spin_lock_bh(&table->lock);
> -	hlist_for_each_entry_rcu_bh(existing_entry,
> -				    index_bucket(table, entry->index),
> -				    index_hash) {
> -		if (existing_entry->index == entry->index) {
> -			spin_unlock_bh(&table->lock);
> -			/* If it was stolen, we start over. */
> -			goto search_unused_slot;
> -		}
> +	existing_entry = rhashtable_lookup_get_insert_fast(table,
> +							   &entry->index_hash,
> +							   index_entry_params);
> +
> +	if (existing_entry) {
> +		WARN_ON(IS_ERR(existing_entry));
> +
> +		/* If it's already in use, we continue searching. */
> +		goto search_unused_slot;
>  	}
> -	/* Otherwise, we know we have it exclusively (since we're locked),
> -	 * so we insert.
> -	 */
> -	hlist_add_head_rcu(&entry->index_hash,
> -			   index_bucket(table, entry->index));
> -	spin_unlock_bh(&table->lock);
> 
>  	rcu_read_unlock_bh();
> 
>  	return entry->index;
>  }
> 
> -bool wg_index_hashtable_replace(struct index_hashtable *table,
> +bool wg_index_hashtable_replace(struct rhashtable *table,
>  				struct index_hashtable_entry *old,
>  				struct index_hashtable_entry *new)
>  {
> -	bool ret;
> +	int ret = rhashtable_replace_fast(table, &old->index_hash,
> +					  &new->index_hash,
> +					  index_entry_params);
> 
> -	spin_lock_bh(&table->lock);
> -	ret = !hlist_unhashed(&old->index_hash);
> -	if (unlikely(!ret))
> -		goto out;
> +	WARN_ON(ret == -EINVAL);
> 
> -	new->index = old->index;
> -	hlist_replace_rcu(&old->index_hash, &new->index_hash);
> -
> -	/* Calling init here NULLs out index_hash, and in fact after this
> -	 * function returns, it's theoretically possible for this to get
> -	 * reinserted elsewhere. That means the RCU lookup below might 
> either
> -	 * terminate early or jump between buckets, in which case the packet
> -	 * simply gets dropped, which isn't terrible.
> -	 */
> -	INIT_HLIST_NODE(&old->index_hash);
> -out:
> -	spin_unlock_bh(&table->lock);
> -	return ret;
> +	return ret != -ENOENT;
>  }
> 
> -void wg_index_hashtable_remove(struct index_hashtable *table,
> +void wg_index_hashtable_remove(struct rhashtable *table,
>  			       struct index_hashtable_entry *entry)
>  {
> -	spin_lock_bh(&table->lock);
> -	hlist_del_init_rcu(&entry->index_hash);
> -	spin_unlock_bh(&table->lock);
> +	rhashtable_remove_fast(table, &entry->index_hash, 
> index_entry_params);
>  }
> 
>  /* Returns a strong reference to a entry->peer */
>  struct index_hashtable_entry *
> -wg_index_hashtable_lookup(struct index_hashtable *table,
> +wg_index_hashtable_lookup(struct rhashtable *table,
>  			  const enum index_hashtable_type type_mask,
>  			  const __le32 index, struct wg_peer **peer)
>  {
> -	struct index_hashtable_entry *iter_entry, *entry = NULL;
> +	struct index_hashtable_entry *entry = NULL;
> 
>  	rcu_read_lock_bh();
> -	hlist_for_each_entry_rcu_bh(iter_entry, index_bucket(table, index),
> -				    index_hash) {
> -		if (iter_entry->index == index) {
> -			if (likely(iter_entry->type & type_mask))
> -				entry = iter_entry;
> -			break;
> -		}
> -	}
> +	entry = rhashtable_lookup_fast(table, &index, index_entry_params);
> +
>  	if (likely(entry)) {
> +		if (unlikely(!(entry->type & type_mask))) {
> +			entry = NULL;
> +			goto out;
> +		}
> +
>  		entry->peer = wg_peer_get_maybe_zero(entry->peer);
>  		if (likely(entry->peer))
>  			*peer = entry->peer;
>  		else
>  			entry = NULL;
>  	}
> +
> +out:
>  	rcu_read_unlock_bh();
> +
>  	return entry;
>  }
> +
> +void wg_index_hashtable_destroy(struct rhashtable *table)
> +{
> +	WARN_ON(atomic_read(&table->nelems));
> +	rhashtable_destroy(table);
> +}
> diff --git a/drivers/net/wireguard/peerlookup.h 
> b/drivers/net/wireguard/peerlookup.h
> index ced811797680..a3cef26cb733 100644
> --- a/drivers/net/wireguard/peerlookup.h
> +++ b/drivers/net/wireguard/peerlookup.h
> @@ -8,17 +8,14 @@
> 
>  #include "messages.h"
> 
> -#include <linux/hashtable.h>
> -#include <linux/mutex.h>
> +#include <linux/rhashtable.h>
>  #include <linux/siphash.h>
> 
>  struct wg_peer;
> 
>  struct pubkey_hashtable {
> -	/* TODO: move to rhashtable */
> -	DECLARE_HASHTABLE(hashtable, 11);
> +	struct rhashtable hashtable;
>  	siphash_key_t key;
> -	struct mutex lock;
>  };
> 
>  struct pubkey_hashtable *wg_pubkey_hashtable_alloc(void);
> @@ -29,12 +26,7 @@ void wg_pubkey_hashtable_remove(struct 
> pubkey_hashtable *table,
>  struct wg_peer *
>  wg_pubkey_hashtable_lookup(struct pubkey_hashtable *table,
>  			   const u8 pubkey[NOISE_PUBLIC_KEY_LEN]);
> -
> -struct index_hashtable {
> -	/* TODO: move to rhashtable */
> -	DECLARE_HASHTABLE(hashtable, 13);
> -	spinlock_t lock;
> -};
> +void wg_pubkey_hashtable_destroy(struct pubkey_hashtable *table);
> 
>  enum index_hashtable_type {
>  	INDEX_HASHTABLE_HANDSHAKE = 1U << 0,
> @@ -43,22 +35,23 @@ enum index_hashtable_type {
> 
>  struct index_hashtable_entry {
>  	struct wg_peer *peer;
> -	struct hlist_node index_hash;
> +	struct rhash_head index_hash;
>  	enum index_hashtable_type type;
>  	__le32 index;
>  };
> 
> -struct index_hashtable *wg_index_hashtable_alloc(void);
> -__le32 wg_index_hashtable_insert(struct index_hashtable *table,
> +struct rhashtable *wg_index_hashtable_alloc(void);
> +__le32 wg_index_hashtable_insert(struct rhashtable *table,
>  				 struct index_hashtable_entry *entry);
> -bool wg_index_hashtable_replace(struct index_hashtable *table,
> +bool wg_index_hashtable_replace(struct rhashtable *table,
>  				struct index_hashtable_entry *old,
>  				struct index_hashtable_entry *new);
> -void wg_index_hashtable_remove(struct index_hashtable *table,
> +void wg_index_hashtable_remove(struct rhashtable *table,
>  			       struct index_hashtable_entry *entry);
>  struct index_hashtable_entry *
> -wg_index_hashtable_lookup(struct index_hashtable *table,
> +wg_index_hashtable_lookup(struct rhashtable *table,
>  			  const enum index_hashtable_type type_mask,
>  			  const __le32 index, struct wg_peer **peer);
> +void wg_index_hashtable_destroy(struct rhashtable *table);
> 
>  #endif /* _WG_PEERLOOKUP_H */
> --
> 2.32.0
> 


