Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753E43B5027
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 22:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhFZVAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 17:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbhFZVAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 17:00:20 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E795C061574;
        Sat, 26 Jun 2021 13:57:57 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id u190so11486274pgd.8;
        Sat, 26 Jun 2021 13:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kL8a5X8847gaiK8cm1v6YoBD+G5PGJOSZdwZTVAMOac=;
        b=Im8KCO09dnHkgi6D5ICIB9NGGQaLMkJx9+10Ko9+HHPEyCs3qx2WbDkz0qKxy8Xk7R
         ASslWM2cLEkC61O8gX7XU8LAwNF123aZC5/0XhhSalv8d3kISNUctvRH/K5k8N1j5gO7
         HRZ+kcPdf43jU+XNN9SKvfxMUHRY2Z8NYS1RnmJDwRYQ/+GNXnaPNratj48K0apw1jr5
         PUuqamElD7ioHzOc8gBvYykv64AjvnC5DClNJGa2hSaAm3Zx9XVQE1DbW56JIIPWicH/
         kPmIMmDr1FSNxeh8lZNaYQ+UoyZQiojsPGnswtwgiOmIRGMeFRCGfBystTaAZ+xr06Ea
         258w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kL8a5X8847gaiK8cm1v6YoBD+G5PGJOSZdwZTVAMOac=;
        b=QH7Xx6I//BuCmuSofVoEX+FVO/3OHPmxBfIR7w6rI/Q31CV7SIGCN8FQOS1cHj9p4I
         aI5+gHjvpBYSAqhqsI/2r6Qln6RBSe5jRnTmM2Dka2vVXEwCbhgL5BJYGthl88r+Nmaj
         X6db+5lIRMBRPV6wiUpiJMLhP1g4ZK6v1w9kHzSEOw+MSF8ctzmwSwUGWCcx6NB166Lk
         LtH2fMylyxqCs6LU2vnykzWajv5XqGoKhBu8/d5VO/XtB5DHJdTiJ5V+2O6luQWIx5/T
         oW6V+VMm9sQgwQowwc6R27fUnF2ukHZwJPIDMPFa055Bia2G1FNLLWgSqDcb+8HRv+0t
         PQaQ==
X-Gm-Message-State: AOAM532NGmO/17kwq4Z1DbYJcsFRBJwksxexSFczluJn7UQ612sV8HdT
        WUtdc5cU+27nEDn3KX2hQTF+/iGP6ZttNXb9Uio=
X-Google-Smtp-Source: ABdhPJz8gtEda/evPb5lW8OwWUD9DR8xplBbIiB6agd+6iY32dPxGWzlsjWgiVAmxYAhrQgLhGwoMw==
X-Received: by 2002:a62:ea18:0:b029:307:6f4:ee98 with SMTP id t24-20020a62ea180000b029030706f4ee98mr17054720pfh.29.1624741076276;
        Sat, 26 Jun 2021 13:57:56 -0700 (PDT)
Received: from pn-hyperv.lan (bb42-60-144-185.singnet.com.sg. [42.60.144.185])
        by smtp.gmail.com with ESMTPSA id e1sm9616539pfd.16.2021.06.26.13.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jun 2021 13:57:55 -0700 (PDT)
From:   Nguyen Dinh Phi <phind.uet@gmail.com>
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH] Fix possible memory leak in function cfg80211_bss_update
Date:   Sun, 27 Jun 2021 04:57:51 +0800
Message-Id: <20210626205751.454201-1-phind.uet@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we exceed the limit of BSS entries, this function will free the
new entry, however, at this time, it is the last door to access the
inputed ies, so these ies will be unreferenced objects and cause memory
leak.
Therefore we should free its ies before deallocating the new entry, beside
of dropping it from hidden_list.
These stuffs could be done by using bss_free function.

Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
---
 net/wireless/scan.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index f03c7ac8e184..b5f62bbe539a 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1761,9 +1761,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 
 		if (rdev->bss_entries >= bss_entries_limit &&
 		    !cfg80211_bss_expire_oldest(rdev)) {
-			if (!list_empty(&new->hidden_list))
-				list_del(&new->hidden_list);
-			kfree(new);
+			bss_free(new);
 			goto drop;
 		}
 
-- 
2.25.1

