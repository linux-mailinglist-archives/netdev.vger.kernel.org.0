Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05F95159D3
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbfEGFkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:40:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728701AbfEGFkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:40:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E046216F4;
        Tue,  7 May 2019 05:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207609;
        bh=4w0e8AD+YQReA0xEyQUoCPG8YS56+1X4TPCsy+T+eMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uGXqd2G1U40BHQjE6pMLY0txI6RrL91LbuzJpvXrBbi7JoMC71684NeFOjHSA6la3
         L5VXuAl+/ckU8x9I0kN2Wr3Ts1elnQDcEhPFwbxmk8diwGc31LicA3/XVX5bTbPOFB
         hcLpsBIlN1TCnoQMFDD5CfkXknrEHw1XEdRGcX0c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 53/95] net: don't keep lonely packets forever in the gro hash
Date:   Tue,  7 May 2019 01:37:42 -0400
Message-Id: <20190507053826.31622-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 605108acfe6233b72e2f803aa1cb59a2af3001ca ]

Eric noted that with UDP GRO and NAPI timeout, we could keep a single
UDP packet inside the GRO hash forever, if the related NAPI instance
calls napi_gro_complete() at an higher frequency than the NAPI timeout.
Willem noted that even TCP packets could be trapped there, till the
next retransmission.
This patch tries to address the issue, flushing the old packets -
those with a NAPI_GRO_CB age before the current jiffy - before scheduling
the NAPI timeout. The rationale is that such a timeout should be
well below a jiffy and we are not flushing packets eligible for sane GRO.

v1  -> v2:
 - clarified the commit message and comment

RFC -> v1:
 - added 'Fixes tags', cleaned-up the wording.

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Fixes: 3b47d30396ba ("net: gro: add a per device gro flush timer")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 net/core/dev.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 93a1b07990b8..90ec30d5b851 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5308,11 +5308,14 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 		if (work_done)
 			timeout = n->dev->gro_flush_timeout;
 
+		/* When the NAPI instance uses a timeout and keeps postponing
+		 * it, we need to bound somehow the time packets are kept in
+		 * the GRO layer
+		 */
+		napi_gro_flush(n, !!timeout);
 		if (timeout)
 			hrtimer_start(&n->timer, ns_to_ktime(timeout),
 				      HRTIMER_MODE_REL_PINNED);
-		else
-			napi_gro_flush(n, false);
 	}
 	if (unlikely(!list_empty(&n->poll_list))) {
 		/* If n->poll_list is not empty, we need to mask irqs */
-- 
2.20.1

