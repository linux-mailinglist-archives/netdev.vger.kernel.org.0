Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D5E319378
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 20:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhBKTx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 14:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhBKTxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 14:53:08 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191A7C0617A7
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 11:51:30 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id y9so11835429ejp.10
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 11:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y5c8p9mzO/BCi2yifPl+6urBzjNWDIYjFaXnBET7i9E=;
        b=WxZGD8t0bVg28dD2Dw6nfRe3n4kSQmP0DMLuzE0Oy0Ju5SUTStuflmQGymu+0tKUDO
         rnqaU0asvmDjkrcbU2TOHMJYTy33Um+lOHX8RlJS+e+s1eXo0nRIm/AmN1R2DXN+U9L4
         etUlAZSBXwvyvIxU0QCW9QEeapOiRsuQcmpYGXAAREwMnpA0Z5nRXbPJtqjaKbsZfkJn
         lIWbPLA88VsEk1qRFUsbZRdZD6J9SP6YNgngWj0J5/vuBZmt4W2yurDx+M4EFgt2KXay
         Lxqon4fPVvUEm4XXrLCJHhlsGjiRcFco4KzLJWmKMrZAsKx0yD8hbSAd7GMZUpf6vVvJ
         Kqiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y5c8p9mzO/BCi2yifPl+6urBzjNWDIYjFaXnBET7i9E=;
        b=qLwgTweL/UMOEBvzBxEz9SqpR48LUngxP0Rr4sMTCORZMnnAgASLyLlh8jv4CgOMvq
         85q3XvDn9z+pEuyPAkrqhOAhEaawTVh1xjLgII6s3hRvkhCU0kMe+tfm3Vst7I8TdWAK
         l8RLwMIatvoe8OR73w8cl+c31nGjNkb8U/wAYH/PLOaLrhLDx7txy/nN90oJGQVP8Zi+
         /sqgSGf5btXlmgWVzTxjo2P4LNwj4xXg5FwrFvq6aSgcDFLoEg36AezoH6SJ4DVNVGhq
         BuYHz0trdeTU9n/X2jfjtgIXo1qp2A3kME1sXxVop6NpjkDKra/sqvmXwnqZRT44ZXni
         KwhQ==
X-Gm-Message-State: AOAM531YXoC48lZMjakRDlCb6+qa852xzDDIIishicEeiUkRmA0rvW4L
        wFMwGk5QjnUY46k3vmCmixI=
X-Google-Smtp-Source: ABdhPJyHF34PNu3qPzUWRJzHrbUgBkq6C45gQtfT8U1P32LogltgIAPmgG5xbo0EEgJgPUmcL9jQZQ==
X-Received: by 2002:a17:906:1c17:: with SMTP id k23mr9874587ejg.121.1613073088756;
        Thu, 11 Feb 2021 11:51:28 -0800 (PST)
Received: from yoga-910.localhost (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id a25sm4887877edt.16.2021.02.11.11.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 11:51:28 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net] dpaa2-eth: fix memory leak in XDP_REDIRECT
Date:   Thu, 11 Feb 2021 21:51:22 +0200
Message-Id: <20210211195122.213065-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

If xdp_do_redirect() fails, the calling driver should handle recycling
or freeing of the page associated with the frame. The dpaa2-eth driver
didn't do either of them and just incremented a counter.
Fix this by trying to DMA map back the page and recycle it or, if the
mapping fails, just free it.

Fixes: d678be1dc1ec ("dpaa2-eth: add XDP_REDIRECT support")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index fb0bcd18ec0c..f1c2b3c7f7e9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -399,10 +399,20 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
 		xdp.frame_sz = DPAA2_ETH_RX_BUF_RAW_SIZE;
 
 		err = xdp_do_redirect(priv->net_dev, &xdp, xdp_prog);
-		if (unlikely(err))
+		if (unlikely(err)) {
+			addr = dma_map_page(priv->net_dev->dev.parent,
+					    virt_to_page(vaddr), 0,
+					    priv->rx_buf_size, DMA_BIDIRECTIONAL);
+			if (unlikely(dma_mapping_error(priv->net_dev->dev.parent, addr))) {
+				free_pages((unsigned long)vaddr, 0);
+			} else {
+				ch->buf_count++;
+				dpaa2_eth_xdp_release_buf(priv, ch, addr);
+			}
 			ch->stats.xdp_drop++;
-		else
+		} else {
 			ch->stats.xdp_redirect++;
+		}
 		break;
 	}
 
-- 
2.30.0

