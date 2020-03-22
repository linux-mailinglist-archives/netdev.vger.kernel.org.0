Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBA918EC37
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 21:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgCVUks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 16:40:48 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39302 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbgCVUkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 16:40:47 -0400
Received: by mail-pf1-f196.google.com with SMTP id d25so6404469pfn.6
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 13:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qJJIJbYykf2eHlSy5B60H3/FaIsyaz1PfOiIJOMOPE8=;
        b=M7zDEUTXvKKhzjXXIL5sVT6tln/tu9kDTDeIVpZtVSZ+jr5G6s7ztjggNxAZye4mrq
         Wx0+/ihZ4I+6hAAl/9Pj9hzP/U+XNGZpohBY+FkfS8eLdbcH88K57CjYMR7VNBvyCIWI
         yd/J7mmygT+LG9cyLAdseBAv4iA1L/uJdZgww=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qJJIJbYykf2eHlSy5B60H3/FaIsyaz1PfOiIJOMOPE8=;
        b=k/je+Dx8LbgBfdhxmTNSx0pRtmGjUUTJlN8TN8QjjXNI5ukdPi2gGVd0A2orsTUc83
         iJbBSkIL3OBMHd30O0JN9tFjMMq9mcs6NVtaUtnlFzktB5waolObWwdD4n+TUjHW1qRA
         zUDng3DZ7W1y1XhOBKawGepkFGj48bUHoxccIuJ2Qt4KSS9QhL4gul5KCE1RwgeJfg6u
         p0d8sd6NY9e0tkikri6JnDN1wp/OnmulwWJUANeWIIEQfM73qSb8LYuOKZqgWyY9kYlD
         TO01OTnXSc4pmJmJfdFIrXoeciCajra3+E6/FvwOeCFqYrQyl/V1IluIETSc0uqCHbJ5
         DEGQ==
X-Gm-Message-State: ANhLgQ29gFDZWcHGeSe3KWSNaBAgmz+MP43G+lpyFeKUpWLV4aqb8kCp
        RyaMXLc489xrPXQbYO183c/p8HKEE+c=
X-Google-Smtp-Source: ADFU+vvS7wIJ1S28avU0NKSLn7HHjwdeFwLoHRkXBiJYIQGnO69ce9+/gk5uaNqhQEFl6euvFAfA+A==
X-Received: by 2002:a63:cb4a:: with SMTP id m10mr18816271pgi.259.1584909645974;
        Sun, 22 Mar 2020 13:40:45 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y131sm11575843pfb.78.2020.03.22.13.40.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Mar 2020 13:40:45 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 5/5] bnxt_en: Reset rings if ring reservation fails during open()
Date:   Sun, 22 Mar 2020 16:40:05 -0400
Message-Id: <1584909605-19161-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584909605-19161-1-git-send-email-michael.chan@broadcom.com>
References: <1584909605-19161-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

If ring counts are not reset when ring reservation fails,
bnxt_init_dflt_ring_mode() will not be called again to reinitialise
IRQs when open() is called and results in system crash as napi will
also be not initialised. This patch fixes it by resetting the ring
counts.

Fixes: 47558acd56a7 ("bnxt_en: Reserve rings at driver open if none was reserved at probe time.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 95f4c02..d28b406 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11677,6 +11677,10 @@ static int bnxt_set_dflt_rings(struct bnxt *bp, bool sh)
 		bp->rx_nr_rings++;
 		bp->cp_nr_rings++;
 	}
+	if (rc) {
+		bp->tx_nr_rings = 0;
+		bp->rx_nr_rings = 0;
+	}
 	return rc;
 }
 
-- 
2.5.1

