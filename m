Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1549C6CF19F
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjC2SCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjC2SCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:02:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD9F3C20;
        Wed, 29 Mar 2023 11:02:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 972F0B81E4A;
        Wed, 29 Mar 2023 18:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1991CC433D2;
        Wed, 29 Mar 2023 18:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680112927;
        bh=g7M1ijeWkoCPcTbPENp03zQ52fyu6Nb8Ng/EsfHXvOI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qYG6/NwFiso/cYVPGEQONfOkFwJ5aQ7B5ozM57fU1Tcy2cE7JXvIQr8Y4qVBVmytE
         BpejHQQrVwWUOBfzm/ThEOrMHr2pBtrITAF/TmdkoXufF53qZRwWqn1of3FKr7WmrN
         5AUt23Z9RCMEkDi5jxPCFktQntHclkvgjpK7KGFqRIjXA82UBteGXdkjVcL2JAECC8
         AsiudOH0prrDDbAxKVjOMYg9jZDqVLQj7jY2tXDHNGEZBEXqQKuV1nl0cwtbcVksP2
         KU1Yy1HiXnBSsKvKwrQaWA3osPL33Tfnl0yKdcpLsooHonUEGQbIzlr5U1vDXZvnhG
         2fl8IHz1HvoHg==
Date:   Wed, 29 Mar 2023 11:02:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: traceability of wifi packet drops
Message-ID: <20230329110205.1202eb60@kernel.org>
In-Reply-To: <8304ec7e430815edf3b79141c90272e36683e085.camel@sipsolutions.net>
References: <00659771ed54353f92027702c5bbb84702da62ce.camel@sipsolutions.net>
        <20230327180950.79e064da@kernel.org>
        <abcf4b9aed8adad05841234dad103ced15f9bfb2.camel@sipsolutions.net>
        <20230328155826.38e9e077@kernel.org>
        <8304ec7e430815edf3b79141c90272e36683e085.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 10:35:08 +0200 Johannes Berg wrote:
> > Thinking about it again, maybe yours is actually cleaner.
> > Having the subsystem reason on the top bits, I mean.
> > That way after masking the specific bits out the lower bits
> > can still provide a valid "global" drop reason.  
> 
> Ah, that's not even what I was thinking, but that would work.
> 
> What I was thinking was basically the same as you had, just hadn't
> thought about more subsystems yet and was trying to carve out some bits
> for wifi specifically :-)
> 
> I don't think we'll really end up with a case where we really want to
> use the low bits for a global reason and a wifi specific reason in
> higher bits together - there are basically no applicable reasons that we
> have today ...
> 
> I mean, it basically doesn't make sense to have any of the current
> reasons (such as _IP_CSUM or _IP_INHDR) with a wifi specific reason
> since we wouldn't even go look at the IP header when wifi drops
> something.
> 
> The only one that _might_ be relevant would be possibly _PKT_TOO_SMALL
> where wifi has various "reasons" for it to be too small (depending on
> the packet format), but I'm not sure that it would even be helpful to
> have drop monitor report "packet too small" from different layers; today
> it's used from L3/L4, not L2.

No, no what I was trying to say is that instead of using the upper bits
to identify the space (with 0 being the current enum skb_drop_reason)
we could use entries in enum skb_drop_reason. In hope that it'd make
the fine grained subsystem reason seem more like additional information
than a completely parallel system.

But it's just a thought, all of the approaches seem acceptable.

Quick code change perhaps illustrates it best:

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index c0a3ea806cd5..048402ffa6ad 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -338,11 +338,21 @@ enum skb_drop_reason {
 	 * for another host.
 	 */
 	SKB_DROP_REASON_IPV6_NDISC_NS_OTHERHOST,
+	/* packet was unusable? IDK */
+	SKB_DROP_REASON_MAC80211_UNUSABLE,
+	/* also no idea :) */
+	SKB_DROP_REASON_MAC80211_MONITOR,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
 	 */
 	SKB_DROP_REASON_MAX,
+
+	/**
+	 * @SKB_DROP_SUBSYS_REASON_MASK: fine grained reason from a particular
+	 * subsystem
+	 */
+	SKB_DROP_SUBSYS_REASON_MASK = 0xffff0000,
 };
 
 #define SKB_DR_INIT(name, reason)				\
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 5a782d1d8fd3..a06ba912c793 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -504,6 +504,7 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 	if (!nskb)
 		return;
 
+	reason &= ~SKB_DROP_SUBSYS_REASON_MASK;
 	if (unlikely(reason >= SKB_DROP_REASON_MAX || reason <= 0))
 		reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	cb = NET_DM_SKB_CB(nskb);
@@ -611,6 +612,7 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 {
 	struct net_dm_skb_cb *cb = NET_DM_SKB_CB(skb);
 	char buf[NET_DM_MAX_SYMBOL_LEN];
+	unsigned int reason, subreason;
 	struct nlattr *attr;
 	void *hdr;
 	int rc;
@@ -627,10 +629,19 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 			      NET_DM_ATTR_PAD))
 		goto nla_put_failure;
 
+	subreason = FIELD_GET(SKB_DROP_SUBSYS_REASON_MASK, cb->reason);
+	reason = cb->reason & ~SKB_DROP_SUBSYS_REASON_MASK;
 	if (nla_put_string(msg, NET_DM_ATTR_REASON,
-			   drop_reasons[cb->reason]))
+			   drop_reasons[reason]))
 		goto nla_put_failure;
 
+	if (subreason) {
+		/* additionally search the per-subsys table,
+		 * table is found based on @reason
+		 * and indexed with @subreason
+		 */
+	}
+
 	snprintf(buf, sizeof(buf), "%pS", cb->pc);
 	if (nla_put_string(msg, NET_DM_ATTR_SYMBOL, buf))
 		goto nla_put_failure;
