Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DDE1F8B60
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 01:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgFNX5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 19:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727928AbgFNX5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 19:57:38 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946ADC05BD43
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 16:57:38 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id gl26so15468241ejb.11
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 16:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Rn0jhfOPQ95iaFmHU1C9v5ozyO83uVXiYWeMRTeFL3c=;
        b=ep43qmOS2vovStI0mNrjsi1zqJ7G3cVOHrlYeyVdnT/0ngNqJIADUlBbIcld8Er5Wx
         scoo1/HV9/D1v6SVqnk0VfZvTm455w5I1KUxQUlf810HypmW5zupUuBZyF27j0Y2rGEK
         O9S/fdnOAWXlVgdwnv0XChCpCpHzcx3jagsTI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Rn0jhfOPQ95iaFmHU1C9v5ozyO83uVXiYWeMRTeFL3c=;
        b=befnLBlV2cIRWVURfVA7wRP5Dm8NZAeATJpko2KiIZNSN74TSOBsDlKNEUvhjVACW7
         MoayemUieAM/q8OzOxwe4UVGTR1rgCKzAiHLP7FgW55LWZvQY02llR9S09U9hxpRLXbg
         KTOLdDfa31t3RH3eOKbTnno3+l9NvcqsykVqVvq41BH+FG3R2m7xXDYF2REXR1Iy4qaM
         8c+cyfjm6g8pf61na9EY+lsjlNX87d0RmzMq1GsHU64bXBMg32Syxi4zCoymmHk9gnCz
         CAyk+v4fK1hs8BtqYLUzZD4ifp6gxDh9nwb55wSf5P7sPrGRyYl1JHaf0Ew8e03MP4fk
         KJlw==
X-Gm-Message-State: AOAM533ejKBNvV1JwhhjPA8U+waDUBctiGg8PB0v+qFrfAasiw3DOeWV
        WTEP9E8KYnzoLpbQWVWMvZn2AQ==
X-Google-Smtp-Source: ABdhPJwSFAH434/z6LHALVZr94GGJnaBvBsG7K/6TzR8TCWR/11JFHVn+vhWpruLulLL09ewPbS9/Q==
X-Received: by 2002:a17:906:7498:: with SMTP id e24mr23147069ejl.174.1592179056875;
        Sun, 14 Jun 2020 16:57:36 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gj10sm7891398ejb.61.2020.06.14.16.57.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jun 2020 16:57:36 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/4] bnxt_en: Re-enable SRIOV during resume.
Date:   Sun, 14 Jun 2020 19:57:08 -0400
Message-Id: <1592179030-4533-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592179030-4533-1-git-send-email-michael.chan@broadcom.com>
References: <1592179030-4533-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If VFs are enabled, we need to re-configure them during resume because
firmware has been reset while resuming.  Otherwise, the VFs won't
work after resume.

Fixes: c16d4ee0e397 ("bnxt_en: Refactor logic to re-enable SRIOV after firmware reset detected.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 1dc38d9..0d97f47 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12151,6 +12151,8 @@ static int bnxt_resume(struct device *device)
 
 resume_exit:
 	bnxt_ulp_start(bp, rc);
+	if (!rc)
+		bnxt_reenable_sriov(bp);
 	rtnl_unlock();
 	return rc;
 }
-- 
1.8.3.1

