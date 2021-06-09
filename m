Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8485B3A1BB5
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 19:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhFIRZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 13:25:35 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:53129 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbhFIRZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 13:25:34 -0400
Received: by mail-wm1-f42.google.com with SMTP id f17so4522090wmf.2;
        Wed, 09 Jun 2021 10:23:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UHxpr2/3BM0v4QSliS/kvZrmMoG8MPeA0PSvAAg0/EY=;
        b=TFdaj5gNbb6fufhVD8TKnOgtHxfXMokHJycEaubVSfHm7ZzLxzVi2X0H7mfvrPZ2p3
         1Y7nG+dctGB67msZyqvuDbg7C6acjO96zeU0V5cRjLAkbbHi4m0w34mvjxx2TLl81/8B
         US2Z1yh9tC4owDYEtIhHdxcrbVNee4havtbvq+6szdjhAAhx5OGTzWvVDcz7VeQSe4c5
         ItevT5IA7/C0xvDhCwaQeDsnC8a/z1aCdN8oEh2ufTnjkaMQtI8JfL7Uf2lXoNP5eF1e
         ++xg7YREEJcjf9lGYxPygdjwxUPldv2w0t2ZBduwBvGuhjqtUDwgaSzO1f5saHqtrhGO
         nXWg==
X-Gm-Message-State: AOAM531c0u/Xvq6sh+uZOb/dAk5tbFAxssoXxg7myQB3sisHm0YyS7D0
        Mx64b0JZRNlKrE4z/oCe/tmqzCuMwIs=
X-Google-Smtp-Source: ABdhPJxafdci0ArPt4wYrQ5LFS61fet+iASno5NpGkN1oI5C0tG79RhILnqtIZ4NT/sLY7NXT56spw==
X-Received: by 2002:a7b:c935:: with SMTP id h21mr10859615wml.183.1623259402301;
        Wed, 09 Jun 2021 10:23:22 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-37-119-128-179.cust.vodafonedsl.it. [37.119.128.179])
        by smtp.gmail.com with ESMTPSA id r2sm615261wrv.39.2021.06.09.10.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 10:23:21 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>
Subject: [PATCH net-next] stmmac: prefetch right address
Date:   Wed,  9 Jun 2021 19:23:03 +0200
Message-Id: <20210609172303.49529-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

To support XDP, a headroom is prepended to the packet data.
Consider this offset when doing a prefetch.

Fixes: da5ec7f22a0f ("net: stmmac: refactor stmmac_init_rx_buffers for stmmac_reinit_rx_buffers")
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 0a266fa0af7e..30b411762a9c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5129,7 +5129,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 		/* Buffer is good. Go on. */
 
-		prefetch(page_address(buf->page));
+		prefetch(page_address(buf->page) + buf->page_offset);
 		if (buf->sec_page)
 			prefetch(page_address(buf->sec_page));
 
-- 
2.31.1

