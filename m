Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4569D19542E
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 10:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbgC0Jhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 05:37:51 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39740 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgC0Jhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 05:37:50 -0400
Received: by mail-wm1-f68.google.com with SMTP id a9so11522664wmj.4
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 02:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=acjCv8ySjgFa0+zCZUWbVDGNkIQmi1JB89nArTPhXXA=;
        b=a8MxsAUbubPFR5jBYlpoPt4XLbpqqQscmTwmzzqeGVE8qvc7gJoS9/k550ct+zB+jg
         QhZDesOeV52zARefWd/J8lOsM8JVa1wIS6xEVCNtyf3HKBVMQcS4Drnz/XYqw1aAj7qz
         QZCfg0N+dchS4EyLnLfgiZTFkvRagi+atqWwI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=acjCv8ySjgFa0+zCZUWbVDGNkIQmi1JB89nArTPhXXA=;
        b=CWMo3RNvu8b6ansm3jvnChSbZxF2DsnUG9HWT+/8NrYgJGZazsV67x/ZAKGm214y6q
         LgiSGcnklJpi+yWv2ihQwK6Prog4M9+AsujaFUIySKf/0H29U3vV3wdp+3t61G4scP2Y
         vrKmsl9dAt4bkdJtccLYt4t9M21IEyfuQ9Wy6zXZm4/bQgohdplFkEDmno/9mJCV32ou
         wH3UvGyoz1xYlLLMWsameKFfxK7d1H3GtT8rz4hEfzFJ9nlP1WMA5k1cqk4VNtwa+sWj
         yrVx+e9Lwpi0Ld72XbAx3WTcQudYZBcqlOykObEXtbGzjdwNn5sA+R28dNAsCcP/lWMM
         kqKw==
X-Gm-Message-State: ANhLgQ1/0OEG1f5pAtOGOJrU2oS2G1beZL5FZontqcIuzn/OAA1602lM
        YZzcHjyr/G5Z5xG1KGVGUg31Yw==
X-Google-Smtp-Source: ADFU+vtIOnZ1lqSGCzj64f8K+dH6S75HaUg+rDBg3D3Px9bRjGQv6gOpz8294m8iMAdwjkL7uoSz8Q==
X-Received: by 2002:a7b:c408:: with SMTP id k8mr4424445wmi.11.1585301868428;
        Fri, 27 Mar 2020 02:37:48 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id v7sm5385107wrs.96.2020.03.27.02.37.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Mar 2020 02:37:47 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH v4 net-next 6/6] bnxt_en: Fix "fw.mgmt" and "fw.nsci" info via devlink info_get cb
Date:   Fri, 27 Mar 2020 15:05:51 +0530
Message-Id: <1585301751-26044-3-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1585301751-26044-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1585301751-26044-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix macro names to report fw.mgmt and fw.ncsi versions to match the
devlink documentation.

Example display after fixes:

$ devlink dev info pci/0000:af:00.0
pci/0000:af:00.0:
  driver bnxt_en
  serial_number B0-26-28-FF-FE-25-84-20
  versions:
      fixed:
        board.id BCM957454A4540
        asic.id C454
        asic.rev 1
      running:
        fw 216.1.154.0
        fw.psid 0.0.0
        fw.mgmt 216.1.146.0
        fw.mgmt.api 1.10.1
        fw.ncsi 864.0.44.0
        fw.roce 216.1.16.0

Fixes: 9599e036b161 ("bnxt_en: Add support for devlink info command")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 Documentation/networking/devlink/bnxt.rst         | 8 ++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/devlink/bnxt.rst b/Documentation/networking/devlink/bnxt.rst
index 9818118..3dfd84c 100644
--- a/Documentation/networking/devlink/bnxt.rst
+++ b/Documentation/networking/devlink/bnxt.rst
@@ -66,15 +66,15 @@ The ``bnxt_en`` driver reports the following versions
    * - ``fw``
      - stored, running
      - Overall board firmware version
-   * - ``fw.app``
+   * - ``fw.mgmt``
      - stored, running
-     - Data path firmware version
+     - NIC hardware resource management firmware version
    * - ``fw.mgmt.api``
      - running
      - Minimum firmware interface spec version supported between driver and firmware
-   * - ``fw.mgmt``
+   * - ``fw.nsci``
      - stored, running
-     - Management firmware version
+     - General platform management firmware version
    * - ``fw.roce``
      - stored, running
      - RoCE management firmware version
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 0c8283b..8e09a52 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -479,7 +479,7 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 			 ver_resp->roce_fw_bld_8b, ver_resp->roce_fw_rsvd_8b);
 	}
 	rc = devlink_info_version_running_put(req,
-			DEVLINK_INFO_VERSION_GENERIC_FW_APP, fw_ver);
+			DEVLINK_INFO_VERSION_GENERIC_FW_MGMT, fw_ver);
 	if (rc)
 		return rc;
 
@@ -491,7 +491,7 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 
 	if (!(bp->flags & BNXT_FLAG_CHIP_P5)) {
 		rc = devlink_info_version_running_put(req,
-			DEVLINK_INFO_VERSION_GENERIC_FW_MGMT, mgmt_ver);
+			DEVLINK_INFO_VERSION_GENERIC_FW_NCSI, mgmt_ver);
 		if (rc)
 			return rc;
 
-- 
1.8.3.1

