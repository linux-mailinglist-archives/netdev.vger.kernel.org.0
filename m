Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D019B509D3D
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 12:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388218AbiDUKR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 06:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388288AbiDUKRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 06:17:17 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7A92CCA6;
        Thu, 21 Apr 2022 03:14:17 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 544DEE000C;
        Thu, 21 Apr 2022 10:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650536055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=an69hgvRkZo4fDphZoWRjZyAXfGzKRGmPZzwE3TFtww=;
        b=UVU1MzSboPYmjJnNfcM3Qk71BBGbWaDl9mydrmQzASqiNP//6Bi6Fu7YwJTbLVt6SLIql3
        2hUt6A5FNi+3wHF/DKZC3lnjDm378xiXMZKwensfWYZ7kwrQY1tBsq5+o1M0bNXD+WOp0l
        0NKFeqwrqVqtEbBAcMb+LrMHJ7mb2mjJqnKBFspRVFslA63voqp+i1j0sS5AxTeGQWVolD
        S3OMLJ5aW690aZdHUX2lgVPqt20ErhXno7ixftgee6PvkgoWMEAj+rz6NbczFSA+n5f7/A
        3gD59XFMH3ld/VwWT4vyP8YjlG3rdn4sdY2RvHOcQC88fE90XMBL+LBbzWNMGQ==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Cc:     bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
Subject: [PATCH net-next] net: bridge: switchdev: check br_vlan_group() return value
Date:   Thu, 21 Apr 2022 12:12:47 +0200
Message-Id: <20220421101247.121896-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

br_vlan_group() can return NULL and thus return value must be checked
to avoid dereferencing a NULL pointer.

Fixes: 6284c723d9b9 ("net: bridge: mst: Notify switchdev drivers of VLAN MSTI migrations")
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 net/bridge/br_switchdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 81400e0b26ac..8f3d76c751dd 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -354,6 +354,8 @@ static int br_switchdev_vlan_attr_replay(struct net_device *br_dev,
 	attr.orig_dev = br_dev;
 
 	vg = br_vlan_group(br);
+	if (!vg)
+		return 0;
 
 	list_for_each_entry(v, &vg->vlan_list, vlist) {
 		if (v->msti) {
-- 
2.34.1

