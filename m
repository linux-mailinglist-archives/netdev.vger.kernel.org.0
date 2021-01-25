Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5296E302266
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 08:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbhAYHXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 02:23:55 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:33744 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727246AbhAYHWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 02:22:03 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 0A5F380DC;
        Sun, 24 Jan 2021 23:08:23 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 0A5F380DC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1611558503;
        bh=xPmMZajMlx3+8nw/gIUg2y17dg/AfR1xFH/XzNqReyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=johBacmnoH35HW35jQcbzTHpzj3KnJIMAhZzInZGpm/ITvwIAPpiJncz4TDZtninH
         ntIH6U2nptvP0C7ue5gtplsF6OoTkbl2dJ8s8wmr0PqeZ8JpT5cGVYrT02UTSJb5Cj
         jZ1UyQbTfcqvRbBuLBIoG7lQnRLKIj6N3VRs4maM=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 06/15] bnxt_en: Add an upper bound for all firmware command timeouts.
Date:   Mon, 25 Jan 2021 02:08:12 -0500
Message-Id: <1611558501-11022-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
References: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

The timeout period for firmware messages is passed to the driver
from the firmware in the response of the first command.  This
timeout period is multiplied by a factor for certain long
running commands such as NVRAM commands.  In some cases, the
timeout period can become really long and it can cause hung task
warnings if firmware has crashed or is not responding.  To avoid
such long delays, cap all firmware commands to a max timeout value
of 40 seconds.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 2fb9873e0162..c06c5f81f087 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4425,6 +4425,8 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 
 	if (!timeout)
 		timeout = DFLT_HWRM_CMD_TIMEOUT;
+	/* Limit timeout to an upper limit */
+	timeout = min(timeout, HWRM_CMD_MAX_TIMEOUT);
 	/* convert timeout to usec */
 	timeout *= 1000;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 867b1d3a134e..cbb338baab07 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -656,6 +656,7 @@ struct nqe_cn {
 #define BNXT_HWRM_MAX_REQ_LEN		(bp->hwrm_max_req_len)
 #define BNXT_HWRM_SHORT_REQ_LEN		sizeof(struct hwrm_short_input)
 #define DFLT_HWRM_CMD_TIMEOUT		500
+#define HWRM_CMD_MAX_TIMEOUT		40000
 #define SHORT_HWRM_CMD_TIMEOUT		20
 #define HWRM_CMD_TIMEOUT		(bp->hwrm_cmd_timeout)
 #define HWRM_RESET_TIMEOUT		((HWRM_CMD_TIMEOUT) * 4)
-- 
2.18.1

