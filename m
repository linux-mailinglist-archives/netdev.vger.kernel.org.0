Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C27625266F
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 07:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgHZFJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 01:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbgHZFJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 01:09:10 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B770C0613ED
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 22:09:09 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id y3so429760wrl.4
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 22:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zyskxP5YsesP+ANazA+/LzTkYPTZv7tA3Q9JqA2vbOM=;
        b=MdTpdcApyaNCO2ZM3C7OevE7YQDP8CFqJjpk58a5C4c7scScj3Nqfe0Yf81TkT49Bu
         CLCA4yGQOPqfmSfxjf8uQUs3LUqbB4ArCi61EBbuEywheBKMeI5lVqAveweoBQxVR8Rj
         nqYn+mkR1cnVTY1GFOMTx+WQq5XZYBeSBnC6w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zyskxP5YsesP+ANazA+/LzTkYPTZv7tA3Q9JqA2vbOM=;
        b=GwOiF4kQHzw8mgbODz304EiFQBvqIGCkRSdVcu9e2ZHypqtzBIR7JR6F1lsf/GakuX
         /EFXhrxaHQ9jtP/LTvkvL7ZBtfPMUb3serWQOMNZC6Rii/VZyIpuIKMZJMYAAPS1WDMJ
         +5fI0d/lcNCHEEBR6kdZxek+Naj3wnlLfExk19vFNtILJnSkKcEGE5HJ2N49x2rkoq9q
         IrGHbQsJNWxQd2qmVrsI14xLHv7ngqXmLJQ+NQAfWPL02nETZioBCCwBH45OzP9geeRR
         FDCZGQX0pHdLE76mwSYyMmEtC5fdxzPADLAY2XioKYXMEpjWepVoH2nCKRMxkY/VyY5W
         iCEA==
X-Gm-Message-State: AOAM532DeZ31LIhy9iyOvX+8KnSKUe8BuCA3f0ri7LvicXoP/UX85VO/
        eLipMbIaUwSn0m/BLR8L2puMhw==
X-Google-Smtp-Source: ABdhPJx207PXOWR6O09oxgSqber22pyNSVaJVpCN0C6jKabGlnpTWASIbyLGBYg4Ilb5G9L2Wpz93A==
X-Received: by 2002:adf:fac7:: with SMTP id a7mr845546wrs.240.1598418548004;
        Tue, 25 Aug 2020 22:09:08 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q12sm2825832wrm.39.2020.08.25.22.09.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2020 22:09:07 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net 4/8] bnxt_en: Fix PCI AER error recovery flow
Date:   Wed, 26 Aug 2020 01:08:35 -0400
Message-Id: <1598418519-20168-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1598418519-20168-1-git-send-email-michael.chan@broadcom.com>
References: <1598418519-20168-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

When a PCI error is detected the PCI state could be corrupt, save
the PCI state after initialization and restore it after the slot
reset.

Fixes: 6316ea6db93d ("bnxt_en: Enable AER support.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 31fb5a2..4389a74 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12339,6 +12339,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		    (long)pci_resource_start(pdev, 0), dev->dev_addr);
 	pcie_print_link_status(pdev);
 
+	pci_save_state(pdev);
 	return 0;
 
 init_err_cleanup:
@@ -12536,6 +12537,8 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 			"Cannot re-enable PCI device after reset.\n");
 	} else {
 		pci_set_master(pdev);
+		pci_restore_state(pdev);
+		pci_save_state(pdev);
 
 		err = bnxt_hwrm_func_reset(bp);
 		if (!err) {
-- 
1.8.3.1

