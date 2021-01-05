Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B38A2EB04F
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 17:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbhAEQjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 11:39:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:42194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727634AbhAEQjX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 11:39:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE68622CB2;
        Tue,  5 Jan 2021 16:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609864722;
        bh=AZsYT3WyOPdgefr1asV0HQb5amex5khUr1Dq73rnLfw=;
        h=From:To:Cc:Subject:Date:From;
        b=vOdWHMjiyq2wF4+oN2GF0jb1DY0wN0+oWG9Ozpzlr2TX6uGZ92oCOMD9jx+lvpZ6M
         c/Grrkf2iiWMVoD4jZQbf47QP6eIPlsY79FDox6jd14NKS0AnT5tH7J3dw4FrdYesc
         iBfyaSfRmswfuI1VVwvh3h3x+a/TY17RUrKrlk24yBZfJ01lWIAlqsmIkS/DH9XEj1
         FNT7Lc6MZ0ZOvJ0ujzPJwtJv+tVfvk7fL1S5oZz2WkQhntLQK/fcHMZ9fWmnXrZsJV
         R9oZTawhioWLOc/XS4Xt4TibKm7VkknSR8jODE+jasJHcucJlsOAL2Lyw9tfULkEjX
         G1bsQDPSEfAWw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH net-next] net: mvneta: fix error message when MTU too large for XDP
Date:   Tue,  5 Jan 2021 17:38:33 +0100
Message-Id: <20210105163833.389-1-kabel@kernel.org>
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
index 563ceac3060f..8adbfa25465d 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4432,7 +4432,7 @@ static int mvneta_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
 	struct bpf_prog *old_prog;
 
 	if (prog && dev->mtu > MVNETA_MAX_RX_BUF_SIZE) {
-		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not supported on XDP");
+		NL_SET_ERR_MSG_MOD(extack, "XDP is not supported with MTU > %d", dev->mtu);
 		return -EOPNOTSUPP;
 	}
 
-- 
2.26.2

