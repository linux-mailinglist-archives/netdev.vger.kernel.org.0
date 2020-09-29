Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C89627C820
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 13:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731651AbgI2L7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 07:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729322AbgI2Ll1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 07:41:27 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B7FC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 04:41:27 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id c18so4986271wrm.9
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 04:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XUngUu4HVak2fl3G5w7GkKRH/esnX0yARyWxIl0qyFM=;
        b=G4qaSumRJCUQPH1Qvc9dip5Rt+mYe2cjC5IWlzOgoeSth7zBIaKGkR95HdAB0OVtpa
         XTmNCr7nqCzFkF9bmuKVDmILNWaFK/nYE87rzKSrIzeT6EvmBpuUPcaqGySM0PAp4Xxl
         Vz47kWT61X37khVa60mifW2m6DblWo0iWkGHo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XUngUu4HVak2fl3G5w7GkKRH/esnX0yARyWxIl0qyFM=;
        b=iqz3pdBEG8Frp2H79O9x1hso8/IUohfVjmcblLQIrbV5cGxfkZ2gE5bUhCkcGu8BXw
         wmQSPnoDrddXWk7dF47Ihp4YsucfyI/LuUkX7mokFrcjCUBZ9FsIp1Dg7n/+1bNOklaV
         wi5BqHk5uyAcz20o07pyxRe/ck/19iQo9+dk2Oan5+Yv4QGpT+ey4z2ofCmc9yC7dc58
         SslnYFG53iQKhX3kbspfcZNyc+zeaXjoiO06FXWOXC+3Pq/7cLD9e6IttzFWaZUAbuQV
         KLP1S3Ap97YzX1Bjs/I9m/bv1ZtciqfP+6aMt5sqv6nkAXqX/PAFwCtMLyD2gHYPY/+w
         jOfg==
X-Gm-Message-State: AOAM5329D/ORida1CIdBXPU1z8a80sLoCzebXMxbSDTxw9yIrWEWXnu0
        HmifSe0tp3g99qqPf5VjbIqCWgyRlS2nyQ==
X-Google-Smtp-Source: ABdhPJy6WnAbqGE9MBfBy48s8h7QTvHkqRxdHNfrVINjX1VHZLMoE18NRemaeTB+Cxx1o9qZ+qHnZA==
X-Received: by 2002:a05:6000:118a:: with SMTP id g10mr3929186wrx.67.1601379685471;
        Tue, 29 Sep 2020 04:41:25 -0700 (PDT)
Received: from taos.konsulko.bg (lan.nucleusys.com. [92.247.61.126])
        by smtp.gmail.com with ESMTPSA id t15sm5826577wrp.20.2020.09.29.04.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 04:41:25 -0700 (PDT)
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Petko Manolov <petko.manolov@konsulko.com>
Subject: [PATCH] net: usb: pegasus: Proper error handing when setting pegasus' MAC address
Date:   Tue, 29 Sep 2020 14:40:39 +0300
Message-Id: <20200929114039.26866-1-petko.manolov@konsulko.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a bug in set_ethernet_addr() which does not take into account possible
errors (or partial reads) returned by its helpers.  This can potentially lead to
writing random data into device's MAC address registers.

Signed-off-by: Petko Manolov <petko.manolov@konsulko.com>
---
 drivers/net/usb/pegasus.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index e92cb51a2c77..25855f976c1b 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -360,28 +360,45 @@ static int write_eprom_word(pegasus_t *pegasus, __u8 index, __u16 data)
 }
 #endif				/* PEGASUS_WRITE_EEPROM */
 
-static inline void get_node_id(pegasus_t *pegasus, __u8 *id)
+static inline int get_node_id(pegasus_t *pegasus, u8 *id)
 {
-	int i;
-	__u16 w16;
+	int i, ret;
+	u16 w16;
 
 	for (i = 0; i < 3; i++) {
-		read_eprom_word(pegasus, i, &w16);
+		ret = read_eprom_word(pegasus, i, &w16);
+		if (ret < 0)
+			return ret;
 		((__le16 *) id)[i] = cpu_to_le16(w16);
 	}
+
+	return 0;
 }
 
-static void set_ethernet_addr(pegasus_t *pegasus)
+static int set_ethernet_addr(pegasus_t *pegasus)
 {
-	__u8 node_id[6];
+	int ret;
+	u8 node_id[6];
 
 	if (pegasus->features & PEGASUS_II) {
-		get_registers(pegasus, 0x10, sizeof(node_id), node_id);
+		ret = get_registers(pegasus, 0x10, sizeof(node_id), node_id);
+		if (ret < 0)
+			goto err;
 	} else {
-		get_node_id(pegasus, node_id);
-		set_registers(pegasus, EthID, sizeof(node_id), node_id);
+		ret = get_node_id(pegasus, node_id);
+		if (ret < 0)
+			goto err;
+		ret = set_registers(pegasus, EthID, sizeof(node_id), node_id);
+		if (ret < 0)
+			goto err;
 	}
+
 	memcpy(pegasus->net->dev_addr, node_id, sizeof(node_id));
+
+	return 0;
+err:
+	dev_err(&pegasus->intf->dev, "device's MAC address not set.\n");
+	return ret;
 }
 
 static inline int reset_mac(pegasus_t *pegasus)
-- 
2.28.0

