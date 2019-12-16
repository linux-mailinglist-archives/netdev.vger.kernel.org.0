Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEE1120EF2
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 17:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfLPQNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 11:13:34 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36376 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfLPQNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 11:13:32 -0500
Received: by mail-pf1-f196.google.com with SMTP id x184so5843659pfb.3;
        Mon, 16 Dec 2019 08:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QkYUT7jxO9Ef328b0I+UMqu+F0Qvw/d1kwZVAedcFkQ=;
        b=Om1+A8Mk6FjVGdAw3SytUAeSPpEWtk6PEe+72l6KXNHSbMcrK7X3aiTAebHjjmmT0H
         DsErLF/RFfr4OS21T5ZDBrH2ekWFu05UVBP2UW69stPN03GrmJUm8a9q7jqvOWQhVHvm
         ZuxAV8Hq1t/r1YKGe8E7gX8UiUn1rsoQ0siC7d3xziLnQHKqSqQPU+d90cCdWygUd6wD
         kzN0Lg2eiBojj1/CsU9+cg2pi4+B+5PMP6jW/tBei4uQBn7+gXacQr8jJ3DMnZjPywIs
         pqcjpUDoKjiB1yrkA8R45k3Ym8nxHfYDmwzhHD7EtXufQZgTtQraOSwul21pA/BXenX0
         2hKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QkYUT7jxO9Ef328b0I+UMqu+F0Qvw/d1kwZVAedcFkQ=;
        b=YuVJVMKb1XYv2NfuZ0ynIvh5sPgJd114TN9EInDmQlhiYMOu6YLtPzROU/H7fKiE47
         Anc4TzdF4hguvAWqZQlBaF91WyzBeHTz9uAX+iiNIeVD/uwgcgeU/ahQmVkWKUoL9eyf
         5ZFvmNnJ0GDfVHmQxMldWPrSrpRb7brRzciW2K0oZiQ5vz1v8Ddxdx2hZIQ6sI7zzjBc
         8gSj9HETAkVUFbBa8tU30/Q3JgatQTgroshirL1TdDWQfP48wu8Q4IXl2d9bUpEa8qO5
         veV16PpIrmwN3FI+eQMmKsK9zb8E5IdB8K0lwjVBw3W/azFkC4EzhY43sMF6pyXY+ckt
         1O9A==
X-Gm-Message-State: APjAAAUqej5m6KiIPqDQNtDGY5jPLzgckfumrfd5X94rHL9bZojGLrmF
        L8/4O+XTj7mWlXCbvDrMkZmnXUJ1
X-Google-Smtp-Source: APXvYqwenL13UcIXMktN46p7QC9zlCVwo9EUP1QY8h79JcryrTihqvzcYxs3sfnoJj2JfWGkw4lgEg==
X-Received: by 2002:a62:1a09:: with SMTP id a9mr16682797pfa.64.1576512811541;
        Mon, 16 Dec 2019 08:13:31 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 83sm23478433pgh.12.2019.12.16.08.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 08:13:30 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: [PATCH V6 net-next 02/11] net: macvlan: Use the PHY time stamping interface.
Date:   Mon, 16 Dec 2019 08:13:17 -0800
Message-Id: <7f0669dcb222c66ea109863d5b90daf020cf54bc.1576511937.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576511937.git.richardcochran@gmail.com>
References: <cover.1576511937.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The macvlan layer tests fields of the phy_device in order to determine
whether to invoke the PHY's tsinfo ethtool callback.  This patch
replaces the open coded logic with an invocation of the proper
methods.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/macvlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 05631d97eeb4..d066cf58c926 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1036,8 +1036,8 @@ static int macvlan_ethtool_get_ts_info(struct net_device *dev,
 	const struct ethtool_ops *ops = real_dev->ethtool_ops;
 	struct phy_device *phydev = real_dev->phydev;
 
-	if (phydev && phydev->drv && phydev->drv->ts_info) {
-		 return phydev->drv->ts_info(phydev, info);
+	if (phy_has_tsinfo(phydev)) {
+		return phy_ts_info(phydev, info);
 	} else if (ops->get_ts_info) {
 		return ops->get_ts_info(real_dev, info);
 	} else {
-- 
2.20.1

