Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31D101499B1
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 10:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgAZJDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 04:03:31 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43270 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgAZJDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 04:03:30 -0500
Received: by mail-pl1-f196.google.com with SMTP id p23so2620403plq.10
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 01:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d+pdlhH3HGuHqtnhsjcC54uu2GGuzCxFPbPH3vA9Fzs=;
        b=URC+OFPJ9O6kPcbl4kfxnPtgG1GRsKUL+KQ87d1XF5z3dl1rcBTJbkNS4zViQj39bz
         bZ9pUihDlcFHdvdh1bEzCGR4drQBdEjhF5q/48QHdLQD3q91ZhbcSjyej5cOyg8XCmM2
         YMLGdomy38cCuMxxnU8nrkXwKGfn4EOyWEjTU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d+pdlhH3HGuHqtnhsjcC54uu2GGuzCxFPbPH3vA9Fzs=;
        b=Z3ib46bJ53u1AEZY9gWnUKtHEpbBN+beXAqtxtIPhl1c9tMjYBzKRMSPL0Nf/SgLaW
         OTcWSu9I8+q+E+VcYGRHVrsJUYLgSMR3dfLdyJFF5x9FYDFaR/5GmehOOI0bYDWcy+Eb
         yZHjEE0S7+6pUpkzKkuA41HPnvzId01snBWvqtnpl+E3DaQqOuWHi1jYUBCOjLoWSP+9
         tRcirZZYCJ0lweq3U9fDOWfGu65Jlkm4bZhIFG6DAl+33Q1kpDVYnOgm+2nPxMdMtIYa
         Is9erTTW1jUiM2aJPBJerzao4QUHxwVbBgsaILQPSb0mhbbQ9qVijrFpTDwfqceggIfo
         qNfg==
X-Gm-Message-State: APjAAAWT/EtZhDi0ZWtxaG6ZR6mjiwbZAOuP/mQjwQUbsaCwXvdcsbtl
        1sQeT9RZWPMWVO6LZDbcDzRliA==
X-Google-Smtp-Source: APXvYqx/g44SmM+BbZTlL639cY4M9B5sqDFhEYu+u6/Gkg3ZkEmCtIo+UvOuxMPZs9sSfmLcYS5iew==
X-Received: by 2002:a17:902:d216:: with SMTP id t22mr12193939ply.150.1580029409985;
        Sun, 26 Jan 2020 01:03:29 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i17sm11856315pfr.67.2020.01.26.01.03.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jan 2020 01:03:29 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 03/16] bnxt_en: Improve bnxt_probe_phy().
Date:   Sun, 26 Jan 2020 04:02:57 -0500
Message-Id: <1580029390-32760-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
References: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the 2nd parameter fw_dflt is not set, we are calling bnxt_probe_phy()
after the firmware has reset.  There is no need to query the current
PHY settings from firmware as these settings may be different from
the ethtool settings that the driver will re-establish later.  So
return earlier in bnxt_probe_phy() to save one firmware call.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4b6f746..4d790bc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11471,6 +11471,9 @@ static int bnxt_probe_phy(struct bnxt *bp, bool fw_dflt)
 			   rc);
 		return rc;
 	}
+	if (!fw_dflt)
+		return 0;
+
 	rc = bnxt_update_link(bp, false);
 	if (rc) {
 		netdev_err(bp->dev, "Probe phy can't update link (rc: %x)\n",
@@ -11484,9 +11487,6 @@ static int bnxt_probe_phy(struct bnxt *bp, bool fw_dflt)
 	if (link_info->auto_link_speeds && !link_info->support_auto_speeds)
 		link_info->support_auto_speeds = link_info->support_speeds;
 
-	if (!fw_dflt)
-		return 0;
-
 	bnxt_init_ethtool_link_settings(bp);
 	return 0;
 }
-- 
2.5.1

