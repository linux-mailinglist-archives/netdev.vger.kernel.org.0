Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C464746C6
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 16:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235428AbhLNPra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 10:47:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52804 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbhLNPra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 10:47:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6F40B81AC8
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 15:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874D0C34606;
        Tue, 14 Dec 2021 15:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639496847;
        bh=lnSS8G9fve9eNxGR3MKCXI/P+AzpakFVt9aJ0XDKPcY=;
        h=From:To:Cc:Subject:Date:From;
        b=SkYBiUUop6gmlTe39PVrDxGpN65h4y5Dsd3k/FOA2xiK0Kl8pHEdSIenWjDHM/3ia
         LsWwei1Tqy099AgN9MXaydugUpnlmSEsnLFCiQMwqrJIq803Ag4UUhYddVzJuMJCWV
         ST+oKPAzB/hVU6X1vTZR1+rL0jbZX28UcVbNn8WljpKHbfMB+H+zSAR/optESbthrY
         g/RYIdPJ4bvdIzWIStRWXKDOaOw+DxLojpZX0iwk4qYvP9iPkKbWHz5T+EWXSPBlyT
         RwDJnbwkPjG8YebCJTPL6/CRUsTmTABXtK3fkdsL1DZRWEqGlGhXlR8HFNE2fI1Ug4
         YAJ+sX7bOinEA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] ethtool: always write dev in ethnl_parse_header_dev_get
Date:   Tue, 14 Dec 2021 07:47:25 -0800
Message-Id: <20211214154725.451682-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 0976b888a150 ("ethtool: fix null-ptr-deref on ref tracker")
made the write to req_info.dev conditional, but as Eric points out
in a different follow up the structure is often allocated on the
stack and not kzalloc()'d so seems safer to always write the dev,
in case it's garbage on input.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/netlink.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 767fb3f17267..f09c62302a9a 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -141,10 +141,9 @@ int ethnl_parse_header_dev_get(struct ethnl_req_info *req_info,
 		return -EINVAL;
 	}
 
-	if (dev) {
-		req_info->dev = dev;
+	req_info->dev = dev;
+	if (dev)
 		netdev_tracker_alloc(dev, &req_info->dev_tracker, GFP_KERNEL);
-	}
 	req_info->flags = flags;
 	return 0;
 }
-- 
2.31.1

