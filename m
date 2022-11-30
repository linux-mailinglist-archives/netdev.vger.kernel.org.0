Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D54863CCD8
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 02:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiK3BbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 20:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiK3BbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 20:31:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4A47209B
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 17:31:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CABAB819B1
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 01:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E5CC433D6;
        Wed, 30 Nov 2022 01:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669771871;
        bh=WdbVcJj9AsKMYsp+xuShcrOeO1GLynlBkYY6R3N62HU=;
        h=From:To:Cc:Subject:Date:From;
        b=HexNqonzL8/Jq+9BSll1MsPD5kOr8qkAHSTSzfiSL2MRoGR8t8P3P3wDB6tTHmSRD
         fJd1NVrTAhIn1krNzs9duGJKSgX5RXU0I490wuG+3r2G4wdURJHFAYstMKvkWLmXHL
         oipEpfNsXVwosyrjXxnA0RnYKohYiuL/KfHB1hMadbc0pU//23Hv9qBwI3QuxycVEf
         osFn7XPV4wWPpf1Js5LN0kBJ7nl7I5l9sql4RfJ6Yhpnfh9QpI8NMA+HqqhHmbmZ+D
         qWeBXIqr8g86vnIYverFaPt1ZjpRYIsXoisZV36bMMUxF0prPs432im7cBy6ZtzNM0
         GOhDKqlEVUGvw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, michael.chan@broadcom.com
Subject: [PATCH net-next] bnxt: report FEC block stats via standard interface
Date:   Tue, 29 Nov 2022 17:31:08 -0800
Message-Id: <20221130013108.90062-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I must have missed that these stats are only exposed
via the unstructured ethtool -S when they got merged.
Plumb in the structured form.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: michael.chan@broadcom.com
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index c2f663770a7f..cbf17fcfb7ab 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2007,6 +2007,14 @@ static void bnxt_get_fec_stats(struct net_device *dev,
 	rx = bp->rx_port_stats_ext.sw_stats;
 	fec_stats->corrected_bits.total =
 		*(rx + BNXT_RX_STATS_EXT_OFFSET(rx_corrected_bits));
+
+	if (bp->fw_rx_stats_ext_size <= BNXT_RX_STATS_EXT_NUM_LEGACY)
+		return;
+
+	fec_stats->corrected_blocks.total =
+		*(rx + BNXT_RX_STATS_EXT_OFFSET(rx_fec_corrected_blocks));
+	fec_stats->uncorrectable_blocks.total =
+		*(rx + BNXT_RX_STATS_EXT_OFFSET(rx_fec_uncorrectable_blocks));
 }
 
 static u32 bnxt_ethtool_forced_fec_to_fw(struct bnxt_link_info *link_info,
-- 
2.38.1

