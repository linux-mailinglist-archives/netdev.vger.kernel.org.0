Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6796DE9EC
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 05:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjDLDnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 23:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjDLDnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 23:43:12 -0400
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE35330E0;
        Tue, 11 Apr 2023 20:43:08 -0700 (PDT)
X-UUID: 693af808dc5e42e1ae0f3d1d1158a962-20230412
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.22,REQID:65187268-a439-4443-96c4-6411741543ce,IP:10,
        URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-9,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:1
X-CID-INFO: VERSION:1.1.22,REQID:65187268-a439-4443-96c4-6411741543ce,IP:10,UR
        L:0,TC:0,Content:0,EDM:0,RT:0,SF:-9,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:1
X-CID-META: VersionHash:120426c,CLOUDID:37d008a1-8fcb-430b-954a-ba3f00fa94a5,B
        ulkID:230412114258BBTF78PU,BulkQuantity:0,Recheck:0,SF:24|17|19|45|102,TC:
        nil,Content:1,EDM:-3,IP:-2,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OS
        I:0,OSA:0,AV:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-UUID: 693af808dc5e42e1ae0f3d1d1158a962-20230412
X-User: sujing@kylinos.cn
Received: from [172.30.110.63] [(210.12.40.82)] by mailgw
        (envelope-from <sujing@kylinos.cn>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES128-GCM-SHA256 128/128)
        with ESMTP id 497150684; Wed, 12 Apr 2023 11:42:56 +0800
Message-ID: <a94798cc-26d1-a97a-2425-89de9ca43df3@kylinos.cn>
Date:   Wed, 12 Apr 2023 11:42:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: Re: [PATCH] net: bonding: avoid use-after-free with
 tx_hashtbl/rx_hashtbl
Content-Language: en-US
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230328034037.2076930-1-sujing@kylinos.cn>
 <23772.1679978284@famine>
From:   sujing <sujing@kylinos.cn>
In-Reply-To: <23772.1679978284@famine>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you so much for your reply!

  I see there are mainly 5 questions about my patch.
  Before answering your questions, let me provide more detailed
information about this issue.

In bonding mode 6, I encounter 3 crashes on ft2000+/64(arm64) server
with kernel 4.19.90 (the issue still exists in the latest version).
Crashes only occur when closing process preempts the lock before TX/RX,
the call traces are as follow:

Call trace 1 : TX vs. close
[21406.614627] tlb_choose_channel+0x5c/0x188 [bonding]
[21406.620009] bond_alb_xmit+0x1fc/0x5b8 [bonding]
[21406.625043] bond_start_xmit+0xf8/0x4c0 [bonding]
[21406.630162] dev_hard_start_xmit+0xac/0x258
[21406.634759] __dev_queue_xmit+0x754/0x940
[21406.639182] dev_queue_xmit+0x24/0x30
[21406.643261] ip_finish_output2+0x23c/0x3e8
[21406.647771] ip_finish_output+0x1c8/0x2a8
[21406.652194] ip_output+0x9c/0x100
[21406.655924] ip_local_out+0x58/0x68
[21406.659829] __ip_queue_xmit+0x12c/0x368
[21406.664167] ip_queue_xmit+0x10/0x18
[21406.668158] __tcp_transmit_skb+0x4f8/0xab8
[21406.672754] tcp_write_xmit+0x23c/0xf78

Timeline 1:
tlb_deinitialize ------------------ bond_start_xmit
spin_lock_bh ---------------------- bond_alb_xmit
tx_hashtbl = NULL ----------------- tlb_choose_channel
spin_unlock_bh -------------------- //wait
----------------------------------- spin_lock_bh
----------------------------------- __tlb_choose_channel
----------------------------------- tx_hashtbl[hash_index].tx_slave
----------------------------------- spin_unlock_bh

  Call trace 2 : RX vs. close
[ 76.809874] Call trace:
[ 76.810317] rlb_arp_recv+0x218/0x2f0 [bonding]
[ 76.811070] bond_handle_frame+0x58/0x270 [bonding]
[ 76.811905] __netif_receive_skb_core+0x2d4/0xd90
[ 76.812683] __netif_receive_skb_one_core+0x38/0x68
[ 76.813477] __netif_receive_skb+0x28/0x80
[ 76.814156] netif_receive_skb_internal+0x3c/0xa8
[ 76.814929] napi_gro_receive+0xf8/0x170
[ 76.815594] receive_buf+0xec/0xa08 [virtio_net]
[ 76.816353] virtnet_poll+0x144/0x310 [virtio_net]
[ 76.817134] net_rx_action+0x158/0x3a0

Timeline 2:
rlb_deinitialize ------------------ bond_handle_frame
spin_lock_bh ---------------------- rlb_arp_recv
rx_hashtbl = NULL ----------------- rlb_update_entry_from_arp
spin_unlock_bh -------------------- //wait
----------------------------------- spin_lock_bh
----------------------------------- rx_hashtbl[hash_index].assigned
----------------------------------- spin_unlock_bh

  Call trace 3 : TX vs. close
[ 144.146818] Call trace:
[ 144.147256] rlb_choose_channel+0x84/0x2e8 [bonding]
[ 144.148067] bond_alb_xmit+0x2d0/0x5b8 [bonding]
[ 144.148820] bond_start_xmit+0x4e8/0x4f0 [bonding]
[ 144.149649] dev_hard_start_xmit+0xac/0x258
[ 144.150335] __dev_queue_xmit+0x754/0x940
[ 144.150994] dev_queue_xmit+0x24/0x30
[ 144.151616] arp_xmit+0x24/0x90
[ 144.152148] arp_send_dst.part.3+0xb4/0xf0
[ 144.152820] arp_solicit+0x1ac/0x260
[ 144.153416] neigh_probe+0x64/0x88
[ 144.153986] __neigh_event_send+0x124/0x340
[ 144.154671] neigh_resolve_output+0x124/0x200
[ 144.155383] ip_finish_output2+0x138/0x3e8
[ 144.156055] ip_finish_output+0x1c8/0x2a8
[ 144.156720] ip_output+0x9c/0x100
[ 144.157276] ip_local_out+0x58/0x68
[ 144.157860] ip_send_skb+0x2c/0x80

Timeline 3:
tlb_deinitialize ------------------ bond_start_xmit
spin_lock_bh ---------------------- bond_alb_xmit
tx_hashtbl = NULL ----------------- rlb_arp_xmit
spin_unlock_bh -------------------- rlb_choose_channel
----------------------------------- spin_lock_bh
----------------------------------- rx_hashtbl[hash_index].assigned
----------------------------------- spin_unlock_bh

To solve the crashes above, the initial idea is to check whether
tx_hashtbl/rx_hashtbl is NULL before operating it ,
and then add some exception handling process.

In bonding driver, there is only one tx_hashtbl operation (in
'__tlb_choose_channel()'), TLB is easy to solve.
But there are so many rx_hashtbl operations that also aren't
checked whether the pointer is NULL.
It may cause other use-after-free while closing.

I am worried that the initial idea can't solve crash issues under other
uncertain race conditions, and it maybe affecting the normal process.

Besides, I think it is unnecessary to free and reallocate
TLB / RLB hash table every-time the bond device is down/up.
Therefore it should be allocated and freed once in
'bond_init()/bond_uninit()'.

Since we can't control whether upper level sends packets or not,
I think the best idea is to make sure tx_hashtbl/rx_hashtbl pointer will
not be set to NULL during the closing process.

Therefore, move 'bond_alb_deinitialize()' from 'bond_close()' to
'bond_uninit()', move 'bond_alb_initialize()' from 'bond_open()'
to 'bond_init()'.

So it becomes as below:
                                     enter(insmod)
bond_init------------------bond_init------------
bond_open------------------bond_alb_initialize--
bond_alb_initialize---==>--tlb_initialize-------
tlb_initialize-------------rlb_initialize-------
rlb_initialize-------------bond_open------------
                                     exit(rmmod)
bond_close-----------------bond_close-----------
bond_alb_deinitialize------bond_uninit----------
tlb_deinitialize------==>--bond_alb_deinitialize
rlb_deinitialize-----------tlb_deinitialize-----
bond_uninit----------------rlb_deinitialize-----

The original initialization is:
if (bond_is_lb(bond))
      bond_alb_initialize(bond, (BOND_MODE(bond) == BOND_MODE_ALB));
         -> tlb_initialize(bond);
         -> if (rlb_enabled)
                   rlb_initialize(bond);
bond_is_lb()
      -> return BOND_MODE(bond) == BOND_MODE_TLB ||
                        BOND_MODE(bond) == BOND_MODE_ALB;
rlb_enabled == (BOND_MODE(bond) == BOND_MODE_ALB);

The original de-initialization is:
if (bond_is_lb(bond))
      bond_alb_deinitialize(bond);
         -> tlb_deinitialize(bond);
         -> if (bond_info->rlb_enabled)
                    rlb_deinitialize(bond);


However, 'BOND_MODE(bond)' is set only after 'bond_init()', meaning that
there's no way to judge the bond device's mode in 'bond_init()'.
I haven't come up with any better idea, so I decide to set up / tear down
the TLB / RLB hash table even when they won't be used.

So the initialization changes to:
bond_alb_initialize(bond);
            -> tlb_initialize(bond);
            -> rlb_initialize(bond);

As well as the de initialization:
bond_alb_deinitialize(bond);
            -> tlb_deinitialize(bond);
            -> rlb_deinitialize(bond);

  Since the main points is the movement of applying and releasing
hash-table memory, the rest in 'bond_close() bond_open()' are keep in
original places.

  In order to make sure each time the status is clean, 'bond_open()'
should clear the TLB / RLB hash table before used.

The answers to your questions in the previous email are below.


On 2023/3/28 12:38, Jay Vosburgh wrote:
> sujing <sujing@kylinos.cn> wrote:
>
>> In bonding mode 6 (Balance-alb),
>> there are some potential race conditions between the 'bond_close' process
>> and the tx/rx processes that use tx_hashtbl/rx_hashtbl,
>> which may lead to use-after-free.
>>
>> For instance, when the bond6 device is in the 'bond_close' process
>> while some backlogged packets from upper level are transmitted
>> to 'bond_start_xmit', there is a spinlock contention between
>> 'tlb_deinitialize' and 'tlb_choose_channel'.
>>
>> If 'tlb_deinitialize' preempts the lock before 'tlb_choose_channel',
>> a NULL pointer kernel panic will be triggered.
>>
>> Here's the timeline:
>>
>> bond_close  ------------------  bond_start_xmit
>> bond_alb_deinitialize  -------  __bond_start_xmit
>> tlb_deinitialize  ------------  bond_alb_xmit
>> spin_lock_bh  ----------------  bond_xmit_alb_slave_get
>> tx_hashtbl = NULL  -----------  tlb_choose_channel
>> spin_unlock_bh  --------------  //wait for spin_lock_bh
>> ------------------------------  spin_lock_bh
>> ------------------------------  __tlb_choose_channel
>> causing kernel panic ========>  tx_hashtbl[hash_index].tx_slave
>> ------------------------------  spin_unlock_bh
> 	I'm still thinking on the race here, but have some questions
> below about the implementation in the meantime.
>
>> Signed-off-by: sujing <sujing@kylinos.cn>
>> ---
>> drivers/net/bonding/bond_alb.c  | 32 +++++++++------------------
>> drivers/net/bonding/bond_main.c | 39 +++++++++++++++++++++++++++------
>> include/net/bond_alb.h          |  5 ++++-
>> 3 files changed, 46 insertions(+), 30 deletions(-)
>>
>> diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
>> index b9dbad3a8af8..f6ff5ea835c4 100644
>> --- a/drivers/net/bonding/bond_alb.c
>> +++ b/drivers/net/bonding/bond_alb.c
>> @@ -71,7 +71,7 @@ static inline u8 _simple_hash(const u8 *hash_start, int hash_size)
>>
>> /*********************** tlb specific functions ***************************/
>>
>> -static inline void tlb_init_table_entry(struct tlb_client_info *entry, int save_load)
>> +void tlb_init_table_entry(struct tlb_client_info *entry, int save_load)
>> {
>> 	if (save_load) {
>> 		entry->load_history = 1 + entry->tx_bytes /
>> @@ -269,8 +269,8 @@ static void rlb_update_entry_from_arp(struct bonding *bond, struct arp_pkt *arp)
>> 	spin_unlock_bh(&bond->mode_lock);
>> }
>>
>> -static int rlb_arp_recv(const struct sk_buff *skb, struct bonding *bond,
>> -			struct slave *slave)
>> +int rlb_arp_recv(const struct sk_buff *skb, struct bonding *bond,
>> +		 struct slave *slave)
>> {
>> 	struct arp_pkt *arp, _arp;
>>
>> @@ -756,7 +756,7 @@ static void rlb_init_table_entry_src(struct rlb_client_info *entry)
>> 	entry->src_next = RLB_NULL_INDEX;
>> }
>>
>> -static void rlb_init_table_entry(struct rlb_client_info *entry)
>> +void rlb_init_table_entry(struct rlb_client_info *entry)
>> {
>> 	memset(entry, 0, sizeof(struct rlb_client_info));
>> 	rlb_init_table_entry_dst(entry);
>> @@ -874,9 +874,6 @@ static int rlb_initialize(struct bonding *bond)
>>
>> 	spin_unlock_bh(&bond->mode_lock);
>>
>> -	/* register to receive ARPs */
>> -	bond->recv_probe = rlb_arp_recv;
>> -
>> 	return 0;
>> }
>>
>> @@ -888,7 +885,6 @@ static void rlb_deinitialize(struct bonding *bond)
>>
>> 	kfree(bond_info->rx_hashtbl);
>> 	bond_info->rx_hashtbl = NULL;
>> -	bond_info->rx_hashtbl_used_head = RLB_NULL_INDEX;
> 	Why remove this line?

The idea is moving 'rlb_deinitialize()' from 'bond_close()' process to
'bond_uninit()' process, so there's no need to reset rx_hashtbl_used_head's
value while exiting the driver.

>> 	spin_unlock_bh(&bond->mode_lock);
>> }
>> @@ -1303,7 +1299,7 @@ static bool alb_determine_nd(struct sk_buff *skb, struct bonding *bond)
>>
>> /************************ exported alb functions ************************/
>>
>> -int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
>> +int bond_alb_initialize(struct bonding *bond)
>> {
>> 	int res;
>>
>> @@ -1311,15 +1307,10 @@ int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
>> 	if (res)
>> 		return res;
>>
>> -	if (rlb_enabled) {
>> -		res = rlb_initialize(bond);
>> -		if (res) {
>> -			tlb_deinitialize(bond);
>> -			return res;
>> -		}
>> -		bond->alb_info.rlb_enabled = 1;
>> -	} else {
>> -		bond->alb_info.rlb_enabled = 0;
>> +	res = rlb_initialize(bond);
>> +	if (res) {
>> +		tlb_deinitialize(bond);
>> +		return res;
>> 	}
>>
>> 	return 0;
>> @@ -1327,12 +1318,9 @@ int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
>>
>> void bond_alb_deinitialize(struct bonding *bond)
>> {
>> -	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
>> -
>> 	tlb_deinitialize(bond);
>>
>> -	if (bond_info->rlb_enabled)
>> -		rlb_deinitialize(bond);
>> +	rlb_deinitialize(bond);
> 	Why is rlb_deinitialize() now unconditionally called here and in
> bond_alb_initialize()?  if rlb_enabled is false, why set up / tear down
> the RLB hash table that won't be used?

There may be some misunderstanding. 'rlb_deinitialize()' and
'tlb_deinitialize()'  are now called in 'bond_alb_deinitialize()'.

As for the next question, I explain it in the beginning, there's no way to
judge the bond device's mode in 'bond_init()'.
I haven't come up with a better way.

>> }
>>
>> static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>> index 236e5219c811..8fcb5d3ac0a2 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -4217,6 +4217,7 @@ static int bond_open(struct net_device *bond_dev)
>> 	struct bonding *bond = netdev_priv(bond_dev);
>> 	struct list_head *iter;
>> 	struct slave *slave;
>> +	int i;
>>
>> 	if (BOND_MODE(bond) == BOND_MODE_ROUNDROBIN && !bond->rr_tx_counter) {
>> 		bond->rr_tx_counter = alloc_percpu(u32);
>> @@ -4239,11 +4240,29 @@ static int bond_open(struct net_device *bond_dev)
>> 	}
>>
>> 	if (bond_is_lb(bond)) {
>> -		/* bond_alb_initialize must be called before the timer
>> -		 * is started.
>> -		 */
>> -		if (bond_alb_initialize(bond, (BOND_MODE(bond) == BOND_MODE_ALB)))
>> -			return -ENOMEM;
>> +		struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
>> +
>> +		spin_lock_bh(&bond->mode_lock);
>> +
>> +		for (i = 0; i < TLB_HASH_TABLE_SIZE; i++)
>> +			tlb_init_table_entry(&bond_info->tx_hashtbl[i], 0);
>> +
>> +		spin_unlock_bh(&bond->mode_lock);
>> +
>> +		if (BOND_MODE(bond) == BOND_MODE_ALB) {
>> +			bond->alb_info.rlb_enabled = 1;
>> +			spin_lock_bh(&bond->mode_lock);
>> +
>> +			bond_info->rx_hashtbl_used_head = RLB_NULL_INDEX;
>> +			for (i = 0; i < RLB_HASH_TABLE_SIZE; i++)
>> +				rlb_init_table_entry(bond_info->rx_hashtbl + i);
>> +
>> +			spin_unlock_bh(&bond->mode_lock);
>> +			bond->recv_probe = rlb_arp_recv;
>> +		} else {
>> +			bond->alb_info.rlb_enabled = 0;
>> +		}
>> +
> 	Why is all of the above done directly in bond_open() and not in
> bond_alb.c somewhere?  That would reduce some churn (changing some
> functions away from static).
>
> 	Also, I see that bond_alb_initialize() is now called from
> bond_init() instead of bond_open(), and it only calls rlb_initialize().
> However, this now duplicates most of the functionality of
> rlb_initialize() and tlb_initialize() here.  Why?
>
> 	In general, the described race is TX vs. close processing, so
> why is there so much change to the open processing?
>
> 	-J

For the record, 'bond_alb_initialize()' now calls both 'rlb_initialize()'
and 'tlb_initialize()'.

You're right. There are two points that need to be improved.

point 1: create 2 new functions 'rlb_hash_initialize()' and
'tlb_hash_initialize()' in bond_alb.c, make them do all of the above.
The plan is as follow:
***************************************
bond_open() in bond_main.c:
if (bond_is_lb(bond)) {
      tlb_hash_initialize(bond);
      if (BOND_MODE(bond) == BOND_MODE_ALB) {
           bond->alb_info.rlb_enabled = 1;
           rlb_hash_initialize(bond);
           bond->recv_probe = rlb_arp_recv;
      } else
           bond->alb_info.rlb_enabled = 0;
}

tlb_hash_initialize() in bond_alb.c:
spin_lock_bh();
for (i)
      tlb_init_table_entry();
spin_unlock_bh();

rlb_hash_initialize() in bond_alb.c:
spin_lock_bh();
rx_hashtbl_used_head = RLB_NULL_INDEX;
for (i)
      rlb_init_table_entry();
spin_unlock_bh();

***************************************

point 2: delete the 'rlb_init_table_entry()' in 'rlb_initialize()' and
'tlb_init_table_entry()' in 'tlb_initialize()', there shouldn't double
the operations.

The key-point is avoiding TLB/RLB hash table is set to NULL while closing.
As for the last question, I think this issue due to timeline between
close processing and TLB / RLB operating.

If all these resetting operations are in 'bond_close()' instead of
'bond_open()', there still exist the same race conditions.

For example:
bond_close------------bond_start_xmit
spin_lock_bh----------bond_alb_xmit
tlb_init_table_entry--tlb_choose_channel
spin_unlock_bh--------//wait for lock
----------------------spin_lock_bh
----------------------tx_hashtbl[hash_index].tx_slave
----------------------spin_unlock_bh

If 'bond_close()' preempts the lock before TX, it won't be able to choose
the correct tx_slave in 'tlb_choose_channel()'.

However, if all these are in 'bond_open()', when the same race conditions
happen, TX can still work normally.


  Looking forward to your opinion on my reply!

-sujing

>> 		if (bond->params.tlb_dynamic_lb || BOND_MODE(bond) == BOND_MODE_ALB)
>> 			queue_delayed_work(bond->wq, &bond->alb_work, 0);
>> 	}
>> @@ -4279,8 +4298,6 @@ static int bond_close(struct net_device *bond_dev)
>>
>> 	bond_work_cancel_all(bond);
>> 	bond->send_peer_notif = 0;
>> -	if (bond_is_lb(bond))
>> -		bond_alb_deinitialize(bond);
>> 	bond->recv_probe = NULL;
>>
>> 	if (bond_uses_primary(bond)) {
>> @@ -5854,6 +5871,8 @@ static void bond_uninit(struct net_device *bond_dev)
>> 	struct list_head *iter;
>> 	struct slave *slave;
>>
>> +	bond_alb_deinitialize(bond);
>> +
>> 	bond_netpoll_cleanup(bond_dev);
>>
>> 	/* Release the bonded slaves */
>> @@ -6295,6 +6314,12 @@ static int bond_init(struct net_device *bond_dev)
>> 	    bond_dev->addr_assign_type == NET_ADDR_PERM)
>> 		eth_hw_addr_random(bond_dev);
>>
>> +	/* bond_alb_initialize must be called before the timer
>> +	 * is started.
>> +	 */
>> +	if (bond_alb_initialize(bond))
>> +		return -ENOMEM;
>> +
>> 	return 0;
>> }
>>
>> diff --git a/include/net/bond_alb.h b/include/net/bond_alb.h
>> index 9dc082b2d543..9fd16e20ef82 100644
>> --- a/include/net/bond_alb.h
>> +++ b/include/net/bond_alb.h
>> @@ -150,7 +150,7 @@ struct alb_bond_info {
>> 						 */
>> };
>>
>> -int bond_alb_initialize(struct bonding *bond, int rlb_enabled);
>> +int bond_alb_initialize(struct bonding *bond);
>> void bond_alb_deinitialize(struct bonding *bond);
>> int bond_alb_init_slave(struct bonding *bond, struct slave *slave);
>> void bond_alb_deinit_slave(struct bonding *bond, struct slave *slave);
>> @@ -165,5 +165,8 @@ struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
>> void bond_alb_monitor(struct work_struct *);
>> int bond_alb_set_mac_address(struct net_device *bond_dev, void *addr);
>> void bond_alb_clear_vlan(struct bonding *bond, unsigned short vlan_id);
>> +int rlb_arp_recv(const struct sk_buff *skb, struct bonding *bond, struct slave *slave);
>> +void tlb_init_table_entry(struct tlb_client_info *entry, int save_load);
>> +void rlb_init_table_entry(struct rlb_client_info *entry);
>> #endif /* _NET_BOND_ALB_H */
>>
>> -- 
>> 2.27.0
>>
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
---
                     -sujing    <sujing@kyinos.cn>
