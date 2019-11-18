Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3589C1000D3
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 09:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfKRI5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 03:57:09 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41260 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfKRI5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 03:57:09 -0500
Received: by mail-pg1-f194.google.com with SMTP id 207so1955577pge.8
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 00:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ynmkEX57qj9EWlP6vdi644CkZoG7AkoVWwgzREArLVk=;
        b=ZzbUodaau5KjBEh+5hNhaDCvx406IWKYrTYAaVkbsHv/V3u2oc7WQEwvV93R3WNqoP
         020BLhFRHrN68fDECHLTl45/hiOZotsO9RC3mWnBOnEI+mdpg249FDObOWA7Ma7tlAIl
         CeiXLuU8HMaT0EW1FnBpq2G8RfAZbGg6TBtc0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ynmkEX57qj9EWlP6vdi644CkZoG7AkoVWwgzREArLVk=;
        b=MnKqgFCkheV8uFy+LMLnzALoUo3XGw9ftoqenPae+X4FjjduK3RdCc21X9bR8i/qQC
         fBm296WvauVIEcz4pXMYAyKxUXc1K0dC3icvxT3lhgd/DkRjQPvIXE7EzANYCCPKS6p/
         IGMltxVqZpNQEu42Cyzs7oG5OKJO8HvCWcRfTMvdH8Pz4FlHK7XjnpO/t2CEvAXQSeiw
         IpwK+QF/faa2KPcECKTnNLIRd2tWrvCenrGIOGq3Kz8YteVb9H1C8TSalA5XntgvoeT6
         m6tybEdFXdaUy44amlbLpK+NS9EI3f40478pC2XL9LkC2LJT0QjP6mpWh0+zGMwi9ygW
         W65A==
X-Gm-Message-State: APjAAAW1yttA3ruBqv/Xa4KSv+N1W+tRzdaeFQn/yqnfvJACtWAgqxEw
        gf/OLYTh2MIX/SZ3jzgGl/uvUw==
X-Google-Smtp-Source: APXvYqz2lDyZmMY4a+YO5FpVzEgqKvBnwk3DOoqKFD8zvI5Xg8vuYeHV91MyYhiOPeNN4Bt7e39S/Q==
X-Received: by 2002:a62:e105:: with SMTP id q5mr33034329pfh.105.1574067427236;
        Mon, 18 Nov 2019 00:57:07 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q41sm19120230pja.20.2019.11.18.00.57.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 00:57:06 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 5/9] bnxt_en: Set MASTER flag during driver registration.
Date:   Mon, 18 Nov 2019 03:56:39 -0500
Message-Id: <1574067403-4344-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574067403-4344-1-git-send-email-michael.chan@broadcom.com>
References: <1574067403-4344-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

The Linux driver is capable of being the master function to handle
resets, so we set the flag to let firmware know.  Some other
drivers, such as DPDK, is not capable and will not set the flag.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b081a55..178490c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4441,7 +4441,8 @@ static int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp)
 	flags = FUNC_DRV_RGTR_REQ_FLAGS_16BIT_VER_MODE |
 		FUNC_DRV_RGTR_REQ_FLAGS_HOT_RESET_SUPPORT;
 	if (bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY)
-		flags |= FUNC_DRV_RGTR_REQ_FLAGS_ERROR_RECOVERY_SUPPORT;
+		flags |= FUNC_DRV_RGTR_REQ_FLAGS_ERROR_RECOVERY_SUPPORT |
+			 FUNC_DRV_RGTR_REQ_FLAGS_MASTER_SUPPORT;
 	req.flags = cpu_to_le32(flags);
 	req.ver_maj_8b = DRV_VER_MAJ;
 	req.ver_min_8b = DRV_VER_MIN;
-- 
2.5.1

