Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C70B4F5EB7
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbiDFNFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbiDFNFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:05:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF343A1069;
        Tue,  5 Apr 2022 18:25:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66355B8203B;
        Wed,  6 Apr 2022 01:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C03C385A0;
        Wed,  6 Apr 2022 01:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649208317;
        bh=AtPl7j1FF7B7J/OEKjtzhOhaatn8aGKD5EedvEowc9A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ICRE4EkXoAcYXSy6dlr64+g8iuxWN4dgB46QvVguvImBFQ08ycZUAl1zDPm61Kl1a
         O/P0XPYs8lylIglx5W5pJjEevojhA5AcSr21KX/XVkjmcNV6q+b/MkdplkLZiMpYcn
         8zv2l7L08ayhBIuezLr10AkYncjZZaSLH3uuxFxrL1blj8FBudIKKzZAnKDxDvP8P/
         4U8rywsD44dFdt48ooQ79WXNTYG4Dz+rlPCYQ+WlNA5C5dPOzym4YymqEhc/EfWy26
         jO6kTYkGUOcStjxKhEoeX436gDbhPJ6hYxAHmd9bZSahGfGqa3zBnR70+xAtUTE7WY
         wI4glUD3o03KQ==
Date:   Tue, 5 Apr 2022 18:25:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     christopher.lee@cspi.com, davem@davemloft.net, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH v2] myri10ge: remove an unneeded NULL check
Message-ID: <20220405182514.40fae2d0@kernel.org>
In-Reply-To: <20220405000553.21856-1-xiam0nd.tong@gmail.com>
References: <20220405000553.21856-1-xiam0nd.tong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 Apr 2022 08:05:53 +0800 Xiaomeng Tong wrote:
> The define of skb_list_walk_safe(first, skb, next_skb) is:
>   for ((skb) = (first), (next_skb) = (skb) ? (skb)->next : NULL; (skb);  \
>      (skb) = (next_skb), (next_skb) = (skb) ? (skb)->next : NULL)
> 
> Thus, if the 'segs' passed as 'first' into the skb_list_walk_safe is NULL,
> the loop will exit immediately. In other words, it can be sure the 'segs'
> is non-NULL when we run inside the loop. So just remove the unnecessary
> NULL check. Also remove the unneeded assignmnets.
> 
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>

The existing code is pretty clearly buggy. Please fix the bugs or don't
touch it. You're obfuscating what the original intention was.

> diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
> index 50ac3ee2577a..071657e3dba8 100644
> --- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
> +++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
> @@ -2903,12 +2903,8 @@ static netdev_tx_t myri10ge_sw_tso(struct sk_buff *skb,
>  		status = myri10ge_xmit(curr, dev);
>  		if (status != 0) {
>  			dev_kfree_skb_any(curr);
> -			if (segs != NULL) {
> -				curr = segs;
> -				segs = next;
> -				curr->next = NULL;
> -				dev_kfree_skb_any(segs);
> -			}
> +			segs->next = NULL;
> +			dev_kfree_skb_any(next);
>  			goto drop;
>  		}
>  	}

