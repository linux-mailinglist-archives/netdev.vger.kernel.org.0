Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9877D13ECE
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 12:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbfEEKUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 06:20:03 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42700 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727576AbfEEKTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 06:19:46 -0400
Received: by mail-wr1-f67.google.com with SMTP id l2so13422622wrb.9
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 03:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uAJqUDEHClJ+6muOD0Ci8z+C8CfsR6yL8j/FHzuUqfc=;
        b=ewgjN9luttj9wW8VZR2GQsuOWTghpEx/+urzeQkC5Xf+Efk0gskY1e7l1nC1UQUpmw
         CoknNcSrVwk0ptr5fqjC1ue9FG/WDwboTvhlM4oKmBW2yTwQgA6CsQh6yf6h6R150XeF
         ey5420JprFW4u4h4U/2IbDJsNs33z7vzoCX7s8CYZmZ0eAnBHrcwrKL/a2GDgoJO0jiC
         J9+eHej/2jEwJCeTBdeOmZn3iJU6UiZ0DWcfM49hzZs5Zcse65X9Tj67L0g7uYL8vOzE
         nELaXYj7cbUbuj8PMJqhbtb0CCJ47LCjyoUIlfREP9UWVa2UsLv1CWEczRfEkFiqNcjI
         BcCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uAJqUDEHClJ+6muOD0Ci8z+C8CfsR6yL8j/FHzuUqfc=;
        b=tKYJa/mTm2CGp1LPUEhrnPmKo8jPGHTpPgoQZ+21rmZ9NZEp7N9VXYKZ8ZRXkt40As
         rMU3Dn1oDB8IQE0mzNroQLTp00cM7UdbbEw9LNPUT1zpV0PN/P9Ctholgmtz5daS5oCy
         3mXDuNjVsSrQOXduk67zBG72ncH387+m94nI1xvSoGB7aQyujlSxiGsFDk7wrfQ5I8yz
         XoUMktmpJ6CXWBYuFd34cWN97AytlxCT4QKkE4kWyOV3QcuYBgdjX34PocUeWApBS6Yu
         Dacv28eZBEFmqKo3KENnevX7QWkRR2Qq35oe4FzfZ657nt/SjnSfC7O/GRB0+mj6VsqH
         Hbvg==
X-Gm-Message-State: APjAAAXxGUxaGf7BDeYywyxldYQzg5pV2CDintJisW+TEqMKutroqV62
        YQW6AzTkb/QIA7rOhHxoWJ4=
X-Google-Smtp-Source: APXvYqyd+elQFkHFNmOBPlmq8a9J/hOjJRIFBhuaBG1ns22WVYFELuwqmOAYQe+jYdmN6QLWau0zfw==
X-Received: by 2002:adf:800e:: with SMTP id 14mr14364064wrk.303.1557051584554;
        Sun, 05 May 2019 03:19:44 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id n2sm12333193wra.89.2019.05.05.03.19.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 03:19:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v3 05/10] net: dsa: Keep private info in the skb->cb
Date:   Sun,  5 May 2019 13:19:24 +0300
Message-Id: <20190505101929.17056-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190505101929.17056-1-olteanv@gmail.com>
References: <20190505101929.17056-1-olteanv@gmail.com>
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
Changes in v3:
  - Fixed the following checkpatch warnings in DSA_SKB_CB_CLONE:
    Macro argument reuse 'skb' - possible side-effects?
    Macro argument reuse 'clone' - possible side-effects?

Changes in v2:
  - None.

 include/net/dsa.h | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index c90ceeec7d1f..d628587e0bde 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -83,6 +83,37 @@ struct dsa_device_ops {
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
+#define DSA_SKB_CB_COPY(nskb, skb)		\
+	{ *__DSA_SKB_CB(nskb) = *__DSA_SKB_CB(skb); }
+
+#define DSA_SKB_CB_ZERO(skb)			\
+	{ *__DSA_SKB_CB(skb) = (struct __dsa_skb_cb) {0}; }
+
+#define DSA_SKB_CB_PRIV(skb)			\
+	((void *)(skb)->cb + offsetof(struct __dsa_skb_cb, priv))
+
+#define DSA_SKB_CB_CLONE(_clone, _skb)		\
+	{					\
+		struct sk_buff *clone = _clone;	\
+		struct sk_buff *skb = _skb;	\
+						\
+		DSA_SKB_CB_COPY(clone, skb);	\
+		DSA_SKB_CB(skb)->clone = clone; \
+	}
+
 struct dsa_switch_tree {
 	struct list_head	list;
 
-- 
2.17.1

