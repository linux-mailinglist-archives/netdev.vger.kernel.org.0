Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3859540F17E
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 06:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244728AbhIQE4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 00:56:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231462AbhIQE4O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 00:56:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F58560F92;
        Fri, 17 Sep 2021 04:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631854493;
        bh=epGIe7Xmru8ybFQY3hEOWF1YwlANoRaxzAVPbzDag28=;
        h=From:To:Cc:Subject:Date:From;
        b=aIE9YuTaa1LMWJAFa1QmyJoNgRMuBUFRJsshM6mw83AFyqVSFAiw/dQicv1LfcqKj
         a64IRNdoS7KAyIR8N6lqPB1zxofJBNV3hvKJXTNVvUc4ptVQGOzXkHo2KwU6+lTocV
         TWUPAmMG1UqRS2w6sjErQSnn6/xxTUFxAFR1uGU9kcsiT97LsziOuzGh+iZMa5ArPZ
         gm//DTFqYtIDCViY5+PFL6XQgaPpDEetG0NSUa8w20OVn9kurLpmA3BB1vXJpPrt6X
         WHExBjeM3P+pzAcQEfqztyKqTWKiklYJ0U9qGfxEiv5HogNHrK/VkecOK+NzUdkz6G
         qwPdkSpioPjqg==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH net-next v2] ptp: ocp: Avoid operator precedence warning in ptp_ocp_summary_show()
Date:   Thu, 16 Sep 2021 21:52:05 -0700
Message-Id: <20210917045204.1385801-1-nathan@kernel.org>
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

on and map are both booleans so this should be a logical AND, which
clears up the operator precedence issue.

Fixes: a62a56d04e63 ("ptp: ocp: Enable 4th timestamper / PPS generator")
Link: https://github.com/ClangBuiltLinux/linux/issues/1457
Suggested-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---

v1 -> v2: https://lore.kernel.org/r/20210916194351.3860836-1-nathan@kernel.org/

* Change fix from adding parentheses to moving from bitwise to logical
  AND. Thanks to Jonathan for catching that both operands were boolean,
  which I unfortunately missed.

 drivers/ptp/ptp_ocp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 844b1401cc5d..c26708f486cf 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -2062,11 +2062,11 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 		on = ioread32(&ts_reg->enable);
 		map = !!(bp->pps_req_map & OCP_REQ_TIMESTAMP);
 		seq_printf(s, "%7s: %s, src: %s\n", "TS3",
-			   on & map ? " ON" : "OFF", src);
+			   on && map ? " ON" : "OFF", src);
 
 		map = !!(bp->pps_req_map & OCP_REQ_PPS);
 		seq_printf(s, "%7s: %s, src: %s\n", "PPS",
-			   on & map ? " ON" : "OFF", src);
+			   on && map ? " ON" : "OFF", src);
 	}
 
 	if (bp->irig_out) {

base-commit: 8dc84dcd7f74b50f81de3dbf6f6b5b146e3a8eea
-- 
2.33.0

