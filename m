Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6D551A5BF
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 18:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353383AbiEDQnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 12:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245372AbiEDQnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 12:43:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F8C433B9
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 09:39:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A440961698
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 16:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8900C385A4;
        Wed,  4 May 2022 16:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651682384;
        bh=auC7/m7KqpH85vFdj1grYJ1nYl4pkBztfh2mKJk/jVM=;
        h=From:To:Cc:Subject:Date:From;
        b=S2TPRMLpG6m4fpdO+MDNjyf5O26urEgGX6kudNIapOnx2c6PMjtcmE1GLwFHUz5Tg
         Eu9ZXGQ1cQbnFPo5CwlzmTyap1wyqUOYXB+Pf7S/WJFwlqa7I9Wj2Mf3xq7lPtSIbw
         Y4aTksj3r0dZ+93cPhmCPGR3ObNtSkcIjaS3JXO1t6oS2cluEPkw5t84SuHYfLXkSh
         Np2uf8lK2tWKFZnBhLGD1MlnG7PQCc3fZS+gAJa3u37T6Nw/h65lGECs12ftGS77wN
         smgJB+JGRiReqRN/j2oQm+SKF8KWKkn83C9GVhaLdusmwDiv2WiF1dxb4s0f5Getr6
         LtofvMNGXjOxg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>, cooldavid@cooldavid.org
Subject: [PATCH net-next] jme: remove an unnecessary indirection
Date:   Wed,  4 May 2022 09:39:39 -0700
Message-Id: <20220504163939.551231-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
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

Remove a define which looks like a OS abstraction layer
and makes spatch conversions on this driver problematic.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: cooldavid@cooldavid.org
---
 drivers/net/ethernet/jme.c | 2 +-
 drivers/net/ethernet/jme.h | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index b6c5122da995..f43d6616bc0d 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -3009,7 +3009,7 @@ jme_init_one(struct pci_dev *pdev,
 		jwrite32(jme, JME_APMC, apmc);
 	}
 
-	NETIF_NAPI_SET(netdev, &jme->napi, jme_poll, NAPI_POLL_WEIGHT)
+	netif_napi_add(netdev, &jme->napi, jme_poll, NAPI_POLL_WEIGHT);
 
 	spin_lock_init(&jme->phy_lock);
 	spin_lock_init(&jme->macaddr_lock);
diff --git a/drivers/net/ethernet/jme.h b/drivers/net/ethernet/jme.h
index 2af76329b4a2..860494ff3714 100644
--- a/drivers/net/ethernet/jme.h
+++ b/drivers/net/ethernet/jme.h
@@ -379,8 +379,6 @@ struct jme_ring {
 #define DECLARE_NET_DEVICE_STATS
 
 #define DECLARE_NAPI_STRUCT struct napi_struct napi;
-#define NETIF_NAPI_SET(dev, napis, pollfn, q) \
-	netif_napi_add(dev, napis, pollfn, q);
 #define JME_NAPI_HOLDER(holder) struct napi_struct *holder
 #define JME_NAPI_WEIGHT(w) int w
 #define JME_NAPI_WEIGHT_VAL(w) w
-- 
2.34.1

