Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED73B185836
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbgCOB6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:58:03 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46551 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgCOB6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 21:58:03 -0400
Received: by mail-ed1-f66.google.com with SMTP id ca19so17318193edb.13
        for <netdev@vger.kernel.org>; Sat, 14 Mar 2020 18:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hackerdom.ru; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0669bumRlP4HQpMkG80Cw5DJ/SJGZFv7rqtcnz7TDA0=;
        b=JcbQbuyXi81cm5wHDyJ7cqBJfT7UTa+AY43Mzi6y2wE2wjk6LKHVBy0RgQei1zf2un
         wLIrWKoqrryjFO6uU219/K6MMJbPbII+gfFayCOvs6RsTx3Z6q0GP37+BvMIaG9oT1qD
         tyQjRWQvVHiEo6pi3ETy9OAi5vSaCkQK8PEAk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0669bumRlP4HQpMkG80Cw5DJ/SJGZFv7rqtcnz7TDA0=;
        b=o8o1DEW0VQNTlQtM0duNWprJ/M02r2nFCBmYAtaIdBqHp9XMSGD8TOQJ3T/9vRTqVr
         6jiIyPYZbSiTUb5ApMPL6iUY4qQazz+X9zyslYAtF482VroEGVm8PWRZgIxPDOAYyd0R
         EeZd8frd1LFTgr8maY9IiaKt+qeqZSo9JLns9875hiMa6tfAVRWiESfi8Agg92IGSkyE
         q6sSTNyjfWuqFElVN8zKuhPvt2BDCXcS4/V87YqF1YjJsEkGiE2jwJa6R4SUGMqUZfFt
         tNQC7lJXV58FgPmTc/tDXmjkCxEriyCDIuYAM3FE7DbzU0p2QLIMDrNqHLWMHQz0BKnA
         6saA==
X-Gm-Message-State: ANhLgQ2yXCGEvfCeuDLP+mfqtl8pzMgY+0CS2+oFxErYf9HmcxdOMnQI
        lT+9U5PN/c3kL5JKYnNN5IhzaBIttrE=
X-Google-Smtp-Source: ADFU+vuPm0TydM8WrmSVNKxt+bqJFE69RN++6libq4nsRTD0a1n2sKLRxBjTwQ+GeYWJEMdpu9/ZOw==
X-Received: by 2002:a2e:8095:: with SMTP id i21mr10602389ljg.193.1584164053136;
        Fri, 13 Mar 2020 22:34:13 -0700 (PDT)
Received: from localhost.localdomain ([83.169.216.4])
        by smtp.googlemail.com with ESMTPSA id v200sm1232577lfa.48.2020.03.13.22.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 22:34:11 -0700 (PDT)
From:   Alexander Bersenev <bay@hackerdom.ru>
To:     bay@hackerdom.ru
Cc:     Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cdc_ncm: Fix the build warning
Date:   Sat, 14 Mar 2020 10:33:24 +0500
Message-Id: <20200314053324.197745-1-bay@hackerdom.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ndp32->wLength is two bytes long, so replace cpu_to_le32 with cpu_to_le16.

Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>
---
 drivers/net/usb/cdc_ncm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 5569077bd5b8..8929669b5e6d 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1172,7 +1172,7 @@ static struct usb_cdc_ncm_ndp32 *cdc_ncm_ndp32(struct cdc_ncm_ctx *ctx, struct s
 		ndp32 = ctx->delayed_ndp32;
 
 	ndp32->dwSignature = sign;
-	ndp32->wLength = cpu_to_le32(sizeof(struct usb_cdc_ncm_ndp32) + sizeof(struct usb_cdc_ncm_dpe32));
+	ndp32->wLength = cpu_to_le16(sizeof(struct usb_cdc_ncm_ndp32) + sizeof(struct usb_cdc_ncm_dpe32));
 	return ndp32;
 }
 
-- 
2.25.1

