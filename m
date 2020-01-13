Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 429E413979C
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 18:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgAMRZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 12:25:33 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:53833 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728621AbgAMRZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 12:25:33 -0500
Received: from webmail.gandi.net (webmail23.sd4.0x35.net [10.200.201.23])
        (Authenticated sender: cengiz@kernel.wtf)
        by relay12.mail.gandi.net (Postfix) with ESMTPA id D6B36200008;
        Mon, 13 Jan 2020 17:25:29 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 13 Jan 2020 20:25:29 +0300
From:   Cengiz Can <cengiz@kernel.wtf>
To:     Alex Vesker <valex@mellanox.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mellanox: prevent resource leak on htbl
In-Reply-To: <HE1PR0501MB22490CD10A5A258E8C08DE86C3350@HE1PR0501MB2249.eurprd05.prod.outlook.com>
References: <20200113134415.86110-1-cengiz@kernel.wtf>
 <HE1PR0501MB22490CD10A5A258E8C08DE86C3350@HE1PR0501MB2249.eurprd05.prod.outlook.com>
Message-ID: <69daf825678a38b676602933303190c9@kernel.wtf>
X-Sender: cengiz@kernel.wtf
User-Agent: Roundcube Webmail/1.3.8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-13 17:49, Alex Vesker wrote:
> On 1/13/2020 3:46 PM, Cengiz Can wrote:
>> According to a Coverity static analysis tool,
>> `drivers/net/mellanox/mlx5/core/steering/dr_rule.c#63` leaks a
>> `struct mlx5dr_ste_htbl *` named `new_htbl` while returning from
>> `dr_rule_create_collision_htbl` function.
>> 
>> A annotated snippet of the possible resource leak follows:
>> 
>> ```
>> static struct mlx5dr_ste *
>> dr_rule_create_collision_htbl(struct mlx5dr_matcher *matcher,
>>                               struct mlx5dr_matcher_rx_tx 
>> *nic_matcher,
>>                               u8 *hw_ste)
>>    /* ... */
>>    /* ... */
>> 
>>    /* Storage is returned from allocation function 
>> mlx5dr_ste_htbl_alloc. */
>>    /* Assigning: new_htbl = storage returned from 
>> mlx5dr_ste_htbl_alloc(..) */
>>         new_htbl = mlx5dr_ste_htbl_alloc(dmn->ste_icm_pool,
>>                                          DR_CHUNK_SIZE_1,
>>                                          MLX5DR_STE_LU_TYPE_DONT_CARE,
>>                                          0);
>>    /* Condition !new_htbl, taking false branch. */
>>         if (!new_htbl) {
>>                 mlx5dr_dbg(dmn, "Failed allocating collision 
>> table\n");
>>                 return NULL;
>>         }
>> 
>>         /* One and only entry, never grows */
>>         ste = new_htbl->ste_arr;
>>         mlx5dr_ste_set_miss_addr(hw_ste, 
>> nic_matcher->e_anchor->chunk->icm_addr);
>>    /* Resource new_htbl is not freed or pointed-to in mlx5dr_htbl_get 
>> */
>>         mlx5dr_htbl_get(new_htbl);
>> 
>>    /* Variable new_htbl going out of scope leaks the storage it points 
>> to. */
>>         return ste;
>> ```
>> 
>> There's a caller of this function which does refcounting and free'ing 
>> by
>> itself but that function also skips free'ing `new_htbl` due to missing
>> jump to error label. (referring to `dr_rule_create_collision_entry 
>> lines
>> 75-77. They don't jump to `free_tbl`)
>> 
>> Added a `kfree(new_htbl)` just before returning `ste` pointer to fix 
>> the
>> leak.
>> 
>> Signed-off-by: Cengiz Can <cengiz@kernel.wtf>
>> ---
>> 
>> This might be totally breaking the refcounting logic in the file so
>> please provide any feedback so I can evolve this into something more
>> suitable.
>> 
>> For the record, Coverity scan id is CID 1457773.
>> 
>>  drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c | 2 ++
>>  1 file changed, 2 insertions(+)
>> 
>> diff --git 
>> a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c 
>> b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
>> index e4cff7abb348..047b403c61db 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
>> @@ -60,6 +60,8 @@ dr_rule_create_collision_htbl(struct mlx5dr_matcher 
>> *matcher,
>>  	mlx5dr_ste_set_miss_addr(hw_ste, 
>> nic_matcher->e_anchor->chunk->icm_addr);
>>  	mlx5dr_htbl_get(new_htbl);
>> 
>> +	kfree(new_htbl);
>> +
>>  	return ste;
>>  }
>> 
>> --
>> 2.24.1
>> 
>> 
> The fix looks incorrect to me.
> The table is pointed by each ste in the ste_arr, ste->new_htbl and 
> being
> freed on mlx5dr_htbl_put.
> We tested kmemleak a few days ago and came clean.
> usually coverity is not wrong, but in this case I don't see the bug...

Hello Alex,

To my experience, the refcounting logic is complex and spread out to 
multiple files.

It might be a false positive on Coverity's side.

If it certainly sounds wrong, we can ignore this.

Thanks

-- 
Cengiz Can
@cengiz_io
