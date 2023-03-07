Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 346826AF1F7
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbjCGStX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbjCGSsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:48:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89740BC6FC
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 10:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678214162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BnJc5MG7JdlzzId1kCUKmbMnOh+CFlQTvdYpLSVDpQo=;
        b=IgDfJS0EOkp6ynxdI+Le/A6EvHzOK2Jwzn1qsqhjio75pHmF68EzDZ5AJybl9iKtZacXcU
        +KDQo2/p6IMHMchMQkZdOw6dcmBHuqk0u9SpQWEQAALw20qms/+wbckja0IKjelLz9D0qk
        n+EWz8MPs6ZZN9OsViopexObOJ3yprE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260-zEz54Z38Ovq5fWA-IDoZvA-1; Tue, 07 Mar 2023 13:31:54 -0500
X-MC-Unique: zEz54Z38Ovq5fWA-IDoZvA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 725C185CCE2;
        Tue,  7 Mar 2023 18:31:53 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.32.201])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D493C4010E7B;
        Tue,  7 Mar 2023 18:31:52 +0000 (UTC)
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
Subject: Re: [PATCH nf-next 4/6] netfilter: move br_nf_check_hbh_len to utils
References: <cover.1677888566.git.lucien.xin@gmail.com>
        <84b12a8d761ac804794f6a0e08011eff4c2c0a3a.1677888566.git.lucien.xin@gmail.com>
Date:   Tue, 07 Mar 2023 13:31:52 -0500
In-Reply-To: <84b12a8d761ac804794f6a0e08011eff4c2c0a3a.1677888566.git.lucien.xin@gmail.com>
        (Xin Long's message of "Fri, 3 Mar 2023 19:12:40 -0500")
Message-ID: <f7t356g5s6f.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin Long <lucien.xin@gmail.com> writes:

> Rename br_nf_check_hbh_len() to nf_ip6_check_hbh_len() and move it
> to netfilter utils, so that it can be used by other modules, like
> ovs and tc.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

Reviewed-by: Aaron Conole <aconole@redhat.com>

>  include/linux/netfilter_ipv6.h |  2 ++
>  net/bridge/br_netfilter_ipv6.c | 57 +---------------------------------
>  net/netfilter/utils.c          | 54 ++++++++++++++++++++++++++++++++
>  3 files changed, 57 insertions(+), 56 deletions(-)
>
> diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
> index 48314ade1506..7834c0be2831 100644
> --- a/include/linux/netfilter_ipv6.h
> +++ b/include/linux/netfilter_ipv6.h
> @@ -197,6 +197,8 @@ static inline int nf_cookie_v6_check(const struct ipv6hdr *iph,
>  __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
>  			unsigned int dataoff, u_int8_t protocol);
>  
> +int nf_ip6_check_hbh_len(struct sk_buff *skb, u32 *plen);
> +
>  int ipv6_netfilter_init(void);
>  void ipv6_netfilter_fini(void);
>  
> diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
> index 07289e4f3213..550039dfc31a 100644
> --- a/net/bridge/br_netfilter_ipv6.c
> +++ b/net/bridge/br_netfilter_ipv6.c
> @@ -40,61 +40,6 @@
>  #include <linux/sysctl.h>
>  #endif
>  
> -/* We only check the length. A bridge shouldn't do any hop-by-hop stuff
> - * anyway
> - */
> -static int br_nf_check_hbh_len(struct sk_buff *skb, u32 *plen)
> -{
> -	int len, off = sizeof(struct ipv6hdr);
> -	unsigned char *nh;
> -	u32 pkt_len = 0;
> -
> -	if (!pskb_may_pull(skb, off + 8))
> -		return -1;
> -	nh = (u8 *)(ipv6_hdr(skb) + 1);
> -	len = (nh[1] + 1) << 3;
> -
> -	if (!pskb_may_pull(skb, off + len))
> -		return -1;
> -	nh = skb_network_header(skb);
> -
> -	off += 2;
> -	len -= 2;
> -	while (len > 0) {
> -		int optlen;
> -
> -		if (nh[off] == IPV6_TLV_PAD1) {
> -			off++;
> -			len--;
> -			continue;
> -		}
> -		if (len < 2)
> -			return -1;
> -		optlen = nh[off + 1] + 2;
> -		if (optlen > len)
> -			return -1;
> -
> -		if (nh[off] == IPV6_TLV_JUMBO) {
> -			if (nh[off + 1] != 4 || (off & 3) != 2)
> -				return -1;
> -			pkt_len = ntohl(*(__be32 *)(nh + off + 2));
> -			if (pkt_len <= IPV6_MAXPLEN ||
> -			    ipv6_hdr(skb)->payload_len)
> -				return -1;
> -			if (pkt_len > skb->len - sizeof(struct ipv6hdr))
> -				return -1;
> -		}
> -		off += optlen;
> -		len -= optlen;
> -	}
> -	if (len)
> -		return -1;
> -
> -	if (pkt_len)
> -		*plen = pkt_len;
> -	return 0;
> -}
> -
>  int br_validate_ipv6(struct net *net, struct sk_buff *skb)
>  {
>  	const struct ipv6hdr *hdr;
> @@ -114,7 +59,7 @@ int br_validate_ipv6(struct net *net, struct sk_buff *skb)
>  		goto inhdr_error;
>  
>  	pkt_len = ntohs(hdr->payload_len);
> -	if (hdr->nexthdr == NEXTHDR_HOP && br_nf_check_hbh_len(skb, &pkt_len))
> +	if (hdr->nexthdr == NEXTHDR_HOP && nf_ip6_check_hbh_len(skb, &pkt_len))
>  		goto drop;
>  
>  	if (pkt_len + ip6h_len > skb->len) {
> diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
> index 2182d361e273..04f4bd661774 100644
> --- a/net/netfilter/utils.c
> +++ b/net/netfilter/utils.c
> @@ -215,3 +215,57 @@ int nf_reroute(struct sk_buff *skb, struct nf_queue_entry *entry)
>  	}
>  	return ret;
>  }
> +
> +/* Only get and check the lengths, not do any hop-by-hop stuff. */
> +int nf_ip6_check_hbh_len(struct sk_buff *skb, u32 *plen)
> +{
> +	int len, off = sizeof(struct ipv6hdr);
> +	unsigned char *nh;
> +	u32 pkt_len = 0;
> +
> +	if (!pskb_may_pull(skb, off + 8))
> +		return -ENOMEM;
> +	nh = (u8 *)(ipv6_hdr(skb) + 1);
> +	len = (nh[1] + 1) << 3;
> +
> +	if (!pskb_may_pull(skb, off + len))
> +		return -ENOMEM;
> +	nh = skb_network_header(skb);
> +
> +	off += 2;
> +	len -= 2;
> +	while (len > 0) {
> +		int optlen;
> +
> +		if (nh[off] == IPV6_TLV_PAD1) {
> +			off++;
> +			len--;
> +			continue;
> +		}
> +		if (len < 2)
> +			return -EBADMSG;
> +		optlen = nh[off + 1] + 2;
> +		if (optlen > len)
> +			return -EBADMSG;
> +
> +		if (nh[off] == IPV6_TLV_JUMBO) {
> +			if (nh[off + 1] != 4 || (off & 3) != 2)
> +				return -EBADMSG;
> +			pkt_len = ntohl(*(__be32 *)(nh + off + 2));
> +			if (pkt_len <= IPV6_MAXPLEN ||
> +			    ipv6_hdr(skb)->payload_len)
> +				return -EBADMSG;
> +			if (pkt_len > skb->len - sizeof(struct ipv6hdr))
> +				return -EBADMSG;
> +		}
> +		off += optlen;
> +		len -= optlen;
> +	}
> +	if (len)
> +		return -EBADMSG;
> +
> +	if (pkt_len)
> +		*plen = pkt_len;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(nf_ip6_check_hbh_len);

