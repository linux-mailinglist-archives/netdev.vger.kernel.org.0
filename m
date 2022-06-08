Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A51954305C
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239078AbiFHMay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239067AbiFHMao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:30:44 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABF6258DD9
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 05:30:41 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id u12so41167461eja.8
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 05:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tLTWfIvEZ40lscWkCNUzGvIbWj1VyxcXotbQfRn3JYI=;
        b=T6b9Wk22xSEVtNx3VxKGw1NVrUhgBSbNOzNTtnpG9TPlKB9RFUR+/H8gvmzMy8UyBZ
         HP6ZQ4hySBy062r50sOC011NqU0kpa3HwQsUztmxk190I3W3nAn6pBlDsRZc+RwneUgZ
         LT9VtD6hjTzYlAi6BjnS4By+/Foun1j0CMUD4hofU5PJCjkL+EmfZmfOYQds6vyJMGrq
         Y3B9scoJ7ybpkpmIflV5tMuG7h34bGU8Bj6+9hoO7k1BKlyax5VVTD3eHMRlP0C4WkT2
         5taroJ9S/ODEwRZo+zJaFzZB5xoNxBMv2avQFPc4UcobMwYo4aLMUYizxNm5z1jUhYH4
         c2Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tLTWfIvEZ40lscWkCNUzGvIbWj1VyxcXotbQfRn3JYI=;
        b=50gMpEAkyokSZH749EqFG68V70F8dCwQpVxURd3cTqyb4XODP8wg5X3vhN9ds94UCr
         4Sbk5WktAR78XAQiK4J5gzPLi9aefXdGshOMSrBsfS5V86kZq6mk4BDkJdgQ3KNR2sED
         Ui9UBgc5sGFeETmX8t9QK2fMqW3NQyZEb5r1ylWlc59dn03QYTphx3n4SOG52nYLTs50
         gu5drTnbYxlm7Hxc0y5YCjepNwxhJSWRKUYAO1Baiw8Hvqr5STKQMFMzzVKOeLbv8nFe
         /HJra4z40Qx0BZjfqT0F7fayI2agnZAKDd/4wBgtuBlXDjhebuKqOhrtKAkDqnrY9J2U
         MPpw==
X-Gm-Message-State: AOAM530nADKa/EBB+++pTDdYfJ1aAstoHLHqnbOFPfjD0FDMd3Aq6Pku
        USHBcMMTv7tfiF3f4/gMQLrjLn0R/OiKxabd
X-Google-Smtp-Source: ABdhPJy1JtSmuhG5LIais2gm6a0ulDQ61P3xWODcPSq/4wVX9EV9n+qABquOBst8Y2IRXnXddQFKfg==
X-Received: by 2002:a17:906:a186:b0:6fe:8a06:849b with SMTP id s6-20020a170906a18600b006fe8a06849bmr30679479ejy.635.1654691440157;
        Wed, 08 Jun 2022 05:30:40 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id o7-20020a50fd87000000b0042dc25fdf5bsm12161687edt.29.2022.06.08.05.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 05:30:39 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, roopa@nvidia.com,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH iproute2-next 05/10] bridge: fdb: add flush [no]static entry matching
Date:   Wed,  8 Jun 2022 15:29:16 +0300
Message-Id: <20220608122921.3962382-6-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220608122921.3962382-1-razor@blackwall.org>
References: <20220608122921.3962382-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add flush support to match static or non-static entries if "no" is
prepended respectively. Note that static entries are only NUD_NOARP ones
without NUD_PERMANENT, also when matching non-static entries exclude
permanent entries as well (permanent entries by definition are also
static).

Examples:
$ bridge fdb flush dev br0 static
This will delete all static entries in br0's fdb table.

$ bridge fdb flush dev br0 nostatic
This will delete all entries except the static ones in br0's fdb
table.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 bridge/fdb.c      | 8 +++++++-
 man/man8/bridge.8 | 7 ++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/bridge/fdb.c b/bridge/fdb.c
index b1c516141750..93806d7d35b5 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -46,7 +46,7 @@ static void usage(void)
 		"       bridge fdb get [ to ] LLADDR [ br BRDEV ] { brport | dev } DEV\n"
 		"              [ vlan VID ] [ vni VNI ] [ self ] [ master ] [ dynamic ]\n"
 		"       bridge fdb flush dev DEV [ brport DEV ] [ vlan VID ]\n"
-		"              [ self ] [ master ] [ [no]permanent ]\n");
+		"              [ self ] [ master ] [ [no]permanent | [no]static ]\n");
 	exit(-1);
 }
 
@@ -700,6 +700,12 @@ static int fdb_flush(int argc, char **argv)
 		} else if (strcmp(*argv, "nopermanent") == 0) {
 			ndm_state &= ~NUD_PERMANENT;
 			ndm_state_mask |= NUD_PERMANENT;
+		} else if (strcmp(*argv, "static") == 0) {
+			ndm_state |= NUD_NOARP;
+			ndm_state_mask |= NUD_NOARP | NUD_PERMANENT;
+		} else if (strcmp(*argv, "nostatic") == 0) {
+			ndm_state &= ~NUD_NOARP;
+			ndm_state_mask |= NUD_NOARP;
 		} else if (strcmp(*argv, "brport") == 0) {
 			if (port)
 				duparg2("brport", *argv);
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 9dcd1f0a613f..9e2952b8c6d6 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -121,7 +121,7 @@ bridge \- show / manipulate bridge addresses and devices
 .B vlan
 .IR VID " ] [ "
 .BR self " ] [ " master " ] [ "
-.BR [no]permanent " ]"
+.BR [no]permanent " | " [no]static " ]"
 
 .ti -8
 .BR "bridge mdb" " { " add " | " del " } "
@@ -833,6 +833,11 @@ such as a bridge, the operation is fulfilled by the master device's driver.
 .B [no]permanent
 if specified then only permanent entries will be deleted or respectively if "no"
 is prepended then only non-permanent entries will be deleted.
+
+.TP
+.B [no]static
+if specified then only static entries will be deleted or respectively if "no"
+is prepended then only non-static entries will be deleted.
 .sp
 
 .SH bridge mdb - multicast group database management
-- 
2.35.1

