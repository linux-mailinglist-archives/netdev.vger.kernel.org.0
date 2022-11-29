Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B61A63C8F2
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 21:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237214AbiK2UHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 15:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237204AbiK2UHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 15:07:01 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A8E2E9F8
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 12:07:00 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id l186-20020a6388c3000000b00478410026bfso2291376pgd.10
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 12:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IJZlDWY2h6FAZWMEwD5hO6Ky1u9533DiRDKfw2y50P4=;
        b=W4HO3RNvc/Y74RIPeU4zMBsbAqmOEReI49UwtMVn/t0kBzZv4AT9l/wnqrvOP3Hb3b
         6r2Sl5Ai6aChrf2k0HSJGuoCGVJow34rGusWwatQWfjkMn+j+CjOHtsQ2dKjk0BGhDNJ
         109Ba3AbXkj4cTcwIa6gmzR2T/6RTzgImRL1o3yD5TOQTeFeGwlRgV3IQ+Gkv8w9dtPW
         QI0Oq/UVmi9IdOPYgT8VfIo7U48DzDMnKJiRyoKdKJfHYjtCWC8G8cMDXcN0MzbKfhLj
         saGs8eXdSK7MQweB7pZyur62dT648rhNge9q5oBzGMmkDE1j4FFpEIWbPsHf2WIiTz77
         40rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IJZlDWY2h6FAZWMEwD5hO6Ky1u9533DiRDKfw2y50P4=;
        b=VhHCrLgrEm6V2MBa4cvhPT/W0hM6+fVJrJitROZ6Pk+RrCb4voEjsfUjcXE+cjsNAY
         sV87f/wrawn63T/LvNKB0Shu+iOprwi9Dy1XS5x3rQRK53EPqGoteQGVp0Z9MKObKO0J
         2ZudCqwtMdsAhLsFV5hcUcOGlqALZDwscCfOH/RFdHKfh5y1l856xzOaGs4LJ8u0TV/T
         Bg8hIRTsXKceb8C9b3IIojpP5FOdSBaDmxamI3QiziZiZ3SewsK7xNiBeXNRsUk3fjzV
         x7JLb7Ea+VCWfRdhl3k51sWGxQykbtN27inT35ypQDHw2Arjxz42mso6X7MJAs47FpZG
         dMkg==
X-Gm-Message-State: ANoB5pm30dxsqSqnf7sJN4NGlc1hD6iVQ8vmQcvnnDMCTxRu/4tA+VwB
        R18cT06rMFi6cAASuTCSke2Jo1hYiOs/QGM=
X-Google-Smtp-Source: AA0mqf5gnZBj8r3JG/i9eglqJL/fFDFy+dC1qa+/TdY1xO8mcB+EqkBKSg6zEgu34onTtuGR9gMzAT3PTh9kFbQ=
X-Received: from coco0920.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:5738])
 (user=lixiaoyan job=sendgmr) by 2002:a17:90a:9606:b0:213:2411:50e8 with SMTP
 id v6-20020a17090a960600b00213241150e8mr59998140pjo.181.1669752420003; Tue,
 29 Nov 2022 12:07:00 -0800 (PST)
Date:   Tue, 29 Nov 2022 20:06:53 +0000
In-Reply-To: <20221129200653.962019-1-lixiaoyan@google.com>
Mime-Version: 1.0
References: <20221129200653.962019-1-lixiaoyan@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221129200653.962019-2-lixiaoyan@google.com>
Subject: [RFC net-next v3 2/2] bnxt: Use generic HBH removal helper in tx path
From:   Coco Li <lixiaoyan@google.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>
Cc:     netdev@vger.kernel.org,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org, Coco Li <lixiaoyan@google.com>
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
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 0fe164b42c5d..f144a5ef2e04 100644
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
@@ -11342,9 +11345,15 @@ static bool bnxt_exthdr_check(struct bnxt *bp, struct sk_buff *skb, int nw_off,
 
 		if (hdrlen > 64)
 			return false;
+
+		/* The ext header may be a hop-by-hop header inserted for
+		 * big TCP purposes. This will be removed before sending
+		 * from NIC, so do not count it.
+		 */
+		if (!(*nexthdr == NEXTHDR_HOP && ipv6_has_hopopt_jumbo(skb)))
+			hdr_count++;
 		nexthdr = &hp->nexthdr;
 		start += hdrlen;
-		hdr_count++;
 	}
 	if (nextp) {
 		/* Caller will check inner protocol */
@@ -13657,6 +13666,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev->features &= ~NETIF_F_LRO;
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
+	netif_set_tso_max_size(dev, GSO_MAX_SIZE);
+
 #ifdef CONFIG_BNXT_SRIOV
 	init_waitqueue_head(&bp->sriov_cfg_wait);
 #endif
-- 
2.38.1.584.g0f3c55d4c2-goog

