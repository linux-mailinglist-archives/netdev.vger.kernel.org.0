Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5EE1C3180
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 05:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgEDDvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 23:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbgEDDvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 23:51:07 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F419CC061A0E;
        Sun,  3 May 2020 20:51:06 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id rh22so12705046ejb.12;
        Sun, 03 May 2020 20:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=61xhgDGc14PjWGT+UPMdCblFNXcNXrLsMXpcQV30Zvw=;
        b=dAmr0FgWofbeUDE0c2ykk+/p7bxfkD1i8Su0uYlO3HerLEfiInIKVesIg6u3NJuyKF
         YMCc7fo9FcLA6IuTvNHYxkiaMDtOEbEIvDQf//FkoMq7J+30zCknK3Fd8hIt/33z9p8a
         DQ5Yja9rCQUPNGaa3t2urvQOYT/BAtplD74BNRXsJhqCcXLFwlimDFjts1N7dVGXzQ8s
         ia3cbPeqR91AEpe1NuqGQySgxkaQBUWkf3YgSgJL7C2/60613cUma/LSP38QMxf766PE
         9T8ZXO9pZ7PoynIhxHUUMWDecgxGwQdTg60GEq/TQf1uD3Gi7Jzs9b6MUcbEBwdOHVHa
         zQYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=61xhgDGc14PjWGT+UPMdCblFNXcNXrLsMXpcQV30Zvw=;
        b=XikzcawIkbY8TIYrSjM8GDEJbNB409YHoUiL9RquHEvUofpJHWmWFoQFkVTPfRRho2
         Un531X58yGHxmFTz9yELFG/Fdc6qmtqIzMRG0BNvath6D3+pK1JHqrayGDqNJexVWsYY
         U7KrC5V4aQSAOPT4cWYvR+W1w6940hsyCYdu06f5dJfCYYefVoUo9GsYWpYMQWvl4ugc
         UsZea12jGuA6ACAU9/ntxsDEaBRCLjRiRsst/a/6PUPJ0LmTAeWQFZRDSEUBk/CnHOPL
         9duXYzZ2T5h70+zZNdp5dvOmp4SiEMXcTbgK6tMDW2IWvXVNPGqJnSS2zMCobJ21+Fk6
         KQcA==
X-Gm-Message-State: AGi0PubQ6dcxkYIlSfCgrIH/6jtTeZURlg69rDU+Z0EyzkAP6uWncqSJ
        h4vPpeMl6BtwS9l4yV8tDHuQdclZ
X-Google-Smtp-Source: APiQypJGtIoCAhlaIS7VkGnCNt5fu/cW/IN11ak+DiYic/9FRqnoIQZwyGPZiA93Mcqdf7/qEHqndg==
X-Received: by 2002:a17:906:2b8a:: with SMTP id m10mr2092466ejg.183.1588564265311;
        Sun, 03 May 2020 20:51:05 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h11sm1408468ejc.4.2020.05.03.20.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2020 20:51:04 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: dsa: Do not make user port errors fatal
Date:   Sun,  3 May 2020 20:50:57 -0700
Message-Id: <20200504035057.20275-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prior to 1d27732f411d ("net: dsa: setup and teardown ports"), we would
not treat failures to set-up an user port as fatal, but after this
commit we would, which is a regression for some systems where interfaces
may be declared in the Device Tree, but the underlying hardware may not
be present (pluggable daughter cards for instance).

Fixes: 1d27732f411d ("net: dsa: setup and teardown ports")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/dsa2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 9a271a58a41d..d90665b465b8 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -459,7 +459,7 @@ static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
 	list_for_each_entry(dp, &dst->ports, list) {
 		err = dsa_port_setup(dp);
 		if (err)
-			goto teardown;
+			continue;
 	}
 
 	return 0;
-- 
2.17.1

