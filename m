Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98EFF6465E6
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 01:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiLHAdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 19:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiLHAdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 19:33:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35378D65E;
        Wed,  7 Dec 2022 16:33:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75E0DB81C57;
        Thu,  8 Dec 2022 00:33:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2499C433C1;
        Thu,  8 Dec 2022 00:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670459580;
        bh=aERxJVK9LoSfFhjpfc9CEj7Hfvg3pTGFz3M0Px/sXYI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zd3BfIh7CG0K8SLra+kRrexs7FTQsrK/eqrxe/Xv1h+gJkb8YrMbRuryCDeWLoxxo
         TVxBAa5CPdqVrtHrSny3XIFghSggD97vCducfp1P+q8RTemBt/5dASbyx/ZRHllhFq
         TgJcBL9fR6EwHLnBYm3+NJHBx1tV2fgdMVPh/qYnWur3hV1saA5aMKsIym4WdzGamc
         mIcqPscfHDVSObcE0Duezr3y5QRwKyO1UVnT1BLNDP0CmAqESH5Ad/pnbemJ70BSDm
         ZNrJOAYAuDwZ7tTI7o90PtgR/AD154vBaQQW9Kyj+HWz2fqY27l2wh/9G+YBMRM5c4
         MQ1xphWsJQwWA==
Date:   Wed, 7 Dec 2022 16:32:58 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Coco Li <lixiaoyan@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next v5 2/2] bnxt: Use generic HBH removal helper in tx
 path
Message-ID: <Y5EwunX89Nq59vf0@x130>
References: <20221207225435.1273226-1-lixiaoyan@google.com>
 <20221207225435.1273226-2-lixiaoyan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221207225435.1273226-2-lixiaoyan@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 07 Dec 14:54, Coco Li wrote:
>Eric Dumazet implemented Big TCP that allowed bigger TSO/GRO packet sizes
>for IPv6 traffic. See patch series:
>'commit 89527be8d8d6 ("net: add IFLA_TSO_{MAX_SIZE|SEGS} attributes")'
>
>This reduces the number of packets traversing the networking stack and
>should usually improves performance. However, it also inserts a
>temporary Hop-by-hop IPv6 extension header.
>
>Using the HBH header removal method in the previous path, the extra header
                                                      ^ patch
>be removed in bnxt drivers to allow it to send big TCP packets (bigger
>TSO packets) as well.
>

I think Eric didn't expose this function because it isn't efficient for
drivers who are already processing the headers separately from payload for
LSO packets .. the trick is to have an optimized copy method depending on
your driver xmit function, usually you would just memcpy the TCP header over
the HBH exactly at the point you copy/process those headers into the HW
descriptor.

>Tested:
>Compiled locally
>
>To further test functional correctness, update the GSO/GRO limit on the
>physical NIC:
>
>ip link set eth0 gso_max_size 181000
>ip link set eth0 gro_max_size 181000
>
>Note that if there are bonding or ipvan devices on top of the physical
>NIC, their GSO sizes need to be updated as well.
>
>Then, IPv6/TCP packets with sizes larger than 64k can be observed.
>
>Big TCP functionality is tested by Michael, feature checks not yet.
>
>Tested by Michael:
>I've confirmed with our hardware team that this is supported by our
>chips, and I've tested it up to gso_max_size of 524280.  Thanks.
>
>Tested-by: Michael Chan <michael.chan@broadcom.com>
>Reviewed-by: Michael Chan <michael.chan@broadcom.com>
>Signed-off-by: Coco Li <lixiaoyan@google.com>
>---
> drivers/net/ethernet/broadcom/bnxt/bnxt.c | 26 ++++++++++++++++++++++-
> 1 file changed, 25 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
>index 0fe164b42c5d..6ba1cd342a80 100644
>--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
>+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
>@@ -389,6 +389,9 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
> 			return NETDEV_TX_BUSY;
> 	}
>
>+	if (unlikely(ipv6_hopopt_jumbo_remove(skb)))
>+		goto tx_free;
>+
> 	length = skb->len;
> 	len = skb_headlen(skb);
> 	last_frag = skb_shinfo(skb)->nr_frags;
>@@ -11315,6 +11318,7 @@ static bool bnxt_exthdr_check(struct bnxt *bp, struct sk_buff *skb, int nw_off,
> 			      u8 **nextp)
> {
> 	struct ipv6hdr *ip6h = (struct ipv6hdr *)(skb->data + nw_off);
>+	struct hop_jumbo_hdr *jhdr;
> 	int hdr_count = 0;
> 	u8 *nexthdr;
> 	int start;
>@@ -11342,9 +11346,27 @@ static bool bnxt_exthdr_check(struct bnxt *bp, struct sk_buff *skb, int nw_off,
>
> 		if (hdrlen > 64)
> 			return false;
>+
>+		/* The ext header may be a hop-by-hop header inserted for
>+		 * big TCP purposes. This will be removed before sending
>+		 * from NIC, so do not count it.
>+		 */
>+		if (*nexthdr == NEXTHDR_HOP) {
>+			if (likely(skb->len <= GRO_LEGACY_MAX_SIZE))
>+				goto increment_hdr;
>+
>+			jhdr = (struct hop_jumbo_hdr *)nexthdr;
>+			if (jhdr->tlv_type != IPV6_TLV_JUMBO || jhdr->hdrlen != 0 ||
>+			    jhdr->nexthdr != IPPROTO_TCP)
>+				goto increment_hdr;
>+
>+			goto next_hdr;
>+		}
>+increment_hdr:
>+		hdr_count++;
>+next_hdr:
> 		nexthdr = &hp->nexthdr;
> 		start += hdrlen;
>-		hdr_count++;
> 	}
> 	if (nextp) {
> 		/* Caller will check inner protocol */
>@@ -13657,6 +13679,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> 		dev->features &= ~NETIF_F_LRO;
> 	dev->priv_flags |= IFF_UNICAST_FLT;
>
>+	netif_set_tso_max_size(dev, GSO_MAX_SIZE);
>+
> #ifdef CONFIG_BNXT_SRIOV
> 	init_waitqueue_head(&bp->sriov_cfg_wait);
> #endif
>-- 
>2.39.0.rc0.267.gcb52ba06e7-goog
>
