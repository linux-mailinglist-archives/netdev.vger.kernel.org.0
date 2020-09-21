Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC6927218D
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 12:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgIUK4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 06:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgIUK4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 06:56:15 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DE1C0613D0
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:15 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id e17so11667498wme.0
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v0VyLBidFMgxaEIbE0qIA152wkMYPe0lHT8kdjtZmtI=;
        b=OSP2THmw1TyZKAGS7yzefO2pKInkY7BvVFxJAj31KwbSw5vuyIHod9PG0W22OsIBBw
         EYaik+sFpNryraAU1anxdSztI+DnuMf7S6ED0uwC84M+Yl1Z+UxA++acN1YBzn/fF9fF
         EQyWODKHqRr9INwFmC3i8ZVtXEMTOTNcjFq3Y1zVOP9yr/ImLjcaxeSy2zXnwu+Ziq09
         QV5C1mRga7XoicYsM5GxQP1dqGwYZrR22RyayOfO7tiLbghz/959wnFw2CY16ypUoZUu
         Me1ZZ9m3Q8No4ivqFaDchAGNV2YAtdZlyN7LZNonGt65yVcAgAhcaLvTRoJC80RHduYu
         4xVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v0VyLBidFMgxaEIbE0qIA152wkMYPe0lHT8kdjtZmtI=;
        b=Vm+aWh9dExO7hlXO4PtTyDmuxqiopHoIXpMk+t92olgg+sl0E+niM5AK0BJq7OPXXG
         SiI+guMuYAJ2pK1bdMqczg9ZNCIEeKKkhBCPq0rJMbVvV14aV1PPTMyk5CoDnYMcxeAh
         78lrloq0vMJwF6d42xKy+6DD2fOesmzqzoD61JX8y7ZPb/K/gUBncdVU9skmDSy9FMXe
         tA6FghK4i2EfE5TlBKG7sqLDaI+yHRtwtTii8hWTzrh44rpjLRZ32pU/2CeSzKCzvUDa
         /iMDEJw26lsxUX0j6Gm4bhwTlAUDZxxCfAS7Td+Wo7dJ0Ce64J6SDDhe9X17yAo6MBHb
         9AEA==
X-Gm-Message-State: AOAM530/xLhrknu+jLHVquCO2rIuKDfY+356E4lvAoyelB6xTCOeP996
        SX4DUSwyXUhrFxjllw26be63lmPUl9Eyo/TTKJk=
X-Google-Smtp-Source: ABdhPJxjNqsH7wNsPPCKctRN8DIm5R6bxvVT4oEAPLuO8Ppr80ft8S2WvfrCAa8gT4yJn7ifnPe+oQ==
X-Received: by 2002:a1c:b7d7:: with SMTP id h206mr8646509wmf.159.1600685773616;
        Mon, 21 Sep 2020 03:56:13 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s11sm19637727wrt.43.2020.09.21.03.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 03:56:13 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 04/16] net: bridge: add src field to br_ip
Date:   Mon, 21 Sep 2020 13:55:14 +0300
Message-Id: <20200921105526.1056983-5-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200921105526.1056983-1-razor@blackwall.org>
References: <20200921105526.1056983-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add a new src field to struct br_ip which will be used to lookup S, G
entries. When SSM option is added we will enable full br_ip lookups.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/linux/if_bridge.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 6479a38e52fa..4fb9c4954f3a 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -18,6 +18,12 @@ struct br_ip {
 		__be32	ip4;
 #if IS_ENABLED(CONFIG_IPV6)
 		struct in6_addr ip6;
+#endif
+	} src;
+	union {
+		__be32	ip4;
+#if IS_ENABLED(CONFIG_IPV6)
+		struct in6_addr ip6;
 #endif
 	} u;
 	__be16		proto;
-- 
2.25.4

