Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2D331C36F
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 22:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhBOVKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 16:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhBOVKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 16:10:31 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A351BC061786
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 13:09:48 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id o3so7663167edv.4
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 13:09:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QSuD80NSsNz+6spIfwhwN3Sb9SzektjHrwizW2ziW/U=;
        b=mfbyZ/hKY1DbVV2lrs8x5KgDbHN7Wo/jT5j+ZMkCJA6qNWzLQwUi7OPoP932C4SN5Z
         L0MDfWx1BZu9sGNztPHWBRVJVCFl5NO+7n5UA7OR12se0n6/mTENhvwVhZ+0WBnLeqxu
         K7uoyajDG4vbPaLqsIeeb2HaDnQP39ViJW4aqKGAMYzpu5bqLZO/1l4TC3TQnPCqwmXM
         Snf+c/RVZTz2+JcAJBtGwsUgnLK4IsNL/c5emq+SGNTgMyu8UCzRLCqxWd7EJRX3Ovdi
         IIee9TFOhN4mHfdNpO9S6UOPS+PnssdPDZvjp9hMKoWV7TWpB6EgnbqfWNALJUS1WKsd
         +pVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QSuD80NSsNz+6spIfwhwN3Sb9SzektjHrwizW2ziW/U=;
        b=rWZbjKqcRe2Da+f8jd8x3Xmewj9MxP04V+65mZUiSgbnxd38ur8CbJ6Oq7Dk74oTFX
         kJGTkXQW/sMwAdABsyWrp/eWo6BcoYMUHt+yRBk0PMB23XxyFd4HSv9Luk1W4ROipcRQ
         gBD4cvGe+bv/DxSQ7x2wlW/tyYms5YWleCoeMun+GrHqX5LtUfEYqpLsLmV3TwUlutQ1
         ATxFIl5ACxVJW3gIyIx2jhLq4R/C/xUU0wmejx46d6ZHTC+a44jPrwETeZbGzTYfQUIE
         xaHaxj/z8MIKzoilwJHKA0UBlouxJtn4MJqek5qiCLWIWcqpz3Zy//d+0JQKYEs4zbNA
         UqLA==
X-Gm-Message-State: AOAM530EzXoxDjsgRrVUxX2JwOMKYhMcGwnWhWDl0QcT0saCgGsRZnSA
        jAyzVLPWM4hzEkjBpr/RpVA=
X-Google-Smtp-Source: ABdhPJzsXj3SMxtCQr7Be2kjOpqr+/YbmeJNAgbKqgDQ6nLODn3fKZCF3I7+jSJEZbmDWR1aI6A8sA==
X-Received: by 2002:a05:6402:4253:: with SMTP id g19mr17810951edb.343.1613423387365;
        Mon, 15 Feb 2021 13:09:47 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id n2sm4200418edr.8.2021.02.15.13.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 13:09:46 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 2/2] net: bridge: fix br_vlan_filter_toggle stub when CONFIG_BRIDGE_VLAN_FILTERING=n
Date:   Mon, 15 Feb 2021 23:09:12 +0200
Message-Id: <20210215210912.2633895-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210215210912.2633895-1-olteanv@gmail.com>
References: <20210215210912.2633895-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The prototype of br_vlan_filter_toggle was updated to include a netlink
extack, but the stub definition wasn't, which results in a build error
when CONFIG_BRIDGE_VLAN_FILTERING=n.

Fixes: 9e781401cbfc ("net: bridge: propagate extack through store_bridge_parm")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_private.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index da71e71fcddc..d7d167e10b70 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1265,7 +1265,8 @@ static inline u16 br_get_pvid(const struct net_bridge_vlan_group *vg)
 }
 
 static inline int br_vlan_filter_toggle(struct net_bridge *br,
-					unsigned long val)
+					unsigned long val,
+					struct netlink_ext_ack *extack)
 {
 	return -EOPNOTSUPP;
 }
-- 
2.25.1

