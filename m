Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58F1912F78C
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 12:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgACLlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 06:41:20 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41390 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbgACLki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 06:40:38 -0500
Received: by mail-wr1-f65.google.com with SMTP id c9so42159286wrw.8
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 03:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+fgbAqPoDOSDZQhAKOgst/HgNdUzTblKClrStgO/kbo=;
        b=str/bHUqtlrRJfwypK7hxG/sLF+Beu4plI88q4NA53w5HK7ZqTNMolS5vA7zj/YZ5D
         ygApksINQg7NEowi6pwN+rJZzdX1W5rA7Xh7vM+vvG0PL1DijFgbfLBl6gytD6yR80Ik
         lUg66mBITdheRJB0N3SvcLpEqSQqrjGZ3Bn9DOIC8/qmUArMbwX/601LPuYbUCkkWMrI
         aNyrBQ1UaOGnLsyEF4JltCRPCF1UBc2zU4IKg1+DvbQBU7hZedkKSpsXeabCkEmB8Aqz
         VMAfuekbfeYWQ32w4htwNF+WAZPrUQs+C2bBE1nphDnDje2/R+2B1MhoaH1bRbfnpYrT
         B80Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+fgbAqPoDOSDZQhAKOgst/HgNdUzTblKClrStgO/kbo=;
        b=qBSMjZzXE61CAQj5MsIdQir17t9mypwVsOZDpzzzGUyCmd2BzNdWwGz++KABz3sykv
         02lZDzn9QlNw1LUxdUS2Ay1vCIWZ6wDGXB2+9YM4z0Ik9m9WK0M7hvmZc7qdX+zyCZuC
         XHa5xXqWp7iQ0dSFMZJj/Wz2iZBMNc0/9AOUZqWhlE60sUdRXrl0UG0P3oxcBejFq05W
         QLhPtmSfv2Chi667cYvExYfT1f7bhNE+MORePlyCzKamYaTTCCcbIhO2fmm4etppmcgQ
         Z3uxz7jlth4SOV5Cj2Kg0N3cyZ77TEMitKkZOvPXL8DCe2SFmj3eNpewUSA+IPzCtoYr
         bSow==
X-Gm-Message-State: APjAAAUwAyzZraEuNZvw4v+o6JhLmV/WKlARa05wSSB59nTYi0gfxeuL
        KdB8rT6XReqiyw/nZZ/CUmGr49qwoMU=
X-Google-Smtp-Source: APXvYqzzHcjOZ1soMvXobq5LirmU2ZcrAW/Um3ciADO79Tcn1tCG7fzSXTMsijGInZ9oDfFitCIcGg==
X-Received: by 2002:adf:ca07:: with SMTP id o7mr90215195wrh.49.1578051637260;
        Fri, 03 Jan 2020 03:40:37 -0800 (PST)
Received: from apalos.home ([2a02:587:460c:faab:2e56:dcff:fe9a:8f06])
        by smtp.gmail.com with ESMTPSA id d8sm58822719wrx.71.2020.01.03.03.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 03:40:36 -0800 (PST)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        davem@davemloft.net, brouer@redhat.com, lorenzo@kernel.org
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH] net: netsec: Change page pool nid to NUMA_NO_NODE
Date:   Fri,  3 Jan 2020 13:40:32 +0200
Message-Id: <20200103114032.46444-1-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.25.0.rc0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current driver only exists on a non NUMA aware machine.
With 44768decb7c0 ("page_pool: handle page recycle for NUMA_NO_NODE condition")
applied we can safely change that to NUMA_NO_NODE and accommodate future
NUMA aware hardware using netsec network interface

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 drivers/net/ethernet/socionext/netsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 869a498e3b5e..b5a9e947a4a8 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1279,7 +1279,7 @@ static int netsec_setup_rx_dring(struct netsec_priv *priv)
 	/* internal DMA mapping in page_pool */
 	pp_params.flags = PP_FLAG_DMA_MAP;
 	pp_params.pool_size = DESC_NUM;
-	pp_params.nid = cpu_to_node(0);
+	pp_params.nid = NUMA_NO_NODE;
 	pp_params.dev = priv->dev;
 	pp_params.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
 
-- 
2.25.0.rc0

