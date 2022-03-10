Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05554D45AD
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 12:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241593AbiCJLb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 06:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240349AbiCJLbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 06:31:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 56B8A141FC5
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 03:30:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646911853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DBExlLjpskpVeXqiYBMCamA2w6IO4jute6crnMTjK+E=;
        b=cCK5ivRuBR1LxNYtaoXe2YA02gET+r5frl8Vyzq8QIHYztEpG4atUoNx0VIUrGkHaUbWF2
        a2/cqBQF3CfYK3r/2vfJdQfkKd7hhaPqO3CeiT33p6rrr+JK0pKcb/nrdlz9fMoOfMGXL5
        EwXUvWcWNVoeJGkGCNtT7aVG4Sqxe7E=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-zJWaqtiXMbqK7K9SmoXMKg-1; Thu, 10 Mar 2022 06:30:52 -0500
X-MC-Unique: zJWaqtiXMbqK7K9SmoXMKg-1
Received: by mail-ej1-f69.google.com with SMTP id 13-20020a170906328d00b006982d0888a4so2927982ejw.9
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 03:30:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=DBExlLjpskpVeXqiYBMCamA2w6IO4jute6crnMTjK+E=;
        b=57JhNoqnzzRgafO1Lh+hkYNF6tRhprNz1U3bV4KQipr0TlSB7yNaBekDMKST9RTgjE
         fSpwIeM7gZE7p1dRAMP4h7bvNGXtmyTTdrSYQT21jbTeyunjns/IK+vCzkMfDaUrfky7
         RfnBQF8Ei3TZWmFQepFglufio1vLYmgAbsAdevFOrkRRHcUXNtPPjoGk+po0zuC8iM53
         dp8f8izca+UAF1YcLbMmUGL7ytyL1M6a9Zae3OiCElqLUnbC0RB6fBVbVve56CAKoQas
         Er3uFFaPzAepn/3VnODW8mWRyre5JMtsvq6dZe/sQL/7++niPYgenp9KvyyMsOH3tqSe
         f4VA==
X-Gm-Message-State: AOAM533gLQObHgc5+BaRiKplAPQYp2QptLIV4NZkbD6iRNW3QaKwiEN5
        +yVI0gqiVufwA8gxGGfUhesFNa/cwfXhuHXRjgwxMsO4/lEl834bVPN2Xc7wdEYWyp/jfBGkt00
        bzbFLF7EUl8bqFqTN
X-Received: by 2002:a50:fb93:0:b0:416:c4f:bd24 with SMTP id e19-20020a50fb93000000b004160c4fbd24mr3837358edq.225.1646911848963;
        Thu, 10 Mar 2022 03:30:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy936ZsG9FnnDHIskhbLnEfRuA9HX6fFO8ZuZwxURuoNsoErHWOxwLmx59AiFAX+M/19aeCrA==
X-Received: by 2002:a50:fb93:0:b0:416:c4f:bd24 with SMTP id e19-20020a50fb93000000b004160c4fbd24mr3837174edq.225.1646911846358;
        Thu, 10 Mar 2022 03:30:46 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id ee29-20020a056402291d00b00416270eaff5sm1924568edb.1.2022.03.10.03.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 03:30:45 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C6DC4192CD3; Thu, 10 Mar 2022 12:30:44 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, pabeni@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        toshiaki.makita1@gmail.com, andrii@kernel.org
Subject: Re: [PATCH v4 bpf-next 3/3] veth: allow jumbo frames in xdp mode
In-Reply-To: <930b1ad3d84f7ca5a41ba75571f9146a932c5394.1646755129.git.lorenzo@kernel.org>
References: <cover.1646755129.git.lorenzo@kernel.org>
 <930b1ad3d84f7ca5a41ba75571f9146a932c5394.1646755129.git.lorenzo@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 10 Mar 2022 12:30:44 +0100
Message-ID: <87bkyeujrv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> writes:

> Allow increasing the MTU over page boundaries on veth devices
> if the attached xdp program declares to support xdp fragments.
> Enable NETIF_F_ALL_TSO when the device is running in xdp mode.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/veth.c | 28 +++++++++++++++++-----------
>  1 file changed, 17 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 47b21b1d2fd9..c5a2dc2b2e4b 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -293,8 +293,7 @@ static int veth_forward_skb(struct net_device *dev, struct sk_buff *skb,
>  /* return true if the specified skb has chances of GRO aggregation
>   * Don't strive for accuracy, but try to avoid GRO overhead in the most
>   * common scenarios.
> - * When XDP is enabled, all traffic is considered eligible, as the xmit
> - * device has TSO off.
> + * When XDP is enabled, all traffic is considered eligible.
>   * When TSO is enabled on the xmit device, we are likely interested only
>   * in UDP aggregation, explicitly check for that if the skb is suspected
>   * - the sock_wfree destructor is used by UDP, ICMP and XDP sockets -
> @@ -302,11 +301,13 @@ static int veth_forward_skb(struct net_device *dev, struct sk_buff *skb,
>   */
>  static bool veth_skb_is_eligible_for_gro(const struct net_device *dev,
>  					 const struct net_device *rcv,
> +					 const struct veth_rq *rq,
>  					 const struct sk_buff *skb)
>  {
> -	return !(dev->features & NETIF_F_ALL_TSO) ||
> -		(skb->destructor == sock_wfree &&
> -		 rcv->features & (NETIF_F_GRO_FRAGLIST | NETIF_F_GRO_UDP_FWD));
> +	return rcu_access_pointer(rq->xdp_prog) ||
> +	       !(dev->features & NETIF_F_ALL_TSO) ||
> +	       (skb->destructor == sock_wfree &&
> +		rcv->features & (NETIF_F_GRO_FRAGLIST | NETIF_F_GRO_UDP_FWD));
>  }
>  
>  static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
> @@ -335,7 +336,7 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
>  		 * Don't bother with napi/GRO if the skb can't be aggregated
>  		 */
>  		use_napi = rcu_access_pointer(rq->napi) &&
> -			   veth_skb_is_eligible_for_gro(dev, rcv, skb);
> +			   veth_skb_is_eligible_for_gro(dev, rcv, rq, skb);
>  	}
>  
>  	skb_tx_timestamp(skb);
> @@ -1525,9 +1526,14 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>  			goto err;
>  		}
>  
> -		max_mtu = PAGE_SIZE - VETH_XDP_HEADROOM -
> -			  peer->hard_header_len -
> -			  SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +		max_mtu = SKB_WITH_OVERHEAD(PAGE_SIZE - VETH_XDP_HEADROOM) -
> +			  peer->hard_header_len;

Why are we no longer accounting the size of the skb_shared_info if the
program doesn't support frags?

> +		/* Allow increasing the max_mtu if the program supports
> +		 * XDP fragments.
> +		 */
> +		if (prog->aux->xdp_has_frags)
> +			max_mtu += PAGE_SIZE * MAX_SKB_FRAGS;
> +
>  		if (peer->mtu > max_mtu) {
>  			NL_SET_ERR_MSG_MOD(extack, "Peer MTU is too large to set XDP");
>  			err = -ERANGE;
> @@ -1549,7 +1555,7 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>  		}
>  
>  		if (!old_prog) {
> -			peer->hw_features &= ~NETIF_F_GSO_SOFTWARE;
> +			peer->hw_features &= ~NETIF_F_GSO_FRAGLIST;

The patch description says we're enabling TSO, but this change enables a
couple of other flags as well. Also, it's not quite obvious to me why
your change makes this possible? Is it because we can now execute XDP on
a full TSO packet at once? Because then this should be coupled to the
xdp_has_frags flag of the XDP program? Or will the TSO packet be
segmented before it hits the XDP program? But then this change has
nothing to do with the rest of your series?

Please also add this explanation to the commit message :)

-Toke

