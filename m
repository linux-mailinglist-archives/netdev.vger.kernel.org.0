Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5F52E7A0
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 23:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfE2VsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 17:48:04 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41462 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbfE2VsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 17:48:04 -0400
Received: by mail-lf1-f68.google.com with SMTP id 136so3316121lfa.8
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 14:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=yGZo23cWxl6g2KAaugpJu9muCFq+8s0tirfzRsyyzGc=;
        b=aMPGcFBgYYRTPnCpwiwXYCAOjA5tmBAEQubH0ej1OKPl9D/K4Iv5piicsC7n7uPHPk
         BOgpQCEQPa2iLxlhWnSMQoVSrIcT6LfZT8g0A/6n6kepICN+pizG12ldjZ/lSu2vLOh4
         sJloAO4vIkII4y6RrJqrzPqX16Yz874Z/gjZ5HdsI+wGw+1eDXGXXtv0792pSxxrIjt2
         tpHnvM18Uwsmwxfgh2yFXWI9gyrAjc1FpkP+V6ChRilOD86qHIO3Ls1bwbkcBMt5SsgN
         nf4SNmuFw73Kib5QHeSJsGvz2T4dK4yOnNbrXxFqP2I0SACxgvlOKdYpkEjApP8BuIO3
         Swbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yGZo23cWxl6g2KAaugpJu9muCFq+8s0tirfzRsyyzGc=;
        b=Q6kw9N+OUSLZG0cvZl9l+vRcqeUPvXYDrGRuEATZvVntFbHTpnokmSlzZvVVWFHbV6
         GnuzvlLWlqpjBWRVbNucGGJ+yJ0wXSKOhyz/HXoi6iiV7J7d9MrjhiJwvKM+QcMgSf7U
         zYbi/bk9kTnU8xtB7dpoaHjN29IrwNJ7H+Yengu067JLi7TQpTCePxLHh9hY6l708EzH
         7MZAK7RjKBaDyF9/dDIJVafZYuIEvNNSdZMursAgPLmIeEm0aeXiG6ws2SG6nQ+AW9dx
         n5wCKVTLOIFK/QhvOuepc+c991ZgplfVrrVzEgZhZeJUFlrHbzO4o3VoZ1s9yp/lEsed
         HnNQ==
X-Gm-Message-State: APjAAAVJ3kD5fMdEzVXOwaZxWb94h9+Ocwux2i6bJ1ClHIH41pMtPCXs
        15sW4wMI0JdMICydLiIh2EXz3g==
X-Google-Smtp-Source: APXvYqx1vuKE081CnhdNF6P+EfJ0Z1kQ9QcafIyaY+mcEKNOf4kj1tT15NdOOUlKeaEnHROoxsZh1A==
X-Received: by 2002:a19:ca02:: with SMTP id a2mr104072lfg.88.1559166482478;
        Wed, 29 May 2019 14:48:02 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id b29sm134846lfo.38.2019.05.29.14.48.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 14:48:01 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     grygorii.strashko@ti.com, davem@davemloft.net
Cc:     linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH] net: ethernet: ti: cpsw_ethtool: fix ethtool ring param set
Date:   Thu, 30 May 2019 00:47:53 +0300
Message-Id: <20190529214753.21804-1-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After adding ethtool ring param sanity check patch:

commit 37e2d99b59c4765112533a1d38174fea58d28a51 ("ethtool: Ensure new
ring parameters are within bounds during SRINGPARAM")

cpsw has no ability to change rx descriptor numbers.
But the reason - initially "tx_max_pending" was not correctly set
while adding a patch:

commit be034fc14015c7fcabe62317d156e98b508a759b ("net: ethernet: ti:
cpsw: add support for ringparam configuration")

The issue appears after adding sanity check, so fix is for "sanity"
patch.

Fixes: 37e2d99b59c4765112533a1d38174fea58d28a51 ("ethtool: Ensure new
ring parameters are within bounds during SRINGPARAM")

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---

Based on net/master

 drivers/net/ethernet/ti/cpsw_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
index a4a7ec0d2531..6d1c9ebae7cc 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -643,7 +643,7 @@ void cpsw_get_ringparam(struct net_device *ndev,
 	struct cpsw_common *cpsw = priv->cpsw;
 
 	/* not supported */
-	ering->tx_max_pending = 0;
+	ering->tx_max_pending = cpsw->descs_pool_size - CPSW_MAX_QUEUES;
 	ering->tx_pending = cpdma_get_num_tx_descs(cpsw->dma);
 	ering->rx_max_pending = cpsw->descs_pool_size - CPSW_MAX_QUEUES;
 	ering->rx_pending = cpdma_get_num_rx_descs(cpsw->dma);
-- 
2.17.1

