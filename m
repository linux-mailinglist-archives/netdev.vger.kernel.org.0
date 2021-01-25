Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0676302279
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 08:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbhAYHhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 02:37:05 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:33746 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727244AbhAYHWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 02:22:03 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 6422180F9;
        Sun, 24 Jan 2021 23:08:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 6422180F9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1611558504;
        bh=R0yGNtXuiC8FMhGMb3tZiYY4yrJhaxLLxJkHpwVaSj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vkegJ5PsgdnpN1WiX3XEgMROOnfQZADwbHag6X6DemLRXNbChnIChpqdV/ypic9tb
         HihzsRlFo9g96gjBTjzmyyNivtDvL5/Pd0GzZvw9uZ4rf++PuTLthlECis5nNbxUEK
         +2KOxnns0m8X54TitP0HUICyphoVwo5Zmi49bMxk=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 15/15] bnxt_en: Do not process completion entries after fatal condition detected.
Date:   Mon, 25 Jan 2021 02:08:21 -0500
Message-Id: <1611558501-11022-16-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
References: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once the firmware fatal condition is detected, we should cease
comminication with the firmware and hardware quickly even if there
are many completion entries in the completion rings.  This will
speed up the recovery process and prevent further I/Os that may
cause further exceptions.

Do not proceed in the NAPI poll function if fatal condition is
detected.  Call napi_complete() and return without arming interrupts.
Cleanup of all rings and reset are imminent.

Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 221f5437884b..dd7d2caa57a2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2405,6 +2405,10 @@ static int bnxt_poll(struct napi_struct *napi, int budget)
 	struct bnxt_cp_ring_info *cpr = &bnapi->cp_ring;
 	int work_done = 0;
 
+	if (unlikely(test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))) {
+		napi_complete(napi);
+		return 0;
+	}
 	while (1) {
 		work_done += bnxt_poll_work(bp, cpr, budget - work_done);
 
@@ -2479,6 +2483,10 @@ static int bnxt_poll_p5(struct napi_struct *napi, int budget)
 	int work_done = 0;
 	u32 cons;
 
+	if (unlikely(test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))) {
+		napi_complete(napi);
+		return 0;
+	}
 	if (cpr->has_more_work) {
 		cpr->has_more_work = 0;
 		work_done = __bnxt_poll_cqs(bp, bnapi, budget);
-- 
2.18.1

