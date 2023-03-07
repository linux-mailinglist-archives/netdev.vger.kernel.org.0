Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603956AF1B6
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233249AbjCGSqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:46:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbjCGSqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:46:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C55B78BB
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 10:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678213997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IYcpmbNmD+ppUYYsUdIFEHZgjqXqKhESFZ61WVHPzOE=;
        b=gNvWUFYmqtpIRDom3yGb9EhjFYnE8bXuqUDoda2+gMsF08OEU2PAMLOMePDUfc6QfWIq4g
        q5ay0w/0/+py5p0RXHiBvPtuz5TeXk21wksqhFq1A2jgN3J1peeyUFdX76ketPSHSkqMzz
        FBEQvIEAeckdTgQ/y3wbhHsYP3BdHRc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-714dGVqfPdedlIo5ZvnLRg-1; Tue, 07 Mar 2023 13:33:16 -0500
X-MC-Unique: 714dGVqfPdedlIo5ZvnLRg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4B6985A5A3;
        Tue,  7 Mar 2023 18:33:15 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.32.201])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DB4304010E7B;
        Tue,  7 Mar 2023 18:33:14 +0000 (UTC)
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
Subject: Re: [PATCH nf-next 1/6] netfilter: bridge: call pskb_may_pull in
 br_nf_check_hbh_len
References: <cover.1677888566.git.lucien.xin@gmail.com>
        <4c156bee64fa58bacb808cead7a7f43d531fd587.1677888566.git.lucien.xin@gmail.com>
Date:   Tue, 07 Mar 2023 13:33:14 -0500
In-Reply-To: <4c156bee64fa58bacb808cead7a7f43d531fd587.1677888566.git.lucien.xin@gmail.com>
        (Xin Long's message of "Fri, 3 Mar 2023 19:12:37 -0500")
Message-ID: <f7tpm9k4djp.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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

> When checking Hop-by-hop option header, if the option data is in
> nonlinear area, it should do pskb_may_pull instead of discarding
> the skb as a bad IPv6 packet.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

Reviewed-by: Aaron Conole <aconole@redhat.com>

>  net/bridge/br_netfilter_ipv6.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
> index 6b07f30675bb..5cd3e4c35123 100644
> --- a/net/bridge/br_netfilter_ipv6.c
> +++ b/net/bridge/br_netfilter_ipv6.c
> @@ -45,14 +45,18 @@
>   */
>  static int br_nf_check_hbh_len(struct sk_buff *skb)
>  {
> -	unsigned char *raw = (u8 *)(ipv6_hdr(skb) + 1);
> +	int len, off = sizeof(struct ipv6hdr);
> +	unsigned char *nh;
>  	u32 pkt_len;
> -	const unsigned char *nh = skb_network_header(skb);
> -	int off = raw - nh;
> -	int len = (raw[1] + 1) << 3;
>  
> -	if ((raw + len) - skb->data > skb_headlen(skb))
> +	if (!pskb_may_pull(skb, off + 8))
>  		goto bad;
> +	nh = (u8 *)(ipv6_hdr(skb) + 1);
> +	len = (nh[1] + 1) << 3;
> +
> +	if (!pskb_may_pull(skb, off + len))
> +		goto bad;
> +	nh = skb_network_header(skb);
>  
>  	off += 2;
>  	len -= 2;

