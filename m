Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B72A6D2EC6
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 08:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbjDAGnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 02:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjDAGny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 02:43:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22201D861;
        Fri, 31 Mar 2023 23:43:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 589BC60B27;
        Sat,  1 Apr 2023 06:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E23CC433EF;
        Sat,  1 Apr 2023 06:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680331431;
        bh=c36lwFwHZ8G1e703Idi7Ck6uKneXMSQqAbeazYyyj3w=;
        h=From:Date:Subject:To:Cc:From;
        b=N2hLYYxim4fCGv6fI0Tr8vSVihXiwc8OXIBTgI1F78It1BDze18bhbwKmE91unR6B
         zhxVXCovtoBsOFIIPOApE766CTypgR+oua2Zr1EZbFr7Mv3DgET1VUic2T5EfqYC1c
         UQQU8cGmRzMJY9hcUMWlSF5bRC0EiJxT8t26hRATR7zPHkG4Rw4ZNI39OUhh4EQYZM
         6tgXRtvAnysW6ZUDTWxv3DtwRujICEeXcfk3UgVOEGaKVtG68Gn7hstg0QTszFuqqW
         S+AEjw8+43WR/TCzGCmZTVD90jg3YWfB0+JLo+Y8mXXI6loHvmp3EG1t/jIGPauJay
         zccTD4auJs8rw==
From:   Simon Horman <horms@kernel.org>
Date:   Sat, 01 Apr 2023 08:43:44 +0200
Subject: [PATCH] net: ethernet: mtk_eth_soc: use be32 type to store be32
 values
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230401-mtk_eth_soc-sparse-v1-1-84e9fc7b8eab@kernel.org>
X-B4-Tracking: v=1; b=H4sIAJ/SJ2QC/x2N0QrCMAwAf2Xk2UK2DhR/RWSkXWaDsxvJFGHs3
 w0+3sFxOxirsMG12UH5IyZLdWhPDeRC9cFBRmfosIvYYxte23PgrQy25GArqXHAnmLCMZ/jZQI
 PE7lMSjUXT+t7nl2uypN8/6fb/Th+IRJA0nkAAAA=
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Perhaps there is a nicer way to handle this but the code
calls for converting an array of host byte order 32bit values
to big endian 32bit values: an ipv6 address to be pretty printed.

Use a sparse-friendly array of be32 to store these values.

Also make use of the cpu_to_be32_array helper rather
than open coding the conversion.

Flagged by sparse:
  drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c:59:27: warning: incorrect type in assignment (different base types)
  drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c:59:27:    expected unsigned int
  drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c:59:27:    got restricted __be32 [usertype]
  drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c:161:46: warning: cast to restricted __be16

No functional changes intended.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
index 53cf87e9acbb..1e0bb8cee7c4 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
@@ -47,16 +47,14 @@ static const char *mtk_foe_pkt_type_str(int type)
 static void
 mtk_print_addr(struct seq_file *m, u32 *addr, bool ipv6)
 {
-	u32 n_addr[4];
-	int i;
+	__be32 n_addr[4];
 
 	if (!ipv6) {
 		seq_printf(m, "%pI4h", addr);
 		return;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(n_addr); i++)
-		n_addr[i] = htonl(addr[i]);
+	cpu_to_be32_array(n_addr, addr, 4);
 	seq_printf(m, "%pI6", n_addr);
 }
 

