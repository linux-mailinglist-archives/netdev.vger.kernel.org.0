Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF5B260E3D
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 10:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbgIHI74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 04:59:56 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5959 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgIHI7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 04:59:55 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5747850000>; Tue, 08 Sep 2020 01:57:41 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 08 Sep 2020 01:59:55 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 08 Sep 2020 01:59:55 -0700
Received: from [172.27.14.146] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 8 Sep
 2020 08:59:45 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [net-next 09/10] net/mlx5e: Move TX code into functions to be
 used by MPWQE
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
References: <20200903210022.22774-1-saeedm@nvidia.com>
 <20200903210022.22774-10-saeedm@nvidia.com>
 <CA+FuTSdoUHM=8Z1FQ8L_eOGwKyzQyO3PD-FHvsf2Q0wBOJ9X7Q@mail.gmail.com>
Message-ID: <3cadeba3-bf14-428a-5783-9b8ec547f716@nvidia.com>
Date:   Tue, 8 Sep 2020 11:59:42 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSdoUHM=8Z1FQ8L_eOGwKyzQyO3PD-FHvsf2Q0wBOJ9X7Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599555461; bh=UZxpMRl+gJaHheXqcEbYZW2HRvnqBSzcUhO21tEdmXE=;
        h=X-PGP-Universal:From:Subject:To:CC:References:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=NOFxtlsHcHOMp9ZdQTtM31Ht6d9yv1p4w/2mc7Sf1ZJP6TsXGlD86cOePFA22HetB
         aMl/9yepJBunzIrd4/bFh2AFAJx5hflQEgCc7ywuIBvcMlATtexKiHBx8zloemutAu
         hIBnmYuGvPXYvM5NagGNoLkORzngebsM7jFSUtee2/f5bQ4nSZOl+Gwo+oejog6wYN
         0I14GfCvwW2cy/at7d4yNZ9Lr2TMPqFYaHgHs6n1JWCB2/tpiuiR4rqm2t2Qs2l5Mt
         QavA26DIKNh94ybZagT1nDbwSuCmcUYtON3A9c8rPs92LdVXR1iFCXC6KExgfe0/1g
         V1v84QoTmMKHQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-04 18:06, Willem de Bruijn wrote:
> On Thu, Sep 3, 2020 at 11:01 PM Saeed Mahameed <saeedm@nvidia.com> wrote:
>>
>> From: Maxim Mikityanskiy <maximmi@mellanox.com>
>>
>> mlx5e_txwqe_complete performs some actions that can be taken to separate
>> functions:
>>
>> 1. Update the flags needed for hardware timestamping.
>>
>> 2. Stop the TX queue if it's full.
>>
>> Take these actions into separate functions to be reused by the MPWQE
>> code in the following commit and to maintain clear responsibilities of
>> functions.
>>
>> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
>> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>> ---
>>   .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 23 ++++++++++++++-----
>>   1 file changed, 17 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
>> index 9ced350150b3..3b68c8333875 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
>> @@ -311,6 +311,20 @@ static inline void mlx5e_sq_calc_wqe_attr(struct sk_buff *skb,
>>          };
>>   }
>>
>> +static inline void mlx5e_tx_skb_update_hwts_flags(struct sk_buff *skb)
>> +{
>> +       if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
>> +               skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
>> +}
> 
> Subjective, but this helper adds a level of indirection and introduces
> code churn without simplying anything, imho.

It's added for the sake of being reused in non-MPWQE and MPWQE flows.

>> +static inline void mlx5e_tx_check_stop(struct mlx5e_txqsq *sq)
>> +{
>> +       if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, sq->stop_room))) {
>> +               netif_tx_stop_queue(sq->txq);
>> +               sq->stats->stopped++;
>> +       }
>> +}
>> +
>>   static inline void
>>   mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
>>                       const struct mlx5e_tx_attr *attr,
>> @@ -332,14 +346,11 @@ mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
>>          cseg->opmod_idx_opcode = cpu_to_be32((sq->pc << 8) | attr->opcode);
>>          cseg->qpn_ds           = cpu_to_be32((sq->sqn << 8) | wqe_attr->ds_cnt);
>>
>> -       if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
>> -               skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
>> +       mlx5e_tx_skb_update_hwts_flags(skb);
>>
>>          sq->pc += wi->num_wqebbs;
>> -       if (unlikely(!mlx5e_wqc_has_room_for(wq, sq->cc, sq->pc, sq->stop_room))) {
>> -               netif_tx_stop_queue(sq->txq);
>> -               sq->stats->stopped++;
>> -       }
>> +
>> +       mlx5e_tx_check_stop(sq);
>>
>>          send_doorbell = __netdev_tx_sent_queue(sq->txq, attr->num_bytes, xmit_more);
>>          if (send_doorbell)
>> --
>> 2.26.2
>>

