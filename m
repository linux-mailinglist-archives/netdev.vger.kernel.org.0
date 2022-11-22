Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6E2634B13
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 00:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235075AbiKVX1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 18:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235127AbiKVX1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 18:27:47 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D39D12A82
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 15:27:47 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id b18-20020a170903229200b00186e357f3b9so12477024plh.6
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 15:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NW0Mw/qHQ9FIGEA+rYwuphRFxEn0u6CmWZPIH+7Q52E=;
        b=mWqj5WIGBem1iF+Uk/grB8x8EBaHVrCqMst6wuBLbGsWFpcwg+0fjzV9JQK2aDAN8W
         xTMUgEpVk41qOs3xRDyaN7pEsURTZ6OAgqiq5vc7RvB7TqK5PdZ7Dcv06XWTDzisLGAg
         2NL5ofiKWD4bNvZjZ8zmLfcgapnRv8QDEY0Ov3pgqB80koLDwTAc3ndTJURU2MxqDDHL
         mrD5iMu6wziBSyEHRNKsL2krLSIIEbBF8MIjSQDABCHRVDlZa8lOUBfUNZhGZKEuj6Ai
         CWWR+astAj3Rv2vb2LxH+ECOYl0y8PP3qDGAWkSVbhBqYX/f/SaUSAR2dtEU5c3kXdTx
         KGEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NW0Mw/qHQ9FIGEA+rYwuphRFxEn0u6CmWZPIH+7Q52E=;
        b=eQH9mD2ZKdy7agVOQh7gSOs2e9MFhBHELts2Ok/8ReHKowOX2tttWKHZy+BZ0gk2Tc
         eBAq2dP/ffed2sHnrobYiQoSReXrUW1t1P/eTsEtW/fgjNeh6Pvzm5jOonfq6HI5Ogyx
         vvrNAmKVKA8/x6jKe7pmljOtV+itS+MbS6W8GO5Jdb96fEHRHwwaeszO66TIDXNjiPWR
         3L+7fqOywnDSa4vZ43KGKfVwwSA/GVrRTFLqwytuEZXCn1lOJ+zsKE3aYO2xYsxckRSw
         VAy7M54GabiBRGUOXRpZQbZjEWZpa2JX0HS8vSKZVX6p/C7KWtQinaeh/Blf79feIzSU
         CAqQ==
X-Gm-Message-State: ANoB5pk6IDwJg95NAbxrWEhl18U84JMCVuDgGwWhIojae9fbtGCjIqfc
        R1qd0F3NXML6Ho5IRZM+52RbU2o5KvYIbLA=
X-Google-Smtp-Source: AA0mqf5ws0Bi8Bmoqt9MzThkL/Zhhqb69IDqQPANUYjbJwkBa5ieR+550EusAf+Wn0+TOvKHSktGDfImx4iRnjk=
X-Received: from lixiaoyan-desktop.svl.corp.google.com ([2620:15c:2c4:201:d85f:1168:cf63:556b])
 (user=lixiaoyan job=sendgmr) by 2002:a05:6a00:301b:b0:56e:1ce2:c919 with SMTP
 id ay27-20020a056a00301b00b0056e1ce2c919mr11190807pfb.78.1669159666639; Tue,
 22 Nov 2022 15:27:46 -0800 (PST)
Date:   Tue, 22 Nov 2022 15:27:40 -0800
In-Reply-To: <20221122232740.3180560-1-lixiaoyan@google.com>
Mime-Version: 1.0
References: <20221122232740.3180560-1-lixiaoyan@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221122232740.3180560-2-lixiaoyan@google.com>
Subject: [PATCH net-next 2/2] bnxt: Use generic HBH removal helper in tx path
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

If bnxt folks could help with testing this patch on the driver (as I
don't have access to one) that would be wonderful. Thank you!

Tested:
Compiled locally

To further test functional correctness, update the GSO/GRO limit on the
physical NIC:

ip link set eth0 gso_max_size 181000
ip link set eth0 gro_max_size 181000

Note that if there are bonding or ipvan devices on top of the physical
NIC, their GSO sizes need to be updated as well.

Then, IPv6/TCP packets with sizes larger than 64k can be observed.

Signed-off-by: Coco Li <lixiaoyan@google.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 0fe164b42c5d..2bfa5e9fb179 100644
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
@@ -13657,6 +13660,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev->features &= ~NETIF_F_LRO;
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
+	netif_set_tso_max_size(dev, GSO_MAX_SIZE);
 #ifdef CONFIG_BNXT_SRIOV
 	init_waitqueue_head(&bp->sriov_cfg_wait);
 #endif
-- 
2.38.1.584.g0f3c55d4c2-goog

