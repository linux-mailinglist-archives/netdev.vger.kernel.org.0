Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5FC3F18B7
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 14:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239049AbhHSMFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 08:05:21 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:51948
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238105AbhHSMFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 08:05:21 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 977413F328;
        Thu, 19 Aug 2021 12:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629374683;
        bh=QUE+Hz7hicyzL2G0Uw8v/suyW1F/+qww9QoZPWvoHqY=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=Zxfo5gIWEgwYXJKX9Yv8VfkD9cB+DuhbtRR14+jv/2PoUDagdODjcAAfgvk/BRqWM
         eHdOLeju7mDV/m3L9ErakhO/+JLbyb/fdttrBERrbItm+K6snYHpoOSffnhSf0KquA
         duQyJsTyMNzvkB6/LEzmXuNFlb9vfLjddQaSuvzJWMfS/lCUH1UjLLCb4ygfsefzxb
         X+4qle46s1bqTO78peg7Zkd/Hiu4y8cQW/8NaG9VfbuyTj5OBx7iC3q+AfWroRyII+
         fnmPPQrtyMPgTM6dHQLJ1petxBw1USD9LaHXew1Ah4zn/JugC8+Yl+WGKIjXgkn1WT
         vAVoH42/K+frw==
From:   Colin King <colin.king@canonical.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: ti: cpsw: make array stpa static const, makes object smaller
Date:   Thu, 19 Aug 2021 13:04:43 +0100
Message-Id: <20210819120443.7083-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the array stpa on the stack but instead it
static const. Makes the object code smaller by 81 bytes:

Before:
   text    data   bss    dec    hex filename
  54993   17248     0  72241  11a31 ./drivers/net/ethernet/ti/cpsw_new.o

After:
   text    data   bss    dec    hex filename
  54784   17376     0  72160  119e0 ./drivers/net/ethernet/ti/cpsw_new.o

(gcc version 10.3.0)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/ti/cpsw_new.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 85d05b9be2b8..534d39f729e2 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -502,7 +502,7 @@ static void cpsw_restore(struct cpsw_priv *priv)
 
 static void cpsw_init_stp_ale_entry(struct cpsw_common *cpsw)
 {
-	char stpa[] = {0x01, 0x80, 0xc2, 0x0, 0x0, 0x0};
+	static const char stpa[] = {0x01, 0x80, 0xc2, 0x0, 0x0, 0x0};
 
 	cpsw_ale_add_mcast(cpsw->ale, stpa,
 			   ALE_PORT_HOST, ALE_SUPER, 0,
-- 
2.32.0

