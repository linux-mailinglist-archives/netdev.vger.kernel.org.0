Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A511246950E
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 12:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242508AbhLFLgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 06:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242511AbhLFLgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 06:36:04 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77062C0613F8;
        Mon,  6 Dec 2021 03:32:35 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id o13so21657311wrs.12;
        Mon, 06 Dec 2021 03:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aW1glWeSnLOJ6iHIw1/VSJXZ8zrzxkwYtnu3Xdlg+Oc=;
        b=WVO5P+eQWPU4+X6CehpqgY9445E2+3og75x9WfYJSc1Y0PN3UeGpl/JwVzIkznLEnk
         ZaY5L2xIMF52fO3oJ5wudIeuXJ9McFhpDujiIuDfhraEUKZFEv8b/9wQc8Uwj1KrRWX+
         gvEjWc9+ySuH3R9ItZpus/fNCtLh1i0MWoeods+6gPPzVZjcu34MvvanugG6FzHRFoiJ
         hX16H4dkhogyzbQwpovEyYLsIKbu5fjQ0NOybaNK3QKd6kZS85LW+r9bITL8CwATvhDy
         2Und7SBFZq1kJdDB6p67WZg/f1dus7dSl1hnCRrBDyYIZGCFRumClY41oMwRT8IHBjiZ
         fwEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aW1glWeSnLOJ6iHIw1/VSJXZ8zrzxkwYtnu3Xdlg+Oc=;
        b=M7UwOPGnqexbemmzMq1W9jgDblhP1GxMvJ9NqRiv8TW+/ehAxgpI+02bpqdEMLpgOD
         U1rmB2rUA12qiYRHHynT3OZWKGgiFpTahUU0FhMNs6RtDEPY0c4GXZylntYw7YSzxxom
         54qgI2KY/f+XVsevBzlg2RAMYOkvPXwk1YPxCqbPmgOiHrEs7XcS9uIyaaClOvOP86HC
         t3jrtDff79ktU6GAFxY78tr+2cnnGmWNPkUi2NMxkRgFz0Yic1Wqr8rCQo7VMXbPEa4e
         lrz9rm6frFG4ntjya2SdzsRM9kCGe4XzQ/93oB7Ms1/AhlsNY3nny6LcDD39CXkSzLbv
         yDYg==
X-Gm-Message-State: AOAM533zZAG3OXblXB3H6CGVd8QXknYPvvnBc15RmqjkLXn8JywIJDgS
        niJVeuSw5NUoDcENHmtQuCs=
X-Google-Smtp-Source: ABdhPJyHTJrDUlcp32XuRcvIEZsm0kmF3F5hwaN3rYdWZX5n9N6PCkO3dVPWLvnvaCCj2qvocGn8mg==
X-Received: by 2002:a5d:6c63:: with SMTP id r3mr42078963wrz.213.1638790354051;
        Mon, 06 Dec 2021 03:32:34 -0800 (PST)
Received: from localhost.localdomain ([39.48.147.147])
        by smtp.gmail.com with ESMTPSA id g5sm14248481wri.45.2021.12.06.03.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 03:32:33 -0800 (PST)
From:   Ameer Hamza <amhamza.mgc@gmail.com>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        amhamza.mgc@gmail.com
Subject: [PATCH] net: dsa: mv88e6xxx: initialize return variable on declaration
Date:   Mon,  6 Dec 2021 16:32:19 +0500
Message-Id: <20211206113219.17640-1-amhamza.mgc@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Uninitialized err variable defined in mv88e6393x_serdes_power
function may cause undefined behaviour if it is called from
mv88e6xxx_serdes_power_down context.

Addresses-Coverity: 1494644 ("Uninitialized scalar variable")

Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 55273013bfb5..33727439724a 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -1507,7 +1507,7 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 			    bool on)
 {
 	u8 cmode = chip->ports[port].cmode;
-	int err;
+	int err = 0;
 
 	if (port != 0 && port != 9 && port != 10)
 		return -EOPNOTSUPP;
-- 
2.25.1

