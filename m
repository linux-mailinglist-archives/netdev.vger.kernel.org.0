Return-Path: <netdev+bounces-4065-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE8C170A663
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 10:30:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 659801C20A8A
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 08:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0284632;
	Sat, 20 May 2023 08:30:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53B5372
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 08:30:23 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp-28.smtpout.orange.fr [80.12.242.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C73CA1
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 01:30:22 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
	by smtp.orange.fr with ESMTPA
	id 0Hylq5VzBHWsH0HylqQZQ4; Sat, 20 May 2023 10:30:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1684571421;
	bh=oQETDRJrVbTE0ETdYYPnZKcQRoVWgLVTmKiK6jA9rrg=;
	h=From:To:Cc:Subject:Date;
	b=fmfKyYeh/B4aI/deh2jAk95LR+ZzeVPc4Ln4zuzzuZFkDAlcfHLp8OTDNASXkHcIV
	 Ftg2EZf55rTKYNQYyMOHhGb6iYzriNOgnMPrsPtgbexXDDutlsTdqVgXTXCJOTwH3z
	 iLfYflB2vMl9kNWXBMR72sdVKf+wDpI+xcDcI4fmyN470r7OxoLjXaRW5FunRPHCYM
	 5yFUiTLe0g6BliVHQPUPpimbXeXzg942AnAX7V+sMjxTIC4jZndhv448LQ6bS+c9cU
	 +CGc3tVVhRiPVBE1c46aZ5F8ftOUNKK+D8Jb9T0yKeghb7YoHgAh64NL6P3n4rgmbK
	 Ar4Z68IHOFy5g==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 20 May 2023 10:30:21 +0200
X-ME-IP: 86.243.2.178
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Rain River <rain.1986.08.12@gmail.com>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Ayaz Abdulla <aabdulla@nvidia.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	netdev@vger.kernel.org
Subject: [PATCH net] forcedeth: Fix an error handling path in nv_probe()
Date: Sat, 20 May 2023 10:30:17 +0200
Message-Id: <355e9a7d351b32ad897251b6f81b5886fcdc6766.1684571393.git.christophe.jaillet@wanadoo.fr>
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

If an error occures after calling nv_mgmt_acquire_sema(), it should be
undone with a corresponding nv_mgmt_release_sema() call.

Add it in the error handling path of the probe as already done in the
remove function.

Fixes: cac1c52c3621 ("forcedeth: mgmt unit interface")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
I don't think that the Fixes tag is really accurate, but
nv_mgmt_release_sema() was introduced here. And cac1c52c3621 is already old
so should be good enough.
---
 drivers/net/ethernet/nvidia/forcedeth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 0605d1ee490d..7a549b834e97 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -6138,6 +6138,7 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	return 0;
 
 out_error:
+	nv_mgmt_release_sema(dev);
 	if (phystate_orig)
 		writel(phystate|NVREG_ADAPTCTL_RUNNING, base + NvRegAdapterControl);
 out_freering:
-- 
2.34.1


