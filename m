Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECCB15B1167
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 02:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiIHAlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 20:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiIHAlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 20:41:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD10A287A;
        Wed,  7 Sep 2022 17:40:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE209610A6;
        Thu,  8 Sep 2022 00:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96374C433D6;
        Thu,  8 Sep 2022 00:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662597658;
        bh=8nHfraft5uM1bANg22z1Icv/Joe/Mli5tnGpmBVUDJY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=mBW8jT9kUvPR7q2CxAOB5JSvOvMoe8c4841tg/x9OVDXB1oMel0U0/RwIc7Q9nBv1
         JJlm5M+gmtogRJZ65jXldSDew3JD0t5rhNggAs6MxgZw7ox4zdH+RF+DKu7mtA2a6U
         o9kj7P9mpyHStnGzm6kPpdaPLWPAcgZ6NT3SwlpuywtlXAD1vc5/JDhsxXa/l4XA7S
         kvM6fE5WXebAHsjQnMv3I7jhc/ffE6z0bGYC7j3by6wFXwPqXxnYDkilG9xUBByGXk
         SEjSN3Ebi0cuSuhAFzKN6L3QElweQhsGtP6rLlFiVpG1L/mIrIJ7bEOi12dHbxktSC
         wx9moGxacVBIg==
Message-ID: <f59a8400-54ba-62eb-2e9b-b8a6b7533f90@kernel.org>
Date:   Wed, 7 Sep 2022 18:40:56 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v3 1/6] udp: allow header check for dodgy GSO_UDP_L4
 packets.
Content-Language: en-US
To:     Andrew Melnychenko <andrew@daynix.com>, edumazet@google.com,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, mst@redhat.com, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
References: <20220907125048.396126-1-andrew@daynix.com>
 <20220907125048.396126-2-andrew@daynix.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220907125048.396126-2-andrew@daynix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-11.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/22 6:50 AM, Andrew Melnychenko wrote:
> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index 6d1a4bec2614..8e002419b4d5 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -387,7 +387,7 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
>  	if (!pskb_may_pull(skb, sizeof(struct udphdr)))
>  		goto out;
>  
> -	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
> +	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4 && !skb_gso_ok(skb, features | NETIF_F_GSO_ROBUST))

that line needs to be wrapped.

>  		return __udp_gso_segment(skb, features, false);
>  
>  	mss = skb_shinfo(skb)->gso_size;

