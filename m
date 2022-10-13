Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D50375FDC3D
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 16:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiJMORS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Oct 2022 10:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiJMORQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 10:17:16 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D883612FFAA
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 07:17:14 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-WU6PnKPWNF2ISYqc7Mjs4Q-1; Thu, 13 Oct 2022 10:17:10 -0400
X-MC-Unique: WU6PnKPWNF2ISYqc7Mjs4Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7BB63C106AE;
        Thu, 13 Oct 2022 14:17:08 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.192.237])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29C911102E3A;
        Thu, 13 Oct 2022 14:17:04 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net 4/5] macsec: fix detection of RXSCs when toggling offloading
Date:   Thu, 13 Oct 2022 16:15:42 +0200
Message-Id: <4fb4ec3c0ad5e48c82389b3c40bd045f3d9eaf76.1665416630.git.sd@queasysnail.net>
In-Reply-To: <cover.1665416630.git.sd@queasysnail.net>
References: <cover.1665416630.git.sd@queasysnail.net>
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
index cdee342e42cd..0ad6eba0a807 100644
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

