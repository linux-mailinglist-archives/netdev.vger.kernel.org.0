Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A7167E21D
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 11:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbjA0KqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 05:46:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232419AbjA0Kp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 05:45:59 -0500
Received: from mail.simonwunderlich.de (mail.simonwunderlich.de [IPv6:2a01:4f8:c17:e8c0::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD8F227A5
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 02:45:49 -0800 (PST)
Received: from kero.packetmixer.de (p200300C5973eAed8832E80845Eb11f67.dip0.t-ipconnect.de [IPv6:2003:c5:973e:aed8:832e:8084:5eb1:1f67])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.simonwunderlich.de (Postfix) with ESMTPSA id 47F4BFAFDB;
        Fri, 27 Jan 2023 11:21:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=simonwunderlich.de;
        s=09092022; t=1674814896; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZvLElpC1+VVIp39vMIrU5LoBRiGr9pejs0Xce5d2JTM=;
        b=KSmKO++kKswmJO78DSO8+r8aVxek2gnRKgl/iR0kjWK5y8um1b5rJhTw1y99rQtE4H0Z5r
        F2k7H+ssOHPXeI7oqiBgq77oibi+Xjrp+oc/CyVN2hiA9wGm13f5V1KZSdEjAOqZ4rMs7/
        rktMHyBstl4gvS5G6sKpVXp6tdmBULea7T6HAD0Jy2DyHvHza0oxIX9l2Naw6dlAsK9d3i
        lYiczDZjdI6JPkV9scRPLMaNudAqYs6s7bxd4GRQb4OUAk5z6iIxweFyOX6Ixw+zsnjG8a
        GR/aMveYWp6cBJzYCOllP+A5o2DdoaEXOPAqSa9bf9MLe5GF4uQz34WHzPFaPg==
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 1/5] batman-adv: Start new development cycle
Date:   Fri, 27 Jan 2023 11:21:29 +0100
Message-Id: <20230127102133.700173-2-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230127102133.700173-1-sw@simonwunderlich.de>
References: <20230127102133.700173-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=simonwunderlich.de; s=09092022; t=1674814896;
        h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZvLElpC1+VVIp39vMIrU5LoBRiGr9pejs0Xce5d2JTM=;
        b=c9Dz2OLpNFukMVRawYs0TLlrEBCYdxuK0xrfkMazVNQFu3Roaplj/QZ6HKuRpGY27C/ZhX
        u3VGJPh2DrJQRegsWai9yIacuauLPj36Wg7p1ClCipasVrDfACKRKgHxfbhrbv93erkEDg
        Yvuotj0AKwPE/+WR/DQVDn/5Crv7CZhxMDTfYXiZkxE+3InWJLk+i2WakKeovFR5jMpMg4
        Cv2onBPUHCOmUZnAjB32T56Zbi0Xe5XlYmolWy0OyvDb4PYiXIaWndShnKjK29RG9MAfDz
        o18LNdlJEdo1Aoh8LCOBimV7zW8F5InmLSqLzmiVOQ0fJL6jIe/eQdpWyHeycg==
ARC-Seal: i=1; s=09092022; d=simonwunderlich.de; t=1674814896; a=rsa-sha256;
        cv=none;
        b=wUr3t+U0wzKru1ENhK+ueeEPwZyPCiAN3lbRHzYx+3Q0bEDoAimUPsInHOjmbXQqT61RNnnfiH1PRlPNxnuEioMGqugCVPfcdVv0qOU9tHxbDF7FomK8Aq8XaTvXy72uNl2MXp4GsECJ4olWKGBgcn/XmPwAbbhpjL8euODpJcYC577TfUrGFeRHw8O1Oy4AlzQ1MSz2gx4cRDw1sqTAps5sbj1fhfxXKvks4Mxhc0brPGF9jiC2NTz0mcpXqScOWtdpoSF2iyHCWXL6zshsDbWYhntqZ2ogo2CzszZFg3tZoEq/yPD0SjYy5Q6RwMxdGpxATccPVmK+/FwF5mmrrw==
ARC-Authentication-Results: i=1;
        mail.simonwunderlich.de;
        auth=pass smtp.auth=sw@simonwunderlich.de smtp.mailfrom=sw@simonwunderlich.de
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This version will contain all the (major or even only minor) changes for
Linux 6.3.

The version number isn't a semantic version number with major and minor
information. It is just encoding the year of the expected publishing as
Linux -rc1 and the number of published versions this year (starting at 0).

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/main.h b/net/batman-adv/main.h
index c48803b32bb0..156ed39eded1 100644
--- a/net/batman-adv/main.h
+++ b/net/batman-adv/main.h
@@ -13,7 +13,7 @@
 #define BATADV_DRIVER_DEVICE "batman-adv"
 
 #ifndef BATADV_SOURCE_VERSION
-#define BATADV_SOURCE_VERSION "2022.3"
+#define BATADV_SOURCE_VERSION "2023.1"
 #endif
 
 /* B.A.T.M.A.N. parameters */
-- 
2.30.2

