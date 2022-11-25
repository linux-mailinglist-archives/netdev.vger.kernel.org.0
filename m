Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3226385EB
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 10:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiKYJM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 04:12:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiKYJM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 04:12:57 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1C4F46
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 01:12:55 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id r9-20020a1c4409000000b003d02dd48c45so5368465wma.0
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 01:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oBGnP/tbHKsQAgy1tdyLh+W/jv119g4lzClzpaLwwp4=;
        b=7hr8eFwpQtLvey8dwbxkbs3xqCY1G9p2nYP5UxGuWKWhIWRsuw55nHIVawRl/y/Y0V
         kjdmkMm2CxaNaDMaBmkR30AhrGCFWheZPHBlBGx0FeCfgwVlSwY8j3eHEYmQXjqmZ8Y9
         Qa+WhPF4twge4VniAESTXw8PuwoQcY6xEcthUF3pv2HCWkpUNXcDRSEfqjM3/TKO/YV3
         2OkF7YGQPweSvY8yG6xHouOEwJd4pqaLTzBoEHGR+nboJ3BKbVLu2/bgsVUrmPMZPXn7
         kNOxQsWgf4kL5gNEV0O1nyniZZSTVG1/0fomc7lajoxrRiO0LnLFOHgKBAVf0J8c8mne
         Lbjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oBGnP/tbHKsQAgy1tdyLh+W/jv119g4lzClzpaLwwp4=;
        b=j9gQmtvwj+bis+r0iI0t8oQ8M2n5F8DwphOJrwtleuXVZI68gco17J4vz8rxlNrPI0
         TSjrbvG52rR4WRBEhF1i3hCFDK1nGuNrT/LmMPSb3z7wRGUZo/1aX4zr88iwwx7gvEmn
         ubtpt1snCbTTwbpCdxEnO/LtI2YQETZfuTWkZFflLDQ1PZYZxFuTnJzxjfKWKypqDHT2
         FOi/+U+9ju6J5fADhC8Em6txEgKPl6Fpd8E5Faf8h9GUdBRSH3hXLPGZePN25YOrtRYn
         +fN7nOawhIaJ8xH3NW+sOFT1v8/ty89gmk44F4qPKtKIUS/FnRB0xDwfp7MUAuvels6R
         4oEw==
X-Gm-Message-State: ANoB5plxZe6wOHbdoHJL5bhHEX3cB+JAjIdhV1aI1uNyckFYed7yjKRH
        RXJe55IAx3LVWdvNz3RaeJFYS2CWk36rWPmP
X-Google-Smtp-Source: AA0mqf478YiVyT71F6ZQeDi5KhnBAQNj0wBcRcLip2NAznXjON+bZin1jxTA5LW+cAV7pFAGwwOSGw==
X-Received: by 2002:a7b:cb97:0:b0:3cf:ac0d:3f80 with SMTP id m23-20020a7bcb97000000b003cfac0d3f80mr12734486wmi.185.1669367573770;
        Fri, 25 Nov 2022 01:12:53 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id z14-20020a7bc7ce000000b003cf78aafdd7sm4362701wmk.39.2022.11.25.01.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 01:12:53 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [patch iproute2-main REPOST] devlink: load ifname map on demand from ifname_map_rev_lookup() as well
Date:   Fri, 25 Nov 2022 10:12:51 +0100
Message-Id: <20221125091251.1782079-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Commit 5cddbb274eab ("devlink: load port-ifname map on demand") changed
the ifname map to be loaded on demand from ifname_map_lookup(). However,
it didn't put this on-demand loading into ifname_map_rev_lookup() which
causes ifname_map_rev_lookup() to return -ENOENT all the time.

Fix this by triggering on-demand ifname map load
from ifname_map_rev_lookup() as well.

Fixes: 5cddbb274eab ("devlink: load port-ifname map on demand")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 8aefa101b2f8..150b4e63ead1 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -838,6 +838,23 @@ static int ifname_map_load(struct dl *dl)
 	return 0;
 }
 
+static int ifname_map_check_load(struct dl *dl)
+{
+	int err;
+
+	if (dl->map_loaded)
+		return 0;
+
+	err = ifname_map_load(dl);
+	if (err) {
+		pr_err("Failed to create index map\n");
+		return err;
+	}
+	dl->map_loaded = true;
+	return 0;
+}
+
+
 static int ifname_map_lookup(struct dl *dl, const char *ifname,
 			     char **p_bus_name, char **p_dev_name,
 			     uint32_t *p_port_index)
@@ -845,14 +862,10 @@ static int ifname_map_lookup(struct dl *dl, const char *ifname,
 	struct ifname_map *ifname_map;
 	int err;
 
-	if (!dl->map_loaded) {
-		err = ifname_map_load(dl);
-		if (err) {
-			pr_err("Failed to create index map\n");
-			return err;
-		}
-		dl->map_loaded = true;
-	}
+	err = ifname_map_check_load(dl);
+	if (err)
+		return err;
+
 	list_for_each_entry(ifname_map, &dl->ifname_map_list, list) {
 		if (strcmp(ifname, ifname_map->ifname) == 0) {
 			*p_bus_name = ifname_map->bus_name;
@@ -870,6 +883,12 @@ static int ifname_map_rev_lookup(struct dl *dl, const char *bus_name,
 {
 	struct ifname_map *ifname_map;
 
+	int err;
+
+	err = ifname_map_check_load(dl);
+	if (err)
+		return err;
+
 	list_for_each_entry(ifname_map, &dl->ifname_map_list, list) {
 		if (strcmp(bus_name, ifname_map->bus_name) == 0 &&
 		    strcmp(dev_name, ifname_map->dev_name) == 0 &&
-- 
2.37.3

