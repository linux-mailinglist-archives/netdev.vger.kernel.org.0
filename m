Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750856AF235
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233266AbjCGSvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:51:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbjCGSux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:50:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0988A1889
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 10:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678214269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UA6GVI9HVyF8oMQ333Rczj5g5DIVDiblZ9QPtMRHDjI=;
        b=ICDyTLDmOP/rSFJwmZU+KajEGzY8JosAOx8xHkiknygY0Bwr1Vdkma3fLwytZsaS2pS3J6
        TAueSqcyWNp221EFDhuWGOu4L5bjsbptQ14BidYWCJqUxoO6KNWiSG0D1Jxo8SlZRo9q2M
        WAorepUHQonJ3OLdKqYzNdrS2wjPkJk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-gOW5cVuOOe2nvKJymIiDRw-1; Tue, 07 Mar 2023 13:31:38 -0500
X-MC-Unique: gOW5cVuOOe2nvKJymIiDRw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E296858F0E;
        Tue,  7 Mar 2023 18:31:37 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.32.201])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AC9F492C18;
        Tue,  7 Mar 2023 18:31:37 +0000 (UTC)
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
Subject: Re: [PATCH nf-next 5/6] netfilter: use nf_ip6_check_hbh_len in
 nf_ct_skb_network_trim
References: <cover.1677888566.git.lucien.xin@gmail.com>
        <5411027934a79f0430edb905ad4b434ec6b8396e.1677888566.git.lucien.xin@gmail.com>
Date:   Tue, 07 Mar 2023 13:31:31 -0500
In-Reply-To: <5411027934a79f0430edb905ad4b434ec6b8396e.1677888566.git.lucien.xin@gmail.com>
        (Xin Long's message of "Fri, 3 Mar 2023 19:12:41 -0500")
Message-ID: <f7t7cvs5s70.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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

> For IPv6 Jumbo packets, the ipv6_hdr(skb)->payload_len is always 0,
> and its real payload_len ( > 65535) is saved in hbh exthdr. With 0
> length for the jumbo packets, all data and exthdr will be trimmed
> in nf_ct_skb_network_trim().
>
> This patch is to call nf_ip6_check_hbh_len() to get real pkt_len
> of the IPv6 packet, similar to br_validate_ipv6().
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

Reviewed-by: Aaron Conole <aconole@redhat.com>

>  net/netfilter/nf_conntrack_ovs.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/net/netfilter/nf_conntrack_ovs.c b/net/netfilter/nf_conntrack_ovs.c
> index 52b776bdf526..2016a3b05f86 100644
> --- a/net/netfilter/nf_conntrack_ovs.c
> +++ b/net/netfilter/nf_conntrack_ovs.c
> @@ -6,6 +6,7 @@
>  #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
>  #include <net/ipv6_frag.h>
>  #include <net/ip.h>
> +#include <linux/netfilter_ipv6.h>
>  
>  /* 'skb' should already be pulled to nh_ofs. */
>  int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
> @@ -114,14 +115,20 @@ EXPORT_SYMBOL_GPL(nf_ct_add_helper);
>  int nf_ct_skb_network_trim(struct sk_buff *skb, int family)
>  {
>  	unsigned int len;
> +	int err;
>  
>  	switch (family) {
>  	case NFPROTO_IPV4:
>  		len = skb_ip_totlen(skb);
>  		break;
>  	case NFPROTO_IPV6:
> -		len = sizeof(struct ipv6hdr)
> -			+ ntohs(ipv6_hdr(skb)->payload_len);
> +		len = ntohs(ipv6_hdr(skb)->payload_len);
> +		if (ipv6_hdr(skb)->nexthdr == NEXTHDR_HOP) {
> +			err = nf_ip6_check_hbh_len(skb, &len);
> +			if (err)
> +				return err;
> +		}
> +		len += sizeof(struct ipv6hdr);
>  		break;
>  	default:
>  		len = skb->len;

