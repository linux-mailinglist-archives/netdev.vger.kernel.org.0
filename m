Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2ADC2EB14E
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 18:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730151AbhAERYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 12:24:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:49690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728044AbhAERYU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 12:24:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9775222D50;
        Tue,  5 Jan 2021 17:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609867419;
        bh=/I2LEf0YHc0yAeBZLCJt9PxhbuBQaA0IAgMbgihdcM4=;
        h=From:To:Cc:Subject:Date:From;
        b=f822nuWRCGwPvkTtoP8vvu54TCYQw+3aSQ81iD5nq0mswotTvqOGUf/cudWvQHwW6
         GbusBj6NPT+rP1pigpTC9Hk4a4ea7n0Gv2wDrLR85sr+xOvDV9Fcnh2neeAaIQeylR
         h9/fqUzpM1Ggs1dNYuDI7/Iq+qc2M8mRtnKptNuvlRzT6J2of01vOPZ8AAC/5WGUmb
         BBZW4mzJgIQAkawZeISzaLVH4veNS3oNqZk+I9O0Qeyr43me+tIb4CA5ehGnzJW2KW
         ijLcN2IjVFIXu4L7y8wfbgynGGi2ojdtIplJdbrYNg4OqaObGQ2H4IJZ619uraCi1+
         S0rRisCfsjwtA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH net-next v2] net: mvneta: fix error message when MTU too large for XDP
Date:   Tue,  5 Jan 2021 18:23:33 +0100
Message-Id: <20210105172333.21613-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error message says that "Jumbo frames are not supported on XDP", but
the code checks for mtu > MVNETA_MAX_RX_BUF_SIZE, not mtu > 1500.

Fix this error message.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: 0db51da7a8e9 ("net: mvneta: add basic XDP support")
Cc: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 563ceac3060f..e11292bd60a8 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4432,7 +4432,7 @@ static int mvneta_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
 	struct bpf_prog *old_prog;
 
 	if (prog && dev->mtu > MVNETA_MAX_RX_BUF_SIZE) {
-		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not supported on XDP");
+		NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
 		return -EOPNOTSUPP;
 	}
 
-- 
2.26.2

