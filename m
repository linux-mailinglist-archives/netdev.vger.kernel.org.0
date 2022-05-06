Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5CCC51DE24
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 19:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444113AbiEFRLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 13:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444121AbiEFRLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 13:11:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619A96EC54
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 10:07:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF4A1620A3
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 17:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056D8C385B1;
        Fri,  6 May 2022 17:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651856878;
        bh=EOppvrxLswoTsvPVhvrABeVCgsSXrFLaroQTBKMVKIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oUiOIpOrCqmyl+XIqqfg64A8drHUQ8XQ/v8CTCT8bXquA+i2AwteKfeOwJa0sxx9v
         CCbHQS6cbVqZhZXZThN55wyC6MRRe+iIOmS8mJmxWE/d4zRu+3CS+PKsjfYGtmtR+X
         pOky90tW0xO/qhYpyHyuBTFgYhJuFMlD2WZv5sieSdgXpBjLS2+uGyJtZkGKEuGNMc
         AVAF4Uu4i3MswcvC+6Qlfmti3WodI/1fpY9jfTTrFz2WkgEflTOmR6w61Vy70K5uFU
         v3+w24wOwepgQTQcAtWGp8msUCUGJ3Ufr1lGd59mzSZmY09d8wLd2YMVKK1sFBDhDd
         1olcvU0eFQbdA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>, mst@redhat.com,
        wanghai38@huawei.com
Subject: [PATCH net-next 2/6] caif_virtio: switch to netif_napi_add_weight()
Date:   Fri,  6 May 2022 10:07:47 -0700
Message-Id: <20220506170751.822862-3-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220506170751.822862-1-kuba@kernel.org>
References: <20220506170751.822862-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

caif_virtio uses a custom napi weight, switch to the new
API for setting custom weights.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: mst@redhat.com
CC: wanghai38@huawei.com
---
 drivers/net/caif/caif_virtio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
index 444ef6a342f6..5458f57177a0 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -714,7 +714,8 @@ static int cfv_probe(struct virtio_device *vdev)
 	/* Initialize NAPI poll context data */
 	vringh_kiov_init(&cfv->ctx.riov, NULL, 0);
 	cfv->ctx.head = USHRT_MAX;
-	netif_napi_add(netdev, &cfv->napi, cfv_rx_poll, CFV_DEFAULT_QUOTA);
+	netif_napi_add_weight(netdev, &cfv->napi, cfv_rx_poll,
+			      CFV_DEFAULT_QUOTA);
 
 	tasklet_setup(&cfv->tx_release_tasklet, cfv_tx_release_tasklet);
 
-- 
2.34.1

