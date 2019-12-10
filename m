Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E56A1194DF
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729241AbfLJVNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:13:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729220AbfLJVNN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:13:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C4E3222C4;
        Tue, 10 Dec 2019 21:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012392;
        bh=+dVhmFBSY3GbhTVxM3STKjRvyQehONRqDjgD14b1w0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5VxBckK+rYhBdvGfbn9KJZTXY4X7AWbL8/IweVcFpBauewjCJYFNKjM03nzVCh7j
         Eft/Z4j3Y3fYcyHlRbFJ6mBvQKhQIqnEAxAhUopdwPSfwPURXSVKInkqqHThY3d91K
         MqZwz2fnIcr4b8iqTJzpJnenL4eqtqO0p/4BK3wA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luigi Rizzo <lrizzo@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 313/350] net-af_xdp: Use correct number of channels from ethtool
Date:   Tue, 10 Dec 2019 16:06:58 -0500
Message-Id: <20191210210735.9077-274-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luigi Rizzo <lrizzo@google.com>

[ Upstream commit 3de88c9113f88c04abda339f1aa629397bf89e02 ]

Drivers use different fields to report the number of channels, so take
the maximum of all data channels (rx, tx, combined) when determining the
size of the xsk map. The current code used only 'combined' which was set
to 0 in some drivers e.g. mlx4.

Tested: compiled and run xdpsock -q 3 -r -S on mlx4

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20191119001951.92930-1-lrizzo@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/xsk.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index a73b79d293337..70f9e10de286e 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -344,13 +344,18 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
 		goto out;
 	}
 
-	if (err || channels.max_combined == 0)
+	if (err) {
 		/* If the device says it has no channels, then all traffic
 		 * is sent to a single stream, so max queues = 1.
 		 */
 		ret = 1;
-	else
-		ret = channels.max_combined;
+	} else {
+		/* Take the max of rx, tx, combined. Drivers return
+		 * the number of channels in different ways.
+		 */
+		ret = max(channels.max_rx, channels.max_tx);
+		ret = max(ret, (int)channels.max_combined);
+	}
 
 out:
 	close(fd);
-- 
2.20.1

