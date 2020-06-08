Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7CC1F2BA7
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730695AbgFHXSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:18:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728395AbgFHXSp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:18:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2362620823;
        Mon,  8 Jun 2020 23:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658325;
        bh=sn8Keq0WlrH2oMOMaqzuef1suUNEu90hJWl2+RdW0To=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lz+X0UzdbPgLWiR3vCKPD2v4+VAoYznhAOGMECW6TDFv/2wzfxorCDyr2Dd4mHeud
         2tjkXrMsNnKKv9IusGEKjJtky1ia86xR72srLGpN1elGvN/QlWwHViMXnSX83g+RQ0
         mPxd5Vo9pft9ZDIKJuIzArBwQ+/LEJNOCwUSz1aE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jerry Lee <leisurelysw24@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 325/606] libceph: ignore pool overlay and cache logic on redirects
Date:   Mon,  8 Jun 2020 19:07:30 -0400
Message-Id: <20200608231211.3363633-325-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jerry Lee <leisurelysw24@gmail.com>

[ Upstream commit 890bd0f8997ae6ac0a367dd5146154a3963306dd ]

OSD client should ignore cache/overlay flag if got redirect reply.
Otherwise, the client hangs when the cache tier is in forward mode.

[ idryomov: Redirects are effectively deprecated and no longer
  used or tested.  The original tiering modes based on redirects
  are inherently flawed because redirects can race and reorder,
  potentially resulting in data corruption.  The new proxy and
  readproxy tiering modes should be used instead of forward and
  readforward.  Still marking for stable as obviously correct,
  though. ]

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/23296
URL: https://tracker.ceph.com/issues/36406
Signed-off-by: Jerry Lee <leisurelysw24@gmail.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/osd_client.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index af868d3923b9..834019dbc6b1 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -3652,7 +3652,9 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
 		 * supported.
 		 */
 		req->r_t.target_oloc.pool = m.redirect.oloc.pool;
-		req->r_flags |= CEPH_OSD_FLAG_REDIRECTED;
+		req->r_flags |= CEPH_OSD_FLAG_REDIRECTED |
+				CEPH_OSD_FLAG_IGNORE_OVERLAY |
+				CEPH_OSD_FLAG_IGNORE_CACHE;
 		req->r_tid = 0;
 		__submit_request(req, false);
 		goto out_unlock_osdc;
-- 
2.25.1

