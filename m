Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C79C193E91
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 13:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbgCZMFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 08:05:17 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38381 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728001AbgCZMFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 08:05:17 -0400
Received: by mail-wm1-f65.google.com with SMTP id f6so109438wmj.3
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 05:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VqeDlpwv1p4TqztAbL3WzSCThKYMNm+IpDoCwea6pPo=;
        b=OBNRNRK25AtAI/hbq6vYdTW/KhmrN3wVWpGVmo9J0vh7oZW3cmA10G7c5SaGxHTKuP
         h7lzhv2yet+zlFu6268AMqIxNkD3Dvm8lqOxfbl9w/oi24nXC6rfuCzELf0/MA7axMnU
         CqDAWdYRISnzK37VMbPdSa/aV/ppQaBaoIqcI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VqeDlpwv1p4TqztAbL3WzSCThKYMNm+IpDoCwea6pPo=;
        b=QReVHlL5ds5pNmOJXao7RWxSAi0tEuLdBkyUXFxbEpg1eto7xZPS2VuNUzePUqdWbq
         Kaxf7QcwMRAVCXdxvN/YC0dh268ddVKFyNXyc7NbitN0zPXQtoPdzQO0e2ROkaMTrQv6
         jdSfG7iIF1dnylTnmqJgXAKvPsUXNSmnH68ebIDi6DyKI+su0/ZhuQ5pxmVA5yzP2hWt
         4ffW/9ljUQHygnP8fcNAPtwnaPWqgokdro/bJCYFV6He0LtAGaOVvEvi4diepj1FHno7
         Hu3HJNlIZB6JKeou3XGjah4P7eom9CNGV2ZQEW8FuXq0wrNdf/T7d1/O7mvATOW8BIwC
         OTvg==
X-Gm-Message-State: ANhLgQ0/X2nBAZ0zO1/6TCC1p0c2XU4+viTjDECDa80iWSWuIzPfqp0v
        VsFYm1+SeutwJDGHXDte+pQDTuyLvgU=
X-Google-Smtp-Source: ADFU+vthDvMokaZnM3M5WswRU9VnLU4oOSpJ0/z8F7zkPYTCcWFBvocZK4QajApx0sZ/Z3VpKuoUNQ==
X-Received: by 2002:a1c:41d6:: with SMTP id o205mr2776225wma.122.1585224314836;
        Thu, 26 Mar 2020 05:05:14 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id t2sm3108969wml.30.2020.03.26.05.05.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Mar 2020 05:05:14 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH v3 net-next 5/5] bnxt_en: Add partno to devlink info_get cb
Date:   Thu, 26 Mar 2020 17:33:25 +0530
Message-Id: <1585224205-11966-2-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1585224205-11966-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1585224205-11966-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add part number info from the vital product data to info_get command
via devlink tool. Update bnxt.rst documentation as well.

Example display:

$ devlink dev info pci/0000:3b:00.1
pci/0000:3b:00.1:
  driver bnxt_en
  serial_number B0-26-28-FF-FE-C8-85-20
  versions:
      fixed:
        board.id BCM957508-P2100G
        asic.id 1750
        asic.rev 1
      running:
        fw 216.0.286.0
        fw.api 1.10.1
        fw.psid 0.0.6
        fw.app 216.0.251.0

Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
v1->v2: Remove serial number information.
---
 Documentation/networking/devlink/bnxt.rst         | 3 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/Documentation/networking/devlink/bnxt.rst b/Documentation/networking/devlink/bnxt.rst
index 71f5a5a..ee8d0f4 100644
--- a/Documentation/networking/devlink/bnxt.rst
+++ b/Documentation/networking/devlink/bnxt.rst
@@ -51,6 +51,9 @@ The ``bnxt_en`` driver reports the following versions
    * - Name
      - Type
      - Description
+   * - ``board.id``
+     - fixed
+     - Part number identifying the board design
    * - ``asic.id``
      - fixed
      - ASIC design identifier
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 51abc6c..b0e37ae 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -403,6 +403,14 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	if (rc)
 		return rc;
 
+	if (strlen(bp->board_partno)) {
+		rc = devlink_info_version_fixed_put(req,
+			DEVLINK_INFO_VERSION_GENERIC_BOARD_ID,
+			bp->board_partno);
+		if (rc)
+			return rc;
+	}
+
 	sprintf(buf, "%X", bp->chip_num);
 	rc = devlink_info_version_fixed_put(req,
 			DEVLINK_INFO_VERSION_GENERIC_ASIC_ID, buf);
-- 
1.8.3.1

