Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67AA260EB07
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 23:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbiJZV5X convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Oct 2022 17:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbiJZV5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 17:57:19 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6600997EFD
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 14:57:18 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-428-iP2RleERMuiTtSp6PgT8dA-1; Wed, 26 Oct 2022 17:57:15 -0400
X-MC-Unique: iP2RleERMuiTtSp6PgT8dA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99DAA1C0A103;
        Wed, 26 Oct 2022 21:57:14 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.192.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2E681121339;
        Wed, 26 Oct 2022 21:57:13 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Leon Romanovsky <leon@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net v2 4/5] macsec: fix detection of RXSCs when toggling offloading
Date:   Wed, 26 Oct 2022 23:56:26 +0200
Message-Id: <0f3ab52fc5a5377c02e1f2dfc14a8d087f56124a.1666793468.git.sd@queasysnail.net>
In-Reply-To: <cover.1666793468.git.sd@queasysnail.net>
References: <cover.1666793468.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

macsec_is_configured incorrectly uses secy->n_rx_sc to check if some
RXSCs exist. secy->n_rx_sc only counts the number of active RXSCs, but
there can also be inactive SCs as well, which may be stored in the
driver (in case we're disabling offloading), or would have to be
pushed to the device (in case we're trying to enable offloading).

As long as RXSCs active on creation and never turned off, the issue is
not visible.

Fixes: dcb780fb2795 ("net: macsec: add nla support for changing the offloading selection")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/macsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 48e2dd2d5778..5a2c1bd65d89 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2572,7 +2572,7 @@ static bool macsec_is_configured(struct macsec_dev *macsec)
 	struct macsec_tx_sc *tx_sc = &secy->tx_sc;
 	int i;
 
-	if (secy->n_rx_sc > 0)
+	if (secy->rx_sc)
 		return true;
 
 	for (i = 0; i < MACSEC_NUM_AN; i++)
-- 
2.38.0

