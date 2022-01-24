Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863304989AD
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343954AbiAXS5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:57:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344554AbiAXSyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:54:47 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221A5C061347
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:39 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d7so16639864plr.12
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MKIdVSYy7eCuFEVyN9FrYorP896yXAvKr1Vh748K9i8=;
        b=X47QfY3Sbgh2386AJhCB/tp57FFhJFularC7qbFlQ9qsYTp1e+syn8EFWWLFUvyRmJ
         fAK7f0S/vUsT0eYZ8KZ8RvR7xqJtNQhjdjulTD83CrpF9jPYaFPr4YNxpEGCTphEVxvP
         Mt56Fkv4VNCqG51VFdpJ/AjXYcZAAJvwJBBNc3zqxNG5wRMqtDK6cWQ2yy5sCHy0mqC9
         SHr1ucvllXYZHQbvynFqZFgTdTIVp7sD2cGDuB7HZl4rDl3FPqS3RZ6u8iU6oRd+B8f3
         PbbZKGTda8Yc+9+MjnVs8VLTIcfixBk9NEfFNdDz05BQ+2bPUbnWKORy4HI/etF0vD30
         Sp3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MKIdVSYy7eCuFEVyN9FrYorP896yXAvKr1Vh748K9i8=;
        b=U2qwdmZa+4pBO/oETxKj2gN7v8yHy4z1JMSmtZioOiF6w5auGMqgaH5UMuDBA8THfk
         ndOZOSwG6TwWom82kayOUB+zpHA7WTEp5t4e9p0Y1ugRliHaBwlvHCb/F6OuCLutdtyB
         wmvOK9uK9qvX9e7zwNw3yVClrxPcH70taOuYfY4qnxexKuiB4c3Qbsc2sVHmX79hMMq3
         miCsAPADCQyFJWMjB4rcLK/sx8AMPzSZd1EKYMlsg8Rs1TO+hUBOqwKib1sfIXcq/W1R
         8g/bHKdnvh8QJzFb+pm8g1kzLF6Xo6nhmt/bQyeQjYTMNx1ED/gOOTJNgR1DLuwJLXib
         IKvw==
X-Gm-Message-State: AOAM533skKMSWYoY//c3d7yFKwk8yIDv+ppaqILW/VfSzDQl9LVS9IEH
        6JlMxiwJr2eufx2m9G3kZa5uhA==
X-Google-Smtp-Source: ABdhPJxIztLX/DejVTYNKawrgFSX269Q6PZsURY66AuI4uqy0UHiA/RgB6mSc9gWNWxLKtZ9pP/rWA==
X-Received: by 2002:a17:90b:33ca:: with SMTP id lk10mr3233468pjb.45.1643050418650;
        Mon, 24 Jan 2022 10:53:38 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id cq14sm85177pjb.33.2022.01.24.10.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 10:53:38 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Brett Creeley <brett@pensando.io>,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 11/16] ionic: Prevent filter add/del err msgs when the device is not available
Date:   Mon, 24 Jan 2022 10:53:07 -0800
Message-Id: <20220124185312.72646-12-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220124185312.72646-1-snelson@pensando.io>
References: <20220124185312.72646-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett@pensando.io>

Currently when a request for add/deleting a filter is made when
ionic_heartbeat_check() returns failure the driver will be overly
verbose about failures, especially when these are usually temporary
fails and the request will be retried later. An example of this is
a filter add when the FW is in the middle of resetting:

IONIC_CMD_RX_FILTER_ADD (31) failed: IONIC_RC_ERROR (-6)
rx_filter add failed: ADDR 01:80:c2:00:00:0e

Fix this by checking for -ENXIO and other error values on filter
request fails before printing the error message.  Add similar
checking to the delete filter code.

Fixes: f91958cc9622 ("ionic: tame the filter no space message")
Signed-off-by: Brett Creeley <brett@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_rx_filter.c | 37 ++++++++++++++++---
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
index f6e785f949f9..b7363376dfc8 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -376,10 +376,24 @@ static int ionic_lif_filter_add(struct ionic_lif *lif,
 
 		spin_unlock_bh(&lif->rx_filters.lock);
 
-		if (err == -ENOSPC) {
-			if (le16_to_cpu(ctx.cmd.rx_filter_add.match) == IONIC_RX_FILTER_MATCH_VLAN)
-				lif->max_vlans = lif->nvlans;
+		/* store the max_vlans limit that we found */
+		if (err == -ENOSPC &&
+		    le16_to_cpu(ctx.cmd.rx_filter_add.match) == IONIC_RX_FILTER_MATCH_VLAN)
+			lif->max_vlans = lif->nvlans;
+
+		/* Prevent unnecessary error messages on recoverable
+		 * errors as the filter will get retried on the next
+		 * sync attempt.
+		 */
+		switch (err) {
+		case -ENOSPC:
+		case -ENXIO:
+		case -ETIMEDOUT:
+		case -EAGAIN:
+		case -EBUSY:
 			return 0;
+		default:
+			break;
 		}
 
 		ionic_adminq_netdev_err_print(lif, ctx.cmd.cmd.opcode,
@@ -494,9 +508,22 @@ static int ionic_lif_filter_del(struct ionic_lif *lif,
 	spin_unlock_bh(&lif->rx_filters.lock);
 
 	if (state != IONIC_FILTER_STATE_NEW) {
-		err = ionic_adminq_post_wait(lif, &ctx);
-		if (err && err != -EEXIST)
+		err = ionic_adminq_post_wait_nomsg(lif, &ctx);
+
+		switch (err) {
+			/* ignore these errors */
+		case -EEXIST:
+		case -ENXIO:
+		case -ETIMEDOUT:
+		case -EAGAIN:
+		case -EBUSY:
+		case 0:
+			break;
+		default:
+			ionic_adminq_netdev_err_print(lif, ctx.cmd.cmd.opcode,
+						      ctx.comp.comp.status, err);
 			return err;
+		}
 	}
 
 	return 0;
-- 
2.17.1

