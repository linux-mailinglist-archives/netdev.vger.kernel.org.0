Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7AFB642014
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 23:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiLDWdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 17:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbiLDWdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 17:33:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD0212AA1
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 14:33:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 12FD7CE0DAF
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 22:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F35C433C1;
        Sun,  4 Dec 2022 22:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670193223;
        bh=+0QtgXN+0MZgMMeAJoPIpwQGerbLrFQzMJqdU8FoSvA=;
        h=From:To:Cc:Subject:Date:From;
        b=VCXWCEvNVkxLONIDP7yt78uzPFoIEbFxfAoFoGa3hor7XZvUph0zbA9WbeoUKiWpw
         gZG5Vi5XhLCZU/JwppswzbXaVYCwRY0WPsm43IchvkHmqvWwADQfxRGhmCFmpoq4MB
         i8IApMMJiFBgTiBz7BJDoJdU1+qDtZ7yQUBDQObdeRb9acJ/qKa0boatq1+Iu4uJwo
         xDeevXUu11vU37C1W9KfVmptzWijxZJzWyXlFmhVAwwfWNbuKH00IXU/dmUphwizHr
         qxz7EHtqMgSfkQKxb+hwleqQHhghXzSEVVGi7nJ4MfvyiwmDepP9EYUruGC73WiDTN
         k73HLpHB0fd6g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     claudiu.manoil@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        vladimir.oltean@nxp.com
Subject: [PATCH net-next] net: ethernet: enetc: set frag flag for non-linear xdp buffers
Date:   Sun,  4 Dec 2022 23:33:23 +0100
Message-Id: <df882eddcf76b5d0ae53c19f368a617713462fd3.1670193080.git.lorenzo@kernel.org>
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

Set missing XDP_FLAGS_HAS_FRAGS bit in enetc_add_rx_buff_to_xdp for
non-linear xdp buffers.

Fixes: d1b15102dd16 ("net: enetc: add support for XDP_DROP and XDP_PASS")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 8671591cb750..6d08ee2233aa 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1416,6 +1416,8 @@ static void enetc_add_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
 	skb_frag_size_set(frag, size);
 	__skb_frag_set_page(frag, rx_swbd->page);
 
+	if (!xdp_buff_has_frags(xdp_buff))
+		xdp_buff_set_frags_flag(xdp_buff);
 	shinfo->nr_frags++;
 }
 
-- 
2.38.1

