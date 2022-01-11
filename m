Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F94348B4A8
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344874AbiAKRyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344887AbiAKRyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:54:47 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDC1C06173F
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:47 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id t18so8862617plg.9
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OiqrohovM9zfns0nWKmPYHs0XGQKbvGE6s/wwEeSu40=;
        b=si0ZRhnaxHadh84EjFcDgnhI2iYwvd5CVG0DRShjMNfaonPqHOkE4zpjzAI81tAoAy
         YfrdJPu98XSuOYC2MxsLxgS9Ev59nmrv0CwDlQe27pDsHZtLc+BPON7zDrMPM99+v3Sy
         TdkAwHRvwfC3K/7101LWjXqNp1DJdqvfMyH/qSbZ2S6Cee+PfljiII/+Uq2tHBW+oo+o
         vchPjmKNcRols5wRRr9bFbOkwoR/zqDmQR3kGE2WzrgFWIztr933ibXKeJlFeQM+sh4u
         71l7SyZS/J8R7kyVGwKLyDmJ5szd4gPNZZPDZLWKn8r9TVI57RqMELinnmVOOS9epm49
         CIug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OiqrohovM9zfns0nWKmPYHs0XGQKbvGE6s/wwEeSu40=;
        b=BG1KUEtzP1rK05NM7NQ6qgy509wZn6urBh0fHXIzyi5EVe47t2PbiF6kw1yIeVZdZc
         g9LKFY1bRB7NPk30feTuef1V2f9JZso8zXzLR6b41Z9qgNG9EQqOHf4XJsJe1dw5vjcT
         3GEA1NIvUNPFAeLZw4BiMO+rseJ15DBoRLdqSMtusOHMQMaB3kafFzWLH/iaCBHALtZn
         q+zoD8W9eAXQYpvneFe+I6Y8dtlxlu5yf9RKXTCp+pDF9bE5EhlI6WfSexZhe2AG0Q3P
         F7+SLFv+iQx+wIugSgJnyT5/81tbUv6H9CBN0SGmas5bjB7yUeogceaPbgDNx1FBdw04
         bT/w==
X-Gm-Message-State: AOAM533KE6T0sMEj7IM35Ek61I7IAdzRgeIL5th1RaFkE2IdEMn2VVv1
        azal369wEJdPyfc1i6yoLfMnrGSxpfj3nA==
X-Google-Smtp-Source: ABdhPJw2q+10dTVAttRGZmS2BDOtGzrbXE+8amf5se3safuNScoDDORTgRkl0lLNJ1FKlbHIAJtjgg==
X-Received: by 2002:a63:7f53:: with SMTP id p19mr2900796pgn.321.1641923686503;
        Tue, 11 Jan 2022 09:54:46 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id f8sm23925pga.69.2022.01.11.09.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 09:54:46 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>, elibr@mellanox.com,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2-next 05/11] tc_util: fix clang warning in print_masked_type
Date:   Tue, 11 Jan 2022 09:54:32 -0800
Message-Id: <20220111175438.21901-6-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220111175438.21901-1-sthemmin@microsoft.com>
References: <20220111175438.21901-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang complains about passing a non-format string but the code here.
The old code was doing extra work the JSON case. JSON ignores one line mode.
This also fixes output format in oneline mode.

Fixes: 04b215015ba8 ("tc_util: introduce a function to print JSON/non-JSON masked numbers")
Cc: elibr@mellanox.com
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/tc_util.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index 6d5eb754831a..67960d2c03d7 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -783,7 +783,6 @@ static void print_masked_type(__u32 type_max,
 			      const char *name, struct rtattr *attr,
 			      struct rtattr *mask_attr, bool newline)
 {
-	SPRINT_BUF(namefrm);
 	__u32 value, mask;
 	SPRINT_BUF(out);
 	size_t done;
@@ -795,26 +794,20 @@ static void print_masked_type(__u32 type_max,
 	mask = mask_attr ? rta_getattr_type(mask_attr) : type_max;
 
 	if (is_json_context()) {
-		sprintf(namefrm, "\n  %s %%u", name);
-		print_hu(PRINT_ANY, name, namefrm,
-			 rta_getattr_type(attr));
+		print_hu(PRINT_JSON, name, NULL, value);
 		if (mask != type_max) {
 			char mask_name[SPRINT_BSIZE-6];
 
 			sprintf(mask_name, "%s_mask", name);
-			if (newline)
-				print_string(PRINT_FP, NULL, "%s ", _SL_);
-			sprintf(namefrm, " %s %%u", mask_name);
-			print_hu(PRINT_ANY, mask_name, namefrm, mask);
+			print_hu(PRINT_JSON, mask_name, NULL, mask);
 		}
 	} else {
 		done = sprintf(out, "%u", value);
 		if (mask != type_max)
 			sprintf(out + done, "/0x%x", mask);
-		if (newline)
-			print_string(PRINT_FP, NULL, "%s ", _SL_);
-		sprintf(namefrm, " %s %%s", name);
-		print_string(PRINT_ANY, name, namefrm, out);
+
+		print_nl();
+		print_string_name_value(name, out);
 	}
 }
 
-- 
2.30.2

