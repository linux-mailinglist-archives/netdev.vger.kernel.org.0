Return-Path: <netdev+bounces-2755-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2375703D58
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 21:09:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5AAE1C20BA6
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 19:09:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2B9D18C31;
	Mon, 15 May 2023 19:09:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E825E18C18
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 19:09:23 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp-22.smtpout.orange.fr [80.12.242.22])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184BF10A23
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:09:22 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
	by smtp.orange.fr with ESMTPA
	id ydZNpe93Z4EobydZNpkGvL; Mon, 15 May 2023 21:09:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1684177760;
	bh=zACXJ1h4Wvn8bpxBXMt599tP1i74X5J3NU0zEKmumlQ=;
	h=From:To:Cc:Subject:Date;
	b=EZ1E8N1HPbyOUIsJmwq/apxM3uqLJ9JMBchA4b8ZR1Em53R8jLyIRCZYebKjvhQyM
	 SxhGsNrUzhIGnQKmBIMYNzCrgzdOier+rcs9ROhGZ47k5WOUbdNBH0FlkzLq2K3pUA
	 e1F3bX0YxT8R6QUq13rHP1rOzaTG5Nz6rx6S81R30Fn3ybdg1N/JOr3dZqC/rLwxtx
	 927wDflqKO5DtdZ3+Zz4Gyi1aIEW8yqRxIcnkTsjOpVL3jaolZcZ6ws9sTad2xxcBh
	 LC5z5W4K/JC82rJFJI74+dvNZ2pB4cGevalo5Rd+Vo6Vb65LEvn/KPkB8Lq1KkyICi
	 3yb+lIfHWUwHg==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 15 May 2023 21:09:20 +0200
X-ME-IP: 86.243.2.178
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jaswinder Singh <jaswinder@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	netdev@vger.kernel.org
Subject: [PATCH] cassini: Fix a memory leak in the error handling path of cas_init_one()
Date: Mon, 15 May 2023 21:09:11 +0200
Message-Id: <de2bb89d2c9c49198353c3d66fa9b67ce6c0f191.1684177731.git.christophe.jaillet@wanadoo.fr>
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
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

cas_saturn_firmware_init() allocates some memory using vmalloc(). This
memory is freed in the .remove() function but not it the error handling
path of the probe.

Add the missing vfree() to avoid a memory leak, should an error occur.

Fixes: fcaa40669cd7 ("cassini: use request_firmware")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/sun/cassini.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 2d52f54ebb45..b317b9486455 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -5073,6 +5073,8 @@ static int cas_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		cas_shutdown(cp);
 	mutex_unlock(&cp->pm_mutex);
 
+	vfree(cp->fw_data);
+
 	pci_iounmap(pdev, cp->regs);
 
 
-- 
2.34.1


