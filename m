Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D99F6DE3C6
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 07:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfJUFfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 01:35:04 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44750 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbfJUFfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 01:35:03 -0400
Received: by mail-pf1-f196.google.com with SMTP id q21so7654402pfn.11
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 22:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tyTx5ASrQbVkpxL5lixVt96YjY8QIb3Fyr9ZrmLA4ho=;
        b=fSQUPtc4PcmFIJJ5iVWVet4Lz+dA/OSpPvEsquKDNClBQDyyVLpRx5iUl1joFVAEC7
         1imKPOqsBUAxQ44z2MewCH8WjfSq7nW4eTz0qczusyvQt5+lmRJh6CWV/y08J+kuLtU5
         3C+p8WjP/8Y3YxCouwDWo/1nfQaOpTxgXMibQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tyTx5ASrQbVkpxL5lixVt96YjY8QIb3Fyr9ZrmLA4ho=;
        b=UIbIqdYA3Zm/zFO42ng5CcFRtCTJyi63/5REEyZM/gcPFRHpPz3vsOdDrlLcWmjxYq
         3zOSme1hXfJvQDgQoEmH4MfNFJqBFfBTRXF58bWn91supqiW9zga7//M3gQhreluotia
         emIKwJ/2B6V8d9mHJZuwAmTO5ZEM3SVsYmVjzQoknI7WHwVFq/kSwWBCf7uq4dU3VQzK
         E+Rihujshn/V+Xgl62xLkV0fO0KToCp51YWEdP0rT9N3a3cuTbC45W4pZ9GamBBnKRA/
         /OhdW1F63Nu/zzg8qZ8V0wyAXWebyJ0OGn0+2+98NifA67w/9zKFPjUATdTyPZE7d+xC
         faZA==
X-Gm-Message-State: APjAAAW1KstkA0pJ/iWJk0ygv3qKjISJ+a8xsOkwBQzYldLguhH+qNF4
        30BCOwrhXm6pgxyBdUn+RoE6KosWlHA=
X-Google-Smtp-Source: APXvYqxvqDCPM62+8B63EDNOG/hIc+mD0VXvatd7BbffvGQTZriTAamqs4xKWkAIhlEXTmilw2oO5Q==
X-Received: by 2002:a17:90b:153:: with SMTP id em19mr26431299pjb.22.1571636102709;
        Sun, 20 Oct 2019 22:35:02 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w2sm14713255pfn.57.2019.10.20.22.35.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Oct 2019 22:35:02 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com
Subject: [PATCH net 5/5] bnxt_en: Avoid disabling pci device in bnxt_remove_one() for already disabled device.
Date:   Mon, 21 Oct 2019 01:34:29 -0400
Message-Id: <1571636069-14179-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571636069-14179-1-git-send-email-michael.chan@broadcom.com>
References: <1571636069-14179-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

With the recently added error recovery logic, the device may already
be disabled if the firmware recovery is unsuccessful.  In
bnxt_remove_one(), check that the device is still enabled first
before calling pci_disable_device().

Fixes: 3bc7d4a352ef ("bnxt_en: Add BNXT_STATE_IN_FW_RESET state.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 8492618..04ec909 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10382,7 +10382,8 @@ static void bnxt_cleanup_pci(struct bnxt *bp)
 {
 	bnxt_unmap_bars(bp, bp->pdev);
 	pci_release_regions(bp->pdev);
-	pci_disable_device(bp->pdev);
+	if (pci_is_enabled(bp->pdev))
+		pci_disable_device(bp->pdev);
 }
 
 static void bnxt_init_dflt_coal(struct bnxt *bp)
-- 
2.5.1

