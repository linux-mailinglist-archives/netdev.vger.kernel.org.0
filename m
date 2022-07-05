Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B62F5665DA
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 11:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiGEJJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 05:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbiGEJJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 05:09:26 -0400
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C477A113D;
        Tue,  5 Jul 2022 02:09:24 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=mqaio@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VIRYWth_1657012160;
Received: from 30.178.82.110(mailfrom:mqaio@linux.alibaba.com fp:SMTPD_---0VIRYWth_1657012160)
          by smtp.aliyun-inc.com;
          Tue, 05 Jul 2022 17:09:21 +0800
Message-ID: <15fb8590-14b3-fc1a-c126-cae3d1490a82@linux.alibaba.com>
Date:   Tue, 5 Jul 2022 17:09:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH net-next v3 3/3] net: hinic: fix bug that u64_stats_sync
 is not initialized
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, gustavoars@kernel.org,
        cai.huoqing@linux.dev, Aviad Krawczyk <aviad.krawczyk@huawei.com>,
        zhaochen6@huawei.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <8cadab244a67bac6b69324de9264f4db61680896.1657001998.git.mqaio@linux.alibaba.com>
 <cover.1657001998.git.mqaio@linux.alibaba.com>
 <0146c84b4161172e7a3d407a940593aa723496ea.1657001998.git.mqaio@linux.alibaba.com>
 <7723937608e9f23b2a904615ae447beaf9f28586.1657001998.git.mqaio@linux.alibaba.com>
 <CANn89iLbgxZSQezYUmQhb8=+OfHDMkEVv=+5hQ4irhw8WaqsSQ@mail.gmail.com>
From:   maqiao <mqaio@linux.alibaba.com>
In-Reply-To: <CANn89iLbgxZSQezYUmQhb8=+OfHDMkEVv=+5hQ4irhw8WaqsSQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/7/5 下午4:53, Eric Dumazet 写道:
> On Tue, Jul 5, 2022 at 8:26 AM Qiao Ma <mqaio@linux.alibaba.com> wrote:
>>
>> In get_drv_queue_stats(), the local variable {txq|rxq}_stats
>> should be initialized first before calling into
>> hinic_{rxq|txq}_get_stats(), this patch fixes it.
>>
>> Fixes: edd384f682cc ("net-next/hinic: Add ethtool and stats")
>> Signed-off-by: Qiao Ma <mqaio@linux.alibaba.com>
>> ---
>>   drivers/net/ethernet/huawei/hinic/hinic_ethtool.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
>> index 93192f58ac88..75e9711bd2ba 100644
>> --- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
>> @@ -1371,6 +1371,9 @@ static void get_drv_queue_stats(struct hinic_dev *nic_dev, u64 *data)
>>          u16 i = 0, j = 0, qid = 0;
>>          char *p;
>>
>> +       u64_stats_init(&txq_stats.syncp);
>> +       u64_stats_init(&rxq_stats.syncp);
>> +
> 
> This is wrong really.
> 
> txq_stats and rxq_stats are local variables in get_drv_queue_stats()
> 
> It makes little sense to use u64_stats infra on them, because they are
> not visible to other cpus/threads in the host.
> 
> Please remove this confusion, instead of consolidating it.
Thanks, I'll remove it in next version.
> 
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c
> b/drivers/net/ethernet/huawei/hinic/hinic_main.c
> index 56a89793f47d4209b9e0dc3a122801d476e61381..edaac5a33458d51a3fb3e75c5fbe5bec8385f688
> 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
> @@ -85,8 +85,6 @@ static void update_rx_stats(struct hinic_dev
> *nic_dev, struct hinic_rxq *rxq)
>          struct hinic_rxq_stats *nic_rx_stats = &nic_dev->rx_stats;
>          struct hinic_rxq_stats rx_stats;
> 
> -       u64_stats_init(&rx_stats.syncp);
> -
>          hinic_rxq_get_stats(rxq, &rx_stats);
> 
>          u64_stats_update_begin(&nic_rx_stats->syncp);
> @@ -105,8 +103,6 @@ static void update_tx_stats(struct hinic_dev
> *nic_dev, struct hinic_txq *txq)
>          struct hinic_txq_stats *nic_tx_stats = &nic_dev->tx_stats;
>          struct hinic_txq_stats tx_stats;
> 
> -       u64_stats_init(&tx_stats.syncp);
> -
>          hinic_txq_get_stats(txq, &tx_stats);
> 
>          u64_stats_update_begin(&nic_tx_stats->syncp);
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
> b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
> index 24b7b819dbfbad1d64116ef54058ee4887d7a056..4edf4c52787051aebc512094741bda30de27e2f0
> 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
> @@ -66,14 +66,13 @@ void hinic_rxq_clean_stats(struct hinic_rxq *rxq)
>   /**
>    * hinic_rxq_get_stats - get statistics of Rx Queue
>    * @rxq: Logical Rx Queue
> - * @stats: return updated stats here
> + * @stats: return updated stats here (private to caller)
>    **/
>   void hinic_rxq_get_stats(struct hinic_rxq *rxq, struct hinic_rxq_stats *stats)
>   {
> -       struct hinic_rxq_stats *rxq_stats = &rxq->rxq_stats;
> +       const struct hinic_rxq_stats *rxq_stats = &rxq->rxq_stats;
>          unsigned int start;
> 
> -       u64_stats_update_begin(&stats->syncp);
>          do {
>                  start = u64_stats_fetch_begin(&rxq_stats->syncp);
>                  stats->pkts = rxq_stats->pkts;
> @@ -83,7 +82,6 @@ void hinic_rxq_get_stats(struct hinic_rxq *rxq,
> struct hinic_rxq_stats *stats)
>                  stats->csum_errors = rxq_stats->csum_errors;
>                  stats->other_errors = rxq_stats->other_errors;
>          } while (u64_stats_fetch_retry(&rxq_stats->syncp, start));
> -       u64_stats_update_end(&stats->syncp);
>   }
> 
>   /**
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
> b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
> index 87408e7bb8097de6fced7f0f2d170179b3fe93a9..2d97add1107f08f088b68a823767a92cbc6bbbdf
> 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
> @@ -91,14 +91,13 @@ void hinic_txq_clean_stats(struct hinic_txq *txq)
>   /**
>    * hinic_txq_get_stats - get statistics of Tx Queue
>    * @txq: Logical Tx Queue
> - * @stats: return updated stats here
> + * @stats: return updated stats here (private to caller)
>    **/
>   void hinic_txq_get_stats(struct hinic_txq *txq, struct hinic_txq_stats *stats)
>   {
> -       struct hinic_txq_stats *txq_stats = &txq->txq_stats;
> +       const struct hinic_txq_stats *txq_stats = &txq->txq_stats;
>          unsigned int start;
> 
> -       u64_stats_update_begin(&stats->syncp);
>          do {
>                  start = u64_stats_fetch_begin(&txq_stats->syncp);
>                  stats->pkts    = txq_stats->pkts;
> @@ -108,7 +107,6 @@ void hinic_txq_get_stats(struct hinic_txq *txq,
> struct hinic_txq_stats *stats)
>                  stats->tx_dropped = txq_stats->tx_dropped;
>                  stats->big_frags_pkts = txq_stats->big_frags_pkts;
>          } while (u64_stats_fetch_retry(&txq_stats->syncp, start));
> -       u64_stats_update_end(&stats->syncp);
>   }
> 
>   /**
