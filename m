Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31FF9640160
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 08:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbiLBHzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 02:55:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbiLBHzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 02:55:32 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C150B11160
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 23:54:09 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id g10so3930820plo.11
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 23:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=T3cYex14B/6JfvtOa/yIdk+IwQ8V7a8iWYWm32l+saE=;
        b=DUQrmooET4etthDgmnRS+9rrGnehhcvQ6jE9KV2zDMCRYXW3entfPT+FvmSBgdWGWj
         MszeKZGs+5R0fMPUltpa4Hs/NRF8T379Kh3fndmgSdJQ4G4z2Zf/z89/ETea+srtibRg
         lzn1o9IhU0HNP9L6OCQg2qo7uRiREaRpg4NbdL5NixZo0hDtigmyYHndaEOwp/aaIZog
         o1fem3zCMiQplL+VL4zSlNCV5BuF337rcf9nE0qDdfm60nrv5ajVl80L0bOG4vRUIuSh
         h9E8yU2XS7S7C2NFQtV5t/XeI2032QdoMMVS4hy5H6hzT0l4intumUZRxNOqqzZKb0uH
         m8HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T3cYex14B/6JfvtOa/yIdk+IwQ8V7a8iWYWm32l+saE=;
        b=bFiXZ0QJKfc0UmwP6AtxlzjbJ5qRhKQsrxuy7ENbzjv07U0Mm3dG2jc9E/BHGCxXW5
         A4klQKCn5cffzECDY03PkUM13TRLnx9Z4US2LGHakMvg+60z4pUCYmD/VNK1L2SvK6j8
         NiJ2KypiHkTjcFAp6LafvYEn5Ev0V4fi9nYbGh+6mpLBDxFVUHAlJ6jly7rFvgPKK14q
         H3azfSZPXZ/POlLDW5LI/1cZxtnf8HZ+dPuHUeN7sxrukZzkeUq4Cgo4krIe1WYN60PA
         xDWuG0Sy14FbahBMTu38oVNRpG+SctazkhKO6s9cuOYM3izBQZNUoz43TQUU4Od6PzXd
         aBdQ==
X-Gm-Message-State: ANoB5plewAz3yd+2Wmt8mQ+atHnAmXoL7DcYRLjLlnXpxoH1RlAkfk+k
        BpFs8ZoOrLWQBMIxwRzvvo7XJ98+oPbdDw==
X-Google-Smtp-Source: AA0mqf46BImtc2kguruGdrjMW5ClYxD8nIer0vA81MZNv2eNPMawRHOzaLLBiz73Flo4YEl5Lj/zvA==
X-Received: by 2002:a17:90a:73c2:b0:200:a7b4:6511 with SMTP id n2-20020a17090a73c200b00200a7b46511mr72357937pjk.101.1669967647887;
        Thu, 01 Dec 2022 23:54:07 -0800 (PST)
Received: from localhost.localdomain ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id b4-20020a170903228400b00188fc6766d6sm4932268plh.219.2022.12.01.23.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 23:54:07 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        William Tu <u9012063@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jianlin Shi <jishi@redhat.com>
Subject: [PATCH net] ip_gre: do not report erspan version on GRE interface
Date:   Fri,  2 Dec 2022 15:53:37 +0800
Message-Id: <20221202075337.2890001-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although the type I ERSPAN is based on the barebones IP + GRE
encapsulation and no extra ERSPAN header. Report erspan version on GRE
interface looks unreasonable. Fix this by separating the erspan and gre
fill info.

IPv6 GRE does not have this info as IPv6 only supports erspan version
1 and 2.

Reported-by: Jianlin Shi <jishi@redhat.com>
Fixes: f989d546a2d5 ("erspan: Add type I version 0 support.")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv4/ip_gre.c | 50 +++++++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index f866d6282b2b..3bb9146e70fd 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1492,24 +1492,6 @@ static int ipgre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	struct ip_tunnel_parm *p = &t->parms;
 	__be16 o_flags = p->o_flags;
 
-	if (t->erspan_ver <= 2) {
-		if (t->erspan_ver != 0 && !t->collect_md)
-			o_flags |= TUNNEL_KEY;
-
-		if (nla_put_u8(skb, IFLA_GRE_ERSPAN_VER, t->erspan_ver))
-			goto nla_put_failure;
-
-		if (t->erspan_ver == 1) {
-			if (nla_put_u32(skb, IFLA_GRE_ERSPAN_INDEX, t->index))
-				goto nla_put_failure;
-		} else if (t->erspan_ver == 2) {
-			if (nla_put_u8(skb, IFLA_GRE_ERSPAN_DIR, t->dir))
-				goto nla_put_failure;
-			if (nla_put_u16(skb, IFLA_GRE_ERSPAN_HWID, t->hwid))
-				goto nla_put_failure;
-		}
-	}
-
 	if (nla_put_u32(skb, IFLA_GRE_LINK, p->link) ||
 	    nla_put_be16(skb, IFLA_GRE_IFLAGS,
 			 gre_tnl_flags_to_gre_flags(p->i_flags)) ||
@@ -1550,6 +1532,36 @@ static int ipgre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	return -EMSGSIZE;
 }
 
+static int erspan_fill_info(struct sk_buff *skb, const struct net_device *dev)
+{
+	struct ip_tunnel *t = netdev_priv(dev);
+	struct ip_tunnel_parm *p = &t->parms;
+	__be16 o_flags = p->o_flags;
+
+	if (t->erspan_ver <= 2) {
+		if (t->erspan_ver != 0 && !t->collect_md)
+			o_flags |= TUNNEL_KEY;
+
+		if (nla_put_u8(skb, IFLA_GRE_ERSPAN_VER, t->erspan_ver))
+			goto nla_put_failure;
+
+		if (t->erspan_ver == 1) {
+			if (nla_put_u32(skb, IFLA_GRE_ERSPAN_INDEX, t->index))
+				goto nla_put_failure;
+		} else if (t->erspan_ver == 2) {
+			if (nla_put_u8(skb, IFLA_GRE_ERSPAN_DIR, t->dir))
+				goto nla_put_failure;
+			if (nla_put_u16(skb, IFLA_GRE_ERSPAN_HWID, t->hwid))
+				goto nla_put_failure;
+		}
+	}
+
+	return ipgre_fill_info(skb, dev);
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
 static void erspan_setup(struct net_device *dev)
 {
 	struct ip_tunnel *t = netdev_priv(dev);
@@ -1628,7 +1640,7 @@ static struct rtnl_link_ops erspan_link_ops __read_mostly = {
 	.changelink	= erspan_changelink,
 	.dellink	= ip_tunnel_dellink,
 	.get_size	= ipgre_get_size,
-	.fill_info	= ipgre_fill_info,
+	.fill_info	= erspan_fill_info,
 	.get_link_net	= ip_tunnel_get_link_net,
 };
 
-- 
2.38.1

