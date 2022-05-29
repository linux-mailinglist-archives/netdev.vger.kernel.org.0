Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 711A35371A1
	for <lists+netdev@lfdr.de>; Sun, 29 May 2022 17:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbiE2PjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 May 2022 11:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbiE2PjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 May 2022 11:39:15 -0400
Received: from sender2-op-o12.zoho.com.cn (sender2-op-o12.zoho.com.cn [163.53.93.243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322E762CF6;
        Sun, 29 May 2022 08:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1653838740;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:From:To:To:Cc:Cc:Message-ID:Subject:Subject:Date:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
        bh=GrTj8VY0/9DV3DlXEyfob5/+KcrPMGhSzDeS9OqV1Rc=;
        b=KGQHbauPudSMl2lfmpKHoOrKXT5ELfnxaEoVuot7m7M2b+maCHgpjqVUUfNjt5aR
        1AWYi9QYshVs2M5BIYCVwsT5+8my7EV2seYd1hJctPVjWZHShlVFBSWsz8f7j8ZjplX
        b6dFaLAhptGAeSKjuYgcQ7xf7eg28t8INm4FIGUQ=
Received: from localhost.localdomain (81.71.33.115 [81.71.33.115]) by mx.zoho.com.cn
        with SMTPS id 1653838738366295.3214211822982; Sun, 29 May 2022 23:38:58 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-media@vger.kernel.org
Cc:     Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20220529153456.4183738-4-cgxu519@mykernel.net>
Subject: [PATCH 3/6] scsi: ipr: fix missing/incorrect resource cleanup in error case
Date:   Sun, 29 May 2022 23:34:53 +0800
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220529153456.4183738-1-cgxu519@mykernel.net>
References: <20220529153456.4183738-1-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix missing resource cleanup(when '(--i) =3D=3D 0') for
error case in ipr_alloc_mem() and skip incorrect resource
cleanup(when '(--i) =3D=3D 0') for error case in
ipr_request_other_msi_irqs() because variable i started from 1.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 drivers/scsi/ipr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 256ec6d08c16..9d01a3e3c26a 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9795,7 +9795,7 @@ static int ipr_alloc_mem(struct ipr_ioa_cfg *ioa_cfg)
 =09=09=09=09=09GFP_KERNEL);
=20
 =09=09if (!ioa_cfg->hrrq[i].host_rrq)  {
-=09=09=09while (--i > 0)
+=09=09=09while (--i >=3D 0)
 =09=09=09=09dma_free_coherent(&pdev->dev,
 =09=09=09=09=09sizeof(u32) * ioa_cfg->hrrq[i].size,
 =09=09=09=09=09ioa_cfg->hrrq[i].host_rrq,
@@ -10068,7 +10068,7 @@ static int ipr_request_other_msi_irqs(struct ipr_io=
a_cfg *ioa_cfg,
 =09=09=09ioa_cfg->vectors_info[i].desc,
 =09=09=09&ioa_cfg->hrrq[i]);
 =09=09if (rc) {
-=09=09=09while (--i >=3D 0)
+=09=09=09while (--i > 0)
 =09=09=09=09free_irq(pci_irq_vector(pdev, i),
 =09=09=09=09=09&ioa_cfg->hrrq[i]);
 =09=09=09return rc;
--=20
2.27.0


