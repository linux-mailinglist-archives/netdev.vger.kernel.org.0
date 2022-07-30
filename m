Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B35585845
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 05:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239772AbiG3Db6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 23:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiG3Dbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 23:31:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414D1EE2C;
        Fri, 29 Jul 2022 20:31:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFFE561DE5;
        Sat, 30 Jul 2022 03:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E1EC433C1;
        Sat, 30 Jul 2022 03:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659151913;
        bh=T/qBos0C3RBWMkL5/pbGZ69/EtykuvP+aJ7ZH+m/CJY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B4Gb1PnPZFj0tkRvAJqIas1gkfdrW5R5t+gqum1lmq07F8YayHEoKFnVH5dp8pqbG
         mCFr+g1oPJKEaE4UnxFoDzEDcXuTJFrVxLcz17c1g905SVwC+RlwC33nW9sbJKq/AA
         /RI9QY7lXQcXN80AlpHoloDpTLBp9nPS8taP22w8cP5MeA69gxEalgwKiZZo4lcMig
         wdgHV1vrOaXnMhJKUTErx1FCMfqOf6Gfri4ayAGRH3AhP772OI5sRLkc7YY48n+cDV
         itCd42rt4wpA0mD6yOv25L/6LR4WgYNj6fBGPTAtB9QrWC4uROBRshKEL6pb43ca2L
         Q/X+1mANjboHw==
Date:   Fri, 29 Jul 2022 20:31:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mike Pattrick <mkp@redhat.com>
Cc:     netdev@vger.kernel.org, pvalerio@redhat.com,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] openvswitch: Fix double reporting of drops
 in dropwatch
Message-ID: <20220729203151.3e849337@kernel.org>
In-Reply-To: <20220728161259.1088662-1-mkp@redhat.com>
References: <20220728161259.1088662-1-mkp@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jul 2022 12:12:58 -0400 Mike Pattrick wrote:
> Frames sent to userspace can be reported as dropped in
> ovs_dp_process_packet, however, if they are dropped in the netlink code
> then netlink_attachskb will report the same frame as dropped.
> 
> This patch checks for error codes which indicate that the frame has
> already been freed.
> 
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=2109946

Please remove the Bugzilla link, it doesn't seem to be public.
If it is then it should be a Link: tag, not a custom tag for bz.

> Signed-off-by: Mike Pattrick <mkp@redhat.com>
> ---
>  net/openvswitch/datapath.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index 7e8a39a35627..029f9c3e1c28 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -252,10 +252,20 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
>  
>  		upcall.mru = OVS_CB(skb)->mru;
>  		error = ovs_dp_upcall(dp, skb, key, &upcall, 0);
> -		if (unlikely(error))
> -			kfree_skb(skb);
> -		else
> +		switch (error) {
> +		case 0:
> +			fallthrough;
> +		case -EAGAIN:
> +			fallthrough;
> +		case -ERESTARTSYS:
> +			fallthrough;

No need to add the fallthrough;s between two case statements.

> +		case -EINTR:
>  			consume_skb(skb);
> +			break;
> +		default:
> +			kfree_skb(skb);
> +			break;
> +		}
>  		stats_counter = &stats->n_missed;
>  		goto out;
>  	}

