Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F471198592
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 22:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbgC3Ukx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 16:40:53 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55736 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728494AbgC3Ukv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 16:40:51 -0400
Received: by mail-wm1-f65.google.com with SMTP id r16so269253wmg.5
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 13:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TLSkwbkBmT9mvdGuUe/8YRoz6F0Zjj10CnTJyh7civM=;
        b=jLWl3OQ2xJ6UZIPQKsIXcNBti+Uxd3OvQ6mMriWgs5l7d4T+j1RKoq+8KJrDpmA8Q3
         sStRwPRDDcQlXh4uL73/vVawiO8ZuiqNWizVv7ECzkrjWQOMmi29X2kqA8Mdm+QY9nwn
         Q5f+o2YWIMXGwjW+lhdcj5UrCnK5eYeYBNPvKGYryZGaDB2c7ZCCZiXxn3WcQafc7+if
         lt0dBwGmh/v497kqUThpN0V3q66O412MG7p/kz1LAvp2VqXTsqz/ZosB+nt5YqseT/lO
         pAZLZk0UaQxV4CbHTj8q3MvhelnUJVZj6O7ZWz0fL49uFlc/38Ct2ggDwnEPqf00KWs/
         /LuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TLSkwbkBmT9mvdGuUe/8YRoz6F0Zjj10CnTJyh7civM=;
        b=N8Sz9HtkHd1Fo1Mf49zHyyY/jYO0Zv+EAQj+R9QD54HXnLt/ZBUAjAL73mmczvh056
         L/HS+Y3TBmCtJ2hdwr/knhSBPFN5V33pILnRJTQ/Cg5UoPF/SRPs0Ern9mzhTCgLOjC5
         ZJ0MrkvfPakLH2pHgBhn+QYu0n79SpAoADZe6XhEP1LQtNqaJYawIpdZeVzXKxufMPBH
         MWWJuzwvBgWNHlsRM3ma4rmyzNnAmSBwM34Tnl1b3dW95saj13R6JZ0NqeXGMRDQzZn2
         8Y1jK2jc3n90PptaqM3O0CE+dY1T4w6vJJZpSapXDkRgYehKbbPdU8NeRUTelfh1GIBx
         Ij6g==
X-Gm-Message-State: ANhLgQ2+06wjNTEd+ZSqm59wsR8Br3qFDqsd2QWpJnZFlbz4SDKSonmr
        PO5Y9LdgOdA8G+jpF1nt4G84wGfO
X-Google-Smtp-Source: ADFU+vs5QK78xGFx05bMsLdo1WCyAWcj5HBSr/DvJ9D42hCQ4Cn8fbCQ9YdtAjCz5MmfzcjKFlPnHQ==
X-Received: by 2002:a1c:56d5:: with SMTP id k204mr1131432wmb.13.1585600849172;
        Mon, 30 Mar 2020 13:40:49 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o16sm23371109wrs.44.2020.03.30.13.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 13:40:48 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        dan.carpenter@oracle.com
Subject: [PATCH net-next 4/9] net: dsa: b53: Deny enslaving port 7 for 7278 into a bridge
Date:   Mon, 30 Mar 2020 13:40:27 -0700
Message-Id: <20200330204032.26313-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330204032.26313-1-f.fainelli@gmail.com>
References: <20200330204032.26313-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7278, port 7 connects to the ASP which should only receive frames
through the use of CFP rules, it is not desirable to have it be part of
a bridge at all since that would make it pick up unwanted traffic that
it may not even be able to filter or sustain.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 42c41b091682..68e2381694b9 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1728,6 +1728,12 @@ int b53_br_join(struct dsa_switch *ds, int port, struct net_device *br)
 	u16 pvlan, reg;
 	unsigned int i;
 
+	/* On 7278, port 7 which connects to the ASP should only receive
+	 * traffic from matching CFP rules.
+	 */
+	if (dev->chip_id == BCM7278_DEVICE_ID && port == 7)
+		return -EINVAL;
+
 	/* Make this port leave the all VLANs join since we will have proper
 	 * VLAN entries from now on
 	 */
-- 
2.17.1

