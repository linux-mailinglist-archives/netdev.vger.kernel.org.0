Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72650224912
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 07:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgGRFrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 01:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgGRFri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 01:47:38 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A70C0619D2;
        Fri, 17 Jul 2020 22:47:38 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id p205so12552554iod.8;
        Fri, 17 Jul 2020 22:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PfMs+d/8rTE+DczufHJcceGTZEwuJydHZFIhdNSBBA8=;
        b=tZEuFSnzOKQNapUURfRPWVJlMGLxwDsc4jXnrSjXLGBfCvGcdp02PlJzyzbWL+dF+I
         E4qVcG/Rlm+QMeRneEgs6jE0OgLfeBw+DVmu5V7PJRgBXw98TjxGLqCppUf95oqhL64E
         B6ZA7pztL+9zIF8GDAEsm1+20D+2Di3ITfyd9j2FmT9pC/wiBoiMHAxeVhiV2FrjxxPl
         svTx7ET5DMcSr8rED/xMCU+g6bCm2KDH9HqFQ9VgLt6mwm3SDtQ+Z1qe55mqdYLOS2h9
         66+7yI/tO3Zxdj7b4byEhSWMEi/2EwOxTAcXbhEUnJejoVHbzlBomcufa2sBoi15m3f7
         Rnyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PfMs+d/8rTE+DczufHJcceGTZEwuJydHZFIhdNSBBA8=;
        b=OInwT7t5/o7BI3xxvsEz4U2mxM3dsQTXRgbIWjggwRzv2SlQxjUjw0WNwXwX/DOQHn
         VzHopHMvhPisThMPKRy4BoW/vIIfZy+Fe5w0F5NitwJy4TJo9rrlMzqiMo5YvhshmqIY
         Y0HWhpJ6bC3rIKD1xqtjGgwd/nayKvYyMISaTbSm4aZKSDCAsv/v4tKzkh7f8XTDgQd1
         pSdaRuifjLebD/8LxMo0BMKT6/wCcwKkIUyTD1c9OVdLid9JeSnzxQ64FbMLmhElWMLG
         JQcwX4drJB2O2vRJfT2toBNqh/HrCZpDsU7YV4kUJHL8D7l6ufqpDQD4UW1AaZT4VN8I
         QGSA==
X-Gm-Message-State: AOAM533e1oODvQ4ty5ApSMZx66GQrNM/X+oVjfxlZ3ucqwmbTHuYGa+A
        2gL3+KJzPI01mTJCFQyjF1HveFsjYXA=
X-Google-Smtp-Source: ABdhPJwmz9PHgLFVxAiR8ICQT3HOsuOshxUJ0WFWXkZT30fBjDH8pGlL70enm1kjAc+Wp58AwhZBSg==
X-Received: by 2002:a6b:f911:: with SMTP id j17mr12389586iog.96.1595051257928;
        Fri, 17 Jul 2020 22:47:37 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [160.94.145.20])
        by smtp.googlemail.com with ESMTPSA id e16sm5852663iow.37.2020.07.17.22.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 22:47:37 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     emamd001@umn.edu, Navid Emamdoost <navid.emamdoost@gmail.com>
Subject: [PATCH] mt76: mt76u: add missing release on skb in __mt76x02u_mcu_send_msg
Date:   Sat, 18 Jul 2020 00:47:26 -0500
Message-Id: <20200718054727.13009-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the implementation of __mt76x02u_mcu_send_msg() the skb is consumed
all execution paths except one. Release skb before returning if
test_bit() fails.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
index a30bb536fc8a..e43d13d7c988 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
@@ -87,8 +87,10 @@ __mt76x02u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 	u32 info;
 	int ret;
 
-	if (test_bit(MT76_REMOVED, &dev->phy.state))
-		return 0;
+	if (test_bit(MT76_REMOVED, &dev->phy.state)) {
+		ret = 0;
+		goto out;
+	}
 
 	if (wait_resp) {
 		seq = ++dev->mcu.msg_seq & 0xf;
@@ -111,6 +113,7 @@ __mt76x02u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 	if (wait_resp)
 		ret = mt76x02u_mcu_wait_resp(dev, seq);
 
+out:
 	consume_skb(skb);
 
 	return ret;
-- 
2.17.1

