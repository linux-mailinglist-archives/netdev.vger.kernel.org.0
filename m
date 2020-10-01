Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6792803D0
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 18:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732741AbgJAQXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 12:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732610AbgJAQXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 12:23:04 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83152C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 09:23:04 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id kk9so2147074pjb.2
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 09:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lQuZaRuWzexgVjSPkkZVKzzUtaieAt/b44l3FnkLuMo=;
        b=TufSgKoN31i8umHCwdzbcwpYs69igEZc9iBIzTIIZ4IburaqEytHaCmtdOgPdW63r/
         GL/dXZoqVVJ0Y0LqBAW7R5Nz1JhL3ngRaHsfB21otKYfRsZLJwkwdZwjWLoJrmCsaZ3t
         7yxxSd4PA7pT/ubn4+vyp8+FHe52maZT/eTeizwn00LzJJxQite58bzsen8fx1bRD0Zg
         UcIibiKBx14DvC5pDc7tsB97vzli3oqnIg8o/S+98cSuQ+mKbddpsNJdJSyqKYbt9kYP
         IZJhs038LmCzB5uTivt/j0cA3PLYm3dnpg7d2zFVtZ+UoZF4EmmRghan2B0V8iSBDUVT
         g0rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lQuZaRuWzexgVjSPkkZVKzzUtaieAt/b44l3FnkLuMo=;
        b=KJjolTOCeljvoV7mL1o9WMgGpA1fm6mbajCnxW4u7mlWOOmojM9f0QvV76W2Kk8Z0j
         m1Gnl8kp1JKNnK0IMxsCFH5pJa6x2X2EIaBN4V2+O0tzJC/Iw+ngHjfTYbMizbC31i1d
         yo/daIqZR8Yg8QJTmminVYywY+yhYaQ8vCAiZ4uTWfaPpxTajHPkqLFGV9RtFFh3h3Dn
         s89ISBnPWA8Oc7915MCAdd3qDIONM/GkhbivKlIkGLdXjCtcxv52Mi2QBOX7WBhwFoHT
         h3YcrKuSggDySifg3zLmjLZjOAekceZa3Cr1pCnn8+C1DnREvkBZqwc518fh1ZojkIBy
         +Evg==
X-Gm-Message-State: AOAM5301TCQr72Y0v1QcJ7df6bzrPJkB24e64AKoo6E45wzcxSlKf7Rd
        IliSjd1cVBx4I0e24ZV7WzNMDzhHDvbWRg==
X-Google-Smtp-Source: ABdhPJz9IJi1q1g8ZAvUoIkzh9DPiAl5j5fJX9eSNqSKtgrEEM5ymiwk+chLjYQD7ah+C5wNGXQN5g==
X-Received: by 2002:a17:90a:6685:: with SMTP id m5mr658826pjj.235.1601569383802;
        Thu, 01 Oct 2020 09:23:03 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k2sm6380066pfi.169.2020.10.01.09.23.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Oct 2020 09:23:03 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 8/8] ionic: add new bad firmware error code
Date:   Thu,  1 Oct 2020 09:22:46 -0700
Message-Id: <20201001162246.18508-9-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001162246.18508-1-snelson@pensando.io>
References: <20201001162246.18508-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the new firmware image downladed for update is corrupted
or is a bad format, the download process will report a status
code specifically for that.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_if.h   | 1 +
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index 5bb56a27a50d..31ccfcdc2b0a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -96,6 +96,7 @@ enum ionic_status_code {
 	IONIC_RC_ERROR		= 29,	/* Generic error */
 	IONIC_RC_ERDMA		= 30,	/* Generic RDMA error */
 	IONIC_RC_EVFID		= 31,	/* VF ID does not exist */
+	IONIC_RC_EBAD_FW	= 32,	/* FW file is invalid or corrupted */
 };
 
 enum ionic_notifyq_opcode {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index c21195be59e1..ee0740881af3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -64,6 +64,8 @@ static const char *ionic_error_to_str(enum ionic_status_code code)
 		return "IONIC_RC_ERROR";
 	case IONIC_RC_ERDMA:
 		return "IONIC_RC_ERDMA";
+	case IONIC_RC_EBAD_FW:
+		return "IONIC_RC_EBAD_FW";
 	default:
 		return "IONIC_RC_UNKNOWN";
 	}
-- 
2.17.1

