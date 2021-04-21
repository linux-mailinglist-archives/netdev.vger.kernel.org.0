Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C25A366A64
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 14:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239499AbhDUMFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 08:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239238AbhDUMFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 08:05:36 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817BDC06138A
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 05:05:02 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id q22so4039993lfu.8
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 05:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=ik62DtIT8mcYynVtSQf4YeYw+4lWsIEkMOvdGt8/XTY=;
        b=1UIq0mbcl1M0eMo7YuTg4Oe72z/XQcLFeFU2EAUlVMmIIwvb/A17fdRs9DnEUtkMCC
         5PEvX4xTcPCZMFVd97xSlXC2lwGCdBsAAz6ztqhteRcps79P3eJp1MjmezS3G2syianS
         IGPdWFXD7ZuCyL/r0rItGGcIMbUX5TXhSL509Kfhjpaw1MwVzwzSc4Ihu4M9i1plmcOt
         0iZRLFqMlKqcsvcgjETkwIQa1DEnGMIXHbQ0v2Cn+xaJrfWtM/CM8xbH2oRzeTcvm7im
         Jee07+pVKovoC09xCfaZLmuNcGtY2cIAEHIDvXmxQmDf+MGLAo36bA3DzMLUM7DJw3S/
         MwFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=ik62DtIT8mcYynVtSQf4YeYw+4lWsIEkMOvdGt8/XTY=;
        b=SlrTvbxL4gjY2rMH6alKZqGg7YoX0hHbhSLbOKhdhrW+4LH9HrGcmR1S6vHfxZe/F3
         W403Hl3G3naTPMH26EQWSjPgHUWR0lMgLKnAs5qB2VSQ/aRARdAH//9aoGzlrFGHfoK3
         cL3wGypPIQ2FTcci1nq0btgJ/iexE+JQxKNxWrzPTRTrTwVEcTc6QG2Wt6Va7TaxYlKX
         V8CsJOn2zUEEVl8LRD94NZnxUbpbbfNLsSuhh5toUAuxfZM6/I5jI++fxz7/oY9dwhAO
         HOFoiOU7h3qP50jpY+5aN6afFbSG7+8QKzxXgGxSOBddGnS2XQNTbROGqmARZQwpPM3Z
         wYmA==
X-Gm-Message-State: AOAM533U0CqF3GK71ESNRJqhWvBxUczsUBqj5+BD993V61jcqf75lIwq
        KvhhJhXCFRpoo7VX3JVfo9PB6A==
X-Google-Smtp-Source: ABdhPJw5/GuZo3AiRldOMagzCzoItDD15X8tCxfStkKIivl4fXCbBV9LoUOY08X85EnIMIWN+5M3WA==
X-Received: by 2002:ac2:5f75:: with SMTP id c21mr16655848lfc.600.1619006701070;
        Wed, 21 Apr 2021 05:05:01 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id r71sm193430lff.12.2021.04.21.05.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 05:05:00 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net-next 2/3] net: dsa: mv88e6xxx: Fix off-by-one in VTU devlink region size
Date:   Wed, 21 Apr 2021 14:04:53 +0200
Message-Id: <20210421120454.1541240-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210421120454.1541240-1-tobias@waldekranz.com>
References: <20210421120454.1541240-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the unlikely event of the VTU being loaded to the brim with 4k
entries, the last one was placed in the buffer, but the size reported
to devlink was off-by-one. Make sure that the final entry is available
to the caller.

Fixes: ca4d632aef03 ("net: dsa: mv88e6xxx: Export VTU as devlink region")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/devlink.c b/drivers/net/dsa/mv88e6xxx/devlink.c
index 21953d6d484c..ada7a38d4d31 100644
--- a/drivers/net/dsa/mv88e6xxx/devlink.c
+++ b/drivers/net/dsa/mv88e6xxx/devlink.c
@@ -678,7 +678,7 @@ static int mv88e6xxx_setup_devlink_regions_global(struct dsa_switch *ds,
 				sizeof(struct mv88e6xxx_devlink_atu_entry);
 			break;
 		case MV88E6XXX_REGION_VTU:
-			size = mv88e6xxx_max_vid(chip) *
+			size = (mv88e6xxx_max_vid(chip) + 1) *
 				sizeof(struct mv88e6xxx_devlink_vtu_entry);
 			break;
 		}
-- 
2.25.1

