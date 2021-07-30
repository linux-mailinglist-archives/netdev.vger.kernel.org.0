Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324203DB79E
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 13:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238623AbhG3LIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 07:08:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238486AbhG3LI3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 07:08:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53B6160FE7;
        Fri, 30 Jul 2021 11:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627643305;
        bh=Z/0iDyHaDNLQbzPjKnr5pF+Kj8Ef43w10O7QtwBtyqw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oPLZUicEg8zSXh7NXEXK2FC0RYiM6H5brE2PJFNaYbhUDW2/TZq3N1Dkzc/ITw7ze
         3gMYPF0H1fH/ERJp28vPl1xfsn6IyjVOQjkdB7kcLpDqL83bco5ZtE19XH5HfedB+Z
         MQaTSHxEtFGw8m/415ZMOMriUElxEwE+HF/Tw657DUI6If/SczAsd0iXXaTRUuYfJd
         Jx8JUlaW714r9MUatm1RAv5vUXuHIB3TpNOrzKvLdv7cHMVzPgFThdUPk4AupnMQpD
         ew0Iyk43+YfpeswuhjPbjwRPvklyppP1FtCX74JjswMIL5ALi8SKLK9k2gs6kG9n7E
         3KhClDgEGr00Q==
Date:   Fri, 30 Jul 2021 04:08:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 2/6] sk_buff: track dst status in slow_gro
Message-ID: <20210730040824.097e0e9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a6d684d37ca7598dc89b1ff886f9b049393f0d99.1627405778.git.pabeni@redhat.com>
References: <cover.1627405778.git.pabeni@redhat.com>
        <a6d684d37ca7598dc89b1ff886f9b049393f0d99.1627405778.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Jul 2021 18:24:00 +0200 Paolo Abeni wrote:
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 3ff18300d210..b1e5bbfcc926 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -992,6 +992,7 @@ static inline struct dst_entry *skb_dst(const struct sk_buff *skb)
>   */
>  static inline void skb_dst_set(struct sk_buff *skb, struct dst_entry *dst)
>  {
> +	skb->slow_gro |= !!dst;
>  	skb->_skb_refdst = (unsigned long)dst;
>  }
>  
> @@ -1008,6 +1009,7 @@ static inline void skb_dst_set(struct sk_buff *skb, struct dst_entry *dst)
>  static inline void skb_dst_set_noref(struct sk_buff *skb, struct dst_entry *dst)
>  {
>  	WARN_ON(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
> +	skb->slow_gro = !!dst;

why is this one = and not |= ?

>  	skb->_skb_refdst = (unsigned long)dst | SKB_DST_NOREF;
>  }
