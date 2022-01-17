Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A658490F85
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238885AbiAQRaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238899AbiAQR35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:29:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609B6C06161C;
        Mon, 17 Jan 2022 09:29:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21156B81145;
        Mon, 17 Jan 2022 17:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D4BC36AE7;
        Mon, 17 Jan 2022 17:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642440595;
        bh=15+BiTTsA5/Onio0uVK22qT9zUs0TrcJ9EIg2grNdQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M8nUNs+89uA5jw7KCjSgxRziv1HjYnuR8pKl6Ury4PPTEsEqBifZAFRaaU1QEovDE
         ds1EDH2lUhlObebDwWggqeqnSQW47/Mbd3YaqBOAW5RTKcR1U/JkRTlvNsklqlTZqh
         Zczktsi/HHjQNwuq8qHphelDESFSIJPo4/GKlcpWn3pdRprB8Kj15f1IxY3dRYwjw9
         UvdQhyVfIqd+IfUlQOHgVimOquAbttm0hl1t9NzVga4lunhUTkWArj9wMssIOHP3Op
         hNwhJ2kP0+7qy/m4OdPLSmmUFV0F0QHxn5w0nQtC7KGOf+AvXJgWYNrLNY61T8QQoS
         wP9uM1KMJcWgw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v22 bpf-next 10/23] net: mvneta: enable jumbo frames if the loaded XDP program support multi-frags
Date:   Mon, 17 Jan 2022 18:28:22 +0100
Message-Id: <92c72be94538f65f7ea05001923c07b4d443d396.1642439548.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1642439548.git.lorenzo@kernel.org>
References: <cover.1642439548.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the capability to receive jumbo frames even if the interface is
running in XDP mode if the loaded program declare to properly support
xdp multi-frags. At same time reject a xdp program not supporting xdp
multi-frags if the driver is running in xdp multi-frags mode.

Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index c2248e23edcc..fc3d19467de7 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3778,6 +3778,7 @@ static void mvneta_percpu_disable(void *arg)
 static int mvneta_change_mtu(struct net_device *dev, int mtu)
 {
 	struct mvneta_port *pp = netdev_priv(dev);
+	struct bpf_prog *prog = pp->xdp_prog;
 	int ret;
 
 	if (!IS_ALIGNED(MVNETA_RX_PKT_SIZE(mtu), 8)) {
@@ -3786,8 +3787,12 @@ static int mvneta_change_mtu(struct net_device *dev, int mtu)
 		mtu = ALIGN(MVNETA_RX_PKT_SIZE(mtu), 8);
 	}
 
-	if (pp->xdp_prog && mtu > MVNETA_MAX_RX_BUF_SIZE) {
-		netdev_info(dev, "Illegal MTU value %d for XDP mode\n", mtu);
+	if (prog && !prog->aux->xdp_has_frags &&
+	    mtu > MVNETA_MAX_RX_BUF_SIZE) {
+		netdev_info(dev,
+			    "Illegal MTU %d for XDP prog without multi-frags\n",
+			    mtu);
+
 		return -EINVAL;
 	}
 
@@ -4528,8 +4533,10 @@ static int mvneta_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
 	struct mvneta_port *pp = netdev_priv(dev);
 	struct bpf_prog *old_prog;
 
-	if (prog && dev->mtu > MVNETA_MAX_RX_BUF_SIZE) {
-		NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
+	if (prog && !prog->aux->xdp_has_frags &&
+	    dev->mtu > MVNETA_MAX_RX_BUF_SIZE) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "prog does not support XDP multi-frags");
 		return -EOPNOTSUPP;
 	}
 
-- 
2.34.1

