Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5B4C5892D
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbfF0Rqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:46:32 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45345 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfF0Rqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:46:32 -0400
Received: by mail-pg1-f194.google.com with SMTP id z19so1335751pgl.12;
        Thu, 27 Jun 2019 10:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dVK/1jelVWuWKY847Kjv4BLwFO5EKIu+zyNuXBFo2IU=;
        b=lza6mnLJF6y/bnBWCnpxzby0hMCcbwyNecgphKuLEAetBOmwciNgFFBjcguynyXSpg
         9avAMfDZQbHdGsrPfKYzfMzpZDrH5/mZ3xR2ti2n2ZlKlPC2HUINUIib05VJF+1nSkbb
         5aicmAb3mnWVwQGu53PKZZ1Z4iU0spw7tcWuU77hVHCKaWoQEGODBsXSHVnpDCm8lTpc
         7V1Cp8gAO9V5w2jc/LKtYUFcHDJhlDQT0RfSql4jjyA0gcYsYNyE9yAHb6mpRd1sdi2y
         WRegHgnnY5TfcypBmtIt7ujIK6vIEfqNMcPRrLXgdJtlbFj39vyjS4Ptoo6KuTc7iQ5t
         daow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dVK/1jelVWuWKY847Kjv4BLwFO5EKIu+zyNuXBFo2IU=;
        b=E5bIT2x4yLQMUJgyEqPLQxTyxBPGgyor9JhjW0JW5C210E3fF7PuphajpOXNW41rxi
         dB3qjjuXRUSzavnUnEJ5EEPMA0z7aUDIuPTZShUz1WC3fwXCgSRM7BFCavcji3jnLLdK
         gcZ0qmgaQmIA6PpNmBvDXFf8icTjDrgj0mXYfBjmDXsr+y7C94XCLNU64eN8dZrKicaV
         CMNq2nJG9+yY2b07gUDpq9XtRLkgxs8Xr1TABm9bWPiV0dONlSJqToehChFieFak+RP/
         6UFLN/nGm5CsPgrWqsMY+Da1XrQ0YEQNF0J7KOO9gZ0kynVnJ9jKU1VykpeE/z1EwCKd
         6qfA==
X-Gm-Message-State: APjAAAV4R7w4WPvQif3G9HTROI9nCQBhAnMNGQ/QWiJ+lTDajThQXnqU
        NWfvuqn7n38BEMTlKA+qA0nEhNBmEMCYLw==
X-Google-Smtp-Source: APXvYqyYw4GJaENpqwyJhxTH3VZZab70A8HPkwSuASaLHiUuZgrb+kuirwvJAdxZ4JuofRxu3kfXqQ==
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr7246665pjb.138.1561657591451;
        Thu, 27 Jun 2019 10:46:31 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id z13sm7780343pjn.32.2019.06.27.10.46.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:46:31 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 76/87] wireless: quantenna: pcie: remove memset after dmam_alloc_coherent
Date:   Fri, 28 Jun 2019 01:46:03 +0800
Message-Id: <20190627174620.6307-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dmam_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c | 2 --
 drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index 3aa3714d4dfd..5ec1c9bc1612 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -244,8 +244,6 @@ static int pearl_alloc_bd_table(struct qtnf_pcie_pearl_state *ps)
 
 	/* tx bd */
 
-	memset(vaddr, 0, len);
-
 	ps->bd_table_vaddr = vaddr;
 	ps->bd_table_paddr = paddr;
 	ps->bd_table_len = len;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
index 9a4380ed7f1b..1f91088e3dff 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
@@ -199,8 +199,6 @@ static int topaz_alloc_bd_table(struct qtnf_pcie_topaz_state *ts,
 	if (!vaddr)
 		return -ENOMEM;
 
-	memset(vaddr, 0, len);
-
 	/* tx bd */
 
 	ts->tx_bd_vbase = vaddr;
-- 
2.11.0

