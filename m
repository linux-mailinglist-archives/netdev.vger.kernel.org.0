Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6F95E767D
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 11:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbiIWJIb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Sep 2022 05:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiIWJI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 05:08:28 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9249312DEF7
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 02:08:15 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-169-Je0GCPpzO1eKBVDAlo9mSA-1; Fri, 23 Sep 2022 05:08:07 -0400
X-MC-Unique: Je0GCPpzO1eKBVDAlo9mSA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 94955185A7A3;
        Fri, 23 Sep 2022 09:08:06 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.192.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 711F740C6E17;
        Fri, 23 Sep 2022 09:08:05 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Lior Nahmanson <liorna@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net-next] macsec: don't free NULL metadata_dst
Date:   Fri, 23 Sep 2022 11:07:09 +0200
Message-Id: <60f2a1965fe553e2cade9472407d0fafff8de8ce.1663923580.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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

Commit 0a28bfd4971f added a metadata_dst to each tx_sc, but that's
only allocated when macsec_add_dev has run, which happens after device
registration. If the requested or computed SCI already exists, or if
linking to the lower device fails, we will panic because
metadata_dst_free can't handle NULL.

Reproducer:
    ip link add link $lower type macsec
    ip link add link $lower type macsec

Fixes: 0a28bfd4971f ("net/macsec: Add MACsec skb_metadata_dst Tx Data path support")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/macsec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 617f850bdb3a..ebcfe87bed23 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3734,7 +3734,8 @@ static void macsec_free_netdev(struct net_device *dev)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
 
-	metadata_dst_free(macsec->secy.tx_sc.md_dst);
+	if (macsec->secy.tx_sc.md_dst)
+		metadata_dst_free(macsec->secy.tx_sc.md_dst);
 	free_percpu(macsec->stats);
 	free_percpu(macsec->secy.tx_sc.stats);
 
-- 
2.37.3

