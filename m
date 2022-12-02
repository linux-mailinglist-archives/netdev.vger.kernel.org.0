Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3834641066
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 23:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbiLBWM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 17:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233977AbiLBWMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 17:12:23 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514E4F9303
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 14:12:22 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id v23-20020aa78097000000b005748c087db1so6071861pff.2
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 14:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RxFknGyAkcIOOsCgLG6r1err07+MBrN/SSNfaLXlwhg=;
        b=dB0yZm0vtYjeMx8aJ36Rn/NpjR0HOQmUVA3aFPdVivS5kxj7wKoAsTcPNoAT8arhsA
         mQ+6r2J7uLpsNM8NKQTyTNs2dq7CwDZ+Weqd9hrvp/SKJTIFJHtCid/SZc3i8gTmyvQu
         C7aJm96Wbv/dWI2bZdS7+Yt72IEFTOLcuNOol3UVrk2PpZhu6wBtUMy6AzH0T59kGjbk
         8d3jHrPMVbv0y2Wjpq8abKjL0TqRYfkNXrjHpFKLSIKysLF2EKnhVQX9dOYMbLlW1ssP
         QfeaS1GnYMTpnZsw7unZNrZUy9WZ21Su51G8exq8HfqMVSO9Tf4q2MU4/zRNq8crE6y6
         W72Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RxFknGyAkcIOOsCgLG6r1err07+MBrN/SSNfaLXlwhg=;
        b=Cwux2nM6w0CeiaXzzsnsBkDw2u2YVqHG5BjU4Bys5dX6eKkZWbMRYL48RWfUkANg5i
         DejMEvUHRdgtkAPb5geXbmSYjbnPjyK7hW/hiAxWIsIO8yYQiIfsW86fBT5ylvMB2lm7
         PRKfNZxBG6w5p8fePVREHA9JJaCKWac+UXDvwfP2mMJHhW4dVE//A/1mdLraLK+PjVng
         UVP7jOcKGYZ80y4sMUKNW75nrGHFlNMfGKtfakiZyQFYqXar/Wo6Tau/3dAs77BmWjiN
         kdI3OVG3OAWrbKVhkXIAh3lepFAHxmA89zllE9/JRc1MFSsamNvPNu0RtnJqXEp+I/bW
         VeqA==
X-Gm-Message-State: ANoB5pnVBbUauFF0mpF/9vFXnX/OkbBC+TbXcJxBUm3hfBBFY5BZ71v0
        y0/nCtjLgDZ3sVruvH8pJbfxz7qo8eJHFmk=
X-Google-Smtp-Source: AA0mqf5wXcrw5d0m1tnOeS4rkHBJ8FcNfWgR5Eu3EYiFy6/85Conhs0C0zQcUP87be5oqcekRI5FcuNccvMcJ8Y=
X-Received: from lixiaoyan-desktop.svl.corp.google.com ([2620:15c:2c4:201:806c:1abb:ce24:13cf])
 (user=lixiaoyan job=sendgmr) by 2002:a05:6a00:2183:b0:574:2104:5657 with SMTP
 id h3-20020a056a00218300b0057421045657mr51866119pfi.58.1670019141829; Fri, 02
 Dec 2022 14:12:21 -0800 (PST)
Date:   Fri,  2 Dec 2022 14:12:13 -0800
In-Reply-To: <20221202221213.236564-1-lixiaoyan@google.com>
Mime-Version: 1.0
References: <20221202221213.236564-1-lixiaoyan@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202221213.236564-2-lixiaoyan@google.com>
Subject: [RFC net-next v4 2/2] bnxt: Use generic HBH removal helper in tx path
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
index 0fe164b42c5d..c2713cb5debd 100644
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
@@ -11342,9 +11345,28 @@ static bool bnxt_exthdr_check(struct bnxt *bp, struct sk_buff *skb, int nw_off,
 
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
+			struct hop_jumbo_hdr *jhdr = (struct hop_jumbo_hdr *)(nexthdr + hdrlen);
+
+			if (jhdr->tlv_type != IPV6_TLV_JUMBO || jhdr->hdrlen != 0 ||
+			    (jhdr->nexthdr != IPPROTO_TCP && jhdr->nexthdr != IPPROTO_UDP))
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

