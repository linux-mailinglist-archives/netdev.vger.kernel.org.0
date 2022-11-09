Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16187622BE5
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 13:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiKIMs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 07:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiKIMs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 07:48:56 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA7211C2E
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 04:48:54 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id 21so27100460edv.3
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 04:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oBGnP/tbHKsQAgy1tdyLh+W/jv119g4lzClzpaLwwp4=;
        b=5z3hMdBRZl0gDup3OoyOamN/yL1V7r8XklvgYfILYK7MrWJoOOmIHjxWAbPkDnIMUS
         kuJC16/JPCFPTdI18tjvQtWWH6IC1esdMiGPHYvORji1PWCvBcUejtxa2aOddHlxO5lj
         kZU/K7NAsZswVB+8UVV8P3dwsLZ0nsokrWfQSj8fvFosOwpPau3azZt25TWwvku9mDiw
         yjF2rv8R31av3wdPabtLrV8Q4wU8d4mKROiFrmDQgrFMAQDFlMgWQNnuMFaVhWT5FrH3
         QGT+gs3RaJYZt7zBhVoQQK5vYpcwt3X8u7EtKrVNH7U+CyE9ZIq9wC29EmRjj7vO3xkK
         hk5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oBGnP/tbHKsQAgy1tdyLh+W/jv119g4lzClzpaLwwp4=;
        b=nBP/kkGeYcte7pv0uy0grAes3+/DNgy1QTQJQkq7S2qzcklmYt9LSH7y4OU9yEpKOl
         GBqA7DMjD5PZE3xycVrUDVhb+5CyPB5ZjPFO9VCACA0iVOGzOUVdlwjNBsdHeKZz1xGT
         m9GAy6yBuNcSXzRn9U1LwN2UYD9eY+cQXSm+OtxOh0I1mW+3A+ytT1kwc4xAsqMGV8ds
         brPdfM6CACguQDFJu5IUlc++opnd3TOaRTjNo/azEWOJsPo7UD9QLrW2AguTUAwUUtmS
         suW4l7qZmRrqXccCSuX6aPfoluulITJOXvWE64pD1JCoLnpp5M69B+G4V1Aoy8VS5jMd
         9TxA==
X-Gm-Message-State: ACrzQf2GFjt0h0XDGdrW7p+iEH9okz1KguKVtmyHW+xZw/WdBmGJ4lhm
        diruLRbx3lAUyOx350ryRI88JheGDmqZGO/O
X-Google-Smtp-Source: AMsMyM5V90VIwsEkW2FbLIaS7c1a9irhuRLa7swp/5jKmQnxVrm8y3KnGhkRS56dEXskxB+PA/XRzw==
X-Received: by 2002:a05:6402:254f:b0:45d:3044:d679 with SMTP id l15-20020a056402254f00b0045d3044d679mr61250277edb.137.1667998132771;
        Wed, 09 Nov 2022 04:48:52 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j7-20020aa7de87000000b004617e880f52sm6838774edv.29.2022.11.09.04.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 04:48:52 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [patch iproute2] devlink: load ifname map on demand from ifname_map_rev_lookup() as well
Date:   Wed,  9 Nov 2022 13:48:51 +0100
Message-Id: <20221109124851.975716-1-jiri@resnulli.us>
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

