Return-Path: <netdev+bounces-5930-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 922BF71363C
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 21:40:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 446FB1C20A85
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 19:40:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5055013AD3;
	Sat, 27 May 2023 19:40:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448717E
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 19:40:17 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp-26.smtpout.orange.fr [80.12.242.26])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF1DD8
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 12:40:14 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
	by smtp.orange.fr with ESMTPA
	id 2zlqqt6LYzb8g2zlqqY7Te; Sat, 27 May 2023 21:40:12 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1685216412;
	bh=VKthlyn9E+U4rCBy7ij6kRftfxuaXpwhoHRrC4eHBog=;
	h=From:To:Cc:Subject:Date;
	b=mG4kTaBcbdVgJxb642fw9xT4sANB4RsAO2haUtUX9fe7eNV41iuffXUFBlfXvzRCa
	 xm5NRBMB1GSBRPb0Kb6/cY2F/Ikzq99aceXqkcXapTgNDYe5awbRfSTnYi3BRMtJ+u
	 7XXWgSEo+20gE6IjEEIEAJ7tjBM8EWA+AQrD2uGJ9o9iBSr0mN/cssERJj15ZgwBiB
	 WWZNRBYsoYGlEarqTmPGoCmdocT5A6ohz/htXTajhFihPOvw7XoSZZmU7IFZ1ZHr8y
	 y1fDYxAo0fnLkBX5B1ctnql9gHDL2Cy+rrplV+XFhX4UpwN3Q9N/1NWzuXs+fYc0q+
	 cNnm/rZj5BovA==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 27 May 2023 21:40:12 +0200
X-ME-IP: 86.243.2.178
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Derek Chickles <dchickles@marvell.com>,
	Satanand Burla <sburla@marvell.com>,
	Felix Manlunas <fmanlunas@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	netdev@vger.kernel.org
Subject: [PATCH net-next] liquidio: Use vzalloc()
Date: Sat, 27 May 2023 21:40:08 +0200
Message-Id: <93b010824d9d92376e8d49b9eb396a0fa0c0ac80.1685216322.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use vzalloc() instead of hand writing it with vmalloc()+memset().
This is less verbose.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c | 4 +---
 drivers/net/ethernet/cavium/liquidio/cn23xx_vf_device.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
index 9ed3d1ab2ca5..285d3825cad3 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
@@ -719,12 +719,10 @@ static int cn23xx_setup_pf_mbox(struct octeon_device *oct)
 	for (i = 0; i < oct->sriov_info.max_vfs; i++) {
 		q_no = i * oct->sriov_info.rings_per_vf;
 
-		mbox = vmalloc(sizeof(*mbox));
+		mbox = vzalloc(sizeof(*mbox));
 		if (!mbox)
 			goto free_mbox;
 
-		memset(mbox, 0, sizeof(struct octeon_mbox));
-
 		spin_lock_init(&mbox->lock);
 
 		mbox->oct_dev = oct;
diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_device.c b/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_device.c
index fda49404968c..b3bd2767d3dd 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_device.c
@@ -279,12 +279,10 @@ static int cn23xx_setup_vf_mbox(struct octeon_device *oct)
 {
 	struct octeon_mbox *mbox = NULL;
 
-	mbox = vmalloc(sizeof(*mbox));
+	mbox = vzalloc(sizeof(*mbox));
 	if (!mbox)
 		return 1;
 
-	memset(mbox, 0, sizeof(struct octeon_mbox));
-
 	spin_lock_init(&mbox->lock);
 
 	mbox->oct_dev = oct;
-- 
2.34.1


