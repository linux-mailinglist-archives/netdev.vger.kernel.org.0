Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B70413F37A
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389867AbgAPRLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:11:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:52078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390235AbgAPRL1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:11:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DECB724681;
        Thu, 16 Jan 2020 17:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194686;
        bh=g+lO25LH3EZ+o7YLSHIS8WaJmhR/qz9jeAD7A8xgcGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eyKmAGWVjC9MjaaEZoMfuKhjsS2cGot/gfiISl7jkhJLHHINIF2GSa2dBbz6jg9P0
         od/t9+i+W/lcbemrHBScXrxwq3ZihdCE5s2o2Uyu5m4pe82x5p81GY4KwDTxjtkZHq
         m46s+PRTQBnTGBx7YUSXMaTCVXZMkVneWPHWPI+Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 530/671] xsk: avoid store-tearing when assigning umem
Date:   Thu, 16 Jan 2020 12:02:48 -0500
Message-Id: <20200116170509.12787-267-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

[ Upstream commit 9764f4b301c3e7eb3b75eec85b73cad449cdbb0d ]

The umem member of struct xdp_sock is read outside of the control
mutex, in the mmap implementation, and needs a WRITE_ONCE to avoid
potential store-tearing.

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Fixes: 423f38329d26 ("xsk: add umem fill queue support and mmap")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index b580078f04d1..72caa4fb13f4 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -454,7 +454,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		}
 
 		xdp_get_umem(umem_xs->umem);
-		xs->umem = umem_xs->umem;
+		WRITE_ONCE(xs->umem, umem_xs->umem);
 		sockfd_put(sock);
 	} else if (!xs->umem || !xdp_umem_validate_queues(xs->umem)) {
 		err = -EINVAL;
@@ -534,7 +534,7 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 
 		/* Make sure umem is ready before it can be seen by others */
 		smp_wmb();
-		xs->umem = umem;
+		WRITE_ONCE(xs->umem, umem);
 		mutex_unlock(&xs->mutex);
 		return 0;
 	}
-- 
2.20.1

