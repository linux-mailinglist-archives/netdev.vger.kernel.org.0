Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1E56AF1E7
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbjCGSsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjCGSsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:48:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E38595447
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 10:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678214127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NSH/hWurmj33G6H+JeE+HDAabg7tb0wcjkZnFYtZ2CQ=;
        b=MjjmOKdEPLcM15fNwH9g4oK6PHDOxcqE+bNLkTG56GrfRFAL82eDb1EscYG05hTwU2cFTA
        yIho3rx4+9XfYnYWqD7eQ0m95sD0MIHud8a2LfG93nkZ7w8mTsZaUMFA60lz85WEAnUTwi
        GZVaXATvCZN+v0SGteKgIFpxqLSHyW0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-qocW7hWjO_2B6eM97TpYtw-1; Tue, 07 Mar 2023 13:32:13 -0500
X-MC-Unique: qocW7hWjO_2B6eM97TpYtw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CFE2D384D033;
        Tue,  7 Mar 2023 18:32:11 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.32.201])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E479140EBF4;
        Tue,  7 Mar 2023 18:32:11 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Pravin B Shelar <pshelar@ovn.org>
Subject: Re: [PATCH nf-next 3/6] netfilter: bridge: move pskb_trim_rcsum out
 of br_nf_check_hbh_len
References: <cover.1677888566.git.lucien.xin@gmail.com>
        <688b6037c640efeb6141d4646cc9dc1b657796e7.1677888566.git.lucien.xin@gmail.com>
Date:   Tue, 07 Mar 2023 13:32:10 -0500
In-Reply-To: <688b6037c640efeb6141d4646cc9dc1b657796e7.1677888566.git.lucien.xin@gmail.com>
        (Xin Long's message of "Fri, 3 Mar 2023 19:12:39 -0500")
Message-ID: <f7ty1o84dlh.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin Long <lucien.xin@gmail.com> writes:

> br_nf_check_hbh_len() is a function to check the Hop-by-hop option
> header, and shouldn't do pskb_trim_rcsum() there. This patch is to
> pass pkt_len out to br_validate_ipv6() and do pskb_trim_rcsum()
> after calling br_validate_ipv6() instead.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

Reviewed-by: Aaron Conole <aconole@redhat.com>

>  net/bridge/br_netfilter_ipv6.c | 33 ++++++++++++++-------------------
>  1 file changed, 14 insertions(+), 19 deletions(-)
>
> diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
> index 50f564c33551..07289e4f3213 100644
> --- a/net/bridge/br_netfilter_ipv6.c
> +++ b/net/bridge/br_netfilter_ipv6.c
> @@ -43,11 +43,11 @@
>  /* We only check the length. A bridge shouldn't do any hop-by-hop stuff
>   * anyway
>   */
> -static int br_nf_check_hbh_len(struct sk_buff *skb)
> +static int br_nf_check_hbh_len(struct sk_buff *skb, u32 *plen)
>  {
>  	int len, off = sizeof(struct ipv6hdr);
>  	unsigned char *nh;
> -	u32 pkt_len;
> +	u32 pkt_len = 0;
>  
>  	if (!pskb_may_pull(skb, off + 8))
>  		return -1;
> @@ -83,10 +83,6 @@ static int br_nf_check_hbh_len(struct sk_buff *skb)
>  				return -1;
>  			if (pkt_len > skb->len - sizeof(struct ipv6hdr))
>  				return -1;
> -			if (pskb_trim_rcsum(skb,
> -					    pkt_len + sizeof(struct ipv6hdr)))
> -				return -1;
> -			nh = skb_network_header(skb);
>  		}
>  		off += optlen;
>  		len -= optlen;
> @@ -94,6 +90,8 @@ static int br_nf_check_hbh_len(struct sk_buff *skb)
>  	if (len)
>  		return -1;
>  
> +	if (pkt_len)
> +		*plen = pkt_len;
>  	return 0;
>  }
>  
> @@ -116,22 +114,19 @@ int br_validate_ipv6(struct net *net, struct sk_buff *skb)
>  		goto inhdr_error;
>  
>  	pkt_len = ntohs(hdr->payload_len);
> +	if (hdr->nexthdr == NEXTHDR_HOP && br_nf_check_hbh_len(skb, &pkt_len))
> +		goto drop;
>  
> -	if (pkt_len || hdr->nexthdr != NEXTHDR_HOP) {
> -		if (pkt_len + ip6h_len > skb->len) {
> -			__IP6_INC_STATS(net, idev,
> -					IPSTATS_MIB_INTRUNCATEDPKTS);
> -			goto drop;
> -		}
> -		if (pskb_trim_rcsum(skb, pkt_len + ip6h_len)) {
> -			__IP6_INC_STATS(net, idev,
> -					IPSTATS_MIB_INDISCARDS);
> -			goto drop;
> -		}
> -		hdr = ipv6_hdr(skb);
> +	if (pkt_len + ip6h_len > skb->len) {
> +		__IP6_INC_STATS(net, idev,
> +				IPSTATS_MIB_INTRUNCATEDPKTS);
> +		goto drop;
>  	}
> -	if (hdr->nexthdr == NEXTHDR_HOP && br_nf_check_hbh_len(skb))
> +	if (pskb_trim_rcsum(skb, pkt_len + ip6h_len)) {
> +		__IP6_INC_STATS(net, idev,
> +				IPSTATS_MIB_INDISCARDS);
>  		goto drop;
> +	}
>  
>  	memset(IP6CB(skb), 0, sizeof(struct inet6_skb_parm));
>  	/* No IP options in IPv6 header; however it should be

