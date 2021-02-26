Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C97326063
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 10:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbhBZJoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 04:44:23 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:45248 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230422AbhBZJoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 04:44:02 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id B03A280DC;
        Fri, 26 Feb 2021 01:43:10 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com B03A280DC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1614332590;
        bh=V30MqnTWwV/g58rZGcq6tLEqmsSyMT6UsjX1B/xa+Zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SiF1Vh4IyNjlINEmR8MYRasmlQA2PYQKv8TqrG3dyzfcaXufImQSZaElpcFT2RW1+
         6dU3/EWFIvOpNVUlQq4i6BGllbwnVNjbmnWifHKdbOmmF3qAcpbpfFh8Zbg2ihWKf+
         hVl9SayuA49+AUP7OQV2mYOWLjJMqwOdFzPVyqno=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net 2/2] bnxt_en: reliably allocate IRQ table on reset to avoid crash
Date:   Fri, 26 Feb 2021 04:43:10 -0500
Message-Id: <1614332590-17865-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1614332590-17865-1-git-send-email-michael.chan@broadcom.com>
References: <1614332590-17865-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

The following trace excerpt corresponds with a NULL pointer dereference
of 'bp->irq_tbl' in bnxt_setup_inta() on an Aarch64 system after many
device resets:

    Unable to handle kernel NULL pointer dereference at ... 000000d
    ...
    pc : string+0x3c/0x80
    lr : vsnprintf+0x294/0x7e0
    sp : ffff00000f61ba70 pstate : 20000145
    x29: ffff00000f61ba70 x28: 000000000000000d
    x27: ffff0000009c8b5a x26: ffff00000f61bb80
    x25: ffff0000009c8b5a x24: 0000000000000012
    x23: 00000000ffffffe0 x22: ffff000008990428
    x21: ffff00000f61bb80 x20: 000000000000000d
    x19: 000000000000001f x18: 0000000000000000
    x17: 0000000000000000 x16: ffff800b6d0fb400
    x15: 0000000000000000 x14: ffff800b7fe31ae8
    x13: 00001ed16472c920 x12: ffff000008c6b1c9
    x11: ffff000008cf0580 x10: ffff00000f61bb80
    x9 : 00000000ffffffd8 x8 : 000000000000000c
    x7 : ffff800b684b8000 x6 : 0000000000000000
    x5 : 0000000000000065 x4 : 0000000000000001
    x3 : ffff0a00ffffff04 x2 : 000000000000001f
    x1 : 0000000000000000 x0 : 000000000000000d
    Call trace:
    string+0x3c/0x80
    vsnprintf+0x294/0x7e0
    snprintf+0x44/0x50
    __bnxt_open_nic+0x34c/0x928 [bnxt_en]
    bnxt_open+0xe8/0x238 [bnxt_en]
    __dev_open+0xbc/0x130
    __dev_change_flags+0x12c/0x168
    dev_change_flags+0x20/0x60
    ...

Ordinarily, a call to bnxt_setup_inta() (not in trace due to inlining)
would not be expected on a system supporting MSIX at all. However, if
bnxt_init_int_mode() does not end up being called after the call to
bnxt_clear_int_mode() in bnxt_fw_reset_close(), then the driver will
think that only INTA is supported and bp->irq_tbl will be NULL,
causing the above crash.

In the error recovery scenario, we call bnxt_clear_int_mode() in
bnxt_fw_reset_close() early in the sequence. Ordinarily, we will
call bnxt_init_int_mode() in bnxt_hwrm_if_change() after we
reestablish communication with the firmware after reset.  However,
if the sequence has to abort before we call bnxt_init_int_mode() and
if the user later attempts to re-open the device, then it will cause
the crash above.

We fix it in 2 ways:

1. Check for bp->irq_tbl in bnxt_setup_int_mode(). If it is NULL, call
bnxt_init_init_mode().

2. If we need to abort in bnxt_hwrm_if_change() and cannot complete
the error recovery sequence, set the BNXT_STATE_ABORT_ERR flag.  This
will cause more drastic recovery at the next attempt to re-open the
device, including a call to bnxt_init_int_mode().

Fixes: 3bc7d4a352ef ("bnxt_en: Add BNXT_STATE_IN_FW_RESET state.")
Reviewed-by: Scott Branden <scott.branden@broadcom.com>
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c55189c7bb36..b53a0d87371a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8556,10 +8556,18 @@ static void bnxt_setup_inta(struct bnxt *bp)
 	bp->irq_tbl[0].handler = bnxt_inta;
 }
 
+static int bnxt_init_int_mode(struct bnxt *bp);
+
 static int bnxt_setup_int_mode(struct bnxt *bp)
 {
 	int rc;
 
+	if (!bp->irq_tbl) {
+		rc = bnxt_init_int_mode(bp);
+		if (rc || !bp->irq_tbl)
+			return rc ?: -ENODEV;
+	}
+
 	if (bp->flags & BNXT_FLAG_USING_MSIX)
 		bnxt_setup_msix(bp);
 	else
@@ -8744,7 +8752,7 @@ static int bnxt_init_inta(struct bnxt *bp)
 
 static int bnxt_init_int_mode(struct bnxt *bp)
 {
-	int rc = 0;
+	int rc = -ENODEV;
 
 	if (bp->flags & BNXT_FLAG_MSIX_CAP)
 		rc = bnxt_init_msix(bp);
@@ -9514,7 +9522,8 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 {
 	struct hwrm_func_drv_if_change_output *resp = bp->hwrm_cmd_resp_addr;
 	struct hwrm_func_drv_if_change_input req = {0};
-	bool resc_reinit = false, fw_reset = false;
+	bool fw_reset = !bp->irq_tbl;
+	bool resc_reinit = false;
 	int rc, retry = 0;
 	u32 flags = 0;
 
@@ -9557,6 +9566,7 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 
 	if (test_bit(BNXT_STATE_IN_FW_RESET, &bp->state) && !fw_reset) {
 		netdev_err(bp->dev, "RESET_DONE not set during FW reset.\n");
+		set_bit(BNXT_STATE_ABORT_ERR, &bp->state);
 		return -ENODEV;
 	}
 	if (resc_reinit || fw_reset) {
-- 
2.18.1

