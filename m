Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66157234528
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 14:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733022AbgGaMCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 08:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732699AbgGaMCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 08:02:22 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652AAC061574;
        Fri, 31 Jul 2020 05:02:22 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id qc22so16378770ejb.4;
        Fri, 31 Jul 2020 05:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0s8kQrogwdlSPLZApHKOPIg76Pp1CNTA9YznKKgGPck=;
        b=M6Y0jv5kDqUnaX/yd/T2xgMQt71taFc83qH0hNkDJSCO82eBpAd0hnmaZzXzH8JwwR
         QxnHOUFXM4WOTonZWpymDce5CueUtu5cPdmXzfF3QkrFwjTonyaSBB6/OFutNKWXXJl7
         1jUDYkKMxsmMDhL2Zw4OcJ1xStjLUKRpOJXm5Y9RjchXLuWxHlaZ4NjkFERXie4cqi+O
         OqAUwBdHmMok6y4FmBJihc5eH+MTABnbOjG2wVrZs5mQO/rZvl7GoIwILp5r9rZkXKaj
         I1ZZYBXCyxy0zsS5imx/7/w6t7tKz/PDc+l5Py3ZaKD6QtvvAyfi+GgIxAJ99ngBWThA
         2OYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0s8kQrogwdlSPLZApHKOPIg76Pp1CNTA9YznKKgGPck=;
        b=V7QYWryoK4+e4eZVv1xqAbRKBVzC3neKD4xzKAi7IWfFtWvTIw4riOgMzPQ/XABLDb
         Q44QNADShZSWV+d8eu/fS45awaQ8Zr+VLpIDFOiWb0auyWkfy3s6wVGbhM36vREVYQ/8
         fNibDIYcTuKsme6vHrK8KXPxsv1t1R7oP6Hut59jdpoaTSHSNTPFmDkV+sfRC0ZhirUK
         wHdEUJgqIdO28U+NoPEbEkX5htcWNWV2SYpurXP61hTuSt28cPsk9TguUzJtvjpJAV10
         PkEilVeEjs3JnSNTqDr4hyvbvIt8UgQY+NFqeDmLg6ZZL2h1QTSRckqqKT5zKoT4E/xw
         6sBA==
X-Gm-Message-State: AOAM532+tpeYjNk4BAVYrgthFq+aZXZ+S75AVLcN925cAwPwUS8f0Dwi
        hCeIIRqmNDgMR4zCfpeI685Vtgz8yBowbw==
X-Google-Smtp-Source: ABdhPJz45zbOZzboFeAodzV6Jdd70KawW/kH4Nt1N7OyBQuz8phrmzy5Ee9QL5qqaAtYtkYbQgzHiA==
X-Received: by 2002:a17:906:1c0e:: with SMTP id k14mr3597814ejg.479.1596196941171;
        Fri, 31 Jul 2020 05:02:21 -0700 (PDT)
Received: from net.saheed (95C84E0A.dsl.pool.telekom.hu. [149.200.78.10])
        by smtp.gmail.com with ESMTPSA id j5sm9091734ejk.87.2020.07.31.05.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 05:02:20 -0700 (PDT)
From:   "Saheed O. Bolarinwa" <refactormyself@gmail.com>
To:     helgaas@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "Saheed O. Bolarinwa" <refactormyself@gmail.com>,
        bjorn@helgaas.com, skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v4 03/12] ath9k: Check if pcie_capability_read_*() reads ~0
Date:   Fri, 31 Jul 2020 13:02:31 +0200
Message-Id: <20200731110240.98326-4-refactormyself@gmail.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200731110240.98326-1-refactormyself@gmail.com>
References: <20200731110240.98326-1-refactormyself@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On failure pcie_capability_read_dword() sets it's last parameter, val
to 0. However, with Patch 12/12, it is possible that val is set to ~0
on failure. This would introduce a bug because (x & x) == (~0 & x).

Since ~0 is an invalid value here,

Add an extra check for ~0 to the if condition to ensure success.

Suggested-by: Bjorn Helgaas <bjorn@helgaas.com>
Signed-off-by: Saheed O. Bolarinwa <refactormyself@gmail.com>
---
 drivers/net/wireless/ath/ath9k/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index f3461b193c7a..f02b243befef 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -867,7 +867,8 @@ static void ath_pci_aspm_init(struct ath_common *common)
 		pci_read_config_dword(pdev, 0x70c, &ah->config.aspm_l1_fix);
 
 	pcie_capability_read_word(parent, PCI_EXP_LNKCTL, &aspm);
-	if (aspm & (PCI_EXP_LNKCTL_ASPM_L0S | PCI_EXP_LNKCTL_ASPM_L1)) {
+	if ((aspm != (u16)~0) &&
+	    (aspm & (PCI_EXP_LNKCTL_ASPM_L0S | PCI_EXP_LNKCTL_ASPM_L1))) {
 		ah->aspm_enabled = true;
 		/* Initialize PCIe PM and SERDES registers. */
 		ath9k_hw_configpcipowersave(ah, false);
-- 
2.18.4

