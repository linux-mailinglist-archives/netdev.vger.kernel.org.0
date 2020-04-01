Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBAEC19A927
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 12:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbgDAKHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 06:07:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:35790 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgDAKHN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 06:07:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 36190ABF6;
        Wed,  1 Apr 2020 10:07:11 +0000 (UTC)
From:   Richard Palethorpe <rpalethorpe@suse.com>
To:     linux-can@vger.kernel.org
Cc:     Richard Palethorpe <rpalethorpe@suse.com>,
        Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        security@kernel.org, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net
Subject: [PATCH v2] slcan: Don't transmit uninitialized stack data in padding
Date:   Wed,  1 Apr 2020 12:06:39 +0200
Message-Id: <20200401100639.20199-1-rpalethorpe@suse.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct can_frame contains some padding which is not explicitly zeroed in
slc_bump. This uninitialized data will then be transmitted if the stack
initialization hardening feature is not enabled (CONFIG_INIT_STACK_ALL).

This commit just zeroes the whole struct including the padding.

Signed-off-by: Richard Palethorpe <rpalethorpe@suse.com>
Fixes: a1044e36e457 ("can: add slcan driver for serial/USB-serial CAN adapters")
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: linux-can@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: security@kernel.org
Cc: wg@grandegger.com
Cc: mkl@pengutronix.de
Cc: davem@davemloft.net
---

V2: Reviewed by Kees and Fixes tag added.

As mentioned in V1; The following unfinished test can reproduce the bug:
https://github.com/richiejp/ltp/blob/pty-slcan/testcases/kernel/pty/pty04.c


 drivers/net/can/slcan.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index a3664281a33f..4dfa459ef5c7 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -148,7 +148,7 @@ static void slc_bump(struct slcan *sl)
 	u32 tmpid;
 	char *cmd = sl->rbuff;
 
-	cf.can_id = 0;
+	memset(&cf, 0, sizeof(cf));
 
 	switch (*cmd) {
 	case 'r':
@@ -187,8 +187,6 @@ static void slc_bump(struct slcan *sl)
 	else
 		return;
 
-	*(u64 *) (&cf.data) = 0; /* clear payload */
-
 	/* RTR frames may have a dlc > 0 but they never have any data bytes */
 	if (!(cf.can_id & CAN_RTR_FLAG)) {
 		for (i = 0; i < cf.can_dlc; i++) {
-- 
2.24.0

