Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D673B533CFE
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 14:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243190AbiEYMvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 08:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbiEYMvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 08:51:08 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040ED97288;
        Wed, 25 May 2022 05:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:
        From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=jBwEIuoVmdPNXYxEmNuUCTtGCzJ7RyCeMRM3c0lfdnM=; b=AzEIJBHOTmK7YtFNZfJc08I+Jo
        f7MV+uUEn8mktkRQf/Qr6HiDRmqX1EBEpHR/XmmLEpSGw9XMi/jttcaeAUzlhOYtICb1I/V0zQYan
        BIdeb0sHrQjvrUEhwkIUpbl7+KyJPEaJ4vEe3F14lucm62aI9R0NH8p8mwV00xFA8ArE=;
Received: from p200300daa70ef2005cc39ce6374ff633.dip0.t-ipconnect.de ([2003:da:a70e:f200:5cc3:9ce6:374f:f633] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1ntqTR-0008WC-92; Wed, 25 May 2022 14:50:49 +0200
Message-ID: <92ca6224-9232-2648-0123-7096aafa17fb@nbd.name>
Date:   Wed, 25 May 2022 14:50:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-Language: en-US
To:     Baligh GASMI <gasmibal@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:MAC80211" <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20220525103512.3666956-1-gasmibal@gmail.com>
 <87r14hoox8.fsf@toke.dk>
 <CALxDnQa8d8CGXz2Mxvsz5csLj3KuTDW=z65DSzHk5x1Vg+y-rw@mail.gmail.com>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC PATCH 1/1] mac80211: use AQL airtime for expected
 throughput.
In-Reply-To: <CALxDnQa8d8CGXz2Mxvsz5csLj3KuTDW=z65DSzHk5x1Vg+y-rw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 25.05.22 14:14, Baligh GASMI wrote:
>> > Since the integration of AQL, packet TX airtime estimation is
>> > calculated and counted to be used for the dequeue limit.
>> >
>> > Use this estimated airtime to compute expected throughput for
>> > each station.
>> >
>> > It will be a generic mac80211 implementation. If the driver has
>> > get_expected_throughput implementation, it will be used instead.
>> >
>> > Useful for L2 routing protocols, like B.A.T.M.A.N.
>> >
>> > Signed-off-by: Baligh Gasmi <gasmibal@gmail.com>
>> > ---
>> >  net/mac80211/driver-ops.h |  2 ++
>> >  net/mac80211/sta_info.h   |  2 ++
>> >  net/mac80211/status.c     | 22 ++++++++++++++++++++++
>> >  net/mac80211/tx.c         |  3 ++-
>> >  4 files changed, 28 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
>> > index 4e2fc1a08681..4331b79647fa 100644
>> > --- a/net/mac80211/driver-ops.h
>> > +++ b/net/mac80211/driver-ops.h
>> > @@ -1142,6 +1142,8 @@ static inline u32 drv_get_expected_throughput(struct ieee80211_local *local,
>> >       trace_drv_get_expected_throughput(&sta->sta);
>> >       if (local->ops->get_expected_throughput && sta->uploaded)
>> >               ret = local->ops->get_expected_throughput(&local->hw, &sta->sta);
>> > +     else
>> > +             ret = ewma_avg_est_tp_read(&sta->status_stats.avg_est_tp);
>> >       trace_drv_return_u32(local, ret);
>> >
>> >       return ret;
>> > diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
>> > index 379fd367197f..fe60be4c671d 100644
>> > --- a/net/mac80211/sta_info.h
>> > +++ b/net/mac80211/sta_info.h
>> > @@ -123,6 +123,7 @@ enum ieee80211_sta_info_flags {
>> >  #define HT_AGG_STATE_STOP_CB         7
>> >  #define HT_AGG_STATE_SENT_ADDBA              8
>> >
>> > +DECLARE_EWMA(avg_est_tp, 8, 16)
>> >  DECLARE_EWMA(avg_signal, 10, 8)
>> >  enum ieee80211_agg_stop_reason {
>> >       AGG_STOP_DECLINED,
>> > @@ -641,6 +642,7 @@ struct sta_info {
>> >               s8 last_ack_signal;
>> >               bool ack_signal_filled;
>> >               struct ewma_avg_signal avg_ack_signal;
>> > +             struct ewma_avg_est_tp avg_est_tp;
>> >       } status_stats;
>> >
>> >       /* Updated from TX path only, no locking requirements */
>> > diff --git a/net/mac80211/status.c b/net/mac80211/status.c
>> > index e81e8a5bb774..647ade3719f5 100644
>> > --- a/net/mac80211/status.c
>> > +++ b/net/mac80211/status.c
>> > @@ -1145,6 +1145,28 @@ void ieee80211_tx_status_ext(struct ieee80211_hw *hw,
>> >                       sta->status_stats.retry_failed++;
>> >               sta->status_stats.retry_count += retry_count;
>> >
>> > +             if (skb && tx_time_est) {
>>
>> Shouldn't this be conditioned on actually being used (i.e., existence of
>> get_expected_throughput op? Also maybe pull it out into its own function
>> to make it clear what it's doing...
> 
> It's already the case I think, since the tx_time_est is not-zero only
> when actually an estimated time is set.
> A dedicated function seems good for me, for clarity, yes.
> 
>>
>> > +                     /* max average packet size */
>> > +                     size_t pkt_size = skb->len > 1024 ? 1024 : skb->len;
>> > +
>> > +                     if (acked) {
>> > +                             /* ACK packet size */
>> > +                             pkt_size += 14;
>> > +                             /* SIFS x 2 */
>> > +                             tx_time_est += 2 * 2;
>> > +                     }
>> > +
>> > +                     /* Backoff average x retries */
>> > +                     tx_time_est += retry_count ? retry_count * 2 : 2;
>> > +
>> > +                     /* failed tx */
>> > +                     if (!acked && !noack_success)
>> > +                             pkt_size = 0;
>> > +
>> > +                     ewma_avg_est_tp_add(&sta->status_stats.avg_est_tp,
>> > +                                         ((pkt_size * 8) * 1000) / tx_time_est);
>>
>> Could we avoid adding this division in the fast path?
> 
> Maybe we can use the do_div() macro for optimization, I don't see how
> we can avoid it.
Here's one idea on how to make it less expensive and improve the average 
of the throughput estimation at the same time:

In sta->status_stats add these fields:

u32 last_tp_update;
u32 pkt_size;
u32 tx_time_est;

And in this part of the code you do something like this:

u32 diff = ((u32)jiffies) - sta->status_stats.last_tp_update;
sta->status_stats.pkt_size += (pkt_size * 8) * 1000;
sta->status_stats.tx_time_est += tx_time_est;
if (diff > HZ / 10) {
	ewma_avg_est_tp_add(&sta->status_stats.avg_est_tp,
			    sta->status_stats.pkt_size /
			    sta->status_stats.tx_time_est);
	sta->status_stats.pkt_size = 0;
	sta->status_stats.tx_time_est = 0;
}

This ensures that you will only get max. 1 update per 100ms interval.

Does that make sense?

- Felix
