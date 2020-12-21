Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710622E00D8
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 20:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgLUTRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 14:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgLUTRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 14:17:08 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F68C061793
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 11:16:28 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id t16so12244523wra.3
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 11:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Hgqtg/BM45Gm64DFcm4q1HmsKbajvebg47kADOweA4=;
        b=PtR83ygb7zvEtzrIiBSejgyuaJHga5pGwHidcxlrdRrrmaShtj8eCDXybkBD4GXcFr
         BGYf5sH+1QWF0ouQHDsJX4dFiz+b544VyOwuHJn5E42PzS8/X23YQx6W+iDbs4GX0WVp
         TLTYgjZP63lnWS9p+2zs2Kqu/qQkPScTnEMa0jGaF8WNJW+6yL3fzstQZ9ufgddBnlO7
         0I7ltqsEiHXWiiHkQSKO9HBoXz+CvA33vwxjQpSIH4my2/dbLD5NMOC5x8mnlYkjq6aF
         TlmooU6hjLTe8HPioBVR9AaK7FiKomyV3j62w9rdU3xKVp6sv6zvvogBDjP6mkPWbT+D
         lWig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Hgqtg/BM45Gm64DFcm4q1HmsKbajvebg47kADOweA4=;
        b=iD36JhXURW6BSBNecdV58R5pEszfuTywK7fFrrZvyvnUyEERxKQGaiV6XVQLjYt2Hc
         W5t4ZLNTrBn9TeY8DZVFCZgDhsItrzMUD12nx8JmWqPN3gcmBri72GzmdJ/M5DUcwi7Q
         avguGZs93Iw4R/2slqyvIvQOW2gAMkHFG2PAv1/7oEqNVftVPYGhZZyUYUXoy+O1/1tQ
         guKLj8n0Gz4giZwuJr62ycS+FQyyxMVmU6cYQWAJUS+22onpc1I8suaX+OYR1TypDaCj
         DSAuTVW381+RyOlCzwO+/gCXlrNcquOkxap2EuIV4WotIp0BZM1Yz5enw2dJwYEfVL8A
         mBnA==
X-Gm-Message-State: AOAM532AHC/4TFN+BFs/Q6Y2MgHuvDosmlKq2EgjvKj2jlawCluKVjVo
        MN395gWmFPvwGcINNKyJNGKzjQnce78=
X-Google-Smtp-Source: ABdhPJzZ2elqyZc6zoCCEMLMnZ4KhM25Yc5h4su6LqoZlxWFI+Q7zVacGmtORHcP6zpgqEFFpcC08A==
X-Received: by 2002:adf:828b:: with SMTP id 11mr19740405wrc.180.1608578187139;
        Mon, 21 Dec 2020 11:16:27 -0800 (PST)
Received: from localhost.localdomain ([137.220.95.74])
        by smtp.googlemail.com with ESMTPSA id w8sm27929834wrl.91.2020.12.21.11.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 11:16:26 -0800 (PST)
From:   Nick Lowe <nick.lowe@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Nick Lowe <nick.lowe@gmail.com>
Subject: [PATCH net] igb: Enable RSS for Intel I211 Ethernet Controller
Date:   Mon, 21 Dec 2020 19:15:49 +0000
Message-Id: <20201221191549.4311-1-nick.lowe@gmail.com>
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

