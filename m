Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 802E514039D
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 06:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgAQFdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 00:33:17 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34361 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbgAQFdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 00:33:15 -0500
Received: by mail-pg1-f193.google.com with SMTP id r11so11104984pgf.1
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 21:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dztjCgKaLVd3ZFqCqTWGTZPSOVPXHERT3e1FfMGjhXo=;
        b=SHfIECIBiWO/c3VCSRecasRryTxT3uRQ6sweF0TnOP5AWW0XjD0Ggk9910v37h4ZQf
         8UH9/YY98L/SXWggmBg3p1XnzPGVd83eHnrIxBJPrS6JuD3RtY8+1EeHKedjjNAyYekE
         KSU86yH5zbnybTfpsREthtwPOhULTKyMV54oA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dztjCgKaLVd3ZFqCqTWGTZPSOVPXHERT3e1FfMGjhXo=;
        b=kzn2TCVBiwng9rxtnamhXfJVbt5KYBMkKI7Mjo4wtKpjV/nZOdNFd2fWsroaXS/qRO
         x4Vzh7dXLmwTbwk99X+uFuLHu2fT0YtcdU55bn65ghgGGK7I/X3Y5ukPLDICoZ9jzEZI
         xVyFQV2u5Z+w6JS+UBCSarctEhQCV3BIUoCm0YvjSeaQToRWustx92Qytlfw+R/CJewd
         MWxm+62K2uT3BuMenom4IxfXPubcTNCTYTQ7pkYjrDtpwpDeM1mVIS+6m8RnYIlXm9LW
         m0JdTi0Qs04+juqBypJfN9nP9Yket2jrE749PgphVAFW8AsJCH5NaIaiqmsvfdfzxNoV
         oHfg==
X-Gm-Message-State: APjAAAVmch7BMEcr8/U4pDryE9DI7U40rGOLluYmcfSrUBVxAVaNYIz3
        RO/38NZDTGtsym1OU3bFxV88ViiLNY0=
X-Google-Smtp-Source: APXvYqzh0xEM54z7tRvlzr3RYErhqFeysMpMjUVR4kwfIX/JUr0X5HossE5vXfm9sb5kRxZgcwv4Qg==
X-Received: by 2002:a63:1b49:: with SMTP id b9mr43035897pgm.258.1579239195110;
        Thu, 16 Jan 2020 21:33:15 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c188sm1357142pga.83.2020.01.16.21.33.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jan 2020 21:33:14 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 3/3] bnxt_en: Do not treat DSN (Digital Serial Number) read failure as fatal.
Date:   Fri, 17 Jan 2020 00:32:47 -0500
Message-Id: <1579239167-16362-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1579239167-16362-1-git-send-email-michael.chan@broadcom.com>
References: <1579239167-16362-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSN read can fail, for example on a kdump kernel without PCIe extended
config space support.  If DSN read fails, don't set the
BNXT_FLAG_DSN_VALID flag and continue loading.  Check the flag
to see if the stored DSN is valid before using it.  Only VF reps
creation should fail without valid DSN.

Fixes: 03213a996531 ("bnxt: move bp->switch_id initialization to PF probe")
Reported-by: Marc Smith <msmith626@gmail.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 7 +++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     | 1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c | 3 +++
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b441da5..e6f18f6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11373,7 +11373,7 @@ int bnxt_get_port_parent_id(struct net_device *dev,
 		return -EOPNOTSUPP;
 
 	/* The PF and it's VF-reps only support the switchdev framework */
-	if (!BNXT_PF(bp))
+	if (!BNXT_PF(bp) || !(bp->flags & BNXT_FLAG_DSN_VALID))
 		return -EOPNOTSUPP;
 
 	ppid->id_len = sizeof(bp->switch_id);
@@ -11746,6 +11746,7 @@ static int bnxt_pcie_dsn_get(struct bnxt *bp, u8 dsn[])
 	put_unaligned_le32(dw, &dsn[0]);
 	pci_read_config_dword(pdev, pos + 4, &dw);
 	put_unaligned_le32(dw, &dsn[4]);
+	bp->flags |= BNXT_FLAG_DSN_VALID;
 	return 0;
 }
 
@@ -11857,9 +11858,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	if (BNXT_PF(bp)) {
 		/* Read the adapter's DSN to use as the eswitch switch_id */
-		rc = bnxt_pcie_dsn_get(bp, bp->switch_id);
-		if (rc)
-			goto init_err_pci_clean;
+		bnxt_pcie_dsn_get(bp, bp->switch_id);
 	}
 
 	/* MTU range: 60 - FW defined max */
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 85af7cf..f143354 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1532,6 +1532,7 @@ struct bnxt {
 	#define BNXT_FLAG_NO_AGG_RINGS	0x20000
 	#define BNXT_FLAG_RX_PAGE_MODE	0x40000
 	#define BNXT_FLAG_MULTI_HOST	0x100000
+	#define BNXT_FLAG_DSN_VALID	0x200000
 	#define BNXT_FLAG_DOUBLE_DB	0x400000
 	#define BNXT_FLAG_CHIP_NITRO_A0	0x1000000
 	#define BNXT_FLAG_DIM		0x2000000
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index f9bf7d7..b010b34 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -398,6 +398,9 @@ static int bnxt_vf_reps_create(struct bnxt *bp)
 	struct net_device *dev;
 	int rc, i;
 
+	if (!(bp->flags & BNXT_FLAG_DSN_VALID))
+		return -ENODEV;
+
 	bp->vf_reps = kcalloc(num_vfs, sizeof(vf_rep), GFP_KERNEL);
 	if (!bp->vf_reps)
 		return -ENOMEM;
-- 
2.5.1

