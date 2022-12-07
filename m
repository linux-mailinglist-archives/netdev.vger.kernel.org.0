Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B5C646458
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 23:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiLGWyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 17:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiLGWyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 17:54:44 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BFC20F4F
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 14:54:43 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-36810cfa61fso200375357b3.6
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 14:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6eA6qqKwG6dZW9afQyr40lctIIKutYT4UeqLtVUnJPg=;
        b=KdmkcfUs9Wx8KNcQPfeWbYT7H7WWFrZ8Ml5GcijxSii2u2vUq6qwZ28Aob1squFjvs
         zHotApR1VCBqi4EO8uIZUCJlBgNPhVjfzX7NGehOXckHoCItsa0htlHiwmtTCl8v4FOI
         MrC5wx8Q3edQimJFQ4ZoitXRJe1MsNR9ftmTsYNHBdUpHKULp+MSHJj8Vp/zoKJqbhji
         tV1BjFxlEFkwlE1rkCyWrMft86K9UKk/E3rGVOC/6Ix3kKPg4+W4CuSkxSFH+9EmqyGl
         5twRLqm7yvGf2dBzZA8RHM1vXXpvPxcbMJfNBMgNnPVQbThGUt2M0/D3RYBrZiOBZ6Tb
         OTZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6eA6qqKwG6dZW9afQyr40lctIIKutYT4UeqLtVUnJPg=;
        b=2eSVYpUz82aIhyIS7OjmribrWBAB9rLr+tsbMlKOyyyEReO3h92G/JcTOSS74tf4Ie
         PR7WcaWYujZcEL7GkrF6naAM3qB8NE2SFPVDm4Qrcc3qHyF8vd3CHG19CqS9+Z+RFAHw
         8GZeRMRrQc1Ca8ljDBD1fidfmaq8Y3qsw/I9t1N2rjJ0wsdm4gGDQv+L2gcqmbUMIdFd
         8+Ah0BdRxabjS4WOSXw3vt48eRMnITSw/EauMSuVJai3ca1WadJpkV8FkM700uV52NDW
         cs73yqzXYi4IF8MZD71hQjXkC4iiGD7Cq2w7iA7Q23t9Pl/RqRUpGHsRHu43XAXXag1k
         ni+w==
X-Gm-Message-State: ANoB5pk/Iue8ZYDNOMgjL01J5mQvim2eTjYvOQtuRPK2SnVhIzEjoOz/
        SPl8S4xfRmlGS0QQQlkqoqSCk8sZ7r6EZDc=
X-Google-Smtp-Source: AA0mqf5S8DtWmHT4Yc0HNTsk+kb/mfkCgjhpNekfH1S//tO6aiOkT3To9phKOAAfSIggZkCWENw94dc43+RPygY=
X-Received: from lixiaoyan-desktop.svl.corp.google.com ([2620:15c:2c4:201:4f64:90f:3bcd:e820])
 (user=lixiaoyan job=sendgmr) by 2002:a05:690c:a84:b0:3ea:454d:d1ee with SMTP
 id ci4-20020a05690c0a8400b003ea454dd1eemr16167530ywb.27.1670453682703; Wed,
 07 Dec 2022 14:54:42 -0800 (PST)
Date:   Wed,  7 Dec 2022 14:54:35 -0800
In-Reply-To: <20221207225435.1273226-1-lixiaoyan@google.com>
Mime-Version: 1.0
References: <20221207225435.1273226-1-lixiaoyan@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221207225435.1273226-2-lixiaoyan@google.com>
Subject: [RFC net-next v5 2/2] bnxt: Use generic HBH removal helper in tx path
From:   Coco Li <lixiaoyan@google.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet implemented Big TCP that allowed bigger TSO/GRO packet sizes
for IPv6 traffic. See patch series:
'commit 89527be8d8d6 ("net: add IFLA_TSO_{MAX_SIZE|SEGS} attributes")'

This reduces the number of packets traversing the networking stack and
should usually improves performance. However, it also inserts a
temporary Hop-by-hop IPv6 extension header.

Using the HBH header removal method in the previous path, the extra header
be removed in bnxt drivers to allow it to send big TCP packets (bigger
TSO packets) as well.

Tested:
Compiled locally

To further test functional correctness, update the GSO/GRO limit on the
physical NIC:

ip link set eth0 gso_max_size 181000
ip link set eth0 gro_max_size 181000

Note that if there are bonding or ipvan devices on top of the physical
NIC, their GSO sizes need to be updated as well.

Then, IPv6/TCP packets with sizes larger than 64k can be observed.

Big TCP functionality is tested by Michael, feature checks not yet.

Tested by Michael:
I've confirmed with our hardware team that this is supported by our
chips, and I've tested it up to gso_max_size of 524280.  Thanks.

Tested-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Coco Li <lixiaoyan@google.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 26 ++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 0fe164b42c5d..6ba1cd342a80 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -389,6 +389,9 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			return NETDEV_TX_BUSY;
 	}
 
+	if (unlikely(ipv6_hopopt_jumbo_remove(skb)))
+		goto tx_free;
+
 	length = skb->len;
 	len = skb_headlen(skb);
 	last_frag = skb_shinfo(skb)->nr_frags;
@@ -11315,6 +11318,7 @@ static bool bnxt_exthdr_check(struct bnxt *bp, struct sk_buff *skb, int nw_off,
 			      u8 **nextp)
 {
 	struct ipv6hdr *ip6h = (struct ipv6hdr *)(skb->data + nw_off);
+	struct hop_jumbo_hdr *jhdr;
 	int hdr_count = 0;
 	u8 *nexthdr;
 	int start;
@@ -11342,9 +11346,27 @@ static bool bnxt_exthdr_check(struct bnxt *bp, struct sk_buff *skb, int nw_off,
 
 		if (hdrlen > 64)
 			return false;
+
+		/* The ext header may be a hop-by-hop header inserted for
+		 * big TCP purposes. This will be removed before sending
+		 * from NIC, so do not count it.
+		 */
+		if (*nexthdr == NEXTHDR_HOP) {
+			if (likely(skb->len <= GRO_LEGACY_MAX_SIZE))
+				goto increment_hdr;
+
+			jhdr = (struct hop_jumbo_hdr *)nexthdr;
+			if (jhdr->tlv_type != IPV6_TLV_JUMBO || jhdr->hdrlen != 0 ||
+			    jhdr->nexthdr != IPPROTO_TCP)
+				goto increment_hdr;
+
+			goto next_hdr;
+		}
+increment_hdr:
+		hdr_count++;
+next_hdr:
 		nexthdr = &hp->nexthdr;
 		start += hdrlen;
-		hdr_count++;
 	}
 	if (nextp) {
 		/* Caller will check inner protocol */
@@ -13657,6 +13679,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev->features &= ~NETIF_F_LRO;
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
+	netif_set_tso_max_size(dev, GSO_MAX_SIZE);
+
 #ifdef CONFIG_BNXT_SRIOV
 	init_waitqueue_head(&bp->sriov_cfg_wait);
 #endif
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

