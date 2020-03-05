Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9AD179F0A
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 06:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgCEFQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 00:16:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:56946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgCEFQm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 00:16:42 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED55E22522;
        Thu,  5 Mar 2020 05:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583385401;
        bh=Pa/VYkwjYDnjD2Oq0ZIuiNy5ba+xHbTXO1VqDHP+bug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HIjx0Hh0j/d0caoza2ZSK0r5XW1oQSm+sQRmSK7/l2xbAMaPNJrDQbK8rcizKI9Mr
         8+xAUhX0oTnHDkA7Oo8U9Z516Sp5BQsaPbVQ695nUFQFnghqqeEz270hKLG9O17nLw
         tZWDtO6tbKB5Wx08KNGooB/qDzEI+sOdOoxKy+gY=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, ecree@solarflare.com, mkubecek@suse.cz,
        thomas.lendacky@amd.com, benve@cisco.com, _govind@gmx.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, snelson@pensando.io, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, alexander.h.duyck@linux.intel.com,
        michael.chan@broadcom.com, saeedm@mellanox.com, leon@kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 12/12] virtio_net: reject unsupported coalescing params
Date:   Wed,  4 Mar 2020 21:15:42 -0800
Message-Id: <20200305051542.991898-13-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305051542.991898-1-kuba@kernel.org>
References: <20200305051542.991898-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set ethtool_ops->supported_coalesce_params to let
the core reject unsupported coalescing parameters.

This driver correctly rejects all unsupported parameters.
As a side effect of these changes the error code for
unsupported params changes from EINVAL to EOPNOTSUPP.

v2: correctly handle rx-frames (and adjust the commit msg)
v3: adjust commit message for new error code and member name

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/virtio_net.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 84c0d9581f93..11f722460513 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2202,23 +2202,14 @@ static int virtnet_get_link_ksettings(struct net_device *dev,
 static int virtnet_set_coalesce(struct net_device *dev,
 				struct ethtool_coalesce *ec)
 {
-	struct ethtool_coalesce ec_default = {
-		.cmd = ETHTOOL_SCOALESCE,
-		.rx_max_coalesced_frames = 1,
-	};
 	struct virtnet_info *vi = netdev_priv(dev);
 	int i, napi_weight;
 
-	if (ec->tx_max_coalesced_frames > 1)
+	if (ec->tx_max_coalesced_frames > 1 ||
+	    ec->rx_max_coalesced_frames != 1)
 		return -EINVAL;
 
-	ec_default.tx_max_coalesced_frames = ec->tx_max_coalesced_frames;
 	napi_weight = ec->tx_max_coalesced_frames ? NAPI_POLL_WEIGHT : 0;
-
-	/* disallow changes to fields not explicitly tested above */
-	if (memcmp(ec, &ec_default, sizeof(ec_default)))
-		return -EINVAL;
-
 	if (napi_weight ^ vi->sq[0].napi.weight) {
 		if (dev->flags & IFF_UP)
 			return -EBUSY;
@@ -2273,6 +2264,7 @@ static void virtnet_update_settings(struct virtnet_info *vi)
 }
 
 static const struct ethtool_ops virtnet_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES,
 	.get_drvinfo = virtnet_get_drvinfo,
 	.get_link = ethtool_op_get_link,
 	.get_ringparam = virtnet_get_ringparam,
-- 
2.24.1

