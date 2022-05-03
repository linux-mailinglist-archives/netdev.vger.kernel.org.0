Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B36F518153
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 11:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbiECJnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 05:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233604AbiECJm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 05:42:59 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F28A377FE
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 02:39:26 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id h29so22119926lfj.2
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 02:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=3LjBBJ47Nha4KKByZizg5Z1Et4EX0g80+0nhlhYqUqk=;
        b=eKfb/SZI7/pvCINMei4p6VKVucvEEm43wugrD3QAw//NXkXHb14iloqWnbhtpAT0OL
         zEdRpU2oh2DPzWiwA5QNMaJjdwUWmKgYRRh8N/5voWGNQRk+legOFnreKdrhtxMiK0q1
         PYsx7cPljYKuNFMT9XZIwnmko86aLCX0RBTpLyLBXb1tpflqVGsB+E/NiX1A3yDJzkZc
         OkswNaUTBjeGO17HPehW4RHGPK3WX84j5/rOeyYLncnAz+kE1mmGTM8S3JnqgQ2CR+XA
         7d+Xt4dZWmjJ8wN4bQoEG/qY+mSi+EKgW2G3o9SSKvybVeIub6AUnHMLVa4YZlh4UR6X
         Qh4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=3LjBBJ47Nha4KKByZizg5Z1Et4EX0g80+0nhlhYqUqk=;
        b=P+7XAM9pT1pbJ60tj+P5zaHTbQ9xTT5C9uobQ3Vth2HkXwXSRFZyeiXjrPjmKcgF82
         dVy9z8ZDeYxyr1GlwvGFaLX2951P9vuKwtVgtQptYBJ+OBHdZFf/hGUEhDJat60nbC/q
         hxmD0SHeBy9JYrGs3lCO40HZyvjmDVuXnf2KZybE3521X4/s1NJb31o+AEX6ApGtL9Sh
         GcbZgLvvKvJcSU+EC9zafgEx4QM+H2f+OTDUVZAVAJn9oBIKhPa2uIBc8z9OKdW71pxS
         ecFhf4P6LT1moYdHRR702ZknunLUI2egEcVt6B+Tr9gg8FbVa8lw/Tenb7yv+PTQNDdg
         k3AA==
X-Gm-Message-State: AOAM533OVQpcyFJVuIh3BjxahNtYeCZdp9lYxHX0CXquGsA+UxQ1VLDk
        PdfC7ylmxU0b9ai8fp0mEWk=
X-Google-Smtp-Source: ABdhPJwMIj8cOXk45NOac19Wndul2vxWgQJD/0Qt3tRnDvD5ADNVbhhwapNpLo+Neykn/8Q5Wzvx4w==
X-Received: by 2002:a05:6512:158d:b0:473:a59f:5b26 with SMTP id bp13-20020a056512158d00b00473a59f5b26mr2902080lfb.420.1651570764249;
        Tue, 03 May 2022 02:39:24 -0700 (PDT)
Received: from wse-c0155.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id d16-20020ac24c90000000b0047255d211a4sm909361lfl.211.2022.05.03.02.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 02:39:23 -0700 (PDT)
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: [PATCH net-next] net: sparx5: Add handling of host MDB entries
Date:   Tue,  3 May 2022 11:39:22 +0200
Message-Id: <20220503093922.1630804-1-casper.casan@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Handle adding and removing MDB entries for host

Signed-off-by: Casper Andersson <casper.casan@gmail.com>
---
 .../net/ethernet/microchip/sparx5/sparx5_switchdev.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index 5389fffc694a..3429660cd2e5 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -396,6 +396,11 @@ static int sparx5_handle_port_mdb_add(struct net_device *dev,
 	u32 mact_entry;
 	int res, err;
 
+	if (netif_is_bridge_master(v->obj.orig_dev)) {
+		sparx5_mact_learn(spx5, PGID_CPU, v->addr, v->vid);
+		return 0;
+	}
+
 	/* When VLAN unaware the vlan value is not parsed and we receive vid 0.
 	 * Fall back to bridge vid 1.
 	 */
@@ -461,6 +466,11 @@ static int sparx5_handle_port_mdb_del(struct net_device *dev,
 	u32 mact_entry, res, pgid_entry[3];
 	int err;
 
+	if (netif_is_bridge_master(v->obj.orig_dev)) {
+		sparx5_mact_forget(spx5, v->addr, v->vid);
+		return 0;
+	}
+
 	if (!br_vlan_enabled(spx5->hw_bridge_dev))
 		vid = 1;
 	else
@@ -500,6 +510,7 @@ static int sparx5_handle_port_obj_add(struct net_device *dev,
 						  SWITCHDEV_OBJ_PORT_VLAN(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
+	case SWITCHDEV_OBJ_ID_HOST_MDB:
 		err = sparx5_handle_port_mdb_add(dev, nb,
 						 SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
@@ -552,6 +563,7 @@ static int sparx5_handle_port_obj_del(struct net_device *dev,
 						  SWITCHDEV_OBJ_PORT_VLAN(obj)->vid);
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
+	case SWITCHDEV_OBJ_ID_HOST_MDB:
 		err = sparx5_handle_port_mdb_del(dev, nb,
 						 SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
-- 
2.30.2

