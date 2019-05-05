Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94AAF13F2B
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 13:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfEELRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 07:17:34 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33411 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727598AbfEELR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 07:17:27 -0400
Received: by mail-pl1-f195.google.com with SMTP id y3so4927260plp.0
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 04:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Vm7BNF60YGeWeVXIt7F/vAX3+KdNnrERvRSvBYJSriE=;
        b=Zhyw1esHqytNA0PIxEG44J77LNUAQPGkVP+izr99LngBGzEO125/sGgg4u3KVX5f4A
         w6CMQmV8+G0syswPyDnf8mQ/LfXonjuRTaaaIA3JfOh2dk041ul7/IxbQAG9AQDt247A
         4IpDYJvGaZbk6Vug7y48abSdbK+EJiHMPHWag=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Vm7BNF60YGeWeVXIt7F/vAX3+KdNnrERvRSvBYJSriE=;
        b=MBQwC7vmsYj0VJ5jn30Poti2v04c7SltVLXCMgqtknRAonK084NoRJbodTn/672WTd
         kMlswS0Hhrp88RAsvQGeHYjtedZT19RmTCG3E7jGI+erw3aLmlXtOvbgfK9FuTh7jm67
         rI1got8qUTBPNsp9YleMX+sAlEWvCFkeRaxmzKQ4VUL0iczZDo0tO287tvVSMV/jd+Ag
         EThZmkVKhrmQCam9S7+TZF97X8XJzFD+npiT2KGWraqLBDqPsxmSIrbhls1CWFPS2ZaY
         k4CCxcRZnetjhJNbaas0Aq34oDhxASS4RJoyeCWou6cwcDmrdtmaHzdPvqgXfaObhhfE
         zqjA==
X-Gm-Message-State: APjAAAVzHiDB6wyVtUN7R4Iq3FAX3Tdgf8qhxl3uMDCfwFCjlfo3n1AA
        nsNXNVr5uRCaURZBTPoR0BWxbBT9Xs4=
X-Google-Smtp-Source: APXvYqzzXsXFjA/Gy4wl660X4Y2R5YWC63jYYIEiVeJSipDgrJZ+8TNOB68b+f80/jEKcLTJZoZfUA==
X-Received: by 2002:a17:902:765:: with SMTP id 92mr23086671pli.196.1557055045922;
        Sun, 05 May 2019 04:17:25 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id 10sm9378902pfh.14.2019.05.05.04.17.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 04:17:25 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 06/11] bnxt_en: read the clause type from the PHY ID
Date:   Sun,  5 May 2019 07:17:03 -0400
Message-Id: <1557055028-14816-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
References: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Currently driver hard code Clause 45 based on speed supported by the
PHY. Instead read the clause type from the PHY ID provided as input
to the mdio ioctl.

Fixes: 0ca12be99667 ("bnxt_en: Add support for mdio read/write to external PHY")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 256be9d..7073b99 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8699,7 +8699,7 @@ static int bnxt_hwrm_port_phy_read(struct bnxt *bp, u16 phy_addr, u16 reg,
 	req.port_id = cpu_to_le16(bp->pf.port_id);
 	req.phy_addr = phy_addr;
 	req.reg_addr = cpu_to_le16(reg & 0x1f);
-	if (bp->link_info.support_speeds & BNXT_LINK_SPEED_MSK_10GB) {
+	if (mdio_phy_id_is_c45(phy_addr)) {
 		req.cl45_mdio = 1;
 		req.phy_addr = mdio_phy_id_prtad(phy_addr);
 		req.dev_addr = mdio_phy_id_devad(phy_addr);
@@ -8726,7 +8726,7 @@ static int bnxt_hwrm_port_phy_write(struct bnxt *bp, u16 phy_addr, u16 reg,
 	req.port_id = cpu_to_le16(bp->pf.port_id);
 	req.phy_addr = phy_addr;
 	req.reg_addr = cpu_to_le16(reg & 0x1f);
-	if (bp->link_info.support_speeds & BNXT_LINK_SPEED_MSK_10GB) {
+	if (mdio_phy_id_is_c45(phy_addr)) {
 		req.cl45_mdio = 1;
 		req.phy_addr = mdio_phy_id_prtad(phy_addr);
 		req.dev_addr = mdio_phy_id_devad(phy_addr);
-- 
2.5.1

