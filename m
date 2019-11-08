Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83260F4C5B
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 14:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731008AbfKHNC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 08:02:28 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38561 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730810AbfKHNCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 08:02:25 -0500
Received: by mail-lf1-f68.google.com with SMTP id q28so4421344lfa.5
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 05:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2QjvBFt/Ahp0rywmkIDhfkZ7dAuBAKpWua4zqIA54R0=;
        b=XVACoOOuXlxl4Cy3V/J8sGSeCCFw8ZKOKZ7FqB/K3JgCxUCJ1xCj/Mqawr8e2qIujx
         O7k1zBR8675/UVFNVWJud7B7gGy4eRxvGFDaQiIdBxLuh/UvxbGJ2jiZIbbPNPtq2kf0
         ZABUDJvpYchPCeIhdPhVBPmgejb6251Cuy5iE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2QjvBFt/Ahp0rywmkIDhfkZ7dAuBAKpWua4zqIA54R0=;
        b=m0Dks69zvfGlHMiCbpgqsqDEOIVXuJrEcawybEmYvTObMICv70k6y1sZQEa8Jll1ke
         AAMNjyzzUNi0RyijB8jFfGXBB8EyCnaLRAemkmTy+HTzmbEasbre3gLu7xv3iUWRJW5s
         l1pu1E58vdyW35VMeqdXQFgVvZUyyK+2D9VDsgrLLVPubu+GyH8Xg536pvIVjFpSUpRG
         9mkusUWvWIlg24k0/vQ7QfaXgC9VLxrSRgoKmzj6Mrr2EsBlE8OMcYUxg+xUV3fm1q9b
         sLrb5dz33Mwmf9eAH9Mc2OsQSooH79dE+PX0C+uWMXDN+OVpYdhrO536MQ+TKgm8lZ/G
         Midg==
X-Gm-Message-State: APjAAAXGKk85R8HB6HiGIVD82qbUdf/9LYQvqgHGsnzCEXdb33duV7Ln
        RaJYjEoseDo9UBJKKWEAXeMbHQ==
X-Google-Smtp-Source: APXvYqwScoFAHiImQMnrTZk87e9zBJh2EkwdHqWoi9bG9XRi4pfN3RXUv9ZB5CXwEIsQqOH7j53G/g==
X-Received: by 2002:a19:820e:: with SMTP id e14mr6605403lfd.29.1573218143917;
        Fri, 08 Nov 2019 05:02:23 -0800 (PST)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id d28sm2454725lfn.33.2019.11.08.05.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 05:02:23 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Qiang Zhao <qiang.zhao@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Scott Wood <oss@buserror.net>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        netdev@vger.kernel.org
Subject: [PATCH v4 45/47] net/wan/fsl_ucc_hdlc: reject muram offsets above 64K
Date:   Fri,  8 Nov 2019 14:01:21 +0100
Message-Id: <20191108130123.6839-46-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191108130123.6839-1-linux@rasmusvillemoes.dk>
References: <20191108130123.6839-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Qiang Zhao points out that these offsets get written to 16-bit
registers, and there are some QE platforms with more than 64K
muram. So it is possible that qe_muram_alloc() gives us an allocation
that can't actually be used by the hardware, so detect and reject
that.

Reported-by: Qiang Zhao <qiang.zhao@nxp.com>
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/net/wan/fsl_ucc_hdlc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
index 8d13586bb774..f029eaa7cfc0 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -245,6 +245,11 @@ static int uhdlc_init(struct ucc_hdlc_private *priv)
 		ret = -ENOMEM;
 		goto free_riptr;
 	}
+	if (riptr != (u16)riptr || tiptr != (u16)tiptr) {
+		dev_err(priv->dev, "MURAM allocation out of addressable range\n");
+		ret = -ENOMEM;
+		goto free_tiptr;
+	}
 
 	/* Set RIPTR, TIPTR */
 	iowrite16be(riptr, &priv->ucc_pram->riptr);
-- 
2.23.0

