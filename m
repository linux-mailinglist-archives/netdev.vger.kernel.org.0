Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF85A4D9379
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 06:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240551AbiCOFDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 01:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235582AbiCOFDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 01:03:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80CA47079
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 22:02:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 965C0B810F6
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 05:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FDCC340E8;
        Tue, 15 Mar 2022 05:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647320522;
        bh=14N+LZwVbOriVcS40AU2JLYUKLIeHWIcp0ANImiyMGE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RjD0tgVUy0Ty3CIhH1d+D3hFl9fbwDN20yc0znTbzDNZuI+DMUvsRL349vN4Bf83a
         7zwV3wMxINzy9OP/ESK1qnVStRKHh8qrt1hCeapj3LtOkwIUZcjfbYEyvp1/AROH9A
         Q7kldfjmWZKM/n5wBfXkVBNRJLTTIOkK/fKFBeMzBfZuHjBM1S5lJ31e+pd/ymwoFG
         V9QfzZHX/2+6YmLe0sBgDrVpcjDfMrR9YJU9pPrBFVYdWiA9cDNpMnU/uZxAgq5o/+
         oBqn13CtfF4dpDhnlAAzGZvzQTiwBraMXpC3wkIU1VnhU+zfdGT5lpfbAacMb4MKso
         nP6hFE/Ay1O+w==
Date:   Mon, 14 Mar 2022 22:02:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     <netdev@vger.kernel.org>, Maor Dickman <maord@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 1/3] net/sched: add vlan push_eth and pop_eth
 action to the hardware IR
Message-ID: <20220314220200.0b53e7a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220309130256.1402040-2-roid@nvidia.com>
References: <20220309130256.1402040-1-roid@nvidia.com>
        <20220309130256.1402040-2-roid@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for the late review.

On Wed, 9 Mar 2022 15:02:54 +0200 Roi Dayan wrote:
> @@ -211,6 +213,8 @@ struct flow_action_entry {
>  			__be16		proto;
>  			u8		prio;
>  		} vlan;
> +		unsigned char vlan_push_eth_dst[ETH_ALEN];
> +		unsigned char vlan_push_eth_src[ETH_ALEN];

Let's wrap these two in a struct, like all other members here, 
and add the customary comment indicating which action its for.

>  		struct {				/* FLOW_ACTION_MANGLE */
>  							/* FLOW_ACTION_ADD */
>  			enum flow_action_mangle_base htype;
> diff --git a/include/net/tc_act/tc_vlan.h b/include/net/tc_act/tc_vlan.h
> index f94b8bc26f9e..8a3422c70f9f 100644
> --- a/include/net/tc_act/tc_vlan.h
> +++ b/include/net/tc_act/tc_vlan.h
> @@ -78,4 +78,18 @@ static inline u8 tcf_vlan_push_prio(const struct tc_action *a)
>  
>  	return tcfv_push_prio;
>  }
> +
> +static inline void tcf_vlan_push_dst(unsigned char *dest, const struct tc_action *a)
> +{
> +	rcu_read_lock();
> +	memcpy(dest, rcu_dereference(to_vlan(a)->vlan_p)->tcfv_push_dst, ETH_ALEN);
> +	rcu_read_unlock();
> +}
> +
> +static inline void tcf_vlan_push_src(unsigned char *dest, const struct tc_action *a)
> +{
> +	rcu_read_lock();
> +	memcpy(dest, rcu_dereference(to_vlan(a)->vlan_p)->tcfv_push_src, ETH_ALEN);
> +	rcu_read_unlock();
> +}

The use of these two helpers separately makes no sense, we can't push
half a header. It should be one helper populating both src and dst, IMO.
