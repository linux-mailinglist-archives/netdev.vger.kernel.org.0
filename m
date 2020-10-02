Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA8D280E54
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 09:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgJBH4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 03:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbgJBH4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 03:56:14 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7C8C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 00:56:12 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id o5so670092wrn.13
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 00:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f6NaUlbiFaG0QhwEZraCS9b07TNXa7e3Xcgo3B9hjfA=;
        b=ceLaeViDnK314Nnw6mNMuU4/86iD8iCG0p18BOB3Co4DyX3i/uAX9s3wQ5NDEjr8aG
         MU3m7/pTxhLhsXDrNxS9ADogKn644y04oo5lNFUd+Jz8VduNgSHazgeyhf9nmV+5N1D/
         m+fwJRYc/+bU4aC57QIrrH39ENwDiyznLFi4w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f6NaUlbiFaG0QhwEZraCS9b07TNXa7e3Xcgo3B9hjfA=;
        b=RPnTnZvP1aIyzfZXWWN8LH6ZVDebKNM3Q3krx0r9C447fJu8nxykce6Uq8SV+PreUp
         RkJc98hDTuUGuCji6FwCvjiwo5VKP3REl3W2lxDWJ9XxLr0js6QUt3pw5a/IlPYa9vQZ
         fx6N6CsKCrz8yORsZysvtX3/zIhu1f2PKAu00liwFPUwn29S+2KZr8lzlfXhKklLPOj9
         cfXbnPJP+Hrr461ZtN7V5pTn6dsR5w2vmpJquiep3gdvyDe1/ZJCNZKuz98AiWy9k87T
         +gRyjC/WNpvUE7+4FuQkiUYy7WhJzB/CQ0FUkdbOctLWh6DUUkM6TKqzKaeEgKjtAH8L
         cISA==
X-Gm-Message-State: AOAM533yD9zcdwSYF+5D2fud/zndrUxwqutZq4Wt6lxqyAHdppI/htOs
        RCn4q0U0ew6CDKpcThgFX5WvB0dLjOnXQw==
X-Google-Smtp-Source: ABdhPJwDPhtnvf+9GW1vSexqffi9809JuZhLDfQ9Ldfl7GqRgVf89K6O5OTWU9sKc1g4rG4OViMAVA==
X-Received: by 2002:adf:e44b:: with SMTP id t11mr1561662wrm.101.1601625371202;
        Fri, 02 Oct 2020 00:56:11 -0700 (PDT)
Received: from taos.konsulko.bg (lan.nucleusys.com. [92.247.61.126])
        by smtp.gmail.com with ESMTPSA id z11sm779217wru.88.2020.10.02.00.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 00:56:10 -0700 (PDT)
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Petko Manolov <petko.manolov@konsulko.com>
Subject: [PATCH v2] net: usb: pegasus: Proper error handing when setting pegasus' MAC address
Date:   Fri,  2 Oct 2020 10:56:04 +0300
Message-Id: <20201002075604.44335-1-petko.manolov@konsulko.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001.184218.21920326424555147.davem@davemloft.net>
References: <20201001.184218.21920326424555147.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2:

If reading the MAC address from eeprom fail don't throw an error, use randomly
generated MAC instead.  Either way the adapter will soldier on and the return
type of set_ethernet_addr() can be reverted to void.

v1:

Fix a bug in set_ethernet_addr() which does not take into account possible
errors (or partial reads) returned by its helpers.  This can potentially lead to
writing random data into device's MAC address registers.

Signed-off-by: Petko Manolov <petko.manolov@konsulko.com>
---
 drivers/net/usb/pegasus.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index e92cb51a2c77..39b78d8fcc79 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -360,28 +360,47 @@ static int write_eprom_word(pegasus_t *pegasus, __u8 index, __u16 data)
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
 
 static void set_ethernet_addr(pegasus_t *pegasus)
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
+	return;
+err:
+	eth_hw_addr_random(pegasus->net);
+	dev_info(&pegasus->intf->dev, "software assigned MAC address.\n");
+
+	return;
 }
 
 static inline int reset_mac(pegasus_t *pegasus)
-- 
2.28.0

