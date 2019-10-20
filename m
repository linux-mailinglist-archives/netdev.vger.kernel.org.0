Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE63ADDC1B
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 05:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfJTDVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 23:21:18 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44823 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbfJTDUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 23:20:20 -0400
Received: by mail-qt1-f193.google.com with SMTP id u40so15229277qth.11;
        Sat, 19 Oct 2019 20:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yA3pAqEUD+2bsrvCX5S7bkJSMgafZOgXAf+aWfs7aLc=;
        b=RVXLSspsPXbjBjCiOedeqBcYjbwGOFxlJEi4PLDTIPxIsrFz0rDqExLvNGX+nk8fLT
         jYpGbardSmFIhtLanPL3uQQxQ8CIp3OOd8mcytlzkgLVry9G5FToxYGp/k19jeumgDx9
         33EbF/Vd9T5U9S46VK7KKDlOnnMpysdkBrri8c/VFBTIR9WtPJFlo8l8zfp0QEZwQ0hD
         rKN6JCXa8Vv1ocmyheVxi2hWd5ZYe1PCAerAeNDZMMy+3oXnPO1DkYegSu/jkacTOLaY
         YY5CNCHGYqVLb9MCyOS08HPymXWeHnzUCZuxTEEAD1bBzlPlylO4+rVby2+HBVWHIxhG
         4Iiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yA3pAqEUD+2bsrvCX5S7bkJSMgafZOgXAf+aWfs7aLc=;
        b=rcs3/y/FYKNFefFEezZTuNMCBzStJc0a9CUUBhmYIoAZ3w6ARfsHHeaZlfHogDqDGq
         sukxBOxyqdgvMsW8KPbC9/k61lw8XGZsEXpOZhV0qwv+ynsg+ROm+sJhLveRyBKWL0Rr
         +MX7VBYUxjyGlWJ11SxeVTvQmOjdgcAjjpxcB385BxmFZubsroSyisO8iGxOoW8YsFsI
         BGxRVppgX3t3XeJB2eFm78f959r3946p3XjV8YGV4aiMplv249bb3ac2NwMLD4oB+v/D
         I6Ve4l3xEg7pEDinAq5pfqIxoBKsBjMRH2dYk4On++X7Hz0dudYbWj3mKbYOe4r6++rn
         PNsA==
X-Gm-Message-State: APjAAAVcJiginY9DLfO629BTqNvj7e83n/vPMwkg9FWHKldOcmWzp9Wm
        HXXnXUmWcUvpjG0fHgLQIwK5BRsf
X-Google-Smtp-Source: APXvYqyDBoeL0OrHFnoRiUUSTUbqN+85XAgBot6EvcJxlSVcJgbePpPTwmTdKQsI2CMWQudMrO9nMA==
X-Received: by 2002:a0c:d851:: with SMTP id i17mr18170018qvj.61.1571541619760;
        Sat, 19 Oct 2019 20:20:19 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 131sm6120739qkg.1.2019.10.19.20.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 20:20:19 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next 09/16] net: dsa: use ports list to find first CPU port
Date:   Sat, 19 Oct 2019 23:19:34 -0400
Message-Id: <20191020031941.3805884-10-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191020031941.3805884-1-vivien.didelot@gmail.com>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new ports list instead of iterating over switches and their
ports when looking up the first CPU port in the tree.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/dsa2.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 3b8de155bc0b..99f5dab06787 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -186,22 +186,11 @@ static bool dsa_tree_setup_routing_table(struct dsa_switch_tree *dst)
 
 static struct dsa_port *dsa_tree_find_first_cpu(struct dsa_switch_tree *dst)
 {
-	struct dsa_switch *ds;
 	struct dsa_port *dp;
-	int device, port;
-
-	for (device = 0; device < DSA_MAX_SWITCHES; device++) {
-		ds = dst->ds[device];
-		if (!ds)
-			continue;
 
-		for (port = 0; port < ds->num_ports; port++) {
-			dp = &ds->ports[port];
-
-			if (dsa_port_is_cpu(dp))
-				return dp;
-		}
-	}
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_is_cpu(dp))
+			return dp;
 
 	return NULL;
 }
-- 
2.23.0

