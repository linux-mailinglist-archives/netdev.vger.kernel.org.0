Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA2C2708F4
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 00:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgIRWa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 18:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbgIRWa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 18:30:27 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284F9C0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 15:30:27 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id q8so7739866lfb.6
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 15:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OtQ4/QyF5GVKw9xFYnNkfpVIkRvRjeUHuugNd+TuDrs=;
        b=Xg91GUvsrdobfQC19NIE3ldvNy6Za21jm9Nn9NO5gNWSwPyjzv2Z/9KhJOSb3X5nUs
         0miyj3Jxla1JqtfyFAalTcQK+cWXmThDOSk6hDyui1oqZlO+o+hUghJcJ6WmmFj4OxcA
         PmYeHOETELMzga94UIJiW/i3uqTT1ftrMb98WD5jKMo4dj81iUtzp2Pm+DigArWAwM8i
         kK9VfIuEGqONzFVGXiZpsOAL7dhGVKX43ArwAzHHSAr6BZB9o/D0+UrvVVAt3FIucKcL
         V6RuB4UgNXenbSr5ifibzkEjeiPRU/B0xl2qcKcDu76U6ZtvihBrg9TVhxe4YxpCzyRH
         B7Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OtQ4/QyF5GVKw9xFYnNkfpVIkRvRjeUHuugNd+TuDrs=;
        b=aqTt6XrwptE+ZGKvA2D3qhEz3H4Xk9kXz1SfJCXaC9MdY78UdOmcWCxdsvfzKCF8/4
         0k4qLh1ZF5GyUj4jcjzRBCAFir9mfqSTZ4dVanktFr1UxBTn/MiEBPPj5UJhGmEwDxQD
         okVeHFnTe+tH0bk9JCPgTBKfOH2vca7f16VsYiH0Rsfbvf9Kzhcwb1d/GUlNFUm4+V4/
         XMqSEmEtAqgVl0HAlOPd6ro6xCXxd911fgQ1ShogZ/niDDa/9hcXGhSzXpaODMpq0O05
         drvtJDW9N3tdgQVHbkWgaPkJIhIVDVB/StQkDkHDzLPrZdtX+zFOUSakeUdDtHABz/Ij
         Oa4w==
X-Gm-Message-State: AOAM530SoDt+ecTNyXi3hmaF2NCnk9GWvS40F72fvTAdo+a8roIQp0yP
        09+LUl6V29RJQRZQd2Wq1iEPeWqaxAnzVSik
X-Google-Smtp-Source: ABdhPJwlPqc96UyZ0kDBitTSEoo1TBprcz7xAUBNaHlfvWrpsi73G2xAYcmcoA1t7xOXHQlQyM7n7Q==
X-Received: by 2002:ac2:5398:: with SMTP id g24mr11154186lfh.7.1600468225373;
        Fri, 18 Sep 2020 15:30:25 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id b22sm847111lff.183.2020.09.18.15.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 15:30:24 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [net-next PATCH] net: dsa: rtl8366: Skip PVID setting if not requested
Date:   Sat, 19 Sep 2020 00:29:54 +0200
Message-Id: <20200918222954.210207-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We go to lengths to determine whether the PVID should be set
for this port or not, and then fail to take it into account.
Fix this oversight.

Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/dsa/rtl8366.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index bd3c947976ce..c58ca324a4b2 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -436,6 +436,9 @@ void rtl8366_vlan_add(struct dsa_switch *ds, int port,
 				"failed to set up VLAN %04x",
 				vid);
 
+		if (!pvid)
+			continue;
+
 		ret = rtl8366_set_pvid(smi, port, vid);
 		if (ret)
 			dev_err(smi->dev,
-- 
2.26.2

