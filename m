Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEE94324ED
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 23:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfFBVP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 17:15:59 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37164 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfFBVP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 17:15:59 -0400
Received: by mail-wm1-f66.google.com with SMTP id 22so830822wmg.2
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 14:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sj4dqvMm0mIJobNSmfRRpHGF+qpUHGKapyqUALrmjSc=;
        b=YxQv1j1lqYzAZKcsHusMA/G+KBQK3lWH4AC24VXVvIPyQ6TX5TKmbMMk5YJTCCziWx
         LFkd7fL1rF5ZpGnYyEM5VEG3ekK6AaSTHYkbDdyOfpJvk0EGELfvlP93wp2OQFeLyjJw
         ZjLNXphGgwLhh1Mm2SCRiQK9GEKb0aaflYbpV60CjctZqiap52fLwEUgTkhgHJCEQLtw
         qlYUUeyrgWid8/2y1ADi+uQcWn1TJvamR89tqEmSRiTRHBnwN7Gado2XMnxv5yk8/6s7
         9J8Ya50qG1keMUWh4c0PtfLphI9hcV1FP9j/FMreHYQpZJeBwLADtBgKKj8s6opGQTIU
         XiJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sj4dqvMm0mIJobNSmfRRpHGF+qpUHGKapyqUALrmjSc=;
        b=bSXef/fUoznc5bI8ARp+CBGQfIke2+AMw1lzR/opnUu5nxlyI0e01toiIS6uOCykcT
         /6LSXa0NEDcyD0g8FluMetYkNkJTOR0M/xHdv1xX2rm/8pFJp56x+A4kbayue7ten+9Z
         h2K601MomJld6GBQtyiU0EwnCHgv0bt7XJg/KHvP6BaawyWQTG7QOfUrj/Ymc9ut+UQ+
         C9WFhv9vp+WIv5Ri2bxO6NG1afmpflxr/uGiWS5Md6H8FvRfuknwWWW/CwZF63TTpFK6
         oxXAmlR96G57q3xIu0iUH9ZGZj77i/SrpGumkm3weNJIrsVy8TZNb51J+baSVyyZlw3p
         8XLw==
X-Gm-Message-State: APjAAAVHE4433uWd8cAqQzGDhPqqM6p/GY/7XIXY1s+6RpmvDYKEQ6no
        vZR2KoX6P889NfOkV0JJOSFEvpXK
X-Google-Smtp-Source: APXvYqx6NFPMAVgN7g4GfJ1n6WrQRkohWUSYZtFB9VaASv5IqM/tZz9KcijV+ntCEwzwIlq3aeqy+A==
X-Received: by 2002:a1c:b046:: with SMTP id z67mr3449wme.49.1559510157078;
        Sun, 02 Jun 2019 14:15:57 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id b5sm2507790wru.69.2019.06.02.14.15.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 14:15:57 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 10/11] net: dsa: sja1105: Unset port from forwarding mask unconditionally on fdb_del
Date:   Mon,  3 Jun 2019 00:15:54 +0300
Message-Id: <20190602211554.19066-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a cosmetic patch that simplifies the code by removing a
redundant check. A logical AND-with-zero performed on a zero is still
zero.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 46e2cc7b9ddc..8343dcf48384 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -903,8 +903,8 @@ int sja1105et_fdb_del(struct dsa_switch *ds, int port,
 	 * need to completely evict the FDB entry.
 	 * Otherwise we just write it back.
 	 */
-	if (l2_lookup.destports & BIT(port))
-		l2_lookup.destports &= ~BIT(port);
+	l2_lookup.destports &= ~BIT(port);
+
 	if (l2_lookup.destports)
 		keep = true;
 	else
-- 
2.17.1

