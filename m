Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6906CB2FD
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 03:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjC1BJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 21:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjC1BJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 21:09:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3CA1991;
        Mon, 27 Mar 2023 18:09:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA0CFB819F6;
        Tue, 28 Mar 2023 01:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21FB6C433D2;
        Tue, 28 Mar 2023 01:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679965792;
        bh=vA/nfYqUwD9ELidaPI/ntUXgM5gMp6ejsqSWsmAdvlg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AClbcXyzQRjHNyQte6rAqVlxpM9APN+dCP2Fi+6dbMiJLb1yZ9TNbgovLGvAWDdOJ
         N/F+Tz0ZVPuMVLgzNHFKPFRK6v82y8hQmK2UKSdOv5XrUxkWlvJV4WUu2AKDBLjlCf
         dNb2jv7403iNsxVS0ATy2SRM44HaexBdVazVQ8sRI1l+rlYip07nc1E3Lj1vxmdGzM
         vWk+Z4KhfrnrJGK1d1LWNal140Dq6S5bWlTZmvf+8RY9+lNiaxHp5inJHNBTqx+3+0
         AS55X0E1h+eUEvuDz3VPCTgbL1nY7TryY2/WuoHe3IJgFNBURPJJUkQiFekwQ4p+wY
         LepiB8xxdTxVw==
Date:   Mon, 27 Mar 2023 18:09:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: traceability of wifi packet drops
Message-ID: <20230327180950.79e064da@kernel.org>
In-Reply-To: <00659771ed54353f92027702c5bbb84702da62ce.camel@sipsolutions.net>
References: <00659771ed54353f92027702c5bbb84702da62ce.camel@sipsolutions.net>
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

On Mon, 27 Mar 2023 16:19:34 +0200 Johannes Berg wrote:
> So I just ran into this problem with a colleague again; we don't have
> good visibility into why in the wifi stack a packet is dropped.
> 
> In the network stack we have skb drop reasons for (part of?) this, but
> we don't really use this in wifi/mac80211 yet.
> 
> Unfortunately we have probably >100 distinct drop reasons in the wifi
> stack, so annotating those is not only tedious, it would also double the
> list of SKB drop reasons from currently ~75.
> 
> Any good ideas? I even thought about just encoding the line number
> wherever we use RX_DROP_UNUSABLE / RX_DROP_MONITOR, but that's kind of
> awkward too. Obviously we could change the internal API to completely
> get rid of enum ieee80211_rx_result and use enum skb_drop_reason
> instead, but then we'd probably need to carve out some space to also
> differentiate DROP_MONITOR and DROP_UNUSABLE, perhaps something like
> 
> 
> 	SKB_DROP_REASON_MAC80211_MASK		0x03ff0000
> 	SKB_DROP_REASON_MAC80211_TYPE_MASK	0x03000000
> 	SKB_DROP_REASON_MAC80211_TYPE_UNUSABLE	0x01000000
> 	SKB_DROP_REASON_MAC80211_TYPE_MONITOR	0x02000000
> 
> 	SKB_DROP_REASON_MAC80211_DUP		(SKB_DROP_REASON_MAC80211_TYPE_UNUSABLE | 1)
> 	SKB_DROP_REASON_MAC80211_BAD_BIP_KEYIDX	(SKB_DROP_REASON_MAC80211_TYPE_MONITOR | 1)
> 
> 
> etc.
> 
> 
> That'd be a LOT of annotations (and thus work) though, and a lot of new
> IDs/names, for something that's not really used all that much, i.e. a
> file number / line number within mac80211 would be completely
> sufficient, so the alternative could be to just have a separate
> tracepoint inside mac80211 with a line number or so?
> 
> Anyone have any great ideas?

We need something that'd scale to more subsystems, so I don't think
having all the definitions in enum skb_drop_reason directly is an
option.

My knee jerk idea would be to either use the top 8 bits of the
skb reason enum to denote the space. And then we'd say 0 is core
1 is wifi (enum ieee80211_rx_result) etc. Within the WiFi space 
you can use whatever encoding you like.

On a quick look nothing is indexed by the reason directly, so no
problems with using the high bits.

Option #2 is to add one main drop reason called SKB_DROP_REASON_MAC80211
and have a separate tracepoint which exposes the detailed wifi
reason and any necessary context. mac80211 would then have its own
wrapper around kfree_skb_reason() which triggers the tracepoint.

Those are perhaps fairly obvious and unimaginative. Adding Eric,
since he has been filling in a lot of the drop reasons lately.
