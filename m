Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D40C14A14A
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgA0J5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:57:17 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46493 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgA0J5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:57:16 -0500
Received: by mail-pl1-f194.google.com with SMTP id y8so3548918pll.13
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 01:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vbQKlghpuXjEUlIa1KsSW2iEIeBU1NJw+JifyZBOcIU=;
        b=dEb1hkZhDJ2nrVtWcCpwKYHHREKxLtdPlYmzKtQajGlhsxKzkALAB5OyZM+AjvDcqh
         X4/8dfV4XXEFARiBK8LfdFUrnP760Du8wZtNjHD9tJ4CjCYPbA9r+OSKkkHUXi7kVeG+
         laMWcRTmfeBLumvayuYTBbhSJwL+J0mF9LIzs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vbQKlghpuXjEUlIa1KsSW2iEIeBU1NJw+JifyZBOcIU=;
        b=CngvgZDgbR+SwYRAsZubNbDSD82O7I6hIFHaEASV6VRnPXo/MvM/CfwGn+liJ//QoD
         ZYw2d6dQL4g4HpdqoHH1ALu9auiUbxUiQuphkf4kb208GxSDTcAnAiBqCFBWmCpJX3nT
         /n7kUlGOaz5KTn2RgjnQDj7Lz6VMXSp7yG0ANO4vXNr0WBKAEAfAr4U1poDJjUqfuF3B
         Z9RBhO+ApLOcoXPDtiMxjqTKm6wR9QOFNSZBuTxt6E6A2BLH6CNrxQuI0xzy5rBp5zxj
         K3bpcGyAk7JcKdlGpbRcjFtDOXv2qabEkQw4orDcIujic5R5hX857arGdhcXxPOXn6jj
         DGkQ==
X-Gm-Message-State: APjAAAU9LARQRZWeUXknMh+D6WMy5ZZZIICxIOmLFpccmGmuxS7YnWCA
        K2Oo3xy8JONe1PBOArg6ywtoDw==
X-Google-Smtp-Source: APXvYqxnhiMJvFMuduP1rLs/zddVkmJo7CJrUyicWkeB8V0FvZN6fVgN+Q5+2RwrypUM61+aB8RH9w==
X-Received: by 2002:a17:902:8c8b:: with SMTP id t11mr15717641plo.319.1580119035740;
        Mon, 27 Jan 2020 01:57:15 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r3sm15232594pfg.145.2020.01.27.01.57.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jan 2020 01:57:15 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next v2 09/15] bnxt_en: Register devlink irrespective of firmware spec version
Date:   Mon, 27 Jan 2020 04:56:21 -0500
Message-Id: <1580118987-30052-10-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
References: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

This will allow to register for devlink port and use port features.
Also register params only if firmware spec version is at least 0x10600
which will support reading/setting numbered variables in NVRAM.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 9253eed..a8cdfbdd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -489,6 +489,9 @@ static int bnxt_dl_params_register(struct bnxt *bp)
 {
 	int rc;
 
+	if (bp->hwrm_spec_code < 0x10600)
+		return 0;
+
 	rc = devlink_params_register(bp->dl, bnxt_dl_params,
 				     ARRAY_SIZE(bnxt_dl_params));
 	if (rc) {
@@ -511,6 +514,9 @@ static int bnxt_dl_params_register(struct bnxt *bp)
 
 static void bnxt_dl_params_unregister(struct bnxt *bp)
 {
+	if (bp->hwrm_spec_code < 0x10600)
+		return;
+
 	devlink_params_unregister(bp->dl, bnxt_dl_params,
 				  ARRAY_SIZE(bnxt_dl_params));
 	devlink_port_params_unregister(&bp->dl_port, bnxt_dl_port_params,
@@ -522,11 +528,6 @@ int bnxt_dl_register(struct bnxt *bp)
 	struct devlink *dl;
 	int rc;
 
-	if (bp->hwrm_spec_code < 0x10600) {
-		netdev_warn(bp->dev, "Firmware does not support NVM params");
-		return -ENOTSUPP;
-	}
-
 	if (BNXT_PF(bp))
 		dl = devlink_alloc(&bnxt_dl_ops, sizeof(struct bnxt_dl));
 	else
-- 
2.5.1

