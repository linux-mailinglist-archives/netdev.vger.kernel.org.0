Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477144FF543
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbiDMKzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235031AbiDMKyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:54:52 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030B55A092
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:52:31 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id r13so3114220ejd.5
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rJB5kY6uPDJBtefnM9IfoNFJA4wwW57RZ1b7IzeHqA8=;
        b=hFdUSE4bdm3dm9ztdRKdeW/8cbk4xAYciXTuexkfId9nwCQCdmTBDzeHXaqgfzjQeN
         TZ/NsAKsRRvweTRt2EAW52YSO+2mnhtdOAADDKVaHA29uMQoS03VdTeW+86igTTMvECm
         ACUEP0LU5+tvPzhM4FJMzoBBmtRsIdRlXdQybuROhvIA4uHgrdlQvGSuaUsKQsOfSfVd
         RAybgRhJX6iwXEaoer6mxl6iJv8mrCSldsW804bEl+UIOMiYiD/oT8/MH7A8qdcFgKGj
         f5lFRyib564wGTYRT586IEXe6XyOsMfYecXCpGxRiZOTZQWKxMFiVOVTROU+brqsTDm6
         xBow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rJB5kY6uPDJBtefnM9IfoNFJA4wwW57RZ1b7IzeHqA8=;
        b=2GEmuGefV1Kw8PSbuekNW+UMB+LP5v4NZSd6FueHkv7D3uKwLsi9ml2hdNOLxr1qdC
         /Xdxqc/nkhtE6kpbj9gRwMoxMFF79gUnUq3YKVoMwBgrKdTdB3DHSYTukgs6Rmt2Zxkd
         mZ9LTJKP8qtXYb/S9PfeKW6aiM/dB2akXB12dZ3ivpFN4mZaNbzsLFhBpRQbZt3aPmHS
         2Uq/U8B6Gz9rgPmMwES8PqKczM+xdpRrBjcsp8oKFW4XB2KP1EOcDlMWfIWB460UOExu
         IHqGnlH0O2S/wv/fRVleTPohR9enT7v9TIGG9iKYXbbiNNFMp+XYWHrx82t+C2DU4r4r
         MwYg==
X-Gm-Message-State: AOAM531hcE3AH/VZ4OcZcLcNUdz3fmMU2xgVfvAePZqt0MUuCTANEpjQ
        XNCQ7l4VyikwbOjLIqblZoWwm8UdhzJVekm3
X-Google-Smtp-Source: ABdhPJxijpQhvK5fjap/CpjUrcUOdp8IrX5N4BwQia6pFPOIIL6KglnkwHXURm36vZ9YMjhMtvDBHg==
X-Received: by 2002:a17:907:9506:b0:6da:b4cd:515b with SMTP id ew6-20020a170907950600b006dab4cd515bmr38189893ejc.602.1649847149264;
        Wed, 13 Apr 2022 03:52:29 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id v8-20020a1709063bc800b006e898cfd926sm2960952ejf.134.2022.04.13.03.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 03:52:28 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v4 08/12] net: bridge: fdb: add ndo_fdb_del_bulk
Date:   Wed, 13 Apr 2022 13:51:58 +0300
Message-Id: <20220413105202.2616106-9-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413105202.2616106-1-razor@blackwall.org>
References: <20220413105202.2616106-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a minimal ndo_fdb_del_bulk implementation which flushes all entries.
Support for more fine-grained filtering will be added in the following
patches.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
v4: don't rename br_fdb_flush

 net/bridge/br_device.c  |  1 +
 net/bridge/br_fdb.c     | 23 +++++++++++++++++++++++
 net/bridge/br_private.h |  3 +++
 3 files changed, 27 insertions(+)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 8d6bab244c4a..58a4f70e01e3 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -465,6 +465,7 @@ static const struct net_device_ops br_netdev_ops = {
 	.ndo_fix_features        = br_fix_features,
 	.ndo_fdb_add		 = br_fdb_add,
 	.ndo_fdb_del		 = br_fdb_delete,
+	.ndo_fdb_del_bulk	 = br_fdb_delete_bulk,
 	.ndo_fdb_dump		 = br_fdb_dump,
 	.ndo_fdb_get		 = br_fdb_get,
 	.ndo_bridge_getlink	 = br_getlink,
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 6ccda68bd473..363985f1a540 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -572,6 +572,29 @@ void br_fdb_flush(struct net_bridge *br)
 	spin_unlock_bh(&br->hash_lock);
 }
 
+int br_fdb_delete_bulk(struct ndmsg *ndm, struct nlattr *tb[],
+		       struct net_device *dev, u16 vid,
+		       struct netlink_ext_ack *extack)
+{
+	struct net_bridge_port *p = NULL;
+	struct net_bridge *br;
+
+	if (netif_is_bridge_master(dev)) {
+		br = netdev_priv(dev);
+	} else {
+		p = br_port_get_rtnl(dev);
+		if (!p) {
+			NL_SET_ERR_MSG_MOD(extack, "Device is not a bridge port");
+			return -EINVAL;
+		}
+		br = p->br;
+	}
+
+	br_fdb_flush(br);
+
+	return 0;
+}
+
 /* Flush all entries referring to a specific port.
  * if do_all is set also flush static entries
  * if vid is set delete all entries that match the vlan_id
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 6e62af2e07e9..f37d49bf5637 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -781,6 +781,9 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 
 int br_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
 		  struct net_device *dev, const unsigned char *addr, u16 vid);
+int br_fdb_delete_bulk(struct ndmsg *ndm, struct nlattr *tb[],
+		       struct net_device *dev, u16 vid,
+		       struct netlink_ext_ack *extack);
 int br_fdb_add(struct ndmsg *nlh, struct nlattr *tb[], struct net_device *dev,
 	       const unsigned char *addr, u16 vid, u16 nlh_flags,
 	       struct netlink_ext_ack *extack);
-- 
2.35.1

