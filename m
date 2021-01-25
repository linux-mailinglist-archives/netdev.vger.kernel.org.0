Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345B0302271
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 08:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbhAYHcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 02:32:16 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:33757 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727249AbhAYHWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 02:22:35 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id E4DC080F2;
        Sun, 24 Jan 2021 23:08:23 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com E4DC080F2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1611558504;
        bh=Ga03E1C20q6O8nYdTdIOw52sj35IIQTSQbiNN+JABk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7PSapT6NwarSik5z9VV7FHpkk1bUQ7wAbds827zPzn52sV8BOjldeI5uL6iKQm74
         6kPRLJPxbH+/0dmiQYdpRPzDIjDvuq9/5uZg2bHcDUbKymLYfQWNsVeBKiUuekyogJ
         V6xFEXT+lIIFmgNN0cV3gXbxreRrQpGeNtgdhHwE=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 12/15] bnxt_en: Modify bnxt_disable_int_sync() to be called more than once.
Date:   Mon, 25 Jan 2021 02:08:18 -0500
Message-Id: <1611558501-11022-13-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
References: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the event of a fatal firmware error, we want to disable IRQ early
in the recovery sequence.  This change will allow it to be called
safely again as part of the normal shutdown sequence.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 83846b50042a..80dab4e622ab 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4280,6 +4280,9 @@ static void bnxt_disable_int_sync(struct bnxt *bp)
 {
 	int i;
 
+	if (!bp->irq_tbl)
+		return;
+
 	atomic_inc(&bp->intr_sem);
 
 	bnxt_disable_int(bp);
-- 
2.18.1

