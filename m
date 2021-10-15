Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3791842F3DD
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 15:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbhJONl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 09:41:27 -0400
Received: from mail-ssdrsserver2.hostinginterface.eu ([185.185.85.90]:52300
        "EHLO mail-ssdrsserver2.hostinginterface.eu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236572AbhJONl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 09:41:26 -0400
X-Greylist: delayed 2369 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Oct 2021 09:41:26 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bobbriscoe.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IDpKo88dSz3NAsjxPU3GYGlfwBOTVO7ckKlu0JyZv6c=; b=KdFX5snHn+tOvR/NMhRsyGFPaV
        kby8VivdsnVakU58gZFKkkdhxS/jb2SFpbXwZSURf+8qYy68vlywJ2cla2ulSqFHGnZTUh3E7O5qh
        fO8SRlG9PnHY5Pd0EkVJLeIY4cZPW9+Yxmtofm4LGxHOMN88C9rp7pT3/jVOM3eV7FLgNfy9N6waB
        2SP/WUZfuyzFaNAvWIyZ89dDAEUivP+0fVEOKqMfy2hTrbV81YvEgcVjusgCWNu9oqI62FS6lTkAT
        tGgx5X9qIVHIJGckobEoiiYs1wlmRbRvi5HKFUzg/DBOqUoKVuzEQXq2puWKBns2Pg/QbmTnnPJ+R
        CppiClsA==;
Received: from 67.153.238.178.in-addr.arpa ([178.238.153.67]:57326 helo=[192.168.1.11])
        by ssdrsserver2.hostinginterface.eu with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <ietf@bobbriscoe.net>)
        id 1mbMoY-00GVce-Sj; Fri, 15 Oct 2021 13:59:50 +0100
Subject: Re: [PATCH net-next 2/2] fq_codel: implement L4S style
 ce_threshold_ect1 marking
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Ingemar Johansson S <ingemar.s.johansson@ericsson.com>,
        Tom Henderson <tomh@tomh.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20211014175918.60188-1-eric.dumazet@gmail.com>
 <20211014175918.60188-3-eric.dumazet@gmail.com>
From:   Bob Briscoe <ietf@bobbriscoe.net>
Message-ID: <9608bf7c-a6a2-2a30-2d96-96bd1dfb25e3@bobbriscoe.net>
Date:   Fri, 15 Oct 2021 13:59:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211014175918.60188-3-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ssdrsserver2.hostinginterface.eu
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - bobbriscoe.net
X-Get-Message-Sender-Via: ssdrsserver2.hostinginterface.eu: authenticated_id: in@bobbriscoe.net
X-Authenticated-Sender: ssdrsserver2.hostinginterface.eu: in@bobbriscoe.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric,

Because the threshold is in time units, I suggest the condition for 
exceeding it needs to be AND'd with (*backlog > mtu), otherwise you can 
get 100% solid marking at low link rates.

When ce_threshold is for DCs, low link rates are unlikely.
However, given ce_threshold_ect1 is mainly for the Internet, during 
testing with 1ms threshold we encountered solid marking at low link 
rates, so we had to add a 1 packet floor:
https://bobbriscoe.net/projects/latency/dctth_journal_draft20190726.pdf

Sorry to chime in after your patch went to net-next.


Bob


On 14/10/2021 18:59, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
>
> Add TCA_FQ_CODEL_CE_THRESHOLD_ECT1 boolean option to select Low Latency,
> Low Loss, Scalable Throughput (L4S) style marking, along with ce_threshold.
>
> If enabled, only packets with ECT(1) can be transformed to CE
> if their sojourn time is above the ce_threshold.
>
> Note that this new option does not change rules for codel law.
> In particular, if TCA_FQ_CODEL_ECN is left enabled (this is
> the default when fq_codel qdisc is created), ECT(0) packets can
> still get CE if codel law (as governed by limit/target) decides so.
>
> Section 4.3.b of current draft [1] states:
>
> b.  A scheduler with per-flow queues such as FQ-CoDel or FQ-PIE can
>      be used for L4S.  For instance within each queue of an FQ-CoDel
>      system, as well as a CoDel AQM, there is typically also ECN
>      marking at an immediate (unsmoothed) shallow threshold to support
>      use in data centres (see Sec.5.2.7 of [RFC8290]).  This can be
>      modified so that the shallow threshold is solely applied to
>      ECT(1) packets.  Then if there is a flow of non-ECN or ECT(0)
>      packets in the per-flow-queue, the Classic AQM (e.g.  CoDel) is
>      applied; while if there is a flow of ECT(1) packets in the queue,
>      the shallower (typically sub-millisecond) threshold is applied.
>
> Tested:
>
> tc qd replace dev eth1 root fq_codel ce_threshold_ect1 50usec
>
> netperf ... -t TCP_STREAM -- K dctcp
>
> tc -s -d qd sh dev eth1
> qdisc fq_codel 8022: root refcnt 32 limit 10240p flows 1024 quantum 9212 target 5ms ce_threshold_ect1 49us interval 100ms memory_limit 32Mb ecn drop_batch 64
>   Sent 14388596616 bytes 9543449 pkt (dropped 0, overlimits 0 requeues 152013)
>   backlog 0b 0p requeues 152013
>    maxpacket 68130 drop_overlimit 0 new_flow_count 95678 ecn_mark 0 ce_mark 7639
>    new_flows_len 0 old_flows_len 0
>
> [1] L4S current draft:
> https://datatracker.ietf.org/doc/html/draft-ietf-tsvwg-l4s-arch
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> Cc: Ingemar Johansson S <ingemar.s.johansson@ericsson.com>
> Cc: Tom Henderson <tomh@tomh.org>
> Cc: Bob Briscoe <in@bobbriscoe.net>
> ---
>   include/net/codel.h            |  2 ++
>   include/net/codel_impl.h       | 18 +++++++++++++++---
>   include/uapi/linux/pkt_sched.h |  1 +
>   net/mac80211/sta_info.c        |  1 +
>   net/sched/sch_fq_codel.c       | 15 +++++++++++----
>   5 files changed, 30 insertions(+), 7 deletions(-)
>
> diff --git a/include/net/codel.h b/include/net/codel.h
> index a6e428f801350809322aaff08d92904e059c3b5a..5e8b181b76b829d6af3c57809d9bc5f0578dd112 100644
> --- a/include/net/codel.h
> +++ b/include/net/codel.h
> @@ -102,6 +102,7 @@ static inline u32 codel_time_to_us(codel_time_t val)
>    * @interval:	width of moving time window
>    * @mtu:	device mtu, or minimal queue backlog in bytes.
>    * @ecn:	is Explicit Congestion Notification enabled
> + * @ce_threshold_ect1: if ce_threshold only marks ECT(1) packets
>    */
>   struct codel_params {
>   	codel_time_t	target;
> @@ -109,6 +110,7 @@ struct codel_params {
>   	codel_time_t	interval;
>   	u32		mtu;
>   	bool		ecn;
> +	bool		ce_threshold_ect1;
>   };
>   
>   /**
> diff --git a/include/net/codel_impl.h b/include/net/codel_impl.h
> index d289b91dcd65ecdc96dc0c9bf85d4a4be6961022..7af2c3eb3c43c24364519120aad5be77522854a6 100644
> --- a/include/net/codel_impl.h
> +++ b/include/net/codel_impl.h
> @@ -54,6 +54,7 @@ static void codel_params_init(struct codel_params *params)
>   	params->interval = MS2TIME(100);
>   	params->target = MS2TIME(5);
>   	params->ce_threshold = CODEL_DISABLED_THRESHOLD;
> +	params->ce_threshold_ect1 = false;
>   	params->ecn = false;
>   }
>   
> @@ -246,9 +247,20 @@ static struct sk_buff *codel_dequeue(void *ctx,
>   						    vars->rec_inv_sqrt);
>   	}
>   end:
> -	if (skb && codel_time_after(vars->ldelay, params->ce_threshold) &&
> -	    INET_ECN_set_ce(skb))
> -		stats->ce_mark++;
> +	if (skb && codel_time_after(vars->ldelay, params->ce_threshold)) {
> +		bool set_ce = true;
> +
> +		if (params->ce_threshold_ect1) {
> +			/* Note: if skb_get_dsfield() returns -1, following
> +			 * gives INET_ECN_MASK, which is != INET_ECN_ECT_1.
> +			 */
> +			u8 ecn = skb_get_dsfield(skb) & INET_ECN_MASK;
> +
> +			set_ce = (ecn == INET_ECN_ECT_1);
> +		}
> +		if (set_ce && INET_ECN_set_ce(skb))
> +			stats->ce_mark++;
> +	}
>   	return skb;
>   }
>   
> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
> index ec88590b3198441f18cc9def7bd40c48f0bc82a1..6be9a84cccfa79bace1f3f7123d02f484b67a25e 100644
> --- a/include/uapi/linux/pkt_sched.h
> +++ b/include/uapi/linux/pkt_sched.h
> @@ -840,6 +840,7 @@ enum {
>   	TCA_FQ_CODEL_CE_THRESHOLD,
>   	TCA_FQ_CODEL_DROP_BATCH_SIZE,
>   	TCA_FQ_CODEL_MEMORY_LIMIT,
> +	TCA_FQ_CODEL_CE_THRESHOLD_ECT1,
>   	__TCA_FQ_CODEL_MAX
>   };
>   
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index 2b5acb37587f7068e2d11fe842ec963a556f1eb1..a39830418434d4bb74d238373f63a4858230fce5 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -513,6 +513,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
>   	sta->cparams.target = MS2TIME(20);
>   	sta->cparams.interval = MS2TIME(100);
>   	sta->cparams.ecn = true;
> +	sta->cparams.ce_threshold_ect1 = false;
>   
>   	sta_dbg(sdata, "Allocated STA %pM\n", sta->sta.addr);
>   
> diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
> index bb0cd6d3d2c2749d54e26368fb2558beedea85c9..033d65d06eb136ff704cddd3ee950a5c3a5d9831 100644
> --- a/net/sched/sch_fq_codel.c
> +++ b/net/sched/sch_fq_codel.c
> @@ -362,6 +362,7 @@ static const struct nla_policy fq_codel_policy[TCA_FQ_CODEL_MAX + 1] = {
>   	[TCA_FQ_CODEL_CE_THRESHOLD] = { .type = NLA_U32 },
>   	[TCA_FQ_CODEL_DROP_BATCH_SIZE] = { .type = NLA_U32 },
>   	[TCA_FQ_CODEL_MEMORY_LIMIT] = { .type = NLA_U32 },
> +	[TCA_FQ_CODEL_CE_THRESHOLD_ECT1] = { .type = NLA_U8 },
>   };
>   
>   static int fq_codel_change(struct Qdisc *sch, struct nlattr *opt,
> @@ -408,6 +409,9 @@ static int fq_codel_change(struct Qdisc *sch, struct nlattr *opt,
>   		q->cparams.ce_threshold = (val * NSEC_PER_USEC) >> CODEL_SHIFT;
>   	}
>   
> +	if (tb[TCA_FQ_CODEL_CE_THRESHOLD_ECT1])
> +		q->cparams.ce_threshold_ect1 = !!nla_get_u8(tb[TCA_FQ_CODEL_CE_THRESHOLD_ECT1]);
> +
>   	if (tb[TCA_FQ_CODEL_INTERVAL]) {
>   		u64 interval = nla_get_u32(tb[TCA_FQ_CODEL_INTERVAL]);
>   
> @@ -544,10 +548,13 @@ static int fq_codel_dump(struct Qdisc *sch, struct sk_buff *skb)
>   			q->flows_cnt))
>   		goto nla_put_failure;
>   
> -	if (q->cparams.ce_threshold != CODEL_DISABLED_THRESHOLD &&
> -	    nla_put_u32(skb, TCA_FQ_CODEL_CE_THRESHOLD,
> -			codel_time_to_us(q->cparams.ce_threshold)))
> -		goto nla_put_failure;
> +	if (q->cparams.ce_threshold != CODEL_DISABLED_THRESHOLD) {
> +		if (nla_put_u32(skb, TCA_FQ_CODEL_CE_THRESHOLD,
> +				codel_time_to_us(q->cparams.ce_threshold)))
> +			goto nla_put_failure;
> +		if (nla_put_u8(skb, TCA_FQ_CODEL_CE_THRESHOLD_ECT1, q->cparams.ce_threshold_ect1))
> +			goto nla_put_failure;
> +	}
>   
>   	return nla_nest_end(skb, opts);
>   

-- 
________________________________________________________________
Bob Briscoe                               http://bobbriscoe.net/

