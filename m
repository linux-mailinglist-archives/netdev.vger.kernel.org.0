Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93BCA4D3692
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbiCIQhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:37:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234410AbiCIQcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:32:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCA01AAFFA;
        Wed,  9 Mar 2022 08:28:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FAEBB82254;
        Wed,  9 Mar 2022 16:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33625C340F5;
        Wed,  9 Mar 2022 16:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646843283;
        bh=ORgOXrbErGzG4bsiU02n8K34kQWixB1gzAnSuiyDSKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=am36o434kzymKcYxH5Bw8aHKBJ7ICH8gE8r4hb1tRzgu2yt7lVpZigThN5gshqrmA
         24L8ngu04yAPRPMNUwPJ4R3hM4ujaqr3WKwiU6MgjE99vewQdxf+amd4spKFMYpw8/
         B+YtzIfieHe9YXXP92zyagRYgtzdskUeqUSWT8aTjgyFfnZTlPAVr7O+1borBMLllE
         1VTkM3hGc4vnS55KwJCs6bf7yU7gJfKv3XkfnCOmfQ1Ni9lhaBjxLqgBnSAVIpDoSM
         dp0bwt+OjZ/CjbG4VrPp9HCa7emQyMlsvI2nHvVG/XV+BqUhxPd8f+2Fez0Bg9vgpu
         jdKAY5W13TdDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niels Dossche <dossche.niels@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, ecree.xilinx@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 09/11] sfc: extend the locking on mcdi->seqno
Date:   Wed,  9 Mar 2022 11:27:14 -0500
Message-Id: <20220309162716.137399-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309162716.137399-1-sashal@kernel.org>
References: <20220309162716.137399-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Niels Dossche <dossche.niels@gmail.com>

[ Upstream commit f1fb205efb0ccca55626fd4ef38570dd16b44719 ]

seqno could be read as a stale value outside of the lock. The lock is
already acquired to protect the modification of seqno against a possible
race condition. Place the reading of this value also inside this locking
to protect it against a possible race condition.

Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/mcdi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index 241520943ada..221798499e24 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -162,9 +162,9 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
 	/* Serialise with efx_mcdi_ev_cpl() and efx_mcdi_ev_death() */
 	spin_lock_bh(&mcdi->iface_lock);
 	++mcdi->seqno;
+	seqno = mcdi->seqno & SEQ_MASK;
 	spin_unlock_bh(&mcdi->iface_lock);
 
-	seqno = mcdi->seqno & SEQ_MASK;
 	xflags = 0;
 	if (mcdi->mode == MCDI_MODE_EVENTS)
 		xflags |= MCDI_HEADER_XFLAGS_EVREQ;
-- 
2.34.1

