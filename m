Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41ACF6936C8
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 10:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjBLJ6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 04:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjBLJ6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 04:58:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C8113DC6;
        Sun, 12 Feb 2023 01:58:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BC4360C76;
        Sun, 12 Feb 2023 09:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC71C433D2;
        Sun, 12 Feb 2023 09:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676195893;
        bh=CUfRVAqrysv7OC9fLkMu9XCNEmuTFr1gW9/jxrpGUB4=;
        h=From:To:Cc:Subject:Date:From;
        b=k2zmp6U/Br/PRu7METzqjkEzbD6bpyo5WX2Ft7BnJSznC7UHBUEJHq36mXCCidlNa
         P9E5fkEDznG2SA68BUFqPFc3NtDQJQ+PPUIS/lnJGFb6uEG71G8EmVex8ZEGV1qK21
         1rEMala7qP+Mp5x+CotetwVD/5NJBbQDm4MF0trOTez2QGtPevEWhBpj7dAwMF9FXs
         hks6c6c51LqrAEl8hxet1HK19EwvDP7nQcwDBtDiZ09DjQb97p9knCVxRopZJXp/WJ
         noKdAKgz4U6EVHsQBtoyN/kWktpJ1sLw8yftcRzjfQ5pS60BTR72mG2vwdkLxS5Uv5
         RtCvkEur4hI9w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com,
        lorenzo.bianconi@redhat.com, bpf@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: [PATCH net-next] hv_netvsc: add missing NETDEV_XDP_ACT_NDO_XMIT xdp-features flag
Date:   Sun, 12 Feb 2023 10:57:58 +0100
Message-Id: <8e3747018f0fd0b5d6e6b9aefe8d9448ca3a3288.1676195726.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing ndo_xdp_xmit bit to xdp_features capability flag.

Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/hyperv/netvsc_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index a9b139bbdb2c..e34ccd47ae57 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2559,7 +2559,8 @@ static int netvsc_probe(struct hv_device *dev,
 
 	netdev_lockdep_set_classes(net);
 
-	net->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT;
+	net->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
+			    NETDEV_XDP_ACT_NDO_XMIT;
 
 	/* MTU range: 68 - 1500 or 65521 */
 	net->min_mtu = NETVSC_MTU_MIN;
-- 
2.39.1

