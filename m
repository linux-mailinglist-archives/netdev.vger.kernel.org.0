Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A019217D6E1
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 23:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgCHWq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 18:46:27 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45290 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgCHWq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 18:46:26 -0400
Received: by mail-pg1-f194.google.com with SMTP id m15so3819667pgv.12
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 15:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CAoVTG0moicyEN68mWeiUhSf+E1MnfdqCLnPCEmAe7I=;
        b=aISMWM0KQSkLZ8XTiUTGQ5/knLymTUXKKg5i0XTsyvJFB84LhZP6kiNyvRwE/9H8Xq
         YxEjGNNXjN62v2thRHL97G+xeq0JcS9kzQnRhwPE5E1gkZ6mRUeqPBuM1EShgCKXEME8
         Yguvb57RTCtcas5w1wMAtaNuCtRxKrCJ6DIJQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CAoVTG0moicyEN68mWeiUhSf+E1MnfdqCLnPCEmAe7I=;
        b=hApcZ7JUcrCSSexRWcFLDVG0B+oJIYA3ILBPR7cquQrM39/ZQHj3tx830lL3rd4dfs
         4ZPcSsGjy/vsLQxNmNESsoUhKfPxuEaFhsjzzy1GEPq6u2smlsjQl92pWe8VvdYZ1c40
         2o9bxFr7wnz8QVNoBQ2ImctA24eOMZcev6Pd0nhLOuWLhxxosWtVYXg3OmZQwIjGZGWf
         oZHIdXVq1ByqBVKOwrz34/ythwA1djEWwC4Tb4gbfkEe8wE7XEa1zadtqI4GdYx82cTl
         +Ov29/aKqyjxyVpYbkQw7mxbBgcgry/L8+gwweYnbxGhNymCq9EKYKlD/U29kqpUS0hr
         M5Nw==
X-Gm-Message-State: ANhLgQ3NxAkFUjMppa3KvGPvNUyl7qcoiIedRnTB/4WKeYy8uwawul+Z
        4ghdUIUXZcFWq0baBii42WwBig==
X-Google-Smtp-Source: ADFU+vv8vgGva0CEYMi9UBwpsAxgW/vSNLYyDSwtOfEcyZOmnZjjNm2kAbHMez6zMyRSVEoMzu+iFA==
X-Received: by 2002:a63:9c4:: with SMTP id 187mr11485224pgj.389.1583707586005;
        Sun, 08 Mar 2020 15:46:26 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x66sm31241397pgb.9.2020.03.08.15.46.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Mar 2020 15:46:25 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 8/8] bnxt_en: Call devlink_port_type_clear() in remove()
Date:   Sun,  8 Mar 2020 18:45:54 -0400
Message-Id: <1583707554-1163-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583707554-1163-1-git-send-email-michael.chan@broadcom.com>
References: <1583707554-1163-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Similar to other drivers, properly clear the devlink port type when
removing the device before unregistration.

Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 02ac718..4c9696a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11429,6 +11429,8 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 		bnxt_sriov_disable(bp);
 
 	bnxt_dl_fw_reporters_destroy(bp, true);
+	if (BNXT_PF(bp))
+		devlink_port_type_clear(&bp->dl_port);
 	pci_disable_pcie_error_reporting(pdev);
 	unregister_netdev(dev);
 	bnxt_dl_unregister(bp);
-- 
2.5.1

