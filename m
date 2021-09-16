Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2DA40EAFC
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 21:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbhIPTp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 15:45:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230267AbhIPTpZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 15:45:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2574561250;
        Thu, 16 Sep 2021 19:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631821445;
        bh=g9tCXJ+38jYZWrC5j09nXQRZrL0lHKFk7H/DYbskE58=;
        h=From:To:Cc:Subject:Date:From;
        b=ohumdK34ws0N80Ht4JKesg/9Fyndg/zhf6+PZXShmjVj2syRDL1NsN+BZu4dqOIFs
         wU17mrq4r9WA2+Y+vCEPFWVYsZnqGuEKGpQBU28EnoNWAs1Wf3bEbPOymcL8juWJq7
         a79JnVwGbPsPyqX1ScLkjQCcZO9bkm3bCDM+VPql8Q8d0+HeGjpxR1DHkHiOKR02a8
         AAGIQTFr34zjyrdJxJZfpm3NI+6ewoerWDCYLzaxSlr2uxGWBwjifZMtccBb0KbFhd
         LNG/QJ3elXpVdPiJHJuHvGMMb+1gEK0FCkNGyKZ0agtF1KPaJ9tkKeP//EZe4agWyv
         plk7QEsLNoLbQ==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] ptp: ocp: Avoid operator precedence warning in ptp_ocp_summary_show()
Date:   Thu, 16 Sep 2021 12:43:51 -0700
Message-Id: <20210916194351.3860836-1-nathan@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns twice:

drivers/ptp/ptp_ocp.c:2065:16: error: operator '?:' has lower precedence
than '&'; '&' will be evaluated first
[-Werror,-Wbitwise-conditional-parentheses]
                           on & map ? " ON" : "OFF", src);
                           ~~~~~~~~ ^
drivers/ptp/ptp_ocp.c:2065:16: note: place parentheses around the '&'
expression to silence this warning
                           on & map ? " ON" : "OFF", src);
                                    ^
                           (       )
drivers/ptp/ptp_ocp.c:2065:16: note: place parentheses around the '?:'
expression to evaluate it first
                           on & map ? " ON" : "OFF", src);
                                    ^

It is clearly intentional that the bitwise operation be done before the
ternary operation so add the parentheses as it suggests to fix the
warning.

Fixes: a62a56d04e63 ("ptp: ocp: Enable 4th timestamper / PPS generator")
Link: https://github.com/ClangBuiltLinux/linux/issues/1457
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/ptp/ptp_ocp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 844b1401cc5d..4ba3fb254a92 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -2062,11 +2062,11 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 		on = ioread32(&ts_reg->enable);
 		map = !!(bp->pps_req_map & OCP_REQ_TIMESTAMP);
 		seq_printf(s, "%7s: %s, src: %s\n", "TS3",
-			   on & map ? " ON" : "OFF", src);
+			   (on & map) ? " ON" : "OFF", src);
 
 		map = !!(bp->pps_req_map & OCP_REQ_PPS);
 		seq_printf(s, "%7s: %s, src: %s\n", "PPS",
-			   on & map ? " ON" : "OFF", src);
+			   (on & map) ? " ON" : "OFF", src);
 	}
 
 	if (bp->irig_out) {

base-commit: 4b5a3ab17c6c942bd428984b6b37fe3c07f18ab3
-- 
2.33.0

