Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57535A19B3
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 14:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbfH2MOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 08:14:17 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55885 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbfH2MOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 08:14:17 -0400
Received: by mail-wm1-f66.google.com with SMTP id f72so3449253wmf.5
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 05:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metanetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JQYkUwuUzgZVwl4WQH4dUBAJ8p6aTRNsQOUKQESOE+s=;
        b=OZNxKdM3aZW4GUx9qIbvE0IxQXuyx1+Gjyr40CSu7EL+0T5zHJ+z4lOcL9hx5cT8sh
         SLWdwp5xKZuMpc9cYi4ep7bouViSjjZyQuPP8wEvK0qtXv1ra4H0QwrF310JYVR76nTG
         Imc7YdXUCvTPP7jsY7UtkXWxo8iHxh95KG8Pw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JQYkUwuUzgZVwl4WQH4dUBAJ8p6aTRNsQOUKQESOE+s=;
        b=flR5lwqTuqrAIfBgVKqIeJIo5y/d06rBKO3ZOhuAcf6ZdnriZeMvLCGly4KrPA+1Zn
         FH4XDxgG4YP2sO7XqD7veoW6fFe9Ne11VTdmFrOnLj0UwpC/ycc6kaq96tn90qP/zOFr
         1I2aaJ6SmFttkrH90UcFS2waV0Abuj8Xk7ZZ5qPt7epY0YrfxMPNpvk1eljZ5qMprF/m
         t68jKBIkePbwYZp3nNQqEHoNlG4/nApbtVtrl/Lv7CYEIHVaCMlG/zn/09fvbFxKPr0t
         kjbThYJO9Xbf4IwCFo0YP+HEfgcYOEnEJISdeq+XBXFn2QYDPyGPvsFG2HBxmFK/ixsv
         /pzg==
X-Gm-Message-State: APjAAAXt+GFec5cbFBGwBDpkVnA3Su5ZBJIrtjBiW9SmAcdcRlPrGUeT
        5bpBi4T9TQVwSx2XEig/SasgF50reeUt4A==
X-Google-Smtp-Source: APXvYqwWleBtrtWixT9dc+TFY6bVQk6SeQJNRHgMituTZTShDYN/snF79mc2I7LI6QRgmVacUi1kBA==
X-Received: by 2002:a05:600c:2311:: with SMTP id 17mr11039510wmo.68.1567080855265;
        Thu, 29 Aug 2019 05:14:15 -0700 (PDT)
Received: from localhost.localdomain (bzq-82-81-225-244.cablep.bezeqint.net. [82.81.225.244])
        by smtp.gmail.com with ESMTPSA id b3sm3696183wrm.72.2019.08.29.05.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 05:14:14 -0700 (PDT)
From:   Shmulik Ladkani <shmulik@metanetworks.com>
X-Google-Original-From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>, Yonghong Song <yhs@fb.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: [PATCH bpf-next 1/2] test_bpf: Refactor test_skb_segment() to allow testing skb_segment() on numerous different skbs
Date:   Thu, 29 Aug 2019 15:13:43 +0300
Message-Id: <20190829121344.20675-2-shmulik.ladkani@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190829121344.20675-1-shmulik.ladkani@gmail.com>
References: <20190829121344.20675-1-shmulik.ladkani@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, test_skb_segment() builds a single test skb and runs
skb_segment() on it.

Extend test_skb_segment() so it processes an array of numerous
skb/feature pairs to test.

Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
---
 lib/test_bpf.c | 51 ++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 10 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index c41705835cba..5e80cb3d3ca0 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -6859,34 +6859,65 @@ static __init struct sk_buff *build_test_skb(void)
 	return NULL;
 }
 
-static __init int test_skb_segment(void)
-{
+struct skb_segment_test {
+	const char *descr;
+	struct sk_buff *(*build_skb)(void);
 	netdev_features_t features;
+};
+
+static struct skb_segment_test skb_segment_tests[] __initconst = {
+	{
+		.descr = "gso_with_rx_frags",
+		.build_skb = build_test_skb,
+		.features = NETIF_F_SG | NETIF_F_GSO_PARTIAL | NETIF_F_IP_CSUM |
+			    NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM
+	}
+};
+
+static __init int test_skb_segment_single(const struct skb_segment_test *test)
+{
 	struct sk_buff *skb, *segs;
 	int ret = -1;
 
-	features = NETIF_F_SG | NETIF_F_GSO_PARTIAL | NETIF_F_IP_CSUM |
-		   NETIF_F_IPV6_CSUM;
-	features |= NETIF_F_RXCSUM;
-	skb = build_test_skb();
+	skb = test->build_skb();
 	if (!skb) {
 		pr_info("%s: failed to build_test_skb", __func__);
 		goto done;
 	}
 
-	segs = skb_segment(skb, features);
+	segs = skb_segment(skb, test->features);
 	if (!IS_ERR(segs)) {
 		kfree_skb_list(segs);
 		ret = 0;
-		pr_info("%s: success in skb_segment!", __func__);
-	} else {
-		pr_info("%s: failed in skb_segment!", __func__);
 	}
 	kfree_skb(skb);
 done:
 	return ret;
 }
 
+static __init int test_skb_segment(void)
+{
+	int i, err_cnt = 0, pass_cnt = 0;
+
+	for (i = 0; i < ARRAY_SIZE(skb_segment_tests); i++) {
+		const struct skb_segment_test *test = &skb_segment_tests[i];
+
+		pr_info("#%d %s ", i, test->descr);
+
+		if (test_skb_segment_single(test)) {
+			pr_cont("FAIL\n");
+			err_cnt++;
+		} else {
+			pr_cont("PASS\n");
+			pass_cnt++;
+		}
+	}
+
+	pr_info("%s: Summary: %d PASSED, %d FAILED\n", __func__,
+		pass_cnt, err_cnt);
+	return err_cnt ? -EINVAL : 0;
+}
+
 static __init int test_bpf(void)
 {
 	int i, err_cnt = 0, pass_cnt = 0;
-- 
2.19.1

