Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81AEB326060
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 10:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhBZJoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 04:44:16 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:45242 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230406AbhBZJoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 04:44:02 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 8C7167DBA;
        Fri, 26 Feb 2021 01:43:10 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 8C7167DBA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1614332590;
        bh=ao51hI7VPKoNGgxnDUJspY1yc8BkXMrx6I4myW85bEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V7Hgi3gY2oT6gyAsthwyy3xMLUKu5Nwl2brPfBfM+BFDX1yz2wdtNeLdZbwsEHKMr
         rJnysndgFOIE7b5QsOdeSPyBRWH+bVlJUiGfl+aL0oyjOgj9focVOH+n5HSxBkyFWh
         Expjb5bvnW9/XJWvq/XTFKAOilQSaNSr+qUa+yJc=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net 1/2] bnxt_en: Fix race between firmware reset and driver remove.
Date:   Fri, 26 Feb 2021 04:43:09 -0500
Message-Id: <1614332590-17865-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1614332590-17865-1-git-send-email-michael.chan@broadcom.com>
References: <1614332590-17865-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

The driver's error recovery reset sequence can take many seconds to
complete and only the critical sections are protected by rtnl_lock.
A recent change has introduced a regression in this sequence.

bnxt_remove_one() may be called while the recovery is in progress.
Normally, unregister_netdev() would cause bnxt_close_nic() to be
called and this would cause the error recovery to safely abort
with the BNXT_STATE_ABORT_ERR flag set in bnxt_close_nic().

Recently, we added bnxt_reinit_after_abort() to allow the user to
reopen the device after an aborted recovery.  This causes the
regression in the scenario described above because we would
attempt to re-open even after the netdev has been unregistered.

Fix it by checking the netdev reg_state in
bnxt_reinit_after_abort() and abort if it is unregistered.

Fixes: 6882c36cf82e ("bnxt_en: attempt to reinitialize after aborted reset")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index a680fd9c68ea..c55189c7bb36 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9890,6 +9890,9 @@ static int bnxt_reinit_after_abort(struct bnxt *bp)
 	if (test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
 		return -EBUSY;
 
+	if (bp->dev->reg_state == NETREG_UNREGISTERED)
+		return -ENODEV;
+
 	rc = bnxt_fw_init_one(bp);
 	if (!rc) {
 		bnxt_clear_int_mode(bp);
-- 
2.18.1

