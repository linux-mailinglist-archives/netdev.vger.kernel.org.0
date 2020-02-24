Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5522E169F59
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 08:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbgBXHgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 02:36:15 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38925 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727325AbgBXHgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 02:36:08 -0500
Received: by mail-wm1-f66.google.com with SMTP id c84so8194050wme.4
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 23:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1VufEhKPNHGR/xZhVO09DMXHV775aoYxmHQB0H4BEhs=;
        b=wz/EtSeWXTv1W7KHT7HuBQbmUmjlVnjKjX+yehVAUhCpResQ9BKiTF8CkSKAzWzVnb
         ILg48O5DZXot2Uh/V4QbEtZBgYppS2RcF1WWLVFrnJ95/XXuhvj+va71S+UheEXHkCP1
         F4UygawH4H/4GYNfWGqlkH0mnxfVuKindrE1VN4SAGSD8AsHa4VUzCap2nHr6k8EDr/7
         tCA05hNpjLqzl1IHu8Ek9ldOMxHqP3jhKqCuQdzRMP+B3D7alP5DXpIxYqnj+PNu7WWf
         fKbDRmwqJKdsMWbq43mbkTtfHRyeoIM//IqSx4czvnRtPygBIZdbFNRL0oCeS670HURA
         tPYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1VufEhKPNHGR/xZhVO09DMXHV775aoYxmHQB0H4BEhs=;
        b=qeFu+ryljjS814V3idYz0CQ+bHnqqwkhst1zSVzd4OWMtxjH8LHA6tJP4eWZ6ZtgiE
         oOOlmrEAFuBq1tSZSDq+eCTI8H2aahqt6R8+QMuzAWKUb/QDB0yM5IwvI56sNXsTnYL0
         07MCtAWYu4mW+U0Hpd9rvqKbuz56pFxQpMOW011p2jUdcK39ZedIluZX2aJttSbe5YiB
         +Zf3IqbOBMqHwZYSn71GCqRTNTCERLwlB60GH2pxcT4cYvKyxwV+3GoyrI76ec5AXfO0
         fOERxexG9KvFiVgPThX1vjvE0AOkNXw+XILHhAanaoFWZG5T/aFhIKaPJ5mFDH9Z8Zfl
         7elw==
X-Gm-Message-State: APjAAAXmaABt1rh26XVL5j1vVFVK1rbeCYkL1YhCqCUGgelddCKKa9VU
        A2j3UUW3eZzlcsc5Nr8Iu0gxJHamZbI=
X-Google-Smtp-Source: APXvYqxTFChMrchSGUtqeNXbNCT4/lB7+XHyJ1FvqhF+bbPNxgub5dbVqWs2OG0XfKNvkbqrhS/T/Q==
X-Received: by 2002:a1c:7fd7:: with SMTP id a206mr20435348wmd.171.1582529765454;
        Sun, 23 Feb 2020 23:36:05 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id z4sm17494293wrt.47.2020.02.23.23.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 23:36:05 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 05/16] devlink: add ACL generic packet traps
Date:   Mon, 24 Feb 2020 08:35:47 +0100
Message-Id: <20200224073558.26500-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200224073558.26500-1-jiri@resnulli.us>
References: <20200224073558.26500-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Add packet traps that can report packets that were dropped during ACL
processing.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 Documentation/networking/devlink/devlink-trap.rst | 9 +++++++++
 include/net/devlink.h                             | 9 +++++++++
 net/core/devlink.c                                | 3 +++
 3 files changed, 21 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index 47a429bb8658..63350e7332ce 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -238,6 +238,12 @@ be added to the following table:
      - ``drop``
      - Traps NVE packets that the device decided to drop because their overlay
        source MAC is multicast
+   * - ``ingress_flow_action_drop``
+     - ``drop``
+     - Traps packets dropped during processing of ingress flow action drop
+   * - ``egress_flow_action_drop``
+     - ``drop``
+     - Traps packets dropped during processing of egress flow action drop
 
 Driver-specific Packet Traps
 ============================
@@ -277,6 +283,9 @@ narrow. The description of these groups must be added to the following table:
    * - ``tunnel_drops``
      - Contains packet traps for packets that were dropped by the device during
        tunnel encapsulation / decapsulation
+   * - ``acl_drops``
+     - Contains packet traps for packets that were dropped by the device during
+       ACL processing
 
 Testing
 =======
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 149c108be66f..07923e619206 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -596,6 +596,8 @@ enum devlink_trap_generic_id {
 	DEVLINK_TRAP_GENERIC_ID_NON_ROUTABLE,
 	DEVLINK_TRAP_GENERIC_ID_DECAP_ERROR,
 	DEVLINK_TRAP_GENERIC_ID_OVERLAY_SMAC_MC,
+	DEVLINK_TRAP_GENERIC_ID_INGRESS_FLOW_ACTION_DROP,
+	DEVLINK_TRAP_GENERIC_ID_EGRESS_FLOW_ACTION_DROP,
 
 	/* Add new generic trap IDs above */
 	__DEVLINK_TRAP_GENERIC_ID_MAX,
@@ -610,6 +612,7 @@ enum devlink_trap_group_generic_id {
 	DEVLINK_TRAP_GROUP_GENERIC_ID_L3_DROPS,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_BUFFER_DROPS,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_TUNNEL_DROPS,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_ACL_DROPS,
 
 	/* Add new generic trap group IDs above */
 	__DEVLINK_TRAP_GROUP_GENERIC_ID_MAX,
@@ -671,6 +674,10 @@ enum devlink_trap_group_generic_id {
 	"decap_error"
 #define DEVLINK_TRAP_GENERIC_NAME_OVERLAY_SMAC_MC \
 	"overlay_smac_is_mc"
+#define DEVLINK_TRAP_GENERIC_NAME_INGRESS_FLOW_ACTION_DROP \
+	"ingress_flow_action_drop"
+#define DEVLINK_TRAP_GENERIC_NAME_EGRESS_FLOW_ACTION_DROP \
+	"egress_flow_action_drop"
 
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_L2_DROPS \
 	"l2_drops"
@@ -680,6 +687,8 @@ enum devlink_trap_group_generic_id {
 	"buffer_drops"
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_TUNNEL_DROPS \
 	"tunnel_drops"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_ACL_DROPS \
+	"acl_drops"
 
 #define DEVLINK_TRAP_GENERIC(_type, _init_action, _id, _group, _metadata_cap) \
 	{								      \
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 216bdd25ce39..0d7c5d3443d2 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7795,6 +7795,8 @@ static const struct devlink_trap devlink_trap_generic[] = {
 	DEVLINK_TRAP(NON_ROUTABLE, DROP),
 	DEVLINK_TRAP(DECAP_ERROR, EXCEPTION),
 	DEVLINK_TRAP(OVERLAY_SMAC_MC, DROP),
+	DEVLINK_TRAP(INGRESS_FLOW_ACTION_DROP, DROP),
+	DEVLINK_TRAP(EGRESS_FLOW_ACTION_DROP, DROP),
 };
 
 #define DEVLINK_TRAP_GROUP(_id)						      \
@@ -7808,6 +7810,7 @@ static const struct devlink_trap_group devlink_trap_group_generic[] = {
 	DEVLINK_TRAP_GROUP(L3_DROPS),
 	DEVLINK_TRAP_GROUP(BUFFER_DROPS),
 	DEVLINK_TRAP_GROUP(TUNNEL_DROPS),
+	DEVLINK_TRAP_GROUP(ACL_DROPS),
 };
 
 static int devlink_trap_generic_verify(const struct devlink_trap *trap)
-- 
2.21.1

