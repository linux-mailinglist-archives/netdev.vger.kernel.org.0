Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADC9136DA
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 03:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfEDBSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 21:18:46 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51379 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbfEDBSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 21:18:45 -0400
Received: by mail-wm1-f68.google.com with SMTP id t76so9077150wmt.1;
        Fri, 03 May 2019 18:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FlBiYAFdqgyAcPlF8/ahth/Wy5yXLY78rXBUogr2yyg=;
        b=RoKwLq8geN5IWbpPxfEdAcrza/aNwRNlGyrtKhJVPDL3WspfLfRY8PU9qaEFx4Uoo1
         idA/D6HsA7GytvhxdHxlKi2qA9nyj3ChCTvn1w1K+NvpQsyvme62A8BlbgDBxMGSIN5j
         erfchs/zrnFpE+B+7nJQAjopt4VG7TkDUZGw1t/9AOI4bvKLfco6nKlyubGDJ3d76hDc
         LDlLMpqTbt9kF0GB+aVW65QuLFGKpbXlIxHZMf3zoURXk8bBVxV2F7d1bBe8Cf1KlWtQ
         1RB0Yu1TBxa0caUgCR9hH+lH9CGV15VXWlPdSm6JKUMwBTTA/Nqd+pzN0qJoBXIbqK0s
         yDhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FlBiYAFdqgyAcPlF8/ahth/Wy5yXLY78rXBUogr2yyg=;
        b=tBxN3uLO5eUVykliggIGIb4MC87k32j6gtAoOwEs/XJqHVmAZZOKWuW1V0+G5YQ9OT
         +wh2Pe3yHIUU6ONUJVYmNuKbKl1f26g4oSqNefEpxZW2xfAYKPWIOV0bqpbmuflfGf7R
         I1/+yG+Hsgs2DV8wXSjtEtk4eEDf174RfRs8jpYcEgBbLMv6SJE62CRQ9zVUUItcW5HX
         3XyH6z3GpZDaBfp3dMYYBTlZS/8yAnZxUJKegPyU8R22P+qH9QJ7ScZWPfBMXYN3ozda
         mnUwCNW5pqNopFHy9p1gLfQRSRcMxyARAq7mSHpmsjLg8B0Hg/v7VBybF8ZpxEzNK6GZ
         19QQ==
X-Gm-Message-State: APjAAAUZa1KZrjLhRSdztOHQXnlMy/i38R8VwnwbmLF4piJ6c+VXOCtC
        0eq9EHfYFWzESvm4vC2jGQw=
X-Google-Smtp-Source: APXvYqwEBrQoCJWfHO+mi+HM0KWfsaOAn8df0cCMbIcZ+3ILEg9tBcp4s+YV7GSE2wHSAYUeqq2FqQ==
X-Received: by 2002:a7b:c844:: with SMTP id c4mr8184298wml.108.1556932723215;
        Fri, 03 May 2019 18:18:43 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id t1sm3937639wro.34.2019.05.03.18.18.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 18:18:42 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 4/9] net: dsa: Keep private info in the skb->cb
Date:   Sat,  4 May 2019 04:18:21 +0300
Message-Id: <20190504011826.30477-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190504011826.30477-1-olteanv@gmail.com>
References: <20190504011826.30477-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Map a DSA structure over the 48-byte control block that will hold
persistent skb info on transmit and receive.

Also add a DSA_SKB_CB_PRIV() macro which retrieves a pointer to the
space up to 48 bytes that the DSA structure does not use. This space can
be used for drivers to add their own private info.

One use is for the PTP timestamping code path. When cloning a skb,
annotate the original with a pointer to the clone, which the driver can
then find easily and place the timestamp to. This avoids the need of a
separate queue to hold clones and a way to match an original to a cloned
skb.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 include/net/dsa.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index c90ceeec7d1f..8f5fcec30b13 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -83,6 +83,34 @@ struct dsa_device_ops {
 #define MODULE_ALIAS_DSA_TAG_DRIVER(__proto)				\
 	MODULE_ALIAS(DSA_TAG_DRIVER_ALIAS __stringify(__proto##_VALUE))
 
+struct dsa_skb_cb {
+	struct sk_buff *clone;
+};
+
+struct __dsa_skb_cb {
+	struct dsa_skb_cb cb;
+	u8 priv[48 - sizeof(struct dsa_skb_cb)];
+};
+
+#define __DSA_SKB_CB(skb) ((struct __dsa_skb_cb *)((skb)->cb))
+
+#define DSA_SKB_CB(skb) ((struct dsa_skb_cb *)((skb)->cb))
+
+#define DSA_SKB_CB_COPY(nskb, skb) \
+	{ *__DSA_SKB_CB(nskb) = *__DSA_SKB_CB(skb); }
+
+#define DSA_SKB_CB_ZERO(skb) \
+	{ *__DSA_SKB_CB(skb) = (struct __dsa_skb_cb) {0}; }
+
+#define DSA_SKB_CB_PRIV(skb) \
+	((void *)(skb)->cb + offsetof(struct __dsa_skb_cb, priv))
+
+#define DSA_SKB_CB_CLONE(clone, skb) \
+	{ \
+		DSA_SKB_CB_COPY(clone, skb); \
+		DSA_SKB_CB(skb)->clone = clone; \
+	}
+
 struct dsa_switch_tree {
 	struct list_head	list;
 
-- 
2.17.1

