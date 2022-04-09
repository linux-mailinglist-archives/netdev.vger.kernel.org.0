Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B117C4FA6F8
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 13:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241480AbiDILHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 07:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236232AbiDILG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 07:06:59 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2681F23EC7A
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 04:04:52 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id dr20so21785800ejc.6
        for <netdev@vger.kernel.org>; Sat, 09 Apr 2022 04:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OJhM912bfhb7uMFugRwaEA6kDWsFt0tEfGy7vW0mS0I=;
        b=SIbGuIOlNQM2gXLI6wvPq/OiqaZuZlgUzTQ45QFtUYdm6NIIc3GSxL6kYcVzdawb6b
         YtW8i9z7gmBXEx64ydeD1JW3GTPA4jfmSs7UXYvcry4+LO+XfgoAZ2BAUkhM0BN7fDC3
         ZVTQ4/fosfRQ50fAeOZTNrrhPjvb74jIQ7eojyRiEQaDd2e2lr7ydHrYgHH7DOHESflO
         HIbFJgGZ35WPNj4QMOx+/QVLiwJryGWgzxyc3n8Xgfg/V4MSz/LE8o7IH8YKJgvSwDxO
         qtA4SE/Kn94ydc9pgbR4fj45t3HbfndToPy2YfOehBYZodIAiWm53alkq0FjLLV2UwIn
         vURw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OJhM912bfhb7uMFugRwaEA6kDWsFt0tEfGy7vW0mS0I=;
        b=djUsH2lK5jECSKzBNgqfqXX4kAwqynLZIl0GiNThI42BtZg6gU1tJouIbKlncxc0/J
         lG5p22EOIPyvSdfc1Ix011xt1Pt7TkTotXsjnZwhiPrYzD5QBb2Ryvc7Ds4PJqo7Sxzg
         txBAi6gcnptkSfLv76+0koRsRyYaVQgqRBYVB0E3wtIrJ9LZMNn3ODoS8YP/SVwPWMwv
         WLtf5kCVQohk1guHPkPvpCKPwcO2SGXBTEjhTQ92JGelRpE1uAaIkns1RNApRA3xMIxn
         T+C+ZhBfLF4gt1IKkWyUhlEWJRQ2joPjiq4K6O84u47YtAp39DK7Sin0MP/fyf14Yc6X
         6sdw==
X-Gm-Message-State: AOAM5320XuyTsjmXoT4Gqq2wnWzxoc+PC+5s6YgPwBCHfDxVTP3I8nbu
        r7udMCH7rXSKtE1OvL4QpJskdC6fTKpbHN+LwKk=
X-Google-Smtp-Source: ABdhPJwYEMDPohwDYUiufv/XqoQdYice2/kWKxabF4RdtB+3ZoftUjO0iq+5NsvsIs/XnS0PYmWXGQ==
X-Received: by 2002:a17:907:72cc:b0:6e0:2d3:bcba with SMTP id du12-20020a17090772cc00b006e002d3bcbamr22158460ejc.642.1649502290289;
        Sat, 09 Apr 2022 04:04:50 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id r11-20020a1709064d0b00b006e87938318dsm179574eju.39.2022.04.09.04.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 04:04:49 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next 1/6] net: bridge: add a generic flush operation
Date:   Sat,  9 Apr 2022 13:58:52 +0300
Message-Id: <20220409105857.803667-2-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220409105857.803667-1-razor@blackwall.org>
References: <20220409105857.803667-1-razor@blackwall.org>
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

Add a new bridge attribute (IFLA_BRIDGE_FLUSH) which will have embedded
attributes describing the object types that will be flushed. It will
allow fine-grained object flushing. Only a single flush attribute is
allowed per call since it can be a very load heavy operation. Also it is
allowed only with setlink command (similar to changelink flush). A nice
side-effect of using an af spec attribute is that it avoids making the
bridge link attribute options list longer.

An example structure for fdbs:
 [ IFLA_BRIDGE_FLUSH ]
  `[ BRIDGE_FDB_FLUSH ]
    `[ FDB_FLUSH_NDM_STATE ]
    `[ FDB_FLUSH_NDM_FLAGS ]

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 include/uapi/linux/if_bridge.h |  8 +++++++
 net/bridge/br_netlink.c        | 42 +++++++++++++++++++++++++++++++++-
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index a86a7e7b811f..221a4256808f 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -123,6 +123,7 @@ enum {
 	IFLA_BRIDGE_MRP,
 	IFLA_BRIDGE_CFM,
 	IFLA_BRIDGE_MST,
+	IFLA_BRIDGE_FLUSH,
 	__IFLA_BRIDGE_MAX,
 };
 #define IFLA_BRIDGE_MAX (__IFLA_BRIDGE_MAX - 1)
@@ -802,4 +803,11 @@ enum {
 	__BRIDGE_QUERIER_MAX
 };
 #define BRIDGE_QUERIER_MAX (__BRIDGE_QUERIER_MAX - 1)
+
+/* embedded in IFLA_BRIDGE_FLUSH */
+enum {
+	BRIDGE_FLUSH_UNSPEC,
+	__BRIDGE_FLUSH_MAX
+};
+#define BRIDGE_FLUSH_MAX (__BRIDGE_FLUSH_MAX - 1)
 #endif /* _UAPI_LINUX_IF_BRIDGE_H */
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 200ad05b296f..fe2211d4c0c7 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -779,6 +779,34 @@ int br_process_vlan_info(struct net_bridge *br,
 	return err;
 }
 
+static const struct nla_policy br_flush_policy[BRIDGE_FLUSH_MAX + 1] = {
+	[BRIDGE_FLUSH_UNSPEC]	= { .type = NLA_REJECT },
+};
+
+static int br_flush(struct net_bridge *br, int cmd,
+		    struct nlattr *flush_attr,
+		    struct netlink_ext_ack *extack)
+{
+	struct nlattr *flush_tb[BRIDGE_FLUSH_MAX + 1];
+	int err;
+
+	switch (cmd) {
+	case RTM_SETLINK:
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Bridge flush attribute is allowed only with RTM_SETLINK");
+		return -EINVAL;
+	}
+
+	err = nla_parse_nested(flush_tb, BRIDGE_FLUSH_MAX, flush_attr,
+			       br_flush_policy, extack);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static int br_afspec(struct net_bridge *br,
 		     struct net_bridge_port *p,
 		     struct nlattr *af_spec,
@@ -787,9 +815,10 @@ static int br_afspec(struct net_bridge *br,
 {
 	struct bridge_vlan_info *vinfo_curr = NULL;
 	struct bridge_vlan_info *vinfo_last = NULL;
-	struct nlattr *attr;
 	struct vtunnel_info tinfo_last = {};
 	struct vtunnel_info tinfo_curr = {};
+	bool flushed = false;
+	struct nlattr *attr;
 	int err = 0, rem;
 
 	nla_for_each_nested(attr, af_spec, rem) {
@@ -845,6 +874,17 @@ static int br_afspec(struct net_bridge *br,
 			if (err)
 				return err;
 			break;
+		case IFLA_BRIDGE_FLUSH:
+			if (flushed) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Multiple bridge flush attributes are not allowed");
+				return -EINVAL;
+			}
+			err = br_flush(br, cmd, attr, extack);
+			if (err)
+				return err;
+			flushed = true;
+			break;
 		}
 	}
 
-- 
2.35.1

