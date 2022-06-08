Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E289F54305B
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239071AbiFHMap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239039AbiFHMal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:30:41 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DD5259F66
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 05:30:38 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z7so26840039edm.13
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 05:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PFilY46P21Qfg+IkRYFCHPWYKejEm8juXWh14hB/0zc=;
        b=hIkFM4A37sx1XaVyMDrD3OHHwE0qCBFXY0eH7X1JGxwWNqLsocVAx4z4O6kMUfXPwK
         qkiIwOTRWu1/4I459DVrhKwsQdmrsjonqi6s11KKRn4SPJOh9XCq+oJBZkrcVXEVu4Gj
         8XNaDIfycsoGlatqOApzA4JrS1InDCyrmCJ9SO5hAGBAiDUAXuIA2V0cWs4taXCpf9Dq
         tnPX0t4NweVJ0TxARgVLexM/T22v/RyOer0dctc3GgCzLdoEgbHzdhM2Mb5Fcz9CBFrh
         kPUDMBTTXCaeQwk91GRELWjvlcw/xf7/zQ33xcSYjKtUIF8iJZJiAztbqi/IFpIi0UQy
         A5Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PFilY46P21Qfg+IkRYFCHPWYKejEm8juXWh14hB/0zc=;
        b=PH692SBnNxwf905DuUQxHXuZ41LljD+G6x0RMf1m1ws8Db/vrSyeMUXBEUhQLzzEFj
         owp/gkiW7ho7NnFxLWTbk6EFjUO855nnUwOy3uEdcla3LcUXedXL2KiBTXw1Md37BQsM
         La4LBQv5/kBr0f2PdG2fUos200pRH85U7ZAA6SQ8S06lrjT17N4bmfOO+7Gsdnjgmwdl
         JhvjeDIJu9KGkwyXwQwOdWmcZi3Hx7FDRNp9Ra2OK+FltPAcfxQT7kUJP0u+0ccBqkO0
         tMikWkYGOvls8OE5F+OV8mPA3j7EfLOMqyvtRRKGtc/Ldlnn/z9hIE+QV05zGq/Vwfa8
         aUqw==
X-Gm-Message-State: AOAM533JeBk/8RjE0yQDMCfCEWKPG09F6jMfSdn/eVabxLJ3V0qTQGT0
        Uaw78ihh3NH1Hx5fvtsxUXm954BKNcy1Fvm7
X-Google-Smtp-Source: ABdhPJydgtAveUPyCW6d+4e7jsDGhkZ1i7CZp4d92gDx8j+ij8pDNzJLlgO7MjEJnW+BbS5S9HI+wA==
X-Received: by 2002:a05:6402:4408:b0:42d:dc8d:a081 with SMTP id y8-20020a056402440800b0042ddc8da081mr39076695eda.69.1654691436675;
        Wed, 08 Jun 2022 05:30:36 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id o7-20020a50fd87000000b0042dc25fdf5bsm12161687edt.29.2022.06.08.05.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 05:30:36 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, roopa@nvidia.com,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH iproute2-next 02/10] bridge: fdb: add flush vlan matching
Date:   Wed,  8 Jun 2022 15:29:13 +0300
Message-Id: <20220608122921.3962382-3-razor@blackwall.org>
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

Add flush support to match fdb entries in a specific vlan.
Example:
$ bridge fdb flush dev swp1 vlan 10 master
This will flush all fdb entries with port swp1 and vlan 10.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 bridge/fdb.c      | 15 ++++++++++++++-
 man/man8/bridge.8 |  7 +++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/bridge/fdb.c b/bridge/fdb.c
index ac9f7af64336..c2a1fb957f7e 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -45,7 +45,7 @@ static void usage(void)
 		"              [ state STATE ] [ dynamic ] ]\n"
 		"       bridge fdb get [ to ] LLADDR [ br BRDEV ] { brport | dev } DEV\n"
 		"              [ vlan VID ] [ vni VNI ] [ self ] [ master ] [ dynamic ]\n"
-		"       bridge fdb flush dev DEV [ self ] [ master ]\n");
+		"       bridge fdb flush dev DEV [ vlan VID ] [ self ] [ master ]\n");
 	exit(-1);
 }
 
@@ -681,6 +681,7 @@ static int fdb_flush(int argc, char **argv)
 	};
 	unsigned short ndm_flags = 0;
 	char *d = NULL;
+	short vid = -1;
 
 	while (argc > 0) {
 		if (strcmp(*argv, "dev") == 0) {
@@ -690,6 +691,11 @@ static int fdb_flush(int argc, char **argv)
 			ndm_flags |= NTF_MASTER;
 		} else if (strcmp(*argv, "self") == 0) {
 			ndm_flags |= NTF_SELF;
+		} else if (strcmp(*argv, "vlan") == 0) {
+			if (vid >= 0)
+				duparg2("vlan", *argv);
+			NEXT_ARG();
+			vid = atoi(*argv);
 		} else {
 			if (strcmp(*argv, "help") == 0)
 				NEXT_ARG();
@@ -708,11 +714,18 @@ static int fdb_flush(int argc, char **argv)
 		return -1;
 	}
 
+	if (vid >= 4096) {
+		fprintf(stderr, "Invalid VLAN ID \"%hu\"\n", vid);
+		return -1;
+	}
+
 	/* if self and master were not specified assume self */
 	if (!(ndm_flags & (NTF_SELF | NTF_MASTER)))
 		ndm_flags |= NTF_SELF;
 
 	req.ndm.ndm_flags = ndm_flags;
+	if (vid > -1)
+		addattr16(&req.n, sizeof(req), NDA_VLAN, vid);
 
 	if (rtnl_talk(&rth, &req.n, NULL) < 0)
 		return -1;
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index bfda9f7ecd7b..d5db85b943bd 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -116,6 +116,8 @@ bridge \- show / manipulate bridge addresses and devices
 .BR "bridge fdb flush"
 .B dev
 .IR DEV " [ "
+.B vlan
+.IR VID " ] [ "
 .BR self " ] [ " master " ]"
 
 .ti -8
@@ -799,6 +801,11 @@ the target device for the operation. If the device is a bridge port and "master"
 is set then the operation will be fulfilled by its master device's driver and
 all entries pointing to that port will be deleted.
 
+.TP
+.BI vlan " VID"
+the target VLAN ID for the operation. Match forwarding table entries only with the
+specified VLAN ID.
+
 .TP
 .B self
 the operation is fulfilled directly by the driver for the specified network
-- 
2.35.1

