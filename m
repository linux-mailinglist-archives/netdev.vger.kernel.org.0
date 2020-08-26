Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C55252676
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 07:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgHZFJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 01:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbgHZFJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 01:09:06 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9EF9C061756
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 22:09:05 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id o21so454014wmc.0
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 22:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rq5s7AmaiVsv85ejYXRh3zzJymvPxUYH4FKSzZrzbL8=;
        b=NhQyDYObK5+PDnWwN7tqxDbtlmdDFRFawEf29sXY7KMtmKXJKlfrdcWrrhJ3tx71i6
         L75C0ISinNqitfFXdD//qEnvuw7+/46Y0yxj16gyKeCd0emnelsqijuA0m68lpb+VvUI
         AXkWahN5rcqlPvvEVRAm29U8wMW2htmlfI6GY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rq5s7AmaiVsv85ejYXRh3zzJymvPxUYH4FKSzZrzbL8=;
        b=T4g+rUmwSWHFcmU1aqjTxVCJyqONl8y2MuOqZOB/dA+XbJsHBXEpa1VkwORVtELWr4
         UVB2P5tD0qA9kMvC90Lu+d29pZkPd1Q3xdR0g6Yh9t77BbzS9uVakkb/Qdx1yNzS6rge
         RohiuoEKEwNUp6I/tnKcKUBl2AiVFSSnvkoely9HVh99nr5aydtKRU6/CK4Q7eKUfD76
         7ZgItoz0KaFvZTKJbjizmUJMN3vw/H/2ZhFItgmdmMrtyqsHZksX5OqKUPQI6wppPSGM
         evnp8DQV+FvwetOwFxc/5QFtU/DtHJrmctI673RTgM6WQWHy4nFTySAlaudXWvvSA+4p
         3e2g==
X-Gm-Message-State: AOAM5303MiRBKboxHyCtuTAQYATu6gaR/Q9RhNizrBUKOO3lMEZF8GPn
        8tLQWoEu0J+xyUFCJsRjVgF+0w==
X-Google-Smtp-Source: ABdhPJy9ss8eLLKQJu69zriACbLVpdp3ppRFQKH05/xbaHSAy82VyvqBAqQ3IqPV1jTiNb9uaQ2Zyw==
X-Received: by 2002:a05:600c:214e:: with SMTP id v14mr5199273wml.118.1598418544301;
        Tue, 25 Aug 2020 22:09:04 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q12sm2825832wrm.39.2020.08.25.22.09.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2020 22:09:03 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net 2/8] bnxt_en: Check for zero dir entries in NVRAM.
Date:   Wed, 26 Aug 2020 01:08:33 -0400
Message-Id: <1598418519-20168-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1598418519-20168-1-git-send-email-michael.chan@broadcom.com>
References: <1598418519-20168-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

If firmware goes into unstable state, HWRM_NVM_GET_DIR_INFO firmware
command may return zero dir entries. Return error in such case to
avoid zero length dma buffer request.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 3890c1a..5d1a0cd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2323,6 +2323,9 @@ static int bnxt_get_nvram_directory(struct net_device *dev, u32 len, u8 *data)
 	if (rc != 0)
 		return rc;
 
+	if (!dir_entries || !entry_length)
+		return -EIO;
+
 	/* Insert 2 bytes of directory info (count and size of entries) */
 	if (len < 2)
 		return -EINVAL;
-- 
1.8.3.1

