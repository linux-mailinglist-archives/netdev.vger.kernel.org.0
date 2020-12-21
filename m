Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79F92E027C
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 23:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgLUW01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 17:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgLUW00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 17:26:26 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E09AC061793
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 14:25:46 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id i9so12676027wrc.4
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 14:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Hgqtg/BM45Gm64DFcm4q1HmsKbajvebg47kADOweA4=;
        b=QgSbLRFwjK/MsfiXMQB75ws0gBS3IxdWi2bJ+/i9JOudGaKfrfE2Mgpz4LoH1+2ZGs
         XnsbW3DUhSHYjCuLc1sYHjWOhde1gz+7nGb+DjBENMrZNgBG5lh9dEPbkzHgH8UDAp5B
         h4pSablc3g1zpjLXEGM5kXk71WHHqNWYdt2q8XReGp+ssouM6qSQQm1sgigk45YK6/7W
         8SIFZkvvRyTM/mrCf6s4ZDYsbfXzWrOKDctqw40CGwSN6V2ZuzCyNllubixTXLcrngZf
         8Gm6gKLOpY171qEMU9FuybZB5ovRBjXSmAMKQLJoegjXAl8cSnHDXBsSw152eFwGzS1H
         NrDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Hgqtg/BM45Gm64DFcm4q1HmsKbajvebg47kADOweA4=;
        b=HxRPCOn+SaChHOPNRmie7lRnTS3FO3FOpIPADCf3Wl1ld7Fr4+6STu6TJXR3GXxCLC
         nhLbNJ4hk3meQgDjnFrFopdsD4cwJMpnXQWYUf8WTCWq2576LKkXC0nDlxT07POe4QXw
         1By50Rw4e6vaWfsBi93w8YDiU5DHrh0GaOs6oBZnrGhNJTPJv7bzN0uzO9gIRJFlybrr
         5klp1+rV9aBPNxYOCQycClG9pu83dxyiASlwL5pAMyd7lhQvutp+D95nvVKnzSN72mGf
         AQEpfXJPFOJzPaG8Q9c9p4GFUEjOTUmx4NNmevad4pB3VBCx7CrF7zpBQEJrLe2dYl5m
         /T1Q==
X-Gm-Message-State: AOAM533DIK8NkoU+GxNsPnlQUZthrtf92m5L3etFAlyN1Ghn3sa5SOOs
        /Pt5jTYRYs/bi431SzTj9qpVhGveXCkudQ==
X-Google-Smtp-Source: ABdhPJyCtXsgCG+Yw6sLJYkIj322kEd26a+QNph35iicN9udxSX2OqVVGoJo2od2Vt73Z7HUYfgTtw==
X-Received: by 2002:adf:f891:: with SMTP id u17mr21073755wrp.253.1608589543623;
        Mon, 21 Dec 2020 14:25:43 -0800 (PST)
Received: from localhost.localdomain ([137.220.95.74])
        by smtp.googlemail.com with ESMTPSA id z3sm29467961wrn.59.2020.12.21.14.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 14:25:43 -0800 (PST)
From:   Nick Lowe <nick.lowe@gmail.com>
To:     netdev@vger.kernel.org
Cc:     anthony.l.nguyen@intel.com, kuba@kernel.org,
        jesse.brandeburg@intel.com, intel-wired-lan@lists.osuosl.org,
        davem@davemloft.net, Nick Lowe <nick.lowe@gmail.com>
Subject: [PATCH net] igb: Enable RSS for Intel I211 Ethernet Controller
Date:   Mon, 21 Dec 2020 22:25:02 +0000
Message-Id: <20201221222502.1706-1-nick.lowe@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Intel I211 Ethernet Controller supports 2 Receive Side Scaling (RSS) queues.
It should not be excluded from having this feature enabled.

Via commit c883de9fd787b6f49bf825f3de3601aeb78a7114
E1000_MRQC_ENABLE_RSS_4Q was renamed to E1000_MRQC_ENABLE_RSS_MQ to
indicate that this is a generic bit flag to enable queues and not
a flag that is specific to devices that support 4 queues

The bit flag enables 2, 4 or 8 queues appropriately depending on the part.

Tested with a multicore CPU and frames were then distributed as expected.

This issue appears to have been introduced because of confusion caused
by the prior name.

Signed-off-by: Nick Lowe <nick.lowe@gmail.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 03f78fdb0dcd..87ac1d3e25cb 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4482,8 +4482,7 @@ static void igb_setup_mrqc(struct igb_adapter *adapter)
 		else
 			mrqc |= E1000_MRQC_ENABLE_VMDQ;
 	} else {
-		if (hw->mac.type != e1000_i211)
-			mrqc |= E1000_MRQC_ENABLE_RSS_MQ;
+		mrqc |= E1000_MRQC_ENABLE_RSS_MQ;
 	}
 	igb_vmm_control(adapter);
 
-- 
2.29.2

