Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B379314A143
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgA0J5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:57:02 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:36263 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgA0J5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:57:01 -0500
Received: by mail-pj1-f66.google.com with SMTP id gv17so2903706pjb.1
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 01:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d+pdlhH3HGuHqtnhsjcC54uu2GGuzCxFPbPH3vA9Fzs=;
        b=hs0GuQuDarFQ1ydQx4pU7amSBiQAXJ9CIcCeLxmZ1oCnbAS8JENvhOthPzzO1lESAI
         M142S9jyfG8QaMIEQL+452RAOYIn+HczefM9UttGyyXia2u4gQhOSLHQhUvFTe1BlzBe
         ahZBFH5QbkZlcYQKGRcJ56s10zIh6m2Golpug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d+pdlhH3HGuHqtnhsjcC54uu2GGuzCxFPbPH3vA9Fzs=;
        b=RTIRpQcvuR8asnb5emrbsD1p6qpsSFBw82r6ZeKiSDXgpptRo1edD+ZCYbgLiH/xim
         yv9MJu0fgQZyllmvUoXvjTe/o/2H823W8rD6s9XVAJNKFSK+ozDUYbc2Jljbn9reS2GD
         Zbthtu31TweGTfufA5O37HHtubU715wwKbyqpVlhScaqlowVWfZjxK2590HSoBaKNTt+
         PpFbUPD8edLdBNyzTOnjATXzB5lHpeB/9hW6VCt1mxzBOmgo/cV9n5nIfOdHOhSc+kLt
         VvvdGvE/vdzZtX0El4myWQxc+5DZ6E0stRCRfHYo7/9qDKq+F8J+UHwU0xVyApoIq0PG
         Tvpg==
X-Gm-Message-State: APjAAAU8VUY/R/2qjWSKFedgVLeyXBNTv0UGHVyCBXSjtIuM9I109+jo
        lyeSqkCRQFoTvfGinSjYw5oiFI9xvNk=
X-Google-Smtp-Source: APXvYqzvqKNRhu7toEytz6XLrrCDRpO9VbDZjO7rON73Ni5CCcqAAByivDot+GoyMeqQKKLvLc7LpA==
X-Received: by 2002:a17:90a:9b88:: with SMTP id g8mr13570659pjp.72.1580119021180;
        Mon, 27 Jan 2020 01:57:01 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r3sm15232594pfg.145.2020.01.27.01.56.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jan 2020 01:57:00 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 02/15] bnxt_en: Improve bnxt_probe_phy().
Date:   Mon, 27 Jan 2020 04:56:14 -0500
Message-Id: <1580118987-30052-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
References: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
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

