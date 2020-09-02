Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B5025A6DC
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 09:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgIBHgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 03:36:16 -0400
Received: from mga17.intel.com ([192.55.52.151]:18273 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgIBHgP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 03:36:15 -0400
IronPort-SDR: Gzm8M9p0VjTwtxNM4m1mchuyTGS1RnkAWpTnjo4UPmnc4RN6KhXgWTIRT8SV+ntognLNFG9qs/
 SXrSRmovTpNw==
X-IronPort-AV: E=McAfee;i="6000,8403,9731"; a="137389289"
X-IronPort-AV: E=Sophos;i="5.76,381,1592895600"; 
   d="scan'208";a="137389289"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 00:36:12 -0700
IronPort-SDR: nAOcUJcIOifA+jKqrONUgITCnYNh085URfnRhmIhLNSl09VqbI2yH1ce/vqy13gL0iMlT59BLU
 0J34jSp4pR3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,381,1592895600"; 
   d="scan'208";a="446434594"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.56.60])
  by orsmga004.jf.intel.com with ESMTP; 02 Sep 2020 00:36:08 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH bpf-next] xsk: fix use-after-free in failed shared_umem bind
Date:   Wed,  2 Sep 2020 09:36:04 +0200
Message-Id: <1599032164-25684-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix use-after-free when a shared umem bind fails. The code incorrectly
tried to free the allocated buffer pool both in the bind code and then
later also when the socket was released. Fix this by setting the
buffer pool pointer to NULL after the bind code has freed the pool, so
that the socket release code will not try to free the pool. This is
the same solution as the regular, non-shared umem code path has. This
was missing from the shared umem path.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reported-by: syzbot+5334f62e4d22804e646a@syzkaller.appspotmail.com
Fixes: b5aea28dca13 ("xsk: Add shared umem support between queue ids")
---
 net/xdp/xsk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 5eb6662..afd1ca0 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -717,6 +717,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 						   dev, qid);
 			if (err) {
 				xp_destroy(xs->pool);
+				xs->pool = NULL;
 				sockfd_put(sock);
 				goto out_unlock;
 			}
-- 
2.7.4

