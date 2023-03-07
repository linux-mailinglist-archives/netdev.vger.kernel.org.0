Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9EA26AF196
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbjCGSps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbjCGSpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:45:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348A0A9DC9
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 10:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678213989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2ky9dYKwxEvaHQ/+rcftd+ezGjDIRTSsKEhlT3yu3PY=;
        b=e2CCvezIE60CsWy7sdzu6wyH1vu2cIcMB5myvuT2QPhRfPBWt5lHCuAfBO0OnqW/m0EC1k
        eLlSm5RENkz1wVG5QQj+pFABy0Fr3OJl4IUD5J/ceswzlb2Eg6uaz4q0MrsWi8mDXP+IVc
        Q3/LQRapfQqS3eBmUpyAK4uPaq19NaI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-tldqTq31Psu876WkwGHu2Q-1; Tue, 07 Mar 2023 13:33:02 -0500
X-MC-Unique: tldqTq31Psu876WkwGHu2Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48997185A794;
        Tue,  7 Mar 2023 18:33:01 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.32.201])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B57762026D68;
        Tue,  7 Mar 2023 18:33:00 +0000 (UTC)
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
Subject: Re: [PATCH nf-next 2/6] netfilter: bridge: check len before
 accessing more nh data
References: <cover.1677888566.git.lucien.xin@gmail.com>
        <e5ea0147b3314ad9db5140c7b307472efbd114bd.1677888566.git.lucien.xin@gmail.com>
Date:   Tue, 07 Mar 2023 13:32:59 -0500
In-Reply-To: <e5ea0147b3314ad9db5140c7b307472efbd114bd.1677888566.git.lucien.xin@gmail.com>
        (Xin Long's message of "Fri, 3 Mar 2023 19:12:38 -0500")
Message-ID: <f7tttyw4dk4.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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

> In the while loop of br_nf_check_hbh_len(), similar to ip6_parse_tlv(),
> before accessing 'nh[off + 1]', it should add a check 'len < 2'; and
> before parsing IPV6_TLV_JUMBO, it should add a check 'optlen > len',
> in case of overflows.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

Reviewed-by: Aaron Conole <aconole@redhat.com>

>  net/bridge/br_netfilter_ipv6.c | 47 ++++++++++++++++------------------
>  1 file changed, 22 insertions(+), 25 deletions(-)
>
> diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
> index 5cd3e4c35123..50f564c33551 100644
> --- a/net/bridge/br_netfilter_ipv6.c
> +++ b/net/bridge/br_netfilter_ipv6.c
> @@ -50,54 +50,51 @@ static int br_nf_check_hbh_len(struct sk_buff *skb)
>  	u32 pkt_len;
>  
>  	if (!pskb_may_pull(skb, off + 8))
> -		goto bad;
> +		return -1;
>  	nh = (u8 *)(ipv6_hdr(skb) + 1);
>  	len = (nh[1] + 1) << 3;
>  
>  	if (!pskb_may_pull(skb, off + len))
> -		goto bad;
> +		return -1;
>  	nh = skb_network_header(skb);
>  
>  	off += 2;
>  	len -= 2;
> -
>  	while (len > 0) {
> -		int optlen = nh[off + 1] + 2;
> -
> -		switch (nh[off]) {
> -		case IPV6_TLV_PAD1:
> -			optlen = 1;
> -			break;
> +		int optlen;
>  
> -		case IPV6_TLV_PADN:
> -			break;
> +		if (nh[off] == IPV6_TLV_PAD1) {
> +			off++;
> +			len--;
> +			continue;
> +		}
> +		if (len < 2)
> +			return -1;
> +		optlen = nh[off + 1] + 2;
> +		if (optlen > len)
> +			return -1;
>  
> -		case IPV6_TLV_JUMBO:
> +		if (nh[off] == IPV6_TLV_JUMBO) {
>  			if (nh[off + 1] != 4 || (off & 3) != 2)
> -				goto bad;
> +				return -1;
>  			pkt_len = ntohl(*(__be32 *)(nh + off + 2));
>  			if (pkt_len <= IPV6_MAXPLEN ||
>  			    ipv6_hdr(skb)->payload_len)
> -				goto bad;
> +				return -1;
>  			if (pkt_len > skb->len - sizeof(struct ipv6hdr))
> -				goto bad;
> +				return -1;
>  			if (pskb_trim_rcsum(skb,
>  					    pkt_len + sizeof(struct ipv6hdr)))
> -				goto bad;
> +				return -1;
>  			nh = skb_network_header(skb);
> -			break;
> -		default:
> -			if (optlen > len)
> -				goto bad;
> -			break;
>  		}
>  		off += optlen;
>  		len -= optlen;
>  	}
> -	if (len == 0)
> -		return 0;
> -bad:
> -	return -1;
> +	if (len)
> +		return -1;
> +
> +	return 0;
>  }
>  
>  int br_validate_ipv6(struct net *net, struct sk_buff *skb)

