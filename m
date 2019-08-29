Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E28BAA19B6
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 14:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfH2MOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 08:14:23 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34576 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727417AbfH2MOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 08:14:22 -0400
Received: by mail-wm1-f68.google.com with SMTP id y135so1938556wmc.1
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 05:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metanetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2+WQjTG7da5+ibgqeaWlUW2ZOIAqoqQ7Q8Ld80/qvh4=;
        b=CbN2t8nQeu0lwa1IDHV6s7yjYH2NcImLdGPPsFuSLDJMebC1SJ/WN4yTZmxNHZwLVy
         /W3W0WhXmrnbtUIk66TTmyKG8iJHQ3UP4/dTchXgJOf1OIBxxBCALug9gZZWCiewbdfT
         /iiVy0bSaPOvS9kDWBXnRQMoAxJpQsDsh0EsI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2+WQjTG7da5+ibgqeaWlUW2ZOIAqoqQ7Q8Ld80/qvh4=;
        b=p+Sbe98wtnmctexQkDeerXBN3eaB4Ug3kBA0KZyF6qIIbVBi1dIReKEGNSbz1zAMVv
         9XuOimRd0f6KzyXB1DKFxDVDx0nudPBiZj91FiXbnxBataiAbCzRbW9aJJ5ANax/jZM2
         Zp1UulLj28dJIqVBcW1I1UqQ1/bJv8MmGahEDmQD0TzO1WM2do1GzycTjaQdjTEQdAym
         dJ54M6rKZljqXClS4KWylOfU5hnOTFubCHWvspQRCRLBPZPvTq7MGrkyBh8QQG9C3VRk
         4nrhfmmqBOdLdGRxbcoGJIGqv0oyKpT+abK3F7j3P5ZW8E19AymaoPzR6da3L4TKX463
         eAhA==
X-Gm-Message-State: APjAAAWiW5prk+HI+TGFkiRKHwAq4Rwe/qT6UDEIvlO8/63DhonhqGrz
        QG0sYIcbVqN+xXggCDvEIR+5wQ==
X-Google-Smtp-Source: APXvYqy+4utVWCqF6xvuoTJrn/HxaKm+H5oT1jpQzOigusVx+9686p6XWc48NkZbBIJwBHpL5L/2fw==
X-Received: by 2002:a7b:cbce:: with SMTP id n14mr10291601wmi.47.1567080860450;
        Thu, 29 Aug 2019 05:14:20 -0700 (PDT)
Received: from localhost.localdomain (bzq-82-81-225-244.cablep.bezeqint.net. [82.81.225.244])
        by smtp.gmail.com with ESMTPSA id b3sm3696183wrm.72.2019.08.29.05.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 05:14:19 -0700 (PDT)
From:   Shmulik Ladkani <shmulik@metanetworks.com>
X-Google-Original-From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>, Yonghong Song <yhs@fb.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: [RFC PATCH bpf-next 2/2] test_bpf: Introduce 'gso_linear_no_head_frag' skb_segment test
Date:   Thu, 29 Aug 2019 15:13:44 +0300
Message-Id: <20190829121344.20675-3-shmulik.ladkani@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190829121344.20675-1-shmulik.ladkani@gmail.com>
References: <20190829121344.20675-1-shmulik.ladkani@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following reports of skb_segment() hitting a BUG_ON when working on
GROed skbs which have their gso_size mangled (e.g. after a
bpf_skb_change_proto call), add a reproducer test that mimics the
input skbs that lead to the mentioned BUG_ON as in [1].

[1] https://lists.openwall.net/netdev/2019/08/26/110

Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
---
 lib/test_bpf.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 5e80cb3d3ca0..2fe1e3ab3c89 100644
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
2.19.1

