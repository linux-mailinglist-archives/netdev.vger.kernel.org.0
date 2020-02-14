Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA61B15DF6C
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390934AbgBNQIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:08:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:60298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390925AbgBNQIY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:08:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69CEE222C2;
        Fri, 14 Feb 2020 16:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696504;
        bh=nX975cmkEA4sifV9b0KMKOPMIxYt2YzC5TeY+ulhTIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mDAqPcG0JEq3bN6ayGwpe3pmQrVIfo7QhzHO5Uy7ShVpwcrGcfnEqS3Lvr/J3Yg/O
         H/wEV5RaFN9JOWo3om/WPo30ZeZurm4LSrSY2Hl4W3eXgJFIJ4OLAeEw7IP0wXi9tE
         6hf85NA59GdsnvPdTJUwVGdezBpwtHAQjCsGp1s4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li RongQing <lirongqing@baidu.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 307/459] bpf: Return -EBADRQC for invalid map type in __bpf_tx_xdp_map
Date:   Fri, 14 Feb 2020 10:59:17 -0500
Message-Id: <20200214160149.11681-307-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 0a29275b6300f39f78a87f2038bbfe5bdbaeca47 ]

A negative value should be returned if map->map_type is invalid
although that is impossible now, but if we run into such situation
in future, then xdpbuff could be leaked.

Daniel Borkmann suggested:

-EBADRQC should be returned to stay consistent with generic XDP
for the tracepoint output and not to be confused with -EOPNOTSUPP
from other locations like dev_map_enqueue() when ndo_xdp_xmit is
missing and such.

Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/1578618277-18085-1-git-send-email-lirongqing@baidu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 1a78d64096bbd..d59dbc88fef5d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3543,7 +3543,7 @@ static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
 		return err;
 	}
 	default:
-		break;
+		return -EBADRQC;
 	}
 	return 0;
 }
-- 
2.20.1

