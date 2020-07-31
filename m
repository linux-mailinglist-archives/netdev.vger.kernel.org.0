Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9035623451F
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 14:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733046AbgGaMC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 08:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733025AbgGaMCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 08:02:24 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E164DC061574;
        Fri, 31 Jul 2020 05:02:23 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id a21so31150585ejj.10;
        Fri, 31 Jul 2020 05:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eZK+H+8P4YZaGPvNdFZeiGG9Bo1EGoEt0s5F4CNNc80=;
        b=QlWaplXGbixFr2iaZsG5PJHSSOZbuNBUIasW8yuH1nsnVdp6YoYPMGxTOoB8aeGPjl
         cn2K3t/zLUCVvaaSnJcwSClDPI/NsQpHsPV9YLrXYaYwWeJ89I2ysukcyFp9knRUz/6A
         C1Yy8ztk7MbJ2O1f6n8/EwUzvpVmzYv3aVhmpXCFLy0CcrvflKiFRAQY1NvlEFKkwjEd
         7M3+18TKCiSUH8ezZEFQRUHHM1DaiD+BvM6ftfMrAemf6hGhWP+eoJ4DEqde40kq53fv
         Vt/tgbEvtv1lsYX5VyhQ7PDlh++wbx6fnuf5oW+s+Z+p1JAKPLwxByyotKgX808QntiK
         +X2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eZK+H+8P4YZaGPvNdFZeiGG9Bo1EGoEt0s5F4CNNc80=;
        b=ok/E+6G8UhDrhUdh76PdpYMPzQYa4VvtED4CF3Kryw1KxNpsqysKzc//Ad0wu1PErb
         3597mUZEGhg63RjOf3xkPHlesimdYIXBmFQVvAW6Qyn8yJu5YLtCPhraiGq6xg6px2yE
         A/Lkm52CPKcbkR3E8syuUaFcTHnj1QMM3web7pqcWj7ebJW22Qy5K1L4ru5qu9j0K263
         8ZU2yfOde9OS83USExyjVKsXEM5+MQ2WT5QaQNj3dSsyXYdxnkObsL0udJmFv/dpGQ+C
         dZSZ5vnY4s/bcGx5ccg8t0fODK9wfzfKTeKIQ+8qaeDeSU/DYBAbyJpHCW9CQyJN6t9o
         FEeQ==
X-Gm-Message-State: AOAM532J3Cs1HI80hWuWEAHG0AZIITGQ1H3pvunKRPhwtJ4/n0eMzT6H
        E4gQYGrZXgCOirX/8d0cXiI=
X-Google-Smtp-Source: ABdhPJzseAgg1rg1tVy8ApT5RrpMw/6kYsnooL/dOwqEDLtZ6RfM9YbjqXKCNWBVO0h/MP8NAaoBeQ==
X-Received: by 2002:a17:906:c1c3:: with SMTP id bw3mr3941716ejb.8.1596196942684;
        Fri, 31 Jul 2020 05:02:22 -0700 (PDT)
Received: from net.saheed (95C84E0A.dsl.pool.telekom.hu. [149.200.78.10])
        by smtp.gmail.com with ESMTPSA id j5sm9091734ejk.87.2020.07.31.05.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 05:02:22 -0700 (PDT)
From:   "Saheed O. Bolarinwa" <refactormyself@gmail.com>
To:     helgaas@kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "Saheed O. Bolarinwa" <refactormyself@gmail.com>,
        bjorn@helgaas.com, skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v4 04/12] iwlegacy: Check if pcie_capability_read_*() reads ~0
Date:   Fri, 31 Jul 2020 13:02:32 +0200
Message-Id: <20200731110240.98326-5-refactormyself@gmail.com>
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
 drivers/net/wireless/intel/iwlegacy/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 348c17ce72f5..659027563260 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -4287,7 +4287,7 @@ il_apm_init(struct il_priv *il)
 	 */
 	if (il->cfg->set_l0s) {
 		pcie_capability_read_word(il->pci_dev, PCI_EXP_LNKCTL, &lctl);
-		if (lctl & PCI_EXP_LNKCTL_ASPM_L1) {
+		if ((lctl != (u16)~0) && (lctl & PCI_EXP_LNKCTL_ASPM_L1)) {
 			/* L1-ASPM enabled; disable(!) L0S  */
 			il_set_bit(il, CSR_GIO_REG,
 				   CSR_GIO_REG_VAL_L0S_ENABLED);
-- 
2.18.4

