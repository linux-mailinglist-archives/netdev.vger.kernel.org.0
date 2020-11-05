Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608612A7C8A
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 12:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgKELEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 06:04:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27805 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725827AbgKELEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 06:04:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604574243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qKwC5oYtZeyEk6aZcV8s9CkbpjIS4Ri4uRpxpj9enZo=;
        b=cWT1Jq3DiVtbKJBty2wfu7bgFIp/rlYNCgu8JRZVBX1kD6nVsZrG1FEiNJUJs214WoMb1g
        KQxlJFwRr5SIQzyeyuuuf6lZ6w4tRpHf+qC3zPFM3LmyqYtudeZ9+I3B7eAMAJ/qMXiJac
        ESJJTBWJAKNMBYF+ION6i4fG/vrL5oc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-xHX6SLAaN2ymihpa-tEFvg-1; Thu, 05 Nov 2020 06:03:59 -0500
X-MC-Unique: xHX6SLAaN2ymihpa-tEFvg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 277841006C9C;
        Thu,  5 Nov 2020 11:03:58 +0000 (UTC)
Received: from [10.40.193.36] (unknown [10.40.193.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F407E5DA6B;
        Thu,  5 Nov 2020 11:03:56 +0000 (UTC)
Message-ID: <b3713e6060246fd1649643fe29df8968be2fbbaa.camel@redhat.com>
Subject: Re: [PATCH v3 net-next 2/2] net/sched: act_frag: add implict
 packet fragment support.
From:   Davide Caratti <dcaratti@redhat.com>
To:     wenxu@ucloud.cn, kuba@kernel.org, marcelo.leitner@gmail.com
Cc:     netdev@vger.kernel.org
In-Reply-To: <1604572893-16156-2-git-send-email-wenxu@ucloud.cn>
References: <1604572893-16156-1-git-send-email-wenxu@ucloud.cn>
         <1604572893-16156-2-git-send-email-wenxu@ucloud.cn>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Thu, 05 Nov 2020 12:03:55 +0100
MIME-Version: 1.0
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello wenxu!

On Thu, 2020-11-05 at 18:41 +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Currently kernel tc subsystem can do conntrack in act_ct. But when several
> fragment packets go through the act_ct, function tcf_ct_handle_fragments
> will defrag the packets to a big one. But the last action will redirect
> mirred to a device which maybe lead the reassembly big packet over the mtu
> of target device.
> 
> This patch add support for a xmit hook to mirred, that gets executed before
> xmiting the packet. Then, when act_ct gets loaded, it configs that hook.
> The frag xmit hook maybe reused by other modules.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---

[...]

> +
> +static int tcf_fragment(struct net *net, struct sk_buff *skb,
> +			u16 mru, int (*xmit)(struct sk_buff *skb))
> +{
> +	if (skb_network_offset(skb) > VLAN_ETH_HLEN) {
> +		net_warn_ratelimited("L2 header too long to fragment\n");
> +		goto err;
> +	}
> +
> +	if (skb->protocol == htons(ETH_P_IP)) {

small nit: use of skb->protocol here may lead to "ambiguous" results: a
VLAN "accelerated" packet is properly processed, while the same VLAN
packet with "non-accelerated" tag is not processed because skb->protocol
is htons(ETH_P_8021Q). Can I suggest use of skb_protocol(), that has
been introduced recently by Toke [1] ?

> +		ip_do_fragment(net, skb->sk, skb, tcf_frag_xmit);
> +		refdst_drop(orig_dst);
> +	} else if (skb->protocol == htons(ETH_P_IPV6)) {

same here,

> +		unsigned long orig_dst;
> +		struct rt6_info tcf_frag_rt;
> +
> +		tcf_frag_prepare_frag(skb, xmit);
> +		memset(&tcf_frag_rt, 0, sizeof(tcf_frag_rt));
> +		dst_init(&tcf_frag_rt.dst, &tcf_frag_dst_ops, NULL, 1,
> +			 DST_OBSOLETE_NONE, DST_NOCOUNT);
> +		tcf_frag_rt.dst.dev = skb->dev;
> +
> +		orig_dst = skb->_skb_refdst;
> +		skb_dst_set_noref(skb, &tcf_frag_rt.dst);
> +		IP6CB(skb)->frag_max_size = mru;
> +
> +		ipv6_stub->ipv6_fragment(net, skb->sk, skb, tcf_frag_xmit);
> +		refdst_drop(orig_dst);
> +	} else {
> +		net_warn_ratelimited("Failed fragment ->%s: eth=%04x, MRU=%d, MTU=%d.\n",
> +				     netdev_name(skb->dev), ntohs(skb->protocol),
> +				     mru, skb->dev->mtu);

and here (even though it's just a printout).


thanks!
-- 
davide

[1] https://lore.kernel.org/netdev/20200707110325.86731-1-toke@redhat.com/

