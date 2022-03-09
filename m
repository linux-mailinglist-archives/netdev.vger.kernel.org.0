Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F58F4D3636
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236464AbiCIQfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239350AbiCIQc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:32:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66D75C67C;
        Wed,  9 Mar 2022 08:27:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD178619CB;
        Wed,  9 Mar 2022 16:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB24C340E8;
        Wed,  9 Mar 2022 16:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646843228;
        bh=QCLclt6Podyl2puOmDCwjqlOCtweKVJusbddgI3eqP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tIAW+lo7vhusB6KoDLoW3jWYN/m3VtExOALBBDl19X06X4b+9EcntmAYgr2ZmPtEA
         J8JcApzk9eCFWMN2YprM+KjecSnc2ZzwiB0rB7ZjepCBa9Ed1GvcwVD4dau6xIPGFc
         rY7NTeHQ5yd9vgOkS8YFsP+f0kUMwSPsmvWZ64Znyx8Qnly5r2EMbpbIjb3JK5pK5r
         2BlR6elHsxAniqXj535EvacB66QtH/cvnU/3as+F4rc2stPsG6v5LZ5JR9qp5St9zp
         PCQewoO40GgOD8v+8wE2aoHNC5tdR7TtYjSe/AKpxgMmgJOFiZWlLXuazJWwbvAJGL
         +xwVxBg3EDztQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niels Dossche <dossche.niels@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, ecree.xilinx@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 10/12] sfc: extend the locking on mcdi->seqno
Date:   Wed,  9 Mar 2022 11:26:15 -0500
Message-Id: <20220309162618.137226-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309162618.137226-1-sashal@kernel.org>
References: <20220309162618.137226-1-sashal@kernel.org>
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
index 3df872f56289..040b52affe19 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -167,9 +167,9 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
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

