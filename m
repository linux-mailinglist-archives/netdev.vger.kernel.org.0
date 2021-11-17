Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F8A453F0B
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 04:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhKQDlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 22:41:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbhKQDla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 22:41:30 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C90C061570;
        Tue, 16 Nov 2021 19:38:33 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id o4so1300270pfp.13;
        Tue, 16 Nov 2021 19:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rQq11xFkw/BPjiAqJUS0qL3YlZ0wnk9p2eHvH/zNYRU=;
        b=Y0m9OeC9lvXMLcuFtyLjqpKFzzNBfi3afkgMRsGStx+tM2mmyUAELpMXhaFaZDe2rt
         5t3hBghiQvgz4/nZPcz0Ly1FA9AEMekqD3pZqGUmHHVfG9ellmcSHgn4o0ffIYU2Vb+j
         cK52Bgpwq2jxFneHVNvF96Rqjy9Osgd28vjDXKXJYcWClZiq6HyCUUAmLwf315esnuul
         88QIqVH6dA0owwnP8OcAsprq+SunLRvpkdzrBa1IZo+AssYDCmAcR1NCeICB8LkdvKSh
         Zi69fYJP4VPmd8TxNqGHgkU4G4D5TOwx+TQ3psS8c8jY0gZsZPOBieZqCzZNIX7/SIMw
         Q0WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rQq11xFkw/BPjiAqJUS0qL3YlZ0wnk9p2eHvH/zNYRU=;
        b=tZ4qEd6wpbzrXWWKuMfdJ+0OjKj1GD9vFDkWEAi8uCh2l1psR32mRq2MmQK9r7fYUe
         4NOIkRjxuwmUHMPpeh1Q+1a7eYQrPAbKEu/Fp7iN6eQXll+nZieb7vw7t1x+dXtOOj+v
         B/DcRdmx3dcp3npyRgKPskvdMwrwoCkX9xjYuGmA7/HSnubBPmEIHP70eEuRYUrBuC4S
         NJmy2w+2fnlCH4c7REmHZ2la9+5BABnBN73fLMSVka1C2ILAS8zFG5ATbdSRFX7OL6NA
         OX281de5R+PvPI/tKUcL2N02pl6s5ygP+VMA1wvlxbsvckCYE4I3abCrqTdDcQPzDggp
         YObg==
X-Gm-Message-State: AOAM531L4rupr7tx+M6kcrbT1k8HLhxaaKJ6u6Iz3LfSiOJhbzKAXejB
        1wqLOPCl2FofOA0tXjCkuTPFdlcjndM=
X-Google-Smtp-Source: ABdhPJyXHGKxzQ6qxBxwGUon2detmxzpTkjRzRXxg1fs2zD7LuJujSU+PrMUBC3h8DrhYkxymIHVgg==
X-Received: by 2002:a65:5386:: with SMTP id x6mr3013436pgq.27.1637120312524;
        Tue, 16 Nov 2021 19:38:32 -0800 (PST)
Received: from localhost ([219.142.138.170])
        by smtp.gmail.com with ESMTPSA id a3sm21645875pfv.5.2021.11.16.19.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 19:38:32 -0800 (PST)
From:   Teng Qi <starmiku1207184332@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        tanghui20@huawei.com
Cc:     netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        islituo@gmail.com, Teng Qi <starmiku1207184332@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH] net: ethernet: dec: tulip: de4x5: fix possible array overflows in type3_infoblock()
Date:   Wed, 17 Nov 2021 11:37:38 +0800
Message-Id: <20211117033738.28734-1-starmiku1207184332@gmail.com>
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
set it to 0 if it is equal to DE4X5_MAX_PHY (i.e., 8).

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Teng Qi <starmiku1207184332@gmail.com>
---
 drivers/net/ethernet/dec/tulip/de4x5.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
index 13121c4dcfe6..18132deac2bf 100644
--- a/drivers/net/ethernet/dec/tulip/de4x5.c
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c
@@ -4708,7 +4708,8 @@ type3_infoblock(struct net_device *dev, u_char count, u_char *p)
     if (lp->state == INITIALISED) {
         lp->ibn = 3;
         lp->active = *p++;
-	if (MOTO_SROM_BUG) lp->active = 0;
+	/* The DE4X5_MAX_PHY is length of lp->phy, and its value is 8 */
+	if (MOTO_SROM_BUG || lp->active == DE4X5_MAX_PHY) lp->active = 0;
 	lp->phy[lp->active].gep = (*p ? p : NULL); p += (2 * (*p) + 1);
 	lp->phy[lp->active].rst = (*p ? p : NULL); p += (2 * (*p) + 1);
 	lp->phy[lp->active].mc  = get_unaligned_le16(p); p += 2;
-- 
2.25.1

