Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 666BA4BF0B3
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239644AbiBVDRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:17:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbiBVDR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:17:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E80F73;
        Mon, 21 Feb 2022 19:17:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F413A6153A;
        Tue, 22 Feb 2022 03:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72330C340E9;
        Tue, 22 Feb 2022 03:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645499823;
        bh=PKBBWoJHEdek5EsBFKqZ6igV/TupZdAvdOe6PE0gyw0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=mvnBYmEIqZ099xyaakZfQ7lZBF3y3SJUbgzGNgWWVUx9qpZ/eHm5DlPxSqfrjmFAQ
         7kyBb3xU3C8L2ztBelJJzFl0kvZhVlc4Oxo0wSmCGOa1azeWBXdsob+wrTWKAfhFp+
         bGURWQot94oaniP+4/ZkyoHPrTihn0TKgrb7f/yJTxPnvrMR9g8cmESZ6AbeojS9MT
         bV4xpAGvIWgnNVDz3gzkKhpcARqVSBSqqsjQoPFDN4D06QqSYLxlyOuQgjSo+V/Den
         nJvNIc4ku1s3hsJMpafSaDn5B0SeQNmgM+oSqOBpJ4NFuw5XBv37wz8EPvAUV6zP6W
         5L6ZUDdTbFFvQ==
Message-ID: <2969b15c-b825-3b0e-2ad7-00633ee6815b@kernel.org>
Date:   Mon, 21 Feb 2022 20:17:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next 2/3] net: neigh: use kfree_skb_reason() for
 __neigh_event_send()
Content-Language: en-US
To:     menglong8.dong@gmail.com, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, imagedong@tencent.com,
        edumazet@google.com, alobakin@pm.me, cong.wang@bytedance.com,
        paulb@nvidia.com, talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, memxor@gmail.com,
        flyingpeng@tencent.com, mengensun@tencent.com,
        daniel@iogearbox.net, yajun.deng@linux.dev, roopa@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20220220155705.194266-1-imagedong@tencent.com>
 <20220220155705.194266-3-imagedong@tencent.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220220155705.194266-3-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/20/22 8:57 AM, menglong8.dong@gmail.com wrote:
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index c310a4a8fc86..206b66f5ce6b 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -393,6 +393,15 @@ enum skb_drop_reason {
>  					 * see the doc for disable_ipv6
>  					 * in ip-sysctl.rst for detail
>  					 */
> +	SKB_DROP_REASON_NEIGH_FAILED,	/* dropped as the state of
> +					 * neighbour is NUD_FAILED
> +					 */

/* neigh entry in failed state */

> +	SKB_DROP_REASON_NEIGH_QUEUEFULL,	/* the skbs that waiting
> +						 * for sending on the queue
> +						 * of neigh->arp_queue is
> +						 * full, and the skbs on the
> +						 * tail will be dropped
> +						 */

/* arp_queue for neigh entry is full */


> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index ec0bf737b076..c353834e8fa9 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -1171,7 +1171,7 @@ int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb,
>  			neigh->updated = jiffies;
>  			write_unlock_bh(&neigh->lock);
>  
> -			kfree_skb(skb);
> +			kfree_skb_reason(skb, SKB_DROP_REASON_NEIGH_FAILED);
>  			return 1;
>  		}
>  	} else if (neigh->nud_state & NUD_STALE) {
> @@ -1193,7 +1193,7 @@ int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb,
>  				if (!buff)
>  					break;
>  				neigh->arp_queue_len_bytes -= buff->truesize;
> -				kfree_skb(buff);
> +				kfree_skb_reason(buff, SKB_DROP_REASON_NEIGH_QUEUEFULL);
>  				NEIGH_CACHE_STAT_INC(neigh->tbl, unres_discards);
>  			}
>  			skb_dst_force(skb);

what about out_dead: path? the tracepoint there shows that path is of
interest.
