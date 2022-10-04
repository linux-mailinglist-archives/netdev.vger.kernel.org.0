Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD555F408D
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 12:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiJDKH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 06:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiJDKHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 06:07:55 -0400
X-Greylist: delayed 591 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 04 Oct 2022 03:07:53 PDT
Received: from forward101p.mail.yandex.net (forward101p.mail.yandex.net [77.88.28.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B84527B33;
        Tue,  4 Oct 2022 03:07:52 -0700 (PDT)
Received: from myt5-2f5ba0466eb8.qloud-c.yandex.net (myt5-2f5ba0466eb8.qloud-c.yandex.net [IPv6:2a02:6b8:c12:1c83:0:640:2f5b:a046])
        by forward101p.mail.yandex.net (Yandex) with ESMTP id 6D10859CFCF7;
        Tue,  4 Oct 2022 12:50:42 +0300 (MSK)
Received: by myt5-2f5ba0466eb8.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id rEpJMfzEhn-ofhSNNBN;
        Tue, 04 Oct 2022 12:50:41 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1664877041;
        bh=K8cBt2opq8Vz5IgFqg7H0MSu8Z+lhRpJxKBpnfGhoQk=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=aksGLhJC7WE4wNfc3JzF+seDDz2hQKmsQioY3ZrS+jepS+I3EXJXG2xyh2Ob4jZtx
         ZquskaeqVqgbeoicM3Nor8mVHw9TjpfOeu4RrmDzd7wLKzY3bwYxIeGSUEVDOODikY
         MlcX+iJUN3C0EmcHcVogdHRtGCC3I5e9PODQ44/4=
Authentication-Results: myt5-2f5ba0466eb8.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
From:   Peter Kosyh <pkosyh@yandex.ru>
To:     Ajit Khaparde <ajit.khaparde@broadcom.com>
Cc:     Peter Kosyh <pkosyh@yandex.ru>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH] net: benet: use snprintf instead sprintf and IFNAMSIZ instead hardcoded constant.
Date:   Tue,  4 Oct 2022 12:50:34 +0300
Message-Id: <20221004095034.377665-1-pkosyh@yandex.ru>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

printf to array 'eqo->desc' of size 32 may cause buffer overflow when
using non-standard IFNAMSIZ.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Peter Kosyh <pkosyh@yandex.ru>
---
 drivers/net/ethernet/emulex/benet/be.h      | 2 +-
 drivers/net/ethernet/emulex/benet/be_main.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be.h b/drivers/net/ethernet/emulex/benet/be.h
index 61fe9625bed1..857a25f45fc8 100644
--- a/drivers/net/ethernet/emulex/benet/be.h
+++ b/drivers/net/ethernet/emulex/benet/be.h
@@ -179,7 +179,7 @@ static inline void queue_tail_inc(struct be_queue_info *q)
 
 struct be_eq_obj {
 	struct be_queue_info q;
-	char desc[32];
+	char desc[IFNAMSIZ+16];
 
 	struct be_adapter *adapter;
 	struct napi_struct napi;
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 414362febbb9..8e75a14da595 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -3485,7 +3485,7 @@ static int be_msix_register(struct be_adapter *adapter)
 	int status, i, vec;
 
 	for_all_evt_queues(adapter, eqo, i) {
-		sprintf(eqo->desc, "%s-q%d", netdev->name, i);
+		snprintf(eqo->desc, sizeof(eqo->desc), "%s-q%d", netdev->name, i);
 		vec = be_msix_vec_get(adapter, eqo);
 		status = request_irq(vec, be_msix, 0, eqo->desc, eqo);
 		if (status)
-- 
2.37.0

