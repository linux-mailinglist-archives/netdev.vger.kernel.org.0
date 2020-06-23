Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F772067D1
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 01:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388223AbgFWXB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 19:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388185AbgFWXB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 19:01:57 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4DF7C061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:01:56 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id p20so388954ejd.13
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RUPDxXQmbHgKQBtTHg7QVT0nYXd1g3tXll90pheFqvk=;
        b=AHJvg9XrtksiiY/uGvxGcVIM0P8sjLGlrj3vE7LPIEl4gFk99mVavMlwaHu9vExLcM
         Kf1mgVSB20cMq7HwoMispLSLCsxL81OcBZdihe++OWSEEzGXCXz/OgMrxDdFoKO19JmE
         XhO051Mr5kpUkKIyYxNd+MKdSL9psKFkq/riI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RUPDxXQmbHgKQBtTHg7QVT0nYXd1g3tXll90pheFqvk=;
        b=a54F1vLbt88vnsZHoScl8V9RZ2+TmEcZ+26ORvZK7nm/wZwkua9CFd+KuoC1Lcm/X5
         DrX8uSfJdnvZn/75TYueFYuEUNJ02ssfWpMswzIMCeHfjzY5s8zf0QGRkN68yMEkfh7A
         bJsYuwP43oqRowWP03WI569tD+Cht9ybtQgFc97JtNZvDzyKyQmNbigh7wRQBh2IpOpy
         G5kpWXk7Rt4OEIXMheqo3D+/SPOcJj1UKx6CWYIYAvVyHyoBst/+INAnMNKu4Mmzz/+d
         Dty1Mox5Per9DcJXTAvEJ7D18R6+VPAnUNIyAnQ2PFn0f9F2gSRJWlIh0Npcic5OcPgI
         01pA==
X-Gm-Message-State: AOAM533Y9BUc9/79/2RX6+0q/z4VdWt5YymjqtBSjbpxFGHLy/YsVk0u
        DyAd1JaxFKhbNhwtRPyB8hqm54R8Rm4=
X-Google-Smtp-Source: ABdhPJwQvZBnEoYKYBGkAa9zTMS7aRhe3HHGJ2hIqlguJ+fC4cOvtsCW+N03qO/Z2iNU+z8iBb0mvg==
X-Received: by 2002:a17:906:3c10:: with SMTP id h16mr16625398ejg.87.1592953315292;
        Tue, 23 Jun 2020 16:01:55 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id cw19sm8205865ejb.39.2020.06.23.16.01.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jun 2020 16:01:54 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/4] bnxt_en: Store the running firmware version code.
Date:   Tue, 23 Jun 2020 19:01:35 -0400
Message-Id: <1592953298-20858-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592953298-20858-1-git-send-email-michael.chan@broadcom.com>
References: <1592953298-20858-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We currently only store the firmware version as a string for ethtool
and devlink info.  Store it also as a version code.  The next 2
patches will need to check the firmware major version to determine
some workarounds.

We also use the 16-bit firmware version fields if the firmware is newer
and provides the 16-bit fields.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 22 ++++++++++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  4 ++++
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b93e05f..0ad8d49 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7240,8 +7240,9 @@ static int __bnxt_hwrm_ver_get(struct bnxt *bp, bool silent)
 static int bnxt_hwrm_ver_get(struct bnxt *bp)
 {
 	struct hwrm_ver_get_output *resp = bp->hwrm_cmd_resp_addr;
+	u16 fw_maj, fw_min, fw_bld, fw_rsv;
 	u32 dev_caps_cfg, hwrm_ver;
-	int rc;
+	int rc, len;
 
 	bp->hwrm_max_req_len = HWRM_MAX_REQ_LEN;
 	mutex_lock(&bp->hwrm_cmd_lock);
@@ -7273,9 +7274,22 @@ static int bnxt_hwrm_ver_get(struct bnxt *bp)
 			 resp->hwrm_intf_maj_8b, resp->hwrm_intf_min_8b,
 			 resp->hwrm_intf_upd_8b);
 
-	snprintf(bp->fw_ver_str, BC_HWRM_STR_LEN, "%d.%d.%d.%d",
-		 resp->hwrm_fw_maj_8b, resp->hwrm_fw_min_8b,
-		 resp->hwrm_fw_bld_8b, resp->hwrm_fw_rsvd_8b);
+	fw_maj = le16_to_cpu(resp->hwrm_fw_major);
+	if (bp->hwrm_spec_code > 0x10803 && fw_maj) {
+		fw_min = le16_to_cpu(resp->hwrm_fw_minor);
+		fw_bld = le16_to_cpu(resp->hwrm_fw_build);
+		fw_rsv = le16_to_cpu(resp->hwrm_fw_patch);
+		len = FW_VER_STR_LEN;
+	} else {
+		fw_maj = resp->hwrm_fw_maj_8b;
+		fw_min = resp->hwrm_fw_min_8b;
+		fw_bld = resp->hwrm_fw_bld_8b;
+		fw_rsv = resp->hwrm_fw_rsvd_8b;
+		len = BC_HWRM_STR_LEN;
+	}
+	bp->fw_ver_code = BNXT_FW_VER_CODE(fw_maj, fw_min, fw_bld, fw_rsv);
+	snprintf(bp->fw_ver_str, len, "%d.%d.%d.%d", fw_maj, fw_min, fw_bld,
+		 fw_rsv);
 
 	if (strlen(resp->active_pkg_name)) {
 		int fw_ver_len = strlen(bp->fw_ver_str);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 9e173d7..858440e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1746,6 +1746,10 @@ struct bnxt {
 #define PHY_VER_STR_LEN         (FW_VER_STR_LEN - BC_HWRM_STR_LEN)
 	char			fw_ver_str[FW_VER_STR_LEN];
 	char			hwrm_ver_supp[FW_VER_STR_LEN];
+	u64			fw_ver_code;
+#define BNXT_FW_VER_CODE(maj, min, bld, rsv)			\
+	((u64)(maj) << 48 | (u64)(min) << 32 | (u64)(bld) << 16 | (rsv))
+
 	__be16			vxlan_port;
 	u8			vxlan_port_cnt;
 	__le16			vxlan_fw_dst_port_id;
-- 
1.8.3.1

