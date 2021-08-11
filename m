Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72923E9314
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 15:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhHKNxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 09:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbhHKNxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 09:53:41 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F827C061765;
        Wed, 11 Aug 2021 06:53:17 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id g12-20020a17090a7d0cb0290178f80de3d8so4881525pjl.2;
        Wed, 11 Aug 2021 06:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=McZHw6sQ4TwpaGC2g78JrbLUmpP0WSdIbTjyHIQHZDg=;
        b=IX2JCs+zddAvzfStvaEUhhbbYHBSt9n8HTPWZ3/t5mQ1TU3rlXnmZzyeO6NqlMVniN
         IlsOhAoy5rjlKPxKf1nDNMSRzYcCkuQXGZTaPjS9X5Df3HKv6AOb/Dq9kkRV3YhHBAYS
         Txyz8cSrY0O8FSCRMbuPV3ONHUxjWZ+MI4St8yeA8CTSDSp6AQMrrTzfAsv6k/lxX5sS
         fmR1h6LqYPgX5fuQkMpUhjvAn4EohaQqLlQD9CQpjAocSj2pjYcmzP6UOEEo+7sku4P/
         osqfp7ya4/LoEf85EZaokcXQe97Pt/WHoh49edxjQXSJgHHsPHB02IUz8atH/NyRNWjc
         7OwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=McZHw6sQ4TwpaGC2g78JrbLUmpP0WSdIbTjyHIQHZDg=;
        b=F651fGZ2RFLB9Ga1vNtAdnaivTjN8LI8xwhUZTOu0IiQpTNIsvW3xHlQ22aN9cGBRn
         yJmIhdPEZGe+G6op0UiFuHGUXSvVwVtZ0pOXStF12kinbVS2JS9D1CLhltzxql+XNKKP
         eEXzXO4m2cZLFRoKkiEfpvOVAlBL624IPYQAi+yiqTP8WKargix0oofqnVrAx94/opCZ
         mCIMS+z/IazG1CcluVKTJ6b4pmNx6iQpr3tamK7QCTwYy1y8fN0tKXJ/Rgt73gFucvm9
         7sF5iExCT1cH+V0mzIFqIRDJN75/LKjwoqv+yjKrnfF8mSYjOJmAw7zkgtLuVsTURQzb
         DGNQ==
X-Gm-Message-State: AOAM5320A4OHX3l5SX8Czd2hKMe8GKAdkiSezacaSaA70GgohonviuG8
        Mew3GCvWhflLjw1QvNCmn7E=
X-Google-Smtp-Source: ABdhPJzDjdhmDa4jqU41NbSggXWKEN6nzrnTBrFBOeBh4RXx2T7JYe/stuAzSJfp2geRSP5kQCJh/g==
X-Received: by 2002:a17:90a:dac4:: with SMTP id g4mr36766901pjx.233.1628689997001;
        Wed, 11 Aug 2021 06:53:17 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id c136sm27603597pfc.53.2021.08.11.06.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 06:53:16 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org (moderated list:ETHERNET BRIDGE),
        netdev@vger.kernel.org (open list:ETHERNET BRIDGE),
        linux-kernel@vger.kernel.org (open list)
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next] net: bridge: switchdev: allow port isolation to be offloaded
Date:   Wed, 11 Aug 2021 21:52:46 +0800
Message-Id: <20210811135247.1703496-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add BR_ISOLATED flag to BR_PORT_FLAGS_HW_OFFLOAD, to allow switchdev
drivers to offload port isolation.

Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 net/bridge/br_switchdev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 6bf518d78f02..898257153883 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -71,7 +71,8 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 
 /* Flags that can be offloaded to hardware */
 #define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | \
-				  BR_MCAST_FLOOD | BR_BCAST_FLOOD)
+				  BR_MCAST_FLOOD | BR_BCAST_FLOOD | \
+				  BR_ISOLATED)
 
 int br_switchdev_set_port_flag(struct net_bridge_port *p,
 			       unsigned long flags,
-- 
2.25.1

