Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD5B5F4110
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 12:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiJDKv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 06:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiJDKvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 06:51:07 -0400
X-Greylist: delayed 513 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 04 Oct 2022 03:50:58 PDT
Received: from forward100o.mail.yandex.net (forward100o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033C313F87;
        Tue,  4 Oct 2022 03:50:57 -0700 (PDT)
Received: from forward100q.mail.yandex.net (forward100q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb97])
        by forward100o.mail.yandex.net (Yandex) with ESMTP id BB33452ABDF7;
        Tue,  4 Oct 2022 13:42:21 +0300 (MSK)
Received: from vla3-23c3b031fed5.qloud-c.yandex.net (vla3-23c3b031fed5.qloud-c.yandex.net [IPv6:2a02:6b8:c15:2582:0:640:23c3:b031])
        by forward100q.mail.yandex.net (Yandex) with ESMTP id B6D6A6F40002;
        Tue,  4 Oct 2022 13:42:21 +0300 (MSK)
Received: by vla3-23c3b031fed5.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id er6Xai1pjJ-gKhGM48u;
        Tue, 04 Oct 2022 13:42:21 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1664880141;
        bh=u8fB18adYnck2C3aYsjuR/l6wiEjwRdtCR4r9ngxn40=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=biLY4ENhLrX39alLvQPu/TsVUHOxxLF6ewU4H5h3DbX7tsi4Yg6fXYJeimfWoPUfg
         0FuHbFep0SSSAsFCd8U0MNo8jur6g+CVlP+tHFiTz9HOKX45cd+IpcmSTwZ2EthI5R
         CWgqfrfwmRIVQ0AoHBb3um0Gg94eE8fOPKJOvqnk=
Authentication-Results: vla3-23c3b031fed5.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
From:   Peter Kosyh <pkosyh@yandex.ru>
To:     Rasesh Mody <rmody@marvell.com>
Cc:     Peter Kosyh <pkosyh@yandex.ru>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH] bna: replace sprintf with snprintf,  BNA_Q_NAME_SIZE is depends on IFNAMSIZ
Date:   Tue,  4 Oct 2022 13:42:17 +0300
Message-Id: <20221004104217.387137-1-pkosyh@yandex.ru>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BNA_Q_NAME_SIZE is just 16, so buffer overflow with long interface
name is possible.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Peter Kosyh <pkosyh@yandex.ru>
---
 drivers/net/ethernet/brocade/bna/bna_types.h | 2 +-
 drivers/net/ethernet/brocade/bna/bnad.c      | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bna_types.h b/drivers/net/ethernet/brocade/bna/bna_types.h
index 666b6922e24d..979dbab9f960 100644
--- a/drivers/net/ethernet/brocade/bna/bna_types.h
+++ b/drivers/net/ethernet/brocade/bna/bna_types.h
@@ -410,7 +410,7 @@ struct bna_ib {
 /* Tx object */
 
 /* Tx datapath control structure */
-#define BNA_Q_NAME_SIZE		16
+#define BNA_Q_NAME_SIZE		IFNAMSIZ
 struct bna_tcb {
 	/* Fast path */
 	void			**sw_qpt;
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index 29dd0f93d6c0..770392e35908 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -1535,7 +1535,8 @@ bnad_tx_msix_register(struct bnad *bnad, struct bnad_tx_info *tx_info,
 
 	for (i = 0; i < num_txqs; i++) {
 		vector_num = tx_info->tcb[i]->intr_vector;
-		sprintf(tx_info->tcb[i]->name, "%s TXQ %d", bnad->netdev->name,
+		snprintf(tx_info->tcb[i]->name, BNA_Q_NAME_SIZE,
+				"%s TXQ %d", bnad->netdev->name,
 				tx_id + tx_info->tcb[i]->id);
 		err = request_irq(bnad->msix_table[vector_num].vector,
 				  (irq_handler_t)bnad_msix_tx, 0,
@@ -1586,8 +1587,8 @@ bnad_rx_msix_register(struct bnad *bnad, struct bnad_rx_info *rx_info,
 
 	for (i = 0; i < num_rxps; i++) {
 		vector_num = rx_info->rx_ctrl[i].ccb->intr_vector;
-		sprintf(rx_info->rx_ctrl[i].ccb->name, "%s CQ %d",
-			bnad->netdev->name,
+		snprintf(rx_info->rx_ctrl[i].ccb->name, BNA_Q_NAME_SIZE,
+			"%s CQ %d", bnad->netdev->name,
 			rx_id + rx_info->rx_ctrl[i].ccb->id);
 		err = request_irq(bnad->msix_table[vector_num].vector,
 				  (irq_handler_t)bnad_msix_rx, 0,
-- 
2.37.0

