Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292A54989BB
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344163AbiAXS6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344537AbiAXSyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:54:46 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572F6C061344
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:37 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id d15-20020a17090a110f00b001b4e7d27474so47124pja.2
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PLArnqefwgDmb7xF33Ph9ouGYL3xAlbp6gYpsYpMxpg=;
        b=IbMWrwYiXVvhbkuGImQ0XJK1Q0Hlr+dMh5HymsJW6Tgd3YBs5nwiGYyyc70xuiDOAe
         BSafNoeVnh6fXC3Vp95OPXF5FKKBcSXvNZgTwWUfsT/DdXqVpOjzc3RXPnWmXHlZG5B9
         70KZqb7bjbJwIqc34SUhxTh7jDjnYKahB14IX6rCNh7BBG/Y/A4CieCBsxko5OUaBFwD
         ahoLfQ6mEjCPz7yJ7mqx9wMBAK8o6zFX9UVBUYyyVo4oxdFkHT9YIUDoYqrE/Ets83Mb
         Q/AARKloL3GgWokoaOxXryIgAyKVJ4xwcZDdBp6OFYLRak7wnFdFMd/wguE5pH02fxDk
         q3PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PLArnqefwgDmb7xF33Ph9ouGYL3xAlbp6gYpsYpMxpg=;
        b=UIqmhslbuMzWuH16Vty5RbRuHkVVpwfMXdpf66qKG4L/H61d7isK19akD95fPn7INW
         v/JjN8eZoinfUej4aSWG/d1Mr314w/M1fvEto7XD1CiXtL0PEzcoUK4MM8VsnaeJbfEv
         WA2u639axmEuMdbdTTGtgGCYfw5YPVRN897Tx+j+gqasXvgQtbHLaAySq0lfJwhApYfw
         D/Dfo2NfyZ1w08d2eFVd9JVI7YAmJLC0gA8fYO+QVqb0yvcWOCmW0kAak/i4Sl9SuRtD
         VxxKGfvAB7/u8nmnmJ6KSNxhJ1Y75lVgXTa5E++urgdhzpx3r5M66Z2SU/lZFzXKYRFy
         T66Q==
X-Gm-Message-State: AOAM532U5Vp7oJ2zysEu9yw/jpkjlw5/70+dR3CcQnsKFkXIg7D3yP9p
        taAoynvh8Vk14Nuk/ZWxqCNABQ==
X-Google-Smtp-Source: ABdhPJwbywn9zvRnkCMaISrd6wFhuVxL8mPKz9vftJp0gX8F30ijNMZ2WMkIrABuIrqjaoeBi2FOhw==
X-Received: by 2002:a17:90b:4ad2:: with SMTP id mh18mr3269039pjb.3.1643050416663;
        Mon, 24 Jan 2022 10:53:36 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id cq14sm85177pjb.33.2022.01.24.10.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 10:53:36 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Brett Creeley <brett@pensando.io>,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 09/16] ionic: Allow flexibility for error reporting on dev commands
Date:   Mon, 24 Jan 2022 10:53:05 -0800
Message-Id: <20220124185312.72646-10-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220124185312.72646-1-snelson@pensando.io>
References: <20220124185312.72646-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett@pensando.io>

When dev commands fail, an error message will always be printed,
which may be overly alarming the to system administrators,
especially if the driver shouldn't be printing the error due
to some unsupported capability.

Similar to recent adminq request changes, we can update the
dev command interface with the ability to selectively print
error messages to allow the driver to prevent printing errors
that are expected.

Signed-off-by: Brett Creeley <brett@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   |  3 ++
 .../net/ethernet/pensando/ionic/ionic_main.c  | 31 ++++++++++++++++---
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 5e25411ff02f..6783c0e6ba4f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -78,6 +78,9 @@ void ionic_adminq_netdev_err_print(struct ionic_lif *lif, u8 opcode,
 				   u8 status, int err);
 
 int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_wait);
+int ionic_dev_cmd_wait_nomsg(struct ionic *ionic, unsigned long max_wait);
+void ionic_dev_cmd_dev_err_print(struct ionic *ionic, u8 opcode, u8 status,
+				 int err);
 int ionic_set_dma_mask(struct ionic *ionic);
 int ionic_setup(struct ionic *ionic);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 7693b4336394..163174f07ed7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -384,7 +384,20 @@ static void ionic_dev_cmd_clean(struct ionic *ionic)
 	memset_io(&idev->dev_cmd_regs->cmd, 0, sizeof(idev->dev_cmd_regs->cmd));
 }
 
-int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
+void ionic_dev_cmd_dev_err_print(struct ionic *ionic, u8 opcode, u8 status,
+				 int err)
+{
+	const char *stat_str;
+
+	stat_str = (err == -ETIMEDOUT) ? "TIMEOUT" :
+					 ionic_error_to_str(status);
+
+	dev_err(ionic->dev, "DEV_CMD %s (%d) error, %s (%d) failed\n",
+		ionic_opcode_to_str(opcode), opcode, stat_str, err);
+}
+
+static int __ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds,
+				const bool do_msg)
 {
 	struct ionic_dev *idev = &ionic->idev;
 	unsigned long start_time;
@@ -452,9 +465,9 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
 		}
 
 		if (!(opcode == IONIC_CMD_FW_CONTROL && err == IONIC_RC_EAGAIN))
-			dev_err(ionic->dev, "DEV_CMD %s (%d) error, %s (%d) failed\n",
-				ionic_opcode_to_str(opcode), opcode,
-				ionic_error_to_str(err), err);
+			if (do_msg)
+				ionic_dev_cmd_dev_err_print(ionic, opcode, err,
+							    ionic_error_to_errno(err));
 
 		return ionic_error_to_errno(err);
 	}
@@ -462,6 +475,16 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
 	return 0;
 }
 
+int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
+{
+	return __ionic_dev_cmd_wait(ionic, max_seconds, true);
+}
+
+int ionic_dev_cmd_wait_nomsg(struct ionic *ionic, unsigned long max_seconds)
+{
+	return __ionic_dev_cmd_wait(ionic, max_seconds, false);
+}
+
 int ionic_setup(struct ionic *ionic)
 {
 	int err;
-- 
2.17.1

