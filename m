Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CE234079D
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbhCROQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbhCROQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:16:15 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE7FC061760
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:16:15 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id u10so4841207lff.1
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=ckpj5klz1A+5QoVk88jbrj3B/Q1ITN5QI5ibc65F/3Q=;
        b=Dr2ohKVrzk/q4TdAE5HHzBFKNrPaIyEK9VCEW1aW5/N2CXxsFIic2yb7nWDFQJoCIM
         mu8cfk0t9vIcP+IIWtI1mK9Y02feNZ3y9qbjHMlv+Bx1qD3NYxyqCjB9jDcZ0+8pgqZJ
         rFCLi4x80EhQEISNdTnnZluchS/SRFg8puNtwUqtXJ0P9yIUDI1pyFQdQjyvShxonPHK
         PFudz/WumV7w0v0cuNH5UiKbxHjLx2DAS6DhgF2d5/kFWisB3sjZgLHH0+WVAwYRM1MU
         5wGqrPLjoMnc32lIjmRQMxWjsfvIadENFtyEN1i5SkY5APEUAigSvGqRlXE12etKCQmz
         Mrdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=ckpj5klz1A+5QoVk88jbrj3B/Q1ITN5QI5ibc65F/3Q=;
        b=qXGzrfkWvHK4N3wAHqC5pJbofJBoC/Q/RPyqXd+/Y5GPohJMSEi/QO+hOCXb8wu15d
         zsX43nlhM5YQ7OPgjckm43Fw3xkS+J5XV5ZMsiNIkgvKZysZ06nlEixSc5BM107+bOyz
         a718MbxGcnlIZmDhotCOEIhyBuL9yFiC68k4kVIwcClnLYnIubWyvo4Uc7C8APJsI6GX
         rqJayiHbFqvyqIx6qwNQ32eIw4fL7fjtTl8uBcqqCY9Lh5l7e31yV4BWQXMDFmaHegfa
         RfkD9wInYMGHIo6XI8MiLLs67Ef8d1D3AQi63iugjbHUZJgqsq+foSIFAuCzbPfHlxYs
         dmiA==
X-Gm-Message-State: AOAM530Obq1MZYZ9f4ou6lGZtnHGdWHaAKrCwr8eYBXqa/EgpXV5htuz
        GCBmmfXnvM0UYr+mh5B2MHdvLg==
X-Google-Smtp-Source: ABdhPJxVIhPgP7fXlLTXJDpGu1OhIIRG3jE/Cut7RF2iPSHPBy17GC9PMVnK0o4YnV/5Y5K+7S+rHw==
X-Received: by 2002:a19:4850:: with SMTP id v77mr5706486lfa.6.1616076973734;
        Thu, 18 Mar 2021 07:16:13 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id w26sm237382lfr.186.2021.03.18.07.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 07:16:13 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 2/8] net: dsa: mv88e6xxx: Avoid useless attempts to fast-age LAGs
Date:   Thu, 18 Mar 2021 15:15:44 +0100
Message-Id: <20210318141550.646383-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318141550.646383-1-tobias@waldekranz.com>
References: <20210318141550.646383-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a port is a part of a LAG, the ATU will create dynamic entries
belonging to the LAG ID when learning is enabled. So trying to
fast-age those out using the constituent port will have no
effect. Unfortunately the hardware does not support move operations on
LAGs so there is no obvious way to transform the request to target the
LAG instead.

Instead we document this known limitation and at least avoid wasting
any time on it.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index f0a9423af85d..ed38b4431d74 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1479,6 +1479,13 @@ static void mv88e6xxx_port_fast_age(struct dsa_switch *ds, int port)
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
+	if (dsa_to_port(ds, port)->lag_dev)
+		/* Hardware is incapable of fast-aging a LAG through a
+		 * regular ATU move operation. Until we have something
+		 * more fancy in place this is a no-op.
+		 */
+		return;
+
 	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_g1_atu_remove(chip, 0, port, false);
 	mv88e6xxx_reg_unlock(chip);
-- 
2.25.1

