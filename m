Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7BD06DB86C
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 05:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjDHDDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 23:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDHDDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 23:03:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB749759;
        Fri,  7 Apr 2023 20:03:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B3FB65382;
        Sat,  8 Apr 2023 03:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF3CC433D2;
        Sat,  8 Apr 2023 03:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680923000;
        bh=Qf5obg+kL73O79EP37quol4/OI6cp1moqLG2S8Dpxws=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rsmamPDtsh4Efg7NE67BKnZ0i0b5Rf4UZmYjmvrwQF5g5vN6lRJmdxJZ3KgatruuJ
         iYlFpEKBJ+DnSutf6kimjmyfDQ0ZSdRLpVJfQ6quNLiIAt1fKFHOOEUqyIE0nuaWoH
         qMP3TUG9O4R6VygrURyNJ1BINKABFdq/16OVQ/9O1P+338aEeWxyObnJDS0BXMhHSH
         ucR0UlJ/H0NP9HagRVhKwC+sQVWnsqp934Oe6Q4maBj2d6sQpn96ddwbeFL6tTCPk1
         d6YcbuAXyHK9owauYuDJBsmUTJbdAQQ6vuG0wyfDQigd8bmUWewPU8R46vRr5Z/lcE
         yll5YHTeRN1qQ==
Date:   Fri, 7 Apr 2023 20:03:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <yang.yang29@zte.com.cn>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <roopa@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>,
        <zhang.yunkai@zte.com.cn>, <jiang.xuexin@zte.com.cn>
Subject: Re: [PATCH net-next] net/bridge: add drop reasons for bridge
 forwarding
Message-ID: <20230407200319.72fd763f@kernel.org>
In-Reply-To: <202304061930349843930@zte.com.cn>
References: <202304061930349843930@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Apr 2023 19:30:34 +0800 (CST) yang.yang29@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> This creates six drop reasons as follows, which will help users know the
> specific reason why bridge drops the packets when forwarding.
> 
> 1) SKB_DROP_REASON_BRIDGE_FWD_NO_BACKUP_PORT: failed to get a backup
>    port link when the destination port is down.
> 
> 2) SKB_DROP_REASON_BRIDGE_FWD_SAME_PORT: destination port is the same
>    with originating port when forwarding by a bridge.
> 
> 3) SKB_DROP_REASON_BRIDGE_NON_FORWARDING_STATE: the bridge's state is
>    not forwarding.
> 
> 4) SKB_DROP_REASON_BRIDGE_NOT_ALLOWED_EGRESS: the packet is not allowed
>    to go out through the port due to vlan filtering.
> 
> 5) SKB_DROP_REASON_BRIDGE_SWDEV_NOT_ALLOWED_EGRESS: the packet is not
>    allowed to go out through the port which is offloaded by a hardware
>    switchdev, checked by nbp_switchdev_allowed_egress().
> 
> 6) SKB_DROP_REASON_BRIDGE_BOTH_PORT_ISOLATED: both source port and dest
>    port are in BR_ISOLATED state when bridge forwarding.

> @@ -338,6 +344,33 @@ enum skb_drop_reason {
>  	 * for another host.
>  	 */
>  	SKB_DROP_REASON_IPV6_NDISC_NS_OTHERHOST,
> +	/** @SKB_DROP_REASON_BRIDGE_FWD_NO_BACKUP_PORT: failed to get a backup
> +	 * port link when the destination port is down.
> +	 */

That's not valid kdoc. Text can be on the same line as the value only
in one-line comments. Otherwise:
	/**
	 * @VALUE: bla bla bla
	 *	more blas.
	 */

> +static inline bool should_deliver(const struct net_bridge_port *p, const struct sk_buff *skb,
> +					 enum skb_drop_reason *need_reason)
>  {
>  	struct net_bridge_vlan_group *vg;
> +	enum skb_drop_reason reason;
> 
>  	vg = nbp_vlan_group_rcu(p);
> -	return ((p->flags & BR_HAIRPIN_MODE) || skb->dev != p->dev) &&
> -		p->state == BR_STATE_FORWARDING && br_allowed_egress(vg, skb) &&
> -		nbp_switchdev_allowed_egress(p, skb) &&
> -		!br_skb_isolated(p, skb);
> +	if (!(p->flags & BR_HAIRPIN_MODE) && skb->dev == p->dev) {
> +		reason = SKB_DROP_REASON_BRIDGE_FWD_SAME_PORT;
> +		goto undeliverable;
> +	}
> +	if (p->state != BR_STATE_FORWARDING) {
> +		reason = SKB_DROP_REASON_BRIDGE_NON_FORWARDING_STATE;
> +		goto undeliverable;
> +	}
> +	if (!br_allowed_egress(vg, skb)) {
> +		reason = SKB_DROP_REASON_BRIDGE_NOT_ALLOWED_EGRESS;
> +		goto undeliverable;
> +	}
> +	if (!nbp_switchdev_allowed_egress(p, skb)) {
> +		reason = SKB_DROP_REASON_BRIDGE_SWDEV_NOT_ALLOWED_EGRESS;
> +		goto undeliverable;
> +	}
> +	if (br_skb_isolated(p, skb)) {
> +		reason = SKB_DROP_REASON_BRIDGE_BOTH_PORT_ISOLATED;
> +		goto undeliverable;
> +	}
> +	return true;
> +
> +undeliverable:
> +	if (need_reason)
> +		*need_reason = reason;
> +	return false;

You can return the reason from this function. That's the whole point of
SKB_NOT_DROPPED_YET existing and being equal to 0.

Which is not to say that I know whether the reasons are worth adding
here. We'll need to hear from bridge experts on that.

