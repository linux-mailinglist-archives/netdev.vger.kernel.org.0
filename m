Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B518454305D
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239086AbiFHMau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239052AbiFHMam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:30:42 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64619BF78
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 05:30:39 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id u12so41167218eja.8
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 05:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ev2+iOJoaKnXpiPEDPTGzN3dyYsPITLJRElMtt1I5ag=;
        b=q91uMYrLsKkBwUt+e2No6a8xqcMiIj6IguXDMeiPOg0w2ZxPPcS3/4KSeXZlQxh3gV
         CK82M3m6Fs75A94XZZYd6VVOOWEza4Yd5KQXtgl8UACE5RPmqGFlskWxjVVvIDsuGcCs
         ah4Yy4zkWZi2lV+8mFw6uft37q8OHDmn3UNysU3UC9QwB7Z0TNKCv0zPHT2IeuwFYrkl
         tIJl0HnoSMa94gH3+YI5MWQG3bX8kJmmEUKNwSz9tJfwUtuQut3JDSHdRKJ/FZNHOjr8
         A3v6MlI7ntUUdgauaVz4QNgaDpr/s4kpsWc6Q3CaeNYXa6px0XRnuoa5jti/QWrg9bS9
         ARlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ev2+iOJoaKnXpiPEDPTGzN3dyYsPITLJRElMtt1I5ag=;
        b=0fKV8cRjJC+7lhb9vLTF4MnfLvzPgW1eTFdHGzhTqA25tHnaLtdg/gU9OdF0YuCrGh
         o98lxjul+0bSuLOS1/QCpyqBnUAnPb0xHio6zEJaFxcZQGjUkyThooCdeiGaaakUC0QW
         Jj6wVD/xKLDCdAcwq1eM4rEeypIYZwf06R1AFsIwolCyX2jURz45Ford+IArpSwtlpGP
         iLzpYatMGaW80qh7uKo7y1OG7cm5kz7UFcSwwkjvSQL46vbMUyVfTaw5AFj2pE1UPWl2
         u1LObI8OM0SdBm3ThRYXM7ulBiF39Gogx682a4/vlqLd5YSAc6bc0fVpIYJUYAvikmhN
         X/bA==
X-Gm-Message-State: AOAM533wFe9ZnQdWqZtQlUxkTewOHJddO9B/Kpxkv4Bm6di03j20pO71
        A4A/MWZMHbXgV/2y/yuMXFE7QK4IMP6bdLyE
X-Google-Smtp-Source: ABdhPJwOaL23IaHgLus6mbeK1Ub6X2gH90jMiVq7SWH3V42QlhwAGkQbCuGrnE4wdyoHSpLMc36HaA==
X-Received: by 2002:a17:906:685:b0:6fa:8e17:e9b5 with SMTP id u5-20020a170906068500b006fa8e17e9b5mr32980668ejb.522.1654691437658;
        Wed, 08 Jun 2022 05:30:37 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id o7-20020a50fd87000000b0042dc25fdf5bsm12161687edt.29.2022.06.08.05.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 05:30:37 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, roopa@nvidia.com,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH iproute2-next 03/10] bridge: fdb: add flush port matching
Date:   Wed,  8 Jun 2022 15:29:14 +0300
Message-Id: <20220608122921.3962382-4-razor@blackwall.org>
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

Usually we match on the device specified after "dev" but there are
special cases where we need an additional device attribute for matching
such as when matching entries specifically pointing to the bridge device
itself. We use NDA_IFINDEX for that purpose.

Example:
$ bridge fdb flush dev br0 brport br0
This will flush only entries pointing to the bridge itself.

$ bridge fdb flush dev swp1 brport swp2 master
Note this will flush entries pointing to swp2 only. The NDA_IFINDEX
attribute overrides the dev argument. This is documented in the man
page.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 bridge/fdb.c      | 23 ++++++++++++++++++++---
 man/man8/bridge.8 |  8 ++++++++
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/bridge/fdb.c b/bridge/fdb.c
index c2a1fb957f7e..4af13eb20dc5 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -45,7 +45,8 @@ static void usage(void)
 		"              [ state STATE ] [ dynamic ] ]\n"
 		"       bridge fdb get [ to ] LLADDR [ br BRDEV ] { brport | dev } DEV\n"
 		"              [ vlan VID ] [ vni VNI ] [ self ] [ master ] [ dynamic ]\n"
-		"       bridge fdb flush dev DEV [ vlan VID ] [ self ] [ master ]\n");
+		"       bridge fdb flush dev DEV [ brport DEV ] [ vlan VID ]\n"
+		"              [ self ] [ master ]\n");
 	exit(-1);
 }
 
@@ -679,9 +680,9 @@ static int fdb_flush(int argc, char **argv)
 		.n.nlmsg_type = RTM_DELNEIGH,
 		.ndm.ndm_family = PF_BRIDGE,
 	};
+	short vid = -1, port_ifidx = -1;
 	unsigned short ndm_flags = 0;
-	char *d = NULL;
-	short vid = -1;
+	char *d = NULL, *port = NULL;
 
 	while (argc > 0) {
 		if (strcmp(*argv, "dev") == 0) {
@@ -691,6 +692,11 @@ static int fdb_flush(int argc, char **argv)
 			ndm_flags |= NTF_MASTER;
 		} else if (strcmp(*argv, "self") == 0) {
 			ndm_flags |= NTF_SELF;
+		} else if (strcmp(*argv, "brport") == 0) {
+			if (port)
+				duparg2("brport", *argv);
+			NEXT_ARG();
+			port = *argv;
 		} else if (strcmp(*argv, "vlan") == 0) {
 			if (vid >= 0)
 				duparg2("vlan", *argv);
@@ -714,6 +720,15 @@ static int fdb_flush(int argc, char **argv)
 		return -1;
 	}
 
+	if (port) {
+		port_ifidx = ll_name_to_index(port);
+		if (port_ifidx == 0) {
+			fprintf(stderr, "Cannot find bridge port device \"%s\"\n",
+				port);
+			return -1;
+		}
+	}
+
 	if (vid >= 4096) {
 		fprintf(stderr, "Invalid VLAN ID \"%hu\"\n", vid);
 		return -1;
@@ -724,6 +739,8 @@ static int fdb_flush(int argc, char **argv)
 		ndm_flags |= NTF_SELF;
 
 	req.ndm.ndm_flags = ndm_flags;
+	if (port_ifidx > -1)
+		addattr32(&req.n, sizeof(req), NDA_IFINDEX, port_ifidx);
 	if (vid > -1)
 		addattr16(&req.n, sizeof(req), NDA_VLAN, vid);
 
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index d5db85b943bd..32b81b4bd4fe 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -116,6 +116,8 @@ bridge \- show / manipulate bridge addresses and devices
 .BR "bridge fdb flush"
 .B dev
 .IR DEV " [ "
+.B brport
+.IR DEV " ] [ "
 .B vlan
 .IR VID " ] [ "
 .BR self " ] [ " master " ]"
@@ -801,6 +803,12 @@ the target device for the operation. If the device is a bridge port and "master"
 is set then the operation will be fulfilled by its master device's driver and
 all entries pointing to that port will be deleted.
 
+.TP
+.BI brport " DEV"
+the target bridge port for the operation. If the bridge device is specified then only
+entries pointing to the bridge itself will be deleted. Note that the target device
+specified by this option will override the one specified by dev above.
+
 .TP
 .BI vlan " VID"
 the target VLAN ID for the operation. Match forwarding table entries only with the
-- 
2.35.1

