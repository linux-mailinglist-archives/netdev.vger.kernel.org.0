Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71B31D5EF2
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 07:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgEPFvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 01:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725807AbgEPFvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 01:51:46 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2013BC061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 22:51:46 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id z72so4727562wmc.2
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 22:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=dszDuDnhyemW2RGGnijtxG1Knodo/9IdDZ7z98Rmivw=;
        b=B+g3WPIaWROimrVfn8DD2FSGvGZFTHJ7VlDSSCMPovgN7IRS1yv9aqR92VBMiUskNc
         Jty3RUK2t/HkHCzWg+q6rGoGjDXxQGo0KOzaijleUZWNbCDYRVACey04n+p2Vi4fE6EX
         jgPWVoWvo51I+QYjU+epfCmCIiuIdroNZb0N4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dszDuDnhyemW2RGGnijtxG1Knodo/9IdDZ7z98Rmivw=;
        b=ihtK3mi7/rtg311i/64rvaX5yWlKqWerkS/V+3qm7fvi+AGdxBgLmYkbb3lMlMI3e9
         CQYx4hnxJPn0k6Zjx9jjIp3luAH07l0qlF0l0lfuWoiozQWjhtY44ihF5gWee31o99a1
         fy0Z36vE0aVIWRW3tLR27qKaissN9n6f46Xo2H+7XvITWdD99ZzkWx5TwD4HSuy/5BhS
         e6h4e2d3XiiEHAsFTIscPPYkOpkjjirj856r2eMNIa8oAjvPLH961GRECvFh0goEc44y
         SvHhk+7pNYzj+ml45xclezpvr59dZ+KHHNyOFQLJ8CJLn6XU1fOgZvpRj/DvGRplk0AP
         8UsQ==
X-Gm-Message-State: AOAM532rv3U0sRhwYXqBXOkKXo7qdEzdyrxxxcBzzh5NQgXYcrJ16yxV
        WELPADPUr+ai3C9Wp/i1Y3X0Nw==
X-Google-Smtp-Source: ABdhPJwk0EYVlI+c+PisFGuhJkRr/aPARk5J4sIImv9/K2iDhcvHE4liTnvbLX+m8KSxVpgblSEa6A==
X-Received: by 2002:a7b:c8d4:: with SMTP id f20mr7878919wml.72.1589608302666;
        Fri, 15 May 2020 22:51:42 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a12sm6481438wro.68.2020.05.15.22.51.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 May 2020 22:51:42 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     jeyu@kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH] bnxt_en: use new module_firmware_crashed()
Date:   Sat, 16 May 2020 11:19:17 +0530
Message-Id: <1589608157-22070-1-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes use of the new module_firmware_crashed() to help
annotate when firmware for device drivers crash. When firmware
crashes devices can sometimes become unresponsive, and recovery
sometimes requires a driver unload / reload and in the worst cases
a reboot.

Using a taint flag allows us to annotate when this happens clearly.

Cc: Michael Chan <michael.chan@broadcom.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
---
Please append to the patchset:
("[PATCH v2 00/15] net: taint when the device driver firmware crashes")
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f86b621..b208404 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2009,6 +2009,7 @@ static int bnxt_async_event_process(struct bnxt *bp,
 		if (!bp->fw_reset_max_dsecs)
 			bp->fw_reset_max_dsecs = BNXT_DFLT_FW_RST_MAX_DSECS;
 		if (EVENT_DATA1_RESET_NOTIFY_FATAL(data1)) {
+			module_firmware_crashed();
 			netdev_warn(bp->dev, "Firmware fatal reset event received\n");
 			set_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
 		} else {
@@ -10183,6 +10184,7 @@ static void bnxt_force_fw_reset(struct bnxt *bp)
 
 void bnxt_fw_exception(struct bnxt *bp)
 {
+	module_firmware_crashed();
 	netdev_warn(bp->dev, "Detected firmware fatal condition, initiating reset\n");
 	set_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
 	bnxt_rtnl_lock_sp(bp);
-- 
1.8.3.1

