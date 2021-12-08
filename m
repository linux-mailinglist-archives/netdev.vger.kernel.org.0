Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A69946D792
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 16:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236426AbhLHQBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 11:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236421AbhLHQBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 11:01:50 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9F9C061746;
        Wed,  8 Dec 2021 07:58:18 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id t9so4866532wrx.7;
        Wed, 08 Dec 2021 07:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+N+ZhzioiS3izYxHmaIXp7iNQEt/WMrjS1HOXzMIJfs=;
        b=Hz+ii3ihM256S8XIu1YCfKwR2X3Q5f3baEXbZP/bUNkz9NEJRJZLpbMoF59h8cic7Q
         npk6z0yoAFixqtHEZx9BpRa0BM4AYPhcWLl0eNUlCR6sGVz31ttv04WaVKKv0cPGOWFH
         3gJJezm67kqQh/wC/VoDvUAoS4MeFCFWOAVJkTmiJcp/yw9hh/ln7u9s03DKdJQy2AQZ
         WMtXU/jmMYk5kmBjwky0rZhojuZrfvyM88ogXESADYxwc1geiez+6HhfjFBzppevPOjK
         I4nkgJnlQWAVK4bdrl7+bvLCNF9SIkl2ScWsXRLqCWxVEtvGbj6G4TKFw5MUccHbwAJI
         /5LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+N+ZhzioiS3izYxHmaIXp7iNQEt/WMrjS1HOXzMIJfs=;
        b=zW+r0Sb60Is2sSIZ9NiERHvm0wAuqGOwVXXFy42W6eM1203rBI9rgEo9/89O+cRch2
         f2VNdTsyEO2S+BKu+Dq/oPaw6RJv6SoBpbf5nc4CUN4Ps8nE5spsTsRZ+xecHEKH9Olo
         c/HXmW2U/WId9rQayMzw3EVbmTMwUC48C554rxm8k38/SDT8YwHEL92GI+y03jkoDLUH
         hjoUgikE0DEqOxN2JF5vDwpmWMIWBFdoaUJ5CvVqpP/5xXuAkKr+T5puiNl9aOWtlEx7
         CFh2hKxRSCj3yaDH6Bt27CfG4+S+caKI5/Shj78xc5m1qfTg4eV7ftfeejgira0jDF7l
         N4qg==
X-Gm-Message-State: AOAM532wA0MyVTZCHeZoDUG6sIZtJkZsHoCwyOapa5jLY7Sd4f+Kt2kI
        FqRUly2qZLemro3tEPVqHclNDraETXGbf/G5
X-Google-Smtp-Source: ABdhPJwgE9kUeBKXRJA/vEiuwgFWzZT1E7fe81W2gYNBWO9X8sdrlB0Qy31XpmRVu5TSiXCeemI1PQ==
X-Received: by 2002:a5d:4343:: with SMTP id u3mr61256334wrr.450.1638979096934;
        Wed, 08 Dec 2021 07:58:16 -0800 (PST)
Received: from localhost.localdomain ([39.48.199.136])
        by smtp.gmail.com with ESMTPSA id r83sm6276856wma.22.2021.12.08.07.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 07:58:16 -0800 (PST)
From:   Ameer Hamza <amhamza.mgc@gmail.com>
To:     kabel@kernel.org, kuba@kernel.org, andrew@lunn.ch
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, amhamza.mgc@gmail.com
Subject: [PATCH v3] net: dsa: mv88e6xxx: error handling for serdes_power functions
Date:   Wed,  8 Dec 2021 20:58:09 +0500
Message-Id: <20211208155809.103089-1-amhamza.mgc@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208164042.6fbcddb1@thinkpad>
References: <20211208164042.6fbcddb1@thinkpad>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added default case to handle undefined cmode scenario in
mv88e6393x_serdes_power() and mv88e6393x_serdes_power() methods.

Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
---
Changes in v3:
make err = -EINVAL instead of direct return, so that we can
check in the code after and handle the error case.
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 33727439724a..2b05ead515cd 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -830,7 +830,7 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 			   bool up)
 {
 	u8 cmode = chip->ports[port].cmode;
-	int err = 0;
+	int err;
 
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
@@ -842,6 +842,9 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 	case MV88E6XXX_PORT_STS_CMODE_RXAUI:
 		err = mv88e6390_serdes_power_10g(chip, lane, up);
 		break;
+	default:
+		err = -EINVAL;
+		break;
 	}
 
 	if (!err && up)
@@ -1507,7 +1510,7 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 			    bool on)
 {
 	u8 cmode = chip->ports[port].cmode;
-	int err = 0;
+	int err;
 
 	if (port != 0 && port != 9 && port != 10)
 		return -EOPNOTSUPP;
@@ -1541,6 +1544,9 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 	case MV88E6393X_PORT_STS_CMODE_10GBASER:
 		err = mv88e6390_serdes_power_10g(chip, lane, on);
 		break;
+	default:
+		err = -EINVAL;
+		break;
 	}
 
 	if (err)
-- 
2.25.1

