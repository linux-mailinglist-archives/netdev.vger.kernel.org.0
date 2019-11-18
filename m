Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2B991000D7
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 09:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfKRI5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 03:57:18 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33101 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbfKRI5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 03:57:17 -0500
Received: by mail-pl1-f196.google.com with SMTP id ay6so9419632plb.0
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 00:57:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5pYU3MBdJcghgwmZCZMRJCjKXgYOm8xSqjzP0Su5DbY=;
        b=dhflZuvpjoOmeUdY1yWFNOov2+J/CTc8CWJ/aIgnlipLRKpQd88Qrk8w7exsyjNNTc
         XAHp+RbEXkFTU7gLZ3W1vbNQWUjNWAfud1q48D+QyFnDUexKTXqp/bbYrRyIEOYiuXVC
         OYxxustx7fj+Tuvo6dTPoIdrTESPPSYkhNGbg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5pYU3MBdJcghgwmZCZMRJCjKXgYOm8xSqjzP0Su5DbY=;
        b=Uyg9icSCJSPtnujnUi+xjB4JfmwXtlkAL0VymjTVOCQM6aHfGubOhU/ANBrq5YkK3R
         QFSKAkuUctiOnw7jB6uiZRtwjZEBIkcc36VKkpIJbJkxwtdUGRe2wxkZuPvbts/KKDGV
         OL5J/TxL7RS1sFC7DNLeHo/mr0nDHZ6uut6a+HJJLd/IhhxVG8VMkHJWLJNKYWtgBeq6
         1d1wROdziurGy3iotFO6oN3LigpHhKrkti4reL+53EI5SMCaDt5lJTJbiRW5gYO9U9b/
         tF8hndHdrTCBg7gZNRkCWOQ36xdmIHguis426wFVdxcofi7UkdQ+eB826laPAchowHzP
         fFHA==
X-Gm-Message-State: APjAAAUV35odRiUZPgTho35x1Lu3lwxEHCo2kD9hZXGkDVHi2NPVNXix
        WG80YU80Ep9PXguBtnOxaQHOwJ3jdJ4=
X-Google-Smtp-Source: APXvYqyKcxuSrliKa00hmt3GXuNE5j96pnNkIPgKrTwdyiIm5t+Beiv7uB30p53pCUuk8rTAXU7gvw==
X-Received: by 2002:a17:902:161:: with SMTP id 88mr26521256plb.253.1574067436540;
        Mon, 18 Nov 2019 00:57:16 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q41sm19120230pja.20.2019.11.18.00.57.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 00:57:16 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Pavan Chebbi <pavan.chebbi@broadcom.com>
Subject: [PATCH net-next 9/9] bnxt_en: Abort waiting for firmware response if there is no heartbeat.
Date:   Mon, 18 Nov 2019 03:56:43 -0500
Message-Id: <1574067403-4344-10-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574067403-4344-1-git-send-email-michael.chan@broadcom.com>
References: <1574067403-4344-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

This is especially beneficial during the NVRAM related firmware
commands that have longer timeouts.  If the BNXT_STATE_FW_FATAL_COND
flag gets set while waiting for firmware response, abort and return
error.

Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 55e02a9..b20ab38 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4278,6 +4278,11 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 		/* Wait until hwrm response cmpl interrupt is processed */
 		while (bp->hwrm_intr_seq_id != (u16)~seq_id &&
 		       i++ < tmo_count) {
+			/* Abort the wait for completion if the FW health
+			 * check has failed.
+			 */
+			if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+				return -EBUSY;
 			/* on first few passes, just barely sleep */
 			if (i < HWRM_SHORT_TIMEOUT_COUNTER)
 				usleep_range(HWRM_SHORT_MIN_TIMEOUT,
@@ -4301,6 +4306,11 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 
 		/* Check if response len is updated */
 		for (i = 0; i < tmo_count; i++) {
+			/* Abort the wait for completion if the FW health
+			 * check has failed.
+			 */
+			if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+				return -EBUSY;
 			len = (le32_to_cpu(*resp_len) & HWRM_RESP_LEN_MASK) >>
 			      HWRM_RESP_LEN_SFT;
 			if (len)
-- 
2.5.1

