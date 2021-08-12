Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E6D3EA677
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 16:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237980AbhHLOWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 10:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233282AbhHLOWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 10:22:48 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CD4C061756;
        Thu, 12 Aug 2021 07:22:23 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id q2so7449670plr.11;
        Thu, 12 Aug 2021 07:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Th9WKl0IW7GpxbqwwqPmaZkhN6z6TMP9nRsqCNvkXyc=;
        b=B1kZBxgA7H8EfDvYb+YKpfkgRv4EqGRi2cH1Te2uNIimCZT5XlojbYszrNoi9qIQLx
         48uzO637fAGckSKocGF6qT99SFw0+S9cg6QmbUWk9xZF085QvQUC1Udn3QqoeTGM7y2s
         +QVOfLPW9B7K9hlkEQHBieJ8HT4t2UpyDEJdmo+f7kRlKCROqxlF/jZr9G02q13tsV8l
         5FqjNqllTJyw73LCn39+PxASzRsKmbLTeDPoQHU5rMJG51qbyU7nzbQGph6E7u9516r1
         RYtVZPTChFfyfGy2NRW53ClkrGI2mCNaHCUg4Uy4rICDjZpi67kB2NBgClxPDeiutpZh
         Rs1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Th9WKl0IW7GpxbqwwqPmaZkhN6z6TMP9nRsqCNvkXyc=;
        b=jTgcqGR5fLb84IlSNMq+pxttNK8WyfNwwxKOYOtaD20p1EasocVeE/JCJbpAnQ2t2c
         g0qBYzRUMAJT0ud29kiL05iw2ura4UTVrywhhc5q+dcCW0p8VnT8dz6TsCNKRYGMSpWz
         z4rapOSkR/F+aLArgADy9kbkYdjNN6X7GM1zMRBEMsa23iX7F7d5UR+12AkvErqvVhRj
         GnL1FuIC0t2GWS08ZGqyylZyojU0+Pl+pvZ5JaA/3JysGgjk/pl24ke3gWdK95RZYqyb
         vyHgo4fxIbc1ntoNRq6KiUVcsoVpai/NcYaizu9G03j94MgrqLDEzYJJtXK4KfE/X4od
         PVgA==
X-Gm-Message-State: AOAM530kB0hFLIPR8XBjuHxylDf3eGEiNhznnzxe0hLHMXy+AKnqk3fR
        7TLoohLSOKcPo+DrTPMM9ys=
X-Google-Smtp-Source: ABdhPJxPcSw90+TVPMjlF0M7lJSG4APT4BstUXA4LaFdE9T3ULA3zTfOten6M/1sqw2LsoSLCruwfg==
X-Received: by 2002:a63:5815:: with SMTP id m21mr4075188pgb.363.1628778142724;
        Thu, 12 Aug 2021 07:22:22 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id x81sm3706010pfc.22.2021.08.12.07.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 07:22:22 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        bridge@lists.linux-foundation.org (moderated list:ETHERNET BRIDGE),
        netdev@vger.kernel.org (open list:ETHERNET BRIDGE),
        linux-kernel@vger.kernel.org (open list)
Cc:     Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v2] net: bridge: switchdev: pass more port flags to drivers
Date:   Thu, 12 Aug 2021 22:22:12 +0800
Message-Id: <20210812142213.2251697-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These 3 port flags: BR_HAIRPIN_MODE, BR_MULTICAST_TO_UNICAST, and
BR_ISOLATED, affect the data path and should be handled by switchdev
drivers.

Add them to BR_PORT_FLAGS_HW_OFFLOAD so they can be passed down to
the drivers.

Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
v1 -> v2: added more flags

 net/bridge/br_switchdev.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 6bf518d78f02..2ab46178c47c 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -70,8 +70,10 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 }
 
 /* Flags that can be offloaded to hardware */
-#define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | \
-				  BR_MCAST_FLOOD | BR_BCAST_FLOOD)
+#define BR_PORT_FLAGS_HW_OFFLOAD (BR_HAIRPIN_MODE | BR_LEARNING | \
+				  BR_FLOOD | BR_MCAST_FLOOD | \
+				  BR_MULTICAST_TO_UNICAST | \
+				  BR_BCAST_FLOOD | BR_ISOLATED)
 
 int br_switchdev_set_port_flag(struct net_bridge_port *p,
 			       unsigned long flags,
-- 
2.25.1

