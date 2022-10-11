Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B86E95FADC5
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 09:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiJKHu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 03:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiJKHuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 03:50:25 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A66D4DF1D;
        Tue, 11 Oct 2022 00:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1665474623; x=1697010623;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+cmDyXYVJNoOF85exIqwvDJu96CLr9WhKIU4syGquOg=;
  b=icpJB+sOtdvzQtXp0cmZkxDrb9Kz03D0asVBrGd/GAMG4cfola1ki/dq
   c9xg4yHVa/ysQOhvzU3CsAIwdvaiAghzaE3ahJJLIbBDyozpq77AJKIAE
   x9F408++AlTdjTaXEbaLAW1N+m+N0qIF0sIDX5Lz3DLQ+S7LvNWHYrbUO
   7uZs9P2rKe3ZP26+Z4qiwUaKDT+RR6ElLAPKfT4rJjHZ4S5Zy3msbn7zO
   i04ACeCpyS75XMb3FSE8RSiWJxvy4vsv6kuPYeUJrPXHreHJRIq6Wcx4G
   BPTUgc6FfvZXAzKabSlabEkaBY9IbjEC8PZNdbxLgjmm2ZKSJ3XZ/ajl2
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,175,1661810400"; 
   d="scan'208";a="26670691"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 11 Oct 2022 09:50:21 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Tue, 11 Oct 2022 09:50:21 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Tue, 11 Oct 2022 09:50:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1665474621; x=1697010621;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+cmDyXYVJNoOF85exIqwvDJu96CLr9WhKIU4syGquOg=;
  b=V1RvZ8NCSPOCSSJE92RFjxo36j577Igg8tXg3RMP3e0ykpSBwKy7r5gx
   77sXuRlp6jwS7N8Y/avjmTJSaWhpj/AruScs9OARl4KzfB3R+yfegrvTE
   u58k4FxPK9V+fTN+aw6gTiAqPi+G9lSRcGUpkak1V/LEouRXoqjublzUQ
   9prWRYekeY4AwCDsIDEabfWWKQPW20AiIZC/h33LIONquUMdYpXNxVq9g
   AdgogBBtIsGF0FZNGS8FtJVNQv1RGDkWBVouGYqD10g9PXPnsuZMhVwRC
   WJxX9HDit4K9aVC849bpod/igEkYyK3Qao1PjgSWyezcUMxv9kyHEuEBz
   A==;
X-IronPort-AV: E=Sophos;i="5.95,175,1661810400"; 
   d="scan'208";a="26670690"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 11 Oct 2022 09:50:21 +0200
Received: from localhost.localdomain (SCHIFFERM-M2.tq-net.de [10.121.49.14])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id D7092280056;
        Tue, 11 Oct 2022 09:50:20 +0200 (CEST)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Siddharth Vadapalli <s-vadapalli@ti.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [PATCH net] net: ethernet: ti: am65-cpsw: set correct devlink flavour for unused ports
Date:   Tue, 11 Oct 2022 09:50:02 +0200
Message-Id: <20221011075002.3887-1-matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

am65_cpsw_nuss_register_ndevs() skips calling devlink_port_type_eth_set()
for ports without assigned netdev, triggering the following warning when
DEVLINK_PORT_TYPE_WARN_TIMEOUT elapses after 3600s:

    Type was not set for devlink port.
    WARNING: CPU: 0 PID: 129 at net/core/devlink.c:8095 devlink_port_type_warn+0x18/0x30

Fixes: 0680e20af5fb ("net: ethernet: ti: am65-cpsw: Fix devlink port register sequence")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 3cbe4ec46234..7f86068f3ff6 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2476,7 +2476,10 @@ static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
 		port = am65_common_get_port(common, i);
 		dl_port = &port->devlink_port;
 
-		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+		if (port->ndev)
+			attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+		else
+			attrs.flavour = DEVLINK_PORT_FLAVOUR_UNUSED;
 		attrs.phys.port_number = port->port_id;
 		attrs.switch_id.id_len = sizeof(resource_size_t);
 		memcpy(attrs.switch_id.id, common->switch_id, attrs.switch_id.id_len);
-- 
2.25.1

