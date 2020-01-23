Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA3B5146906
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 14:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgAWN2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 08:28:19 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37876 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727194AbgAWN2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 08:28:18 -0500
Received: by mail-lf1-f67.google.com with SMTP id b15so2286316lfc.4
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 05:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mtj5BWUVGyinNX7wvC73dcZuNmbbOVj5imGPpnqwC7s=;
        b=UZd2c5nyGY2rKI/2SUt5BXQqvmIHkkRf+jsPzmIMbnYtgP5mjuvoRKkMSiclljwFWD
         8nH8mAzPwXXUk5Eg3xbzAcJmiUdIgN9NOiJPCkTfk+6TLJ8v21c15H+ymNSKNQDy2oPW
         O7tnKIJ5jSJMkKsN07BcWhSod4qIB/lo1+deE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mtj5BWUVGyinNX7wvC73dcZuNmbbOVj5imGPpnqwC7s=;
        b=RM3NmIaGBMjjXjueiiQwVRMlRwJYH3Vtq1PX5lV8HyjIQJZFfjdZZNM4HGFiZgD2Sg
         1351HalJnMmTtDpZKJRmFC0NJr9JJ2SqpZRXmEsMV82pe3FFQiqnBAwZOtVzi7i47b7N
         fsDExxh6jc0toqTueWfXMCp8ws2wpIYor162MMfLfpTRhc4c8AQm2wPboMsXkRImsfXK
         PYmkRS/GfNDJqInXcHYxudHnclM855KpzVeujER2ebJKZgoH2u0wW+Sh28roolcEvRJf
         t340CJ9H6tCiZ15YXETKRbKeVMcSxMxscJBvptv7T0OgmimSX56eFa+2sudwCIOUNwE5
         MuNA==
X-Gm-Message-State: APjAAAUsD4dtZ2b/xs7c3SP1w2r4cWUU5VCsSDasDmpo/OPfZZfvFrFl
        roUzzBOkORYJKUn5Qyouu3ri0+6UPeM=
X-Google-Smtp-Source: APXvYqyGSQMTA1c6s5oE1M0N0X8tb3IVqAOnwYf4Iapt4+LKCWPHBlrTKq5oaLfD4IhvG/8vbOgfxA==
X-Received: by 2002:a19:4849:: with SMTP id v70mr4779278lfa.30.1579786096460;
        Thu, 23 Jan 2020 05:28:16 -0800 (PST)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b20sm1238571ljp.20.2020.01.23.05.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 05:28:15 -0800 (PST)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 1/4] net: bridge: check port state before br_allowed_egress
Date:   Thu, 23 Jan 2020 15:28:04 +0200
Message-Id: <20200123132807.613-2-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200123132807.613-1-nikolay@cumulusnetworks.com>
References: <20200123132807.613-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we make sure that br_allowed_egress is called only when we have
BR_STATE_FORWARDING state then we can avoid a test later when we add
per-vlan state.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_forward.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 86637000f275..7629b63f6f30 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -25,7 +25,7 @@ static inline int should_deliver(const struct net_bridge_port *p,
 
 	vg = nbp_vlan_group_rcu(p);
 	return ((p->flags & BR_HAIRPIN_MODE) || skb->dev != p->dev) &&
-		br_allowed_egress(vg, skb) && p->state == BR_STATE_FORWARDING &&
+		p->state == BR_STATE_FORWARDING && br_allowed_egress(vg, skb) &&
 		nbp_switchdev_allowed_egress(p, skb) &&
 		!br_skb_isolated(p, skb);
 }
-- 
2.21.0

