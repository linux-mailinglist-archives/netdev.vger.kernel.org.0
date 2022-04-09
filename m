Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335504FA6FB
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 13:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241495AbiDILHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 07:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241476AbiDILHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 07:07:10 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B3123F3FF
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 04:04:53 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id l7so16450701ejn.2
        for <netdev@vger.kernel.org>; Sat, 09 Apr 2022 04:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ByfL8z/R6BuRgwZqTxWQ31zr/BQkKOOXCLKFqhleuTY=;
        b=ilhuW9/NCRq4MTKKfWSDcWFxlWcnsF2ZZozvoMJG02Aiw6o1FZiMM93nJSKtnNfLWI
         OPN7XWVHpxnl+tP18PkJud6MfyjAWUorgmDYQdfVl3dbUTvMK0fIqxcInmuOFSQFmq6l
         ypvTJJ1pGUzjZJaaBaB3X+FDpSB3ALFjZzuALMG9ZKj4OFleKGGrtWhL5CIvdJZQyp8j
         +pg1P7f5FQAxjdPVVbyPotaNcXjxy1ieOy/Bq5U1b0xpt32co5tOSnijoKHmL1gODEjq
         hJmrlLC8K21YWB5fRAiYJbPb/wEWDPafq8z0g1N9MBDvt4jzGzwPQvg/A9QN8L3wNSx7
         FZMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ByfL8z/R6BuRgwZqTxWQ31zr/BQkKOOXCLKFqhleuTY=;
        b=5Y1BtP57j31n1Ff2cgdGdCFafETdSAeVy+8DvRM4CpW5BGao2jXf7Ga55EClk7zCtI
         UjH+WtROYUKHSeIZHgKDXE/p1aa76Km1Tp5sWTttePV+AkaezdmyJ4lv1p0997qOPyhv
         CgZJznAUeNdTZjw7JdjcFdpF6rzALTLPONzvfHNTaU3wgm7q1WdLOn41oQTE4K0vOgwM
         JIF61YBx6poqaFMQDmV6uqwScd3dNz1rdtW0vuuId94RvoQeM2mLw4AKyhOq4dHaePu5
         tSjZjkf1JHBpUKJVjXcFog0Z5e7a6Z1DvH0rqZyYl+NmBfa3F4LWuU82/XBGiTNoajR7
         du8w==
X-Gm-Message-State: AOAM5326LGKP/0jrSGo89IdbZiW56TUKj405kuhy2Nhr9yKb0PfaSpwr
        LQ6FmY3FLLqyV1maksujsw5GgFx9OPqkT2nNHE0=
X-Google-Smtp-Source: ABdhPJxtyzsUMBx+lnq/Dwpwi4sb6B14tB2bpLSu2+2TcHoBKiJLynE/mrdnudx7dnKRecCCrqd6bg==
X-Received: by 2002:a17:906:d10c:b0:6cd:4aa2:cd62 with SMTP id b12-20020a170906d10c00b006cd4aa2cd62mr22117209ejz.229.1649502292179;
        Sat, 09 Apr 2022 04:04:52 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id r11-20020a1709064d0b00b006e87938318dsm179574eju.39.2022.04.09.04.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 04:04:51 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next 3/6] net: bridge: fdb: add new nl attribute-based flush call
Date:   Sat,  9 Apr 2022 13:58:54 +0300
Message-Id: <20220409105857.803667-4-razor@blackwall.org>
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

Add a new fdb flush call which parses the embedded attributes in
BRIDGE_FLUSH_FDB and fills in the fdb flush descriptor to delete only
matching entries. Currently it's a complete flush, support for more
fine-grained filtering will be added in the following patches.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 include/uapi/linux/if_bridge.h |  8 ++++++++
 net/bridge/br_fdb.c            | 24 ++++++++++++++++++++++++
 net/bridge/br_netlink.c        |  8 ++++++++
 net/bridge/br_private.h        |  2 ++
 4 files changed, 42 insertions(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 221a4256808f..2f3799cf14b2 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -807,7 +807,15 @@ enum {
 /* embedded in IFLA_BRIDGE_FLUSH */
 enum {
 	BRIDGE_FLUSH_UNSPEC,
+	BRIDGE_FLUSH_FDB,
 	__BRIDGE_FLUSH_MAX
 };
 #define BRIDGE_FLUSH_MAX (__BRIDGE_FLUSH_MAX - 1)
+
+/* embedded in BRIDGE_FLUSH_FDB */
+enum {
+	FDB_FLUSH_UNSPEC,
+	__FDB_FLUSH_MAX
+};
+#define FDB_FLUSH_MAX (__FDB_FLUSH_MAX - 1)
 #endif /* _UAPI_LINUX_IF_BRIDGE_H */
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 4b0bf88c4121..62f694a739e1 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -594,6 +594,30 @@ void br_fdb_flush(struct net_bridge *br,
 	rcu_read_unlock();
 }
 
+static const struct nla_policy br_fdb_flush_policy[FDB_FLUSH_MAX + 1] = {
+	[FDB_FLUSH_UNSPEC]	= { .type = NLA_REJECT },
+};
+
+int br_fdb_flush_nlattr(struct net_bridge *br, struct nlattr *fdb_flush_attr,
+			struct netlink_ext_ack *extack)
+{
+	struct nlattr *fdb_flush_tb[FDB_FLUSH_MAX + 1];
+	struct net_bridge_fdb_flush_desc desc = {};
+	int err;
+
+	err = nla_parse_nested(fdb_flush_tb, FDB_FLUSH_MAX, fdb_flush_attr,
+			       br_fdb_flush_policy, extack);
+	if (err)
+		return err;
+
+	br_debug(br, "flushing port ifindex: %d vlan id: %u flags: 0x%lx flags mask: 0x%lx\n",
+		 desc.port_ifindex, desc.vlan_id, desc.flags, desc.flags_mask);
+
+	br_fdb_flush(br, &desc);
+
+	return 0;
+}
+
 /* Flush all entries referring to a specific port.
  * if do_all is set also flush static entries
  * if vid is set delete all entries that match the vlan_id
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 6e6dce6880c9..bd2c91e5723d 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -781,6 +781,7 @@ int br_process_vlan_info(struct net_bridge *br,
 
 static const struct nla_policy br_flush_policy[BRIDGE_FLUSH_MAX + 1] = {
 	[BRIDGE_FLUSH_UNSPEC]	= { .type = NLA_REJECT },
+	[BRIDGE_FLUSH_FDB]	= { .type = NLA_NESTED },
 };
 
 static int br_flush(struct net_bridge *br, int cmd,
@@ -804,6 +805,13 @@ static int br_flush(struct net_bridge *br, int cmd,
 	if (err)
 		return err;
 
+	if (flush_tb[BRIDGE_FLUSH_FDB]) {
+		err = br_fdb_flush_nlattr(br, flush_tb[BRIDGE_FLUSH_FDB],
+					  extack);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index e6930e9ee69d..c7ea531d30ef 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -768,6 +768,8 @@ int br_fdb_hash_init(struct net_bridge *br);
 void br_fdb_hash_fini(struct net_bridge *br);
 void br_fdb_flush(struct net_bridge *br,
 		  const struct net_bridge_fdb_flush_desc *desc);
+int br_fdb_flush_nlattr(struct net_bridge *br, struct nlattr *fdb_flush_attr,
+			struct netlink_ext_ack *extack);
 void br_fdb_find_delete_local(struct net_bridge *br,
 			      const struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid);
-- 
2.35.1

