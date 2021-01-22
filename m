Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7A830005E
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 11:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbhAVK0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 05:26:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727387AbhAVJb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 04:31:29 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334DBC061788
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:31:10 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id x18so2874752pln.6
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vm6TTBkR6dYfTcRYc71shRvGfcxw75rAnNhZLex5e00=;
        b=f39JQ276pTFmiekRtHEZGEg6cVDttYIAfiaEyvN7MpCkuBTnL8M88LJSx53cNWmTUD
         3m5HsTyjWqisACI4Z0TC/5pQgVI2IZjPCnm80FlGA5xMe6SuYs5By45+vlvrjDaI7cc6
         GI0EvUuoQDdhX6l53iDla2r9L+hYG61ZH9JAWeWXgz14d5AbcaWsg3kP6wUcZVLDNoBI
         rZN8akIM1yYqWi9jTL2pGYxfJBCzd7pc/rAVEcf2HHfNC+vEbumEOjYl0yDeWAfr4oWj
         Q0S3yZn7zvyOZ0mCs4WrR36ybB2tJbw9uVRZ8iom4uD4DqC4vyBsghHoBHYD0VXgHp11
         AS4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vm6TTBkR6dYfTcRYc71shRvGfcxw75rAnNhZLex5e00=;
        b=T2SlpC2jR1w6vBtnM/yue6lgQe2IXwo/Bp9JpB43AtFouI0NO/NzKj6xbMUryvrac4
         qyUayK4UqI3UDkMsBxsvxh++fv2e4RNMMDhlfbDfrBOggaq3Idkincdu87YXH7/11aAI
         +hUUqrv79ELM9NqFDzYsQCKTTQKG2AMWmJdZsTKWjsE23ii1AimQ1OY+XnQ+x8ZkF5PR
         UJhPeaPGMOkyjsubAhiuXr0vuS2t0sQ3sPobKEOlI8499T+zFtvJ2GLMUAMIuSRTHO27
         +A7w3BPHHUuUKF3/KkfRnKhs6an0/RDZguKVkTjPEXQHyUlPTxpU62Zp+IT/mLgqUTCj
         4Mjg==
X-Gm-Message-State: AOAM5308jrXrNsV3vgcRrPx7czqLlAbvll+Gkok5WRMEIzJYsTRi+foc
        G1v5241+WUb8+Oo5bRz5rxz91hiQtads4g==
X-Google-Smtp-Source: ABdhPJz0xo/uZw9oyDI3jye+vUPzHP+f7S1X3V6ImV3GBRgCJbguT0fWcVe9aYIoxx6u+QINiCGi7g==
X-Received: by 2002:a17:90a:6c90:: with SMTP id y16mr4432678pjj.129.1611307869502;
        Fri, 22 Jan 2021 01:31:09 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p7sm8213567pfn.52.2021.01.22.01.31.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Jan 2021 01:31:08 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH net-next] net: hns3: replace skb->csum_not_inet with skb_csum_is_sctp
Date:   Fri, 22 Jan 2021 17:31:01 +0800
Message-Id: <3ad3c22c08beb0947f5978e790bd98d2aa063df9.1611307861.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit fa8211701043 ("net: add inline function skb_csum_is_sctp")
missed replacing skb->csum_not_inet check in hns3. This patch is
to replace it with skb_csum_is_sctp().

Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 405e490..5120806 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1070,7 +1070,7 @@ static bool hns3_check_hw_tx_csum(struct sk_buff *skb)
 	 * HW checksum of the non-IP packets and GSO packets is handled at
 	 * different place in the following code
 	 */
-	if (skb->csum_not_inet || skb_is_gso(skb) ||
+	if (skb_csum_is_sctp(skb) || skb_is_gso(skb) ||
 	    !test_bit(HNS3_NIC_STATE_HW_TX_CSUM_ENABLE, &priv->state))
 		return false;
 
-- 
2.1.0

