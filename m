Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97EDC4C8C5A
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 14:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234076AbiCANQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 08:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiCANQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 08:16:05 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F72986E2F
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 05:15:24 -0800 (PST)
Received: from LAPTOP-CHBRPQ78.localdomain (dynamic-089-012-174-087.89.12.pool.telefonica.de [89.12.174.87])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0C3B420B7178;
        Tue,  1 Mar 2022 05:15:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0C3B420B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1646140523;
        bh=26YqdGESuffqNuXxngcFVRruqvYP/q5h6bFp22GsUuk=;
        h=From:To:Subject:Date:From;
        b=rYe0GS9H+x7FU78HshiCT9lqBxYG1tZ39acAmiuw9WGf+VdHUnhqrCsu5rS+Szs/f
         QZ6hH7HP3xpblmsoFiljtx5n7Y0E5OkWghIbe+WuGbKoHMXT3OOEv50/KDYeYIxHeb
         MWdNnpXdo6p2eUiFYhpqz5CDmAhLGslB4gvDBRC8=
From:   kailueke@linux.microsoft.com
To:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH 1/2] Revert "xfrm: interface with if_id 0 should return error"
Date:   Tue,  1 Mar 2022 14:15:11 +0100
Message-Id: <20220301131512.1303-1-kailueke@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kai Lueke <kailueke@linux.microsoft.com>

This reverts commit 8dce43919566f06e865f7e8949f5c10d8c2493f5 because it
breaks userspace (e.g., Cilium is affected because it used id 0 for the
dummy state https://github.com/cilium/cilium/pull/18789).

Signed-off-by: Kai Lueke <kailueke@linux.microsoft.com>
---
 net/xfrm/xfrm_interface.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 57448fc519fc..41de46b5ffa9 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -637,16 +637,11 @@ static int xfrmi_newlink(struct net *src_net, struct net_device *dev,
 			struct netlink_ext_ack *extack)
 {
 	struct net *net = dev_net(dev);
-	struct xfrm_if_parms p = {};
+	struct xfrm_if_parms p;
 	struct xfrm_if *xi;
 	int err;
 
 	xfrmi_netlink_parms(data, &p);
-	if (!p.if_id) {
-		NL_SET_ERR_MSG(extack, "if_id must be non zero");
-		return -EINVAL;
-	}
-
 	xi = xfrmi_locate(net, &p);
 	if (xi)
 		return -EEXIST;
@@ -671,12 +666,7 @@ static int xfrmi_changelink(struct net_device *dev, struct nlattr *tb[],
 {
 	struct xfrm_if *xi = netdev_priv(dev);
 	struct net *net = xi->net;
-	struct xfrm_if_parms p = {};
-
-	if (!p.if_id) {
-		NL_SET_ERR_MSG(extack, "if_id must be non zero");
-		return -EINVAL;
-	}
+	struct xfrm_if_parms p;
 
 	xfrmi_netlink_parms(data, &p);
 	xi = xfrmi_locate(net, &p);
-- 
2.25.1

