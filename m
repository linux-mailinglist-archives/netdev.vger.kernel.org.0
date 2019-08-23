Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC3C89A73B
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 07:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391902AbfHWFwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 01:52:07 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44672 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391856AbfHWFwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 01:52:06 -0400
Received: by mail-pg1-f196.google.com with SMTP id i18so5133733pgl.11
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 22:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=cf8OSsHVcAxEXY/fwlzzFK4n2S6Ml35GE2j/+I/8FyQ=;
        b=PbPSdyHDEWA/5i3lLQzqKN6HqBfuMcMgB8Pe8LCUjNex94o433v5dJ4uDncBshqpSz
         9RHqj7ZmH/JvdGI8OjC8m+LdEMgXNeXqx/unPUXJ0pCaKFG5JJcZuTO6A/UfIHR1UENT
         gvNthHx1qsjfY7C+z1m9D7pCtepFJpVF19sDE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cf8OSsHVcAxEXY/fwlzzFK4n2S6Ml35GE2j/+I/8FyQ=;
        b=Ik7LFCBce+5ZZoW5jdDobOqrFePgIvLsmNUomQ1a1Vt9NhLIbNVkX0phjAjXGrGu6M
         er8XzBTAkxzw5Z2fp2XMdj3Yu0gJcCYVDTLX+6wqlsS0CIFy90EwhaZbZDJzMaeEDi+u
         jvCcWdfG5fe3c32OWysP8A1vRbB8KKdhu3hjr4FuU9BWfFDS5UHGwC1DnYQKwNFk1ORt
         RSUi4N1QDjKMel95SzSyfa/edhaL8GM8oPIg6Ki/ioRkBWdXJ7ne0Wz/2Qm1X1lrIbAG
         Ff5WlLYlZev1A7BPjW/wgeoqcRGFLI0dr+Q4uwdW6u/OEH5x5Cz4zn+ATHeSx4L75e1Y
         eiaw==
X-Gm-Message-State: APjAAAXGHInrUS1/c0br2o5BqD6vra0n9eO5qjltxfJoTW5DtBkhN3fr
        wm0uSy6ObLFdwst8gop9f5n3ew==
X-Google-Smtp-Source: APXvYqyI2Y9GNz0QRXWI7LM5TWGU1WZZ/vMdotBXkAhD5XUx+PL17hmX0ESuRo028a7gbddCTEufJA==
X-Received: by 2002:a65:6401:: with SMTP id a1mr2484325pgv.42.1566539525851;
        Thu, 22 Aug 2019 22:52:05 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b6sm993048pgq.26.2019.08.22.22.52.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 22:52:05 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     jonathan.lemon@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net-next] bnxt_en: Fix allocation of zero statistics block size regression.
Date:   Fri, 23 Aug 2019 01:51:41 -0400
Message-Id: <1566539501-5884-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent commit added logic to determine the appropriate statistics block
size to allocate and the size is stored in bp->hw_ring_stats_size.  But
if the firmware spec is older than 1.6.0, it is 0 and not initialized.
This causes the allocation to fail with size 0 and bnxt_open() to
abort.  Fix it by always initializing bp->hw_ring_stats_size to the
legacy default size value.

Fixes: 4e7485066373 ("bnxt_en: Allocate the larger per-ring statistics block for 57500 chips.")
Reported-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4c790ff..b9ad43d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4985,6 +4985,7 @@ static int bnxt_hwrm_vnic_qcaps(struct bnxt *bp)
 	struct hwrm_vnic_qcaps_input req = {0};
 	int rc;
 
+	bp->hw_ring_stats_size = sizeof(struct ctx_hw_stats);
 	if (bp->hwrm_spec_code < 0x10600)
 		return 0;
 
@@ -5004,8 +5005,6 @@ static int bnxt_hwrm_vnic_qcaps(struct bnxt *bp)
 		if (bp->max_tpa_v2)
 			bp->hw_ring_stats_size =
 				sizeof(struct ctx_hw_stats_ext);
-		else
-			bp->hw_ring_stats_size = sizeof(struct ctx_hw_stats);
 	}
 	mutex_unlock(&bp->hwrm_cmd_lock);
 	return rc;
-- 
2.5.1

