Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D83613012B
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 07:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgADGPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 01:15:12 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35023 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgADGPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 01:15:11 -0500
Received: by mail-pf1-f194.google.com with SMTP id i23so19039762pfo.2;
        Fri, 03 Jan 2020 22:15:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2RCd7C91a00C5Ohzt9aA2Hv16VtBMG3QIACuPc5j8rQ=;
        b=ePB2ICf3Tdj0hl3KUBGAhhYqB/o+YzPtmEjQS/Z3j7QPp0jNfBL1kR7QteV2cyhFfA
         ORBfcUzkLBuNEGsUqlbOAA44SRd0LmzcgL/O3alHm/z0aFNESEkm9XiW+xhFrASCq1Co
         ZrIDD5cKNbCV44Nh/hwMG1/EWU/SmIJKXaMQxnhGgzRqXFmhLLXZQWGANsyEyWSj1a6n
         F6sfGHNmWWoV8XSI76ejFGofi2hoeL4xymU+Jpi8jd1lq1uk8syWfEqWFdt9pkc50wME
         GOXWrz5xwtS0EcNKS+AxRG4FIJeCQyhJJZHmLaWvyEXHzQ4VfUUqgMcntYvGkzePDCPm
         lbPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2RCd7C91a00C5Ohzt9aA2Hv16VtBMG3QIACuPc5j8rQ=;
        b=omN+ZONR5NegFCn4U+6V6Bj07mo2nB3oNwSg318WDtrWiTSWyKhLOCK/ZD8FmihYCe
         jiYQr9QIm7nxwM8HjmAwsKaTDV+s5Vxs3uNKZZgD4Fo/FcGu2r85ekA/+EIbNm2ypXSz
         jC5nsPqZP9ei+2A4l1RkIX7JhqA969jZ2LMnuOlLre3cNydRDFxFk1Yvo2kxU8ZAywro
         dFsP0S6Gc0oq5HV/vfU3dCMbxEvrFYL/OZwkREilM77NMvaLzC3+2qnirfyx4OHww26z
         7yrCPf4XkqK0liWrbRfpbfqOiKZWiGJN8mOm2SJJ8IDYKb8tHyUOlWwQuqRhaTXbEG+A
         +Uzg==
X-Gm-Message-State: APjAAAXqSTZnyQik2CDBXHSQvPl4St+T3xSJl5kMBqKLoneBtBMi6ta2
        ZQDw1HUR7VIoXsnoRqZWWD+WlP/c
X-Google-Smtp-Source: APXvYqzSptSpQI5kTklo1xTpnFQPR4Gd6n9jxOQ4T/0DU8XWrudk6Tml1E4WwN6A4NUEsfxUR+FSJg==
X-Received: by 2002:a63:289:: with SMTP id 131mr101370576pgc.149.1578118510616;
        Fri, 03 Jan 2020 22:15:10 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p185sm71276250pfg.61.2020.01.03.22.15.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jan 2020 22:15:09 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net] sctp: free cmd->obj.chunk for the unprocessed SCTP_CMD_REPLY
Date:   Sat,  4 Jan 2020 14:15:02 +0800
Message-Id: <f5ea0cd0d1ae40046da27fcf9f3cf5c21772be49.1578118502.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to fix a memleak caused by no place to free cmd->obj.chunk
for the unprocessed SCTP_CMD_REPLY. This issue occurs when failing to
process a cmd while there're still SCTP_CMD_REPLY cmds on the cmd seq
with an allocated chunk in cmd->obj.chunk.

So fix it by freeing cmd->obj.chunk for each SCTP_CMD_REPLY cmd left on
the cmd seq when any cmd returns error. While at it, also remove 'nomem'
label.

Reported-by: syzbot+107c4aff5f392bf1517f@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_sideeffect.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index acd737d..834e9f8 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1363,8 +1363,10 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
 			/* Generate an INIT ACK chunk.  */
 			new_obj = sctp_make_init_ack(asoc, chunk, GFP_ATOMIC,
 						     0);
-			if (!new_obj)
-				goto nomem;
+			if (!new_obj) {
+				error = -ENOMEM;
+				break;
+			}
 
 			sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
 					SCTP_CHUNK(new_obj));
@@ -1386,7 +1388,8 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
 			if (!new_obj) {
 				if (cmd->obj.chunk)
 					sctp_chunk_free(cmd->obj.chunk);
-				goto nomem;
+				error = -ENOMEM;
+				break;
 			}
 			sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
 					SCTP_CHUNK(new_obj));
@@ -1433,8 +1436,10 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
 
 			/* Generate a SHUTDOWN chunk.  */
 			new_obj = sctp_make_shutdown(asoc, chunk);
-			if (!new_obj)
-				goto nomem;
+			if (!new_obj) {
+				error = -ENOMEM;
+				break;
+			}
 			sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
 					SCTP_CHUNK(new_obj));
 			break;
@@ -1770,11 +1775,17 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
 			break;
 		}
 
-		if (error)
+		if (error) {
+			cmd = sctp_next_cmd(commands);
+			while (cmd) {
+				if (cmd->verb == SCTP_CMD_REPLY)
+					sctp_chunk_free(cmd->obj.chunk);
+				cmd = sctp_next_cmd(commands);
+			}
 			break;
+		}
 	}
 
-out:
 	/* If this is in response to a received chunk, wait until
 	 * we are done with the packet to open the queue so that we don't
 	 * send multiple packets in response to a single request.
@@ -1789,7 +1800,4 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
 		sp->data_ready_signalled = 0;
 
 	return error;
-nomem:
-	error = -ENOMEM;
-	goto out;
 }
-- 
2.1.0

