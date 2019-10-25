Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E8BE4C84
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 15:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504884AbfJYNmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 09:42:49 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36495 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504875AbfJYNms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 09:42:48 -0400
Received: by mail-wr1-f65.google.com with SMTP id w18so2419697wrt.3
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 06:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metanetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0mnmJjgSlbBJ30kBXAxihFKleD83aqV+FTUAUtrG3yA=;
        b=Li6TPKlS1dN7+hG4fVg7M1mBLXyZSf07oSkHnNQubaNALerMXZKLDxK7R9u+lzqxCy
         ogprTCWDbICgJw0yomR4qlKWK64bTcZ7INGxfNig4hcYRHNrTzDv69+wbwZzcR6lhuf7
         fyzfxPa1PjHRBK+jFpQ/Gv7TKnU4DXkigWg+0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0mnmJjgSlbBJ30kBXAxihFKleD83aqV+FTUAUtrG3yA=;
        b=M6LCuu4+TbVfrD4uDkQ9fH4476dSmsjBiiQEMg3Ujp/nBf7nGGZ6jQoUcViG41dkzz
         h43KeuwYvdFBriRrbV3uMt2bKqmK1fXK4QD79NNqyUNexgmxC/OBz1fj2Zrxlea6Coes
         GHwddQoNlaKfPdmsALN3/pv/lS2QZ/r0i1E/gGNZktBJhI0IcubEjtrCHLZwqguletxY
         QqgOhrYl/i5GAIqHMMbKGi5LvIRKZ/t8e5fkWFooySapidIO6PNX9er1YrCpcsXUbvFu
         +pit1Ngco8wrLIh/GQH/ORhQROM3TnSRJekryOQsptLI8zpZRxV9aXVXRDOttlsdp8AR
         TXjw==
X-Gm-Message-State: APjAAAX61D9/JaikMBjjKtye1t61ictCt0HGuKpXq6sN/86ha9Yp6orX
        ktcMRPZi9VhOv1LWfysqC84Nxw==
X-Google-Smtp-Source: APXvYqwupdv7Fh2oROTvgM21NgJagri/TBE8LfHiqS9h+SXH5+3S+USNhdGzYSHXAQdz0PZWE1FJkQ==
X-Received: by 2002:adf:e585:: with SMTP id l5mr3085728wrm.156.1572010966360;
        Fri, 25 Oct 2019 06:42:46 -0700 (PDT)
Received: from localhost.localdomain ([94.230.83.169])
        by smtp.gmail.com with ESMTPSA id v11sm2194730wrw.97.2019.10.25.06.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 06:42:45 -0700 (PDT)
From:   Shmulik Ladkani <shmulik@metanetworks.com>
X-Google-Original-From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: [PATCH bpf-next 2/2] test_bpf: Introduce 'gso_linear_no_head_frag' skb_segment test
Date:   Fri, 25 Oct 2019 16:42:23 +0300
Message-Id: <20191025134223.2761-3-shmulik.ladkani@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191025134223.2761-1-shmulik.ladkani@gmail.com>
References: <20191025134223.2761-1-shmulik.ladkani@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following reports of skb_segment() hitting a BUG_ON when working on
GROed skbs which have their gso_size mangled (e.g. after a
bpf_skb_change_proto call), add a reproducer test that mimics the
input skbs that lead to the mentioned BUG_ON as in [1] and validates the
fix submitted in [2].

[1] https://lists.openwall.net/netdev/2019/08/26/110
[2] commit 3dcbdb134f32 ("net: gso: Fix skb_segment splat when splitting gso_size mangled skb having linear-headed frag_list")

Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
---
 lib/test_bpf.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index c952df82b515..cecb230833be 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -6859,6 +6859,60 @@ static __init struct sk_buff *build_test_skb(void)
 	return NULL;
 }
 
+static __init struct sk_buff *build_test_skb_linear_no_head_frag(void)
+{
+	unsigned int alloc_size = 2000;
+	unsigned int headroom = 102, doffset = 72, data_size = 1308;
+	struct sk_buff *skb[2];
+	int i;
+
+	/* skbs linked in a frag_list, both with linear data, with head_frag=0
+	 * (data allocated by kmalloc), both have tcp data of 1308 bytes
+	 * (total payload is 2616 bytes).
+	 * Data offset is 72 bytes (40 ipv6 hdr, 32 tcp hdr). Some headroom.
+	 */
+	for (i = 0; i < 2; i++) {
+		skb[i] = alloc_skb(alloc_size, GFP_KERNEL);
+		if (!skb[i]) {
+			if (i == 0)
+				goto err_skb0;
+			else
+				goto err_skb1;
+		}
+
+		skb[i]->protocol = htons(ETH_P_IPV6);
+		skb_reserve(skb[i], headroom);
+		skb_put(skb[i], doffset + data_size);
+		skb_reset_network_header(skb[i]);
+		if (i == 0)
+			skb_reset_mac_header(skb[i]);
+		else
+			skb_set_mac_header(skb[i], -ETH_HLEN);
+		__skb_pull(skb[i], doffset);
+	}
+
+	/* setup shinfo.
+	 * mimic bpf_skb_proto_4_to_6, which resets gso_segs and assigns a
+	 * reduced gso_size.
+	 */
+	skb_shinfo(skb[0])->gso_size = 1288;
+	skb_shinfo(skb[0])->gso_type = SKB_GSO_TCPV6 | SKB_GSO_DODGY;
+	skb_shinfo(skb[0])->gso_segs = 0;
+	skb_shinfo(skb[0])->frag_list = skb[1];
+
+	/* adjust skb[0]'s len */
+	skb[0]->len += skb[1]->len;
+	skb[0]->data_len += skb[1]->len;
+	skb[0]->truesize += skb[1]->truesize;
+
+	return skb[0];
+
+err_skb1:
+	kfree_skb(skb[0]);
+err_skb0:
+	return NULL;
+}
+
 struct skb_segment_test {
 	const char *descr;
 	struct sk_buff *(*build_skb)(void);
@@ -6871,6 +6925,15 @@ static struct skb_segment_test skb_segment_tests[] __initconst = {
 		.build_skb = build_test_skb,
 		.features = NETIF_F_SG | NETIF_F_GSO_PARTIAL | NETIF_F_IP_CSUM |
 			    NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM
+	},
+	{
+		.descr = "gso_linear_no_head_frag",
+		.build_skb = build_test_skb_linear_no_head_frag,
+		.features = NETIF_F_SG | NETIF_F_FRAGLIST |
+			    NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_GSO |
+			    NETIF_F_LLTX_BIT | NETIF_F_GRO |
+			    NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM |
+			    NETIF_F_HW_VLAN_STAG_TX_BIT
 	}
 };
 
-- 
2.17.1

