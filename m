Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41E6A14039B
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 06:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgAQFdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 00:33:13 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41998 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgAQFdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 00:33:12 -0500
Received: by mail-pf1-f194.google.com with SMTP id 4so11393098pfz.9
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 21:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YJeICOD8dlLE2gkck/ToRmWKUMwRJMDAFfxQTccIbCw=;
        b=fdjZ/UAUeTUl4XKZkgTJGvrAhfYZMjSLnDk2vLUlDHkSa+t7UBAA1z2sSeKQSjGwYU
         P8k6V0Ke+CTbdCaaOr9gRm7xFpXJ+Fje8dwqBrmd4R6am4S5jWPHxAW/dhaaIlrQLV+1
         g5hJ7QpajUnNqLsH89xqrqJ7N43d1/9T+kkaw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YJeICOD8dlLE2gkck/ToRmWKUMwRJMDAFfxQTccIbCw=;
        b=gWO/7adoM84ruhFKY1zg8tmoQ1kpBFiyBMN9UJC7RCg1BcU21sGZUfOFNvTcJd7eio
         hqW86eX19MGobcU1Rm5j+Hc/CIAGrvgBwOFpgMbAfPvryrqX4QhmEQhciNf6Z0B5BX3i
         M/AOCAEBlxmqmoRYQ756MPBG1LrhTOvqAroKmx6IoLnu7oKvM78g6MPiMx8Y7ernEM//
         l9gPoMHVjUx7n4rt92MCj/WMiiWiPRKdj+nWE2YDOB34fjw3NrQk+TybBxkitjrDZwHq
         trD27bByR6TIRtAawttjtOAcmeKkL52HwGsmeLfkIdgif8qXVB+BHvOj1N2a8N3yYSSI
         pE5Q==
X-Gm-Message-State: APjAAAWSmZi62AeqaXieBgGJs6rbx8RLmlAB75NK2ibmhzUFu3dCtevJ
        RA6Il3qRZjHqel5y44AwdNAC2DL9ASY=
X-Google-Smtp-Source: APXvYqwzuYkdcQpObMIzWwEClm+u3h+P+8CMqD/A+vNcTCk0b0wdxS1ihdaAmadnSBWRcYSCtud7Bw==
X-Received: by 2002:a62:7683:: with SMTP id r125mr1300024pfc.132.1579239191389;
        Thu, 16 Jan 2020 21:33:11 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c188sm1357142pga.83.2020.01.16.21.33.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jan 2020 21:33:11 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 1/3] bnxt_en: Fix NTUPLE firmware command failures.
Date:   Fri, 17 Jan 2020 00:32:45 -0500
Message-Id: <1579239167-16362-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1579239167-16362-1-git-send-email-michael.chan@broadcom.com>
References: <1579239167-16362-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NTUPLE related firmware commands are sent to the wrong firmware
channel, causing all these commands to fail on new firmware that
supports the new firmware channel.  Fix it by excluding the 3
NTUPLE firmware commands from the list for the new firmware channel.

Fixes: 760b6d33410c ("bnxt_en: Add support for 2nd firmware message channel.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 505af5c..85af7cf 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1936,9 +1936,6 @@ static inline bool bnxt_cfa_hwrm_message(u16 req_type)
 	case HWRM_CFA_ENCAP_RECORD_FREE:
 	case HWRM_CFA_DECAP_FILTER_ALLOC:
 	case HWRM_CFA_DECAP_FILTER_FREE:
-	case HWRM_CFA_NTUPLE_FILTER_ALLOC:
-	case HWRM_CFA_NTUPLE_FILTER_FREE:
-	case HWRM_CFA_NTUPLE_FILTER_CFG:
 	case HWRM_CFA_EM_FLOW_ALLOC:
 	case HWRM_CFA_EM_FLOW_FREE:
 	case HWRM_CFA_EM_FLOW_CFG:
-- 
2.5.1

