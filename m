Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 960EE13A7D
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 15:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbfEDN7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 09:59:52 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33109 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfEDN7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 09:59:50 -0400
Received: by mail-wm1-f65.google.com with SMTP id s18so1645132wmh.0
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 06:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=U5eHXmezP4NAsJ4OJ3h0l/KejYRt6wZYqXMwgL5OzQw=;
        b=KNeySPD6U2P1GFm/Xe/Gg7odNhCB5DIsuJ6I6Ps5839CbobI52z9SQcQuU8W87riGo
         BaukBKynKTAaRpEzmH2pIUy440kRBBqYr6LjWDQpNUuGZSBe8b/Qc9CDu9jvB6zRh81y
         eQWTutKk+Vur7xw6ShGx8mpJFkoxR6DfQ1RH9qheVWdf1a4nMS0iX6Ivn9hK1D7a/RHy
         KZFHFh+h7BOKWH+C875chVP8W1aoHu4TOlrakGlAPbRCEGrPVWnztx0M7g+LG/XFIpzP
         pFPQ+6k6k9jpwNumS8eufK7c8ELtKMVNxoptD6jWeMwJZeYrGrIFnyO+X8UGwJZT0VyE
         2ubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=U5eHXmezP4NAsJ4OJ3h0l/KejYRt6wZYqXMwgL5OzQw=;
        b=m2+4yF9/Lsau+Q0pvqxGsp3TciG1yCqtgewc7T4IK9po/murUIf2dYGX6c7o/KYMGW
         IJqiBwpi8mQ/GpQndxMXV03GnK36OHdG6O3Hl6E8nDu2ZYDxciVNcJPm8S3yEFeu15g1
         YdsukC3P8McuxzTZ2s2jNnowkblNn8GOLfZS57LbYFCr6FHN6UGhjOzYSveqpSZWWlpv
         b4XQay6Gj8cUMDfRGGKgdP5Eb82DD0ZDepSBOBiG2eMITILYB9ym2DVVULDMRndkK9zI
         iKDxyR7uC8P9U7Q/bi7MRswOW0Oysqw2aOrm1rnCE3WrqkaCIqOycf69OlaOZRop3BKF
         Zhaw==
X-Gm-Message-State: APjAAAWkTG5Dby6QWZJtuKdXfXEo1uZW1a3A4k3VbxkEsR+sXPKV3D1c
        SV2MaGBfnja0fwCun6TNuDk=
X-Google-Smtp-Source: APXvYqwrh7TSs4rxmIKt04LrXqQB7ALrUADwx6ULGAaiBOOvl28OqEmZmVQBMLZkIVkYxUpXZQ4Hag==
X-Received: by 2002:a7b:cb81:: with SMTP id m1mr10694270wmi.9.1556978388813;
        Sat, 04 May 2019 06:59:48 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id s16sm5085940wrg.71.2019.05.04.06.59.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 06:59:48 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v2 4/9] net: dsa: Keep private info in the skb->cb
Date:   Sat,  4 May 2019 16:59:14 +0300
Message-Id: <20190504135919.23185-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190504135919.23185-1-olteanv@gmail.com>
References: <20190504135919.23185-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Map a DSA structure over the 48-byte control block that will hold
skb info on transmit and receive. This is only for use within the DSA
processing layer (e.g. communicating between DSA core and tagger) and
not for passing info around with other layers such as the master net
device.

Also add a DSA_SKB_CB_PRIV() macro which retrieves a pointer to the
space up to 48 bytes that the DSA structure does not use. This space can
be used for drivers to add their own private info.

One use is for the PTP timestamping code path. When cloning a skb,
annotate the original with a pointer to the clone, which the driver can
then find easily and place the timestamp to. This avoids the need of a
separate queue to hold clones and a way to match an original to a cloned
skb.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
  - Added a clarification about intended use in the commit message.

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

