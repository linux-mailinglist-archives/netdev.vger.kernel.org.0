Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF654FE29A
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356208AbiDLN3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356775AbiDLN2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:28:10 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA75DD4F
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:23:18 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id t25so9663503edt.9
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=egLzN7/s9/QZ3qlg41Rj8BKSB1yfeA3ZGBvqcFvmni0=;
        b=XoRKm7gWr72tnpuMrPmdTcwkzSX48VLbwDbDflfb7NstKPnbU6B7PsuSPmIzYL50Uk
         p49Py1tQHUeOPMQE3filRxSm8yXFyQQdgeV0fwXFHuOghxb8NcpWKEZkvGaJgbcfrMtc
         gJZNiktJqYfNN7vMv67fU4LviUN54RuWPGdEAgcu2hr5SRx4Az+nVJVRXpTWMV/BMkkk
         aQ7oUhkBufIfJvH+UfMstsyY5AbzhtLje+zSDBLC6lhzXTFLYkn4/dmDPto6zNDM/hJ0
         ego4SqcnkzljllnqpdOqFuF9hb7QhxqTXILj98Oja19NBcuEZxNPlS4JOrL1zPugbxe+
         E3pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=egLzN7/s9/QZ3qlg41Rj8BKSB1yfeA3ZGBvqcFvmni0=;
        b=FssisyRVosFNWVCSNXwddvhxA7JNgNT69H7PJGsdN6IygHCm1LV3IMOQ3UmNfcD52K
         6TBELF+DghEJvTHHCYMyYAhwGwng9oHlaESfjEaXB5yKT5oB5xxgPQ05a+Uu6qrsQ4t4
         J+JdvLuLN8x3EbeN+lcgY2ixalCUKHOSo0vvtcUxzUTHljC0P9eXCG+k+Zp0aA5NzSVV
         NcsEhrfE9XpXMwEeJ1HGr8Bc+6HWtNB220af2EmhuHIpcCUzGPcYxISgfGIYZ8jZc6+G
         mFVClFYcaS0GQckFuv/TK18z+P7+1xZpaGUwquJWb7AUIcrVeHD/HUl1obT8eyazk4h7
         u/sA==
X-Gm-Message-State: AOAM5305LLuRDQ/r4o4ndjborYwWunlRPryrKqVaitnGh14q09sftrML
        8KSzv/Yl6o+2a7SLllrQ2nQoDedoeJ2Dk+bz
X-Google-Smtp-Source: ABdhPJys3pdSysfXP0n7n9kFByanJwNxCn2koANT+ueJboT7ny9u4vCxrCXaaoo6Lj13xRaGq0X+hA==
X-Received: by 2002:a05:6402:331c:b0:41d:9354:97c2 with SMTP id e28-20020a056402331c00b0041d935497c2mr3237826eda.300.1649769797232;
        Tue, 12 Apr 2022 06:23:17 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id z16-20020a17090665d000b006e8789e8cedsm3771301ejn.204.2022.04.12.06.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 06:23:16 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v3 8/8] net: bridge: fdb: add support for flush filtering based on ifindex and vlan
Date:   Tue, 12 Apr 2022 16:22:45 +0300
Message-Id: <20220412132245.2148794-9-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412132245.2148794-1-razor@blackwall.org>
References: <20220412132245.2148794-1-razor@blackwall.org>
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

Add support for fdb flush filtering based on destination ifindex and
vlan id. The ifindex must either match a port's device ifindex or the
bridge's. The vlan support is trivial since it's already validated by
rtnl_fdb_flush, we just need to fill it in.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
v2: validate ifindex and fill in vlan id
v3: NDFA -> NDA attributes

 net/bridge/br_fdb.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index bbb00a75ef0a..c44ea83ac3d9 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -622,12 +622,44 @@ static unsigned long __ndm_flags_to_fdb_flags(u8 ndm_flags)
 	return flags;
 }
 
+static int __fdb_flush_validate_ifindex(const struct net_bridge *br,
+					int ifindex,
+					struct netlink_ext_ack *extack)
+{
+	const struct net_device *dev;
+
+	dev = __dev_get_by_index(dev_net(br->dev), ifindex);
+	if (!dev) {
+		NL_SET_ERR_MSG_MOD(extack, "Unknown flush device ifindex");
+		return -ENODEV;
+	}
+	if (!netif_is_bridge_master(dev) && !netif_is_bridge_port(dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Flush device is not a bridge or bridge port");
+		return -EINVAL;
+	}
+	if (netif_is_bridge_master(dev) && dev != br->dev) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Flush bridge device does not match target bridge device");
+		return -EINVAL;
+	}
+	if (netif_is_bridge_port(dev)) {
+		struct net_bridge_port *p = br_port_get_rtnl(dev);
+
+		if (p->br != br) {
+			NL_SET_ERR_MSG_MOD(extack, "Port belongs to a different bridge device");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 int br_fdb_delete_bulk(struct ndmsg *ndm, struct nlattr *tb[],
 		       struct net_device *dev, u16 vid,
 		       struct netlink_ext_ack *extack)
 {
 	u8 ndm_flags = ndm->ndm_flags & ~FDB_FLUSH_IGNORED_NDM_FLAGS;
-	struct net_bridge_fdb_flush_desc desc = {};
+	struct net_bridge_fdb_flush_desc desc = { .vlan_id = vid };
 	struct net_bridge *br;
 
 	if (netif_is_bridge_master(dev)) {
@@ -663,6 +695,14 @@ int br_fdb_delete_bulk(struct ndmsg *ndm, struct nlattr *tb[],
 
 		desc.flags_mask |= __ndm_flags_to_fdb_flags(ndm_flags_mask);
 	}
+	if (tb[NDA_IFINDEX]) {
+		int err, ifidx = nla_get_s32(tb[NDA_IFINDEX]);
+
+		err = __fdb_flush_validate_ifindex(br, ifidx, extack);
+		if (err)
+			return err;
+		desc.port_ifindex = ifidx;
+	}
 
 	br_debug(br, "flushing port ifindex: %d vlan id: %u flags: 0x%lx flags mask: 0x%lx\n",
 		 desc.port_ifindex, desc.vlan_id, desc.flags, desc.flags_mask);
-- 
2.35.1

