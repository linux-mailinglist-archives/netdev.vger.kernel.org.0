Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3135C4F6FBA
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 03:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235906AbiDGBOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 21:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235457AbiDGBNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 21:13:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C59181D85;
        Wed,  6 Apr 2022 18:11:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1744B8268B;
        Thu,  7 Apr 2022 01:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709AFC385A6;
        Thu,  7 Apr 2022 01:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649293870;
        bh=/oU6JTFjoCPlkwzZtxF5z5nHNFqJRDCxPamXkPOwE5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IvECytCub//rn5O8DuIIPZIjpSEc9ZqmVa1Mpq82SwaWaue63Rv9qg5Z/Xk0p/+RC
         mXwocwML29A0GS5chQXwktH4rLQmVpNPEZ6GFesO0YXsrO8ppWjkjKUppehv7Vrrc0
         qgodceA+0SgG+nPgn4M0FO21MadY+kPorBn8y6O9I3JtI3JI7i8heX+00876T4u71F
         PM3EGEupMERo/L5AKkHclLEHVkmrrMu2dmdDbmtBdvzcLCA1VyRTI7spH2ZJQNFP4u
         oyPbWRXC/PCSX48oF+y1W7ODlt+9uBY7D5y4U8tAk5YlucJ+Uq5Z2Oq7iJ4OnUvxCK
         3zsrkUFD4A3Gw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 19/31] vhost_vdpa: don't setup irq offloading when irq_num < 0
Date:   Wed,  6 Apr 2022 21:10:17 -0400
Message-Id: <20220407011029.113321-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011029.113321-1-sashal@kernel.org>
References: <20220407011029.113321-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Lingshan <lingshan.zhu@intel.com>

[ Upstream commit cce0ab2b2a39072d81f98017f7b076f3410ef740 ]

When irq number is negative(e.g., -EINVAL), the virtqueue
may be disabled or the virtqueues are sharing a device irq.
In such case, we should not setup irq offloading for a virtqueue.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Link: https://lore.kernel.org/r/20220222115428.998334-3-lingshan.zhu@intel.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ec5249e8c32d..05f5fd2af58f 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -97,8 +97,11 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
 		return;
 
 	irq = ops->get_vq_irq(vdpa, qid);
+	if (irq < 0)
+		return;
+
 	irq_bypass_unregister_producer(&vq->call_ctx.producer);
-	if (!vq->call_ctx.ctx || irq < 0)
+	if (!vq->call_ctx.ctx)
 		return;
 
 	vq->call_ctx.producer.token = vq->call_ctx.ctx;
-- 
2.35.1

