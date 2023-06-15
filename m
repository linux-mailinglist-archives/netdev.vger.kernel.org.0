Return-Path: <netdev+bounces-10965-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC42E730DBC
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 05:52:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FB9A1C20E1B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 03:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6564634;
	Thu, 15 Jun 2023 03:52:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2E2625
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 03:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8573EC433CA;
	Thu, 15 Jun 2023 03:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686801153;
	bh=eUMOaaa64vv4PEr+rHiwQ5XErXSIP/gyvXwLW+x4DIE=;
	h=From:To:Cc:Subject:Date:From;
	b=g/eeBySz8RkrHgqbCc6maIbvUP8+JWE1jWVuVwl8b2gorJu8s7PijZiGh1D7z/IiL
	 +1jDMvOLh4jHLzHZXjxnXIKgqjkZV0MLziB+4k0aUQlAdCxAspblBZzdPZxD1myw+q
	 Pbro0U9QV0o41yA2P7X0xSjfs75XfS5IqoGxx2+Vd0vkmcTmwur+hJRn0TWVuZA+HS
	 Y/cBIFfeM6OXEI6Scap0+oqbPgGKeHA8mca8jxYwxBbzs5cdi/h0skfW6OYgd0M1mA
	 I1BNbPKprnICjEVNwfN4Hiv2+M9ea62NRiI6cutq2VylWrzu41QEnMUOp/SC/MseTn
	 uRz2xIxAVr8Mw==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	pantelis.antoniou@gmail.com,
	linuxppc-dev@lists.ozlabs.org
Subject: [PATCH net-next] eth: fs_enet: fix print format for resource size
Date: Wed, 14 Jun 2023 20:52:31 -0700
Message-Id: <20230615035231.2184880-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Randy forwarded report from Stephen that on PowerPC:

drivers/net/ethernet/freescale/fs_enet/mii-fec.c: In function 'fs_enet_mdio_probe':
drivers/net/ethernet/freescale/fs_enet/mii-fec.c:130:50: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' {aka 'long long unsigned int'} [-Wformat=]
  130 |         snprintf(new_bus->id, MII_BUS_ID_SIZE, "%x", res.start);
      |                                                 ~^   ~~~~~~~~~
      |                                                  |      |
      |                                                  |      resource_size_t {aka long long unsigned int}
      |                                                  unsigned int
      |                                                 %llx

Use the right print format.

Untested, I can't repro this warning myself. With or without
the patch mpc512x_defconfig builds just fine.

Link: https://lore.kernel.org/all/8f9f8d38-d9c7-9f1b-feb0-103d76902d14@infradead.org/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Randy Dunlap <rdunlap@infradead.org>
CC: pantelis.antoniou@gmail.com
CC: linuxppc-dev@lists.ozlabs.org

Targeting net-next as I can't repro this, and I don't
see recent changes which could cause this problem.
So maybe it's something in linux-next... ?
In any case res is a struct resource so patch shouldn't hurt.
---
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fs_enet/mii-fec.c b/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
index d37d7a19a759..59a8f0bd0f5c 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
@@ -127,7 +127,7 @@ static int fs_enet_mdio_probe(struct platform_device *ofdev)
 	if (ret)
 		goto out_res;
 
-	snprintf(new_bus->id, MII_BUS_ID_SIZE, "%x", res.start);
+	snprintf(new_bus->id, MII_BUS_ID_SIZE, "%pap", &res.start);
 
 	fec->fecp = ioremap(res.start, resource_size(&res));
 	if (!fec->fecp) {
-- 
2.40.1


