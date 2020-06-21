Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C389202B59
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 17:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730343AbgFUPbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 11:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730295AbgFUPbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 11:31:02 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C00C061794;
        Sun, 21 Jun 2020 08:31:02 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id a14so522530qvq.6;
        Sun, 21 Jun 2020 08:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=w7LEvtximaHHI3gKwz/HbBq2os4OtLow9QLP893GQuQ=;
        b=nWpJwnhQH+1M5XEsttvFRqBkYuaEcMNvmcCLmRBkfBw4kV+mM0F8ZOIe37iAHnvKUa
         S/uL4sBaGMie6KUthFyqSSR8qZQUC53kqays/zjz0CgHtWDi/mgTby9kL3oPZDSX/AMD
         6oqr5f9GPZOVdHtUAXHphMdGCO25+CJoDsYiJklBOBiSqwL76P9O7L8FPJlqVf0w8qCp
         4ParinX+0zhNIbaST7MQZreXYjJhpoeafSnY3yQbb9eAIx9y/GkJszMkI3bLLwxcQY5S
         jW0fPmq+mCsETmxbDng5zdst4GdusFbbO1TN4s688pt2fDrMRfPfeTY223C5GWWUoDI9
         gULw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=w7LEvtximaHHI3gKwz/HbBq2os4OtLow9QLP893GQuQ=;
        b=rnEltsKp3W5BtSxQjAZO4J3qvtKsVOrUccJ7qPinhUm+5X5KyAsdCmYQZAFS/p0edD
         PNFtI4zqSWrhg/jeKQdQwlMapVJD1xlbmDLPQaIuKsGyna0lQcWZd4HaK7SZIBoxr26p
         nnDmelm+sPXjZGWKy2oXb7zoJ6rmufW8R2K/JsnwhdLrdci2XAuRvDMbXPUnx7Ma1GRs
         Mey4VjhBXKmCBjTO0s1hlPEixtn9VwRLbP3Mr8hnkkPRP/2z1FaeNLQdy2kzj5GzqqSC
         myP63qY5yfpdMVFEMu9HbMLP4KBqbXnoseCEoJOKWVxDUumZgLxuELIAaua1yG/WB8hD
         1p5w==
X-Gm-Message-State: AOAM533XYF2Wf7orF6ZcuwDJikqQTEtelQBPRYUx3croreHv0yOF3keE
        2aXMIpQSiqSQF1HEjFXAMUY=
X-Google-Smtp-Source: ABdhPJwfAmBdJViS1b+C/fzM2lXjn4h5Ea3EWPfW7eM3EXMI3vSg2n9U9zZNvxyRPCc2cU85ynIapw==
X-Received: by 2002:a0c:aed6:: with SMTP id n22mr17897310qvd.70.1592753461637;
        Sun, 21 Jun 2020 08:31:01 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:c0e3:b26:d2d0:5003])
        by smtp.googlemail.com with ESMTPSA id o4sm3375185qtb.17.2020.06.21.08.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 08:31:00 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Leon Romanovsky <leon@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] Fix check in ethtool_rx_flow_rule_create
Date:   Sun, 21 Jun 2020 11:30:17 -0400
Message-Id: <20200621153051.8553-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix check in ethtool_rx_flow_rule_create

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 net/ethtool/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index b5df90c981c2..21d5fc0f6bb3 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2978,7 +2978,7 @@ ethtool_rx_flow_rule_create(const struct ethtool_rx_flow_spec_input *input)
 			       sizeof(match->mask.ipv6.dst));
 		}
 		if (memcmp(v6_m_spec->ip6src, &zero_addr, sizeof(zero_addr)) ||
-		    memcmp(v6_m_spec->ip6src, &zero_addr, sizeof(zero_addr))) {
+		    memcmp(v6_m_spec->ip6dst, &zero_addr, sizeof(zero_addr))) {
 			match->dissector.used_keys |=
 				BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS);
 			match->dissector.offset[FLOW_DISSECTOR_KEY_IPV6_ADDRS] =
-- 
2.17.1

