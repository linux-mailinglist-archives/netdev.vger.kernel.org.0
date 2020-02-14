Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16A5515E0AF
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392361AbgBNQOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:14:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:44302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404030AbgBNQOj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:14:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A34B246CF;
        Fri, 14 Feb 2020 16:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696879;
        bh=k4MAyLiQvbkcRfoaIpeTeeZXxVI0Sn7O1+qJM6lHONc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m2W2O6GML+mVVMqtgq3g77n+Z1ooW8bU8AzqoWQZ/bzA01+u0Bm1eV65WUMZa+loT
         3j2tl3rmgNX0wApQ/8DmlyRyTbWqEGmTPx+63zJKDinqYiFaSpnoME3Neap/Guiybe
         VkDl+5VWLP71P0WDC1v1PCzku5evyLuShjUFPWec=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Adhemerval Zanella <adhemerval.zanella@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 134/252] mlx5: work around high stack usage with gcc
Date:   Fri, 14 Feb 2020 11:09:49 -0500
Message-Id: <20200214161147.15842-134-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 42ae1a5c76691928ed217c7e40269db27f5225e9 ]

In some configurations, gcc tries too hard to optimize this code:

drivers/net/ethernet/mellanox/mlx5/core/en_stats.c: In function 'mlx5e_grp_sw_update_stats':
drivers/net/ethernet/mellanox/mlx5/core/en_stats.c:302:1: error: the frame size of 1336 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

As was stated in the bug report, the reason is that gcc runs into a corner
case in the register allocator that is rather hard to fix in a good way.

As there is an easy way to work around it, just add a comment and the
barrier that stops gcc from trying to overoptimize the function.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=92657
Cc: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 8255d797ea943..9a68dee588c1a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -211,6 +211,9 @@ void mlx5e_grp_sw_update_stats(struct mlx5e_priv *priv)
 			s->tx_tls_resync_bytes	+= sq_stats->tls_resync_bytes;
 #endif
 			s->tx_cqes		+= sq_stats->cqes;
+
+			/* https://gcc.gnu.org/bugzilla/show_bug.cgi?id=92657 */
+			barrier();
 		}
 	}
 
-- 
2.20.1

