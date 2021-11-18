Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD1C455508
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 08:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243518AbhKRHEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 02:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238258AbhKRHEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 02:04:23 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9D3C061570;
        Wed, 17 Nov 2021 23:01:23 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so6045784pjb.1;
        Wed, 17 Nov 2021 23:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oM4jK15lu4pb/vtYZCteppAAAeGITk9zIwzzPns4s2M=;
        b=Yg4QTkpHOhKs4fBF2mv/OAGj3o2BQ2/riUOjUg40zxhb7sUkdERxwISdHtipQbWltY
         hcO2BpQ4CGAHHtHXdMu8suVuJt7s/9ZkLInUnNoxDvJNjEtuZDztyrDVFj2+6mRKQZcz
         ToITmBWvAdFjDxN2QpXJhpsY+Nsx+NsRa5yALHimrc4QqRfO2dKUlkB8A2iAvS1qXE3R
         xPFNgk4cNFv41sL+bJTN0JyicURtbbtuCb33UuJ1AlcxlyvhfnjUrSMXbO1/xTHUioZv
         /4IhZEWhvMw8TxN5566UiaSQHnX/u5bQfyX5GldGpfkU+NNLFU6qinpInbXoq0YzWt5z
         RkJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oM4jK15lu4pb/vtYZCteppAAAeGITk9zIwzzPns4s2M=;
        b=DzBP934ABJhOBonk4z6PGuDaHZNAGAM2MZn7q6+ya5/0uqEM8KUamrY3pO4QDWKnls
         tebT2ZVOkkv45seJ5Et6hwwVzsu7tzurYUmRj3LbQX9xII8fQtrWPfkzODZe5nctlngI
         1lNcGcLxkZPHWKIl6I7qWbGE+/g+zpK+zpl5uCc5lhuMQP7J4dISb6qFHBqeGVU47sck
         cXkWFzTSk55EQPqbl62kQFgDjN5mTl4B8/o0AJ2U5TwucIQ+2+hinheNuN2G8iUh/yLN
         3BVzZamdS4t7ArMlZ6coE89KPiTBXCHaDxxJRW+5k3tB971w4bf75WQoI9Qm7whEd46P
         TYyA==
X-Gm-Message-State: AOAM530wGu49HGGgSvgCij6nl0rNaJ74pG+aGE4nlaMV8duOfz5lpNRY
        2gM0q/g0UWMAm77cAOewgtU=
X-Google-Smtp-Source: ABdhPJwWsJla+gLDtPWKcLO66tAPghK3N7UvA75f2P8LyQNKxURsj+zxVkMieuZSK3ta2TE6Rd8/gA==
X-Received: by 2002:a17:90a:1b26:: with SMTP id q35mr7580985pjq.212.1637218882909;
        Wed, 17 Nov 2021 23:01:22 -0800 (PST)
Received: from localhost ([219.142.138.170])
        by smtp.gmail.com with ESMTPSA id u23sm1775337pfl.105.2021.11.17.23.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 23:01:22 -0800 (PST)
From:   Teng Qi <starmiku1207184332@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, tanghui20@huawei.com,
        arnd@arndb.de
Cc:     netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        islituo@gmail.com, Teng Qi <starmiku1207184332@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH v2] net: ethernet: dec: tulip: de4x5: fix possible array overflows in type3_infoblock()
Date:   Thu, 18 Nov 2021 15:01:18 +0800
Message-Id: <20211118070118.63756-1-starmiku1207184332@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The definition of macro MOTO_SROM_BUG is:
  #define MOTO_SROM_BUG    (lp->active == 8 && (get_unaligned_le32(
  dev->dev_addr) & 0x00ffffff) == 0x3e0008)

and the if statement
  if (MOTO_SROM_BUG) lp->active = 0;

using this macro indicates lp->active could be 8. If lp->active is 8 and
the second comparison of this macro is false. lp->active will remain 8 in:
  lp->phy[lp->active].gep = (*p ? p : NULL); p += (2 * (*p) + 1);
  lp->phy[lp->active].rst = (*p ? p : NULL); p += (2 * (*p) + 1);
  lp->phy[lp->active].mc  = get_unaligned_le16(p); p += 2;
  lp->phy[lp->active].ana = get_unaligned_le16(p); p += 2;
  lp->phy[lp->active].fdx = get_unaligned_le16(p); p += 2;
  lp->phy[lp->active].ttm = get_unaligned_le16(p); p += 2;
  lp->phy[lp->active].mci = *p;

However, the length of array lp->phy is 8, so array overflows can occur.
To fix these possible array overflows, we first check lp->active and then
return -EINVAL if it is greater or equal to ARRAY_SIZE(lp->phy) (i.e. 8).

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Teng Qi <starmiku1207184332@gmail.com>
---
v2:
* Check lp->active in separate if statement within macro WARN_ON() and 
return -EINVAL if it is greater or equal to ARRAY_SIZE(lp->phy). Instead
of checking lp->active and MOTO_SROM_BUG together in the same if
statement.
  Thank Arnd Bergmann for helpful and friendly suggestion.
---
 drivers/net/ethernet/dec/tulip/de4x5.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
index 13121c4dcfe6..828b9642fd68 100644
--- a/drivers/net/ethernet/dec/tulip/de4x5.c
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c
@@ -4709,6 +4709,10 @@ type3_infoblock(struct net_device *dev, u_char count, u_char *p)
         lp->ibn = 3;
         lp->active = *p++;
 	if (MOTO_SROM_BUG) lp->active = 0;
+	/* if (MOTO_SROM_BUG) statement indicates lp->active could
+	 * be 8 (i.e. the size of array lp->phy) */
+	if (WARN_ON(lp->active >= ARRAY_SIZE(lp->phy)))
+		return -EINVAL;
 	lp->phy[lp->active].gep = (*p ? p : NULL); p += (2 * (*p) + 1);
 	lp->phy[lp->active].rst = (*p ? p : NULL); p += (2 * (*p) + 1);
 	lp->phy[lp->active].mc  = get_unaligned_le16(p); p += 2;
-- 
2.25.1

